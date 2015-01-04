function ind = genetic_op(index, updateneighbour, domain)
%   subproblems: is all the subproblems.
%   index: the index of the subproblem need to handle.
%   ind: is an individual structure.

  parents = mateselection(index, updateneighbour, 2);
  newpoint = binomial_crossover([index parents]);

  
  ind = get_structure('individual');
  ind.parameter = newpoint;

  ind = binarymutate(ind);
  
  clear points selectpoints oldpoint randomarray deselect newpoint parentindex si;
end

function ind = binarymutate(ind)
  global  pd; 
  if (isstruct(ind))
      a = ind.parameter;
  else
      a = ind;
  end
  
 out=randperm(pd)';
 I=out(1:2);

   temp=a(I(1,1),1);
   a(I(1,1),1)=a(I(2,1),1);
   a(I(2,1),1)=temp;
  
  if isstruct(ind)
      ind.parameter = a;
  else
      ind = a;
  end
end

% select the candidate for evoluationary mating, i.e. finding the parent.
function select = mateselection(index, updateneighbour, size)
  global subproblems;
  
  select=[];
  if (updateneighbour)
      parentindex = subproblems(index).neighbour;
  else
      parentindex = 1:length(subproblems);
  end
  
  while(length(select)<size)
      r = rand;
      parent = ceil(length(parentindex)*r);
      indexsel = parentindex(parent);
      if ~any(ismember(parent, select))
          select = [select indexsel];
      end
  end
end

function ind = binomial_crossover(parents)
global subproblems pd;
  points = [subproblems(parents).curpoint];
  selectpoints = [points.parameter];
  out=randperm(pd-1)';
  I=out(1:pd/2);
  a = selectpoints(:,1);
  b = selectpoints(:,2);
  a1=zeros(pd,1);
for i=1:pd/2
a1(I(i,1),1)=a(I(i,1),1);
end
for i=1:pd
  for j=1:pd
     if(b(i,1)==a1(j,1))
       break
     end
  end
   for k=1:pd
      if(a1(k,1)==0&&j==pd)
        a1(k,1)=b(i,1);
      break
      end
   end
end
  ind = a1;
 
end

