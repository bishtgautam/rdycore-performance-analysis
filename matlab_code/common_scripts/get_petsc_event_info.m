function event_info = get_petsc_event_info(filename, event_name)

cmd_txt = sprintf('cat %s | grep %s',filename,event_name);
[status,result] = system(cmd_txt);

if ~(isempty(result))
    tmp = strsplit(result,' ');
    event_info.name = 'event_name';

    ndata = length(tmp)-2;
    event_info.data = zeros(ndata,1);
    for ii = 1:ndata
        event_info.data(ii) = str2num(tmp{ii+1});
    end
else
    error(sprintf('%s not found in %s',event_name,filename))
end
