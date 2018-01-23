function m  = mode_kde(x, w)
% Find peak of kernel density estimation. Equivalent to mode of a discrete
% distribution.
    if(~exist('w','var'))
        w = [];
    else
        assert(isequal(size(x),size(w)));
    end
    if(~isempty(w))
        w = w(~isnan(x));
    end
    x = x(~isnan(x));
    if(isempty(x))
        m = NaN;
        return;
    end
    if(isempty(w))
        [f, xi]=ksdensity(x,'npoints',200); % npoints = 200 for efficiency
    else
        [f, xi]=ksdensity(x,'npoints',200,'weights',w); 
    end
    % reusing bandwidth later may save some time (not significant), but 
    % it is specified differently in different versions, like
    % 'bandwidth' (2014a) or 'width' (2012b). It is not worth dealing with.
    
    [~,ii] = max(f);
    ii_1 = max(ii-1,1);
    ii_2 = min(ii+1,length(f));
    if(ii_2-ii_1 == 2) % if two are similarly high compared to the third,
                       % let's just focus on the interval between two.
        if(f(ii_2)>f(ii_1))
            if(f(ii)-f(ii_2)<f(ii_2)-f(ii_1))
                ii_1 = ii;
            end
        else
            if(f(ii)-f(ii_1)<f(ii_1)-f(ii_2))
                ii_2 = ii;
            end
        end
    end
    xx = linspace(xi(ii_1),xi(ii_2),201); % x100 interpolation
    if(isempty(w))
        [f, xi]=ksdensity(x,xx);
    else
        [f, xi]=ksdensity(x,xx,'weights',w);
    end
    [~, ii] = max(f);
    m = xi(ii);
end