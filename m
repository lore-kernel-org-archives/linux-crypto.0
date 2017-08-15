From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: random.c: LFSR polynomials are not irreducible/primitive
Date: Tue, 15 Aug 2017 11:12:24 -0400
Message-ID: <20170815151224.jff5kvmin44lhkot@thunk.org>
References: <10436695.bPChAg2egJ@tauon.chronox.de>
 <20170814222105.oyswoj3xjyd5qu3c@thunk.org>
 <5311487.93A5fcTOOn@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        david.fontaine@capgemini.com, olivier.vivolo@orange.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46122 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbdHOPMa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Aug 2017 11:12:30 -0400
Content-Disposition: inline
In-Reply-To: <5311487.93A5fcTOOn@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 15, 2017 at 10:45:17AM +0200, Stephan Mueller wrote:
> Am Dienstag, 15. August 2017, 00:21:05 CEST schrieb Theodore Ts'o:
> 
> Hi Theodore,
> 
> > Have you looked at section 3.1.1 of the above cited paper?
> > 
> > 	http://eprint.iacr.org/2012/251.pdf
> 
> Thanks for the hint, but that does not seem to solve the mystery either.
> 
> When I use magma with GF(2^32), I see that all polynomials are neither 
> primitive nor irreducible:

I believe that assertion being made in that section is not that
modified P(X) is primitive, but that Q(X) is primitive

	Q(X) = α**3 (P(X) − 1) + 1

Where multiplication by α**3 is done by a twist-table lookup.

Also of interest might be this paper, which I believe totally missed
when the authors made their proposal on the linux-crypto list in
September 2016 (I've added them to the cc list):

	https://eprint.iacr.org/2017/726.pdf

The date on the paper is from just 3 weeks ago or so, and it was just
luck that I found it when Googling to find some other references in
response to your question.  (Thanks for raising the question, BTW).

I don't have a huge amount invested in any of the mixing schemes,
because in practice we are *not* feeding large number of zero inputs
into mixing function.  So while it is good to make the mixing function
to have as large a cyclic length as possible, it seems unlikely that
the weaknesses of the current polynomials can be leveraged into a
practical attack.

Stephan, if you have any comments on the proposal made by David
Fontaine and Olivier Vivolo, I'd appreciate hearing them!

						- Ted
