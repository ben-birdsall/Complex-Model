Final Agent Based Model Write Up
Overview
	Purpose and patterns
The purpose of this model is to assess spawning success and recruitment potential of Asian Carp in the lower Red River system during drought and flooding years. These invasive species were recently (2012) detected in this system. However, there has been no evidence of successful spawning of these fish in the system. The purpose of this model will be to assess what habitat parameters in the catchment influence the successful recruitment of these species. 
	Entities, state variables, and scales
The agent will be a single female Silver Carp. The single state variable will be spawning action such as maintaining, partial spawning, spawning, or re-absorption of eggs. The scale will be in a single river location. Space will not be modeled but instead I will use 1 week time steps throughout a 16 week spawning season for both wet and dry years. 
	Process Overview
The model will run agents (females) through time steps of a spawning season in which the discharge and temperature will determine if a female successfully spawns. After all time steps are complete it will then determine how many eggs successfully hatched if any females successfully spawned.  
		
Design Concepts
Basic principles: the model addresses the hypothesis that the habitat in the Lower Red River causes extremely variable spawning for Bighead and Silver Carp. 
Emergence: the important results of the model is what habitat parameters influence Carp survival. 
Adaptation: the adaptive action of the agent is the multiple spawning options that it can choose to act out such as partially spawning or re-absorption. 
Objectives: the objective of the adaptive nature such as partially spawning allows for the agent to partially spawn when conditions are met but they are not the best, and allows them to spawn a second time at a later date when conditions are ideal. 
Learning: individuals do not learn from previous actions
Sensing: The agents are able to sense the water quality parameters and water velocity. This is basic ecology known of the species. 
Interaction: there is no interaction between individual agents in the model. 
Collectives: There are no collectives in this model
Observation: Outputs needed from the model will be the temperature and discharge of each time step to ensure that they are within observed levels. I will also require the final recruitment potential of each agent and the mean survival for each week. 
Details
	Sub-models
		Discharge: This will model the discharge of the river at each time step 
		Temperature: This will model the discharge of the river at each time step
Spawning: The sub-model will take each factor from the submodels listed above to determine whether a female chooses not to spawn, partially spawns, fully spawns, or re-absorbs her eggs and is removed from the model for future time steps. 
Recruitment Potential: This submodel will determine the total number of eggs that will successfully hatch if a female spawns. 

How to Run
It is pretty simple model to run. The overall model consists of 3 portions: the drought year, flood year, and data analysis. The first two models are contained within their own loops. You will need to highlight both models to run the overall survival model. If you want to run the data analysis portion you will need to read in the df csv of the outputs produced after both models are ran. 

