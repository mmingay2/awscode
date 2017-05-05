install.packages("dplyr")
install.packages("RJSONIO")
install.packages("tidyr")
install.packages("data.table")

library(dplyr)
library(RJSONIO)
library(tidyr)
library(data.table)

#Get All Pairs
#urla <- "https://api.kraken.com/0/public/AssetPairs"
urlt <- "https://api.kraken.com/0/public/Time"
pairdat <- fromJSON(urla) # returns a lis
dnames <- grep("*\\.d", pairdat$result)
pairs <- gsub(".d", "", names(pairdat$result[dnames]))
pairs <- c(pairs, "XLTCZEUR", "XLTCXXBT")
write.table(data.frame(pairs), file="/home/ec2-user/cryptodata/pairsOI.txt", col.names=F, row.names = F, quote = F, sep="\t")

pairs <- as.vector(read.table("/home/ec2-user/cryptodata/pairsOI.txt")$V1)

ncycles <- 100

for (j in 1:ncycles) {
  pmaster <- NULL
  for (i in 1:length(pairs)) {
    urlp <- paste0("https://api.kraken.com/0/public/Ticker?pair=", pairs[i])
    bs_data <- fromJSON(urlp)
    askp <- as.numeric(bs_data$result[[pairs[i]]]$a)[1]
    askv <- as.numeric(bs_data$result[[pairs[i]]]$a)[2]
    askx <- askp*askv
    bidp <- as.numeric(bs_data$result[[pairs[i]]]$b)[1]
    bidv <- as.numeric(bs_data$result[[pairs[i]]]$b)[2]
    bidx <- bidp*bidv
    price <- as.numeric(bs_data$result[[pairs[i]]]$c)[1]
    wvol <- as.numeric(bs_data$result[[pairs[i]]]$p[1])
    ntrades <- as.numeric(bs_data$result[[pairs[i]]]$t[1])
    time_data <- fromJSON(urlt)
    time <- gsub(" \\+.*", "", gsub(".*, ", "",time_data$result$rfc1123))
    pair <- pairs[i]
    temp <- data.frame(pair, time, wvol, price, ntrades, askp, askv, bidp, bidv)
    pmaster <- rbind(pmaster, temp)
  }  
  write.table(pmaster,"/home/ec2-user/cryptodata/crypto_prices_may4.txt", append = T, row.names = F, quote=F, sep="\t")
  print(paste0("Minutes Running:", (300*as.numeric(j))/60))
  Sys.sleep(300)
}
