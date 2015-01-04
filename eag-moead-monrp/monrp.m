

% the content of this file should be self-explained.
% however, if you have any quesion, please contact Yexing Li(lyx19910329@126.com)

clear all;
load randomData_cust100_req1000;

global nmbofreq  nmbofcust Value Cost t
problems = {'MONRP'};

plength = length(problems);
%total test run.
totalrun = 1;

ParetoCell=cell(totalrun,1);


seed = 10;
for i=1:plength
    prob = problems{i};
    disp(sprintf('Running on %s', prob));
    for j = 1:totalrun
        mop = testmop(prob,nmbofreq);
        runPareto = moead(mop);
        ParetoCell{j}=runPareto;
        disp(sprintf('run %d', j));

    end
end