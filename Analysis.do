// Change to root 
//global base_dir "C:\Users\LENOVO\CausalInference\MainProject\causal_inference_project"
//cd "$base_dir"

use "all_data.dta", clear

// Dataset has data for all types of workers, which means duplicates,
//  so need to filter for this and for proper mergings
// (if they are not 3, there is missing data somewhere)
keep if (TypeofWorker == "Total  " & ///
         merge_taxes_1 == 3 & merge_subsidies_2 == 3 & ///
		 merge_productivity_3 == 3 & ///
         merge_capital_n_co_4 == 3 & merge_cpi_5 == 3)

		 
// correlation among variables
correlate H_EMPE VA_PI Ip_Brand Ip_Train Ip_Tang Taxes Subsidies Productivity Wages CPI
matrix corrmatrix = r(C)
// heatplot corrmatrix


histogram Wages, bin(40) 


// generating log of wages, if any
// generate log_Wages = log(Wages)


// generating dummies for year
//levelsof Year, local(years)
//foreach year of local years {
  //  generate Year_`year' = (Year == `year')
//}
// add smt else?
// Year_2021 omitted because of collinearity. - why if 2014 removed ?
reg Wages Subsidies Taxes H_EMPE VA_PI Ip_Brand Ip_Tan Productivity CPI  ///
    Year_2015 Year_2016 Year_2017 Year_2018 Year_2019 Year_2020 Year_2021 , r
	
correlate Wages Subsidies Taxes H_EMPE VA_PI Ip_Brand Ip_Tan Productivity CPI  ///
    Year_2015 Year_2016 Year_2017 Year_2018 Year_2019 Year_2020 Year_2021	
vif

// generating lagged productivity and regressing wages on it

//encode code, generate(code_numeric)
//xtset code_numeric Year
//generate Productivity_Lag1 = L.Productivity


// The regression on first lag is better than just on current productivity;
// Lags 2 and so on also show better results, but due to decreasinf number of
// observations I am not sure if that's a good idea to use them
reg Wages Productivity_Lag1


// Dummies of each industry
//levelsof code_numeric, local(codes)
//foreach code_i of local codes {
//    generate Code_num_`code_i' = (code_numeric == `code_i')
//}

label var Code_num_1 "Mining and quarrying"
label var Code_num_2 "Manufacturing"
label var Code_num_3 "Electricity, gas, steam and air conditioning supply"
label var Code_num_4 "Water supply, sewerage, waste management and remediation activities"
label var Code_num_5 "Transportation and storage"
label var Code_num_6 "Accommodation and food service activities"
label var Code_num_7 "Information and communication"
label var Code_num_8 "Professional, scientific and technical activities"
label var Code_num_9 "Administrative and support service activities"
label var Code_num_10 "Education"
label var Code_num_11 "Human health and social work activities"
label var Code_num_12 "Arts, entertainment and recreation"
label var Code_num_13 "Other service activities"




// suspiciously and unrealisticly good results, not quite sure why (one of industries is removed) !!!
reg Wages Productivity_Lag1 Code_num_2 Code_num_3 Code_num_4 Code_num_5 Code_num_6 Code_num_7 Code_num_8 Code_num_9 Code_num_10 Code_num_11 Code_num_12 Code_num_13


// strange Interactions working only with categorical variables, just test
reg Wages Productivity_Lag1 Code_num_2#Year_2020



// productivity is not meaningfull with the full regression (not robust). Some variables still are automatically dropped, I'm trying to find the interpretation of that
reg Wages Productivity_Lag1 Code_num_1 Code_num_2 Code_num_3 Code_num_4 Code_num_5 Code_num_6 Code_num_7 Code_num_8 Code_num_9 Code_num_10 Code_num_11 Code_num_12 Code_num_13 Year_2014 Year_2015 Year_2016 Year_2017 Year_2018 Year_2019 Year_2020 Year_2021 Subsidies Taxes H_EMPE VA_PI Ip_Brand Ip_Tan


// productivity is not meaningfull with the full robust regression. Some variables still are automatically dropped, I'm trying to find the interpretation of that
reg Wages Productivity_Lag1 Code_num_1 Code_num_2 Code_num_3 Code_num_4 Code_num_5 Code_num_6 Code_num_7 Code_num_8 Code_num_9 Code_num_10 Code_num_11 Code_num_12 Code_num_13 Year_2014 Year_2015 Year_2016 Year_2017 Year_2018 Year_2019 Year_2020 Year_2021 Subsidies Taxes H_EMPE VA_PI Ip_Brand Ip_Tan, r

vif //crazy collinearity
correlate Wages Productivity_Lag1 Code_num_1 Code_num_2 Code_num_3 Code_num_4 Code_num_5 Code_num_6 Code_num_7 Code_num_8 Code_num_9 Code_num_10 Code_num_11 Code_num_12 Code_num_13 Year_2014 Year_2015 Year_2016 Year_2017 Year_2018 Year_2019 Year_2020 Year_2021 Subsidies Taxes H_EMPE VA_PI Ip_Brand Ip_Tan


