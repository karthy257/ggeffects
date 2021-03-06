if (suppressWarnings(
  require("testthat") &&
  require("ggeffects") &&
  require("sjlabelled") &&
  require("survey") &&
  require("sjstats") &&
  require("sjmisc")
)) {
  context("ggeffects, survey")

  # svyglm -----

  data(nhanes_sample)

  nhanes_sample$total <- dicho(nhanes_sample$total)

  # create survey design
  des <- svydesign(
    id = ~SDMVPSU,
    strat = ~SDMVSTRA,
    weights = ~WTINT2YR,
    nest = TRUE,
    data = nhanes_sample
  )

  # fit negative binomial regression
  fit <- svyglm(total ~ RIAGENDR + age + RIDRETH1, des, family = binomial(link = "logit"))

  test_that("ggpredict, svyglm", {
    ggpredict(fit, "age")
    ggpredict(fit, c("age", "RIAGENDR"))
  })

  test_that("ggeffect, svyglm", {
    ggeffect(fit, "age")
    ggeffect(fit, c("age", "RIAGENDR"))
  })
}
