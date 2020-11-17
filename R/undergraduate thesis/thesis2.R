
winsor=function(tb,col){
  li=lim(tb,col)
  a=c()
  for(i in 1:nrow(tb)){
    if(tb[i,col]<li[1]||tb[i,col]>li[2]){
      a=c(a,i)
    }
  }
  tb=tb[-a,]
}

lim=function(tb,col){
  li=quantile(tb[,names(tb)==col], probs=c(0.01,0.99))
  li
}
lim(allr,"roe")
lim(allr,"gpa")
test=winsor(allr,"roe")
test=winsor(test,"roa")
test=winsor(test,"gpa")

##allr test,rt
library(plyr)
quan <- function(x){
  z <- ddply(x, .(year), .fun = function(xx){
    quantile(xx$size,prob = seq(from =0, to=1, by=0.1))
  })
  return(z)
}

b=quan(tt4)

sort=function(tb,col,rid){
  for (i in 1:nrow(tb)){
    for(j in 1:nrow(b)){
      if(tb[i,'year']==b[j,'year']){
        if(tb[i,col]<b[j,'10%']){
          tb[i,rid]=1
        }
        if(tb[i,col]>=b[j,'10%']&tb[i,col]<b[j,'20%']){
          tb[i,rid]=2
        }
        if(tb[i,col]>=b[j,'20%']&tb[i,col]<b[j,'30%']){
          tb[i,rid]=3
        }
        if(tb[i,col]>=b[j,'30%']&tb[i,col]<b[j,'40%']){
          tb[i,rid]=4
        }
        if(tb[i,col]>=b[j,'40%']&tb[i,col]<b[j,'50%']){
          tb[i,rid]=5
        }
        if(tb[i,col]>=b[j,'50%']&tb[i,col]<b[j,'60%']){
          tb[i,rid]=6
        }
        if(tb[i,col]>=b[j,'60%']&tb[i,col]<b[j,'70%']){
          tb[i,rid]=7
        }
        if(tb[i,col]>=b[j,'70%']&tb[i,col]<b[j,'80%']){
          tb[i,rid]=8
        }
        if(tb[i,col]>=b[j,'80%']&tb[i,col]<b[j,'90%']){
          tb[i,rid]=9
        }
        if(tb[i,col]>=b[j,'90%']){
          tb[i,rid]=10
        }
      }
    }
    
  }
  tb
}

#t5-t6除去上市第一年
#t6winsor各个变量

  tt4=sort(tt4,"mv","mvid")
ttt=merge(tt,test,by="id",all.tt=TRUE)
ttt=merge(ttt,mv,by="id",all.ttt=TRUE)
ttt=merge(tt,three,by="yid",all.x=TRUE)
ttt=merge(ttt,subset(newmv,select=-c(com,hy,dt,mv), by="id",all.x=TRUE))
t5$gpa=t5$profit/t5$asset
t5$bm=t5$equity/t5$asset
names(ttt)[names(ttt)=='endmv']='mv'
ttt$bm=ttt$equity/ttt$mv
ttt=winsor(ttt,"bm")
ttt$rt=ttt$rt/100
fpmg <- pmg(rt~gpa, ttt, index=c("yid"))
library(plm)
fpmg <- pmg(rt~gpa+log(mv)+log(bm)+mom+mv*gpa, test, index=c("yid"))

tt1=sqldf('select * from tt where yid="200610"')
a=t(data.frame(regression=coefficients(lm(rt~gpa+log(mv)+log(bm)+mom, tt1))))
summary(fpmg)
#求每个回归中的系数

  coe<- ddply(tt3, .(yid), .fun = function(xx){
    a=t(data.frame(regression=coefficients(lm(rt~gpa+log(mv)+log(bm)+mom, xx))))
  })
  coe<- ddply(tt, .(gpaid), .fun = function(xx){
    a=t(data.frame(regression=coefficients(pmg(rt~gpa+log(mv)+log(bm)+mom, test, index=c("yid")))))
  })
  coe<- ddply(tt1, .(gpaid), .fun = function(xx){
    a=t(data.frame(regression=coefficients(lm(rt~mrf+smb+hml,xx))))
  })
#画图
  #直方图
ggplot(coe, aes(lnmv)) +geom_histogram(bins=40)

ggplot(coe, aes(x=yid, y=lnmv,group=1))+geom_point()
coe$yid=as.character(coe$yid)
ggplot(tt1, aes(x=gpa, y=rt,group=1))+geom_point()
  ##三因子模型回归

