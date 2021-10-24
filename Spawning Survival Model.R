time_step=16
females=1000
#hold=1
#pspawn=2
#fspawn=3
#absorb=4

###Discharge Spawning Sub-Model

#this submodel will determine what stage of spawning a female is in reference to discharge rate, this will than be extrapolated across the 16 spawning time steps 

#the first action will be setting up the discharge rate for each time step, the mean and sd come from the observed value in the field 
discharge=rnorm(n=time_step,mean = 22000,sd=6000)

#the spawn_discharge model will begin by making the submodel a function of discharge. 
spawn_discharge=function(discharge){
  #the first fart of the function will be a series possible spawning actions that a female can take. The probability of each spawning variation occuring with change depending on the discharge rate. This is listed below
      #discharge <17000 cfs: prob of hold=0.5, psawn=0.15, fspawn=0.1, reabsorb=0.25
      #17000 cfs < discharge < 22000: prob of hold=0.4, psawn=0.25, fspawn=0.25,               reabsorb=0.1
      #22000 cfs < discharge < 27000: prob of hold=0.3, psawn=0.15, fspawn=0.45,               reabsorb=0.1
      #discharge > 27000: prob of hold=0.2, psawn=0.1, fspawn=0.6, reabsorb=0.1
  
  
  probs_d_17=c(0.5,0.15,0.1,0.25)
  samples_d_17=sample(1:4,size = females,replace = TRUE,prob = probs_d_17)

  
  probs_d_17_22=c(0.4,0.25,0.25,0.1)
  samples_d_17_22=sample(1:4,size = females,replace = TRUE,prob = probs_d_17_22)
  
  probs_d_22_27=c(0.3,0.15,0.45,0.1)
  samples_d_17_22=sample(1:4,size = females,replace = TRUE,prob = probs_d_22_27)
  
  probs_d_27=c(0.2,0.1,0.6,0.1)
  samples_d_27=sample(1:4,size = females,replace = TRUE,prob = probs_d_27)

  #following the run of a single time step that determines the spawning time of each female then the function with be looped over the 16 time steps for the entire spawning season
  matrix_spawn_d=matrix(data = NA,nrow=females,ncol = time_step)
  for (i in 1:time_step) {
    
      
  }
}



###Temperature Spawning Sub-Model

#this submodel will determine what potential stage of spawning a female is in reference to temperatuer. This will than be determined for all 16 time steps. 

#this first action will be to create the temperature profile for the 16 time steps pulled from field data
temp=rnorm(n=time_step,mean = 23,sd=4)
temp
#the first fart of the function will be a series possible spawning actions that a female can take. The probability of each spawning variation occuring will change depending on the temperature during the time step. The probabilities are listed below
  #Temp <22: prob of hold=0.6, psawn=0.1, fspawn=0, reabsorb=0.3
  #22 < temp < 25: prob of hold=0.5, psawn=0.3, fspawn=0.1, reabsorb=0.1
  #25 cfs < temp < 27: prob of hold=0.2, psawn=0.3, fspawn=0.4, reabsorb=0.1
  #temp > 27: prob of hold=0.1, psawn=0.3, fspawn=0.55, reabsorb=0.05

probs_t_22=c(0.6,0.1,0.0,0.3)
samples_t_22=sample(1:4,size = females,replace = TRUE,prob = probs_t_22)

probs_t_22_25=c(0.5,0.3,0.1,0.1)
samples_t_22_25=sample(1:4,size = females,replace = TRUE,prob = probs_t_22_25)

probs_t_25_27=c(0.2,0.3,0.4,0.1)
samples_t_25_27=sample(1:4,size = females,replace = TRUE,prob = probs_t_25_27)

probs_t_27=c(0.1,0.3,0.55,0.05)
samples_t_27=sample(1:4,size = females,replace = TRUE,prob = probs_t_27)


#following the run of a single time step that determines the spawning time of each female then the function with be looped over the 16 time steps for the entire spawning season
spawn_temp=function(temp){
  
}




###Presence/Absence Spawning Sub-Model

#this submodel will determine if a female can spawn if males are present. This will than be determined for all 16 time steps. 
males=rbinom(n=time_step,1,prob = 0.7)
#if the males are not present then a female will not spawn. If the males are present than a female has a 0.8 probability of spawning. This will then be looped for determing the spawning action of spawn or no spawn for all females for all time steps. 

probs_m=c(0.2,0.8)
samples_m=sample(0:1,size = females,replace = TRUE,prob = probs_m)
samples_m
spawn_males=function(males){
  
}




###Combined Spawning Model

#the final spawning funciton with combine the results of all three spawning sub-models. Of the two models that control type of spawn (temp and discharge) the lowest spawning action will occur. For example, if temp determined the female would full spawn but discharge determined it would hold, than the female will hold. If one of the models stated tha the female would reabsorb, then the female reabsorbs and she is removed from the model. 
#factoring in the male portion of the model is the part I am struggling with. If the female can spawn from the male model then whatever action is determined from the other two submodels will occur. However if the male model determines it will not spawn then the female will hold irregardless of the other models (unless the action was to reabsorb) 
spawn_final=function(spawn_males,spawn_discharge,spawn_temp){
  
}



###Survival Model

#this model determines the survival and total quantity of eggs based of the spawn final function output and the temp and discharge for each time step. Holding and reabsorbing will both produce 0 eggs. Partially spawning will resort in 100,000 eggs, while fully spawning will result in 400000 (mean ovargy quantities collected from the field). 
#once the model produces the total number of eggs for each time step then the survival portion of the model will ensue. 
#survival for each time step will be determine based on literature for temperature and discharge.

##Outputs/Purpose

#the outputs of the model will be the total number of eggs produced per time step. The interactions observed will be that between total eggs survived and temp/discharge. While eggs may have a higher survival rate for a specific time step, there may be less spawning activity for that same time step. Thus there may be an unknown interaction that occurs due to temperature and disrcharge on the total number of offspring that are produced. 
