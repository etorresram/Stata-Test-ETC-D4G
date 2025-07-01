# STATA Test – Extended Term Consultant Application (req32976)
## Author: Eric Torres

This repository contains my submission for the take-home STATA test required as part of the recruitment process for an Extended Term Consultant position, focused on welfare and poverty analysis.

##  Repository Structure

- `question_1.do` – Code for Question 1: International poverty analysis using `Brazil_2022.dta`.
- `question_2.do` – Code for Question 2: Efficient computation of poverty and Gini coefficients from 1,000 simulation datasets.
- `new_poverty.ado` – Custom ado-file to compute international poverty indicators by subgroup (e.g., state, rural).
- `new_gini.ado` – Custom ado-file to compute Gini coefficients efficiently at national levels, and also  by subgroups (e.g., state, rural).
- `question_3.docx` – Description of past STATA experience and context for the accompanying code.
- `salarios2.do` (described in `question_3.docx`) – A do-file used to generate harmonized labor poverty indicators in nine Latin American and Caribbean countries.


##  Summary of Each Task

### Question 1 – International Poverty in Brazil
- Computed the $3.00/day international poverty rate for Brazil (2022).
- Generated disaggregated poverty estimates by gender and education.
- Created an illustrative graph and table for export to Excel.

### Question 2 – Efficient Simulated Estimation
- Processed 1,000 simulated datasets using loops and timers.
- Computed poverty rates and Gini coefficients at national and state levels.
- Designed the code to be easily scalable to urban/rural levels.

### Question 3 – Prior STATA Experience
- Provided a real do-file (`salarios2.do`) developed during a technical note for the IDB.
- The code harmonized variables like income and employment status across countries, and used PPP conversion factors to ensure comparability.
- The accompanying `.docx` explains the context and learning outcomes.

##  How to Run
To adapt and run these scripts:
1. Set your working directory at the top of each `.do` file.
2. Make sure all required `.ado` files are in your Stata ADO path.
3. Use the datasets provided in the instructions (`Brazil_2022.dta`, `Sim_sample.zip`).

##  Notes
- All code is thoroughly commented to explain the reasoning.
- The `timer` function was used to measure runtime efficiency.
- The scripts follow best practices in file structuring and documentation.
