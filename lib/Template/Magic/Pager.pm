package Template::Magic::Pager ;
$VERSION = 1.0 ;

# This file uses the "Perlish" coding style
# please read http://perl.4pro.net/perlish_coding_style.html

; use strict
; use Carp
; $Carp::Internal{+__PACKAGE__}++ 
; our $no_template_magic_zone = 1 # prevents passing the zone object to properties  
     
; sub new
   { my $c = shift
   ; ref($c)  && croak qq(Can't call method "new" on a reference)
   ; (@_ % 2) && croak qq(Odd number of arguments for "$c"->new)
   ; my $s = bless {}, $c
   ; while ( my ($p, $v) = splice @_, 0, 2 )
      { if ($s->can($p))                     # if method
         { $s->$p( $v )          
         }
        else
         { croak qq(No such property "$p")
         }
      }
   ; $s->_init if $s->can('_init')
   ; $$s{total_results} ? $s : undef
   }
      
; use Object::props
      ( { name       => 'total_results'
        , validation => sub { /^[\d]+$/ }  # verificare _
        }
      , { name       => 'page_number'
        , default    => 1
        , validation => sub
                         { /^[\d]+$/
                         && $_ > 0
                         }
        } 
      , { name       => [ qw | rows_per_page 
                               pages_per_index 
                             |
                        ]
        , default    => 10
        , validation => sub{ /^[\d]+$/ }
        }
      )
      
; sub total_pages
   { my $s = shift
   ; int ($s->total_results / $s->rows_per_page)
     + ($s->total_results % $s->rows_per_page ? 1 : 0)
   }

; sub next_page
   { my $s = shift
   ; $s->page_number + 1 if $s->page_number < $s->total_pages
   }
   
; sub next 
   { $_[0]->next_page && {}
   }

; sub previous_page
   { my $s = shift
   ; $s->page_number - 1 if $s->page_number > 1  
   }
   
; sub previous 
   { $_[0]->previous_page && {} 
   }
   
; sub start_offset
   { my ($s, $page_number) = @_
   ; $page_number ||= $s->page_number
   ; $s->rows_per_page * ($page_number - 1)
   }
   
; sub end_offset
   { my ($s, $page_number) = @_
   ; my $end = $s->start_offset($page_number) + $s->rows_per_page - 1
   ; $end > ($s->total_results - 1)
     ? $s->total_results - 1
     : $end
   }

; sub start_result 
   { my ($s, $page_number) = @_
   ; $s->start_offset($page_number) + 1 
   }

; sub end_result
   { my ($s, $page_number) = @_
   ; $s->end_offset($page_number) + 1 
   }
 
; sub index
   { my $s = shift
   ; my ( $half, $start, $end )
   ; $half = int ($s->pages_per_index / 2)
   ; my $page_number = $s->page_number
   ; my $page_count  = $s->total_pages
   ; if ( $page_count / 2 > $page_number) # if first half
      { $start = $page_number - $half
      ; $start = 1 if $start < 1
      ; $end   = $start + $s->pages_per_index - 1
      ; $end   = $page_count if $end > $page_count
      }
     else
      { $end   = $page_number + $half
      ; $end   = $page_count if $end > $page_count
      ; $start = $end - $s->pages_per_index + 1
      ; $start = 1 if $start < 1
      }
   ; my @i = map
              { $_ + 1 != $page_number
                ? { linked_page  => {}
                  , page_number  => $_ + 1
                  , start_result => $s->start_result($_+1)
                  , end_result   => $s->end_result($_+1)
                  }
                : { current_page => {}
                  , page_number  => $_ + 1
                  }
              } $start - 1 .. $end - 1
   ; \ @i
   }

     
; 1

__END__

=head1 NAME

Template::Magic::Pager - HTML Pager for Template::Magic

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

  use Template::Magic::Pager ;
  
  $pager = Template::Magic::Pager->new
           ( total_results   => $results         # integer
           , page_number     => $page_number     # integer
           , rows_per_page   => $rows_per_page   # integer
           , pages_per_index => $pages_per_index # integer
           ) ;

and inside the 'I<pager>' block in your template file you will have availables a complete set of L<"Labels and Blocks">.

=head1 DESCRIPTION

This module make it very simple to split an array of results into pages, and use your own totally customizable Template-Magic file to display each page; it is fully integrated with CGI::Builder::Magic and its handlers (such as TableTiler), and it can be used efficiently with any DB.

Using it is very simple: you have just to create an object in your code and define a block in your template and Template::Magic will do the rest. Inside the block you will have available a complete set of magic labels to define the result headers, dynamic index navigation bars Goooogle style and more. (see L<"Labels and Blocks">)

B<Note>: This module is very useful when you have big number of results coming from a DB query, because you don't need to retrieve them all in order to initialize the object (i.e. you just need to pass the total number of results, not the whole array reference of the results).

If you already have all the results in memory, you should use the L<Template::Magic::Slicer|Template::Magic::Slicer> which is written exactly for that situation.

=head2 Useful links

=over

=item *

A simple and useful navigation system between my modules is available at this URL: http://perl.4pro.net

=item *

More practical topics are probably discussed in the mailing list at this URL: http://lists.sourceforge.net/lists/listinfo/template-magic-users

=back

=head1 METHODS

=head2 new( arguments )

This method returns the new object reference ONLY if there are results to display (see L<total_results> below). It accepts the following arguments:

=over

=item * total_results

Mandatory argument. It must be an integer value of the total number of results you want to split into pages (not to be confused with the results of one page). If the passed value is not true (0 or undef), then the new() method will return the undef value instead of the object, thus allowing you to define a C<NOT_pager> block that will be printed when no result has been found.

=item * page_number

It expects an integer value representing the page to display. Default is 1 (i.e. if no value is passed then the page number 1 will be displayed).

=item * rows_per_page

Optional argument. This is the number of results that will be displayed for each page. Default 10.

=item * pages_per_index

Optional argument. This is the number of pages (or items) that will build the index bar. Default 10. (see also L<index|"item_index">)       

=back

=head2 Other Methods

Since all the magics of this module is done automatically by Template::Magic, usually you will explicitly use just the new() method. Anyway, each L<"Labels and Blocks"> listed below is referring to an object method that returns the indicated value. The Block methods -those indicated with "(block)"- are just boolean methods that check some conditions and return a reference to an empty array when the condition is true, or undef when it is false.

=head1 Labels and Blocks

These are the labels and blocks available inside the pager block:

=over

=item * start_result

The number of the result which starts the current page.

=item * end_result

The number of the result which ends the current page.

=item * total_results

The number of the total results (same number passed as the total_results argument: see L<new()|"new( arguments )">).

=item * page_number

The current page number (same number passed as the page_number argument: see L<new()|"new( arguments )">)

=item * total_pages

The total number of pages that have been produced by splitting the results.

=item * previous (block)

This block will be printed when the current page has a previous page, if there is no previous page (i.e. when the current page is the first page), then the content of this block will be wiped out. If you need to print somethingjust when the current page has no previous page (e.g. a dimmed 'Previous' link or image), then you should define a C<NOT_previous> block: it will be printed automatically when the C<previous> block is not printed.

=item * previous_page 

The number of the page previous to the current page. Undefined if there are no previous pages (i.e. when the current page is the first page).

=item * next (block)

This block will be printed when the current page has a next page, if there is no next page (i.e. when the current page is the last page), then the content of this block will be wiped out. If you need to print something just when the current page has no next page (e.g. a dimmed 'Next' link or image), then you just need to define a C<NOT_next> block: it will be printed automatically when the C<next> block is not printed.

=item * next_page

The number of the page next to the current page. Undefined if there are no next pages (i.e. the current page is the last page).  

=item * index (block)

This block defines the index bar loop: each item of the loop has its own set of values defining the C<page_number>, C<start_result> and C<end_result> of each index item. Nested inside the index block you should define a couple of other blocks: the C<current_page> and the C<linked_page> blocks.

=over

=item current_page (block)  

This block will be printed only when the index item refers to the current page, thus allowing you to print this item in a different way from the others items.

=item linked_page (block)

This block will be printed for all the index items unless the item is referring to the current page.

=back

=back

=head1 EXAMPLE

This is a complete example with results coming from a DB query. In this case you don't want to retrieve the whole results that would be probably huge, but just the results in the page to display:

  use Template::Magic ;
  use Template::Magic::Pager ;
  use CGI;
  
  my $cgi = CGI->new() ;
  my $pages_per_index = 20 ;
  my $rows_per_page   = $cgi->param('rows') ;                 # e.g. 20
  my $page_number     = $cgi->param('page') ;                 # e.g. 3
  my $offset          = $rows_per_page * ($page_number - 1) ; # e.g. 40
  
  # this manages the page_rows template block (notice the 'our')
  # (change the assignment with any real DB query)
  our $page_rows  = ... SELECT ...
                        LIMIT $offset, $rows_per_page ... ;   # ARRAY ref
  my $count       = ... SELECT FOUND_ROWS() ... ;             # integer e.g 526
  
  # $pager whould be undef if $count is not true
  our $pager = Template::Magic::Pager->new
               ( total_results   => $count           # (e.g 1526)
               , page_number     => $page_number     # (3)
               , rows_per_page   => $rows_per_page   # (20)
               , pages_per_index => $pages_per_index # (20)
               ) ; 
  
  Template::Magic::HTML->new->print('/path/to/template') ;

In this example C<$main::page_rows> contains the array of results to display for the current page, and it will be used automagically by Template::Magic to fill the C<page_rows> template block.

B<Note>: To be sure the object is syncronized with the retrived DB query, you must use the correct C<offset> and C<rows_per_page> in both DB retrieving and object initialization. To do so you should use this simple algorithm:

  my $offset = $rows_per_page * ($page_number - 1) ;

=head1 SEE ALSO

L<Template::Magic::Slicer|Template::Magic::Slicer>

=head1 SUPPORT

Support for all the modules of the Template Magic System is via the mailing list. The list is used for general support on the use of the Template::Magic, announcements, bug reports, patches, suggestions for improvements or new features. The API to the Magic Template System is stable, but if you use it in a production environment, it's probably a good idea to keep a watch on the list.

You can join the Template Magic System mailing list at this url:

L<http://lists.sourceforge.net/lists/listinfo/template-magic-users>

=head1 AUTHOR and COPYRIGHT

© 2004 by Domizio Demichelis (L<http://perl.4pro.net>)

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as perl itself.
