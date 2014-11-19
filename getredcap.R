rm(list=ls())
library(RCurl)

source('loadToken.R')

out <- postForm("https://redcap.vanderbilt.edu/api/",
                token=myToken,
                content="record",
                type="flat",
                format="csv",
                .opts=curlOptions(ssl.verifypeer=FALSE))
write(out,file="out.csv")

mylife = read.csv("out.csv",stringsAsFactor=FALSE)
mylife$timeoffact.timestamp = as.POSIXct(mylife$timeoffact)
mylife<-mylife[order(mylife$timeoffact.timestamp),]

timespan = c(min(mylife$timeoffact.timestamp),max(mylife$timeoffact.timestamp))

myruns<-mylife[mylife$typeoffact==3,]
myruns$total<-cumsum(myruns$rundistance)
mystartrun<-min(myruns$timeoffact.timestamp)
mystartitf<-as.POSIXct("2014-07-28T07:00")

myweights<-mylife[mylife$typeoffact==2,]

png("out.png",width=1200,height=900,res=150)
# par(ann=FALSE)
plot(myweights$timeoffact.timestamp,myweights$weightvalue,
     ylim=c(150,250),xlim=timespan,col="black",type="p",pch=18,
     ylab="Weight (lbs)",xlab='')
abline(h=seq(150,250,10),lty="solid",lwd=1) #150,250,10 in lbs
par(new=TRUE)
plot(myruns$timeoffact.timestamp,myruns$total,
     ylim=c(0,300),xlim=timespan,col="red",type="s",lwd=3,yaxt='n',ann=FALSE)
abline(v=mystartrun,lwd=1,lty="dashed")
abline(v=mystartitf,lwd=1,lty="dashed")
axis(side=4)
dev.off()

# Specific special sub-analyses below
source('plottonsillectomy.R')
