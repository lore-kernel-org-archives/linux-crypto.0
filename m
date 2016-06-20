From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: 20 Jun 2016 14:44:03 -0400
Message-ID: <20160620184403.21972.qmail@ns.sciencehorizons.net>
References: <1639356.ozYDPrS7jM@tauon.atsec.com>
Cc: andi@firstfloor.org, cryptography@lakedaemon.net,
	herbert@gondor.apana.org.au, hpa@linux.intel.com, joe@perches.com,
	jsd@av8n.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@horizon.com, pavel@ucw.cz,
	sandyinchina@gmail.com
To: smueller@chronox.de, tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1639356.ozYDPrS7jM@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> With that being said, wouldn't it make sense to:
> 
> - Get rid of the entropy heuristic entirely and just assume a fixed value of 
> entropy for a given event?

What does that gain you?  You can always impose an upper bound, but *some*
evidence that it's not a metronome is nice to have.

> - remove the high-res time stamp and the jiffies collection in 
> add_disk_randomness and add_input_randomness to not run into the correlation 
> issue?

Again, you can argue for setting the estimate to zero, but why *remove*
the timestamp?  Maybe you lose nothing,maybe you lose something, but it's definitely
a monotonic decrease.

> - In addition, let us credit the remaining information zero bits of entropy 
> and just use it to stir the input_pool.

Unfortunately, that is of limited use.  We mustn't remove more bits (of data,
as well as entropy) from the input pool that there are bits of entropy coming in.

So the extra uncounted entropy never goes anywhere and does very little good.
So any time the input pool is "full" (by counted entropy), then the uncounted
entropy has been squeezed out and thrown away.

> - Conversely, as we now would not have the correlation issue any more, let us 
> change the add_interrupt_randomness to credit each received interrupt one bit 
> of entropy or something in this vicinity?  Only if random_get_entropy returns 
> 0, let us drop the credited entropy rate to something like 1/10th or 1/20th 
> bit per event.

Baically, do you have a convincing argument that *eery* interrupt has
this?  Even those coming from strongly periodic signals like audio DMA
buffer fills?

> Hence, we cannot estimate the entropy level at runtime. All we can do is 
> having a good conservative estimate. And for such estimate, I feel that 
> throwing lots of code against that problem is not helpful.

I agree that the efficiency constraints preclude having a really
good solution.  But is it worth giving up?

For example, suppose wecome up with a decent estimator, but only use it
when we're low on entropy.  When things are comfortable, underestimate.

For example, a low-overhead entropy estimator can be derived from
Maurer's universal test.  There are all sort of conditions required to
get an accurate measurement of entropy, but violating them produces
a conservative *underestimate*, which is just fine for an on-line
entropy estimator.  You can hash non-binary inputs to save table space;
collisions cause an entropy underestimate.  You can use a limited-range
age counter (e.g. 1 byte); wraps cause entropy underestimate.  You need
to initialize the history table before measurements are accurate, but
initializing everything to zero causes an initial entropy underestimate.
