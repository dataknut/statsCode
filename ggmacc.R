# test ggmacc - marignal abatement curves
# https://github.com/aj-sykes92/ggmacc

#devtools::install_github("aj-sykes92/ggmacc")
# also needs colours from https://github.com/G-Thomson/Manu
#devtools::install_github("G-Thomson/Manu")

library(dplyr)
library(ggplot2)
library(ggmacc)
library(Manu)

social_cost_of_carbon <- 66.1

full_macc <- uk_agroforestry %>%
  ggmacc(abatement = co2_tyear, mac = mac_gbp_tco2, fill = crop, cost_threshold = social_cost_of_carbon,
         zero_line = TRUE, threshold_line = TRUE, threshold_fade = 0.3)

full_macc

full_macc +
  scale_x_continuous(labels = scales::number_format()) +
  scale_fill_manual(values = Manu::get_pal("Kea")) +
  labs(title = "Marginal abatement cost curve for UK agroforestry",
       fill = "Crop type",
       x = expression("Abatement (tonnes CO"[2]*"-eq)"),
       y = expression("Marginal abatement cost (GBP tonne CO"[2]*"-eq"^{-1}*")")
  ) +
  theme_classic()

small_example %>%
  macc_prep(mac = mac, abatement = abatement) %>%
  ggplot() +
  geom_macc(fill = cat)
