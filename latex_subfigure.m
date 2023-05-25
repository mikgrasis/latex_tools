function latex_subfigure(file_ltx, str_subfig_names, str_subfig_captions, str_main_caption, str_subfig_labels, str_main_label, varargin)
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
% |     Date authored: 10.01.2023
% |     Modifications:
% |     10.01.2023 - initial version (MG)
% |----------------------------------------------------------------
%
% Inputs:
%   file_ltx            - file handle of LaTeX
%   str_subfig_names    - cell with (.eps)-file figure names
%   str_subfig_captions - cell with captions for subfigures
%   str_main_caption    - strgin with main caption
%   str_subfig_labels   - cell with labels for subfigures
%   str_main_label      - cell with main label for figure
%   varargin            - optional arguments (e.g., key-value pairs of options)

p = inputParser;
addParameter(p, 'placement', '!h', @ischar);
addParameter(p, 'subfig_width', '0.45\textwidth', @ischar);
parse(p, varargin{:});

placement = p.Results.placement;
subfig_width = p.Results.subfig_width;


num_subfigs = length(str_subfig_names);

% create default subfigure labels if not provided
if isempty(str_subfig_labels)
    str_subfig_labels = cell(1, num_subfigs);
    for curr_subfig = 1:num_subfigs
        str_subfig_labels{curr_subfig} = sprintf('%s_%d', str_main_label, curr_subfig);
    end
end

% start figure environment
fprintf(file_ltx, '\\begin{figure}[%s]\n', placement);                      % \begin{figure}[!h]
fprintf(file_ltx, '\\centering\n');                                         % \centering
fprintf(file_ltx, '%%\n');                                                  % %

% add subfigures
for curr_subfig = 1:num_subfigs
    fprintf(file_ltx, '\\begin{subfigure}[b]{%s}\n', subfig_width);         % \begin{subfigure}[b]{0.45\textwidth}
    fprintf(file_ltx, '\\centering\n');                                     % \centering
    fprintf(file_ltx, '\\includegraphics[clip, trim=0cm 0cm 0cm 0cm, width=\\textwidth]{figures/%s.eps}\n', str_subfig_names{curr_subfig});
    fprintf(file_ltx, '%%trim=left bottom right top\n');                    % %trim=left bottom right top
    fprintf(file_ltx, '\\caption{%s}\n', str_subfig_captions{curr_subfig}); % \caption{close price}
    fprintf(file_ltx, '\\label{%s}\n', str_subfig_labels{curr_subfig});     % \label{fig_SYMBOL_price}
    fprintf(file_ltx, '\\end{subfigure}\n');                                % \end{subfigure}
    fprintf(file_ltx, '%%\n');                                              % %
end

% add main caption and end figure environment
fprintf(file_ltx, '\\caption{%s}\n', str_main_caption);                     % \caption{str_main_caption}
fprintf(file_ltx, '\\label{%s}\n', str_main_label);                         % \label{fig_str_main_label}
fprintf(file_ltx, '\\end{figure}\n');                                       % \end{figure}
fprintf(file_ltx, '\n\n');

end
