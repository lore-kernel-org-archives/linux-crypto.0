From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Testing the PRNG driver of the Allwinner Security System A20
Date: Tue, 01 Jul 2014 13:14:02 +0200
Message-ID: <53B297FA.4050106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44677 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106AbaGALQO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 07:16:14 -0400
Received: by mail-wi0-f177.google.com with SMTP id r20so7501271wiv.16
        for <linux-crypto@vger.kernel.org>; Tue, 01 Jul 2014 04:16:12 -0700 (PDT)
Received: from [10.234.175.50] ([193.252.149.222])
        by mx.google.com with ESMTPSA id jy8sm47554370wjc.7.2014.07.01.04.16.10
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 01 Jul 2014 04:16:11 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

I am writing the PRNG driver for the Allwinner Security System SoC A20.

I didn't know how to test it, so I have found that char/hw_random/exynos-rng.c exposes a PRNG via the hwrng interfaces.
So I have written a HWRNG driver that use the SS PRNG via the crypto API (crypto_alloc_rng/crypto_rng_reset/crypto_rng_get_bytes)
I have attached the code in case of...

The problem is that rngtest show some failures.
cat /dev/hwrng | rngtest
rngtest: bits received from input: 1876960032
rngtest: FIPS 140-2 successes: 93771
rngtest: FIPS 140-2 failures: 77
rngtest: FIPS 140-2(2001-10-10) Monobit: 15
rngtest: FIPS 140-2(2001-10-10) Poker: 11
rngtest: FIPS 140-2(2001-10-10) Runs: 30
rngtest: FIPS 140-2(2001-10-10) Long run: 22
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=979.894; avg=109756.722; max=4882812.500)Kibits/s
rngtest: FIPS tests speed: (min=1.309; avg=32.191; max=39.986)Mibits/s
rngtest: Program run time: 72523286 microseconds

So I have questions:
- Does the use of a HWRNG driver for exposing the PRNG is a good idea ?
- Could I think the PRNG is good enough with the result of rngtest ?

Bests regards



/*
 * ss-rng.c - Random Number Generator driver for the Security System
 */

#include <linux/hw_random.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <crypto/rng.h>

struct ss_rng_ctx {
	struct hwrng rng;
	struct crypto_rng *cr;
};

static struct ss_rng_ctx ss_rng;

#define SS_SEED_LEN (192/8)

static int ss_rng_init(struct hwrng *rng)
{
	int i;
	u8 seed[SS_SEED_LEN];
	u32 *s = (u32 *)seed;
	for (i = 0 ; i < SS_SEED_LEN/4 ; i++)
		s[i] = jiffies;
	crypto_rng_reset(ss_rng.cr, seed, SS_SEED_LEN);
	return 0;
}

static int ss_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
{
	return crypto_rng_get_bytes(ss_rng.cr, buf, max);
}

static int ss_rng_probe(void)
{
	int err;
	struct crypto_rng *rng;
	const char *name;

	rng = crypto_alloc_rng("stdrng", 0, 0);
	err = PTR_ERR(rng);
	if (IS_ERR(rng))
		return err;

	name = crypto_tfm_alg_driver_name(crypto_rng_tfm(rng));
	if (strcmp(name, "rng-sunxi-ss") != 0) {
		pr_err("ERROR: Cannot get Security System PRNG, but got %s instead\n", name);
		crypto_free_rng(rng);
		return -ENODEV;
	}

	ss_rng.cr = rng;
	ss_rng.rng.name = "Security System HWRNG";
	ss_rng.rng.init = ss_rng_init;
	ss_rng.rng.read = ss_rng_read;
	err = hwrng_register(&ss_rng.rng);
	if (err != 0) {
		crypto_free_rng(ss_rng.cr);
	}
	return err;
}

static void ss_rng_remove(void)
{
	hwrng_unregister(&ss_rng.rng);
	crypto_free_rng(ss_rng.cr);
}

module_init(ss_rng_probe);
module_exit(ss_rng_remove);

MODULE_DESCRIPTION("Allwinner Security System H/W Random Number Generator driver");
MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
MODULE_LICENSE("GPL");
