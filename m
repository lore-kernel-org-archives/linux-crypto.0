From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 0/6] /dev/random - a new approach
Date: Sun, 24 Apr 2016 17:21:09 +0200
Message-ID: <20160424152109.GA8880@amd>
References: <9192755.iDgo3Omyqe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandyinchina@gmail.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33216 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbcDXPVR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Apr 2016 11:21:17 -0400
Content-Disposition: inline
In-Reply-To: <9192755.iDgo3Omyqe@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

> Please find in [1] the full design discussion covering qualitative assessments
> of the entropy collection and entropy flow. Furthermore, a full
> testing of the

I don't get it.

# The
# idea is that only after obtaining LRNG_POOL_SIZE_BITS healthy bits,
# the
#entropy pool is completely changed with new bits. Yet, the stuck bit
# is not
# discarded as it may still contain some entropy. Hence, it is simply
# XORed
# with the previous bit as the XOR operation maintains the entropy since
# the previous time stamp and the current time stamp are not dependent
# on each other.

So you are relying on high-resolution timestamps. Ok. then you do kind
of the check on the timestamps... ok, why not. But then you mix in the
data regardless, saying that "they are not dependent" and thus can't
hurt.

But you already know they _are_ dependent, that's what your stuck test
told you:

# Thus, the stuck test
# ensures that:
# (a) variations exist in the time deltas,
# (b) variations of time deltas do not have a simple repeating pattern,
# and
# (c) variations do not have a linearly changing patterns (e.g. 1 - 2 -
# 4 - 7
# - 11 - 16).


Now. I could imagine cases where interrupts are correlated... like
some hardware may generate two interrupts for each event or something
like that...

What goes on if high resolution timer is not available?

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
