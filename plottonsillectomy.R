# Plot a window of weights around my tonsillectomy on 2014-06-11
# Should be sourced after getredcap.R

mytonsilDate <- as.Date("2014-06-11")
mytonsilwindow <- c(mytonsilDate-30,mytonsilDate+30)
mytonsilwindow <- as.POSIXct(mytonsilwindow)

mytonsilweightsper <- data.frame(weights=myweights$weightvalue,timeof=myweights$timeoffact.timestamp)
mybaselineweight <- mytonsilweightsper[as.Date(mytonsilweightsper$timeof)==as.Date("2014-06-11"),c("weights")]
mytonsilweightsper$weights <- mytonsilweightsper$weights / mybaselineweight * 100

png("tonsillectomy.png",width=1200,height=900,res=150)
plot(mytonsilweightsper$timeof,mytonsilweightsper$weights,
     ylim=c(80,100),xlim=mytonsilwindow,col="black",type="b",pch=18, lwd=2,
     ylab="Weight (% of weight at surgery)")
abline(h=seq(0,100,5),lty="solid",lwd=1) #150,250,10 in lbs
dev.off()
