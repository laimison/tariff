require "tariff/version"
require 'tariff/translator'

module Tariff
  def self.hi(language = "english")
    translator = Translator.new(language)
    translator.hi       
  end
end
