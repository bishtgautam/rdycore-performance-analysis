function [t, N_unique] = compute_aveg_time_and_nodes(hardware, get_time_per_step)

data = hardware.data;
N    = hardware.N;

if (get_time_per_step)
    values = data(:,5)./data(:,3);
else
    values = data(:,5);
end


N_unique = unique(N);

for ii = 1:length(N_unique)
    loc = find(N == N_unique(ii));
    t(ii,1) = mean(values(loc));
end