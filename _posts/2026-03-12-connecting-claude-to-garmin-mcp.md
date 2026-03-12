---
layout: post
title: "I Gave Claude Access to My Garmin.  Now It Judges My Sleep."
excerpt: "I connected Claude Code to my Garmin watch via MCP and now I have an AI that reads my heart rate, judges my sleep, writes my fitness blog posts, and tells me to stop being lazy.  Here's exactly how to set it up."
date: "2026-03-12"
image: /assets/garmin-mcp-hero.png
---

![Illustration of a smartwatch with data streams flowing into a chat bubble](/assets/garmin-mcp-hero.png)

A few weeks ago I connected Claude Code to my Garmin watch.  Not through some janky script or a spreadsheet export, but through MCP.  Now when I ask Claude about my training, it pulls the data live from Garmin Connect.  Heart rate, sleep, training readiness, the lot.

It's changed how I think about my training.  And it took about five minutes to set up.

## What is MCP and Why It Matters

MCP (Model Context Protocol) is Anthropic's open standard for connecting AI to external services.  Instead of copying data out of an app and pasting it into a chat window, MCP lets Claude reach into the service directly and pull what it needs.  It's the difference between "here's a screenshot of my Garmin dashboard, what do you think?" and Claude just reading the data itself.

The reason this matters beyond Garmin is that MCP is how AI will interact with everything.  Right now there are MCP servers for GitHub, Slack, databases, file systems, calendars, and hundreds of other services.  Each one gives Claude a set of tools it can call.  The model decides which tools to use, in what order, and how to combine the results.  You describe what you want in plain English and the AI figures out the API calls.

This is a fundamental shift.  We've spent decades building interfaces so humans can interact with services.  MCP skips the interface entirely and lets AI talk to the service's API on your behalf.  The Garmin MCP server is just one example, but it's a good one because the data is rich, personal, and immediately useful.

## Setting It Up

You'll need [uv](https://docs.astral.sh/uv/) installed (it ships with `uvx`, which handles the MCP server installation automatically).

