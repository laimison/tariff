#!/bin/bash

echo "Make sure you have rspec, gem installed and executed bundle install"
rspec && gem build tariff.gemspec && gem install tariff-*.gem && echo "Installed at:" && gem contents tariff 2>/dev/null | grep bin/tariff
