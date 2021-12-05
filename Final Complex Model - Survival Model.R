setwd("~/GitHub/Agent-Based-Model")

#parameters for both loops
iterations=100 #repetitions of each year
time_step=16 #number of weeks

#creating matrices of the outputs of each iterations
dry_mean_prod=matrix(nrow = iterations,ncol=time_step)
dry_total_prod=matrix(nrow = iterations,ncol=time_step)
temp_dry=matrix(nrow = iterations,ncol = time_step)
dist_dry=matrix(nrow = iterations,ncol = time_step)
habitat_dry=matrix(nrow = iterations,ncol = time_step)

####dry year
#the overall dry year model for spawning and survival
for (j in 1:iterations) {
  
  #parameters for the models, include number of females, and temperture and discharge means and sd's for both drought and flood years
  time_step=16
  females=1000
  ddmn=10000
  ddsd=3000
  dwmn=18000
  dwsd=6000
  tdmn=29
  tdsd=5
  twmn=23
  twsd=7
  
  
  #creating the habitat valous for the sixteen weeks of the spawning season
  discharge=(rnorm(n=time_step,mean = ddmn, sd=ddsd))
  temp=(rnorm(n=time_step,mean=tdmn,sd=tdsd))
  habitat=round(10*(((discharge/22000)+(temp/27)/2)))
  s_tmp=round(temp)
  s_dist=round(discharge)
  
  
  spawn=matrix(nrow=females,ncol=time_step)
  
  #the spawning model that determines the spawning action of each female
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(habitat[i]>=12){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.05,0.15,0.3,0.5))
      } else if (habitat[i]>=9 & habitat[i]<12){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.1,0.2,0.3,0.4))
      } else if (habitat[i]>=7 & habitat[i]<9){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.2,0.4,0.3,0.1))
      } else if (habitat[i]<7){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.2,0.5,0.2,0.1))
      }}}
  
  
  
  
  #the production model, determines how many eggs are produced for each spwaning action
  prod=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(spawn[k,i]==4){
        prod[k,i]=400000
      } else if (spawn[k,i]==3){
        prod[k,i]=100000
      } else if (spawn[k,i]==2){
        prod[k,i]=0
      } else if (spawn[k,i]==1){
        prod[k,i]=0
      }}}
  
  #survival model based off temperature
  t_survive=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(s_tmp[i]>=12){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.5,0.3,0.1,0.1)))
      } else if (s_tmp[i]>=9 & s_tmp[i]<12){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.3,0.4,0.2,0.1)))
      } else if (s_tmp[i]>=7 & s_tmp[i]<9){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.1,0.2,0.3,0.4)))
      } else if (s_tmp[i]<7){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.0,0.0,0.2,0.8)))
      }}}
  
  #survival model based off discharge
  d_survive=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(s_dist[i]>=12){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.3,0.3,0.1,0.0)))
      } else if (s_dist[i]>=9 & s_dist[i]<12){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.4,0.3,0.2,0.1)))
      } else if (s_dist[i]>=7 & s_dist[i]<9){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.1,0.2,0.3,0.4)))
      } else if (s_dist[i]<7){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.0,0.0,0.1,0.9)))
      }}}
  
  #the final survival model, takes the lowest value of the two previous models
  f_survive=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(t_survive[k,i]<=d_survive[k,i]){
        f_survive[k,i]=t_survive[k,i]
      } else if (t_survive[k,i]>d_survive[k,i]){
        f_survive[k,i]=d_survive[k,i]
      }}}
  
  
  #the outputs from the survival model
  mean_fem_prod=numeric(time_step)
  for (i in 1:time_step) {
    mean_fem_prod[i]=mean(f_survive[,i])
  }
  
  total_fem_prod=numeric(time_step)
  for (i in 1:time_step) {
    total_fem_prod[i]=sum(f_survive[,i])
  }
  
  dry_mean_prod[j,]=mean_fem_prod
  dry_total_prod[j,]=total_fem_prod
  temp_dry[j,]=s_tmp
  dist_dry[j,]=s_dist
  habitat_dry[j,]=habitat
}


##### Wet Year

#this entire model is exactly the same as the prior, except that the habitat variables are different for a drought year
iterations=100

wet_mean_prod=matrix(nrow = iterations,ncol=time_step)
wet_total_prod=matrix(nrow = iterations,ncol=time_step)
temp_wet=matrix(nrow = iterations,ncol = time_step)
dist_wet=matrix(nrow = iterations,ncol = time_step)
habitat_wet=matrix(nrow = iterations,ncol = time_step)

