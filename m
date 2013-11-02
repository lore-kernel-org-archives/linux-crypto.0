From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Date: Sat, 2 Nov 2013 12:01:13 +0100
Message-ID: <20131102110112.GA16231@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <3160817.9DcncHidey@tauon>
 <20131029132448.GB691@thunk.org>
 <7861469.OAmn4h8An0@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	sandy harris <sandyinchina@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42585 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab3KBLBP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Nov 2013 07:01:15 -0400
Content-Disposition: inline
In-Reply-To: <7861469.OAmn4h8An0@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

> >sense of where the unpredictability might be coming from, and whether
> >the unpredictability is coming from something which is fundamentally
> >arising from something which is chaotic or quantum effect, or just
> >because we don't have a good way of modelling the behavior of the
> >L1/L2 cache (for example) and that is spoofing your entropy estimator.
> 
> Please note: if the jitter really comes from the oscillator effect of 
> the RAM clock vs. the CPU clock (which I suspect), we will not be able 
> to alter the jitter software wise.

Well... if it is really oscillator effect, there should be _no_
entropy when running with L1/L2 enabled (because DRAM will not be
accessed at all at that case).

There should be way to extract entropy more directly from various
oscillator effects, no?

For DRAM, just perform timing, have entropy. Plus we could for example
measure PIT vs. other timer sources... (but I suspect that on PCs we
already have enough entropy...)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
