From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Fri, 29 Apr 2016 11:53:32 +0200
Message-ID: <4528395.Mi7xQggM5z@tauon.atsec.com>
References: <20160429093418.14458.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160429093418.14458.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 29. April 2016, 05:34:18 schrieb George Spelvin:

Hi George,

> (Note that we have two chains of e-mails crossing mid-stream.  I'm in
> the middle of working on a much longer reply to your previous e-mail.)
> 
> >> They're not independent, nor are they identically distributed.
> > 
> > That is an interesting statement: you say that the time stamp has holes
> > in it, i.e. some values have zero probability of being selected!
> 
> That's not at all what I said.  It may be true, depending on Intel's
> TSC implementation, but I didn't say or imply it.
> 
> > Second, you imply that when bit x of a given time stamp has some
> > particular value, bit y can be deduced from bit x.
> 
> Yes.  For example, bit 30 can be deduced from bit 31, given our
> assumption that the attacker has knowledge of previous timestamps, and
> likely inter-interrupt times.  If bit 31 has changed, bit 30 is almost
> certainly zero.  The bits are not independent.

I think there is a slight mixup: IID is not related to an attacker predicting 
things. IID is simply a statistical measure, it is either there or not. It 
does not depend on an attacker (assuming that the attacker cannot change the 
data). Note, the IID is only needed to claim that the XOR will be entropy 
preserving.

The reason that the IID on a statistical level is preserved is due to the fact 
that that an attacker can only observe the values, but not manipulate them 
(i.e. set the bits in a time stamp depending on other bits in that very time 
stamp).

Hence, the attacker may cause that some bits have zero or little entropy, but 
he cannot change the statistical pattern of the bits. This is the key 
requirement why the XOR can be applied here: statistical independent bits, 
where some bits may not have any entropy.

The relativity of an attacker comes in when you want to determine how much 
entropy a particular bit has. And here, the higher the bit is the lower the 
entropy as the attacker has more and more likelihood to guess the bit 
correctly.
> 
> The distribution of bit 31 is, with very high probability, equal to that
> in the previous timestamp.  Bit 0, not so much.
> 
> In other words, bits 31 and 0 have different distributions.  They are
> not identically distributed.
> 
> I gave this example in my previous e-mail
> Message-ID: <20160429004748.9422.qmail@ns.horizon.com>
> 
> >> If they were identically distributed, they'd all have identical
> >> entropy.  And there's be no reason to stop at 32 bits.  If the high
> >> 32 bits have the same entropy as the low
> >> entropy too?.
> > 
> > There is absolutely no limit to the 32 bits. We easily can take the high
> > bits too. But we know (as you mention below), an attacker has more and
> > more knowledge about the selected bits the higher the bit is as he can
> > predict an event with a certain degree of probability.
> 
> Yes, an attacker has more information about higher bits.
> 
> This is the defintion of NOT identically distributed!

So, you are saying that by looking at data, you change their statistical 
distribution?
> 
> *If* they were identically distributed, a suggestion I'm pointing
> out the ridiculous implications of, then an attacker's knowledge
> of each of them would be identical.

Not at all, you mix the attackers knowledge again with a pure statistical 
property.


Ciao
Stephan
