function hardware = read_event_info_from_all_files_in_a_dir(machine_dir, event_names)

%machine_dir = '/Users/bish218/projects/rdycore/rdycore-performance-analysis/harvey/Turning_30m/frontier/';
%event_names = {'TSStep','CeedOperatorApp'};

files = dir([machine_dir '*.snippet']);

for ifile = 1:length(files)
    tmp = strsplit(files(ifile).name,'.');
    N(ifile,1) = str2num(tmp{3}(3:end));

    switch tmp{2}
        case 'ceed_cpu'
            is_cpu(ifile,1) = 1;
        case 'ceed_gpu'
            is_cpu(ifile,1) = 0;
        case 'ceed_cuda'
            is_cpu(ifile,1) = 0;
        otherwise
            error(sprintf('Could not figure out if it is a CPU or GPU data. %s',files{ifile}.name));
    end

end

for ievent = 1:length(event_names)
    event_name = event_names{ievent};
    disp(event_name);
    for ii = 0:1

        loc = find(is_cpu == ii);
        [~,idx] = sort(N(loc));


        for jj = 1:length(loc)
            ifile = loc(idx(jj));
            filename = [files(ifile).folder '/' files(ifile).name];
            disp(files(ifile).name);
            event_info = get_petsc_event_info(filename, event_name);
            event_data(jj,:) = event_info.data';
        end

        data = [is_cpu(loc) N(idx) event_data];
        clear event_data

        switch ii
            case 0
                hardware.event(ievent).name = event_name;
                hardware.event(ievent).gpu.data = data;
                hardware.event(ievent).gpu.N = N(loc(idx));
            case 1
                hardware.event(ievent).cpu.data = data;
                hardware.event(ievent).cpu.N = N(loc(idx));
        end
    end
end
