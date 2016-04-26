From: "George Spelvin" <linux@horizon.com>
Subject: Re: random(4) changes
Date: 26 Apr 2016 16:43:30 -0400
Message-ID: <20160426204330.15098.qmail@ns.horizon.com>
References: <5279345.Lo7T948V4W@positron.chronox.de>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandyinchina@gmail.com, tytso@mit.edu
To: linux@horizon.com, smueller@chronox.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5279345.Lo7T948V4W@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Schrieb Stephan Mueller:
> Am Montag, 25. April 2016, 21:59:43 schrieb George Spelvin:
>> Indeed, this is an incredibly popular novice mistake and I don't
>> understand why people keep making it.

> Can you please elaborate on your statement to help me understanding the issue 
> and substantiate your claim here?

Basically, hashing down to 1 bit limits the entropy to 1 bit.

If there happened to be more than 1 bit of entropy in the
original input (and many timestamps *do* have more entropy than
that; the hard part is identifying which), you've thrown it away.

You need to hash eventually, to convert the large amount of weakly-random
input to the desired strongly-random output, but you should do that as
late in the processing as possible, and in as large blocks as possible.

The "novice mistake" is to try to concentrate the entropy (reduce the
number of bits used to store it) too soon.  You want to defer that as much
as possible.

> Please note the mathematical background I outlined in my documentation: What I
> try is to collapse the received data such as a time stamp into one bit by
> XORing each bit with each other. Note, the bits within a time stamp are IID
> (independent and identically distributed -- i.e. when you see one or more bits
> of a given time stamp, you cannot derive the yet unseen bit values). 
> Technically this is identical to a parity calculation.

And I'm still struggling to understand it.  You wrote it up formally, so
I want to stare at it for a few hours (which is a couple of days calendar
time) before passing judgement on it.

For example, my initial reaction is that the IID claim seems ridiculous.

Bit 63 of a rdtsc timestamp is always zero.  It's initialized to zero on
boot and no computer with a TSC has been up for the 50+ years it would
take to flip that bit.

But presumably that's obvious to you, too, so I'm misunderstanding.

I'm trying to catch up on your paper and all the other comments in this
thread at the same time, and my brain is a bit scattered.

I'm trying to resist the urge to respond until I understand everything
that's already been said, but as I mentioned previously, I'm not being
entirely successful.

> - the output of the entropy pool is meant to be fed into a DRBG. Such DRBG 
> (let us take the example of a Hash DRBG) will, well, hash the input data. So, 
> what help does a hash to raw entropy before feeding it to a DRBG which will 
> hash it (again)?

The two-stage hashing is a matter of practical implementation necessity.

Ideally, we'd take all of the raw sampled data and use a strong hash
on it directly.  But that requires an impractical amount of storage.

Just as good would be to losslessly compress the data.  If we could do
*perfect* compression, we'd get pure entropy directly.  But the latter
is impossible and even the former is impractical.

So we hash it to fit it into a fixed-size buffer.  This hash does
not have to be cryptographically strong, just minimize collisions.
(Since a collision is the one and only way to lose entropy.)  This is
explained in the comment at drivers/char/random.c:335.

A second design goal of this first stage hash is speed; we want to
minimize interrupt overhead.  Since it was first designed, cache effects
have gotten stronger and the scattered access to a large pool could be
improved upon, but it's still reasonably fast.


The second stage hash (DRBG or equivalent) then uses a strong cryptographic
algorithm to generate the final output.

> - the entropy pool maintenance does not need to have any backtracking 
> resistance as (1) it is always postprocessed by the cryptographic operation
> of the DRBG, and (2) constantly overwritten by new interrupts coming in

I don't see how (1) is relevant at all; if you can recover the DRBG
seed, you can recover the DRBG output, and (2) might not be fast enough.
For example, suppose someone suspends to disk immediately after generating
a key.

(I'm assuming you instantiate a new DRBG for each open() of /dev/random.
I haven't read your code yet to verify that.)

If the amount of entropy added after the key generation is attackable (say
it's around 32 bits), then the image on disk can reveal the previously
generated key.

You're right that it's not a very critical feature in most use cases,
but it's not very expensive to implement and I think a lot of people
would question its dismissal.  Knowledgeable people, never mind the
howls from the peanut gallery if they hear we're weakening /dev/random.

(I mention that the NIST DRBGs implement anti-backtracking, so presumably
they think it's an important feature.)

> - to hash raw input data is usually performed to whiten it. When you have a 
>   need to whiten it, it contains skews and statistical weaknesses that
>   you try to disguise. My approach is to not disguise anything -- I try
>   to have "nothing up my sleeve".

Only the final hash, which produces the strongly-random output, is for the
explicit purpose of whitening.  That's because strongly-random bits are,
by definition, white.

Earlier steps should not try to whiten.

That's what I don't like about Intel's RDRAND and similar hardware RNGs:
they are whitening too early.

That's also what I don't like about XORing down to 1 bit before adding
to the pool.  Again, whitening too early!


Is that any clearer?
