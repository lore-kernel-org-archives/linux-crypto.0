From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Sun,  7 Dec 2014 07:26:08 -0500
Message-ID: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:36969 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752593AbaLGM0w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:26:52 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a reworked version of my earlier patch series, based on feedback
from Neil Horman and Stephan Mueller.  Thank you both very much!

It's mostly the same content as before, but I've tried to improve comments
and commit messages to address questions, to reorder the patches to put
the questionable stuff at the end, and I've also (at Neil's prodding)
made some larger scale changes.

I've added appropriate const qualifiers to the RNG API, and also const
declarations to all of the self-tests in testmgr.h.  (That's a very
large but simple patch.)

The significant code improvement is the addition of what I call the
"stutter test" to testmgr.  This reads from the RNG in irregular chunks
and verifies that the output matches that produced by a more regular
pattern.  This should prevent any recurrence of CVE-2013-4345.
(It itself passed an important test by detecting a bug in my code!)

Dropped change:
* Neil said he wanted deterministic to remain the default, so I dropped
  the patch that changed the default seedsize.

Pending issues:
* Neil would like me to post the results of the NIST and FIPS test
  vectors.  The current code doesn't print anything on a successful
  test; I need to know what result format is wanted.
* Stephan says he has the FIPS test vectors referred to above and
  will send them to me when he finds them.
* Is non-deterministic mode (last three patches) wanted?

George Spelvin (25):
  crypto: ansi_cprng - unroll _get_more_prng_bytes
  crypto: ansi_cprng - Additional _get_more_prng_bytes cleanup
  crypto: ansi_cprng - Use %phN rather than print_hex_dump for debug
  crypto: ansi_cprng - Make debug output more like NIST test vectors
  crypto: ansi_cprng - Eliminate ctx->I and ctx->last_rand_data
  crypto: ansi_cprng - Make cont_test a bool
  crypto: ansi_cprng - Shrink context some more
  crypto: ansi_cprng - Don't call reset_prng_context from cprng_init
  crypto: ansi_cprng - Make length types consistent
  crypto: ansi_cprng - Use u8 data types consistently internally
  crypto: ansi_cprng - Eliminate unused PRNG_FIXED_SIZE flag
  crypto: ansi_cprng - Get rid of rdata buffer in fips_cprng_reset
  crypto: Add appropriate consts to RNG API
  crypto: tcrypt - Add const qualifiers all over the test code.
  crypto: testmgr - Merge seed arrays in struct cprng_testvec
  crypto: testmgr - Report failure on zero-length crypto_rng_get_bytes
  crypto: testmgr - Don't crash if CPRNG test result is large
  crypto: testmgr - Add CPRNG stutter test.
  crypto: ansi_cprng - simplify get_prng_bytes
  crypto: ansi_cprng - simplify xor_vectors() to xor_block()
  crypto: ansi_cprng - Rename rand_data_valid more sensibly
  crypto: ansi_cprng - Tweak comments
  crypto: ansi_cprng - Introduce a "union cipherblock"
  crypto: ansi_cprng - Introduce non-deterministic mode
  crypto: ansi_cprng - If non-deterministic, don't buffer old output

 crypto/ansi_cprng.c    | 369 ++++++++++++++++--------------------
 crypto/krng.c          |   2 +-
 crypto/rng.c           |   3 +-
 crypto/tcrypt.c        |  46 ++---
 crypto/tcrypt.h        |  30 +--
 crypto/testmgr.c       | 190 +++++++++++++------
 crypto/testmgr.h       | 502 ++++++++++++++++++++++++-------------------------
 include/crypto/rng.h   |   2 +-
 include/linux/crypto.h |   6 +-
 9 files changed, 587 insertions(+), 563 deletions(-)

-- 
2.1.3
