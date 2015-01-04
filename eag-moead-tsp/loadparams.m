function params = loadparams(mop, propertyArgIn)
%LOADPARAMS Load the parameter settings from external file.
% file format 
%   Detailed explanation goes here

    params = get_structure('parameter');
    % set the default!!

    % General Setting for MOEA/D
%     params.seed = 177; % random seed.
    params.popsize = 100; % population size.
    params.niche = 10;  % neighbourhhood size
%     params.dmethod = 'ts'; % decomposition method of choice.
    params.iteration = 100; % total iteration.
    params.evaluation =30000; % total function evaluation number.

    % new MOEA/D setting.
    params.updateprob = 1; % percantege to update the neighbour or the whole population. 100% for all update neighbours
    params.updatenb = params.popsize; %params.popsize; % the maximum updation number to one weight-solution in one generation

    % DE setting.
    params.F = 0.5; % the F rate in DE.
    params.CR = 1; % the CR rate in DE.

    % R-MOEA/D specific setting.
    params.dynamic = 0; % weather to use R-MOEA/D or a normal MOEA/D, 1 for R-MOEA/D
    params.selportion = 5; % the selection percentage of in R-MOEA/D in utility selection
                           % selectionsize = params.popsize/params.selportion
    params.decayrate = 0.95; % the decay rate in R-MOEA/D

    % set for the default for a specific problem here.
    switch lower(mop.name)
        case {'kno1'}
            params.popsize = 20;
            params.niche = 5;
        case {'uf1','uf2','uf3','uf4','uf5','uf6','uf7'}
            params.popsize = 600;
            params.niche = 60;
            params.updatenb=6;
        case {'uf8','uf9','uf10'}
            params.popsize = 1000;
            params.niche = 100;
            params.updatenb=5;
        case {'r2_dtlz2_m5', 'r3_dtlz3_m5', 'wfg1_m5'}
            params.popsize = 1500;
            params.niche = 15;
            params.updatenb=10;
        otherwise
    end

    % handle the parameters passed in from the function directly!
    % it has priority higher than the default values.
    while length(propertyArgIn)>=2
        prop = propertyArgIn{1};
        val=propertyArgIn{2};
        propertyArgIn=propertyArgIn(3:end);

        switch prop
            case 'popsize'
                params.popsize=val;
            case 'niche'
                params.niche=val;
            case 'evaluation'
                params.evaluation=val;
            case 'selportion'
                params.selportion=val;                
            case 'dynamic'
                params.dynamic=val;
            case 'seed'
                params.seed=val;                
            otherwise
                warning('moea doesnot support the given parameters name');
        end
    end

end

