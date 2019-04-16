`rm builds.log`
`gcloud builds list --limit=1000 --page-size=1000 >> builds.log`

contents = File.read('./builds.log')
commit = ENV['GIT_COMMIT']
sha = commit[commit.length-8, commit.length]
puts "Looking for COMMIT #{ sha } in Google Cloud Build"
puts "Building image."
complete_build = false
result = false
while complete_build == false
  lines = contents.split("\n")
  lines[1..3].each do |line|
    record = line.split(" ")
     
    record_result =  `gcloud builds describe #{ record[0] }`
    if record_result.include?(sha)
      if record_result.include? "SUCCESS"
        puts "\n#{ commit } was a SUCCESS"
        result = 0
        complete_build = true
        exit(result)
      elsif line.include? "FAILURE"
        puts "\n#{ commit } was a FAILURE"
        result = 1
        complete_build = true
        exit(result)
      else
        complete_build = false
      end
    end
  end
    
  unless complete_build == true
    `gcloud builds list >> builds.log`
    contents = File.read('./builds.log')
  end
  
  if complete_build == true
    break
  end
end

exit(result)
