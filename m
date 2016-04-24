From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Sun, 24 Apr 2016 19:32:10 +0200
Message-ID: <9492847.lAf6tQpUi9@positron.chronox.de>
References: <9192755.iDgo3Omyqe@positron.chronox.de> <20160424152109.GA8880@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandyinchina@gmail.com
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53462 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbcDXRcO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Apr 2016 13:32:14 -0400
In-Reply-To: <20160424152109.GA8880@amd>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 24. April 2016, 17:21:09 schrieb Pavel Machek:

Hi Pavel,

> Hi!
> 
> > Please find in [1] the full design discussion covering qualitative
> > assessments of the entropy collection and entropy flow. Furthermore, a
> > full
> > testing of the
> 
> I don't get it.
> 
> # The
> # idea is that only after obtaining LRNG_POOL_SIZE_BITS healthy bits,
> # the
> #entropy pool is completely changed with new bits. Yet, the stuck bit
> # is not
> # discarded as it may still contain some entropy. Hence, it is simply
> # XORed
> # with the previous bit as the XOR operation maintains the entropy since
> # the previous time stamp and the current time stamp are not dependent
> # on each other.
> 
> So you are relying on high-resolution timestamps. Ok. then you do kind
> of the check on the timestamps... ok, why not. But then you mix in the
> data regardless, saying that "they are not dependent" and thus can't
> hurt.
> 
> But you already know they _are_ dependent, that's what your stuck test
> told you:

The stuck test says that there is a pattern, but not that the pattern shows a 
dependency.
> 
> # Thus, the stuck test
> # ensures that:
> # (a) variations exist in the time deltas,
> # (b) variations of time deltas do not have a simple repeating pattern,
> # and
> # (c) variations do not have a linearly changing patterns (e.g. 1 - 2 -
> # 4 - 7
> # - 11 - 16).
> 
> 
> Now. I could imagine cases where interrupts are correlated... like
> some hardware may generate two interrupts for each event or something
> like that...

But I see what you are referring to and I think you have a valid point in a 
worst case assessment.

Thus, any stuck value should not be mixed into the pool.

I have changed the code accordingly.

> 
> What goes on if high resolution timer is not available?

See lrng_init:

/* This RNG does not work if no high-resolution timer is available */
BUG_ON(!random_get_entropy() && !random_get_entropy());

If there is no high-resolution timer, the LRNG will not produce good entropic 
random numbers. The current kernel code implements high-resolution timers for 
all but the following architectures where neither random_get_entropy nor 
get_cycles are implemented:

- AVR32

- CRIS

- FR-V

- H8300

- Hexagon

- M32R

- METAG

- Microblaze

- SPARC 32

- Score

- SH

- UM

- Unicore32

- Xtensa

Thus, for all large-scale architectures, the LRNG would be applicable.

Please note that also the legacy /dev/random will have hard time to obtain 
entropy for these environments. The majority of the entropy comes from high-
resolution time stamps. If you do not have them and you rely on Jiffies, an 
attacker has the ability to predict the events mixed into the pools with a 
high accuracy. Please remember the outcry when MIPS was identified to have no 
get_cycles about two or three years back.

Though, the patch I offer leaves the legacy /dev/random in peace for those 
architectures to not touch the status quo.

Ciao
Stephan
