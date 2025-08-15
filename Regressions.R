# Description: Regression analysis to analytically answer the research question

# Section 1: Initial Parallel Pre Trends Test ----

# Run a model regressing arrests with an interaction term between Date and Boroughs
pre_treatment_period$Date <- as.factor(pre_treatment_period$Date)
parallel_pretrends_test <- lm(Arrests ~ Date * Manhattan, data = pre_treatment_period)

# Summarize the model output
sink("../output/Parallel Pretrends Test.txt")   # Asked ChatGPT: is there a function to save a regression in txt format
print(summary(parallel_pretrends_test))
sink()

# We see statistical insignificance for Date:Manhattan, implying no differential trends in arrests
# between Manhattan and the other boroughs, parallel pre-trends holds

