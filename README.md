# Tariff



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

2) Just execute from bin directory:

    $ ./tariff
    
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
mac:bin user$ ./tariff.rb usage tariff1 gas 30
1628.571 kWh
mac:bin user$ ./tariff.rb 
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
