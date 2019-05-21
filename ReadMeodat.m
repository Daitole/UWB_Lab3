function [CH1,CH2] = ReadMeodat(filename)

fid = fopen(filename);
idx = 0;
fs = 4.5; % GHz
dt = 1/fs; 
t = 0:dt:510*dt; % ns

while ~feof(fid)
    
    W0 = fread(fid,1,'uint32');
    if ~isempty(W0)
        if W0
            idx = idx+1;
            SyncWord(idx) = W0;
        end
    end
    W1 = fread(fid,1,'uint32');
    W2 = fread(fid,1,'uint32');
    W3 = fread(fid,4,'uchar');
    if ~isempty(W3)
        if W0
            ADC_level(idx) = W3(1);
            Rx(idx) = W3(2);
            Tx(idx) = W3(3);
        end
    end
    W4 = fread(fid,1,'uint32');
    if ~isempty(W4)
        if W0
            Scan_Number(idx) = W4;
        end
    end
    W5 = fread(fid,1,'uint32');
    W6 = fread(fid,1,'uint32');
    if ~isempty(W6)
        if W0
            AVG(idx) = W6/256;
        end
    end
    W7 = fread(fid,1,'uint32');
    W8 = fread(fid,1,'uint32');
    W9 = fread(fid,511,'float');
    if ~isempty(W9)
        if W0
            AScan(:,idx) = W9;
        end
    end
    
end

CH1 = AScan(:,1:2:end);
CH2 = AScan(:,2:2:end);

fclose(fid);