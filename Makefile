TEST_FILES:= $(wildcard test/*_test.rb)

.DEFAULT_GOAL:=test-acceptance

Gemfile.lock: Gemfile
	bundle install
	touch $@

.PHONY: test
test: Gemfile.lock
	@ruby -I$(PWD) $(foreach file,$(TEST_FILES),-r$(file)) -e exit

.PHONY: test-acceptance
test-acceptance: Gemfile.lock
	bundle exec cucumber -r features/support/env.rb --strict
