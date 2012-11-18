function [ meanVec, stdVec ] = errorCalculationCorrelated( idealData, estData, type )
%ERRORCALCULATIONCORRELATED Summary of this function goes here
%   Detailed explanation goes here




idealCoordPrep = idealData(2:end,:);

switch type
    case 'mean'
        estDataPrep = [estData(1,:,:); estData(4,:,:); estData(7,:,:);...
            estData(2,:,:); estData(5,:,:); estData(8,:,:)];
        
        differData = zeros(size(idealCoordPrep,1),size(idealCoordPrep,2),size(estData,3));
        %meanData = zeros(1,size(idealData,2),size(estData,3));
        %meanDataSq = zeros(1,size(idealData,2),size(estData,3));
        %stdData = zeros(1,size(idealData,2),size(estData,3));
        for p = 1:size(estData,3)
            differData(:,:,p) = estDataPrep(:,:,p).' - idealCoordPrep;
            %meanData(:,:,p) = mean(differData(:,:,p));
            %meanDataSq(:,:,p) = mean(differData(:,:,p).^2);
            %stdData(:,:,p) = std(differData(:,:,p),1);
        end
        meanData = mean(differData,3);
        meanDataSq = mean(differData.^2,3);
        stdData = sqrt(meanDataSq - meanData.^2);
        
        meanVec = meanData;
        stdVec = stdData;
        %meanVec = mean(meanData,3);
        %stdVec = mean(stdData,3);
        
    otherwise
        estDataPrep = [estData(1,:); estData(4,:); estData(7,:);...
            estData(2,:); estData(5,:); estData(8,:)].';
        differData = estDataPrep - idealCoordPrep;
        meanVec = mean(differData);
        stdVec = std(differData,1);
        
        
end

end

