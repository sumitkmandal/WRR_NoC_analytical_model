function[event_trace] = gen_trace_GGeo_dist_func(lambda, p_burst, trace_len)

  p_Geo_sucess = lambda*(1 - p_burst);   % service time during burst state = 0  
  event_trace = zeros(1, trace_len); 

  Geo_server_done = true;
  Geo_server_may_start = true;
  
  for i = 1:trace_len                
    if Geo_server_done == false || Geo_server_may_start == true    
       Geo_server_may_start = false;
       p = rand(1,1);
       if p <= p_Geo_sucess
          event_trace(i) = 1;
          
          Geo_server_done = true;
       else
          Geo_server_done = false;
       end
    end
    
    if (Geo_server_done == true)
      p = rand(1,1);
      while p <= p_burst
        event_trace(i) = event_trace(i) + 1;
        
        p = rand(1,1);
      end
      Geo_server_may_start = true;      
    end   
  end
  
  % Geo trace (debug)
%   event_trace = zeros(1, trace_len);
%   for i = 1:trace_len
%     p = rand(1,1);
%     if p <= lambda
%       event_trace(i) = 1;
%     end
%   end

end