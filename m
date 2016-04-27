From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 26 Apr 2016 20:23:46 -0400
Message-ID: <20160427002346.12354.qmail@ns.horizon.com>
References: <25204908.NQ7XpImiHx@positron.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <25204908.NQ7XpImiHx@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> And considering that I only want to have 0.9 bits of entropy, why
> should I not collapse it? The XOR operation does not destroy the existing
> entropy, it only caps it to at most one bit of information theoretical
> entropy.

No.  Absolutely, demonstrably false.

The XOR operation certainly *does* destroy entropy.
If you have 0.9 bits of entropy to start, you will have less
after the XOR.  It does NOT return min(input, 1) bits.

In rare cases, the XOR won't destroy entropy, but that's statistically
unlikely.


Here's a proof:

If there are only two possible inputs (timings), and those inputs have
opposite parities, then the XOR will cause no collisions and no entropy
is destroyed.

If you have at least three possibilities, hashing down to one bit (by
XOR or any other algorithm) must cause a collision, and that collision
will lose entropy.

Just as an example, let me use a 3-option distribution with roughly 0.5
bit of Shannon entropy: probabilities 90%, 9% and 1%.  Then list all
the possible collisions, and the Shannon and min-entropy in each case:

	%	Shannon		Min
	90/9/1	0.5159		0.1520
	90/10	0.4690	(91%)	0.1520	(100%)
	91/9	0.4365	(85%)	0.1361	(90%)
	99/1	0.0808	(16%)	0.0145	(10%)
	100	0		0

If you reduce the number of cases to 2, you lose Shannon entropy, always.

Min-entropy is preserved 1/4 of the time if you get lucky and none of the
less-likely options collide with the most-likely.

If the 4 possible collision cases are equally likely (which is the
case if the hashing to one bit is a random function), then you expect
to retain half of the input entropy.


If there are more than three possible inputs, the situation gets worse,
and the likelihood of no loss of min-entropy falls.


In a case of particular interest to an RNG, consider the min-entropy when
there are a large number of possible input measurements.  The min-entropy is
simply -log2(p(max)), where p(max) is the probability of the most likely
outcome.  If p(max) > 50%, then the input min-entropy is less than 1 bit.

In this case we can assume that, when collapsing to a single bit, the
less likely cases will be distributed uniformly between colliding and
not colliding with the most likely alternative.

Thus, the probability of the most likely increases from p to
p + (1-p)/2 = (1+p)/2, and the min-entropy correspondingly
decreases from -log2(p) to -log2((1+p)/2).

The ratio of output to input min-entropy varies from 50% near 0 bits to
45.7% at 0.5 bits to 41.5% at 1 bit input.

In this case, which I think is a plausible case for /dev/random
measurements, you're throwing away half the entropy.


Beyond 1 bit of input entropy, the ratio gets worse as the output
asymptotically approaches 1 bit of entropy.  Specifically, in order to
get 0.9 bits of min-entropy in the output (p(max) = 0.5358), you need
3.8 bits (p(max) = 0.07177 = 1/14) in the input!


I'm sorry, but collapsing individual samples to 1 bit is a Bad Design,
full stop.  It's not the algorithm used to do the reduction, it's the
reduction itself.