ss=data.frame(summary(lm(rt~mrf+smb+hml,tt2))$coefficients)
coe<- ddply(tt1, .(gpaid), .fun = function(xx){
  a=ss=data.frame(summary(lm(rt~mrf+smb+hml,xx))$coefficients)
})



##论文其他部分
  ##样本描述
library(lubridate)
rt$year=year(rt$dt)
sqldf('select year, count(distinct com) num_of_com from rt group by year')
summary(tt1)
sd(tt1$gpa)
##portfolio characteristics描述
c(mean(tt3$gpa),mean(tt3$roe),mean(tt3$roa),mean(log(mv)),mean(bm),mean(mom))
library(plyr)
library(sqldf)
tt3$size=log(tt3$mv)
sqldf('select avg(gpa) gpa, avg(roe) roe,avg(roa) roa,avg(mv) mv, avg(bm) bm, avg(mom) mom from tt3 group by gpaid')
bmg=sqldf('select avg(bm),gpaid from tt3 group by gpaid')
amg=sqldf('select avg(bm),roaid from tt3 group by roaid')
emg=sqldf('select avg(bm),roeid from tt3 group by roeid')
write.csv(bmg,file="X:/bmg.csv")
write.csv(amg,file="X:/amg.csv")
write.csv(bmg,file="X:/emg.csv")
##每组做三因子回归
##每月rt求平均
rm(c,t,a,b)
c=data.frame()
for(i in 1:10){
  t=sqldf(paste('select sum(rt*mv)/sum(mv) avgrt,* from t4 where roaid=',i,'group by yid'))
  print(mean(t$avgrt))
  a=summary(lm(avgrt~mrf+smb+hml,t))
  b=data.frame(a$coefficients)
  b$avg=mean(t$avgrt)
  c=rbind(c,b)
}
##t=sqldf(paste('select avg(rt) avgrt,* from tt3 where roeid=',i,'group by yid'))
write.csv(c,file='X:/roeth.csv')
##第二种方法不推荐
coo=ddply(tt3,.(gpaid),.fun=function(x){

  a=summary(lm(rt~mrf+smb+hml,x))
  b=data.frame(a$coefficients)
})
##拼接
roeth$val=paste(roeth$Estimate,"[",roath$t.value,"]",sep = '')
write.csv(roeth,file='X:/roeth.csv')
##保留两位小数
options(digits = 3)
coo=subset(coo,select = -c(val))
##求平均回报

mm=sqldf('select avg(rt) avgrt, roaid from tt3 group by roaid')

##求high-low回归
tsmall=sqldf('select avg(rt) smallrt, yid from tt3 where roaid=1 group by yid')
tbig=sqldf('select avg(rt) bigrt, yid, mrf, smb, hml from tt3 where roaid=10 group by yid')
mean(tbig$bigrt-tsmall$smallrt)
b_sub_s=merge(tsmall,tbig,by='yid',all=TRUE)
summary(lm(bigrt-smallrt~mrf+smb+hml,b_sub_s))

##return分正负求
library(sqldf)
library(plm)
positive=sqldf('select * from tt3 where rt>0')
fpmg <- pmg(rt~gpa+log(mv)+log(bm)+mom+log(mv)*gpa+bm*log(mv), tt4, index=c("yid"))
fpmg <- pmg(rt~log(mv)+mom+(log(tt3$mv)-mean(log(tt3$mv)))*(tt3$gpa-mean(log(tt3$gpa))), tt3, index=c("yid"))
summary(fpmg)
##time-serials analysis
tsmall=sqldf('select avg(rt) smallrt, yid, year from tt4 where gpaid=1  group by yid')
tbig=sqldf('select avg(rt) bigrt, yid from tt4 where gpaid=10 group by yid')
b_sub_s=merge(tsmall,tbig,by='yid',all=TRUE)

time=sqldf('select sum(bigrt), sum(smallrt),sum(smallrt)-sum(bigrt), year from b_sub_s group by year')
write.csv(time,file='X:/timegpa.csv')
#cross-section regression 
#无交叉项
fpmg <- pmg(rt~roe+log(mv)+log(bm)+mom, tt4, index=c("yid"))
summary(fpmg)

#有交叉项
fpmg <- pmg(rt~roe+log(mv)+log(bm)+mom+log(mv)*roe, tt4, index=c("yid"))
summary(fpmg)
##combine
Fama_Mac$v7=paste(Fama_Mac$`7`,"[",Fama_Mac$t7,"]",sep = '')
roeth$val=paste(roeth$Estimate,"[",roath$t.value,"]",sep = '')