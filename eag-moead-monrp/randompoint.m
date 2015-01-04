function ind = randompoint(prob)
%RANDOMNEW to generate a new point from 
%   Detailed explanation goes here
    global rnduni;
    
    lowend = prob.domain(:,1);
    span = prob.domain(:,2)-lowend;
    
    ind =get_structure('individual');
    ind.parameter = zeros(prob.pd, 1);
    
    for i=1:prob.pd
        if rand < 0.5;
            ind.parameter(i)=1;
        else
            ind.parameter(i)=0;
        end
    end
end
