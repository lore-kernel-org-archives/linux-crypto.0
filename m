From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 29 Apr 2016 14:02:48 -0400
Message-ID: <20160429180248.1713.qmail@ns.horizon.com>
References: <4191223.qhyOqInRhP@tauon.atsec.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:20220 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751065AbcD2SCu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 14:02:50 -0400
In-Reply-To: <4191223.qhyOqInRhP@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>> 1. It DOES depend on the attacker.  Any statement about independence
>>    depends on the available knowledge.
>> 2. XOR being entropy preserving depends on independence ONLY, it does
>>    NOT depend on identical distribution.  The latter is a red herring.
>>    (An English metaphor for "irrelevant distraction.")
>> 3. Precisely because the bits are not independent, XOR is not
>>    guaranteed to be entropy-preserving (your sense) on real data.

> It seems we talk past each other. Your entire explanation refers to
> individual bits that come in sequentially where the attacker inbetween
> can analyze it and potentially modify his attack. Sure, in this case
> they are not independent and I am not claiming that.

You can analyze it in two equivalent ways:

1. The attacker knows all previous timestamps, and we are tring to
   quantify their uncertainty about the current timestamp word.

   In this case, some of the attacker's knowledge will be about
   correlations between the bits of that word.

   I think this is the easier way to think about the problem and
   the formulation I prefer.  Especially because of the structure
   of the work you do afterward, XORing those 32 bits.

2. An attacker knows all previous *bits*, and is presented with, and
   tries to guess, the 32 bits of the timestamp one at a time.

   In this case, information gleaned from previously-seen bits which
   would be called correlations in option 1 get incorporated into the
   predicted distribution of the current bit.

   For measuring the source entropy, this is also a valid way to
   proceed.  It's like Shannon's early studies of the entropy of
   English by letting readers read the first half of a novel and then
   asking them to guess what follows, one letter at a time.

   I think this form is less convenient in general, and it's particularly
   annoying when subsequently computing the parity of a word, as it's
   hard to talk about cancellations due to non-independent bits.

Entropy (Shannon, Renyi, and min-) is additive, meaning that the two
different ways of measuring will produce the same result.

Either way, word or bit at a time, we are trying to quantify the *new*
additional entropy contributed by the current sample.  That means
we assume for the analysis of each sample that all previous samples
are known to the attacker.

> But one single time stamp is one value where the entire 32 bits are generated 
> in an atomic fashion to any observer -- there is no sequential obtaining of 
> its bits, analyzing it and then reacting on it.

I never suggested doing it any other way, although as I explained above
it's possible to do so.

I was only considering processing *words* sequentially.

Knowledge of the previous *words* affect the predicted distribution
of individual bits in the current word.

When woring word-at-a-time like this, we also have to consider
cross-correlations among the bits of a word.  The most general way to
express it is a set of 2^32 probabilities for each of the 2^32 possible
values.  The awkwardness of this form is why it's sometimes useful to
think about smaller pieces.

For example, if p(9) = 0.5, p(10) = 0.5, and p(x) = 0 for all other x,
then we have 1 bit of entropy in the word.

We can analyze it bit a time, and proceed in oe of two ways:

- If we go lsbit first, then we have 1 bit of entropy in bit 0, but
  then zero entropy in bit 1.
- If we go msbit first, we have 1 bit of entropy in bit 1, but then
  zero entropy in bit 0.

Either way, there's only 1 bit of entropy total because of the
correlation between the bits.  Once we have seen one of the bits, the
entropy of the second one collapses to 0.

And either way, we have 1 bit of entropy in the word, but 0 bits of entropy
in the parity of the word.
