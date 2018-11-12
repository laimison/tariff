require "tariff/version"
require 'tariff/translator'

module Tariff
  # Default is english for - Tariff.hi
  # but it can be called with - Tariff.hi('spanish')
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi
  end
  
  def hi2(language = "english")
    translator = Translator.new(language)
    translator.hi    
  end
end

class Laimis
  include Tariff
end

my_test = Laimis.new
puts my_test.hi2