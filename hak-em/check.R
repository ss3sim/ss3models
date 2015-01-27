file.copy("../hak-om/hakeOM.dat", "hakeEM.dat")
library("r4ss")
o <- SS_output(dir = ".")
SS_plots(o, png = TRUE)
