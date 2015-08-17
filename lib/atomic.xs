#define PERL_NO_GET_CONTEXT 1
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "stdio.h"

int _do_compare_and_swap(SV *ref, SV *oldval, SV *newval) {
  if(!SvROK(ref))
    croak("ref is not a reference!");
  if(__sync_bool_compare_and_swap(&SvRV(ref), oldval, newval)) {
    SvREFCNT_dec(oldval);
    SvREFCNT_inc(newval);
    return 1;
  } else return 0;
}

SV *_do_swap(SV *block, SV *ref) {
  dSP;
  SV *old;
  SV *new;
  int count;

  if(!SvROK(ref))
    croak("ref is not a reference!");

  do {
    old = SvRV(ref);
    /* perlguts is sooooooooooo fucking creaky. WTF?! at all of this boilerplate */
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    EXTEND(SP, 1);
    PUSHs(old);
    PUTBACK;
    count = call_sv(block, G_SCALAR | G_EVAL);
    SPAGAIN; 
    switch (count) {
      case 0:  new = &PL_sv_undef; break;
      case 1:  new = POPs; break;
      default: croak("Expected 0 or 1 args returned from block, got %d", count);
    }
    PUTBACK;
    FREETMPS;
    LEAVE;
  } while (_do_compare_and_swap(ref, old, new));
  return new;
}

MODULE = atomic   PACKAGE = atomic


PROTOTYPES: DISABLE


SV
_compare_and_swap(SV *ref, SV *oldval, SV *newval)
PROTOTYPE: $$$
CODE:
    RETVAL = _do_compare_and_swap(ref, oldval, newval) ? PL_sv_yes : PL_sv_no;
OUTPUT: RETVAL


SV *
_swap(SV *block, SV *ref)
PROTOTYPE: &$
CODE:
  RETVAL = _do_swap(block, ref);
OUTPUT: RETVAL
