## Modeling-Sale-Prices-of-Homes
# A regression analysis model with interaction was used to predict the sale price of homes. 
Aubree Thompson

Predictive Modeling of House Sale Prices

Introduction

The real estate market is complex and influenced by various factors determining a property's value. Accurate house prices are important for buyers, sellers, and investors. Understanding how different characteristics of a property influence its value and interact with each other is crucial. 

This project aims to develop a predictive model for house sale prices based on certain property features. I will utilize multiple regression analysis to create the best model for predicting house sale prices. I will explore the use of interaction terms and quadratic regression to ensure the most accurate predictions are made from this model. 

The outcome of this model can provide very valuable insight for decision-making concerning property values. 

Data Description

This dataset contains the variables bedrooms, bathrooms, living area, lot size, year built, property tax and sale price. It only contains data from houses built between the years 1948-1962. There is a total of 85 data points. 

The dataset consists of the following variables:
•	Bedrooms: Number of bedrooms in the house. (categorical)
•	Bathrooms: Number of bathrooms in the house. (categorical)
•	Living Area: Square footage of the living space. (integer)
•	Lot Size: Square footage of the lot. (integer)
•	Year Built: The year the house was built. (categorical)
•	Property Tax: Annual property tax amount. (integer)
•	Sale Price: The price at which the house was sold. (integer) 


For this project the variables sale price will be the dependent variable, and the other variables will be treated as independent variables. 

Exploratory Data Analysis

The section includes visualization of variables including boxplots (for categorical variables) and scatterplots for numerical variables. The boxplots will give insight on how to create optimal categories for the categorical variables.

	



Boxplots

The first boxplot is visualizing year built and you can tell there is a shift of sale price at the year 1953, this led me to create two categories for year built: 1948-1952 and 1953-1962. 

The second boxplot is visualizing the number of bathrooms compared to sale price. The means for 1, 1.5, and 2 are very similar but there is a large increase from 2 to 2.5. This led me to create the categories 1, 1.5, 2, and 2.5+ for bathrooms. 

The third boxplot is visualizing number of bedrooms compared to sale price; each of these plots are like I just followed the categories given of 3,4, and 5. 

Scatterplots
 

There is a linear relationship between property tax and sale price and living area and sale price. Although it seems that there is a lot of randomness in both plots, so it is difficult to say how strong the relationships are. The line the scatterplot of lot size and sale price is almost completely flat, indicating there is not a relationship between lot size and sale price. 

The number of values of 6000 for lot size is extremely high, which causes concern about data legitimacy.

Regression Analysis

For this section of the project, I will compare the R2 values between sale price and each of the independent variables to see which ones will optimize my model. These R2 values allow us to know how much of the variability of sale price is affected by a certain variable; this ranges from 0 to 1 where a value close to 1 means there is strong predictive capability of a certain independent variable for sale price. After this, I will perform stepwise regression to validate these results. Then I will include interaction terms if there are any that are significant. I will then choose three of my best models to perform residual analysis on to ensure model optimization. 

	R2 Values
	Here are the following R2 values of each independent variable against sale price:
	
R-squared for living area: 0.2941124
R-squared for lot size: 0.004549647
R-squared for property tax: 0.1057611
R-squared for bedrooms: 0.03040917
R-squared for bathrooms: 0.3614805
R-squared for year built: 0.09808558
	
The highest R2 value is 0.361, which represents the number of bathrooms predictive power on the variability of sale price. The next highest is living area, then property tax, then year built, then number of bedrooms, and then lot size. The R2 value for lot size is extremely small meaning it most likely will not be included in the model; this follows the same results as the scatterplot above. 
 	
	Variable Screening
	
Forward and backward stepwise regression was also utilized to evaluate which variables would make an optimized model. 

Here are the results: 

	Forward selection: 
	
Stepwise Summary                                
-----------------------------------------------------------------------------------------------------------
Step    Variable          AIC             SBC         SBIC                 R2         Adj. R2 
-----------------------------------------------------------------------------------------------------------
 0      Base Model      2128.157    2133.042    1885.627    0.00000    0.00000 
 1      living_area     2100.551    2107.879    1858.341    0.29411    0.28561 
 2      year_group      2086.793    2096.564    1845.177    0.41356    0.39926 
 3      bathrooms1      2082.358    2094.572    1841.210    0.45632    0.43618 
 4      bathrooms2      2083.136    2097.792    1842.151    0.46408    0.43729 
 5      bathrooms1.5    2079.732    2096.830    1839.585    0.49710    0.46527 
 6      bedrooms3       2080.265    2099.806    1840.558    0.50570    0.46768 

	
