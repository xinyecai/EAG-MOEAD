    function Ranking = NSGA_sorting(Indivs,ObjVals)

[nmbOfVars nmbOfIndivs] = size( Indivs);
[nmbOfObjs foo] = size( ObjVals);

% Pareto-optimal fronts
Front = {[]};
% number of Pareto-optimal front for each individual; 2nd highest priority sorting key
NmbOfFront = zeros( nmbOfIndivs, 1);
% set of individuals a particular individual dominates
Dominated = cell( nmbOfIndivs, 1);
% number of individuals by which a particular individual is dominated
NmbOfDominating = zeros( nmbOfIndivs, 1);
for p = 1:nmbOfIndivs
  for q = 1:nmbOfIndivs
    if (sum( ObjVals( :, p) <= ObjVals( :, q)) == nmbOfObjs) && ...
      (sum( ObjVals( :, p) < ObjVals( :, q)) > 0)
      Dominated{ p}(end + 1) = q;
    elseif (sum( ObjVals( :, q) <= ObjVals( :, p)) == nmbOfObjs) && ...
      (sum( ObjVals( :, q) < ObjVals( :, p)) > 0)
      NmbOfDominating( p) = NmbOfDominating( p) + 1;
    end
  end
  if NmbOfDominating( p) == 0
    NmbOfFront( p) = 1;
    Front{ 1}(end + 1) = p;
  end
end
i = 1;
while ~isempty( Front{ i})
  NextFront = [];
  for k = 1:length( Front{ i})
    p = Front{ i}( k);
    for l = 1:length( Dominated{ p})
      q = Dominated{ p}( l);
      NmbOfDominating( q) = NmbOfDominating( q) - 1;
      if NmbOfDominating( q) == 0
	NmbOfFront( q) = i + 1;
	NextFront( end + 1) = q;
      end
    end
  end
  i = i + 1;
  Front{ end + 1} = NextFront;
end
% crowding distance for each individual; 3rd highest priority sorting key
CrowdDist = zeros( nmbOfIndivs, 1);
for i = 1:nmbOfObjs
  [ObjValsSorted SortIdx] = sort( ObjVals( i, :));
  % individuals w/ extreme objective function values are assigned a negative
  % infinite crowding distance so that their rank is always lower than the rank
  % of other individuals which are otherwise of the same rank (same degree of
  % constraint violation; same Pareto-Front)
  CrowdDist( SortIdx( 1)) = -inf;
  CrowdDist( SortIdx( nmbOfIndivs)) = -inf;
  for j = 2:(nmbOfIndivs - 1)
    %%% introduced normalization by the absolute range of the 
    %%% objective function; a range of [0 1] is equivalent to no normalization
    % add negative of the distance between the nearest other two individuals
    % to the overall crowding distance
      CrowdDist( SortIdx( j)) = CrowdDist( SortIdx( j)) - ...
      (ObjValsSorted( j + 1) - ObjValsSorted( j - 1))./(max(ObjVals(i,:))-min(ObjVals(i,:)));
  end
end
% rank of each individual
[foo SortIdx] = sortrows( [NmbOfFront CrowdDist]);
Ranking = zeros( nmbOfIndivs, 1);
for i = 1:nmbOfIndivs
  Ranking( i) = find( SortIdx == i);
end