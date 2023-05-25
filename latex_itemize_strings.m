function latex_itemize_strings(file_ltx, str_items)
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
% |     Date authored: 03.12.2022
% |     Modifications:
% |     03.12.2022 - initial version (MG)
% |----------------------------------------------------------------
%
% Inputs:
%   file_ltx    - file handle
%   str_items   - cell with strings
num_items = numel(str_items);

fprintf(file_ltx, '\\begin{itemize}\\itemsep0ex\n');
for curr_item = 1:num_items
    fprintf(file_ltx, '\\item %s\n', str_items{curr_item});
end
fprintf(file_ltx, '\\end{itemize}\n\n');

end
