function [] = increment_bounce(u)

sink_id = u(1);
bounced = u(2);
cur_time = u(3);
src_id = u(4);


global sink_bnc_cntr;
global warm_up_cycles;

if (cur_time > warm_up_cycles && bounced == 1)
    sink_bnc_cntr(src_id, sink_id) = sink_bnc_cntr(src_id, sink_id) + 1;
end

end

