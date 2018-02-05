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
var theta1{ANTENNAS,ZONES}>=0;
var theta2{ANTENNAS,ZONES}>=0;
var theta3{ANTENNAS,ZONES}>=0;
var delta1{ANTENNAS,ZONES} binary;
var delta2{ANTENNAS,ZONES} binary;
var dataloss;

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

#total transmission loss
total_transmission_loss : sum{a in ANTENNAS,z in ZONES} zone_dist[a,z]*(theta1[a,z]*0 + theta2[a,z]*0.05 + theta3[a,z]*0.075)=dataloss;

#sum of thetas is one
piecewise{a in ANTENNAS, z in ZONES}: theta1[a,z]+theta2[a,z]+theta3[a,z]=1;

#theta and demand constraint
demand_theta{a in ANTENNAS,z in ZONES}: (theta1[a,z]*0+theta2[a,z]*50+theta3[a,z]*100)=demand_alloc[a,z];

#binary constraints
sum_of_binary{a in ANTENNAS, z in ZONES}:delta1[a,z]+delta2[a,z]=1;
binary1{a in ANTENNAS, z in ZONES}: theta1[a,z]<=delta1[a,z];
binary2 {a in ANTENNAS, z in ZONES}: theta2[a,z]<= delta1[a,z]+delta2[a,z];
binary3 {a in ANTENNAS, z in ZONES}: theta3[a,z]<= delta2[a,z];

option solver cplex; 




