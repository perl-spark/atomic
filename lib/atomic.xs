#define PERL_NO_GET_CONTEXT 1
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "stdio.h"

MODULE = atomic   PACKAGE = atomic

PROTOTYPES: DISABLE

SV
compare_and_swap(SV * ref, SV * oldval, SV * newval)
PROTOTYPE: $$$
CODE:
    if(!SvROK(ref))
      croak("ref is not a reference!");
    if(__sync_bool_compare_and_swap(&SvRV(ref), oldval, newval)) {
      SvREFCNT_dec(oldval);
      SvREFCNT_inc(newval);
      RETVAL=PL_sv_yes;
    } else {
      RETVAL=PL_sv_no;
    }
OUTPUT:
    RETVAL