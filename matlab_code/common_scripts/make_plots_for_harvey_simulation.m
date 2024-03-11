function make_plots_for_harvey_simulation()

ncells = 2926532;
ndof_per_cell = 3;

p_ngpu_per_node = 4;
p_ncpu_per_node = 128;
f_ngpu_per_node = 8;
f_ncpu_per_node = 56;

event_names = {'TSStep','CeedOperatorApp'};

pm = read_event_info_from_all_files_in_a_dir('/Users/bish218/projects/rdycore/rdycore-performance-analysis/harvey/Turning_30m/perlmutter/', event_names);
frontier = read_event_info_from_all_files_in_a_dir('/Users/bish218/projects/rdycore/rdycore-performance-analysis/harvey/Turning_30m/frontier/', event_names);
fig_dir ='/Users/bish218/projects/rdycore/rdycore-performance-analysis/harvey/Turning_30m/figures';

for ievent = 1:2

    get_time_per_step = 1;
    [f_gpu_t_norm, f_gpu_n] = compute_aveg_time_and_nodes(frontier.event(ievent).gpu, get_time_per_step);
    [f_cpu_t_norm, f_cpu_n] = compute_aveg_time_and_nodes(frontier.event(ievent).cpu, get_time_per_step);

    [p_gpu_t_norm, p_gpu_n] = compute_aveg_time_and_nodes(pm.event(ievent).gpu, get_time_per_step);
    [p_cpu_t_norm, p_cpu_n] = compute_aveg_time_and_nodes(pm.event(ievent).cpu, get_time_per_step);
    
    get_time_per_step = 0;
    [f_gpu_t, f_gpu_n] = compute_aveg_time_and_nodes(frontier.event(ievent).gpu, get_time_per_step);
    [f_cpu_t, f_cpu_n] = compute_aveg_time_and_nodes(frontier.event(ievent).cpu, get_time_per_step);

    [p_gpu_t, p_gpu_n] = compute_aveg_time_and_nodes(pm.event(ievent).gpu, get_time_per_step);
    [p_cpu_t, p_cpu_n] = compute_aveg_time_and_nodes(pm.event(ievent).cpu, get_time_per_step);

    p_gpu_dof = ndof_per_cell*ncells/p_ngpu_per_node./p_gpu_n;
    p_cpu_dof = ndof_per_cell*ncells/p_ncpu_per_node./p_cpu_n;
    f_gpu_dof = ndof_per_cell*ncells/f_ngpu_per_node./f_gpu_n;
    f_cpu_dof = ndof_per_cell*ncells/f_ncpu_per_node./f_cpu_n;

    % Efficiency: DoF/s/GPU or DoF/s/GPU
    p_gpu_eff = p_gpu_dof./p_gpu_t;
    p_cpu_eff = p_cpu_dof./p_cpu_t;
    f_gpu_eff = f_gpu_dof./f_gpu_t;
    f_cpu_eff = f_cpu_dof./f_cpu_t;

    figure;
    loglog(f_cpu_n,f_cpu_t,'-ob','linewidth',2)
    hold all
    loglog(f_gpu_n,f_gpu_t,'--ob','linewidth',2)
    loglog(p_cpu_n,p_cpu_t,'-sr','linewidth',2)
    loglog(p_gpu_n,p_gpu_t,'--sr','linewidth',2)
    set(gca,'xtick',2.^[0:7])
    set(gca,'fontweight','bold','fontsize',12)
    loglog(p_cpu_n, p_cpu_n(1)./p_cpu_n.*p_cpu_t(1)*0.5, '--k')
    xlabel('Nodes')
    ylabel('Time [sec]')
    title([event_names{ievent} ': Weak scaling for 3M cells Harvey problem'])
    legend('Frontier CPU','Frontier GPU','Perlmutter CPU','Perlmutter GPU','Perfect weak scaling')
    grid on;
    %ylim(([1e-5 1e-1]))
    ylim(([1e1 1e5]))
    orient landscape
    print('-dpng',sprintf('%s/%s_1.png',fig_dir,event_names{ievent}))


    figure;
    loglog(f_cpu_dof,f_cpu_t,'-ob','linewidth',2)
    hold all
    loglog(f_gpu_dof,f_gpu_t,'--ob','linewidth',2)
    loglog(p_cpu_dof,p_cpu_t,'-sr','linewidth',2)
    loglog(p_gpu_dof,p_gpu_t,'--sr','linewidth',2)
    ylabel('Time [sec]')
    xlabel('DOF/device')
    title([event_names{ievent} ': Weak scaling for 3M cells Harvey problem'])
    legend('Frontier CPU','Frontier GPU','Perlmutter CPU','Perlmutter GPU')
    set(gca,'fontweight','bold','fontsize',12)
    grid on
    %ylim(([1e-5 1e-1]))
    ylim(([1e1 1e5]))
    orient landscape
    print('-dpng',sprintf('%s/%s_2.png',fig_dir,event_names{ievent}))

    figure;
    loglog(f_cpu_t,f_cpu_eff,'-ob','LineWidth',2);
    hold all
    loglog(f_gpu_t,f_gpu_eff,'--ob','LineWidth',2);
    loglog(p_cpu_t,p_cpu_eff,'-sr','LineWidth',2);
    loglog(p_gpu_t,p_gpu_eff,'--sr','LineWidth',2);
    xlabel('Time [sec]')
    ylabel('Efficiency [DOF/sec/device]')
    legend('Frontier CPU','Frontier GPU','Perlmutter CPU','Perlmutter GPU')
    grid on;
    set(gca,'fontweight','bold','fontsize',12)
    orient landscape
    xlim(([1e1 1e5]))
    title([event_names{ievent} ': Weak scaling for 3M cells Harvey problem'])
    print('-dpng',sprintf('%s/%s_3.png',fig_dir,event_names{ievent}))

end

