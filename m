From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: random.c: LFSR polynomials are not irreducible/primitive
Date: Mon, 14 Aug 2017 18:21:05 -0400
Message-ID: <20170814222105.oyswoj3xjyd5qu3c@thunk.org>
References: <10436695.bPChAg2egJ@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43206 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752408AbdHNWVI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 18:21:08 -0400
Content-Disposition: inline
In-Reply-To: <10436695.bPChAg2egJ@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 14, 2017 at 10:20:18AM +0200, Stephan Mueller wrote:
> Hi Ted,
> 
> drivers/char/random.c contains the following comment:
> 
> """
>  * Our mixing functions were analyzed by Lacharme, Roeck, Strubel, and
>  * Videau in their paper, "The Linux Pseudorandom Number Generator
>  * Revisited" (see: http://eprint.iacr.org/2012/251.pdf).  In their
>  * paper, they point out that we are not using a true Twisted GFSR,
>  * since Matsumoto & Kurita used a trinomial feedback polynomial (that
>  * is, with only three taps, instead of the six that we are using).
>  * As a result, the resulting polynomial is neither primitive nor
>  * irreducible, and hence does not have a maximal period over
>  * GF(2**32).  They suggest a slight change to the generator
>  * polynomial which improves the resulting TGFSR polynomial to be
>  * irreducible, which we have made here.
> """
> 
> This comment leads me to belief that the current polynomial is primitive (and 
> irreducible).
> 
> Strangely, this is not the case as seen with the following code that can be 
> used with the mathematical tool called magma. There is a free online version 
> of magma available to recheck it: http://magma.maths.usyd.edu.au/calc/
> 
> Note, the polynomials used up till 3.12 were primitive and irreducible.
> 
> Could you please help me understanding why the current polynomials are better 
> than the old ones?

Have you looked at section 3.1.1 of the above cited paper?

	http://eprint.iacr.org/2012/251.pdf

							- Ted
