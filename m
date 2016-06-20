From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Mon, 20 Jun 2016 17:43:55 +0200
Message-ID: <1639356.ozYDPrS7jM@tauon.atsec.com>
References: <2754489.L1QYabbYUc@positron.chronox.de> <3817952.8FvMDE0Kc7@tauon.atsec.com> <20160620152838.GE9848@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Pavel Machek <pavel@ucw.cz>, herbert@gondor.apana.org.au,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160620152838.GE9848@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 20. Juni 2016, 11:28:38 schrieb Theodore Ts'o:

Hi Theodore,

> On Mon, Jun 20, 2016 at 07:51:59AM +0200, Stephan Mueller wrote:
> > - Correlation of noise sources: as outlined in [1] chapter 1, the three
> > noise sources of the legacy /dev/random implementation have a high
> > correlation. Such correlation is due to the fact that a HID/disk event at
> > the same time produces an IRQ event. The time stamp (which deliver the
> > majority of entropy) of both events are correlated. I would think that
> > the maintenance of the fast_pools partially breaks that correlation to
> > some degree though, yet how much the correlation is broken is unknown.
> 
> We add more entropy for disk events only if they are rotational (i.e.,
> not flash devices), and the justification for this is Don Davis's
> "Cryptographic randomness from air turbulence in disk drives" paper.
> There has also been work showing that by measuring disk completion
> times, you can actually notice when someone walks by the server
> (because the vibrations from footsteps affect disk head settling
> times).  In fact how you mount HDD's to isolate them from vibration
> can make a huge difference to the overall performance of your system.
> 
> As far as HID's are concerned, I will note that in 99.99% of the
> systems, if you have direct physical access to the system, you
> probably are screwed from a security perspective anyway.  Yes, one
> could imagine systems where the user might have access to keyboard and
> the mouse, and not be able to do other interesting things (such as
> inserting a BadUSB device into one of the ports, rebooting the system
> into single user mode, etc.).  But now you have to assume the user can
> actually manipulate the input devices down to jiffies 1ms or cycle
> counter (nanonsecond) level of granularity...
> 
> All of this being said, I will freely admit that the hueristics of
> entropy collection is by far one of the weaker aspects of the system.

With that being said, wouldn't it make sense to:

- Get rid of the entropy heuristic entirely and just assume a fixed value of 
entropy for a given event?

- remove the high-res time stamp and the jiffies collection in 
add_disk_randomness and add_input_randomness to not run into the correlation 
issue?

- In addition, let us credit the remaining information zero bits of entropy 
and just use it to stir the input_pool.

- Conversely, as we now would not have the correlation issue any more, let us 
change the add_interrupt_randomness to credit each received interrupt one bit 
of entropy or something in this vicinity? Only if random_get_entropy returns 
0, let us drop the credited entropy rate to something like 1/10th or 1/20th 
bit per event.

> Ultimately there is no way to be 100% accurate with **any** entropy
> system, since ENCRYPT(NSA_KEY, COUNTER++) has zero entropy, but good
> luck finding a entropy estimation system that can detect that.

+1 here

To me, all the entropy heuristic today is only a more elaborate test against 
the failure of a noise source. And this is how I use the 1st/2nd/3rd 
derivation in my code: it is just a failure test.

Hence, we cannot estimate the entropy level at runtime. All we can do is 
having a good conservative estimate. And for such estimate, I feel that 
throwing lots of code against that problem is not helpful.
> 
> > - The delivery of entropic data from the input_pool to the
> > (non)blocking_pools is not atomic (for the lack of better word), i.e. one
> > block of data with a given entropy content is injected into the
> > (non)blocking_pool where the output pool is still locked (the user cannot
> > obtain data during that injection time). With Ted's new patch set, two 64
> > bit blocks from the fast_pools are injected into the ChaCha20 DRNG. So,
> > it is clearly better than previously. But still, with the blocking_pool,
> > we face that issue. The reason for that issue is outlined in [1] 2.1. In
> > the pathological case with an active attack, /dev/random could have a
> > security strength of 2 * 128 bits of and not 2^128 bits when reading 128
> > bits out of it (the numbers are for illustration only, it is a bit better
> > as /dev/random is woken up at random_read_wakeup_bits intervals -- but
> > that number can be set to dangerous low levels down to 8 bits).
> 
> I believe what you are referring to is addressed by the avalanche
> reseeding feature.  Yes, that can be turned down by
> random_read_wakeup_bits, but (a) this requires root (at which point
> the game is up), and (b) in practice no one touches that knob.  You're
> right that it would probably be better to reject attempts to set that
> number to too-small a number, or perhaps remove the knob entirely.
> 
> Personally, I don't really use /dev/random, nor would I recommend it
> for most application programmers.  At this point, getrandom(2) really
> is the preferred interface unless you have some very specialized
> needs.

I fully agree. But there are use cases for /dev/random, notably as a seed 
source for other DRNG.
> 
> 
> Cheers,
> 
> 							- Ted


Ciao
Stephan