Backward elimination:

  Stepwise Summary                               
---------------------------------------------------------------------------------------

Step    Variable        AIC               SBC          SBIC           R2       Adj. R2 
----------------------------------------------------------------------------
 0      Full Model    2100.263    2124.690    1861.147    0.40333    0.34052 
 1      bedrooms3     2098.265    2120.249    1858.911    0.40332    0.34908 
 2      bedrooms4     2096.270    2115.812    1856.679    0.40328    0.35738 
 3      lot_size           2094.748    2111.847    1854.848    0.39992    0.36194
---------------------------------------------------------------------------------------


Interpretation:  Since the stepwise regression treats the dummy variables for the categorical variables as regular variables it is a little different than the conclusion from the R2 values. However, the rankings of just the numerical variables coincides with the R2 findings. 

Overall conclusion: Based off these findings an optimized model with no interaction would include the variables bathrooms, living area, year built, property tax, and bedrooms. Lot size will be omitted from the model due to its lack of relationship with sale price. 

Variable Selection and Model Building

Based off the R2 values an optimized model without interaction would include bathrooms, living area, property tax, and year built. Since the R2 value for bedrooms is low but not extremely low I will compare a model with and without the bedroom’s variables:

Without bedrooms:

Coefficients:
                           Estimate            Std. Error        t value   Pr(>|t|)    
(Intercept)        -7.101e+06        3.809e+06      -1.864      0.066023 .  
bathrooms1      -9.589e+04        2.520e+04      -3.806      0.000280 ***
bathrooms1.5   -7.741e+04        2.834e+04      -2.731      0.007801 ** 
bathrooms2      -5.051e+04        1.856e+04      -2.722      0.008011 ** 
living_area        5.706e+01         1.495e+01       3.818      0.000268 ***
year_built          3.792e+03        1.948e+03       1.947      0.055127 
property_tax     1.813e+00         2.900e+00       0.625      0.533784    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 47780 on 78 degrees of freedom
Multiple R-squared:  0.4981,	Adjusted R-squared:  0.4595 
F-statistic:  12.9 on 6 and 78 DF,  p-value: 4.497e-10

With bedrooms:

Coefficients:
                               Estimate          Std. Error       t value.      Pr(>|t|)    
(Intercept)           -6.182e+06        3.892e+06      -1.588      0.116394    
bathrooms1         -9.937e+04        2.534e+04      -3.922      0.000191 ***
bathrooms1.5      -7.940e+04        2.873e+04      -2.764      0.007162 ** 
bathrooms2         -5.433e+04        1.877e+04       -2.895     0.004942 ** 
living_area            6.511e+01        1.600e+01       4.068      0.000115 ***
year_built              3.308e+03       1.991e+03        1.661      0.100820    
property_tax          1.841e+00       2.918e+00        0.631      0.529901    
bedrooms3             2.697e+04       1.928e+04       1.399       0.165994    
bedrooms4             1.443e+04       1.604e+04       0.899       0.371291    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 47790 on 76 degrees of freedom
Multiple R-squared:  0.5109,	Adjusted R-squared:  0.4594 
F-statistic: 9.923 on 8 and 76 DF,  p-value: 2.412e-09

Conclusion: The model is significant with or without the bedrooms variable and including the bedroom variable only increases the R2 value by .02. Since we don’t need the bedrooms variable the most optimized model without interaction is:

Sale prices regressed on: bathrooms1 + bathrooms1.5 + bathrooms2 + living area + year built + property tax 

This model produces an R2 value of 0.4981.

Model Building with Interaction

	Most Significant Interactions:
	
	
Variable Interactions	 R2 
Living area and property tax	0.272876
Living area and bathrooms	0.218717
Property tax and bathrooms	0.212851


	


New Model with Interaction

Model 1

Sale prices regressed on: bathrooms1 + bathrooms1.5 + bathrooms2 + living area + year built + property tax + living area * property tax + living area * bathrooms + property tax * bathrooms 

This model produces an R2  value of 0.5884.

To prepare for residual analysis I will prepare two other optimized models:

Model 2

