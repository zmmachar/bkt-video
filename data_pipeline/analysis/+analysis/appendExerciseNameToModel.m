function [ modelReferences ] = appendExerciseNameToModel( modelReferences, videoReference)
%APPENDEXERCISENAMETOMODEL Summary of this function goes here
%   Detailed explanation goes here
    
    for i = 1:length(modelReferences)
        kcNum = num2str(modelReferences(i).exerciseRef);
        kcRef = regexp(videoReference, strcat('video_\d+:([\w\s,'']+)\S+Related KC:\s*',kcNum ,':([\w\d\.]+),'), 'tokens');
        modelReferences(i).videos = cellfun(@(x) x(1), kcRef);
        %kcRef = regexp(exerciseReference, strcat('KC_', kcNum, ':(\w+)\s{'), 'tokens');
        if(isempty(kcRef))
            disp 'huh'
        end
        modelReferences(i).exerciseTitle = kcRef{1}(2);
    end
    

end

