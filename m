From: "George Spelvin" <linux@horizon.com>
Subject: Is ansi_cprng.c supposed to implement X9.17/X9.31's RNG?
Date: 28 Nov 2014 21:43:45 -0500
Message-ID: <20141129024345.8122.qmail@ns.horizon.com>
Cc: linux@horizon.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, jarod@redhat.com,
	nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:27683 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750866AbaK2Cnr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Nov 2014 21:43:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm trying to understand the Linux crypto layer, and a lot of
the code I read for guidance I instead end up wanting to fix.

My current itch to scratch is crypto/ansi_cprng.c.

There is a lot of questionable code I'll submit patches for, particularly:

- The "rand_data_valid" variable, which is actually the amount of
  INvalid data in ctx->rand_data[].  (I'm renaming it to rand_data_pos.)
- The ctx->I and ctx->last_rand_data buffers, which are completely
  unnecessary (and in the latter case, violate anti-backtracking).
- The fact that cprng_init() calls reset_prng_context() with NULL
  key and V inputs, and the latter has special-case code to handle
  that, when cprng_init() sets PRNG_NEED_RESET, so can just omit
  the call entirely.

But there's one thing that I can't figure out, and that is whether
the code is meant to be an implementation of the ANSI X9.17/X9.31 RNG.

It's currently definitely not, because the spec requires periodic input
of a timestamp with some seed entropy, while the code just uses
an incrementing counter.

So I have two paths available:

1. Clarify in comments that, although "Based on" X9.31 Appendix A.2.4,
   this is very much NOT an implementation thereof.  This is a fully
   deterministic PRNG, while the spec is for an RNG.
2. Alternativelt, change the code to actually use high-resolution
   timestamps for seed material.

In the latter case, I'd use jiffies and random_get_entropy, and provide
a compatible deterministic option for self-testing.  I'd drop the
recommended seedsize to DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ, but keep the
current implementation's support for an optional starting DT value.

If it isn't provided (the default), the code would generate it fresh
on each call to _get_more_prng_bytes, rather than the current default
to zero.

My problem is I don't know which option is intended.  Is it guaranteed that
CRYPTO_ALG_TYPE_RNG is deterministic?
