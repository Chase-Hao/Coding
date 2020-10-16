an=function(ret,b){
  for (i in 1:nrow(ret)){
    for(j in 1:nrow(b)){
        if(ret[i,'yid']==b[j,'yid']){
          if(ret[i,'rt']<b[j,'10%']){
            ret[i,'pid']=1
          }
          if(ret[i,'rt']>=b[j,'10%']&ret[i,'rt']<b[j,'20%']){
            ret[i,'pid']=2
          }
          if(ret[i,'rt']>=b[j,'20%']&ret[i,'rt']<b[j,'30%']){
            ret[i,'pid']=3
          }
          if(ret[i,'rt']>=b[j,'30%']&ret[i,'rt']<b[j,'40%']){
            ret[i,'pid']=4
          }
          if(ret[i,'rt']>=b[j,'40%']&ret[i,'rt']<b[j,'50%']){
            ret[i,'pid']=5
          }
          if(ret[i,'rt']>=b[j,'50%']&ret[i,'rt']<b[j,'60%']){
            ret[i,'pid']=6
          }
          if(ret[i,'rt']>=b[j,'60%']&ret[i,'rt']<b[j,'70%']){
            ret[i,'pid']=7
          }
          if(ret[i,'rt']>=b[j,'70%']&ret[i,'rt']<b[j,'80%']){
            ret[i,'pid']=8
          }
          if(ret[i,'rt']>=b[j,'80%']&ret[i,'rt']<b[j,'90%']){
            ret[i,'pid']=9
          }
          if(ret[i,'rt']>=b[j,'90%']){
            ret[i,'pid']=10
          }
        }
      }

    }
  ret
}


nn=an(return,b)
##删除上市第一年的return数据
del=function(d){
  a=c()
  sdate=min(d$dt)+366
  for(i in 1:nrow(d)){
    if(is.na(d[i,'dt'])){
      d[i,'dt']=0
    }
    if(d[i,'dt']<sdate){
      a=c(a,i)
    }
  }
  d=d[-a,]
}
tt=del(tt)
del=function(d){
  a=c()
  sdate=min(d$dt)+years(1)
  if(is.na(sdate)){
    a=d['com']
  }

}
rt=ddply(newrt,.(com), del)

rt=del(rt)


rt$mon=as.yearmon(rt$dt)
tt$mom=0
mom=function(d){
  for(i in 1:nrow(d)){
    f1=d[i,'mon']
    f2=f1-1
    s=0
    for(j in 1:nrow(d)){
      if(d[j,'mon'] < f1 && d[j,'mon'] >= f2){
       s=s+d[j,'rt']
      }
    }
  d[i,'mom']=s
  }
  return(d)
}
tt=mom(tt)
tt=ddply(rt,.(com), mom)
test=na.omit(test)

library(sqldf)
tran=na.omit(tran)
tran=sqldf('select * from tran where ii= 1')
tran$year=substr(tran$dt, 1,4)
ss=ddply(tran, .(com),.fun = function(xx){a=sqldf('select com,year,sum(money) from xx group by year order by year desc')})
write.csv(ss, file='X:/ss.csv')