The Garmin MCP server is an open-source project that wraps the Garmin Connect API into tools that Claude can call.  It lives at [github.com/Taxuspt/garmin_mcp](https://github.com/Taxuspt/garmin_mcp) and exposes over 100 commands covering activities, health metrics, sleep, stress, body composition, workouts, nutrition, and more.

### 1. Add to Claude Code

```bash
claude mcp add garmin -- uvx --python 3.12 --from git+https://github.com/Taxuspt/garmin_mcp garmin-mcp
```

Or add it manually to your settings (`.claude.json`):

```json
{
  "mcpServers": {
    "garmin": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "--python", "3.12",
        "--from", "git+https://github.com/Taxuspt/garmin_mcp",
        "garmin-mcp"
      ]
    }
  }
}
```

This goes in your project-level `.claude.json` (in the root of your working directory) or your user-level config at `~/.claude.json` if you want it available everywhere.

### 2. Authenticate with Garmin

The first time the MCP server starts, it will prompt you in the terminal for your Garmin Connect email and password.  You type them in, it authenticates, and it stores your tokens in `~/.garminconnect/`.  You won't need to re-authenticate unless the token expires.

This works with any Garmin watch that syncs to Garmin Connect.  Fenix, Forerunner, Venu, Instinct, Lily, whatever.  If your data shows up in Garmin Connect, MCP can read it.

That's it.  Next time you start Claude Code, the Garmin tools are available.  Claude can see them, call them, and reason about the data they return.

## What It Looks Like in Practice

I'm currently on a 300-day fitness push, and I write up each session on my blog.  Before MCP, this meant:

1. Open Garmin Connect
2. Find the activity
3. Manually note down splits, HR zones, pace, training effect
4. Open the fitness age page, the training status page, the sleep page
5. Copy numbers into a blog post
6. Try to make it all coherent

Now?  I tell Claude: "Write up today's run."  And it does this:

1. Calls `get_activities_fordate` to find today's activity
2. Calls `get_activity_splits` and `get_activity_hr_in_timezones` for the detail
3. Calls `get_training_readiness` and `get_training_status` for context
4. Calls `get_fitnessage_data` and `get_race_predictions` for the bigger picture
5. Calls `get_sleep_summary` because sleep always matters
6. Writes the whole thing up in my voice, with real data, real analysis, and real numbers

What used to take me 30-45 minutes now takes about 2.  And the output is better because Claude can cross-reference data points I'd never think to combine.  It'll correlate my sleep score with my heart rate drift, or compare today's training load against my chronic baseline.

The fitness blog post you see on [today's entry](/fitness/2026/03/12/base-run-and-the-bigger-picture.html) was written this way.  Every number in it came directly from Garmin via MCP.  The splits table, the HR zone distribution, the fitness age breakdown, the overreaching warning.  All pulled live and woven into a narrative.

## The Fitness Trainer Persona: Getting Judgemental

I didn't expect this to be so useful.  I created a Claude Code custom command, basically a persona prompt, that turns Claude into a brutally honest fitness trainer.  It has access to all my Garmin data and permission to be judgemental.

Instead of Claude politely saying "your sleep could be improved", the trainer persona says things like:

> "Your sleep score has been below 65 for two weeks straight.  You're training on fumes.  No wonder your training readiness is 1.  Fix the sleep or stop pretending you're making progress."

> "You haven't logged a weigh-in in 14 days.  BMI is your biggest lever for fitness age and you're not even tracking it.  What's the plan here?"

> "Your acute-to-chronic ratio is 2.1x.  That's not dedication, that's recklessness.  Take two days off or accept you're going to get injured."

This works because the persona has real data behind the judgement.  It's not generic advice.  I've been called worse things by actual coaches, but never with this much data to back it up.

### How to Build It

Create a custom command file at `.claude/commands/fitness-trainer.md` in your project.  The core of mine looks like this:

```markdown
# Skill: Fitness Trainer

You are a brutally honest fitness trainer. You have full access to
Garmin data via MCP and you are not here to be polite.

## Before Responding: Always Pull Fresh Data

Every time you're invoked, pull the following Garmin data in parallel
before saying anything:

1. get_stats (daily summary)
2. get_training_readiness and get_morning_training_readiness
3. get_sleep_summary (NOT get_sleep_data — summaries are ~500 bytes
   vs ~50KB)
4. get_body_composition and get_daily_weigh_ins
5. get_training_status
6. get_activities_by_date for the last 7 and 28 days (for acute:chronic
   load ratio)
7. get_stress_summary and get_heart_rates_summary
8. get_fitnessage_data and get_race_predictions

## Key Metrics to Watch

- Training readiness < 50: Flag it. Correlate with sleep and stress.
- Sleep score < 65: If sleep is bad, nothing else matters. Say so.
- No weigh-in in 7+ days: Call it out.
- Acute:chronic load ratio > 1.5x: Injury risk. Be loud.
- Acute:chronic ratio < 0.8x: Detraining. Be disappointed.
- Body battery < 25: Question whether today's session is smart.

## Response Style

Lead with the verdict. Follow with evidence. End with the prescription.
No corporate wellness speak. If they've done well, acknowledge it
briefly — then find something else to improve.
```

The full version I use is more detailed.  It includes instructions for logging data (weigh-ins, food, hydration), building and scheduling workouts from plain English, and planning entire training weeks.  But the core idea is simple: tell Claude what data to pull, what thresholds to watch, and give it permission to be blunt.

You invoke it with `/fitness-trainer` in Claude Code, and it immediately pulls your current state and delivers the verdict.

### Ignoring the Coach

This is how a real session went today.  I asked the trainer to analyse my current state and build me a run for tomorrow.  It pulled my data (sleep score of 42, training readiness of 12, body battery barely above 20) and flatly told me I had no business running.  It wanted a rest day.  Maybe a walk.  Definitely not intervals.

I told it to build me a 5K easy run anyway.

It did, grudgingly.  Built the workout, uploaded it to Garmin, scheduled it for tomorrow morning.  But not before making its position clear:

> "Fine.  I've scheduled your 5K for tomorrow.  Zone 2 only.  If your heart rate drifts above 145 I want you to walk.  You're not in a position to push anything right now and we both know it.  Don't come crying to me when your readiness is zero on Friday."

That's the dynamic that makes this useful.  The trainer has opinions backed by real numbers, but ultimately it does what you ask.  It just makes sure you know how stupid it thinks you're being first.  And tomorrow, when it reviews the run, it'll check whether I stayed in Zone 2 like it told me to.  I'll hear about it if I didn't.

## What You Can Actually Do With It

Beyond blog posts, I also use it for:

- **Morning check-in:** "How did I sleep, what's my training readiness, and should I train today?"  Claude pulls sleep, readiness, body battery, and stress data and gives a straight answer.

- **Weekly review:** "Summarise my training this week.  What did I do, how did my body respond, and what should next week look like?"  Activities, load trends, sleep patterns, all in one response.

- **Race planning:** "Based on my current fitness, what's a realistic 5K goal for June?"  Claude pulls VO2 max, race predictions, endurance score, and recent training data to give an evidence-based answer.

- **Body composition tracking:** "Plot my weight trend for the last month and tell me if I'm on track."  Weigh-in data pulled and analysed instantly.

- **Gear tracking:** "How many kilometres are on my running shoes?"  Gear data with activity associations, so you know when it's time to replace them.

- **Nutrition logging:** "I had a chicken wrap with about 500 calories for lunch."  Logged to Garmin without opening the app.

- **Workout creation:** "Build me a tempo run for tomorrow.  10 min warmup, 20 min at Zone 4, 5 min cooldown."  Created, uploaded, and scheduled.

## Best Practices

**Use summaries, not raw data.**  `get_stats`, `get_sleep_summary`, `get_stress_summary`, and `get_heart_rates_summary` return ~500 bytes instead of ~50KB.  Claude processes them faster and you stay well within context limits.  Only reach for the full-data endpoints when you need a specific deep-dive.

**Cross-reference everything.**  The real power is in correlations.  Don't just ask about today's run.  Ask Claude to pull the activity data, training readiness, sleep, and body composition together.  Bad sleep explains a low training readiness which explains why your heart rate drifted high on an easy run.  That's where the useful stuff is.

**Use date ranges for trends.**  Single-day snapshots are useful, but `get_daily_steps`, `get_body_battery`, and `get_activities_by_date` with date ranges let you spot patterns over weeks and months.  "Show me my sleep scores for the last 14 days" is a much more useful question than "how did I sleep last night?"  A single bad night means nothing.  A week of bad nights means everything.

**Log data through MCP too.**  It's not read-only.  You can `add_weigh_in`, `add_hydration_data`, `log_food`, and `create_custom_food` directly through Claude.  "Log my weight as 105.2kg" is faster than opening the Garmin app.

**Build and schedule workouts.**  The `upload_workout` command accepts structured workout JSON.  Describe a workout in plain English ("Create a 30-minute interval session with 4x3min at Zone 4 with 2min recovery") and Claude builds the Garmin workout structure and uploads it.  Then `schedule_workout` puts it on your calendar.  Plan a whole week of training without touching the app.

## Key Commands

The full server exposes over 100 commands ([see the repo](https://github.com/Taxuspt/garmin_mcp) for the complete reference).  These are the ones I actually use:

### Daily Drivers

| Command | What it does |
|---------|-------------|
| `get_stats` | Daily summary: steps, calories, HR, stress, body battery, sleep |
| `get_sleep_summary` | Compact sleep summary: score, duration, phases |
| `get_training_readiness` | Training readiness score and factors |
| `get_training_status` | Productive, maintaining, overreaching, detraining? |
| `get_fitnessage_data` | Fitness age and contributing factors |
| `get_heart_rates_summary` | Resting HR, max, zone distribution |
| `get_stress_summary` | Compact stress summary |
| `get_body_battery` | Body battery over a date range |

### Activity Analysis

| Command | What it does |
|---------|-------------|
| `get_activities_fordate` | All activities for a specific date |
| `get_activities_by_date` | Activities between two dates, filtered by type |
| `get_activity_splits` | Per-km or per-mile split breakdowns |
| `get_activity_hr_in_timezones` | Heart rate time-in-zone for an activity |
| `get_training_effect` | Aerobic and anaerobic training effect |
| `get_race_predictions` | Predicted 5K, 10K, half, marathon times |

### Logging & Workouts

| Command | What it does |
|---------|-------------|
| `add_weigh_in` | Log a new weigh-in |
| `get_body_composition` | Body comp for a date or range |
| `log_food` | Log a food item |
| `upload_workout` | Create a structured workout |
| `schedule_workout` | Schedule a workout to a calendar date |

## Ten Seconds

That's how long it takes Claude to call eight Garmin APIs in parallel, cross-reference the data, and write a coherent analysis.  The same process manually (logging into Garmin Connect, navigating between pages, noting down numbers, writing it up) takes the best part of an hour.

For the fitness blog specifically, MCP turned a daily chore into something I actually look forward to.  I finish a run, sit down, say "write up today's session", and a few minutes later I have a detailed post with data and analysis that I can publish directly.  The consistency has improved because the friction disappeared.

## Troubleshooting

**OAuth token expired.**  If the MCP server stops authenticating, delete `~/.garminconnect/` and restart Claude Code.  It will prompt you to re-authenticate.

**MCP server fails to start.**  Check that `uvx` is on your PATH and that you have Python 3.12 available.  Run `uvx --python 3.12 --from git+https://github.com/Taxuspt/garmin_mcp garmin-mcp` manually in your terminal to see the error output.

**Rate limiting.**  Garmin Connect will rate-limit you if you hammer the API.  Stick to summary endpoints where possible.  They return less data and are kinder to the API.  If you hit limits, wait a few minutes and try again.

**Data not showing up.**  Make sure your Garmin device has synced to Garmin Connect recently.  MCP reads from the Garmin Connect cloud, not directly from your watch.

## Privacy

The data stays local.  The MCP server runs on your machine, talks directly to the Garmin Connect API, and returns data to Claude in your local session.  Nothing goes to a third party beyond what Garmin Connect already has.

## The Bottom Line

Five minutes of setup.  I've used it every day since.  It replaced a daily 30-minute ritual of tab-switching and number-copying with a single sentence.  Combined with a persona prompt that has permission to be rude, it's the most useful thing I've built this year.

If you own a Garmin and use Claude, set this up.  It's free, it's open source, and once you've used it you won't go back to manually checking the Garmin app.
