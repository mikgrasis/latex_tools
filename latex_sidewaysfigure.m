function latex_sidewaysfigure(file_ltx, str_fig_name, str_caption, str_label, varargin)
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
%   file_ltx        - file handle
%   str_fig_name    - .eps figure filename
%   str_caption     - caption
%   str_label       - label, e.g., 'fig_bla_3'
%   varargin        - key-value argument pairs
p = inputParser;
addParameter(p, 'placement', '!h', @ischar);
addParameter(p, 'fig_width', '0.5\textwidth', @ischar);
parse(p, varargin{:});

placement = p.Results.placement;
fig_width = p.Results.fig_width;

% add figure to Latex Document
fprintf(file_ltx, '\\begin{sidewaysfigure}[%s]\n', placement);  % \begin{figure}[!h]
fprintf(file_ltx, '\\centering\n');                             % \centering
fprintf(file_ltx, '\\includegraphics[clip, trim=0cm 0cm 0cm 0cm, width=%s]{figures/%s.eps}\n', fig_width, str_fig_name);
fprintf(file_ltx, '%%trim=left bottom right top\n');            % %trim=left bottom right top
fprintf(file_ltx, '\\caption{%s}\n', str_caption);              % \caption{str_caption}
fprintf(file_ltx, '\\label{%s}\n', str_label);                  % \label{str_label}
fprintf(file_ltx, '\\end{sidewaysfigure}\n');                   % \end{figure}
fprintf(file_ltx, '\n\n');

end
