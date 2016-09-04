function [ resourcePositions ] = countResourcePositions (data)
%CountResourcePositions Summarizes the position of resource usage within a trace
%   This function summarizes the position of resource usage within a trace.  Since this is pretty back-of-the-envelope
%   at the moment, relevant positions are beginning (before any problem attempts), middle (between the same), and end (after all)
	
    resourcePositions = zeros(length(data), 3); %Resource use can be in beginning, middle, or end of trace
    for i = 1:length(data)
      exercise = data{i};
      compactData = sum(exercise.data, 1); %don’t care about subparts
      for j = 1:length(exercise.lengths)
        trace = compactData(exercise.starts(j): exercise.starts(j) + exercise.lengths(j) - 1);
        resourceUsageIndices = find(trace == 0, length(trace));
        attemptIndices = find(trace > 0, length(trace));
        if length(attemptIndices) == 0 || length(resourceUsageIndices) == 0
          continue % we only care about traces with both attempts and resource uses
        end			
        firstAttemptIndex = attemptIndices(1);
        lastAttemptIndex = attemptIndices(end);
        resourcePositions(i, 1) = resourcePositions(i, 1) + sum(resourceUsageIndices < firstAttemptIndex);
        resourcePositions(i, 2) = resourcePositions(i, 2) + sum(resourceUsageIndices < lastAttemptIndex & resourceUsageIndices > firstAttemptIndex);
        resourcePositions(i, 3) = resourcePositions(i, 3) + sum(resourceUsageIndices > lastAttemptIndex);
      end
    end				
end
