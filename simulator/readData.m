function [ average_latency, sd_latency ] = readData( )

[average_latency_1, sd_latency_1] = read_latency_and_sd( 'outputs_03212018' );
[average_latency_2, sd_latency_2] = read_latency_and_sd( 'outputs_03062018' );
[average_latency_3, sd_latency_3] = read_latency_and_sd( 'outputs_03072018' );
[average_latency_4, sd_latency_4] = read_latency_and_sd( 'outputs_032020180' );

average_latency = [average_latency_1; average_latency_2; average_latency_3; average_latency_4];
sd_latency = [sd_latency_1; sd_latency_2; sd_latency_3; sd_latency_4];

end