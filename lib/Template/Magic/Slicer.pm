package Template::Magic::Slicer ;
$VERSION = 1.0 ;

# This file uses the "Perlish" coding style
# please read http://perl.4pro.net/perlish_coding_style.html

; use strict
; use Carp
; $Carp::Internal{+__PACKAGE__}++
; our $no_template_magic_zone = 1 # prevents passing the zone object to properties
; use Template::Magic::Pager
; push our @ISA, 'Template::Magic::Pager'

; sub _init
   { my $s = shift
   ; my $r = $$s{total_results}
   ; $$s{total_results} = @$r
   ; $$s{page_rows} = [ @$r[ $s->start_offset .. $s->end_offset ] ]
   }
          
; use Object::props
        { name       => 'total_results'
        , validation => sub { ref eq 'ARRAY' }
        }

; sub page_rows { $_[0]{page_rows} }
     
; 1  

__END__

=head1 NAME

Template::Magic::Slicer - HTML Slicer for Template::Magic

=head1 VERSION 1.0

Included in Template-Magic-Pager 1.0 distribution.

The latest versions changes are reported in the F<Changes> file in this distribution.

The distribution includes:

=over

=item * Template::Magic::Pager

HTML Pager for Template::Magic

=item * Template::Magic::Slicer

HTML Slicer for Template::Magic

=back

=head1 INSTALLATION

=over

=item Prerequisites

    Perl version    >= 5.6.1
    Template::Magic >= 1.2
    OOTools         >= 1.71

=item Standard installation

From the directory where this file is located, type:

    perl Makefile.PL
    make
    make test
    make install

B<Note>: The installation of this module runs an automatic version check connection which will warn you in case a newer version is available: please don't use old versions, because I can give you full support only for current versions. Besides, since CPAN does not provide any download statistic to the authors, this check allows me also to keep my own installation counter. Version checking is transparent to regular users, while CPAN testers should skip it by running the Makefile.PL with NO_VERSION_CHECK=1.

=back

=head1 SYNOPSIS

  use Template::Magic::Slicer ;
  
  $pager = Template::Magic::Slicer->new
           ( total_results   => $results         # ARRAY ref
           , page_number     => $page_number     # integer
           , rows_per_page   => $rows_per_page   # integer
           , pages_per_index => $pages_per_index # integer
           ) ;

and inside the 'I<pager>' block in your template file you will have availables the complete set of L<"Labels and Blocks"> supplied by Template::Magic::Pager, plus the C<page_rows> block, that is the current page slice of the results.

=head1 DESCRIPTION

This module is a sub-class of Template::Magic::Pager, so you should start to read L<Template::Magic::Pager>. Template::Magic::Slicer implements a couple of differences from its base class, which are useful when you already have all the results in memory.

B<Note>: If you have big number of results coming from a DB query you should use the L<Template::Magic::Pager|Template::Magic::Pager> which is written exactly for that situation.

=head2 Useful links

=over

=item *

A simple and useful navigation system between my modules is available at this URL: http://perl.4pro.net

=item *

More practical topics are probably discussed in the mailing list at this URL: http://lists.sourceforge.net/lists/listinfo/template-magic-users

=back

=head1 METHODS

=head2 new( arguments )

As Template::Magic::Pager::new(), this method returns the new object reference ONLY if there are results to display (see L<total_results> below). It accepts the same arguments of its super class with only this difference:

=over

=item * total_results

Mandatory argument. It must be a B<reference to the array of results> you want to split into pages (not to be confused with the results of one page). If the referenced array does not contain any element, then the new() method will return the undef value instead of the object, thus allowing you to define a C<NOT_pager> block that will be printed when no result has been found.

=back

=head1 Labels and Blocks

This module adds one block to the standard Template::Magic::Pager set of Labels and Blocks:

=over

=item * page_rows (block)

This block will be automatically used by Template::Magic to generate the printing loop with the slice of results of the current page.

=back

=head1 SEE ALSO

L<Template::Magic::Pager|Template::Magic::Pager>

=head1 SUPPORT

Support for all the modules of the Template Magic System is via the mailing list. The list is used for general support on the use of the Template::Magic, announcements, bug reports, patches, suggestions for improvements or new features. The API to the Magic Template System is stable, but if you use it in a production environment, it's probably a good idea to keep a watch on the list.

You can join the Template Magic System mailing list at this url:

L<http://lists.sourceforge.net/lists/listinfo/template-magic-users>

=head1 AUTHOR and COPYRIGHT

© 2004 by Domizio Demichelis (L<http://perl.4pro.net>)

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as perl itself.
