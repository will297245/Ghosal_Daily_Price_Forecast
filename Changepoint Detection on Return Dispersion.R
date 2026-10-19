
# ================================
# Changepoint analysis for WHO measles vaccination data
# ================================

# Install these once if needed:
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("changepoint")
#install.packages("strucchange")

library(ggplot2)
library(dplyr)
library(changepoint)
library(strucchange)








# ================================
# 1. Import data
# ================================

data <- read.csv(
  "/Users/willlodder/Desktop/Personals/Medical statistics project/Measles Vaccination Coverage.csv"
)

data <- as.data.frame(data)

print(colnames(data))





# ================================
# 2. Clean data
# ================================




data_clean <- data %>%
  mutate(
    YEAR = as.integer(YEAR),
    COVERAGE = as.numeric(COVERAGE)
  ) %>%
  filter(
    !is.na(YEAR),
    !is.na(COVERAGE)
  )







# ================================
# 3. Choose country and antigen
# ================================

# Change these if needed
country_to_use <- "Region of the Americas"
antigen_to_use <- "MCV1"

US <- data_clean %>%
  filter(
    NAME == country_to_use,
    ANTIGEN == antigen_to_use
  ) %>%
  arrange(YEAR)

# Check if filtering worked
#print(US)

if (nrow(US) == 0) {
  stop("No rows found. Check the exact NAME and ANTIGEN values in your dataset.")
}












# ================================
# 4. Initial plot of vaccination coverage
# ================================

p_initial <- ggplot(US, aes(x = YEAR, y = COVERAGE)) +
  geom_point() +
  geom_line() +
  labs(
    title = paste("Measles vaccination coverage:", country_to_use, antigen_to_use),
    x = "Year",
    y = "Coverage (%)"
  )

print(p_initial)















# ================================
# 5. Changepoint analysis: change in mean
# ================================

fit_mean <- cpt.mean(
  US$COVERAGE,
  method = "PELT",
  penalty = "MBIC",
  minseglen = 3
)

#print(fit_mean)

# Extract changepoint indices
change_indices_mean <- cpts(fit_mean)

# Convert indices to years
change_years_mean <- US$YEAR[change_indices_mean]

#print("Changepoint years for change in mean:")
#print(change_years_mean)

# Create dataframe for plotting vertical changepoint lines
change_df_mean <- data.frame(YEAR = change_years_mean)

p_mean <- ggplot(US, aes(x = YEAR, y = COVERAGE)) +
  geom_point() +
  geom_line() +
  geom_vline(
    data = change_df_mean,
    aes(xintercept = YEAR),
    linetype = "dashed"
  ) +
  labs(
    title = "Changepoint detection: change in mean coverage",
    x = "Year",
    y = "Coverage (%)"
  )

#print(p_mean)

# Segment parameter estimates
#print("Estimated segment means:")
#print(param.est(fit_mean))








# ================================
# 6. Changepoint analysis: change in mean and variance
# ================================

fit_meanvar <- cpt.meanvar(
  US$COVERAGE,
  method = "PELT",
  penalty = "MBIC",
  minseglen = 3
)

print(fit_meanvar)

change_indices_meanvar <- cpts(fit_meanvar)
change_years_meanvar <- US$YEAR[change_indices_meanvar]

#print("Changepoint years for change in mean and variance:")
#print(change_years_meanvar)

change_df_meanvar <- data.frame(YEAR = change_years_meanvar)

p_meanvar <- ggplot(US, aes(x = YEAR, y = COVERAGE)) +
  geom_point() +
  geom_line() +
  geom_vline(
    data = change_df_meanvar,
    aes(xintercept = YEAR),
    linetype = "dashed"
  ) +
  labs(
    title = "Changepoint detection: change in mean and variance",
    x = "Year",
    y = "Coverage (%)"
  )

print(p_meanvar)

#print("Estimated segment means and variances:")
#print(param.est(fit_meanvar))










# ================================
# Estimated distributions by segment
# ================================

# Changepoint indices
cpt_indices <- cpts(fit_meanvar)

# Segment start and end indices
segment_starts <- c(1, cpt_indices + 1)
segment_ends <- c(cpt_indices, nrow(US))

# Build readable segment summary table
segment_summary <- data.frame(
  segment = seq_along(segment_starts),
  start_index = segment_starts,
  end_index = segment_ends,
  start_year = US$YEAR[segment_starts],
  end_year = US$YEAR[segment_ends]
)

# Add estimated mean, variance, and standard deviation manually
segment_summary$mean_coverage <- NA
segment_summary$variance_coverage <- NA
segment_summary$sd_coverage <- NA
segment_summary$n_years <- NA

for (i in seq_len(nrow(segment_summary))) {
  
  start_i <- segment_summary$start_index[i]
  end_i <- segment_summary$end_index[i]
  
  segment_data <- US$COVERAGE[start_i:end_i]
  
  segment_summary$n_years[i] <- length(segment_data)
  segment_summary$mean_coverage[i] <- mean(segment_data)
  segment_summary$variance_coverage[i] <- var(segment_data)
  segment_summary$sd_coverage[i] <- sd(segment_data)
}



print(segment_summary)
