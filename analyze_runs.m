clear;
close all;
clc;

files = dir('./2017_03_10*');
k = size(files,1);
datafiles = cell(k,1);
for ii = 1:k
    datafiles{ii} = files(ii).name;
end
datafiles = sort(datafiles);

runs = textread('runs.txt', '%s', 'delimiter', '\n');
m = size(runs,1);
ii = 1;
for jj = 1:m
    runDesc = runs{ii};
    if isempty(runDesc)
        continue;
    end

    runName = datafiles{ii};
    runData = textread(runName, '%s', 'delimiter', '\n');
    imu = [];
    sonic = [];

    for kk = 1:size(runData,1)
        row = runData{kk};
        if isempty(row)
            continue;
        end

        if (row(1) == 'u')
            data = strsplit(row,',');
            sonic = [sonic; [kk, str2num(row(2)), str2num(data{2}), str2double(data{3})]];
        elseif (row(1) == 'i')
            data = strsplit(row(2:end),',');
            imu = [imu; [kk, str2double(data{1}), str2double(data{2}), str2double(data{3})]];
        else
            disp('Bad input');
        end
    end
    
    figure();
    hold on;
    leg = {};
    for ll = 1:6
        sensor = sonic(sonic(:,2) == ll, :);
        plot(sensor(:,1), sensor(:,4));
        leg = [leg, num2str(ll)];
    end
    title(['Run ', num2str(ii), ', Ultrasonic readings']);
    legend(leg);

    figure();
    hold on;
    plot(imu(:,1), imu(:,2));
    plot(imu(:,1), imu(:,3));
    plot(imu(:,1), imu(:,4));
    title(['Run ', num2str(ii), ', IMU readings']);
    legend({'X', 'Y', 'Z'});

    disp(num2str(ii));
    disp(runName);
    disp(runDesc);

    ii = ii + 1;
    break;
end

