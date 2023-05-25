function latex_block_accuracy_binary(file_ltx, C, varargin)
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
% |     Date authored: 20.02.2023
% |         based on matrix2latex.m by M. Koehler (as edited by M. Ranaivombola)
% |     Modifications:
% |     20.02.2023 - initial version (MG)
% |----------------------------------------------------------------
%
% Inputs:
%   fid         - file handle
%   C           - cell array with confusion matrices
%   varargin    - key-value argument pairs
%
% This software is published under the GNU GPL, by the free software
% foundation. For further reading see: http://www.gnu.org/licenses/licenses.html#GPL

%--------------------------------------------------------------------------
% function: matrix2latex(...)
% Author:   M. Koehler
% Contact:  koehler@in.tum.de
% Version:  1.1
% Date:     May 09, 2004

% This software is published under the GNU GPL, by the free software
% foundation. For further reading see: http://www.gnu.org/licenses/licenses.html#GPL
%--------------------------------------------------------------------------
% Modified by
% Author : Marion Ranaivombola
% Date : February 24, 2022
% contact : marion.ranaivombola@univ-reunion.fr or
% marion.ranaivombola@gmail.com
% version : 1.0.2
% Modifications :
% - remove all warning
% - added an inputpaser instead of the IF and FOR loop and to add varargs
%--------------------------------------------------------------------------

%
% Usage:
% latex_block_accuracy_binary(file_ltx, C, varargs)
% where
%   - file_ltx is a valid file handle
%   - C is a cell of 2x2 confusion matrices
%   - varargs is one ore more of the following (key, value) combinations
%      + 'blockLabels', array -> Can be used to label the blocks of the
%      resulting latex table
%      + 'classLabels', array -> Can be used to label the classes of the
%      resulting block confusion matrices in the latex table
%      + 'alignment', 'value' -> Can be used to specify the alginment of
%      the table within the latex document. Valid arguments are: 'l', 'c',
%      and 'r' for left, center, and right, respectively
%      + 'format', 'value' -> Can be used to format the input data. 'value'
%      has to be a valid format string, similar to the ones used in
%      fprintf('format', value); the default value is '%-6.2f'.
%      + 'size', 'value' -> One of latex' recognized font-sizes, e.g. tiny,
%      HUGE, Large, large, LARGE, etc.
%      + 'caption', 'value' -> caption of table on latex.
%

p = inputParser;
p.KeepUnmatched = true;
addRequired(p, 'file_ltx');
addRequired(p, 'C', @iscell);
addParameter(p, 'placement', '!h', @ischar);
addParameter(p, 'blockLabels', @ischar);
addParameter(p, 'classLabels', @ischar);
addParameter(p, 'alignment', 'c', @ischar);
addParameter(p, 'size', '', @ischar);
addParameter(p, 'caption', '', @ischar);
addParameter(p, 'label', '', @ischar);

parse(p, file_ltx, C, varargin{:});

placement = p.Results.placement;
blockLabels = p.Results.blockLabels;
classLabels = p.Results.classLabels;
alignment = p.Results.alignment;

num_classes = numel(classLabels);
rowLabels = cell(1, num_classes);
colLabels = cell(1, num_classes);
for curr_class = 1:num_classes
    rowLabels{curr_class} = ['True ', classLabels{curr_class}];
    colLabels{curr_class} = ['Predicted ', classLabels{curr_class}];
end

switch (alignment)
    case ('right')
        alignment = 'r';
    case ('left')
        alignment = 'l';
    case ('center')
        alignment = 'c';
end
if alignment ~= 'l' && alignment ~= 'c' && alignment ~= 'r'
    alignment = 'l';
    warning('matrix2latex: Unkown alignment. (Set it to \''left\''.)');
end

textsize = p.Results.size;
caption = p.Results.caption;
label = p.Results.label;

num_blocks = numel(C);
num_rows = size(C{1}, 2);

%% Begin Table
fprintf(file_ltx, '\\begin{table}[%s]\n', placement);

% handle caption and label
if (~isempty(caption)) && (~isempty(label))
    fprintf(file_ltx, '\\caption{%s} \\label{%s}\n', caption, label);
elseif (~isempty(caption))
    fprintf(file_ltx, '\\caption{%s}\n', caption);
elseif (~isempty(label))
    fprintf(file_ltx, '\\label{%s}\n', label);
end
if (~isempty(textsize))
    fprintf(file_ltx, '\\begin{%s}\n', textsize);
end

%% Populate Table
fprintf(file_ltx, '\\begin{center}\n');
fprintf(file_ltx, '\\begin{tabular}{');
if (~isempty(rowLabels))
    fprintf(file_ltx, 'l');
end
for r = 1:num_rows
    fprintf(file_ltx, '%c', alignment);
end
fprintf(file_ltx, '}\r\n');

for curr_block = 1:num_blocks
    PN_PP = sum(C{curr_block}, 1);

    if curr_block == 1
        fprintf(file_ltx, '\\toprule\r\n');
    else
        fprintf(file_ltx, '\\midrule[\\heavyrulewidth]\n');
    end
    fprintf(file_ltx, '%s & \\text{Predicted Down} & \\text{Predicted Up} \\\\\n', blockLabels{curr_block});
    fprintf(file_ltx, '\\midrule\n');

    fprintf(file_ltx, 'True Down & %d, TN/PN: %2.1f\\%% & %d, FP/PP: %2.1f\\%% \\\\\n', ...
        C{curr_block}(1, 1), C{curr_block}(1, 1)/PN_PP(1)*100, C{curr_block}(1, 2), C{curr_block}(1, 2)/PN_PP(2)*100);
    fprintf(file_ltx, 'True Up & %d, FN/PN: %2.1f\\%% & %d, TP/PP %2.1f\\%% \\\\\n', ...
        C{curr_block}(2, 1), C{curr_block}(2, 1)/PN_PP(1)*100, C{curr_block}(2, 2), C{curr_block}(2, 2)/PN_PP(2)*100);
    fprintf(file_ltx, '\\midrule\n');

    fprintf(file_ltx, ' & %d, PN: %2.1f\\%% & %d, PP: %2.1f\\%% \\\\\n', PN_PP(1), PN_PP(1)/sum(PN_PP)*100, PN_PP(2), PN_PP(2)/sum(PN_PP)*100);

end

%% End Table
fprintf(file_ltx, '\\bottomrule\r\n');
fprintf(file_ltx, '\\end{tabular}\r\n');
fprintf(file_ltx, '\\end{center}\n');
if (~isempty(textsize))
    fprintf(file_ltx, '\\end{%s}', textsize);
end
fprintf(file_ltx, '\\end{table}\n\n');

end
