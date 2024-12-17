#Final Project-Aubree Thompson

install.packages("olsrr")
library(olsrr)
library(ggplot2)

attach(data_Final)

#Exploratory data analysis and preprocessing
sapply(data_Final, typeof)

# Detect outliers in 'sale_price'
ggplot(data_Final, aes(y = sale_price)) +
  geom_boxplot(fill = "lightblue") +
  labs(title = "Boxplot of Sale Price for Outlier Detection") +
  theme_minimal()
high_price_threshold <- quantile(data_Final$sale_price, 0.95)  # Top 5% sale prices
outliers <- data_Final[data_Final$sale_price > high_price_threshold, ]
print(outliers)

# Identify specific observations with high sale prices
high_price_threshold <- quantile(data$sale_price, 0.95)  # Top 5% sale prices
outliers <- data[data$sale_price > high_price_threshold, ]

#Exploratory data analysis with numerical independent variables:
num_vars <- c("lot_size", "living_area", "property_tax", "sale_price")
for (var in num_vars[-length(num_vars)]) {  # Exclude 'sale_price' itself
  p <- ggplot(data_Final, aes_string(x = var, y = "sale_price")) +
    geom_point(color = "blue", alpha = 0.6) +
    geom_smooth(method = "lm", color = "red", se = FALSE) +
    labs(title = paste("Sale Price vs.", var), x = var, y = "Sale Price") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
  print(p)
}


#number of bedrooms and bathrooms are going to be categorical
#viewing best categories for bedrooms and bathrooms
boxplot(sale_price ~ bedrooms, data = data_Final,
        xlab = "Number of Bedrooms",
        ylab = "Sale Price",
        main = "Sale Price by Number of Bedrooms",
        col = "lightblue")
#bedroom categories: 3,4,5 
boxplot(sale_price ~ bathrooms, data = data_Final,
        xlab = "Number of Bathrooms",
        ylab = "Sale Price",
        main = "Sale Price by Number of Bathrooms",
        col = "lightgreen")
#bathroom categories: 1, 1.5, 2, 2.5 and more 

boxplot(sale_price ~ year_built, data = data_Final,
        xlab = "Year Built",
        ylab = "Sale Price",
        main = "Sale Price by Year Built",
        col = "pink")
#category 1: 1948-1952, category 2: 1953-1962

#creating dummy variables:
data_Final$bedrooms <- as.factor(data_Final$bedrooms)
data_Final$bathrooms <- as.factor(data_Final$bathrooms)
data_Final$year_built<-as.factor(data_Final$year_built)

data_Final$bedrooms3<-ifelse(data_Final$bedrooms == "3", 1, 0)
data_Final$bedrooms4<-ifelse(data_Final$bedrooms == "4", 1,0)
#five bedrooms is the otherwise overall

data_Final$bathrooms1<-ifelse(data_Final$bathrooms == "1", 1, 0)
data_Final$bathrooms1.5<-ifelse(data_Final$bathrooms == "1.5",1,0)
data_Final$bathrooms2<-ifelse(data_Final$bathrooms == "2",1,0)
#otherwise overall is 2.5 or more bathrooms

data_Final$year_group <- ifelse(data_Final$year_built %in% c(1948:1952), "1",
                                ifelse(data_Final$year_built %in% c(1953:1962), "0","other"))



data_Final
attach(data_Final)
#Finding R^2 for each independent variable (no interaction)
lm1<-lm(sale_price~living_area)
summary(lm1)

lm2<-lm(sale_price~lot_size)
summary(lm2)

lm3<-lm(sale_price~property_tax)
summary(lm3)

lm4<-lm(sale_price~bedrooms3+bedrooms4)
summary(lm4)

lm5<-lm(sale_price~bathrooms1+bathrooms1.5+bathrooms2)
summary(lm5)

lm6<-lm(sale_price~year_group)
summary(lm6)

