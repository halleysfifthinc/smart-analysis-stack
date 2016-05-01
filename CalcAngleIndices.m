function var = CalcAngleIndices(handles)
% Clear the variables in case the new angleIndices are different (shorter)
% lengths and some data from the old binWidth value would hold over and
% cause erroneous results.
handles.firstBinAngleIndices = {};

% Gather all the indices for data points that occur within a range of
% degrees determined by binWidth
for n=1:(360/handles.binWidth)
  handles.firstBinAngleIndices{n} = find( handles.firstHandlebarAngles < n*handles.binWidth & handles.firstHandlebarAngles >= (n-1)*handles.binWidth );
end

% Return the update handles structure
var = handles;
