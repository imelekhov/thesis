function [ ] = errorCalculationEUROCONTROL( idealDataTmp, estData, cutOff )
%ERRORCALCULATION Summary of this function goes here
%   Detailed explanation goes here

idealData = idealDataTmp(2:end,:);


errorX = sqrt(sum((estData(1,cutOff:end).' - idealData(cutOff:end,1)).^2) / length(idealData(cutOff:end,1)));
errorY = sqrt(sum((estData(4,cutOff:end).' - idealData(cutOff:end,2)).^2) / length(idealData(cutOff:end,1)));
errorZ = sqrt(sum((estData(7,cutOff:end).' - idealData(cutOff:end,3)).^2) / length(idealData(cutOff:end,1)));
errorVx = sqrt(sum((estData(2,cutOff:end).' - idealData(cutOff:end,4)).^2) / length(idealData(cutOff:end,1)));
errorVy = sqrt(sum((estData(5,cutOff:end).' - idealData(cutOff:end,5)).^2) / length(idealData(cutOff:end,1)));
errorVz = sqrt(sum((estData(8,cutOff:end).' - idealData(cutOff:end,6)).^2) / length(idealData(cutOff:end,1)));

str1 = ['X error: ',  num2str(errorX)]
str2 = ['Y error: ',  num2str(errorY)]
str3 = ['Z error: ',  num2str(errorZ)]
str4 = ['Vx error: ', num2str(errorVx)]
str5 = ['Vy error: ', num2str(errorVy)]
str6 = ['Vz error: ', num2str(errorVz)]

end

