
# Use pdflatex
# $pdf_mode = 1;

# Use XeLaTeX
# $pdf_mode = 5;

# Use LuaLaTeX (recommended for new documents: https://www.texdev.net/2024/11/05/engine-news-from-the-latex-project)
$pdf_mode = 4;

$dvi_mode = 0;
$postscript_mode = 0;

@default_files = ("thesis");

# Custom dependency and function for glossaries package 
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');

# Custom dependency and function for nomencl package 
add_cus_dep( 'nlo', 'nls', 0, 'run_makeindex' );


push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' %R.ist %R.xdy';

sub run_makeindex {
    system( "makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"" );
}

sub run_makeglossaries {
    my ($base_name, $path) = fileparse( $_[0] ); #handle -outdir param by splitting path and file, ...
    pushd $path; # ... cd-ing into folder first, then running makeglossaries ...

    if ( $silent ) {
        # system "makeglossaries -q '$base_name'"; #unix
        system "makeglossaries", "-q", "$base_name"; #windows
    }
    else {
        # system "makeglossaries '$base_name'"; #unix
        system "makeglossaries", "$base_name"; #windows
    };

    popd; # ... and cd-ing back again
}