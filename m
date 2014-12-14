From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 00/25] Multiple changes to crypto/ansi_cprng.c
Date: Sun, 14 Dec 2014 13:06:44 +0100
Message-ID: <2320511.tdzPj5eXcj@tachyon.chronox.de>
References: <cover.1417951990.git.linux@horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55041 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaLNMGx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Dec 2014 07:06:53 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SC34C> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 14 Dec 2014 13:06:45 +0100
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 7. Dezember 2014, 07:26:08 schrieb George Spelvin:

Hi George,

> This is a reworked version of my earlier patch series, based on feedback
> from Neil Horman and Stephan Mueller.  Thank you both very much!
> 
> It's mostly the same content as before, but I've tried to improve comments
> and commit messages to address questions, to reorder the patches to put
> the questionable stuff at the end, and I've also (at Neil's prodding)
> made some larger scale changes.
> 
> I've added appropriate const qualifiers to the RNG API, and also const
> declarations to all of the self-tests in testmgr.h.  (That's a very
> large but simple patch.)
> 
> The significant code improvement is the addition of what I call the
> "stutter test" to testmgr.  This reads from the RNG in irregular chunks
> and verifies that the output matches that produced by a more regular
> pattern.  This should prevent any recurrence of CVE-2013-4345.
> (It itself passed an important test by detecting a bug in my code!)
> 
> Dropped change:
> * Neil said he wanted deterministic to remain the default, so I dropped
>   the patch that changed the default seedsize.
> 
> Pending issues:
> * Neil would like me to post the results of the NIST and FIPS test
>   vectors.  The current code doesn't print anything on a successful
>   test; I need to know what result format is wanted.
> * Stephan says he has the FIPS test vectors referred to above and
>   will send them to me when he finds them.

I have send these vectors about a week ago. Do you have results?

Note, apart from the two comments  I sent today, I do not see any big problems 
in the patch set. However, I would like to see the test results.

To give you a helping hand, here is the test invocation of the test vectors I 
sent -- please replace struct kccavs_test->something with just "something" 
holding the values from the test vectors:

struct kccavs_data {
	char *data;
	u64 len;
};

/*
 * input: name
 * input seed: 48 bytes in kccavs_test->key
 * 	       from cprng_reset:
 *  This is the cprng_registered reset method the seed value is
 *  interpreted as the tuple { V KEY DT}
 *
 * output: one round of 32 bytes in kccavs_test->data
 */
static int kccavs_test_x931rng(size_t nbytes) {

	int size;
	int err;
	struct kccavs_data *key = &kccavs_test->key;
	struct kccavs_data *data = &kccavs_test->data;

	/* we scratch the buffer if one should exist */
	memset(data->data, 0, MAXDATALEN);
	data->len = 16;

	if (kccavs_test->rng == NULL) {
		kccavs_test->rng = crypto_alloc_rng(kccavs_test->name, 0, 0);
		if (IS_ERR(kccavs_test->rng)){
			int err = PTR_ERR(kccavs_test->rng);
			kccavs_test->rng = NULL;
			pr_info(DRIVER_NAME": could not allocate RNG handle "
				"for %s\n", kccavs_test->name);
			return err;
		}

		/* the ANSI X9.31 has seedsize
		 * DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ
		 */
		size = crypto_rng_seedsize(kccavs_test->rng);
		if (size != 48) {
			pr_info(DRIVER_NAME": seedsize not equal to 48: %d\n", 
size);
			kccavs_free_cipher();
			return -EAGAIN;
		}
		if (size != key->len) {
			pr_info(DRIVER_NAME": size of supplied seed not equal 
to required size\n");
			kccavs_free_cipher();
			return -EINVAL;
		}

		err = crypto_rng_reset(kccavs_test->rng, key->data, size);
		if (err) {
			pr_info(DRIVER_NAME": Failed to reset rng\n");
			kccavs_free_cipher();
			return -EAGAIN;
		}
	}

	/* get one RNG round of data */
	err = crypto_rng_get_bytes(kccavs_test->rng, data->data, data->len);
	if (err <= 0) {
		pr_info(DRIVER_NAME": could not obtain random data\n");
		kccavs_free_cipher();
		return err;
	}
	
	/* do not free the rng handle - we keep until reseeded or terminated 
*/

	return 0;
}


Note, the test vectors I sent to you are two-fold. The larger set is just a 
"known-answer test" where you invoke the X9.31 with the input data and get the 
output data right away.

The MCT test vectors are "monte-carlo tests". They are invoked as follows: you 
read 10000 16 byte chunks -- the 10000th value is the one that should match 
with the expected result.


Note, the seed is to be constructed from the test vectors by simply 
concatenating them as outlined in the comment above. The following Perl code 
illustrates that:

my $seed = $v . $key . $dt;


> * Is non-deterministic mode (last three patches) wanted?
> 
> George Spelvin (25):
>   crypto: ansi_cprng - unroll _get_more_prng_bytes
>   crypto: ansi_cprng - Additional _get_more_prng_bytes cleanup
>   crypto: ansi_cprng - Use %phN rather than print_hex_dump for debug
>   crypto: ansi_cprng - Make debug output more like NIST test vectors
>   crypto: ansi_cprng - Eliminate ctx->I and ctx->last_rand_data
>   crypto: ansi_cprng - Make cont_test a bool
>   crypto: ansi_cprng - Shrink context some more
>   crypto: ansi_cprng - Don't call reset_prng_context from cprng_init
>   crypto: ansi_cprng - Make length types consistent
>   crypto: ansi_cprng - Use u8 data types consistently internally
>   crypto: ansi_cprng - Eliminate unused PRNG_FIXED_SIZE flag
>   crypto: ansi_cprng - Get rid of rdata buffer in fips_cprng_reset
>   crypto: Add appropriate consts to RNG API
>   crypto: tcrypt - Add const qualifiers all over the test code.
>   crypto: testmgr - Merge seed arrays in struct cprng_testvec
>   crypto: testmgr - Report failure on zero-length crypto_rng_get_bytes
>   crypto: testmgr - Don't crash if CPRNG test result is large
>   crypto: testmgr - Add CPRNG stutter test.
>   crypto: ansi_cprng - simplify get_prng_bytes
>   crypto: ansi_cprng - simplify xor_vectors() to xor_block()
>   crypto: ansi_cprng - Rename rand_data_valid more sensibly
>   crypto: ansi_cprng - Tweak comments
>   crypto: ansi_cprng - Introduce a "union cipherblock"
>   crypto: ansi_cprng - Introduce non-deterministic mode
>   crypto: ansi_cprng - If non-deterministic, don't buffer old output
> 
>  crypto/ansi_cprng.c    | 369 ++++++++++++++++--------------------
>  crypto/krng.c          |   2 +-
>  crypto/rng.c           |   3 +-
>  crypto/tcrypt.c        |  46 ++---
>  crypto/tcrypt.h        |  30 +--
>  crypto/testmgr.c       | 190 +++++++++++++------
>  crypto/testmgr.h       | 502
> ++++++++++++++++++++++++------------------------- include/crypto/rng.h   | 
>  2 +-
>  include/linux/crypto.h |   6 +-
>  9 files changed, 587 insertions(+), 563 deletions(-)


-- 
Ciao
Stephan
