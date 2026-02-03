*Code for ECON0110 research project

*First, some work on the dataset for white-asian decomposition
*Working directory
cd "C:\Users\liayu\OneDrive - Università Commerciale Luigi Bocconi\Gender and Ethnicity in the Economy\project"

*Opening file
use "k_indresp.dta", clear

*Selecting the variables needed
keep pidp k_age_dv k_ethn_dv k_employ k_fimnlabgrs_dv k_hiqual_dv k_jbhrs k_urban_dv k_jbnssec5_dv

*Dropping observations for individuals that are not employed or work less than 0 hours per week
drop if k_employ!=1
drop if k_jbhrs<0

*Selecting the ethnicities we're interested in
drop if k_ethn_dv<1  // Values from 1 to 4 are for whites
drop if k_ethn_dv>13 // Values from 9 to 13 are for Asian ethnicities
drop if k_ethn_dv==5 // Values from 5 to 8 are for mixed ethnicities, e.g. white and black, white and asian, ecc...
drop if k_ethn_dv==6
drop if k_ethn_dv==7
drop if k_ethn_dv==8

*Dropping observations for missing data about residence (urban/rural), highest qualification, job sector and monthly labour income
drop if k_urban_dv<1
drop if k_hiqual_dv<1
drop if k_jbnssec5_dv<1
drop if k_fimnlabgrs_dv<1

*Generating new variables: the log of monthly labour income, binary variable for ethnicity (white=0, asian=1), binary variable for rural (=0) or urban (=0) area
generate log_wage=ln(k_fimnlabgrs_dv)

gen ethnicity=0
replace ethnicity=1 if k_ethn_dv>=9 & k_ethn_dv<=13

gen urban=0
replace urban=1 if k_urban_dv==1

gen age=k_age_dv

gen hrs_worked=k_jbhrs

*Generating variables for educational levels and job sectors 
gen education=1							// Value 1 for "no qualification"
replace education=2 if k_hiqual_dv==5	// Value 2 for "other qualification"
replace education=3 if k_hiqual_dv==4	// Value 3 for "GCSE"
replace education=4 if k_hiqual_dv==3	// Value 4 for "A levels"
replace education=5 if k_hiqual_dv==2	// Value 5 for "other higher degree"
replace education=6 if k_hiqual_dv==1	// Value 6 for "degree"

gen job_sector=1							//Value 1 for "semi-routine & routine"
replace job_sector=2 if k_jbnssec5_dv==4	// Value 2 for "lower supervisory & technical"
replace job_sector=3 if k_jbnssec5_dv==3	// Value 3 for "Small employers & own account"
replace job_sector=4 if k_jbnssec5_dv==2	// Value 4 for "Intermediate"
replace job_sector=5 if k_jbnssec5_dv==1	// Value 5 for "Management & professional"

*Generating a dummy variable that takes value 1 for people that match the stereotype, i.e. that have the highest level of education, work as manager or other professional and their interaction term
gen high_education=0
replace high_education=1 if education==6

gen manager=0
replace manager=1 if job_sector==5

gen high_education_manager=high_education*manager

save wh_as_data, replace

*Oaxaca-Blinder decomposition
oaxaca log_wage age urban hrs_worked education job_sector, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education job_sector high_education, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education job_sector high_education high_education_manager, by(ethnicity) noisily



*Now, some work on the dataset for white-black decomposition
*Working directory
cd "C:\Users\liayu\OneDrive - Università Commerciale Luigi Bocconi\Gender and Ethnicity in the Economy\project"

*Opening file
use "k_indresp.dta"

*Selecting the variables needed
keep pidp k_age_dv k_ethn_dv k_employ k_fimnlabgrs_dv k_hiqual_dv k_jbhrs k_urban_dv k_jbnssec5_dv

*Dropping observations for individuals that are not employed or work less than 0 hours per week
drop if k_employ!=1
drop if k_jbhrs<0

*Selecting the ethnicities we're interested in
drop if k_ethn_dv<1
drop if k_ethn_dv==5 
drop if k_ethn_dv==6
drop if k_ethn_dv==7
drop if k_ethn_dv==8
drop if k_ethn_dv==9 // Values from 14 to 16 are for blacks
drop if k_ethn_dv==10
drop if k_ethn_dv==11
drop if k_ethn_dv==12
drop if k_ethn_dv==13
drop if k_ethn_dv>=17

*Dropping observations for missing data about residence (urban/rural), highest qualification, job sector and monthly labour income
drop if k_urban_dv<1
drop if k_hiqual_dv<1
drop if k_jbnssec5_dv<1
drop if k_fimnlabgrs_dv<1

