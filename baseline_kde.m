function b = baseline_kde(x,ds_ratio,window,step)
% potential improvement: increase weight of x at tentative baseline,
% e.g. small variance, small range, etc.
    assert(ismatrix(x), 'input has to be a matrix');
    [m, n] = size(x);
    if(~exist('ds_ratio','var'))
        ds_ratio = 50; % to speed up and to remove frame-by-frame noise
    end
    if(~exist('window','var'))
        window = 100;  % # of downsampled samples to use baseline est.
    end
    if(~exist('step','var'))
        step = 20; % mainly for speed up. later interporated.
    end
    if(mod(window,2)~=mod(step,2))
        window = window+1; % to match parity 
    end
    if(m < ds_ratio * 4)
        error('not enough samples. decrease ds_ratio');
    end
    while(m < ds_ratio * step * 4)
        step = floor(step/2);
    end
    x_ds = downsample_mean(x,ds_ratio);
    i_ds = downsample_mean((1:m)',ds_ratio);
    [m_ds, ~] = size(x_ds);
    b = zeros(m,n);
    h = (window-step)/2;
    for i=1:n
        i_steps = [];
        b_steps = [];
        for j = 1:step:m_ds
            r = max(1, j-h);
            l = min(m_ds, j+step-1+h);
            i_steps(end+1) = mean(i_ds(j:min(j+step-1,m_ds)));
            b_steps(end+1) = mode_kde(x_ds(r:l,i));
        end
        b(:,i) = interp1(i_steps,b_steps,1:m,'spline');
    end
end