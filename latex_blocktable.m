function latex_blocktable(fid, block_inputs, varargin)
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
% |         based on matrix2latex.m by M. Koehler (as edited by M. Ranaivombola)
% |     Modifications:
% |     19.02.2023 - initial version (MG)
% |----------------------------------------------------------------
%
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
% latex_blocktable(matrix, block_inputs, varargs)
% where
%   - fid is a valid file handle
%   - block_inputs is a cell 2 dimensional (numerical) inputs
%   - varargs is one ore more of the following (key, value) combinations
%      + 'blockLabels', array -> Can be used to label the blocks of the
%      resulting latex table
%      + 'rowLabels', array -> Can be used to label the rows of the
%      resulting latex table
%      + 'columnLabels', array -> Can be used to label the columns of the
%      resulting latex table
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
addRequired(p, 'fid');
addRequired(p, 'matrix', @ismatrix);
addParameter(p, 'placement', '!h', @ischar);
addParameter(p, 'blockLabels', @ischar);
addParameter(p, 'rowLabels', @ischar);
addParameter(p, 'columnLabels', @ischar);
addParameter(p, 'alignment', 'c', @ischar);
addParameter(p, 'format', '%-6.2f', @ischar);
addParameter(p, 'size', '', @ischar);
addParameter(p, 'caption', '', @ischar);
addParameter(p, 'label', '', @ischar);

parse(p, fid, block_inputs, varargin{:});

placement = p.Results.placement;
blockLabels = p.Results.blockLabels;
rowLabels = p.Results.rowLabels;
colLabels = p.Results.columnLabels;
alignment = p.Results.alignment;

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

format = p.Results.format;
textsize = p.Results.size;
caption = p.Results.caption;
label = p.Results.label;

num_blocks = numel(block_inputs);
num_rows_per_block = size(block_inputs{1}, 1);
num_cols = size(block_inputs{1}, 2);

if isnumeric(block_inputs{1})
    for curr_block = 1:num_blocks
        block_inputs{curr_block} = num2cell(block_inputs{curr_block});
        for curr_row = 1:num_rows_per_block
            for curr_col = 1:num_cols
                if (~isempty(format))
                    block_inputs{curr_block}{curr_row, curr_col} = num2str(block_inputs{curr_block}{curr_row, curr_col}, format);
                else
                    block_inputs{curr_block}{curr_row, curr_col} = num2str(block_inputs{curr_block}{curr_row, curr_col});
                end
            end
        end
    end
end

%% Begin Table
fprintf(fid, '\\begin{table}[%s]\n', placement);

% handle caption and label
if (~isempty(caption)) && (~isempty(label))
    fprintf(fid, '\\caption{%s} \\label{%s}\n', caption, label);
elseif (~isempty(caption))
    fprintf(fid, '\\caption{%s}\n', caption);
elseif (~isempty(label))
    fprintf(fid, '\\label{%s}\n', label);
end

%% Populate Table
fprintf(fid, '\\begin{center}\n');
if (~isempty(textsize))
    fprintf(fid, '\\begin{%s}\n', textsize);
end
fprintf(fid, '\\begin{tabular}{');
if (~isempty(rowLabels))
    fprintf(fid, 'l');
end
for curr_col = 1:num_cols
    fprintf(fid, '%c', alignment);
end
fprintf(fid, '}\r\n');

for curr_block = 1:num_blocks
    fprintf(fid, '\\toprule\r\n');
    if (~isempty(colLabels))
        if (~isempty(blockLabels{curr_block}))
            fprintf(fid, '%s & ', blockLabels{curr_block});
        elseif (~isempty(rowLabels))
            fprintf(fid, ' & ');
        end
        for curr_col = 1:num_cols - 1
            fprintf(fid, '%s & ', colLabels{curr_col});
        end
        fprintf(fid, '%s \\\\\r\n', colLabels{num_cols});
    end
    fprintf(fid, '\\midrule\r\n');
    fprintf(fid, '\\midrule\r\n');

    for curr_row = 1:num_rows_per_block
        if (~isempty(rowLabels))
            fprintf(fid, '%s &', rowLabels{curr_row});
        end
        for curr_col = 1:num_cols - 1
            fprintf(fid, ' %s &', block_inputs{curr_block}{curr_row, curr_col});
        end
        fprintf(fid, ' %s \\\\\r\n', block_inputs{curr_block}{curr_row, num_cols});
    end
end

%% End Table
fprintf(fid, '\\bottomrule\r\n');
fprintf(fid, '\\end{tabular}\r\n');
if (~isempty(textsize))
    fprintf(fid, '\\end{%s}', textsize);
end
fprintf(fid, '\\end{center}\n');
fprintf(fid, '\\end{table}\n\n');

end