for (j in 1:iterations) {
  
  time_step=16
  females=1000
  ddmn=10000
  ddsd=3000
  dwmn=18000
  dwsd=6000
  tdmn=29
  tdsd=5
  twmn=25
  twsd=7
  
  
  
  discharge=(rnorm(n=time_step,mean = dwmn, sd=dwsd))
  temp=(rnorm(n=time_step,mean=twmn,sd=twsd))
  habitat=round(10*(((discharge/22000)+(temp/27)/2)))
  s_tmp=round(temp)
  s_dist=round(discharge)
  
  
  spawn=matrix(nrow=females,ncol=time_step)
  
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(habitat[i]>=12){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.05,0.15,0.3,0.5))
      } else if (habitat[i]>=9 & habitat[i]<12){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.1,0.2,0.3,0.4))
      } else if (habitat[i]>=7 & habitat[i]<9){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.2,0.4,0.3,0.1))
      } else if (habitat[i]<7){
        spawn[k,i]=sample(c(1,2,3,4),size = 1,replace = FALSE,prob = c(0.2,0.5,0.2,0.1))
      }}}
  
  
  
  
  
  prod=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(spawn[k,i]==4){
        prod[k,i]=400000
      } else if (spawn[k,i]==3){
        prod[k,i]=100000
      } else if (spawn[k,i]==2){
        prod[k,i]=0
      } else if (spawn[k,i]==1){
        prod[k,i]=0
      }}}
  
  t_survive=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(s_tmp[i]>=12){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.5,0.3,0.1,0.1)))
      } else if (s_tmp[i]>=9 & s_tmp[i]<12){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.3,0.4,0.2,0.1)))
      } else if (s_tmp[i]>=7 & s_tmp[i]<9){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.1,0.2,0.3,0.4)))
      } else if (s_tmp[i]<7){
        t_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.0,0.0,0.2,0.8)))
      }}}
  
  d_survive=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(s_dist[i]>=12){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.3,0.3,0.1,0.0)))
      } else if (s_dist[i]>=9 & s_dist[i]<12){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.4,0.3,0.2,0.1)))
      } else if (s_dist[i]>=7 & s_dist[i]<9){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.1,0.2,0.3,0.4)))
      } else if (s_dist[i]<7){
        d_survive[k,i]=prod[k,i]*(sample(c(1.0,0.75,0.25,0.0),size = 1,replace = FALSE,prob = c(0.0,0.0,0.1,0.9)))
      }}}
  
  f_survive=matrix(nrow=females,ncol=time_step)
  for (k in 1:females) {
    
    for (i in 1:time_step) {
      
      if(t_survive[k,i]<=d_survive[k,i]){
        f_survive[k,i]=t_survive[k,i]
      } else if (t_survive[k,i]>d_survive[k,i]){
        f_survive[k,i]=d_survive[k,i]
      }}}
  
  mean_fem_prod=numeric(time_step)
  for (i in 1:time_step) {
    mean_fem_prod[i]=mean(f_survive[,i])
  }
  
  total_fem_prod=numeric(time_step)
  for (i in 1:time_step) {
    total_fem_prod[i]=sum(f_survive[,i])
  }
  
  wet_mean_prod[j,]=mean_fem_prod
  wet_total_prod[j,]=total_fem_prod
  temp_wet[j,]=s_tmp
  dist_wet[j,]=s_dist
  habitat_wet[j,]=habitat
}


###the following loops create output matrices for the previous two models 

mn_week_mean_wet=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  mn_week_mean_wet[h]=mean(wet_mean_prod[h,])
}

mn_week_mean_dry=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  mn_week_mean_dry[h]=mean(dry_mean_prod[h,])
}

tot_week_mean_wet=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  tot_week_mean_wet[h]=mean(wet_total_prod[h,])
}

tot_week_mean_dry=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  tot_week_mean_dry[h]=mean(dry_total_prod[h,])
}

dist_week_mean_dry=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  dist_week_mean_dry[h]=mean(dist_dry[h,])
}

dist_week_mean_wet=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  dist_week_mean_wet[h]=mean(dist_wet[h,])
}

tmp_week_mean_dry=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  tmp_week_mean_dry[h]=mean(temp_dry[h,])
}

tmp_week_mean_wet=matrix(nrow = iterations,ncol = 1)
for (h in 1:100) {
  tmp_week_mean_wet[h]=mean(temp_wet[h,])
}


#the final output matrix for analyzing the data

wet_year=matrix(nrow = iterations,ncol=4)
wet_year[,1]=mn_week_mean_wet
wet_year[,2]=dist_week_mean_wet
wet_year[,3]=tmp_week_mean_wet
wet_year[,4]='wet'

dry_year=matrix(nrow = iterations,ncol=4)
dry_year[,1]=mn_week_mean_dry
dry_year[,2]=dist_week_mean_dry
dry_year[,3]=tmp_week_mean_dry
dry_year[,4]='dry'

final.data=rbind(dry_year,wet_year)

outputs=data.frame(final.data)
colnames(outputs)=c('mn_prod','dist','temp','year')

write.csv(outputs,'outputs')

#if you want to analyze the data the following csv, plots, and lm's are there



df=read.csv(file.choose())


write.table(outputs,file = 'out.csv',sep = ',',row.names = FALSE)
boxplot(mn_prod~year,data = df)

plot(mn_prod~dist,data = df)
plot(mn_prod~temp,data = df)
plot(mn_prod)

mn_dist_wet.lm=lm(data=df,mn_prod[year=='wet']~dist[year=='wet'])
summary(mn_dist_wet.lm)
confint(mn_dist_wet.lm)

mn_dist_dry.lm=lm(data=df,mn_prod[year=='dry']~dist[year=='dry'])
summary(mn_dist_dry.lm)

mn_tmp_wet.lm=lm(data=df,mn_prod[year=='wet']~temp[year=='wet'])
summary(mn_tmp_wet.lm)

mn_tmp_dry.lm=lm(data=df,mn_prod[year=='dry']~temp[year=='dry'])
summary(mn_tmp_dry.lm)



