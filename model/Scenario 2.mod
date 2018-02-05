#Minimise maximum Antenna utilization

#sets
set ZONES; #set of all zones
set ANTENNAS within ZONES; #set of all antennas

#parameters
param zonedemand{ZONES};#demand per zone
param zone_dist{ZONES,ZONES};#avg distance between zones
param max_trm;#max transmission capacity per antenna
param min_trm;#min transmission capacity per antenna
param max_dist;# max distance that can be transmitted

#variables
var trm_cap{ANTENNAS}<=max_trm, >=min_trm;#transmission capacity of each Antenna
var demand_alloc{ANTENNAS,ZONES}>=0;#demand allocated to each zone per antenna
var max_alloc>=0;#maximum antenna allocation
var data_loss;

#objective : to minimise maximum Antenna utilization
minimize maximum_transmission_allocation : max_alloc ;

subject to
#maximum distance transmitted
min_distance{a in ANTENNAS, z in ZONES: zone_dist[a,z] > max_dist}: demand_alloc[a,z] = 0;  

#total demand met by antennas
tot_demand{z in ZONES}: sum{a in ANTENNAS}demand_alloc[a,z]>= zonedemand[z]; 
 
#transmission capacity enough to meet demand
capacity_reqr{a in ANTENNAS}: trm_cap[a]>= sum{z in ZONES}demand_alloc[a,z];

#total traffic transmitted to an Antenna below 40% of the total network transmission capacity 
max_antenna_cap{a in ANTENNAS}: sum{z in ZONES}demand_alloc[a,z]<= 0.4*sum{i in ANTENNAS}trm_cap[i];

#maximum antenna allocation requirement
max_antenna_alloc{a in ANTENNAS}:max_alloc >= trm_cap[a];

#data loss value
max_data_loss :0.001*sum{a in ANTENNAS,z in ZONES} demand_alloc[a,z]*zone_dist[a,z]=data_loss;



option solver cplex; 




