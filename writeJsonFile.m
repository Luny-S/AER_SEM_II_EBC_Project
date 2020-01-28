function [ok] = writeJsonFile(filename, data)

    jsonStr = jsonencode(data);
    fid = fopen(filename,'w');
    if fid == -1
        ok = 0;
        return;
    end
    fwrite(fid, jsonStr, 'char');
    fclose(fid);
    ok = 1;
end

