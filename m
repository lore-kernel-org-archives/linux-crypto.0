From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Sun, 24 Apr 2016 23:25:00 +0200
Message-ID: <20160424212459.GA4725@amd>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
 <20160424152109.GA8880@amd>
 <9492847.lAf6tQpUi9@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandyinchina@gmail.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41535 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbcDXVZE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Apr 2016 17:25:04 -0400
Content-Disposition: inline
In-Reply-To: <9492847.lAf6tQpUi9@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

> > So you are relying on high-resolution timestamps. Ok. then you do kind
> > of the check on the timestamps... ok, why not. But then you mix in the
> > data regardless, saying that "they are not dependent" and thus can't
> > hurt.
> > 
> > But you already know they _are_ dependent, that's what your stuck test
> > told you:
> 
> The stuck test says that there is a pattern, but not that the pattern shows a 
> dependency.
...
> > Now. I could imagine cases where interrupts are correlated... like
> > some hardware may generate two interrupts for each event or something
> > like that...
> 
> But I see what you are referring to and I think you have a valid point in a 
> worst case assessment.
> 
> Thus, any stuck value should not be mixed into the pool.

Thanks.

> /* This RNG does not work if no high-resolution timer is available */
> BUG_ON(!random_get_entropy() && !random_get_entropy());

Heh, does this cause BUG() with 2^-64 probability? :-).

> If there is no high-resolution timer, the LRNG will not produce good entropic 
> random numbers. The current kernel code implements high-resolution timers for 
> all but the following architectures where neither random_get_entropy nor 
> get_cycles are implemented:

Ok, what about stuff like Intel 486 (no RDTSC)?

> Thus, for all large-scale architectures, the LRNG would be applicable.
> 
> Please note that also the legacy /dev/random will have hard time to obtain 
> entropy for these environments. The majority of the entropy comes
> from high-

Understood.

> Though, the patch I offer leaves the legacy /dev/random in peace for those 
> architectures to not touch the status quo.

Well -- that's the major problem -- right? Makes it tricky to tell
what changed, and we had two RNGs to maintain.

Best regards,
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
