function latex_block_accuracy(file_ltx, C, varargin)
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
%   file_ltx    - file handle
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
% latex_block_accuracy(file_ltx, C, varargs)
% where
%   - file_ltx is a valid file handle
%   - C is a cell with confusion matrices
%   - varargs is one ore more of the following (key, value) combinations
%      + 'blockLabels', array -> Can be used to label the blocks of the
%      resulting latex table
%      + 'classLabels', array -> Can be used to label the classes of the
%      resulting block confusion matrices in the latex table
%      + 'alignment', 'value' -> Can be used to specify the alginment of
%      the table within the latex document. Valid arguments are: 'l', 'c',
%      and 'r' for left, center, and right, respectively
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
addParameter(p, 'alignement', 'c', @ischar);
addParameter(p, 'size', '', @ischar);
addParameter(p, 'caption', '', @ischar);
addParameter(p, 'label', '', @ischar);
addParameter(p, 'showPercentage', true, @islogical);

parse(p, file_ltx, C, varargin{:});

placement = p.Results.placement;
blockLabels = p.Results.blockLabels;
classLabels = p.Results.classLabels;
alignment = p.Results.alignement;

num_classes = numel(classLabels);
row_labels = cell(1, num_classes);
col_labels = cell(1, num_classes);
for curr_class = 1:num_classes
    row_labels{curr_class} = ['True ', classLabels{curr_class}];
    col_labels{curr_class} = ['Predicted ', classLabels{curr_class}];
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
showPercentage = p.Results.showPercentage;

num_blocks = numel(C);

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
if (~isempty(row_labels))
    fprintf(file_ltx, 'l');
end
for curr_col = 1:num_classes
    fprintf(file_ltx, '%c', alignment);
end
fprintf(file_ltx, '}\r\n');

for curr_block = 1:num_blocks
    num_total = sum(sum(C{curr_block}));

    %     fprintf(file_ltx, '%s & \\text{Predicted Down} & \\text{Predicted Up} \\\\\n', blockLabels{curr_block});
    %     fprintf(file_ltx, '\\midrule\n');
    %     fprintf(file_ltx, 'True Down & %d, TN/PN: %2.1f\\%% & %d, FP/PP: %2.1f\\%% \\\\\n', ...
    %         C{curr_block}(1, 1), C{curr_block}(1, 1)/PN_PP(1)*100, C{curr_block}(1, 2), C{curr_block}(1, 2)/PN_PP(2)*100);
    %     fprintf(file_ltx, 'True Up & %d, FN/PN: %2.1f\\%% & %d, TP/PP %2.1f\\%% \\\\\n', ...
    %         C{curr_block}(2, 1), C{curr_block}(2, 1)/PN_PP(1)*100, C{curr_block}(2, 2), C{curr_block}(2, 2)/PN_PP(2)*100);
    %     fprintf(file_ltx, '\\midrule\n');
    %     fprintf(file_ltx, ' & %d, PN: %2.1f\\%% & %d, PP: %2.1f\\%% \\\\\n', PN_PP(1), PN_PP(1)/sum(PN_PP)*100, PN_PP(2), PN_PP(2)/sum(PN_PP)*100);

    if curr_block == 1
        fprintf(file_ltx, '\\toprule\r\n');
    else
        fprintf(file_ltx, '\\midrule[\\heavyrulewidth]\n');
    end

    % fill in block header with classes
    if (~isempty(col_labels))
        if (~isempty(blockLabels{curr_block}))
            fprintf(file_ltx, '%s & ', blockLabels{curr_block});
        elseif (~isempty(row_labels))
            fprintf(file_ltx, ' & ');
        end
        for curr_col = 1:num_classes - 1
            fprintf(file_ltx, '%s & ', col_labels{curr_col});
        end
        fprintf(file_ltx, '%s \\\\\r\n', col_labels{num_classes});
    end
    fprintf(file_ltx, '\\midrule\r\n');

    % fill in entries of confusion matrix
    for curr_row = 1:num_classes
        if (~isempty(row_labels))
            fprintf(file_ltx, '%s &', row_labels{curr_row});
        end
        for curr_col = 1:num_classes - 1
            if showPercentage
                fprintf(file_ltx, ' %d (%2.1f\\%%) &', ...
                    C{curr_block}(curr_row, curr_col), ...
                    C{curr_block}(curr_row, curr_col)/sum(C{curr_block}(:, curr_col))*100);
            else
                fprintf(file_ltx, ' %d &', C{curr_block}(curr_row, curr_col));
            end
        end
        if showPercentage
            fprintf(file_ltx, ' %d (%2.1f\\%%) \\\\\r\n', ...
                C{curr_block}(curr_row, num_classes), ...
                C{curr_block}(curr_row, num_classes)/sum(C{curr_block}(:, num_classes))*100);
        else
            fprintf(file_ltx, ' %d \\\\\r\n', C{curr_block}(curr_row, num_classes));
        end
    end
    fprintf(file_ltx, '\\midrule\r\n');

    % add column sums
    if (~isempty(row_labels))
        fprintf(file_ltx, '%s &', 'Sum');
    end
    for curr_col = 1:num_classes - 1
        fprintf(file_ltx, ' %d (%2.1f\\%%) &', ...
            sum(C{curr_block}(:, curr_col)), ...
            sum(C{curr_block}(:, curr_col))/num_total*100);
    end
    fprintf(file_ltx, ' %d (%2.1f\\%%) \\\\\r\n', ...
        sum(C{curr_block}(:, num_classes)), ...
        sum(C{curr_block}(:, num_classes))/num_total*100);
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
