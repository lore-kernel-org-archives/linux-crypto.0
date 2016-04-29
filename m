From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 28 Apr 2016 20:47:48 -0400
Message-ID: <20160429004748.9422.qmail@ns.horizon.com>
References: <20160427002346.12354.qmail@ns.horizon.com>
Cc: herbert@gondor.apana.org.au, linux@horizon.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sandyinchina@gmail.com, tytso@mit.edu
To: smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:17818 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752684AbcD2Aru (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Apr 2016 20:47:50 -0400
In-Reply-To: <20160427002346.12354.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'd like to apologise for the harsh tone of my earlier message.
I was frustrated, and it showed.


I hope I can be more gentle as I continue to elaborate on the shortcomings
of that scheme.

Concentrating entropy is hard.  To paraphrase Princess Leia, "the more
you tighten your grip, the more entropy will slip through your fingers."

While it's true that the entropy of two independent bit strings is at
least as high as the entropy of either one, it's not necessarily much
higher, either.


I'm going to discuss two things here.  First, what happens if you assume
that the inpuit samples are made up of independent and identically
distributed (i.i.d.) random bits, and second why they're not i.i.d.

When talking about single bits, all that matters is the probabilities
of the two values.  I'm going to assume that the bits are 1 with some
probability p <= 0.5, and 0 with probability p >= 0.5, but that's just
for convenience.

You can XOR any attacker-known pattern into those bits and it doesn't
change the entropy.  What matters is the probability that they match an
attacker's prediction, and the probability that they don't match.

For example, if an attacker knows that a bit is 75% likely to match
some other bit, then I'll describe it with p=0.25.


i.i.d. bits of course all have the same entropy.  Suppose that we have 32
bits, with 0.1 bits of entropy each, making 3.2 bits of entropy in total.

This is a pretty good sample; it shoud be easy to get one bit with high
entropy out of this, right?

Well, no.

0.1 bits of Shannon entropy means that a bit is 0 with probability 98.7%,
and 1 with probability p = 1.3%.

If you XOR two such bits together, the result is 1 with probability
2 * p * (1-p) (which is also less than 0.5).


Let's work out the entropy assuming we start with 0.1 of a bit of Shannon
entropy per bit, and 0.1 of a bit of min-entropy per bit, and then
form the XOR of increasingly large blocks:

Starting with 32/10 bits of Shannon entropy
 1: p=0.012987  Shannon=0.100000 (sum 3.200000)  Min=0.018859 (sum 0.603482)
 2: p=0.025636  Shannon=0.172013 (sum 2.752203)  Min=0.037468 (sum 0.599486)
 4: p=0.049958  Shannon=0.286220 (sum 2.289760)  Min=0.073937 (sum 0.591499)
 8: p=0.094925  Shannon=0.452699 (sum 1.810795)  Min=0.143891 (sum 0.575563)
16: p=0.171829  Shannon=0.661871 (sum 1.323741)  Min=0.271999 (sum 0.543997)
32: p=0.284607  Shannon=0.861653 (sum 0.861653)  Min=0.483192 (sum 0.483192)

The last line is the probability that the XOR of 32 such bits is 1.
28.46% is still some distance from 50/50, isn't it?

The min-entropy per bit comes close to doubling each time, since it
suffers less from saturation effects as it approaches 1 bit per bit,
but still 20% of the entropy is lost.

Starting with 32/10 bits of min-entropy
 1: p=0.066967  Shannon=0.354502 (sum 11.344068)  Min=0.100000 (sum 3.200000)
 2: p=0.124965  Shannon=0.543466 (sum  8.695452)  Min=0.192587 (sum 3.081394)
 4: p=0.218697  Shannon=0.757782 (sum  6.062253)  Min=0.356046 (sum 2.848372)
 8: p=0.341738  Shannon=0.926472 (sum  3.705887)  Min=0.603265 (sum 2.413061)
16: p=0.449906  Shannon=0.992747 (sum  1.985494)  Min=0.862250 (sum 1.724500)
32: p=0.494981  Shannon=0.999927 (sum  0.999927)  Min=0.985591 (sum 0.985591)

Because min-entropy is a more conservaitve estimate, the starting probability
is much closer to 50/50, and we got very close to unbiased.  But it took
11 bits of Shannon entropy to do it!


Working the formula backward, we can deduce that to get 0.95 bits of
Shannon entropy by XORing 32 i.i.d. bits, each of the input bits needs
to have p = 0.020511, 0.1443 bits of entropy, a total of 4.62 bits.


In fact, if the maximum entropy per bit is low enough then the
probability of getting the all-zero word is greater than 50% and
that imposes an upper limit on the entropy produces by *any* hashing
scheme.

For 0.1 bits of Shannon entropy per bit, (1-p)^32 = 0.658164 so even if
you reduced to one bit using !, you couldn't get closer to 50:50
than that.  (0.926565 bit Shannon, 0.603482 bits min-entropy.)


It turns out that lots of weakly random i.i.d. bits are a worst case for
this sort of reduction; if divide entropy in a "triangular" way, where
bit i gets (i+1) parts of the entropy (dividing by (32*33/2) to normalize)
then we get a final XOR of

p=0.338856  Shannon=0.923720  Min=0.596964

which is better than the p=0.284607 we got from i.i.d. bits.


Is it, then, perhaps the case that the i.i.d. assumption is not a good one?
The bit patterns we're talking about don't seem to resemble realistic
timestamps.

It's a very bad one, as I'll explain.


*Independence* can exist in a vacuum: not correlated with anything.
That's what /dev/random is trying to produce.  But the seed material
is anything but.

There are two major sources of information to an attacker about the
seed entropy:

1) An attacker is assumed to know all prior seed inputs.
   That's because we're trying to quantify the *additional* entropy
   contributed by this sample.  The difficulty of guessing the
   previous seed material has already been accounted for in the
   entropy assigned to it.  So any correlation with any previous
   seed material must be considered non-random.

