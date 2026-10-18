Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCD440EB80
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356572; cv=none; b=YRaeVekxx4c4AsA3KSkraT+Be0iQTDvnx+FhK3PFSyLrVnyuQdOFgVT16l/vfb+EZBduqEo1eNchhntgq+KeeosUYvhQrinlkaAkUWckqO5a1uNDbl69DekoiJHQZVGWP4fSghbqXkUt2J8EZ2AHmyx7TTgiIl1+do5FsQFHY5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356572; c=relaxed/simple;
	bh=cjtx+ZFA/lJ0ogh8fbCrk7sFq4Ve83AetuiGIlmEiu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWhrgVwgW8tdHCWgPwCqiXJD19ou0epXysm7cFN+wk4TG9QZSQdaxT4mc4UkGOdnmIocgB5SNjQlUETVz4ACxRsIBDjBLdYnCPTfTCi1Dciw/BJmKEZ19F3BffkA8jfzD8P08yATU3JFR2o8ZM25h4esTBHPyveb6v95Rx/FsMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wdj5HPw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wdj5HPw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C9F1F000C7;
	Sun, 18 Oct 2026 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356570;
	bh=pu9MAt1fD1JyCvs7tIsYWn9xdN2WFw6eFIFGe5yxWg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wdj5HPw4ZZRtTeoReD8Z1TfdfucMEdddOAMT04Xu2WJQzJBADW62idyngFxqvYYPb
	 NOj6Er4NSXSbzboG4KkYXDKIVzqLKTLlcx960IIKdPo7GBUEa4rBp9ZhzjFKEnoeDA
	 RsLpuErmFnH7Y8s9CNkG0iy00+fM6R6k76arg6CoAy0HmDThK6S6BU6AX5lKmQNcNT
	 1trlnwoCI+DLE+Vv50fg5x72pxYOejRwi2D7bUl3HUYEEQp2nvMctbSXDwo64o/gaO
	 pEKPmch9LgOiQppnpPI6ZEQi4hjbl4kIyqQXEHHuEhfb7dxh9blKMkGRO0UsI/B4hG
	 Ur7Y5BTcp2EzQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 13/14] crypto: rng - Remove the rng algorithm type
Date: Sun, 18 Oct 2026 13:46:17 -0700
Message-ID: <20261018204618.104876-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261018204618.104876-1-ebiggers@kernel.org>
References: <20261018204618.104876-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are no users of crypto_rng remaining, so remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/api-rng.rst      |  17 ---
 Documentation/crypto/api-samples.rst  |  37 ------
 Documentation/crypto/api.rst          |   1 -
 Documentation/crypto/architecture.rst |   8 --
 crypto/Kconfig                        |   9 --
 crypto/Makefile                       |   1 -
 crypto/rng.c                          | 157 ----------------------
 include/crypto/internal/rng.h         |  31 -----
 include/crypto/rng.h                  | 182 --------------------------
 include/linux/crypto.h                |   3 +-
 include/uapi/linux/cryptouser.h       |   3 +-
 11 files changed, 3 insertions(+), 446 deletions(-)
 delete mode 100644 Documentation/crypto/api-rng.rst
 delete mode 100644 crypto/rng.c
 delete mode 100644 include/crypto/internal/rng.h

diff --git a/Documentation/crypto/api-rng.rst b/Documentation/crypto/api-rng.rst
deleted file mode 100644
index 23a94c0b272ee..0000000000000
--- a/Documentation/crypto/api-rng.rst
+++ /dev/null
@@ -1,17 +0,0 @@
-Random Number Generator (RNG)
-=============================
-
-Random Number Algorithm Definitions
------------------------------------
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: rng_alg
-
-Crypto API Random Number API
-----------------------------
-
-.. kernel-doc:: include/crypto/rng.h
-   :doc: Random number generator API
-
-.. kernel-doc:: include/crypto/rng.h
-   :functions: crypto_alloc_rng crypto_rng_alg crypto_free_rng crypto_rng_generate crypto_rng_get_bytes crypto_rng_reset crypto_rng_seedsize
diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index 388bb7d7a460b..8816565dd046f 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -148,40 +148,3 @@ Code Example For Use of Operational State Memory With SHASH
         crypto_free_shash(alg);
         return ret;
     }
