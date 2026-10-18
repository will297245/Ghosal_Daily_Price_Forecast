# Ghosal Daily Price Forecast
Using a modified geometric stochastic model to predict plausible price ranges at time $t+1$ using data up to time $t$



#A basic model and it's failures
When initially estimating plausible ranges for future prices of an equity, we may employ a standard Geometric Brownian motion model, carrying the form:

$$dS_t = \mu S_t dt + \sigma S_t dW_t $$

This gives us a log-normal distribution for equity prices $S_t$ at time $t$, however some underlying assumptions can greatly reduce the validity of this model.






## Independence in daily variance
For this model, we assume the variance has no conditional hetereoskedasticity. In financial market settings, this can often fail, as we see with the below example of TICKER's financial returns below

Please insert a graph of some stocks daily variance showing conditional heteroskedasticity.




## Constant Mu
This model also assumes a fixed average log change in prices. In reality, our growth rate can be significantly impacted by various factors. For example, market regimes, management changes etc can all have large influences upon the growth of a company. 

Again show a graph of some time varying growth rate company.





## Constant variance
Yap about how market crashes can cause persisting periods of clustered high volatilty










#An updated method
Instead, we will attempt to improve the model using a few steps.





##Momentum based predictor for $\mu$
We will fit a least squares regression model to $\mu$ of the following form:


$$ \mu_{t+1} = \beta_0 + \beta_1 1Dprice_change_t + \beta_2 5Dprice_change_t + (insert controls + other variables here) $$