2) An attacker is assumed to be able to run programs on the
   machine collecting entropy.  This is because we want different
   users' random bits to be secure from each other.

For the second issue, note that on my Ivy Bridge, I can do rdtsc(),
subtract from the previous and compare to a threshold in 24 cycles.

If I notice a sudden jump in rdtsc() deltas, I know an interrupt
happened, and I know when it happened within a window of 24 clock
cycles.

There's some delay to run the interrupt handler, but that's
highly predictable.

If interrupt arrival time is quantized, by a lower APIC clock speed,
PCI bus clock speed, or the like, then it's possible there's less
than log2(24) = 4.6 bits of uncertainty there.

(It may be possible to ignore this threat during early boot when
nothing is running, to speed up entropy accumulation.)


Getting to the first, much more important case, this is why the bits in
a captured timestamp are neither independent nor identically distributed.

What we care about those statements is *relative to the knowledge of the
attacker*.  Deterministic whitening is easy and completely pointless; the
only thing we're interested in measuring is what an attacker cannot know.

First of all, the correlation with the *previous* timestamp is stronger
the higher you go in the bits.

The chance of a higher-order bit having the predicted value is higher than
for a lower-order bit.  Thus, the bits aren't identically distributed.

If bit 31 toggles, bit 30 is almost certainly 0 now.  Thus, the bits
aren't independent.

There are many more counterexamples, but just those two will suffice
to show that the i.i.d. assumption is fatally flawed.  It makes the math
easy, but that's not what the available entropy is like.


The way to think about handling entropy is minimizing collisions.
No collisions means no entropy loss.  Collisions mean entropy loss.
This is not a huge problem when you're extracting from a pool and the
pool remains; all that happens is the remaining entropy stays in the pool.

Two possible inputs that result in the same pool state afterward is like
crossing the streams: it Would Be Bad.  You can't eliminate the possibility
with a finite-sized pool, but you should work to minimize it.
