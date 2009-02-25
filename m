From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: [PATCH] crypto: implement new prng, Vegard's PRNG
Date: Wed, 25 Feb 2009 16:12:43 +0100
Message-ID: <20090225151243.GA31418@damson.getinternet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:49959 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763707AbZBYPTq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 10:19:46 -0500
Received: by fxm24 with SMTP id 24so28323fxm.37
        for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2009 07:19:43 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>From 0dea4a79c856eb5d0897fa3c83fd7b4aa1b5150f Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 23 Jan 2009 20:17:08 +0100
Subject: [PATCH] crypto: implement new prng, Vegard's PRNG

Hi,

I realize that submitting a non-cryptographically secure algorithm to a
crypto mailing list might not make too much sense. On the other hand, it
shouldn't hurt either, and I've written this, so why not? I don't know
if this is actually useful for anything at all, so this patch is more of
an "it exists" rather than a serious patch submission.

The only obvious property of this algorithm is its fixed, known sequence
period.

(Note: I didn't actually test the code either, so it could all be wrong.)

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 crypto/Kconfig  |    7 ++
 crypto/Makefile |    1 +
 crypto/vprng.c  |  179 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 187 insertions(+), 0 deletions(-)
 create mode 100644 crypto/vprng.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 8dde4fc..e31c97d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -734,6 +734,13 @@ config CRYPTO_ANSI_CPRNG
 	  for cryptographic modules.  Uses the Algorithm specified in
 	  ANSI X9.31 A.2.4
 
+config CRYPTO_VPRNG
+	tristate "Vegard's Pseudo-Random Number Generator"
+	select CRYPTO_RNG
+	help
+	  A very simple PRNG. WARNING: This algorithm is not
+	  cryptographically secure!
+
 source "drivers/crypto/Kconfig"
 
 endif	# if CRYPTO
diff --git a/crypto/Makefile b/crypto/Makefile
index 46b08bf..417b197 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
+obj-$(CONFIG_CRYPTO_VPRNG) += vprng.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 
 #
diff --git a/crypto/vprng.c b/crypto/vprng.c
new file mode 100644
index 0000000..eeed88f
--- /dev/null
+++ b/crypto/vprng.c
@@ -0,0 +1,179 @@
+/*
+ * Vegard's Pseudo-Random NG.
+ *
+ * Copyright (c) 2009 Vegard Nossum <vegard.nossum@gmail.com>
+ *
+ * based on:
+ *
+ * RNG implementation using standard kernel RNG.
+ *
+ * Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * any later version.
+ *
+ */
+
+#include <crypto/internal/rng.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/random.h>
+
+#define DEFAULT_N 40
+
+/* A table of prime numbers. This could be generated, but what a bother. */
+static int primes[] = {
+	  2,   3,   5,   7,  11,  13,  17,  19,  23,  29,  31,  37,
+	 41,  43,  47,  53,  59,  61,  67,  71,  73,  79,  83,  89,
+	 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151,
+	157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223,
+	227, 229, 233, 239, 241, 251, 257, 263, 269, 271,
+};
+
+struct vprng_context {
+	spinlock_t lock;
+
+	/* The number of counters */
+	unsigned int n;
+
+	/* Counters */
+	u8 *c;
+};
+
+static int vprng_init(struct crypto_tfm *tfm)
+{
+	struct vprng_context *ctx = crypto_tfm_ctx(tfm);
+
+	spin_lock_init(&ctx->lock);
+	ctx->n = DEFAULT_N;
+	ctx->c = kcalloc(ctx->n, sizeof(*ctx->c), 0);
+	if (!ctx->c)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void vprng_exit(struct crypto_tfm *tfm)
+{
+	struct vprng_context *ctx = crypto_tfm_ctx(tfm);
+
+	kfree(ctx->c);
+}
+
+/*
+ * To generate a random bit, we sum the values of all the counters and return
+ * the least significant bit of this number. The counters all wrap around at
+ * a prime number, so the generated sequence of bits has a period of exactly
+ * $ \prod_{i=0}^{n-1} primes_i $ bits.
+ */
+static u8 vprng_get_random_bit(unsigned int n, u8 *c)
+{
+	u8 ret;
+	unsigned int i;
+
+	ret = 0;
+	for (i = 0; i < n; ++i) {
+		ret += c[i];
+
+		if (++c[i] == primes[i])
+			c[i] = 0;
+	}
+
+	return ret & 1;
+}
+
+static u8 vprng_get_random_byte(unsigned int n, u8 *c)
+{
+	u8 ret;
+	unsigned int i;
+
+	ret = 0;
+	for (i = 0; i < 8; ++i)
+		ret = (ret << 1) | vprng_get_random_bit(n, c);
+
+	return ret;
+}
+
+static int vprng_get_random(struct crypto_rng *tfm,
+	u8 *rdata, unsigned int dlen)
+{
+	struct vprng_context *ctx = crypto_rng_ctx(tfm);
+	unsigned int i;
+
+	spin_lock(&ctx->lock);
+	for (i = 0; i < dlen; ++i)
+		rdata[i] = vprng_get_random_byte(ctx->n, ctx->c);
+	spin_unlock(&ctx->lock);
+
+	return 0;
+}
+
+static int _vprng_reset(struct vprng_context *ctx, u8 *seed, unsigned int slen)
+{
+	unsigned int i;
+
+	if (slen != ctx->n)
+		return -EINVAL;
+
+	for (i = 0; i < slen; ++i)
+		ctx->c[i] = seed[i];
+
+	return 0;
+}
+
+static int vprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
+{
+	struct vprng_context *ctx = crypto_rng_ctx(tfm);
+	int ret;
+
+	spin_lock(&ctx->lock);
+	ret = _vprng_reset(ctx, seed, slen);
+	spin_unlock(&ctx->lock);
+
+	return ret;
+}
+
+static struct crypto_alg vprng_alg = {
+	.cra_name		= "vprng",
+	.cra_driver_name	= "vprng",
+	.cra_priority		= 100,
+	.cra_flags		= CRYPTO_ALG_TYPE_RNG,
+	.cra_ctxsize		= sizeof(struct vprng_context),
+	.cra_type		= &crypto_rng_type,
+	.cra_module		= THIS_MODULE,
+	.cra_list		= LIST_HEAD_INIT(vprng_alg.cra_list),
+	.cra_init		= &vprng_init,
+	.cra_exit		= &vprng_exit,
+	.cra_u			= {
+		.rng = {
+			.rng_make_random	= vprng_get_random,
+			.rng_reset		= vprng_reset,
+			.seedsize		= DEFAULT_N,
+		}
+	}
+};
+
+/* Module initalization */
+static int __init vprng_mod_init(void)
+{
+	/* Make sure we have enough prime numbers. */
+	BUILD_BUG_ON(ARRAY_SIZE(primes) < DEFAULT_N);
+
+	return crypto_register_alg(&vprng_alg);
+}
+
+static void __exit vprng_mod_fini(void)
+{
+	crypto_unregister_alg(&vprng_alg);
+}
+
+module_init(vprng_mod_init);
+module_exit(vprng_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Vegard's Pseudo-Random Number Generator");
+MODULE_AUTHOR("Vegard Nossum <vegard.nossum@gmail.com>");
+MODULE_ALIAS("vprng");
-- 
1.6.0.6

