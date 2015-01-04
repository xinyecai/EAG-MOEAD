
% Note that the test problems here includes only tsp200
% the content of this file should be self-explained.
% however, any quesion please contact xinye cai()

clear all;

load tsp200;

global pd s v  ps pf

problems = {'TSP'};

plength = length(problems);

totalrun =1;

ParetoCell=cell(totalrun,1);
ParetoCell1=cell(totalrun,1);

for i=1:plength
    prob = problems{i};
    disp(sprintf('Running on %s', prob));
    for j = 1:totalrun
        mop = testmop(prob,pd);
        [runPareto  runPareto1 ]= moead(mop);
        ParetoCell{j}=runPareto;
        ParetoCell1{j}=runPareto1;
        disp(sprintf('run %d', j));
    end
end