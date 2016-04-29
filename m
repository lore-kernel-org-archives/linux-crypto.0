From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 29 Apr 2016 05:34:18 -0400
Message-ID: <20160429093418.14458.qmail@ns.horizon.com>
References: <6617324.Ja7tlXHdMV@tauon.atsec.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:27980 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750940AbcD2JeW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 05:34:22 -0400
In-Reply-To: <6617324.Ja7tlXHdMV@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(Note that we have two chains of e-mails crossing mid-stream.  I'm in
the middle of working on a much longer reply to your previous e-mail.)

>> They're not independent, nor are they identically distributed.

> That is an interesting statement: you say that the time stamp has holes
> in it, i.e. some values have zero probability of being selected!

That's not at all what I said.  It may be true, depending on Intel's
TSC implementation, but I didn't say or imply it.

> Second, you imply that when bit x of a given time stamp has some
> particular value, bit y can be deduced from bit x.

Yes.  For example, bit 30 can be deduced from bit 31, given our
assumption that the attacker has knowledge of previous timestamps, and
likely inter-interrupt times.  If bit 31 has changed, bit 30 is almost
certainly zero.  The bits are not independent.

The distribution of bit 31 is, with very high probability, equal to that
in the previous timestamp.  Bit 0, not so much.

In other words, bits 31 and 0 have different distributions.  They are
not identically distributed.

I gave this example in my previous e-mail
Message-ID: <20160429004748.9422.qmail@ns.horizon.com>

>> If they were identically distributed, they'd all have identical
>> entropy.  And there's be no reason to stop at 32 bits.  If the high
>> 32 bits have the same entropy as the low
>> entropy too?.

> There is absolutely no limit to the 32 bits. We easily can take the high bits 
> too. But we know (as you mention below), an attacker has more and more 
> knowledge about the selected bits the higher the bit is as he can predict an 
> event with a certain degree of probability.

Yes, an attacker has more information about higher bits.

This is the defintion of NOT identically distributed!

*If* they were identically distributed, a suggestion I'm pointing
out the ridiculous implications of, then an attacker's knowledge
of each of them would be identical.

If that were the case (and it's not), then the high 32 bits would be as
good a source of entropy as the low 32 bits.

>>> 2. show that the maximum entropy of each of the individual bits is equal
>>> or  more to my entropy estimate I apply.
>> 
>> I'm not sure what you mean here.  When you say "maximum entropy" is that
>> a non-strict upper bound?
>> 
>> Or does that mean that at least one bit achieves that maximum?

> Exactly that -- I have to show that at least one bit out of the 32
> bit value reaches that maximum, i.e. one bit has more entropy than my
> entropy estimate.

That will be an interesting claim to argue for.  Where do you make it?

>>> Regarding 1: The time stamp (or cycle counter) is a 32 bit value where
>>> each of the bits does not depend on the other bits. When considering one
>>> and only one time stamp value and we look at, say, the first 20 bits,
>>> there is no way it is clear what the missing 12 bits will be.

>> If you deliberately exclude all external data, then a 32-bit
>> constant is random.  (I suggest 17, the "most random number".)
>> 
>> But that's meaningless.  When we talk about "entropy", we are talking
>> about an attacker's uncertainty about the value.  Any other measure is
>> garbage in, and produces nothing but garbage out.

> Correct.

You mean that I'm correct that your description of the timestamp bits
as independent is meaningless?

> Maybe I am not smart enough for attacking the system. Maybe others are
> smarter than me and find a way to attack it to get to 5 or 6 bits of
> accuracy. Yet, this is means there is way more entropy than I need --
> this is my first safety margin.

I agree that the amount of entropy per timing sample is almost
certainly much higher than the current /dev/random credits it for.

The hard part is proving it.  All a statistical test can show is
that its model has a hard time predicting the output.  It can't show
tha non-existence of a better model.  That's why /dev/random is so
conservative.

Many years ago, when clock rates were below 1 GHz, I wrote a small kernel
module which disabled all other interrupts, and did nothing but take timer
interrupts and capture TSC values to RAM.  (It stopped when the buffer
was full and let the system continue.)  This was on a system with both
CPU and timer clocks generated from a single crystal by PLL.

I got a nice gaussian distribution of interrupt timings, relative
to a best-fit line,, with a standard deviation of about 8 cycles.

If I wanted to repeat that these days, I'd have to either disable in
the BIOS, or take into account, spread-spectrum clocking.  Modern clock
PLLs, to reduce EMI, deliberately modulate the CPU clock at about 30 kHz.
That adds a "ripple" with about 40 ns p-p to the TSC values relative to
a non-modulated external clock.

If I'm not careful, I could think that was 40 ns * 3.2 GHz = 128 cycles
of unpredicatability when it's just a periodic pattern.
