function TV = compute_TV(X)
    X = double(X);
    h=[1;0;-1];
    Gx=imfilter(X,h');
    Gy=imfilter(X,h);
    TV = sum(abs(Gx(:)) + abs(Gy(:)));
end
