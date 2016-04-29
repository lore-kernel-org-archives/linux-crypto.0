From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Fri, 29 Apr 2016 10:02:35 +0200
Message-ID: <6617324.Ja7tlXHdMV@tauon.atsec.com>
References: <20160429072950.10671.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54154 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbcD2ICj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 04:02:39 -0400
In-Reply-To: <20160429072950.10671.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 29. April 2016, 03:29:50 schrieb George Spelvin:

Hi George,

> > 1. the individual bits of a given 32 bit time stamp are independent
> > 
> >    (or IID in terms of NIST)
> 
> They're not independent, nor are they identically distributed.

That is an interesting statement: you say that the time stamp has holes in it, 
i.e. some values have zero probability of being selected! Second, you imply 
that when bit x of a given time stamp has some particular value, bit y can be 
deduced from bit x.

I have not experienced that nor do I see any hints for that claim.
> 
> If they were identically distributed, they'd all have identical
> entropy.  And there's be no reason to stop at 32 bits.  If the high
> 32 bits have the same entropy as the low
> entropy too?.

There is absolutely no limit to the 32 bits. We easily can take the high bits 
too. But we know (as you mention below), an attacker has more and more 
knowledge about the selected bits the higher the bit is as he can predict an 
event with a certain degree of probability.

Thus, mixing in the high 32 bits do not hurt here from a mathematical point of 
view. But from a technical, it hurts: we know that these high 32 bits have 
hardly any entropy relative to the attacker. Thus, we would mix in bits that 
do not really help us in the entropy collection. But the processing still 
requires CPU cycles -- for each interrupt. Thus, to prevent wasting CPU 
cycles, I think that the high 32 bits should be discarded.

But if people say that they want them considered too, I have no problems in 
adding them
> 
> > 2. show that the maximum entropy of each of the individual bits is equal
> > or
> > 
> >    more to my entropy estimate I apply.
> 
> I'm not sure what you mean here.  When you say "maximum entropy" is that
> a non-strict upper bound?
> 
> Or does that mean that at least one bit achieves that maximum?

Exactly that -- I have to show that at least one bit out of the 32 bit value 
reaches that maximum, i.e. one bit has more entropy than my entropy estimate.
> 
> That will be a much more interesting proof.
> 
> > Regarding 1: The time stamp (or cycle counter) is a 32 bit value where
> > each of the bits does not depend on the other bits. When considering one
> > and only one time stamp value and we look at, say, the first 20 bits,
> > there is no way it is clear what the missing 12 bits will be.
> 
> If you deliberately exclude all external data, then a 32-bit
> constant is random.  (I suggest 17, the "most random number".)
> 
> But that's meaningless.  When we talk about "entropy", we are talking
> about an attacker's uncertainty about the value.  Any other measure is
> garbage in, and proiduces nothing but garbage out.

Correct. Please attack the, say, low 4 or 5 bits of a high-res timer so that 
you can predict their values with a certain confidence for the observed events 
(in the legacy /dev/random, that is a hdd event, a HID event and an interrupt 
-- all of those events are user-triggerable). If you achieve that, you broke, 
well, almost all timer based noise sources -- be it the legacy /dev/random, be 
it OpenBSD, XNU, you name it.

Note, I thought I can attack the legacy /dev/random HID noise source using the 
X11 logic: if one has access to the X11 server, one can see all HID events. I 
measured its RDTSC time and obtained the respective RDTSC time from the legacy 
/dev/random event processing. There are about 500,000,000 clock ticks in 
variations between both measurements. For a ping flood from a VMM host to a 
virtual machine guest, I get down to 11 bits variations. I even measured RDTSC 
timers (see my Jitter RNG measurements) in a tight loop where interrupts are 
immediately to be spotted -- the variations of those interrupts are also in 
the vicinity of 10 or 11 bits.

Regardless of what I am doing, I do not see that I can get below 10 bits of 
"accuracy" in predicting an RDTSC time stamp of an event processed by the 
legacy /dev/random.

Maybe I am not smart enough for attacking the system. Maybe others are smarter 
than me and find a way to attack it to get to 5 or 6 bits of accuracy. Yet, 
this is means there is way more entropy than I need -- this is my first safety 
margin.

Ciao
Stephan
