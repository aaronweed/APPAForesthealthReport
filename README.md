---
output: 
    html_document:
      css: custom_styles.css
      includes: 
        in_header: "header_readme.html" 
        after_body: "footer.html"
---

# Introduction

This repository contains code used for the Appalachian Scenic Trail Forest Health Monitoring Report. Below is a quick overview of the files and directories in this repository and their uses.

## Repo structure/files

* atForestReport.Rmd - The main (final/output) document containing analysis and information.
* data_prep - R scripts for downloading and summarizing FIA data for the report
* summary_data - Summaries of data in the form of RDS files output from data_prep/03make.R.
* ecoregions - shapefiles for the ecoregions near the AT 
* at_centerline - shapefiles for the AT centerline
* custom_styles.css - The CSS code used in atForestReport
* header_manual.html and footer.html - The header and footer used in atForestReport
* *.png - Images used in atForestReport
              
    

            