-
-
-Code Example For Random Number Generator Usage
-----------------------------------------------
-
-::
-
-
-    static int get_random_numbers(u8 *buf, unsigned int len)
-    {
-        struct crypto_rng *rng = NULL;
-        char *drbg = "stdrng";
-        int ret;
-
-        if (!buf || !len) {
-            pr_debug("No output buffer provided\n");
-            return -EINVAL;
-        }
-
-        rng = crypto_alloc_rng(drbg, 0, 0);
-        if (IS_ERR(rng)) {
-            pr_debug("could not allocate RNG handle for %s\n", drbg);
-            return PTR_ERR(rng);
-        }
-
-        ret = crypto_rng_get_bytes(rng, buf, len);
-        if (ret < 0)
-            pr_debug("generation of random numbers failed\n");
-        else if (ret == 0)
-            pr_debug("RNG returned no data");
-        else
-            pr_debug("RNG returned %d bytes of data\n", ret);
-
-    out:
-        crypto_free_rng(rng);
-        return ret;
-    }
diff --git a/Documentation/crypto/api.rst b/Documentation/crypto/api.rst
index 8b2a905218862..bf5827eca88dc 100644
--- a/Documentation/crypto/api.rst
+++ b/Documentation/crypto/api.rst
@@ -8,7 +8,6 @@ Programming Interface
    api-skcipher
    api-aead
    api-digest
-   api-rng
    api-akcipher
    api-sig
    api-kpp
diff --git a/Documentation/crypto/architecture.rst b/Documentation/crypto/architecture.rst
index ec2e99d99aff5..206cd9322dee3 100644
--- a/Documentation/crypto/architecture.rst
+++ b/Documentation/crypto/architecture.rst
@@ -13,8 +13,6 @@ cipher types:
 
 -  Message digest, including keyed message digest
 
--  Random number generation
-
 -  User space interface
 
 Ciphers And Templates
@@ -155,8 +153,6 @@ applicable to a cipher, it is not displayed:
 
    -  compression for compression type transformations
 
-   -  rng for random number generator
-
    -  kpp for a Key-agreement Protocol Primitive (KPP) cipher such as
       an ECDH or DH implementation
 
@@ -166,8 +162,6 @@ applicable to a cipher, it is not displayed:
 
 -  ivsize: IV size in bytes
 
--  seedsize: required size of seed data for random number generator
-
 -  digestsize: output size of the message digest
 
 -  geniv: IV generator (obsolete)
@@ -208,8 +202,6 @@ the aforementioned cipher types:
 
 -  CRYPTO_ALG_TYPE_AHASH Asynchronous multi-block hash
 
--  CRYPTO_ALG_TYPE_RNG Random Number Generation
-
 -  CRYPTO_ALG_TYPE_AKCIPHER Asymmetric cipher
 
 -  CRYPTO_ALG_TYPE_SIG Asymmetric signature
diff --git a/crypto/Kconfig b/crypto/Kconfig
index da7f2dca05d4a..01fe01656d442 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -98,15 +98,6 @@ config CRYPTO_HASH2
 	tristate
 	select CRYPTO_ALGAPI2
 
-config CRYPTO_RNG
-	tristate
-	select CRYPTO_RNG2
-	select CRYPTO_ALGAPI
-
-config CRYPTO_RNG2
-	tristate
-	select CRYPTO_ALGAPI2
-
 config CRYPTO_AKCIPHER2
 	tristate
 	select CRYPTO_ALGAPI2
diff --git a/crypto/Makefile b/crypto/Makefile
index 8386d55a9755e..b5256119d035a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -156,7 +156,6 @@ obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
 obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
 obj-$(CONFIG_CRYPTO_XXHASH) += xxhash_generic.o
 obj-$(CONFIG_CRYPTO_842) += 842.o
-obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
diff --git a/crypto/rng.c b/crypto/rng.c
deleted file mode 100644
index be4873bec679b..0000000000000
--- a/crypto/rng.c
+++ /dev/null
@@ -1,157 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * Cryptographic API.
- *
- * RNG operations.
- *
- * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
- * Copyright (c) 2015 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#include <crypto/internal/rng.h>
-#include <linux/atomic.h>
-#include <linux/cryptouser.h>
-#include <linux/err.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/mutex.h>
-#include <linux/random.h>
-#include <linux/seq_file.h>
-#include <linux/slab.h>
-#include <linux/string.h>
-#include <net/netlink.h>
-
-#include "internal.h"
-
-int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
-{
-	u8 *buf = NULL;
-	int err;
-
-	if (!seed && slen) {
-		buf = kmalloc(slen, GFP_KERNEL);
-		if (!buf)
-			return -ENOMEM;
-
-		err = get_random_bytes_wait(buf, slen);
-		if (err)
-			goto out;
-		seed = buf;
-	}
-
-	err = crypto_rng_alg(tfm)->seed(tfm, seed, slen);
-out:
-	kfree_sensitive(buf);
-	return err;
-}
-EXPORT_SYMBOL_GPL(crypto_rng_reset);
-
-static int crypto_rng_init_tfm(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
-static unsigned int seedsize(struct crypto_alg *alg)
-{
-	struct rng_alg *ralg = container_of(alg, struct rng_alg, base);
-
-	return ralg->seedsize;
-}
-
-static int __maybe_unused crypto_rng_report(
-	struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_rng rrng = {
-		.type = "rng",
-	};
-
-	rrng.seedsize = seedsize(alg);
-
-	return nla_put(skb, CRYPTOCFGA_REPORT_RNG, sizeof(rrng), &rrng);
-}
-
-static void __maybe_unused crypto_rng_show(struct seq_file *m,
-					   struct crypto_alg *alg)
-{
-	seq_printf(m, "type         : rng\n");
-	seq_printf(m, "seedsize     : %u\n", seedsize(alg));
-}
-
-static const struct crypto_type crypto_rng_type = {
-	.extsize = crypto_alg_extsize,
-	.init_tfm = crypto_rng_init_tfm,
-#ifdef CONFIG_PROC_FS
-	.show = crypto_rng_show,
-#endif
-#if IS_ENABLED(CONFIG_CRYPTO_USER)
-	.report = crypto_rng_report,
-#endif
-	.maskclear = ~CRYPTO_ALG_TYPE_MASK,
-	.maskset = CRYPTO_ALG_TYPE_MASK,
-	.type = CRYPTO_ALG_TYPE_RNG,
-	.tfmsize = offsetof(struct crypto_rng, base),
-	.algsize = offsetof(struct rng_alg, base),
-};
-
-struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
-{
-	return crypto_alloc_tfm(alg_name, &crypto_rng_type, type, mask);
-}
-EXPORT_SYMBOL_GPL(crypto_alloc_rng);
-
-static void rng_default_set_ent(struct crypto_rng *tfm, const u8 *data,
-				unsigned int len)
-{
-}
-
-int crypto_register_rng(struct rng_alg *alg)
-{
-	struct crypto_alg *base = &alg->base;
-
-	if (alg->seedsize > PAGE_SIZE / 8)
-		return -EINVAL;
-
-	base->cra_type = &crypto_rng_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
-	base->cra_flags |= CRYPTO_ALG_TYPE_RNG;
-
-	if (!alg->set_ent)
-		alg->set_ent = rng_default_set_ent;
-
-	return crypto_register_alg(base);
-}
-EXPORT_SYMBOL_GPL(crypto_register_rng);
-
-void crypto_unregister_rng(struct rng_alg *alg)
-{
-	crypto_unregister_alg(&alg->base);
-}
-EXPORT_SYMBOL_GPL(crypto_unregister_rng);
-
-int crypto_register_rngs(struct rng_alg *algs, int count)
-{
-	int i, ret;
-
-	for (i = 0; i < count; i++) {
-		ret = crypto_register_rng(algs + i);
-		if (ret) {
-			crypto_unregister_rngs(algs, i);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(crypto_register_rngs);
-
-void crypto_unregister_rngs(struct rng_alg *algs, int count)
-{
-	int i;
-
-	for (i = count - 1; i >= 0; --i)
-		crypto_unregister_rng(algs + i);
-}
-EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Random Number Generator");
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
deleted file mode 100644
index 8c9f560d6449c..0000000000000
--- a/include/crypto/internal/rng.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * RNG: Random Number Generator  algorithms under the crypto API
- *
- * Copyright (c) 2008 Neil Horman <nhorman@tuxdriver.com>
- * Copyright (c) 2015 Herbert Xu <herbert@gondor.apana.org.au>
- */
-
-#ifndef _CRYPTO_INTERNAL_RNG_H
-#define _CRYPTO_INTERNAL_RNG_H
-
-#include <crypto/algapi.h>
-#include <crypto/rng.h>
-
-int crypto_register_rng(struct rng_alg *alg);
-void crypto_unregister_rng(struct rng_alg *alg);
-int crypto_register_rngs(struct rng_alg *algs, int count);
-void crypto_unregister_rngs(struct rng_alg *algs, int count);
-
-static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
-{
-	return crypto_tfm_ctx(&tfm->base);
-}
-
-static inline void crypto_rng_set_entropy(struct crypto_rng *tfm,
-					  const u8 *data, unsigned int len)
-{
-	crypto_rng_alg(tfm)->set_ent(tfm, data, len);
-}
-
-#endif
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 463bbdce11c2c..087c04c118db6 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -9,56 +9,9 @@
 #ifndef _CRYPTO_RNG_H
 #define _CRYPTO_RNG_H
 
-#include <linux/atomic.h>
-#include <linux/container_of.h>
-#include <linux/crypto.h>
 #include <linux/fips.h>
 #include <linux/random.h>
 
-struct crypto_rng;
-
-/**
- * struct rng_alg - random number generator definition
- *
- * @generate:	The function defined by this variable obtains a
- *		random number. The random number generator transform
- *		must generate the random number out of the context
- *		provided with this call, plus any additional data
- *		if provided to the call.
- * @seed:	Seed or reseed the random number generator.  With the
- *		invocation of this function call, the random number
- *		generator shall become ready for generation.  If the
- *		random number generator requires a seed for setting
- *		up a new state, the seed must be provided by the
- *		consumer while invoking this function. The required
- *		size of the seed is defined with @seedsize .
- * @set_ent:	Set entropy that would otherwise be obtained from
- *		entropy source.  Internal use only.
- * @seedsize:	The seed size required for a random number generator
- *		initialization defined with this variable. Some
- *		random number generators does not require a seed
- *		as the seeding is implemented internally without
- *		the need of support by the consumer. In this case,
- *		the seed size is set to zero.
- * @base:	Common crypto API algorithm data structure.
- */
-struct rng_alg {
-	int (*generate)(struct crypto_rng *tfm,
-			const u8 *src, unsigned int slen,
-			u8 *dst, unsigned int dlen);
-	int (*seed)(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
-	void (*set_ent)(struct crypto_rng *tfm, const u8 *data,
-			unsigned int len);
-
-	unsigned int seedsize;
-
-	struct crypto_alg base;
-};
-
-struct crypto_rng {
-	struct crypto_tfm base;
-};
-
 int __crypto_stdrng_get_bytes(void *buf, unsigned int len);
 
 /**
@@ -89,139 +42,4 @@ static inline int crypto_del_default_rng(void)
 }
 #endif
 
-/**
- * DOC: Random number generator API
- *
- * The random number generator API is used with the ciphers of type
- * CRYPTO_ALG_TYPE_RNG (listed as type "rng" in /proc/crypto)
- */
-
-/**
- * crypto_alloc_rng() -- allocate RNG handle
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	      message digest cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Allocate a cipher handle for a random number generator. The returned struct
- * crypto_rng is the cipher handle that is required for any subsequent
- * API invocation for that random number generator.
- *
- * For all random number generators, this call creates a new private copy of
- * the random number generator that does not share a state with other
- * instances. The only exception is the "krng" random number generator which
- * is a kernel crypto API use case for the get_random_bytes() function of the
- * /dev/random driver.
- *
- * Return: allocated cipher handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
- */
-struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask);
-
-static inline struct crypto_tfm *crypto_rng_tfm(struct crypto_rng *tfm)
-{
-	return &tfm->base;
-}
-
-static inline struct rng_alg *__crypto_rng_alg(struct crypto_alg *alg)
-{
-	return container_of(alg, struct rng_alg, base);
-}
-
-/**
- * crypto_rng_alg() - obtain 'struct rng_alg' pointer from RNG handle
- * @tfm: RNG handle
- *
- * Return: Pointer to 'struct rng_alg', derived from @tfm RNG handle
- */
-static inline struct rng_alg *crypto_rng_alg(struct crypto_rng *tfm)
-{
-	return __crypto_rng_alg(crypto_rng_tfm(tfm)->__crt_alg);
-}
-
-/**
- * crypto_free_rng() - zeroize and free RNG handle
- * @tfm: cipher handle to be freed
- *
- * If @tfm is a NULL or error pointer, this function does nothing.
- */
-static inline void crypto_free_rng(struct crypto_rng *tfm)
-{
-	crypto_destroy_tfm(tfm, crypto_rng_tfm(tfm));
-}
-
-/**
- * crypto_rng_generate() - get random number
- * @tfm: cipher handle
- * @src: Input buffer holding additional data, may be NULL
- * @slen: Length of additional data
- * @dst: output buffer holding the random numbers
- * @dlen: length of the output buffer
- *
- * This function fills the caller-allocated buffer with random
- * numbers using the random number generator referenced by the
- * cipher handle.
- *
- * Return: 0 function was successful; < 0 if an error occurred
- */
-static inline int crypto_rng_generate(struct crypto_rng *tfm,
-				      const u8 *src, unsigned int slen,
-				      u8 *dst, unsigned int dlen)
-{
-	return crypto_rng_alg(tfm)->generate(tfm, src, slen, dst, dlen);
-}
-
-/**
- * crypto_rng_get_bytes() - get random number
- * @tfm: cipher handle
- * @rdata: output buffer holding the random numbers
- * @dlen: length of the output buffer
- *
- * This function fills the caller-allocated buffer with random numbers using the
- * random number generator referenced by the cipher handle.
- *
- * Return: 0 function was successful; < 0 if an error occurred
- */
-static inline int crypto_rng_get_bytes(struct crypto_rng *tfm,
-				       u8 *rdata, unsigned int dlen)
-{
-	return crypto_rng_generate(tfm, NULL, 0, rdata, dlen);
-}
-
-/**
- * crypto_rng_reset() - re-initialize the RNG
- * @tfm: cipher handle
- * @seed: seed input data
- * @slen: length of the seed input data
- *
- * The reset function completely re-initializes the random number generator
- * referenced by the cipher handle by clearing the current state. The new state
- * is initialized with the caller provided seed or automatically, depending on
- * the random number generator type. (The SP800-90A DRBGs perform an automatic
- * seeding.) The seed is provided as a parameter to this function call. The
- * provided seed should have the length of the seed size defined for the random
- * number generator as defined by crypto_rng_seedsize.
- *
- * Return: 0 if the setting of the key was successful; < 0 if an error occurred
- */
-int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed,
-		     unsigned int slen);
-
-/**
- * crypto_rng_seedsize() - obtain seed size of RNG
- * @tfm: cipher handle
- *
- * The function returns the seed size for the random number generator
- * referenced by the cipher handle. This value may be zero if the random
- * number generator does not implement or require a reseeding. For example,
- * the SP800-90A DRBGs implement an automated reseeding after reaching a
- * pre-defined threshold.
- *
- * Return: seed size for the random number generator
- */
-static inline int crypto_rng_seedsize(struct crypto_rng *tfm)
-{
-	return crypto_rng_alg(tfm)->seedsize;
-}
-
 #endif
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b7c97f1c47c92..bfad00a1339ca 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -31,7 +31,6 @@
 #define CRYPTO_ALG_TYPE_KPP		0x00000008
 #define CRYPTO_ALG_TYPE_ACOMPRESS	0x0000000a
 #define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000b
-#define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_HASH		0x0000000e
 #define CRYPTO_ALG_TYPE_SHASH		0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000f
@@ -307,7 +306,7 @@ struct cipher_alg {
  * @cra_type: Type of the cryptographic transformation. This is a pointer to
  *	      struct crypto_type, which implements callbacks common for all
  *	      transformation types. There are multiple options, such as
- *	      &crypto_skcipher_type, &crypto_ahash_type, &crypto_rng_type.
+ *	      &crypto_skcipher_type, &crypto_ahash_type.
  *	      This field might be empty. In that case, there are no common
  *	      callbacks. This is the case for: cipher.
  * @cra_u: Callbacks implementing the transformation. This is a union of
diff --git a/include/uapi/linux/cryptouser.h b/include/uapi/linux/cryptouser.h
index db05e04199726..29f9c6c4290bb 100644
--- a/include/uapi/linux/cryptouser.h
+++ b/include/uapi/linux/cryptouser.h
@@ -49,7 +49,7 @@ enum crypto_attr_type_t {
 	CRYPTOCFGA_REPORT_BLKCIPHER,	/* struct crypto_report_blkcipher */
 	CRYPTOCFGA_REPORT_AEAD,		/* struct crypto_report_aead */
 	CRYPTOCFGA_REPORT_COMPRESS,	/* struct crypto_report_comp */
-	CRYPTOCFGA_REPORT_RNG,		/* struct crypto_report_rng */
+	CRYPTOCFGA_REPORT_RNG,		/* No longer supported, do not use. */
 	CRYPTOCFGA_REPORT_CIPHER,	/* struct crypto_report_cipher */
 	CRYPTOCFGA_REPORT_AKCIPHER,	/* struct crypto_report_akcipher */
 	CRYPTOCFGA_REPORT_KPP,		/* struct crypto_report_kpp */
@@ -191,6 +191,7 @@ struct crypto_report_comp {
 	char type[CRYPTO_MAX_NAME];
 };
 
+/* No longer supported, do not use. */
 struct crypto_report_rng {
 	char type[CRYPTO_MAX_NAME];
 	unsigned int seedsize;
-- 
2.56.0

