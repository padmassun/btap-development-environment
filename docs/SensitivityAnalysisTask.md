#Sensitivity Analysis Task
## Ensure environment is working. 
In your project folder clone the following repostories. The measures and standards projects are required to be at the same folder level as the. If you do not have access to any of the repositories please ask andrew parker for access. 
```bash
  git clone https://github.com/phylroy/OpenStudio-PTool.git
  git https://github.com/NREL/openstudio-standards.git -b nrcan 
  git clone https://github.com/NREL/OpenStudio-measures.git -b nrcan
  
```
Follow the instructions in the main PTOOL folder to setup the environment and test that PTOOL is functional. You may also try to run the NECB projects as well. Please only use Excel to edit the excel files.

You can download the CSV or the R dataframe from the website. BTAPReports now compresses and adds the OSM file to the CSV file.. This is to avoid having to download each osm file one at a time, however the csv file will not be viewable in EXCEL. To extract the zipped osm and other data files and create a new csv file simpley type on the terminator console. 
```bash
btap_results_extracter -f your_csv_file
```
This will create an output folder with the csv file and all the other files for each simulation.  If you are on windows you will have to use this file and ensure that it is up to date. https://github.com/phylroy/btap_utilities/blob/master/btap_results_extracter

##Adding Measures for BTAP
If you examine the nrcan branch of the OpenStudio-measures, you will find an NRCAN_working_measures, as well as NREL measure folder. If we make modifications to any of the measures, or create new ones, please place them in this folder, ideally with a btap prefix. This is to avoid confusion on what are NRELs original measures and what are the ones that we have modified and authored. You will notice on the 'setup' tab of the project Excel files that the 'Measure Directory' links to the measures...This of this as similar to an include statement in C++. This will tell the excel file where to look for measures.  A 'How to write measures guide' is located here http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide.

##Loads, Envelope and HVAC Spreadsheets
This task is to create a sensitivity / parametric analysis of any/all of the archetypes withing these three domains. We have modified the NECB QA/QC spreadsheet as a starting point. The goal is to modify common charecteristics of the building automatically within these three domains. The measure variables units should be real (RSI, KW, U-value) where ever possible and up to 5 reasonable defaults should be set. The measure should include a "baseline" default value as well that effectively does nothing to ensure that the baseline condition will be run this means that most of the measures will be discrete based. so for example for string based measures the format should look like this. 
```bash
['baseline','concrete','wood']
``
for double based variable is should have a consitant number





