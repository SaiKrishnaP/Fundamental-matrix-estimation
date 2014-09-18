
close all;
clear all;
clc;

load('sp.mat')

M = sp_slic;
M = imresize(M,[50,50]);
connect  = 4;
tresh = ( max(max(M))+min(min(M)) )/2;

[A,vertex, IMM] = build_graph_from_image( M, connect, tresh );

pad_with = 0;

W = build_euclidean_weight_matrix(A, vertex, pad_with);

% 
% Here i want to build a adjaceny matrix and a vertex. The problem is with both of this
% 
% For example
% 
% let M = [1 2 3
%          4 5 6
%          7 8 9]
% 
% Now the adjaceny matrix will keep all the relations between the main number and its adjacent number.
% 
% lets say : 1 is the main number or vertex then the relations with 2 and 4 are stored in adjaceny matrix
%            2 is the main number or vertex then the relations with 1,3 and 5 are stored in adjaceny matrix
%            3 is the main number or vertex then the relations with 2 and 6 are stored in adjaceny matrix
%            4 is the main number or vertex then the relations with 1 and 5 are stored in adjaceny matrix
%            5 is the main number or vertex then the relations with 2, 4, 6 and 8 are stored in adjaceny matrix
%            
%            and so on
%            
% But the problem is when the matrix is big like 200-by-200 or more...
