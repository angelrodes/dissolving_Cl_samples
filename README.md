# Dissolving samples for Chlorine 36 analysis

This script simulates the effect of evaporation on the 35Cl-36Cl-37Cl ratios in the liquid during and after the spiking and dissoultion stages.

These are the first *wet* laboratory procedures in the sample preparation for [36Cl analysis by AMS](https://doi.org/10.1016/j.nimb.2009.10.021). The carrier is usually a solution with low 36Cl content and enriched in 35Cl. The latter is used to calculate the total Cl content in the sample by [isotope dilution](https://doi.org/10.1016/j.quageo.2009.08.001).

The output looks like this:

![Output](https://raw.githubusercontent.com/angelrodes/dissolving_Cl_samples/main/output.png)

Simulations where part of the Cl is evaporated due to the heat generated during dissolution are depticte in **red**.
Simulations without evaporation are depicted in **green**. I use the green simulations as the reference for the final expected values.

This shows that adding half of your carrier before and the other half after dissolution minimises the effect of evaporation on the final 36Cl/Cl and 35Cl/37Cl ratios.

Ángel Rodés, SUERC 2018
