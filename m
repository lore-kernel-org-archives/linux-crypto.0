From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 29 Apr 2016 16:08:48 -0400
Message-ID: <20160429200848.12765.qmail@ns.horizon.com>
References: <1893537.hxFTUMSmqB@positron.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:17515 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750875AbcD2UIu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 16:08:50 -0400
In-Reply-To: <1893537.hxFTUMSmqB@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> What I am saying that the bits in one given time stamp are mutually 
> independent. I.e. bit 0 of one time stamp does not depend on bit 1 of that 
> very same time stamp.

And I'm saying that's wrong.

We are interested in the correlation from the point of view of someone
who knows all previous time stamps (and a lot else besides).

Based on this knowledge of what happened before, it is possible to
deduce a correlation.

> I totally agree with you that bit 0 from time stamp 1 may tell you something 
> about bit 0 of time stamp 2. And therefore I am not considering multiple time 
> stamps for this first step.

But also bits 0 and 1 of time stamp 1 will tell you something about the
correlation of bits 0 and 1 of time stamp 2.

To simplify the discussion, let's slow down the time stamp counter
to slightly more than 1 tick per interrupt.

Suppose time stamp 1 (I'll call it x) happens to end in the bits "10".
The attacker knows, based on the rates of the interrupts and TSC ticks,
that the next time stamp is probably x+1 or x+2.  It might be x+3 or more,
but that's pretty unlikely.

This means that the lsbits are probably 11 or 00.  So there's a strong
correlation between bit 0 and bit 1.

> IID: A sequence of random variables for which each element of the
> sequence has the same probability distribution as the other values
> and all values are mutually independent.
>
> Independent: Two discrete random variables X and Y are (statistically)
> independent if the probability that an observation of X will have
> a certain value does not change, given knowledge of the value of
> an observation of Y (and vice versa). When this is the case, the
> probability that the observed values of X and Y will be x and y,
> respectively, is equal to the probability that the observed value of
> X will be x (determined without regard for the value of y) multiplied
> by the probability that the observed value of Y will be y (determined
> without regard for the value of x).

These are both exactly correct.

Notice in particular the statement that a probability (of X) can change
based on knowledge (of Y).  The special case where it doesn't change is
called independence.

> All I am claiming and all I am saying is that the bits 0 through 31 in one 
> given time stamp are mutually indpendent. And thus the XOR of those 
> independent bits is appropriate.

And I'm saying that's flat out wrong.  The bits are NOT mutually
independent.  The correlation might be small in some cases, but
it's not exactly zero.

>> When woring word-at-a-time like this, we also have to consider
>> cross-correlations among the bits of a word.  The most general way to

> Tell me where the correlations should be within one word.  Where do you claim 
> they come from?

>From all the other knowledge of the machine.  Knowledge of previous
timestamps, kernel internals, interrupt service routine execution times,
interrupt mitigation timers in various hardware, periodic interrupts, etc.

>> For example, if p(9) = 0.5, p(10) = 0.5, and p(x) = 0 for all other x,
>> then we have 1 bit of entropy in the word.
>> 
>> We can analyze it bit a time, and proceed in oe of two ways:
>> 
>> - If we go lsbit first, then we have 1 bit of entropy in bit 0, but
>>   then zero entropy in bit 1.
>> - If we go msbit first, we have 1 bit of entropy in bit 1, but then
>>   zero entropy in bit 0.

> This description makes no sense.

I tried to make it as simple as I could.

Let me try again.

Assume for the purpose of discussion that we are able to predict, by some
magical means irrelevant to the example, that the next timestamp will
definitely be either 9 or 10, with 50% probability of each.

This is obviously an extremely simplified example, but the basic logic
applies to more complex cases.

We can analyze the entropy of the following timestamp in three ways:

1) Consider the timestamp all at once.  The entropy of the word is the
   expected value of -log2(p[i]).  This is p[9] * -log2(p[9]) +
   p[10] * -log2(p[10]) = 0.5*1 + 0.5*1 = 1.0 bits of entropy.

2) Consider the timestamp a bit at a time, starting from the lsbit.
2a) We have no idea what bit 0 is, so the entropy of this bit is 1.0.
2b) Given that we have already seen bit 0, we know with certainty that
    bit 1 is its complement, so bit 1 contributes zero entropy.
    (See the definition of "independent" above.  Having gained knowledge
    of bit 0, the probability of bit 1 having a particular value has
    changed.  Thus bits 0 and 1 are not independent.)
2c) Bits 2..31 are all known ahead of time, so contribute zero entropy.

3) Consider the timestamp a bit at a time, starting from the msbit.
3a) We know bits 31..2 ahead of time, so they contribute zero entropy.
3b) We have no idea what bit 1 is, so it contributes 1.0 bits of entropy.
3c) Having seen bit 1, we know with certainty that bit 0 is its
    complement, so bit 0 contributes zero entropy.

The point of the example is that regardless of the method used to
add it up, the total entropy is the same.  We may not even attribute the
entropy to the same bit, but the total is still the same.

This additive property is what makes entropy a useful measurement.

The same logic applies to more complex cases, it just takes longer
to write out all the equations and show that the numbers add up the same.

>> Either way, there's only 1 bit of entropy total because of the
>> correlation between the bits.  Once we have seen one of the bits, the
>> entropy of the second one collapses to 0.

> Again, where does the correlation is supposed to come from?

>From our knowledge that the value will be either 9 (1001) or 10 (1010).

That's a severely simplfiied case, but it's meant to show what happens if
we have any knowlegedge of the range of possible values.


For another simplified example using larger numbers, suppose we know
that the next timestamp will be somewhere in the 2^17-tick range between
0xffff0000 and 0x0000ffff.  In this case, bits 16..31 are guaranteed
perfectly correlated.

The same logic applies if we know that the next interrupt timestamp will
be x + delta, where delta is a Poisson-distributed value with expected
value lambda, the math is just a lot messier and the correlations are
a lot smaller.  But still non-zero, so they're *not* independent.
