![EVESCORE](https://raw.githubusercontent.com/evescore/evescore/master/app/assets/images/evescore_logo_dark.png)

[![Build Status](https://travis-ci.org/evescore/evescore.svg?branch=master)](https://travis-ci.org/evescore/evescore)
[![Code Climate](https://codeclimate.com/github/evescore/evescore/badges/gpa.svg)](https://codeclimate.com/github/evescore/evescore)
[![Test Coverage](https://codeclimate.com/github/evescore/evescore/badges/coverage.svg)](https://codeclimate.com/github/evescore/evescore/coverage)

## DISCLAIMER!

This is a work in progress, so results may vary

## General

A PvE scoreboard relying on Wallet Journal data from ESI. It parses the information contained in the incomming bounty transactions into information on kills of NPCs.

Provides info on NPCs when clicked on a icon link in the "Kill Log" or one of the entries in the Character dashboard. When visited via a `rat`, `rats` or `ratopedia` subdomains redirects directly to the "ratopedia". Same info available under the `/factions` path ([https://evescore.online/factions](https://evescore.online/factions))

## Requirements

- An up to date `mongodb` server i.e. not the default one in Ubuntu LTS. Hint: [https://docs.mongodb.com/manual/installation/](https://docs.mongodb.com/manual/installation/)

Standard Rails 5 deps:

- `nodejs`
- `yarn 1.5.1`

Testing:

- `phantomjs`

Hint: [https://docs.mongodb.com/manual/installation/](https://docs.mongodb.com/manual/installation/)

## Installation

    # Clone the repo
    $ git clone https://github.com/evescore/evescore.git
    
    # Enter the app dir
    $ cd evescore
    
    # Import data
    $ bundle exec rake import:all
    
## Startup
#### Web

    # Start the server
    $ bundle exec rails server
    
### Worker

Handled by `delayed_job`

    # Responsible for the initial import of Wallet date after adding a Character
    $ bundle exec rake jobs:work
    
### Recurring tasks

Handled by `whenever`
    
    $ bundle exec whenever
    0,5,10,15,20,25,30,35,40,45,50,55 * * * * /bin/bash -l -c 'cd /Users/chi/Projects/evescore && RAILS_ENV=production bundle exec rake import:wallets --silent >> /root/cron.log 2>&1'

    0 0 * * * /bin/bash -l -c 'cd /Users/chi/Projects/evescore && RAILS_ENV=production bundle exec rake update:rats --silent >> /root/cron.log 2>&1'

    ## [message] Above is your schedule file converted to cron syntax; your crontab file was not updated.
    ## [message] Run `whenever --help' for more options.
    
