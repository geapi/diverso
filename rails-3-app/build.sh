#!/bin/bash

# for selenium headless
export DISPLAY=:99

source /usr/local/rvm/scripts/rvm

# must happen after loading rvm
# set -e

export RUNNING_CI=true

rm spec/fixtures/*.yml

rvm list | grep ruby-1.9.2-p180 > /dev/null || rvm install ruby-1.9.2-p180

rvm use ruby-1.9.2-p180@[your-rails-rvm] --create

gem list --local bundler | grep bundler || gem install bundler

bundle check || bundle install --local

echo "loading schema"
RAILS_ENV=test bundle exec rake db:schema:load > /dev/null 2>&1

declare -i ERROR_COUNT=0

echo "running specs"
RAILS_ENV=test bundle exec rspec spec -t ~js
ERROR_COUNT+=$?
echo "ERROR_COUNT $ERROR_COUNT"

echo "running selenium"
RAILS_ENV=test bundle exec rspec spec -t js
ERROR_COUNT+=$?
echo "ERROR_COUNT $ERROR_COUNT"

echo "running jasmine tests"
RAILS_ENV=test bundle exec rake jasmine:ci:headless
ERROR_COUNT+=$?
echo "ERROR_COUNT $ERROR_COUNT"

# make sure the test fixtures still load
echo "loading test fixtures"
RAILS_ENV=development bundle exec rake db:rebuild
ERROR_COUNT+=$?
echo "ERROR_COUNT $ERROR_COUNT"

exit $ERROR_COUNT