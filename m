From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 29 Apr 2016 07:04:24 -0400
Message-ID: <20160429110424.641.qmail@ns.horizon.com>
References: <4528395.Mi7xQggM5z@tauon.atsec.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:14848 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752176AbcD2LEb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 07:04:31 -0400
In-Reply-To: <4528395.Mi7xQggM5z@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> I think there is a slight mixup: IID is not related to an attacker
> predicting things. IID is simply a statistical measure, it is either there
> or not. It does not depend on an attacker (assuming that the attacker
> cannot change the data). Note, the IID is only needed to claim that the
> XOR will be entropy preserving.

1. It DOES depend on the attacker.  Any statement about independence
   depends on the available knowledge.
2. XOR being entropy preserving depends on independence ONLY, it does
   NOT depend on identical distribution.  The latter is a red herring.
   (An English metaphor for "irrelevant distraction.")
3. Precisely because the bits are not independent, XOR is not
   guaranteed to be entropy-preserving (your sense) on real data.

To give a specific example, suppose that an attacker can predict that the
counter will be either x or x+1 on the upcoming sample.  For simplicity,
assume the probabilites are exactly 50%, so there is one full bit of
entropy in the lsbit.

But if x ends in ..01, then x+1 ends in ..10, and they have the same
XOR, and the attacker knows (0 bits if entropy) the XOR of the bottom
two bits even though they know nothing about the bottom bit in isolation.

>>> There is absolutely no limit to the 32 bits. We easily can take the high
>>> bits too. But we know (as you mention below), an attacker has more and
>>> more knowledge about the selected bits the higher the bit is as he can
>>> predict an event with a certain degree of probability.

>> Yes, an attacker has more information about higher bits.
>> 
>> This is the defintion of NOT identically distributed!

> So, you are saying that by looking at data, you change their statistical 
> distribution?

Yes.

For example, if I have seen the previous sample and it is 0x00000000,
I know that the distribution of the msbit of the following sample
is heavily biased toward 0.

If I have seen the previous sample and it is 0x7fffffff, I know that the
distribution of the msbit is heavily biased toward 1.

If I had not looked at the preceding samples, I would not be able
to draw those conclusions.

Remember, the following sample doesn't have a distribution; it is a
future fact.  The only thing that has a distribution is my advance
knowledge (prediction) of that fact.

>> *If* they were identically distributed, a suggestion I'm pointing
>> out the ridiculous implications of, then an attacker's knowledge
>> of each of them would be identical.

> Not at all, you mix the attackers knowledge again with a pure statistical 
> property.

I don't understand what a "pure statistical property" means.

The distribution of a single independent bit can be described
completely by giving the probability of it being 1.

In the absence of correlations (dependencies), this single number
completely describes the attacker's knowledge of the bit.

Several bits have identical distributions if and only if the
probability of their being 1 is identical.

This is the same as saying that the attacker's knowledge of the
bits is identical.
