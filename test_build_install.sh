#!/bin/bash

rspec && gem build tariff.gemspec && gem install tariff-*.gem &&rm tariff-*.gem
