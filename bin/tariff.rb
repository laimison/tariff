#!/usr/bin/env ruby
#
# Alpha version
#
# Written in Ruby 2.4
#

require 'json'
require 'pp'

class Tariff
  def tariff_usage
    puts "Usage: ./#{File.basename($0)} cost <POWER_USAGE> <GAS_USAGE>
       or
       ./#{File.basename($0)} usage <TARIFF_NAME> <FUEL_TYPE> <TARGET_MONTHLY_SPEND>

Explanation:  POWER_USAGE - given annual power consumption in kWh
              GAS_USAGE - given annual gas consumption in kWh
              TARIFF_NAME - please check prices file for tariff names
              FUEL_TYPE - power or gas'
              TARGET_MONTHLY_SPEND - given target monthly spend (inclusive VAT)"
    exit 1
  end
end

# Extend Ruby String class (this is needed to identify number from string directly)
class String
  def is_number?
    true if Float(self) rescue false
  end
end

vat = 1.05

file_prices = File.read("#{__dir__}/../data/prices.json")
prices_hash = JSON.parse(file_prices)

arg1 = ARGV[0]
arg2 = ARGV[1]
arg3 = ARGV[2]
arg4 = ARGV[3]
arg5 = ARGV[4]
arg_size = ARGV.size

my_tariff = Tariff.new

if arg1 =~ /^cost$/
  # Cost logic
  if arg_size < 4 &&
     arg2 && arg2.is_number? &&
     arg3 && arg3.is_number?
    annual_consumption_power = arg2.to_i
    annual_consumption_gas = arg3.to_i

    annual_cost_hash = Hash.new
    
    prices_hash['tariffs'].each do |tariff, fuels|
      # Power      
      annual_cost_power = 0
      
      tariff_price_power = fuels['power']['kwh_price']
      standing_charge_power = fuels['power']['monthly_standing_price']
      power_available = fuels['power']['available']
      
      if power_available && annual_consumption_power > 0
        annual_cost_power = (annual_consumption_power * tariff_price_power * vat) + (standing_charge_power * 12 * vat)
      end      
      
      # Gas
      annual_cost_gas = 0
      
      tariff_price_gas = fuels['gas']['kwh_price']
      standing_charge_gas = fuels['gas']['monthly_standing_price']
      gas_available = fuels['gas']['available']
      
      if gas_available && annual_consumption_gas > 0
        annual_cost_gas = (annual_consumption_gas * tariff_price_gas * vat) + (standing_charge_gas * 12 * vat)
      end
            
      # Power + Gas
      annual_cost = annual_cost_power + annual_cost_gas

      # Writing tariff prices to hash to sort them in the next steps
      annual_cost_hash[tariff] = annual_cost
    end # prices.hash['tariffs'] each ends
    
    # Sorting by price and printing the output
    annual_cost_hash.sort_by {|k, v| v}.each do |line|
      puts line.join(' ')
    end
  else
    my_tariff.tariff_usage
  end
elsif arg1 =~ /^usage$/
  # Usage logic
  if arg_size < 5 &&
     arg2 && !arg2.is_number? &&
     arg3 && !arg3.is_number? &&
     arg4 && arg4.is_number?
    tariff = arg2
    fuel_type = arg3
    monthly_spend = arg4.to_i
    
    unless fuel_type =~ /^(gas|power)$/i
      puts 'Cannot find this fuel type'
      my_tariff.tariff_usage
      exit 1
    end
    
    unless prices_hash['tariffs'].keys.include?(tariff)
      puts 'Cannot find this tariff'
      my_tariff.tariff_usage
      exit 1      
    end
    
    unless prices_hash['tariffs'][tariff][fuel_type]
      puts "#{fuel_type} is not available in #{tariff}"
      exit 1
    end

    fuel_found = prices_hash['tariffs'][tariff][fuel_type]
    
    fuel_price = fuel_found['kwh_price']
    fuel_monthly_standing_price = fuel_found['monthly_standing_price']
    fuel_available = fuel_found['available']
    
    annual_consumption = ((monthly_spend * 12) - (fuel_monthly_standing_price * 12 * vat)) / (fuel_price * vat)
    
    # Round down watts
    puts "#{annual_consumption.floor(3)} kWh"
  else
    my_tariff.tariff_usage
  end
else
  my_tariff.tariff_usage
end