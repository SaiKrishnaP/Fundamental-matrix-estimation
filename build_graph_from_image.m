function [A,vertex, IMM] = build_graph_from_image( M, connect, tresh )

% build_graph_from_image - build a graph from an image.
%
%   [A,vertex] = build_graph_from_image( M, tresh, connect );
%
%   M is a matrix. Pixel 'i' is connected to 'j'
%   in the neighboorhood (default '4' connectivity
%   but you can also set '8' in the variable 'connect')
%   if |M(i)-M(j)|>thresh. Default value for 'tresh' 
%   is image mean value.
%
%   Copyright (c) 2003 Gabriel Peyré

% [r1,c1] = size(M);

% for i = 1:r1-1
% %     for j = 1:c1
%         if sum(M(i,:)) == 0
%             M(i,:) = [];
%         end        
% %     end
% end

% only one line:

M( :, ~any(M,1) ) = [];  % Erase columns
M( ~any(M,2), : ) = [];  % Erase rows


[r,c] = size(M);

IMM = M;
figure, imshow(uint8(IMM))

A = zeros( (r+1)*(c+1), (r+1)*(c+1) );
vertex = zeros( (r+1)*(c+1), 3);

if nargin<2
    connect = 4;
end
if nargin<3
    tresh = ( max(max(M))+min(min(M)) )/2;
end

for i=1:(r+1)
    
for j=1:(c+1)
    N = i+(j-1)*(r+1);
    vertex(N,:) = [(i-1)/r,(j-1)/c,0];
    % check neighbors 
    p11 = 0;
    p21 = 0;
    p12 = 0;
    p22 = 0;
    if i>1 && j<=c
        p11 = M(i-1,j)>tresh;
    end
    if i<=r && j<=c
        p21 = M(i,j)>tresh;
    end
    if i>1 && j>1
        p12 = M(i-1,j-1)>tresh;
    end
    if j>1 && i<=r
        p22 = M(i,j-1)>tresh; 
    end
    % build link
    if (p21+p22>=1) %  || (i==1 && p21+p22==1) 
        A(N, N+1) = 1;
        A(N+1, N) = 1;
    end
    if (p11+p12)>=1
        A(N, N-1) = 1;
        A(N-1, N) = 1;
    end
    if p11+p21>=1
        A(N, N+r+1) = 1;
        A(N+r+1, N) = 1;
    end
    if p12+p22>=1
        A(N, N-r-1) = 1;
        A(N-r-1, N) = 1;
    end
    if connect==8
        if p21==1
            A(N, N+1+r+1) = 1;
            A(N+1+r+1, N) = 1;
        end
        if p11==1
            A(N, N-1+r+1) = 1;
            A(N-1+r+1, N) = 1;
        end
        if p22==1
            A(N, N+1-r-1) = 1;
            A(N+1-r-1, N) = 1;
        end
        if p12==1
            A(N, N-1-r-1) = 1;
            A(N-1-r-1, N) = 1;
        end
    end
end
end