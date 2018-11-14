# Tariff

This application takes arguments as a input. These argumens are converted to floats to make sure output is not affected. Output values are rounded to 2 decimal places and also zeros are kept for pences e.g. £10.00.
In json file if any fuel is not supplied, you can take out this block. You can check the example: tariff4. It looks simpler than having true and false booleans.
The app allows only 3 or 4 arguments depending on command 'cost' or 'usage'. So it has fixed, but also validated structure.
This code contains unit tests and rubocop styling checks and they passed. In a code, I have decided to convert everything to 1 year to simplify calculations.
VAT parameter is moved to json for easier management. It is accepted as integer or float.
In addition, this program is packaged by using gem.

JSON file is located at (data/prices.json)[data/prices.json]

Thank you

# My Questions

If the tariff costs e.g. £20.12333, should we round up or round down the price for output?

I have rounded down in a code so it outputs £20.12 in this case. You can search for "QUITE IMPORTANT" phrase.

## Installation Prerequisites

Make sure you have Ruby 2.4 or newest version installed

For Mac OS:
`brew install ruby`

(no root access required in any step)

For Ubuntu:
`sudo apt-get install ruby-full`

For Redhat:
`sudo yum install ruby`

You may need to execute `bundle install` from project's directory to get RSpec tool for unit tests and rubocop tool for styling.

## Installation

Here are options to execute this app. So you can choose one of them:

1) install as gem and check where `tariff` binary was installed:

    $ cd to_this_project
    
    $ gem install tariff
    
    $ gem contents tariff
    
    $ ./bin/tariff 
    
2) you can also install gem package from file

    $ gem install --local tariff-0.1.0.gem
    
    $ gem contents tariff
    
Add binary to your PATH or call with full path
    
## Re-build gem

Please review and use a Shell script:

    $ ./build_and_install.sh
    
    $ gem contents tariff
    
If any issues, you can execute `bundle install` so this will install tools such as RSpec as defined in a Gemfile
    
## Usage

Here are examples to use this app:

```
mac:bin user$ ./tariff cost 1000 0
tariff1 £304.50
tariff2 £378.00
tariff3 £424.20
tariff4 £424.20
mac:bin user$ ./tariff usage tariff1 gas 30
1628.571 kWh
mac:bin user$ ./tariff --help 
Usage: tariff.rb cost <POWER_USAGE> <GAS_USAGE>
       or
       tariff.rb usage <TARIFF_NAME> <FUEL_TYPE> <TARGET_MONTHLY_SPEND>

Explanation:  POWER_USAGE - given annual power consumption in kWh
              GAS_USAGE - given annual gas consumption in kWh
              TARIFF_NAME - please check prices file for tariff names
              FUEL_TYPE - power or gas'
              TARGET_MONTHLY_SPEND - given target monthly spend (inclusive VAT)
mac:bin user$
```

## Testing

It contains one unit test to show that class can be easily tested, especially comparing input and output figures

    $ rspec
    
It passes rubocop styling checks

    $ rubocop
