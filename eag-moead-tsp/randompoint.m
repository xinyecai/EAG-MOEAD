function ind = randompoint(prob)
%RANDOMNEW to generate a new point from 
%   Detailed explanation goes here
    
    ind =get_structure('individual');
    ind.parameter = zeros(prob.pd, 1);
    
   for i=1:prob.pd
       ind.parameter(i,1)=i;
    end
   ind.parameter = random_shuffle(ind.parameter);
end

