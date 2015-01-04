function [iterPareto  iterPareto1] = moead( mop, varargin)


    %global variable definition.
    global subproblems params itrCounter evalCounter  EP  a  c q2 t 
    %global idealpoint objDim parDim evalCounter;
    
    %load the parameters.
    params=loadparams(mop, varargin);
    evalCounter = 0;
    itrCounter =0;
    subproblems=[];
    % external population for non-dominated solutions
    temp_EP = get_structure('individual');
    EP = repmat(temp_EP, length(subproblems),1);
   
    %and Initialize the algorithm.
    init(mop);
     z=8;
     c=0;
    q=ones(length(subproblems),1);
    q1=ones(length(subproblems),1);
    q2=ones(length(subproblems),1);
    t=zeros(length(subproblems),z);
    cellnum=params.evaluation./params.popsize;
    iterPareto=cell(cellnum,1);
    iterPareto1=cell(cellnum,1);
    while ~terminate()
        evolve(mop); % one generation of evaluation.
        itrCounter=itrCounter+1;
%         h1=h1+1;
        if (rem(itrCounter,1)==0) % updating of the utility.
            pf=[EP.objective];
            k=itrCounter./1;
            pf11=[subproblems.curpoint];
            pf1=[ pf11.objective];
            iterPareto{k}=pf;
            iterPareto1{k}=pf1;   
        end  
%%%%%evaluate the probility of subproblems%%%%%%%%%%
    a=zeros(length(EP),2);
    a(:,2)=1:length(EP);
  for i = 1:length(EP)
    for j=1:length(EP)
        if(EP(i).index(1)==j);
        a(j,1)=a(j,1)+1;% 存放每个问题的个数
        end
    end
  end
 
  t(:,mod(c,z)+1)=a(:,1);%存放在近z代中每个问题的个数
  c=c+1;
  g=ones(z,1);
  g1=ones(length(subproblems),1);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   q=t*g/(z*length(subproblems))+0.01;%给每个问题都加上一个相同的较小的概率
   q1= q/(g1'*q);%每个问题所占的比例
   q2(1,1)= q1(1,1);
   for j=2:length(EP)  
      q2(j,1)= q1(j,1)+q2(j-1,1);
   end 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    end
end

% The evoluation setp in MOEA/D
function evolve(mop)
  global subproblems idealpoint params  EP ind1 q2 selectionSize;


  selindex = 1:length(subproblems);  
  selectionSize = length(selindex);
  
  temp_ind = get_structure('individual');
  temp_ind2 = get_structure('ind1');
  ind = repmat(temp_ind, length(subproblems),1);
  ind2 = repmat(temp_ind2, length(subproblems),1);
  for i=1:length(selindex)
      r1=rand;
   for j=1:length(subproblems)    
   %%%%%select the subproblem%%%%%%%%%%%%%
   if(q2(j,1)<r1)
   continue
   end
   break
   end
   index=j;%select the 'j 'subproblem%
    r = rand;
    updateneighbour = r < params.updateprob;
    ind(index) = genetic_op(index, updateneighbour, mop.domain);
    [obj,ind(index)] = evaluate(mop, ind(index));
    
    ind1(index).parameter=ind(index).parameter;
    ind1(index).objective=ind(index).objective;
    
    ind2(i).parameter=ind1(index).parameter;
    ind2(i).objective=ind1(index).objective;
    ind2(i).index=ind1(index).index;
  
     %update the idealpoint.
     idealpoint = min(idealpoint, obj);
     update(index, ind(index), 1);
%        end 
  end

  pop = [EP ind2'];
  
  for i = 1:length(pop)
    Indivs(:,i) = pop(i).parameter;
    ObjVals(:,i) = pop(i).objective;
  end

  Ranking = NSGA_sorting(Indivs,ObjVals);
  elite=find(Ranking<=length(EP));
  Indivs = Indivs(:,elite);
  ObjVals = ObjVals(:,elite);
  for i = 1:length(EP)
    EP(i).parameter =  Indivs(:,i);
    EP(i).objective = ObjVals(:,i);
    EP(i).index = pop(elite(i,1)).index;
    EP(i).result = pop(elite(i,1)).result;
  end
end


function update(index, ind, updateneighbour)
  global subproblems idealpoint params;

  if (updateneighbour)
    updateindex = subproblems(index).neighbour;
  else
    updateindex = 1:length(subproblems);
  end
  
  updateindex = random_shuffle(updateindex);
  time=0;
  
  for i=1:length(updateindex)
      idx = updateindex(i);
      updateweight = subproblems(idx).weight;
      
      newobj=subobjective(updateweight, ind.objective,  idealpoint, 'ws');
      old=subobjective(updateweight, subproblems(idx).curpoint.objective,  idealpoint, 'ws');
      
      if (newobj<old)
         subproblems(idx).curpoint=ind;
         time = time+1; 
      end
      if (time>=params.updatenb)
          return;
      end
  end
  
end

function y =terminate()
    global params evalCounter;
    y = evalCounter>params.evaluation;
end


