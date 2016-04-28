From: Stephan Mueller <smueller@chronox.de>
Subject: Re: random(4) changes
Date: Thu, 28 Apr 2016 22:15:17 +0200
Message-ID: <1821963.inKkSskLoH@positron.chronox.de>
References: <20160427002346.12354.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160427002346.12354.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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

That means, the entropy behavior of H(A XOR B) is max(H(A), H(B)) if they are 
independent. For example, A has 5 bits of entropy and B has 7 bits of entropy, 
A XOR B has 7 bits of entropy. Similarly, if A has zero bits of entropy the 
XORed result will still have 7 bits of entropy from B. That applies regardless 
of the size of A or B, including one bit sized chunks. The same applies when 
XORing more values:

A XOR B XOR C = (A XOR B) XOR C

Now, the entropy behaves like:

max(max(H(A), H(B)), H(C)) = max(H(A), H(B), H(C))

Now, with that definition, let us look at the LRNG method. The LRNG obtains a 
time stamp and uses the low 32 bits of it. The LRNG now slices those 32 bits 
up in individual bits, let us call them b0 through b31.

The LRNG XORs these individual bits together. This means:

b0 XOR b1 XOR b2 XOR ... XOR b31

This operation gives us one bit.

How is the entropy behaving here? Let us use the definition from above:

H(XORed bit) = max(H(b0), H(b1), ..., H(b31))

We know that each individual bit can hold at most one bit. Thus the formula 
implies that the XOR operation in the LRNG can at most get one bit of entropy.


Given these findings, I now have to show and demonstrate that:

1. the individual bits of a given 32 bit time stamp are independent (or IID in 
terms of NIST)

2. show that the maximum entropy of each of the individual bits is equal or 
more to my entropy estimate I apply.


Regarding 1: The time stamp (or cycle counter) is a 32 bit value where each 
of the bits does not depend on the other bits. When considering one and only 
one time stamp value and we look at, say, the first 20 bits, there is no way 
it is clear what the missing 12 bits will be. Note I am not saying that when 
comparing two or more time stamps that one cannot deduce the bits! And here it 
is clear that the bits within one given time stamp are independent, but 
multiple time stamps are not independent. This finding is supported with 
measurements given in 3.4.1 (I understand that the measurements are only 
supportive and no proof). Figure 3.1 shows an (almost) rectangular 
distribution which is the hint to an equidistribution which in turn supports 
the finding that the individual bits within a time stamp are independent. In 
addition, when you look at the Shannon/Min Entropy values (which do not give 
an entropy estimate here, but only help in understanding the distribution!), 
the values show that the distribution has hardly any discontinuities -- please 
read the explanation surrounding the figure.

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
