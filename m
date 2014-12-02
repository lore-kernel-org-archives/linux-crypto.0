From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 00/17] Multiple changes to crypto/ansi_cprng.c
Date: 2 Dec 2014 03:33:14 -0500
Message-ID: <20141202083314.17647.qmail@ns.horizon.com>
References: <20141129175928.GC15743@localhost.localdomain>
Cc: linux@horizon.com, linux-crypto@vger.kernel.org,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:21213 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751091AbaLBIdQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:33:16 -0500
In-Reply-To: <20141129175928.GC15743@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thank you all for your hospitality to my amateurish efforts.

Given that this all started with me reading the code in an attempt to
understand it, it is likely that some of the "problems" I address are
actually misunderstandings on my part.  If all I get from this patch series
is some enlightenment, that's okay.

It's even more likely that some parts contain the germ of a good idea,
but will need considerable rework to be acceptable.  I look forward
to that too.

Expecting that much more work will be needed, I've run the testmgr.h
test vectors on this code, but haven't desk-checked it as thoroughly as
security-sensitive code should be before final acceptance.  If the ideas
pass muster, I'll double-check the implementatoin details.

Really, I'm just trying to understand the code.  Patches are just
a very specific way of talking about it.

Here's an overview of the series.  It's a lot of code cleanup, and
a bit of semantic change.

[01/17] crypto: ansi_cprng - Rename rand_data_valid more sensibly
	I find it confusing, so I rename it to rand_data_pos
[02/17] crypto: ansi_cprng - Eliminate ctx->last_rand_data
	Shrink the context structure.
[03/17] crypto: ansi_cprng - Eliminate ctx->I
	Shrink it some more.
[04/17] crypto: ansi_cprng - simplify xor_vectors() to xor_block()
	We don't need a size parameter.
[05/17] crypto: ansi_cprng - Add const annotations to hexdump()
	I like const.
[06/17] crypto: ansi_cprng - Eliminate unused PRNG_FIXED_SIZE flag
	It's dead code ACAICT.
[07/17] crypto: ansi_cprng - Shrink rand_read_pos & flags
	A little more context shrinking.
[08/17] crypto: ansi_cprng - Require non-null key & V in reset_prng_context
	Sue to the PRNG_NEED_RESET flag, cprng_init() doesn't need to call
	reset_prng_context) directly.
[09/17] crypto: ansi_cprng - Clean up some variable types
	Try to be more consistent about signed vs. unsigned.
[10/17] crypto: ansi_cprng - simplify get_prng_bytes
	Code shrink & simplification.
[11/17] crypto: ansi_cprng - unroll _get_more_prng_bytes
	Slight object code size savings, and definite readability improvement.
[12/17] crypto: ansi_cprng - Create a "block buffer" data type
	union { u8 bytes[16]; u32 ints[4]; u64 longs[2]; }, sort of.
[13/17] crypto: ansi_cprng - If DT is not provided, use a fresh timestamp
	This is the big semantic change.  I'm rather proud of the use
	of get_random_int() as a timestamp, but feedback is definitely
	solicited!
[14/17] crypto: ansi_cprng - If DT is omitted, don't buffer old output
	Not sure if this is desirable or not.
[15/17] crypto: testmgr - Teach test_cprng to handle non-default seed sizes
	I consider this a latent bug that patch 17 sould expose.
[16/17] crypto: testmgr - Merge seed arrays in struct cprng_testvec
	I think this is a better way of solving the preceding problem,
	but it's more intrusive.  All the consts I add are not a critical
	part of the patch, but an example of what I'd like to do to the
	rest of the code.
[17/17] crypto: ansi_cprng - Shrink default seed size
	This makes (some amount of) true entropy the default.
