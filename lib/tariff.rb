require 'tariff/version'
require 'json'

# Class to calculate tariff prices
class Tariff
  def initialize
    @file_basename = File.basename($PROGRAM_NAME)
  end

  def tariff_usage
    abort "Usage: #{@file_basename} cost <POWER_USAGE> <GAS_USAGE>
       or
       #{@file_basename} usage <TARIFF_NAME> <FUEL_TYPE> <TARGET_MONTHLY_SPEND>

Explanation:  POWER_USAGE - given annual power consumption in kWh
              GAS_USAGE - given annual gas consumption in kWh
              TARIFF_NAME - please check prices file for tariff names
              FUEL_TYPE - power or gas'
              TARGET_MONTHLY_SPEND - given target monthly spend (inclusive VAT)"
  end

  def validate_and_assign_json
    if File.exist?("#{__dir__}/../data/prices.json")
      file_prices = File.read("#{__dir__}/../data/prices.json")
      @prices_hash = JSON.parse(file_prices)
    else
      abort 'Cannot read json file'
    end

    @prices_hash
  end

  def validate_and_assign_vat_json
    if @prices_hash['VAT'] && @prices_hash['VAT'].between?(0, 50)
      @vat = @prices_hash['VAT'] / 100.00 + 1
    else
      abort 'Cannot use VAT from json file'
    end
  end

  def tariff_comparison(args)
    # Get arguments count to not accept more than needed
    arg_size = args.size

    # Arguments are fixed as required
    arg1 = args[0]
    arg2 = args[1]
    arg3 = args[2]
    arg4 = args[3]

    validate_and_assign_json

    validate_and_assign_vat_json

    # Validate given arguments and calculate the results
    if arg1 =~ /^cost$/
      # Cost logic
      if arg_size < 4 && arg2 && arg3
        annual_consumption_power = arg2.to_f
        annual_consumption_gas = arg3.to_f

        annual_cost_hash = {}

        @prices_hash['tariffs'].each do |tariff, fuels|
          # Power
          annual_cost_power = 0

          if fuels['power']
            tariff_price_power = fuels['power']['kwh_price']
            standing_charge_power = fuels['power']['monthly_standing_price']

            annual_cost_power = (annual_consumption_power * tariff_price_power * @vat) + (standing_charge_power * 12 * @vat) if annual_consumption_power > 0
          end

          # Gas
          annual_cost_gas = 0

          if fuels['gas']
            tariff_price_gas = fuels['gas']['kwh_price']
            standing_charge_gas = fuels['gas']['monthly_standing_price']

            annual_cost_gas = (annual_consumption_gas * tariff_price_gas * @vat) + (standing_charge_gas * 12 * @vat) if annual_consumption_gas > 0
          end

          # Power + Gas
          # QUITE IMPORTANT: to round down by 1 pp with floor(2) or to round up by 1 pp with round(2)
          annual_cost = (annual_cost_power + annual_cost_gas).floor(2)

          # Print float with two digits regardless if this is zero for pences & writing tariff prices to hash for sorting
          annual_cost_hash[tariff] = format('%.2f', annual_cost)
        end

        tariff_output = []
        
        # Sorting by price and printing the output
        annual_cost_hash.sort_by { |_k, v| v.to_f }.each do |tariff_line|
          tariff_output << tariff_line.join(' ').gsub(/ /, ' £')
        end
        
        tariff_output
      else
        tariff_usage
      end
    elsif arg1 =~ /^usage$/
      # Usage logic
      if arg_size < 5 &&
         arg2 && arg3 && arg4
        # Used integers to reduce complexity of floats - this part needs to be improved only if this app will be called by using floats
        tariff = arg2.to_s
        fuel_type = arg3.to_s
        monthly_spend = arg4.to_f

        unless fuel_type =~ /^(gas|power)$/i
          puts 'Cannot find this fuel type'
          tariff_usage
          exit 1
        end

        unless @prices_hash['tariffs'].key?(tariff)
          puts 'Cannot find this tariff'
          tariff_usage
          exit 1
        end

        fuel_found = @prices_hash['tariffs'][tariff][fuel_type]

        abort "#{fuel_type} is not available in #{tariff}" unless fuel_found

        fuel_price = fuel_found['kwh_price']
        fuel_monthly_standing_price = fuel_found['monthly_standing_price']

        annual_consumption = ((monthly_spend * 12) - (fuel_monthly_standing_price * 12 * @vat)) / (fuel_price * @vat)

        # Round down by watt
        "#{annual_consumption.floor(3)} kWh"
      else
        tariff_usage
      end
    else
      tariff_usage
    end
  end
end