Sale prices regressed on: bathrooms1 + bathrooms1.5 + bathrooms2 + living area + year built + property tax +bedrooms3+bedrooms4+ living area * property tax + living area * bathrooms + property tax * bathrooms 

The model includes the dummy variables for bedrooms, which was previously deemed unnecessary. It produces an R2  value of 0.6157. 

	Model 3
Sale prices regressed on: bathrooms1 + bathrooms1.5 + bathrooms2 + living area + year built + property tax + bedrooms3 + bedrooms4+ living area * property tax + living area * bathrooms 

This model includes the dummy variables for bedrooms and does not have interaction of property tax and bathrooms. This model produces an R2 value of 0.5808.


Model Interpretation

Model 2 may be preferred as it has the highest R2 value, however it not much larger than that of Model 1 and Model 3. Model 3 is the simplest and it’s R2 value is only 0.0349 less than Model 2. 

Between Model 1 and Model 3, Model 1 has a higher R2 value, which shows that interaction between property tax and bathrooms is more significant than the number of bedrooms. 

Model 1 is to be preferred as it doesn’t include any insignificant independent variables and it’s R2 value is only .0273 less than Model 3. 

	




Model Coefficients

The following applies to all models: 

B1 represents the different in sale price between a house with one bathroom and a house with 2.5+ bathrooms. B2 represents the difference in sale price between a house with 1.5 bathrooms and a house with 2.5+ bathrooms. B3 represents the difference in sale price between a house with 2 bathrooms and house with 2.5+ bathrooms. B7 represents the difference in price between a house with 3 bedrooms and a house with 5 bedrooms. B8 represents the difference in price between a house with 4 bedrooms and a house with 5 bedrooms. 
	
	Model 1
	
	E(y)=213900-37410x1-895200x2+167800x3+131.7x4-41640x5-12.37x6+5637x4x6-55.62x1x4-45.95x2x4-131x3x4+12.37x1x6+165.9x2x6+3.454x3x6

	 Model 2

E(y)=139000+5326x1-841800x2+204300x3+157.6x4-4289x5-12.55x6+3894x7+2981x8+0.006096x4x6-79.38x1x4-489.7x2x4-151.2x3x4+11.78x1x6+165.3x2x6+3.214x3x6

Model 3

E(y)=61070+76610x1+353200x2+220100x3+182.8x4-43820x5-2.040x6+3.9770x7+29670x8+.00235x4x6-65.23x1x4-251.3x2x4-143.4x3x4
 	 	 


Interpretation

For each model, when plotting the residuals against the fitted values, they are very tightly fit around the 0 line. There is a lot of variation, and the points stray from the reference zero line. This could cause limitations for model optimization. The only model with residual outliers larger than the average is model 2, say if these points were data misinput they could be removed thus giving the model a higher R2 value – thus the model would fit better. Overall, the errors look normally distributed. 

	Checking for Omission of Important Variables
	Partial Regression for Lot Size 



Lot size does not add anything valuable to the model and is not important. It should be omitted. All other partial regression plots revealed linear relationships with sale price. 



Limitations

It appears there is non -linearity in the regression function as the residuals don’t follow tightly around the reference line of zero. However, when I did individual partial regression plots no quadratic or cubic relationships were revealed. There are also limitations with the data set. There are only 85 data points, the year built only ranges from 1948-1962, and the bedrooms only range from 3-5. This doesn’t represent the overall real estate market effectively. Also, for the lot size variable there are many values of 6000, an unusual amount. Perhaps this could be a default value and take the place of missing values. 

Discussion

I believe model 2 is the most optimized model, in terms of R2 . However, the outliers in its residual boxplot led me to think otherwise. Although, there are already errors with this data, so it would be plausible these points have reason for removal. If these points were removed the R2 value would be even higher, as the model would fit better. Although if these points could not be removed then model 1 is the most optimized because it has more normally distributed errors and has a higher R2 than model three. 

Conclusion

Overall, I don’t think this dataset has the appropriate capabilities of creating an accurate predictive model of house sale prices. However, it still does give valuable insight into the real estate market. This is my final optimized model (model 1) for sale price prediction: Sale prices regressed on: bathrooms1 + bathrooms1.5 + bathrooms2 + living area + year built + property tax + living area * property tax + living area * bathrooms + property tax * bathroom. From this dataset, we can conclude these are the most powerful predictors for a house’s sale price. It provides an R2 of 0.5885 and an R2 adjusted of 0.5131 




 