cat("R-squared for living area:", summary(lm1)$r.squared, "\n")
cat("R-squared for lot size:", summary(lm2)$r.squared, "\n")
cat("R-squared for property tax:", summary(lm3)$r.squared, "\n")
cat("R-squared for bedrooms:", summary(lm4)$r.squared, "\n")
cat("R-squared for bathrooms:", summary(lm5)$r.squared, "\n")
cat("R-squared for year built:", summary(lm6)$r.squared, "\n")
#lotsize has extremely low R^2: most likely will not be included

#now doing multiple variables:
#found this to be the most optimal model without interaction or quadratic/cubic relationships
lm6<-lm(sale_price~bathrooms1+bathrooms1.5+bathrooms2+living_area+year_built+property_tax)
summary(lm6)
cat("R-squared for overall model (not including bedrooms) (no interaction or residual analysis):", summary(lm7)$r.squared, "\n")
lm7<-lm(sale_price~bathrooms1+bathrooms1.5+bathrooms2+living_area+year_built+property_tax+bedrooms3+bedrooms4)
summary(lm7)
cat("R-squared for overall model (including bedrooms) (no interaction or residual analysis):", summary(lm7)$r.squared, "\n")

#Variable Screening
data_Final <- subset(data_Final, select = -c(bedrooms, bathrooms, year_built))

#Chose sale price as the dependent variable because it is most likely to be affected by the other variables
model<-lm(sale_price~.,data=data_Final)
summary(model)
ols_step_both_p(model)

#Forward selection
ols_step_forward_p(model)

#Backward elimination
model_backwards<-lm(sale_price~.,data=data_Final[,-1])
ols_step_backward_p(model_backwards)
k=ols_step_all_possible(model_backwards, details=FALSE)
plot(k)

#above code verifies previous findings
lm9<-lm(sale_price~living_area+year_group+bathrooms1+bathrooms1.5+bathrooms2+property_tax+bedrooms3+bedrooms4)
summary(lm9)
cat("R-squared for overall model (no interaction or residual analysis):", summary(lm9)$r.squared, "\n")

#Now checking with interaction
variables <- c("bedrooms3", "bedrooms4","bathrooms1", "bathrooms1.5","bathrooms2","living_area", "lot_size", "year_group", "property_tax")
R2_values <- numeric(length(variables))
for (i in seq_along(variables)) {
  var <- variables[i]
  formula <- as.formula(paste("sale_price ~", var))
  model <- lm(formula, data = data_Final)
  R2_values[i] <- summary(model)$r.squared
  cat("R-squared for", var, ":", R2_values[i], "\n")
}

# Create a table of R-squared values
R2_results <- data.frame(
  Variable = variables,
  R_squared = R2_values
)
print(R2_results)


#the only variables that could be intertwined is living area and bathrooms and living area and bedrooms
#bedroom interaction only added .01->scraped
year_group<-as.numeric(year_group)

#chose three models: 
#currently optimized model including interaction but with no residual analysis
lm8<-lm(sale_price~bathrooms1+bathrooms1.5+bathrooms2+living_area+year_group+property_tax+I(living_area*property_tax)+I(bathrooms1*living_area)+I(bathrooms1.5*living_area)+I(bathrooms2*living_area)+I(bathrooms1*property_tax)+I(bathrooms1.5*property_tax)+I(bathrooms2*property_tax))
summary(lm8)

cat("R-squared for overall model (no residual analysis):", summary(lm8)$r.squared, "\n")
attach(data_Final)
lm9<-lm(sale_price~bathrooms1+bathrooms1.5+bathrooms2+living_area+year_group+property_tax+I(living_area*property_tax)+I(bathrooms1*living_area)+I(bathrooms1.5*living_area)+I(bathrooms2*living_area)+I(bathrooms1*property_tax)+I(bathrooms1.5*property_tax)+I(bathrooms2*property_tax)+bedrooms3+bedrooms4)
summary(lm9)
cat("R-squared for overall model (no residual analysis):", summary(lm9)$r.squared, "\n")

