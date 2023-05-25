function latex_includegraphics(file_ltx, str_fig_name, varargin)
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
% |     Date authored: 13.02.2023
% |     Modifications:
% |     13.02.2023 - initial version (MG)
% |----------------------------------------------------------------
%
% Inputs:
%   file_ltx        - file handle
%   str_fig_name    - .eps figure filename
%   varargin        - key-value argument pairs
p = inputParser;
addParameter(p, 'fig_width', '0.5\textwidth', @ischar);
parse(p, varargin{:});

fig_width = p.Results.fig_width;

% add figure to Latex Document
fprintf(file_ltx, '\\includegraphics[clip, trim=0cm 0cm 0cm 0cm, width=%s] %%trim=left bottom right top\n', fig_width);
fprintf(file_ltx, '{%s.eps}\n', str_fig_name);
fprintf(file_ltx, '%%\n');

end
