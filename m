From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 29 Apr 2016 03:29:50 -0400
Message-ID: <20160429072950.10671.qmail@ns.horizon.com>
References: <1821963.inKkSskLoH@positron.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:11083 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752337AbcD2H3x (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 03:29:53 -0400
In-Reply-To: <1821963.inKkSskLoH@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From smueller@chronox.de Fri Apr 29 04:56:49 2016
From: Stephan Mueller <smueller@chronox.de>
To: George Spelvin <linux@horizon.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
Subject: Re: random(4) changes
Date: Thu, 28 Apr 2016 22:15:17 +0200
User-Agent: KMail/4.14.10 (Linux/4.4.7-300.fc23.x86_64; KDE/4.14.18; x86_64; ; )
In-Reply-To: <20160427002346.12354.qmail@ns.horizon.com>
References: <20160427002346.12354.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 26. April 2016, 20:23:46 schrieb George Spelvin:

Hi George,

> > And considering that I only want to have 0.9 bits of entropy, why
> > should I not collapse it? The XOR operation does not destroy the existing
> > entropy, it only caps it to at most one bit of information theoretical
> > entropy.
> 
> No.  Absolutely, demonstrably false.
> 
> The XOR operation certainly *does* destroy entropy.
> If you have 0.9 bits of entropy to start, you will have less
> after the XOR.  It does NOT return min(input, 1) bits.

As I am having difficulties following your explanation, let us start at the 
definition:

XOR is defined as an entropy preserving operation, provided the two arguments 
to the XOR operation are statistically independent (let us remember that 
caveat for later).

> That means, the entropy behavior of H(A XOR B) is max(H(A), H(B)) if they are 
> independent.

Actually, no.  If they're independent, it can be greater.

For example, if A has half a bit of entropy, and B has half a bit
(both in the Shannon sense), then A XOR B will have 0.713537
bits.

> 1. the individual bits of a given 32 bit time stamp are independent
>    (or IID in terms of NIST)

They're not independent, nor are they identically distributed.

If they were identically distributed, they'd all have identical
entropy.  And there's be no reason to stop at 32 bits.  If the high
32 bits have the same entropy as the low
entropy too?.

> 2. show that the maximum entropy of each of the individual bits is equal or 
>    more to my entropy estimate I apply.

I'm not sure what you mean here.  When you say "maximum entropy" is that
a non-strict upper bound?

Or does that mean that at least one bit achieves that maximum?

That will be a much more interesting proof.


> Regarding 1: The time stamp (or cycle counter) is a 32 bit value where
> each of the bits does not depend on the other bits. When considering one
> and only one time stamp value and we look at, say, the first 20 bits,
> there is no way it is clear what the missing 12 bits will be.

If you deliberately exclude all external data, then a 32-bit
constant is random.  (I suggest 17, the "most random number".)

But that's meaningless.  When we talk about "entropy", we are talking
about an attacker's uncertainty about the value.  Any other measure is
garbage in, and proiduces nothing but garbage out.


 Note I
am not saying that when comparing two or more time stamps that one
cannot deduce the bits! And here it is clear that the bits within
one given time stamp are independent, but multiple time stamps are
not independent. This finding is supported with measurements given in
3.4.1 (I understand that the measurements are only supportive and no
proof). Figure 3.1 shows an (almost) rectangular distribution which is
the hint to an equidistribution which in turn supports the finding that
the individual bits within a time stamp are independent. In addition,
when you look at the Shannon/Min Entropy values (which do not give an
entropy estimate here, but only help in understanding the distribution!),
the values show that the distribution has hardly any discontinuities --
please read the explanation surrounding the figure.

Regarding 2: I did numerous measurements that show that the low bits do have 
close to one bit of entropy per data bit. If I may ask to consider section 
3.4.1 again (please consider that I tried to break the logic by applying a 
pathological generation of interrupts here to stimulate the worst case): The 
entropy is not found in the absolute time stamps, but visible in the time 
deltas (and the uncertainty of the variations of those). So I calculated the 
time deltas from the collected set of time stamps of events. Now, when simply 
using the four (you may also use three or perhaps five) lower bits of the time 
delta values, we can calculate an interesting and very important Minimum 
Entropy value: the Markov Min Entropy. Using the table 2, I calculated the 
Markov Min Entropy of the data set of the 4 low bit time delta values. The 
result shows that the 4 bit values still have 3.92 bits of entropy (about 0.98 
bits of entropy per data bit). Ok, one worst case measurement may not be good 
enough. So I continued on other environments with the same testing. Table 3 
provides the results on those environments. And they have even more entropy 
than the first measurement! So, with all the measurements I always see that 
each of the four low bits has around 0.98 bits of entropy. Thus, with the XOR 
value I can conclude that these measurements show that the XOR result will 
have 0.98 bits of Markov Min Entropy based on these measurements.

Please note that I assume an entropy content of 256/288 bits of entropy per 
data bit which is slightly less than 0.9. This lower level is significantly 
less than the measured values -- a safety margin.


Albeit that marks the conclusion of the XOR folding assessment, let me 
continue why this XOR folding operation provides another helping hand. The 
measurement of the time deltas in 3.4.1, particular figure 3.2 shows that the 
time delta has even 11 bits of ("regular") Min Entropy. So, don't I waste a 
lot of entropy with the XOR folding? Apart from having more safety margins in 
case the overall delta values have less variations than I measured in my worst 
case testing, there is another factor at play:

As I have explained above, the XOR collapse is applied to the time stamps. 
Those time stamps show statistical dependencies (and maybe even to a lesser 
degree the time deltas have some dependencies too). We fold the time stamps 
and then concatenate them -- concatenation is not affected by the statistical 
dependencies. At one point in time we have a wrap-around in the entropy pool. 
The current entropy pool is 4096 bits in size (which can be arbitrarily 
changed to a minimum of 256 bits), so we wrap after 4096 received events. Now, 
we XOR the bit from the first interrupt with the bit from the 4097th 
interrupt. To ensure that the XOR operation is entropy preserving, these bits 
must be statistically independent. And to ensure that, the collapsing of the 
time stamp and the seemingly loosing of entropy helps here too! So, we give up 
entropy to "buy" statistical independence to support the XOR operation here.


With section 3.4.2 I apply a large array of statistical tests against a bit 
stream of folded bits. All of those tests pass, indicating that the bit stream 
behaves like White Noise without any whitening logic like LFSR or even 
hashing. Thus, this testing supports my analysis from above.


The root cause for not applying an LFSR or another mix-in function is that 
such LFSR is already a whitening logic. But I do have a whitening logic 
already with the DRBG. So, to me having a whitening logic whose output is used 
by another whitener is akin that you have to hide some deficiencies like skews 
or other problems in your noise source. But I have nothing to hide at the 
layer of the noise source.

Ciao
Stephan
