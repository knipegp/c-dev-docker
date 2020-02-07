" " Syntastic c setup
let g:syntastic_c_checkers = ['clang_tidy', 'oclint']
let g:syntastic_c_clang_tidy_args = '-checks=clang-analyzer-*,cppcoreguidelines-* -p compile_commands.json'
let g:syntastic_c_clang_tidy_post_args = ""
let g:syntastic_c_oclint_post_args = ""
" " Syntastic cpp setup
let g:syntastic_cpp_checkers = ['clang_tidy', 'oclint']
let g:syntastic_cpp_clang_tidy_args = '-checks=clang-analyzer-*,cppcoreguidelines-*'
let g:syntastic_cpp_oclint_post_args = '-- -std=c++11'
