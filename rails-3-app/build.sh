#!/bin/bash
tput setaf 3
echo "****************************************"
echo "Running suite for Rails app ..."
# install bundler if necessary
#set -e

CURRENTDIR=`pwd`
TEST_TO_RUN=$1

exitStatus=0

function run_app_specs {
  echo "Tests for Rails App ..."
  echo ""
  source .rvmrc
  echo USER=$USER && ruby --version && which ruby && which bundle
  gem install bundler --no-ri --no-rdoc && bundle install --quiet

  if [[ -n "$JENKINS_HOME" ]]; then
    ln -sf ../../shared/database.yml config/database.yml
    RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
    CI=true rspec spec -t ~local_only
    exitStatus+=$?
    echo "\nBEGIN License Finder"
    license_finder --quiet
    echo "END License Finder\n"
    exitStatus+=$?
  else
    RAILS_ENV=test bundle exec rake db:create db:migrate db:test:prepare
    rspec spec
    exitStatus+=$?
  fi
  exitStatus+=$?
}

function run_engine_tests {
    echo "Tests for engines ..."
    exitStatus+=$?

}

case "$1" in

lib)  echo "Running only tests for engines ..."
      run_engine_tests
      ;;
*) echo "Running all tests ..."
   run_app_specs
    ;;
esac

cd "$CURRENTDIR"



if [ $exitStatus -eq 0 ]; then
tput setaf 2
echo "****************************************"
echo "**         SUCCESSFUL BUILD!          **"
echo "**    `date`    **"
echo "****************************************"
else
tput setaf 1
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "XX           BUILD FAILED!            XX"
echo "XX    `date`    XX"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
exit -1
fi
