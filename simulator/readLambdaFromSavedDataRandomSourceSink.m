function [ lambda_tile, data_size ] = readLambdaFromSavedDataRandomSourceSink( output_path )

lambda_core_1_struct = load(strcat(output_path,'/lambda_core_1.mat'));
lambda_core_1 = lambda_core_1_struct.lambda_core_1_data;
lambda_core_1 = lambda_core_1(2:length(lambda_core_1(:,1)),:);

lambda_core_2_struct = load(strcat(output_path,'/lambda_core_2.mat'));
lambda_core_2 = lambda_core_2_struct.lambda_core_2_data;
lambda_core_2 = lambda_core_2(2:length(lambda_core_2(:,1)),:);

lambda_core_3_struct = load(strcat(output_path,'/lambda_core_3.mat'));
lambda_core_3 = lambda_core_3_struct.lambda_core_3_data;
lambda_core_3 = lambda_core_3(2:length(lambda_core_3(:,1)),:);

lambda_core_4_struct = load(strcat(output_path,'/lambda_core_4.mat'));
lambda_core_4 = lambda_core_4_struct.lambda_core_4_data;
lambda_core_4 = lambda_core_4(2:length(lambda_core_4(:,1)),:);

lambda_core_5_struct = load(strcat(output_path,'/lambda_core_5.mat'));
lambda_core_5 = lambda_core_5_struct.lambda_core_5_data;
lambda_core_5 = lambda_core_5(2:length(lambda_core_5(:,1)),:);

lambda_core_6_struct = load(strcat(output_path,'/lambda_core_6.mat'));
lambda_core_6 = lambda_core_6_struct.lambda_core_6_data;
lambda_core_6 = lambda_core_6(2:length(lambda_core_6(:,1)),:);

% lambda_tile = [lambda_core_1; lambda_core_2; lambda_core_3; lambda_core_4; lambda_core_5; lambda_core_6];

% lambda_core_1 = transpose(lambda_core_1);
% lambda_core_2 = transpose(lambda_core_2);
% lambda_core_3 = transpose(lambda_core_3);
% lambda_core_4 = transpose(lambda_core_4);
% lambda_core_5 = transpose(lambda_core_5);
% lambda_core_6 = transpose(lambda_core_6);

lambda_tile(:,:,1) = lambda_core_1;
lambda_tile(:,:,2) = lambda_core_2;
lambda_tile(:,:,3) = lambda_core_3;
lambda_tile(:,:,4) = lambda_core_4;
lambda_tile(:,:,5) = lambda_core_5;
lambda_tile(:,:,6) = lambda_core_6;


data_size = length(lambda_core_1);

assert(length(lambda_core_1(:,1)) == length(lambda_core_2(:,1)), 'Lenght of vectors should be same');
assert(length(lambda_core_1(:,1)) == length(lambda_core_3(:,1)), 'Lenght of vectors should be same');
assert(length(lambda_core_1(:,1)) == length(lambda_core_4(:,1)), 'Lenght of vectors should be same');
assert(length(lambda_core_1(:,1)) == length(lambda_core_5(:,1)), 'Lenght of vectors should be same');
assert(length(lambda_core_1(:,1)) == length(lambda_core_6(:,1)), 'Lenght of vectors should be same');

end

