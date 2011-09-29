From: Sandy Harris <sandyinchina@gmail.com>
Subject: RFC: redesigning random(4)
Date: Thu, 29 Sep 2011 14:46:20 +0800
Message-ID: <CACXcFm=yUwYY+RvDTFk+BC8ecwcO0m-0d=LxRgrWNB+Vydthbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Ted Ts'o" <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39137 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1I2GqV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Sep 2011 02:46:21 -0400
Received: by wyg34 with SMTP id 34so70996wyg.19
        for <linux-crypto@vger.kernel.org>; Wed, 28 Sep 2011 23:46:20 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I have been thinking about how random(4) might be redesigned and I now
have enough thoughts to put them on electrons and send them out. This
is all first-cut stuff, though I have thought about it some. It needs
comment, criticism and revision.

A few things I think we absolutely want to keep. At least the existing
input mixing code including its entropy estimation, the three-pool
structure, and the use (at least sometimes) of a hash for the mixing.
I think the large pool plus hashing is obviously superior to Yarrow,
where the pool is a single hash context. For our purposes, though
perhaps not elsewhere, it also seems better than Fortuna which
complicates things with multiple input pools; we do not need those.

I would change some things fairly radically, though. Hence this
message and an invitation to discussion.

I would define all pools in terms of 64-bit objects, make the input
pool use Skein (or another SHA-3 candidate) and the output pools a
modified counter-mode AES.

Currently the driver uses SHA-1 for all three. Sometime next year, the
SHA-3 competition will declare a winner. Using that might make getting
various certifications easier, so we should probably do that when we
can. The simplest way to do that might be to keep the three-pool setup
and make them all use a new hash, but I'll argue for making the two
output pools use a block cipher instead.

All  five of the finalists in the SHA-3 competition use some variant
of a "wide-pipe" strategy. The internal state of the hash is larger
than the output size by a factor of two or more, and (in most, though
I think JH just takes raw bits from state) there is an output function
that crunches the final state into the output. It appears Ted was
ahead of his time with the trick or folding an SHA-1 output in half to
get 80 output bits. It also appears that Ted's trick is no longer
needed; the hashes do it for us now.

All the finalists have an -256 and an -512 mode. Either way, we can
have a get256() function that gets 256 hashed bits. Things like
Skein-512-256 can be used directly; that has 512-bit internal state
and 256-bit output. For another hash, we might have to use the version
with 512-bit output and do our own folding to 256. However, it is
straightforward to have a get256() function either way. That should be
the only output function from the primary pool, and its output should
never go outside the driver. It should be used only to initialise or
update the other pools.

The get256() function should start by mixing in some new entropy. At
one point, Ted had an add_timer_randomness() call for this. I recall
some discussion about taking it out and I don't see it now. As I see
it, every extraction of main pool entropy should add something new
first. Perhaps add_timer_randomness() is enough, but we might look
around the kernel to see if there's more that could be got -- is the
process or file descriptor table random enough to be worth throwing
in, for example?

get256() should also mix at least the hash value worth of bits back
into the pool at the end. Currently this is done in extract_buf() with
a call to mix_pool_bytes(). I'd do it rather differently.

I suggest a new mixing primitive, to be used for all pools. It would
actually work with structure members, but here is simple code to
explain it:

#define SIZE 32             // must be even
#define DELTA 7            // must be odd, no common factor with SIZE

static u64 buffer[SIZE] ;
static u64 *p = buffer ;
static u64 *end = Buffer+SIZE ;

// point q where p will be after SIZE iterations
static u64 *q = p + (SIZE/2) + DELTA ;

void mix64( u64 *data)
{
       *p ^= *data ;
       // pseudo-Hadamard transform
       *p += *q ;
       *q += *p ;
       // increment pointers
       p += DELTA ;
       q += DELTA ;
       // wrap around if needed
       if(p >= end) p -= SIZE ;
       if(q >= end) q -= SIZE ;
}

This has some nice properties. It is only used for
internally-generated data, to mix hash or cipher outputs back into
pools. It may be more efficient than mix_pool_bytes() which is
designed to handle external inputs and works one byte at a time. It is
somewhat non-linear because it mixes XORs with addition.

The starting point for q is chosen so that after SIZE/2 iterations,
every word in the pool is changed. In the example, with SIZE = 32 and
DELTA = 7, p runs through all words in 32 iterations. After 16
iterations, p has increased by (16*7)%32 = 16. For the second 16, it
starts at 16+7. That is just where q starts for the first 16, so
between them p and q update every word in the first 16 iterations.
This works for any values of SIZE and DELTA, provided SIZE is even and
the two have no common factors.

get256() should end with four calls to mix64(), mixing all its data back in.

I would make the two output pools AES-128 contexts, 22 64-bit words
each, and use a variant of counter mode to generate the outputs.
Counter mode has been rather extensively analyzed, notably in the
Schneier et al.Yarrow
paper(http://www.schneier.com/paper-yarrow.html). That is the main
reason I prefer it.

Ted rightly objected to counter mode in one list post (not sure where,
sorry), saying that successive values of a counter had only a small
Hamming distance between them (few bits change) which might create a
vulnerability. He's right, but that is easily dealt with. Instead of
(the 18-bit version of) x++, just use x += k where k is some constant
with somewhere near half its bits set. The Hamming distance is then
large every time. I'd use a different k for each output pool, and get
them by looking at some large collection of more-or-less random bits
like the 4K of intialisation constants (derived from pi) in Blowfish.
PIck bytes with at least 3 bits one and at least 3 zero, for example.

I'd limit output from these pools to 64 bits. Do an AES encryption,
get 128 bits, output up to 64 and feed the other 64 back with mix64(),
using a different delta for each pool. This makes the output and
feedback completely distinct. I am not sure that's necessary, but it
looks like a clean way to do it.

It also updates all of the round keys every 11 iterations. This seems
reasonable to me. Round keys and cipher output are both supposed to be
essentially random, so mixing output into the keys cannot do damage.

Initialising a pool involves doing get256(), putting 128 bits into the
counter and using the other 128 for the AES key schedule. Re-keying is
simple too; just get 128 bits and XOR them into your counter. This
gives a little non-linearity since other operations on the counter use
addition. It immediately changes the outputs and, because of the
feedback, in 11 iterations it changes the entire round key array too.
The 128 bits could come from the main pool or from the encrypted
output of your own or another output pool.

The blocking pool re-keys after every two iterations, after 128 bits
of output. It has to get the rekeying bits from the main pool every
time. The non-blocking pool can re-key less often, and perhaps be less
strict about where the re-key data comes from. I have not worked out
details yet.
