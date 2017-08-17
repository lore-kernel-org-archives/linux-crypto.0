From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random.c: LFSR polynomials are not irreducible/primitive
Date: Thu, 17 Aug 2017 08:07:21 +0200
Message-ID: <3391688.VOOQBju3Jz@tauon.chronox.de>
References: <10436695.bPChAg2egJ@tauon.chronox.de> <5311487.93A5fcTOOn@tauon.chronox.de> <20170815151224.jff5kvmin44lhkot@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        david.fontaine@capgemini.com, olivier.vivolo@orange.com
To: Theodore Ts'o <tytso@mit.edu>, noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58948 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbdHQGHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 02:07:23 -0400
In-Reply-To: <20170815151224.jff5kvmin44lhkot@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 15. August 2017, 17:12:24 CEST schrieb Theodore Ts'o:

Hi Theodore, Jeffrey,
> 
> Stephan, if you have any comments on the proposal made by David
> Fontaine and Olivier Vivolo, I'd appreciate hearing them!

(from Jefferey):

> This may be helpful, too. I use it to look up minimal weight
> irreducibles when I need them.
> http://www.hpl.hp.com/techreports/98/HPL-98-135.pdf

Thanks for the list of polynomials. There is even another list that I used for 
my LRNG: http://courses.cse.tamu.edu/csce680/walker/lfsr_table.pdf.

The problem with all of these polynomials is that their taps are very close 
together and are mostly in the high parts. As there is a chance that adjacent 
event values that shall be processed with the LFSR have some form of 
correlation, having taps close together is not good, especially when they are 
in the high parts of the polynomial.

To counter that effect, either polynomials with spaced-out taps are good (as 
sought by Ted).

There is another solution that I found which was confirmed by mathematicians 
to be of no effect regarding the polynomial behavior: instead of updating 
adjacent words in the entropy pool, update words that are more spaced apart. 
The key is that the spacing must ensure that still all words are evenly 
updated. Updating more spaced-apart words will effectively counter potential 
correlations in adjacent input data when these adjacent values are XORed due 
to polynomials with close taps.

In my LRNG I use the value 67 (a prime number), since I have taps that are 
close together in the high parts. The value 67 is somewhat in the middle of 
the smallest pool size (having 128 words) and thus should have the largest 
spacing possible for the smallest pool. The spacing does not need to be a 
prime number, it is sufficient that this value is odd to ensure that all words 
are evenly accessed by the spacing.

Translating that consideration into the code found in random.c, the following 
line is affected:

                i = (i - 1) & wordmask;

This line could be changed to something like:

                i = (i - 13) & wordmask;

Why 13? Well, it is a prime number (I like primes :-) ) and it is somewhat in 
the middle of the smallest pool size of 32 words.

Though, as we have polynomials that are spread out more evenly, we do not need 
that change. Yet, if the impact on having such large polynomials (and thus 
doing that many XORs for each byte in the event value) is considered to great 
speed-wise, we could use much smaller polynomials, even when their taps are 
not spaced apart.

Ciao
Stephan