lm10<-lm(sale_price~bathrooms1+bathrooms1.5+bathrooms2+living_area+year_group+property_tax+I(living_area*property_tax)+I(bathrooms1*living_area)+I(bathrooms1.5*living_area)+I(bathrooms2*living_area)+bedrooms3+bedrooms4)
summary(lm10)
cat("R-squared for overall model (no residual analysis):", summary(lm10)$r.squared, "\n")
data_Final$predicted_sale_price <- predict(lm9)

# Load ggplot2 for plotting
library(ggplot2)

# Plot actual vs. predicted sale prices
ggplot(data_Final, aes(x = predicted_sale_price, y = sale_price)) +
  geom_point(color = "blue", alpha = 0.6) +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(
    title = "Actual vs. Predicted Sale Prices",
    x = "Predicted Sale Price",
    y = "Actual Sale Price"
  ) +
  theme_minimal()
#now including residual analysis:
res<-resid(lm8)
plot(fitted(lm8),res) #very random doesn't necessarily follow around the line:
abline(0,0) #error variance is decreasing with 

res9<-resid(lm9)
plot(fitted(lm9),res9)
abline(0,0)

res10<-resid(lm10)
plot(fitted(lm10),res10)
abline(0,0)

plot(lot_size,res) #very random doesn't necessarily follow around the line:
abline(0,0)
boxplot(res) #looks like three data points are outliers -> will look into later
boxplot(res9)
boxplot(res10)

qqnorm(res)
qqline(res) #has trouble following line around the mins and maxs

qqnorm(res9)
qqline(res9)

qqnorm(res10)
qqline(res10)
#Partial Regression:

# Function to get residuals of Xj regressed on other predictors
get_Xj_residuals <- function(data, Xj, predictors) {
  # Remove Xj from predictors
  other_predictors <- setdiff(predictors, Xj)
  # Create formula
  formula_Xj <- as.formula(paste(Xj, "~", paste(other_predictors, collapse = " + ")))
  # Fit model
  model_Xj <- lm(formula_Xj, data = data)
  # Obtain residuals
  residuals_Xj <- residuals(model_Xj)
  return(residuals_Xj)
}

# Function to get residuals of Y regressed on other predictors excluding Xj
get_Y_residuals <- function(data, Y, Xj, predictors) {
  # Remove Xj from predictors
  other_predictors <- setdiff(predictors, Xj)
  # Create formula
  formula_Y <- as.formula(paste(Y, "~", paste(other_predictors, collapse = " + ")))
  # Fit model
  model_Y <- lm(formula_Y, data = data)
  # Obtain residuals
  residuals_Y <- residuals(model_Y)
  return(residuals_Y)
}

# Function to plot partial regression plot for Xj
plot_partial_regression <- function(e_Xj, e_Y, Xj) {
  plot(e_Xj, e_Y,
       xlab = paste("Residuals of", Xj),
       ylab = "Residuals of Y",
       main = paste("Partial Regression Plot for", Xj),
       pch = 19, col = "blue")
  # Add regression line
  abline(lm(e_Y ~ e_Xj), col = "red", lwd = 2)
}

# List of all predictors in your model
predictors <- c("bedrooms3", "bedrooms4","bathrooms1", "bathrooms1.5","bathrooms2","living_area", "lot_size", "year_group", "property_tax")

# Response variable
Y <- "sale_price"

# Loop over each predictor
for (Xj in predictors) {
  # Get residuals of Xj regressed on other predictors
  e_Xj <- get_Xj_residuals(data_Final, Xj, predictors)
  
  # Get residuals of Y regressed on other predictors excluding Xj
  e_Y <- get_Y_residuals(data_Final, Y, Xj, predictors)
  
  # Plot partial regression
  plot_partial_regression(e_Xj, e_Y, Xj)
  
  # Pause between plots
  readline(prompt = "Press [enter] to continue to the next plot...")
}





