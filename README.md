[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.x&color=orange)

# Colorado APACD Connector


This is package models data from Colorado's all payers all claims database into the Tuva claims input layer for downstream processing and analytics.


## Pre-requisites
1. You have Colordo claims data
2. You have [dbt](https://www.cloud.getdbt.com/) installed and configured (i.e. connected to your data warehouse)

[Here](https://docs.getdbt.com/dbt-cli/installation) are instructions for installing dbt.

## Configuration
Execute the following steps to load all seed files, build all data marts in your data warehouse:

1. [Clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) this repo to your local machine or environment
4. Configure [dbt_project.yml](/dbt_project.yml)
    - profile: set to 'default'.  Cloud users do not have to change this but CLi users need to change to an active profile in the profile.yml file that connects to your data warehouse
    - vars: configure source_name, source database name, and source schema name
5. Run project
    1. Navigate to the project directory in the command line
    2. Execute "dbt build" to create all tables/views in your data warehouse

## Contributions
Have an opinion on the mappings? Notice any bugs when installing 
and running the package? If so, we highly encourage and welcome contributions to this package! 

Join the conversation on [Slack](https://tuvahealth.slack.com/ssb/redirect#/shared-invite/email)!  We'd love to hear from you on the #claims-preprocessing channel.

## Database Support
This package has been tested on Redshift.  We are planning to expand testing to BigQuery in the near future.
