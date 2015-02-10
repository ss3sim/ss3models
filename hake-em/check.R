species <- "hake"

original_files <- list.files()
file.copy(paste0("../", species, "-om/", species, "OM.dat"),
  paste0(species, "EM.dat"))

system.time(system("ss3_24o_opt"))
# system.time(system("ss3_24o_safe"))

# x <- r4ss::SS_output(dir = ".")
# r4ss::SS_plots(x, png = TRUE)

files <- list.files()
files <- files[-which(files %in% original_files)]
unlink(files)
