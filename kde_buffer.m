classdef kde_buffer < handle
    properties(Access = private)        
        ds_ratio  = 20  % downsampling
        ds_buffer = []  %
        ds_count  = []  %
        
        window   = 100  %
        buffer   = []   % circular buffer
        position = []   %
        step     = 5
        
        index    = 1    % index to update result
        result = []
    end
    methods(Access = public)
        
        function add(self, x) % x has to be a row vector
            if(isempty(self.ds_buffer))
                self.ds_buffer = zeros(1,size(x,2));
                self.ds_count = 0;
                self.buffer = NaN(self.window,size(x,2));
                self.position = 0;
                self.result = zeros(1,size(self.buffer,2));
            end
            self.ds_count = self.ds_count + 1;
            self.ds_buffer = self.ds_buffer + x;
            if(self.ds_count == self.ds_ratio)
                x = self.ds_buffer / self.ds_ratio;
                self.position = mod(self.position, self.window) + 1;
                self.buffer(self.position,:) = x;
                self.ds_buffer = zeros(1,size(x,2));
                self.ds_count = 0;
            end
            self.result(self.index)=mode_kde(self.buffer(:,self.index));
            self.index = mod(self.index, size(x,2))+1;
        end
        function i = mode(self)
%             if(isempty(self.result))
%                 for j = 1:size(self.buffer,2)
%                     x = self.buffer(:,j);
%                     self.result(j)=mode_kde(x(x>0));
%                 end
%             end
            i = self.result;
        end
    end
end