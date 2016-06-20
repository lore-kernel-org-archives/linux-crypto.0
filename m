From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Mon, 20 Jun 2016 21:00:49 +0200
Message-ID: <10477997.AvJKPRy4pc@positron.chronox.de>
References: <20160620184403.21972.qmail@ns.sciencehorizons.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tytso@mit.edu, andi@firstfloor.org, cryptography@lakedaemon.net,
	herbert@gondor.apana.org.au, hpa@linux.intel.com, joe@perches.com,
	jsd@av8n.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux@horizon.com, pavel@ucw.cz,
	sandyinchina@gmail.com
To: George Spelvin <linux@sciencehorizons.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37462 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbcFTTBu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 15:01:50 -0400
In-Reply-To: <20160620184403.21972.qmail@ns.sciencehorizons.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. Juni 2016, 14:44:03 schrieb George Spelvin:

Hi George,

> > With that being said, wouldn't it make sense to:
> > 
> > - Get rid of the entropy heuristic entirely and just assume a fixed value
> > of entropy for a given event?
> 
> What does that gain you?  You can always impose an upper bound, but *some*
> evidence that it's not a metronome is nice to have.

You are right, but that is an online test -- and I suggest we have one. 
However, the heuristic with its fraction of bits maintenance and the 
asymptotic calculation in credit_entropy_bits is a bit over the top, 
considering that we know that the input data is far from accurate.
> 
> > - remove the high-res time stamp and the jiffies collection in
> > add_disk_randomness and add_input_randomness to not run into the
> > correlation issue?
> 
> Again, you can argue for setting the estimate to zero, but why *remove*
> the timestamp?  Maybe you lose nothing,maybe you lose something, but it's
> definitely a monotonic decrease.

The time stamp maintenance is the exact cause for the correlation: one HID 
event triggers:

- add_interrupt_randomness which takes high-res time stamp, Jiffies and some 
pointers

- add_input_randomness which takes high-res time stamp, Jiffies and HID event 
value

The same applies to disk events. My suggestion is to get rid of the double 
counting of time stamps for one event.

And I guess I do not need to stress that correlation of data that is supposed 
to be entropic is not good :-)

> 
> > - In addition, let us credit the remaining information zero bits of
> > entropy
> > and just use it to stir the input_pool.
> 
> Unfortunately, that is of limited use.  We mustn't remove more bits (of
> data, as well as entropy) from the input pool that there are bits of
> entropy coming in.

I am not saying that we take more bits out of the input pool. All I am 
suggesting is to take out the correlation and in the end credit the entropy 
source which definitely is available on all systems with higher entropy rates.
> 
> So the extra uncounted entropy never goes anywhere and does very little
> good. So any time the input pool is "full" (by counted entropy), then the
> uncounted entropy has been squeezed out and thrown away.
> 
> > - Conversely, as we now would not have the correlation issue any more, let
> > us change the add_interrupt_randomness to credit each received interrupt
> > one bit of entropy or something in this vicinity?  Only if
> > random_get_entropy returns 0, let us drop the credited entropy rate to
> > something like 1/10th or 1/20th bit per event.
> 
> Baically, do you have a convincing argument that *eery* interrupt has
> this?  Even those coming from strongly periodic signals like audio DMA
> buffer fills?

I am sure I cannot be convincing as you like it because in the end, entropy is 
relative.

But look at my measurements for my LRNG, tested with and without tickless 
kernel. I see timing variations which ten times the entropy rate I suggest 
here. Besides, the analysis I did for my Jitter RNG cannot be discarded 
either.
> 
> > Hence, we cannot estimate the entropy level at runtime. All we can do is
> > having a good conservative estimate. And for such estimate, I feel that
> > throwing lots of code against that problem is not helpful.
> 
> I agree that the efficiency constraints preclude having a really
> good solution.  But is it worth giving up?
> 
> For example, suppose wecome up with a decent estimator, but only use it
> when we're low on entropy.  When things are comfortable, underestimate.
> 
> For example, a low-overhead entropy estimator can be derived from
> Maurer's universal test.  There are all sort of conditions required to

I am not suggesting any test. Entropy cannot be measured. All we can measure 
are statistics. And I cannot see why one statistical test is better than the 
other. Thus, let us have the easiest statistical test there is: use a fixed, 
but appropriate entropy value for one event and be done with it.

All that statistical tests could be used for are health tests of the noise 
source.

> get an accurate measurement of entropy, but violating them produces
> a conservative *underestimate*, which is just fine for an on-line
> entropy estimator.  You can hash non-binary inputs to save table space;
> collisions cause an entropy underestimate.  You can use a limited-range
> age counter (e.g. 1 byte); wraps cause entropy underestimate.  You need
> to initialize the history table before measurements are accurate, but
> initializing everything to zero causes an initial entropy underestimate.


Ciao
Stephan
