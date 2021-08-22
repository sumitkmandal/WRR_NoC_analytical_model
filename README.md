# Theoretical Analysis and Evaluation of NoCs with Weighted Round-Robin Arbitration:An Open Source Release
Analytical model of NoCs with weighted round robin (WRR) arbitration

       1. Directory information
	- 8x8 Simulator: simulator
	- Trace file generation: traffic_generation
        - Analytical model: analytical_model

	2. Generating the trace file: We have to run the matlab file in the item 'traffic_generation/create_traces.m'. It will generate a directory named ‘lambda_<injection rate>_pb_<probability of burst>_rand_factor_<factor>’. Inside the directory the .mat files related to timestamp will be there. Below are the modifications need to be made for different size of NoC. For all simulations, the trace length is fixed (1E5 in line 59).
	Settings for 8x8
	- num_node = 64 (at line 7)
	- sources = 1:num_node (either line 52 or line 53)
	- Set the injection rate in the variable ‘lambda_array’ accordingly (somewhere around line 41)
	- Set the probability of burstiness in the variable ‘p_burst_array’ accordingly (in line 14)
	- Running multiple iterations (changing the random seed): Change the ‘rand_factor’ (at line 60, currently set to 2) to other integer (other than 1) to generate trace files for multiple iterations. You can set the factor to 2,3,4,5 to generate trace files with four different rand factors. Trace file with different rand factors need to be simulated separately.

	3. Injection rate: Copy the injection rate directory (or directories) generated from item 2 to the corresponding simulator directory (simulator/). There might be already some injection rate directories. Delete those before copying the new ones. In ‘automate_simulation.m’, set the injection rate(s) (which you intend to run) in ‘lambda_array’ variable.

	4. ω_ring and ω_src: These are the weights corresponding to ring and source. The array for ω_ring is ‘ring_weights’ (line 46 in automate_simulation.m) and the array for ω_src is ‘source_weights’ (in line 47). These two are changed in lock steps. For example, suppose we need to run for two combinations [ω_ring=1,ω_src=1] and  [ω_ring=2,ω_src=1]. Then we need to set ring_weights = [1 2] and source_weights = [1 1]. 

	5. Probability of burstiness: Set it in line 44 of automate_simulation.m

	6. Putting the result: Run automate_simulation.m. After it finished execution, a directory named ‘outputs_lambda_<injection rate>_pb_<p_burst>_r_<ring weight>_s_<source weight>_f_<rand factor>’ will be generated. In that directory, the average latency is reported in ‘latency_output.txt’ file.

	7. Points to be noted: 
	- The trace generation takes long time (around an hour in a high performance server for 8x8 for high injection rate). So it is better if you launch the trace generations for multiple injection rates (i.e. putting an array instead if a single injection rate (or probability of burstiness) in the ‘lambda_array’ and ‘p_burst_array’ variable)
	- Simulation for 8x8 takes around 2 hrs for high injection rate. Better if launched multiple simulations simultaneously.
	- Before starting simulation delete any directories whose name start with ‘output_’
  
For any queries feel free to email skmandal@wisc.edu.

