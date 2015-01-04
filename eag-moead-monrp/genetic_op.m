function ind = genetic_op(index, updateneighbour, domain)

%   subproblems: is all the subproblems.
%   index: the index of the subproblem need to handle.
%   ind: is an individual structure.
  global  parDim;

  parents = mateselection(index, updateneighbour, 2);
  newpoint = binomial_crossover([index parents]);
  
  ind = get_structure('individual');
  ind.parameter = newpoint;

  ind = binarymutate(ind,1/parDim);
  
  clear points selectpoints oldpoint randomarray deselect newpoint parentindex si;
end

function ind = binarymutate(ind, rate)
  global parDim;

  
  if (isstruct(ind))
      a = ind.parameter;
  else
      a = ind;
  end
  
  
  for j = 1:parDim
      r = rand;
      if (r <= rate)
          if a(j) == 0
            a(j) = 1;
          elseif a(j) == 1
            a(j) = 0;
          else
            error('either 1 or 0');
          end
      end
  end
  
  if isstruct(ind)
      ind.parameter = a;
  else
      ind = a;
  end
end

% select the candidate for evoluationary mating, i.e. finding the DE parent.
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
global subproblems;
  points = [subproblems(parents).curpoint];
  selectpoints = [points.parameter];
  a = selectpoints(:,1);
  b = selectpoints(:,2);
  r = randint(length(a),1);
  ro = ones(length(a),1) - r;
  c = r.*a + ro.*b;
  ind = c;
end

