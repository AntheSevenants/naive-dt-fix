source("naive-dt-fix.R")

df <- data.frame(deelwoord = c("ingeplant", "gebeurt", "gebeurt", "gebeurd",
                               "gebeurd", "gebeurd", "gebeurd", "verandert",
                               "verandert", "veranderd", "veranderd",
                               "veranderd", "geracet", "geraced", "geraced"))

df <- fix_participle_dt(df, "deelwoord")

print(df)