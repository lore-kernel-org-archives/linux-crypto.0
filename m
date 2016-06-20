From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Mon, 20 Jun 2016 11:28:38 -0400
Message-ID: <20160620152838.GE9848@thunk.org>
References: <2754489.L1QYabbYUc@positron.chronox.de>
 <20160619193614.GA26146@amd>
 <3817952.8FvMDE0Kc7@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel@ucw.cz>, herbert@gondor.apana.org.au,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37294 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbcFTP3z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 11:29:55 -0400
Content-Disposition: inline
In-Reply-To: <3817952.8FvMDE0Kc7@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 20, 2016 at 07:51:59AM +0200, Stephan Mueller wrote:
> 
> - Correlation of noise sources: as outlined in [1] chapter 1, the three noise 
> sources of the legacy /dev/random implementation have a high correlation. Such 
> correlation is due to the fact that a HID/disk event at the same time produces 
> an IRQ event. The time stamp (which deliver the majority of entropy) of both 
> events are correlated. I would think that the maintenance of the fast_pools 
> partially breaks that correlation to some degree though, yet how much the 
> correlation is broken is unknown.

We add more entropy for disk events only if they are rotational (i.e.,
not flash devices), and the justification for this is Don Davis's
"Cryptographic randomness from air turbulence in disk drives" paper.
There has also been work showing that by measuring disk completion
times, you can actually notice when someone walks by the server
(because the vibrations from footsteps affect disk head settling
times).  In fact how you mount HDD's to isolate them from vibration
can make a huge difference to the overall performance of your system.

As far as HID's are concerned, I will note that in 99.99% of the
systems, if you have direct physical access to the system, you
probably are screwed from a security perspective anyway.  Yes, one
could imagine systems where the user might have access to keyboard and
the mouse, and not be able to do other interesting things (such as
inserting a BadUSB device into one of the ports, rebooting the system
into single user mode, etc.).  But now you have to assume the user can
actually manipulate the input devices down to jiffies 1ms or cycle
counter (nanonsecond) level of granularity...

All of this being said, I will freely admit that the hueristics of
entropy collection is by far one of the weaker aspects of the system.
Ultimately there is no way to be 100% accurate with **any** entropy
system, since ENCRYPT(NSA_KEY, COUNTER++) has zero entropy, but good
luck finding a entropy estimation system that can detect that.

> - The delivery of entropic data from the input_pool to the (non)blocking_pools 
> is not atomic (for the lack of better word), i.e. one block of data with a 
> given entropy content is injected into the (non)blocking_pool where the output 
> pool is still locked (the user cannot obtain data during that injection time). 
> With Ted's new patch set, two 64 bit blocks from the fast_pools are injected 
> into the ChaCha20 DRNG. So, it is clearly better than previously. But still, 
> with the blocking_pool, we face that issue. The reason for that issue is 
> outlined in [1] 2.1. In the pathological case with an active attack, 
> /dev/random could have a security strength of 2 * 128 bits of and not 2^128 
> bits when reading 128 bits out of it (the numbers are for illustration only, 
> it is a bit better as /dev/random is woken up at random_read_wakeup_bits 
> intervals -- but that number can be set to dangerous low levels down to 8 
> bits).

I believe what you are referring to is addressed by the avalanche
reseeding feature.  Yes, that can be turned down by
random_read_wakeup_bits, but (a) this requires root (at which point
the game is up), and (b) in practice no one touches that knob.  You're
right that it would probably be better to reject attempts to set that
number to too-small a number, or perhaps remove the knob entirely.

Personally, I don't really use /dev/random, nor would I recommend it
for most application programmers.  At this point, getrandom(2) really
is the preferred interface unless you have some very specialized
needs.  


Cheers,

							- Ted
