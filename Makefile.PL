# This file uses the "Perlish" coding style
# please read http://perl.4pro.net/perlish_coding_style.html

; use 5.006_001
; use ExtUtils::MakeMaker

; my $dist = 'Template::Magic::Pager'
; my $vers = '1.11'

; WriteMakefile
   ( NAME           => $dist
   , VERSION        => $vers
   , ( $] ge '5.005' )
     ? ( AUTHOR     => 'Domizio Demichelis - perl.4pro.net'
       , ABSTRACT   => 'HTML Pager for Template::Magic'
       )
     : ()
   , PREREQ_PM      => { 'Class::constr'   => '1.72'
                       , 'Object::props'   => '1.72'
                       , 'Template::Magic' => '1.21'
                       }
   )


; 1
