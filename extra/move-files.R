setwd("../inst")
m <- list.files()
ty <- c("om", "em")
for (i in m) {
  for (j in ty) {
    setwd(paste0(i, "/", j))
    f <- list.files()
    ctl_file <- f[grepl("*\\.ctl", f)]
    if (!file.exists("ss3.ctl")) { # already done?
      if (j == "om") dat_file <- f[grepl("*\\.dat", f)]
      system(paste("git mv", ctl_file, "ss3.ctl"))
      if (j == "om") system(paste("git mv", dat_file, "ss3.dat"))
    }
    if (!file.exists("README.md")) {
      system("touch README.md")
    }
    if (!file.exists("README.Rmd")) {
      system("touch README.Rmd")
    }
    setwd("../../")
  }
}
