# Usage of the analyze_and_log_errors script
This script is used as a post processing tool to analyze the qaqc non-compliances and log the runtime errors that occur during a run on the OpenStudio-Server that has the BTAP download button feature.

This script will read the `simulations.json` and `failed_run_error_log.csv`, and produce 
1. A csv file that has the qaqc errors that can be copied directly into the `qaqc.template.xlsm`
2. A json file that will contain the QAQC error logs, runtime errors, and eplus warnings, and severe errors.

# Using the qaqc.template.xlsm 
This file is used to analyze the correlations of failures that occur during a run on OpenStudio Server (that has the BTAP download button). The output provided by the `analyze_and_log_errors` script is used to identify the corelations of the errors. The `qaqc.template.xlsm` file contains a regex macro that is used to sort and match the errors using keywords present within the header of this file.

The contents of the `qaqc.log.csv` that was written by the `analyze_and_log_errors.rb` script should be copied to `qaqc.template.xlsm` file. Next the formula used in the second row must be applied to all the rows below after the new content has been pasted. The regex macro will grab the qaqc errors, and it makes it easier to analyze the failure patterns.

