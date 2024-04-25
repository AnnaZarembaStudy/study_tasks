#DF
simulation <- data.frame(subjects = seq(1, 200))
simulation$arm <- ifelse(simulation$subjects <= 100, "A", "B")
set.seed(201)
simulation$ct_d0 <- sample(5:30, nrow(simulation), replace = TRUE)
simulation$ct_d2 <- sample(10:45, nrow(simulation), replace = TRUE)
simulation$ct_d4 <- sample(15:60, nrow(simulation), replace = TRUE)
print(simulation)
#Mean and SD
summary_stats <- aggregate(cbind(ct_d0, ct_d2, ct_d4) ~ arm, data = simulation, FUN = function(x) c(mean = mean(x), sd = sd(x)))
View(summary_stats)