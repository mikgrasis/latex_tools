function latex_subsection(file_ltx, str_section_title, str_section_label)
%
% |----------------------------------------------------------------
% | (C) 2022 Mikus Grasis
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
% |     Date authored: 03.12.2022
% |     Modifications:
% |     03.12.2022 - initial version (MG)
% |----------------------------------------------------------------
%
% Inputs:
%   file_ltx            - file handle
%   str_section_title   - section title
%   str_section_label   - section label
if nargin < 3
    str_section_label = [];
end

if ~isempty(str_section_label)
    fprintf(file_ltx, '\n\\subsection{%s} %%\\label{sec_}\n', str_section_title);
else
    fprintf(file_ltx, '\n\\subsection{%s} %%\\label{%s}\n', str_section_title, str_section_label);
end
str = '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%';
fprintf(file_ltx, '%s\n', str);
fprintf(file_ltx, '%%\n');

end
