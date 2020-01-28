function [data] = readJsonFile(filename)
    fid = fopen(filename);
    rawData = fread(fid, inf);
    fclose(fid);
    str = char(rawData');
    data = jsondecode(str);
end

