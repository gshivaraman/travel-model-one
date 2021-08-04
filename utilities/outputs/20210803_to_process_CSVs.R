
source("JoinSkimsStr.R", encoding = "UTF-8")

setwd("2015_TM152_STR_T8")

JoinSkimsStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, "walktime", "wait", "IVT", "transfers", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")

print(gc())

setwd("..")

setwd("2015_TM152_IPA_16_NB")

JoinSkimsStr(fullrun=TRUE, iter=4, sampleshare=0.5, logrun=TRUE, "walktime", "wait", "IVT", "transfers", "boardfare", "faremat", "xfare", "othercost", "distance", "dFree", "dInterCity", "dLocal", "dRegional", "ddist", "dFareMat")

print(gc())

setwd("..")
