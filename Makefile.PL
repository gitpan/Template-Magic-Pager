# This file uses the "Perlish" coding style
# please read http://perl.4pro.net/perlish_coding_style.html

; use 5.006_001
; use ExtUtils::MakeMaker

; my $dist = 'Template::Magic::Pager'
; my $vers = '1.12'

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

__END__

Note: While I did removed the "phone home opt-out only logic" from all my distributions since 2004-24-06, the related ratings have not been removed so far. Sorry for the inconvenience.

Domizio Demichelis
