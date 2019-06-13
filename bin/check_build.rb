`rm builds.log`
`rm builds-app.log`
app = ENV['APP']
commit = ENV['GIT_COMMIT']
branch = ENV['GIT_BRANCH'].gsub('origin/', '')
sha = commit[commit.length-8, commit.length]

puts "app: #{ app }"
puts "commit: #{ commit }"
cmd_str = "gcloud builds list --limit=10000 --page-size=10000 >> builds.log"
`#{ cmd_str }`


contents = File.read('./builds.log')
contents.split("\n").each do |line|
  if line.include? "#{ app }@#{ branch }"
    `echo "#{ line }" >> builds-app.log`
  end
end
`cat builds-app.log`

puts "Looking for COMMIT #{ sha } in Google Cloud Build"
puts "Building image."
build_id = nil
branch_found = false
complete_build = false
result = false

contents = File.read('./builds-app.log')
lines = contents.split("\n")
lines[0...3].each do |line|
  record = line.split(" ")
  record_result =  `gcloud builds describe #{ record[0] }`
  puts "checking #{ line }"
  if record_result.include?(sha)
    puts "Found the build"
    build_id = record[0]
    branch_found = true
  end
end

puts "Now we know the build id: #{ build_id } let's keep asking google if it's passed"
if branch_found == true
  
  while complete_build == false
    record_result =  `gcloud builds describe #{ build_id }`
    if record_result.include?(sha)    
      if record_result.include? "SUCCESS"
        puts "\n#{ commit } was a SUCCESS"
        result = 0
        complete_build = true
        exit(result)
      elsif record_result.include? "FAILURE"
        puts "\n#{ commit } was a FAILURE"
        result = 1
        complete_build = true
        exit(result)
      else
        print "."
        complete_build = false
      end
    end
  end
else
  puts "\n#{ commit } was not found in GOOGLE CLOUD BUILD"
  exit(1)
end
exit(result)

