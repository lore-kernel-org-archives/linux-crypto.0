From: Stephan Mueller <smueller@chronox.de>
Subject: random.c: LFSR polynomials are not irreducible/primitive
Date: Mon, 14 Aug 2017 10:20:18 +0200
Message-ID: <10436695.bPChAg2egJ@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58786 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751542AbdHNIUV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 04:20:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ted,

drivers/char/random.c contains the following comment:

"""
 * Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
 * Videau in their paper, "The Linux Pseudorandom Number Generator
 * Revisited" (see: http://eprint.iacr.org/2012/251.pdf).  In their
 * paper, they point out that we are not using a true Twisted GFSR,
 * since Matsumoto & Kurita used a trinomial feedback polynomial (that
 * is, with only three taps, instead of the six that we are using).
 * As a result, the resulting polynomial is neither primitive nor
 * irreducible, and hence does not have a maximal period over
 * GF(2**32).  They suggest a slight change to the generator
 * polynomial which improves the resulting TGFSR polynomial to be
 * irreducible, which we have made here.
"""

This comment leads me to belief that the current polynomial is primitive (and 
irreducible).

Strangely, this is not the case as seen with the following code that can be 
used with the mathematical tool called magma. There is a free online version 
of magma available to recheck it: http://magma.maths.usyd.edu.au/calc/

Note, the polynomials used up till 3.12 were primitive and irreducible.

Could you please help me understanding why the current polynomials are better 
than the old ones?

Thanks a lot.

F:=GF(2);
F;

P<x>:=PolynomialRing(F);
P;

print "Old polynomials:";

P<x>:=x^128 + x^103 + x^76 + x^51 +x^25 + x + 1;
P;
print "is irreducible: "; IsIrreducible(P);
print "is primitive: "; IsPrimitive(P);

P<x>:=x^32 + x^26 + x^20 + x^14 + x^7 + x + 1;
P;
print "is irreducible: "; IsIrreducible(P);
print "is primitive: "; IsPrimitive(P);

print "New polynomials:";

P<x>:=x^128 + x^104 + x^76 + x^51 +x^25 + x + 1;
P;
print "is irreducible: "; IsIrreducible(P);
print "is primitive: "; IsPrimitive(P);

P<x>:=x^32 + x^26 + x^19 + x^14 + x^7 + x + 1;
P;
print "is irreducible: "; IsIrreducible(P);
print "is primitive: "; IsPrimitive(P);

And obtained:

Finite field of size 2
Univariate Polynomial Ring in x over GF(2)
Old polynomials:
x^128 + x^103 + x^76 + x^51 + x^25 + x + 1
is irreducible:
true
is primitive:
true
x^32 + x^26 + x^20 + x^14 + x^7 + x + 1
is irreducible:
true
is primitive:
true
New polynomials:
x^128 + x^104 + x^76 + x^51 + x^25 + x + 1
is irreducible:
false
is primitive:
false
x^32 + x^26 + x^19 + x^14 + x^7 + x + 1
is irreducible:
false
is primitive:
false


Ciao
Stephan
