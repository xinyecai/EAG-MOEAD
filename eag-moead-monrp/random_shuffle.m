function vector = random_shuffle(vector)
    for i=length(vector):-1:2
        r = rand;
        k=ceil(r*i);
        temp = vector(i);
        vector(i)=vector(k);
        vector(k)=temp;
    end
end