*Generating new variables: the log of monthly labour income, binary variable for ethnicity (white=0, black=1), binary variable for rural (=0) or urban (=0) area
generate log_wage=ln(k_fimnlabgrs_dv)

gen ethnicity=0
replace ethnicity=1 if k_ethn_dv>=14

gen urban=0
replace urban=1 if k_urban_dv==1

gen age=k_age_dv

gen hrs_worked=k_jbhrs

*Generating variables for educational levels and job sectors
gen education=1
replace education=2 if k_hiqual_dv==5
replace education=3 if k_hiqual_dv==4
replace education=4 if k_hiqual_dv==3
replace education=5 if k_hiqual_dv==2
replace education=6 if k_hiqual_dv==1

gen job_sector=1
replace job_sector=2 if k_jbnssec5_dv==4
replace job_sector=3 if k_jbnssec5_dv==3
replace job_sector=4 if k_jbnssec5_dv==2
replace job_sector=5 if k_jbnssec5_dv==1

*Generating a dummy variable that takes value 1 for people that match the asian stereotype, i.e. that have the highest education, work as manager or other professional and their interaction term
gen high_education=0
replace high_education=1 if education==6
gen manager=0
replace manager=1 if job_sector==5

gen high_education_manager=high_education*manager

*Oaxaca-Blinder decomposition*
oaxaca log_wage age urban hrs_worked education job_sector, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education job_sector high_education, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education job_sector high_education high_education_manager, by(ethnicity) noisily

save wh_bl_data, replace




*Then, some work on the dataset for white-chinese decomposition*
*Working directory*
cd "C:\Users\liayu\OneDrive - Università Commerciale Luigi Bocconi\Gender and Ethnicity in the Economy\project"

*Opening file*
use "k_indresp.dta", clear

*Selecting the variables needed*
keep pidp k_age_dv k_ethn_dv k_employ k_fimnlabgrs_dv k_hiqual_dv k_jbhrs k_urban_dv k_jbnssec5_dv

*Dropping observations for individuals that are not employed, work less than 0 hours per week*
drop if k_employ!=1
drop if k_jbhrs<0

*Selecting the ethnicities we're interested in*
drop if k_ethn_dv<1
drop if k_ethn_dv>13
drop if k_ethn_dv>=5 & k_ethn_dv<=11

*Dropping observations for missing data about residence (urban/rural), highest qualification, job sector and monthly labour income*
drop if k_urban_dv<1
drop if k_hiqual_dv<1
drop if k_jbnssec5_dv<1
drop if k_fimnlabgrs_dv<1

save wh_ch_data, replace

*Generating new variables: the log of monthly labour income, binary variable for ethnicity (white=0, asian=1)*
generate log_wage=ln(k_fimnlabgrs_dv)

gen ethnicity=0
replace ethnicity=1 if k_ethn_dv==12

gen urban=0
replace urban=1 if k_urban_dv==1

gen age=k_age_dv

gen hrs_worked=k_jbhrs

gen education=1
replace education=2 if k_hiqual_dv==5
replace education=3 if k_hiqual_dv==4
replace education=4 if k_hiqual_dv==3
replace education=5 if k_hiqual_dv==2
replace education=6 if k_hiqual_dv==1

gen job_sector=1
replace job_sector=2 if k_jbnssec5_dv==4
replace job_sector=3 if k_jbnssec5_dv==3
replace job_sector=4 if k_jbnssec5_dv==2
replace job_sector=5 if k_jbnssec5_dv==1

gen job_1=0
replace job_1=1 if job_sector==1
gen job_2=0
replace job_2=1 if job_sector==2
gen job_3=0
replace job_3=1 if job_sector==3
gen job_4=0
replace job_4=1 if job_sector==4
gen job_5=0
replace job_5=1 if job_sector==5

*Generating a dummy variable that takes value 1 for asian people that match the stereotype, i.e. asian that have high education*
gen stereotype=0
replace stereotype=1 if education==6
gen stereotype_chinese=stereotype*ethnicity

*Oaxaca-Blinder decomposition*
oaxaca log_wage age urban hrs_worked education job_sector, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education job_sector stereotype, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education job_2 job_4 job_5, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education stereotype job_2 job_4 job_5, by(ethnicity) noisily

save wh_ch_data, replace

/* gen job_1=0
replace job_1=1 if job_sector==1
gen job_2=0
replace job_2=1 if job_sector==2
gen job_3=0
replace job_3=1 if job_sector==3
gen job_4=0
replace job_4=1 if job_sector==4
gen job_5=0
replace job_5=1 if job_sector==5

oaxaca log_wage age urban hrs_worked education job_2 job_4 job_5, by(ethnicity) noisily
oaxaca log_wage age urban hrs_worked education stereotype job_2 job_4 job_5, by(ethnicity) noisily
*/