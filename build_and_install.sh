#!/bin/bash

rspec
gem build tariff.gemspec && gem install tariff-*.gem && echo "Installed at:" && gem contents tariff 2>/dev/null | grep bin/tariff
