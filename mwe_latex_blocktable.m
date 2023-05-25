% Minimal working example for latex_blocktable.m
%
% |----------------------------------------------------------------
% | (C) 2023 Mikus Grasis
% |
% |         __          __               ______            __
% |        / /   ____ _/ /____  _  __   /_  __/___  ____  / /____
% |       / /   / __ `/ __/ _ \| |/_/    / / / __ \/ __ \/ / ___/
% |      / /___/ /_/ / /_/  __/>  <     / / / /_/ / /_/ / (__  )
% |     /_____/\__,_/\__/\___/_/|_|    /_/  \____/\____/_/____/
% |
% |     Advisors:
% |         Univ.-Prof. Dr.-Ing. Martin Haardt
% |
% |     Date authored: 19.02.2023
% |     Modifications:
% |     19.02.2023 - initial version (MG)
% |----------------------------------------------------------------
%
file_ltx = fopen('out.tex', 'w');


str_algs = {'SVM', 'kNN', 'NN'};
num_algs = numel(str_algs);

str_headers = {'Min', 'Max', 'Median', 'Mean', 'Std'};
str_data_sets = {'dataset 1', 'dataset 2', 'dataset 3'};

STATS = cell(1, num_algs);
for curr_alg = 1:num_algs
    ACC = rand(3);
    STATS{curr_alg} = [min(ACC, [], 1).', max(ACC, [], 1).', median(ACC, 1).', mean(ACC, 1).', std(ACC, 1).'];
end


str_caption = 'Summary statistics over the datasets';
latex_blocktable(file_ltx, STATS, 'blockLabels', str_algs, 'rowLabels', str_data_sets, 'columnLabels', str_headers, 'caption', str_caption);


fclose(file_ltx);
