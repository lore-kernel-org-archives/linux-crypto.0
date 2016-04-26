From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 25 Apr 2016 21:59:43 -0400
Message-ID: <20160426015943.27472.qmail@ns.horizon.com>
Cc: herbert@gondor.apana.org.au, linux@horizon.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernrl.org,
	smueller@chronox.de, tytso@mit.edu
To: sandyinchina@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:62040 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750817AbcDZCG0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 22:06:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I just discovered this huge conversation and am trying to read it all
and get caught up.

I know I should finish reading before I start writing, but too many ideas
are bubbling up.


> not the rest of Stephan's input handling code: the parity
> calculation and XORing the resulting single bit into the entropy pool.

Indeed, this is an incredibly popular novice mistake and I don't
understand why people keep making it.

Look, *we don't know how* much entropy is in any given sample.  It's
unmeasurable in practice, so /dev/random uses some heuristics and
a huge amount of conservatism.

Because of the crude nature of this estimate, the amount of entropy
that's *probably* there is much larger than the computed guarantee.

To preserve this "bonus entropy", it's very important *not* to
have any bottlenecks like hashing down to a single bit.

Real events consist of a lot of highly predictable low-entropy samples,
with an occasional high-entropy exception.  Even if the average is less
than one bit, you want to ensure there's plenty of room for much *more*
than one bit so you aren't throwing away occasional high-entropy data.

This is why the current per-CPU fast pools are 128 bits and spilled *long*
before they approach full.

Precisely because the entropy estimate is so poor, I'd like *at least*
8 times as many bits as the entropy estimate, and more isn't a bad thing.

Eventually, you have to narrow it down to N strongly random bits with N
bits of entropy, but when you do that:

1. Use the largest batches possible, averaging over as much input as
   possible, and
2. Use a good collision-resistant, and preferably cryptographically
   strong, hash.  /dev/random's CRC-based input mix is pretty much
   the lightest defensible thing.  XOR is bad for for the same reason
   that any additive checksum is weak.


> I also quite like Stephan's idea of replacing the two output pools
> with a NIST-approved DBRG, mainly because this would probably make
> getting various certifications easier.

Do you know of an example of such a certification?

I don't really *mind* the NIST DRBGs (well, except for Dual_EC_DRBG
of course), but they don't really *help* in this context, either.

The good and bad thing about them is that they're highly correlated to
the strength of the underlying primitives.  If you're already relying
on AES in your application, then an AES-based DRBG avoids adding another
algorithm to your attack surface.  (Be it cryptanalytic, implementation,
or side channel.)

They also provide a nice reliable cookbook solution to anti-backtracking
and incorporating weakly random seed material (the timestamps) into
their state.

If they're not seeded with full entropy, then an algorithm like CTR_DRBG
isn't significantly *stronger* the underlying cipher.  Which is not
wonderful if /dev/random uses AES and someone's generating a Keccak key
with it (or vice versa).

And if they are seeded with full entropy, they aren't contrbuting
anything; it's just waving a dead chicken over your already-secure
input seed.

If waving a dead chicken would help with some real-world bureaucratic
obstacle, I don't mind, but otherwise it's pointless bloat.

(Exception: for large amounts of output, NIST's DRBGs have the problem
that they are bottlenecked at "seedlen" bits of internal state.
This makes sense for their intended use, which is in an application
with a specific security requirement, but an issue for a fully
general-purpose random bit source.)


> In the current driver -- and I think in Stephan's, though I have not
> looked at his code in any detail, only his paper -- heavy use of
> /dev/urandom or the kernel get_random_bytes() call can deplete the
> entropy available to /dev/random. That can be a serious problem in
> some circumstances, but I think I have a fix.

Actually, that hasn't been too big a problem for a while.  Of course
it depletes it *somewhat*, and it should, but there's the contents of
B plus some reserved in I (see rsvd_bytes in xfer_secondary_pool())
that won't be used up.

> You have an input pool (I) plus a blocking pool (B) & a non-blocking
> pool (NB). The problem is what to do when NB must produce a lot of
> output but you do not want to deplete I too much. B & NB might be
> replaced by DBRGs and the problem would not change.

I, B and NB *are* DRBGs, just not the NIST design.

> B must be reseeded before every /dev/random output, NB after some
> number of output blocks. I used #define SAFE_OUT 503 but some other
> number might be better depending how NB is implemented & how
> paranoid/conservative one feels.

Actually, it's better to use Ferguson & Schneier's idea of "catastropic
reseeding".  If you never want to block, you can never guarantee
reseeding.  This is not a big problem; a decent DRBG can generate
petabytes of output without reseeding.

(The reseed interval should be no more than the square root of the
state size, to force a reseed before a cycle appears.  NIST further
clamp it to 2^48, but that's somewhat arbitrary.)

What's more important is to reseed *enough* to "lose the tail"
if someone has captured the state.  If you reseed 1 bit after
each operation, then someone making frequent requests can
easily solve for the unknown seed bits.  If you wait and
reseed 256 bits all at once, they are locked out.

> B can only produce one full-entropy output, suitable for /dev/random,
> per reseed but B and NB are basically the same design so B can also
> produce SAFE_OUT reasonably good random numbers per reseed.

No, it can't.  I'll explain why this specifically doesn't work,
and then discuss the general problem.


The B pool keeps internal state.  Although it aims to provide
inforamtion-theoretic secure output, the antibacktracking is only
computationally secure; the generate function applies a one-way function
to the state so it's infeasible to compute the previous state (and thus
the previous output), but if someone captures the kernel state *and*
has a radical cryptanalytic advance, it's theoretically possible to
gain knowledge about previous outputs.

(The reason for this is that information-theoretic secure
antibacktracking is hugely wasteful of entropy.)

But if you *ever* use the B pool to generate more output than
it has seed entropy in, you are revealing enough information to
(assuming infinite computational power) compute the previous
state, or at least learn something about the previous state,
and this the previous output.

The security guarantee of /dev/random requires that B is never
used to generate more output than its seed entropy.

(This was the problem with the original one-pool Linux /dev/random,
which is why the current three-pool design was developed.  If you want
to ditch it, we can go back to the much simpler one-pool design.)

> Use those
> to reseed NB.and you reduce the load on I for reseeding NB from
> SAFE_OUT (use I every time NB is reseeded) to SAFE_OUT*SAFE_OUT (use I
> only to reseed B).

Your idea is based on a solid one: if you double the number of internal
state bits, you square the necessary reseed interval.  But there's
no advantage to doing it this particular way.  And the current
1024-bit output pools have such a long period it's a non-issue.


The more general issue is a problem with what I call "bonus entropy"
in the random pools.  As described above, if you ever remove from
a pool more bits than you are sure there is entropy, you can recover
some information about *previous* output bits.  It's computationally
infeasible to recover, but not information-theoretically secure,
which is what the blocking device aims for.

This means that not only may we not pull more bits from B than
we have guaranteed seed entropy, we may not pull the bits from I
either!

I really wish we could feed this "bonus entropy" into NB somehow, but
AFAICT it's impossible.

The only benefit we get from the bonus entropy is that it stays in I
and helps protect it from any later entropy underestimates.

If anyone can figure out a way to get more use out of it than currently,
that would be a significant advance.
