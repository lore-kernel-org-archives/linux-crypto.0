From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random.c: LFSR polynomials are not irreducible/primitive
Date: Tue, 15 Aug 2017 10:45:17 +0200
Message-ID: <5311487.93A5fcTOOn@tauon.chronox.de>
References: <10436695.bPChAg2egJ@tauon.chronox.de> <20170814222105.oyswoj3xjyd5qu3c@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58850 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751518AbdHOIpU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Aug 2017 04:45:20 -0400
In-Reply-To: <20170814222105.oyswoj3xjyd5qu3c@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 15. August 2017, 00:21:05 CEST schrieb Theodore Ts'o:

Hi Theodore,

> Have you looked at section 3.1.1 of the above cited paper?
> 
> 	http://eprint.iacr.org/2012/251.pdf

Thanks for the hint, but that does not seem to solve the mystery either.

When I use magma with GF(2^32), I see that all polynomials are neither 
primitive nor irreducible:

F:=GF(4294967296);
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



The output is:

Finite field of size 2^32
Univariate Polynomial Ring in x over GF(2^32)
Old polynomials:
x^128 + x^103 + x^76 + x^51 + x^25 + x + 1
is irreducible:
false
is primitive:
false
x^32 + x^26 + x^20 + x^14 + x^7 + x + 1
is irreducible:
false
is primitive:
false
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


Thus, I am unsure how the referenced document concludes that the new 
polynomials are irreducible over GF(2^32).

Ciao
Stephan
