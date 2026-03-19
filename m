Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5393603F6;
	Thu, 19 Mar 2026 06:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773901162; cv=none; b=KIU3EYqAdfV0AtII5+/tz+ZRBg70qCuHYWPJsUY9CHa8EV5ZPmXAOirjPQpWGw/D4YlwPqWTP37wZ8ViI7IHhVG15BRSj47v++1r+ZJwV9qEfX+vN83Po6xAuuS2WC5anBkr3fVaXvJQ2PUmJxg2VXimqqtgoXJlZ++3Qnv+q4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773901162; c=relaxed/simple;
	bh=A17Or1mhILOD8g/OauvklfFcseA7rh2PNPCFHHxYHps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHRau+aDERm3jTqCcDeZd0V7jtV15+y8420ct4/QRsjm2fvED4wT290xjZUeJdXT6jjWlRSluvMGm1s6X1SqOsdipxQ/jv0WH5W8fqvu/WbUc/NhJ9OJ+J78HBkcWUX6NfvxZgonp8OQznE+Y43MYMYHNJGbhTq5MO3oVSpOuVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rLuXxi5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rLuXxi5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD107C2BCC4;
	Thu, 19 Mar 2026 06:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901162;
	bh=A17Or1mhILOD8g/OauvklfFcseA7rh2PNPCFHHxYHps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLuXxi5JU7e4lhDja+r/raWzll947pWc4MN189ypr8SfFoCCk+3TWuQLyZg5+aqur
	 KtJWSfl0m9oJzz/nIxydzurMQxR/TXkO3B2H6vPc8ohT6HxPfCtyBjfA+jfePcJTLv
	 iXWK9SuB8JbbOGVLAdzzUmS/keEKFG5TpF5elm5N3dm7pANpOfiyrfurP6rzophpj0
	 PgPEoS+zkDU/xnBynkSgZcrtmGPnxFbVyqi30/9F0B7YBbz8fyFYdGGZgkOat5RGXw
	 RDkNDtSWLFnuvY0vc62CKN9KHXl5vaSu/UIq1pYiP609MOnMgpbb18sNPGGJfx/fIG
	 WUzFLC7v2SSNg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 16/19] crypto: ghash - Remove ghash from crypto_shash API
Date: Wed, 18 Mar 2026 23:17:17 -0700
Message-ID: <20260319061723.1140720-17-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319061723.1140720-1-ebiggers@kernel.org>
References: <20260319061723.1140720-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Now that there are no users of the "ghash" crypto_shash algorithm,
remove it.  GHASH remains supported via the library API.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig         |   7 --
 crypto/Makefile        |   1 -
 crypto/ghash-generic.c | 162 -----------------------------------------
 crypto/tcrypt.c        |   9 ---
 crypto/testmgr.c       |   6 --
 crypto/testmgr.h       | 109 ---------------------------
 6 files changed, 294 deletions(-)
 delete mode 100644 crypto/ghash-generic.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 13ccf5ac2f1a..efb482ea192d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -886,17 +886,10 @@ config CRYPTO_CMAC
 	select CRYPTO_MANAGER
 	help
 	  CMAC (Cipher-based Message Authentication Code) authentication
 	  mode (NIST SP800-38B and IETF RFC4493)
 
-config CRYPTO_GHASH
-	tristate "GHASH"
-	select CRYPTO_HASH
-	select CRYPTO_LIB_GF128MUL
-	help
-	  GCM GHASH function (NIST SP800-38D)
-
 config CRYPTO_HMAC
 	tristate "HMAC (Keyed-Hash MAC)"
 	select CRYPTO_HASH
 	select CRYPTO_MANAGER
 	help
diff --git a/crypto/Makefile b/crypto/Makefile
index 04e269117589..17f4fca9b9e5 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -169,11 +169,10 @@ CFLAGS_jitterentropy.o = -O0
 KASAN_SANITIZE_jitterentropy.o = n
 UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
 obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
-obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
 obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
deleted file mode 100644
index e5803c249c12..000000000000
--- a/crypto/ghash-generic.c
+++ /dev/null
@@ -1,162 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * GHASH: hash function for GCM (Galois/Counter Mode).
- *
- * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
- * Copyright (c) 2009 Intel Corp.
- *   Author: Huang Ying <ying.huang@intel.com>
- */
-
-/*
- * GHASH is a keyed hash function used in GCM authentication tag generation.
- *
- * The original GCM paper [1] presents GHASH as a function GHASH(H, A, C) which
- * takes a 16-byte hash key H, additional authenticated data A, and a ciphertext
- * C.  It formats A and C into a single byte string X, interprets X as a
- * polynomial over GF(2^128), and evaluates this polynomial at the point H.
- *
- * However, the NIST standard for GCM [2] presents GHASH as GHASH(H, X) where X
- * is the already-formatted byte string containing both A and C.
- *
- * "ghash" in the Linux crypto API uses the 'X' (pre-formatted) convention,
- * since the API supports only a single data stream per hash.  Thus, the
- * formatting of 'A' and 'C' is done in the "gcm" template, not in "ghash".
- *
- * The reason "ghash" is separate from "gcm" is to allow "gcm" to use an
- * accelerated "ghash" when a standalone accelerated "gcm(aes)" is unavailable.
- * It is generally inappropriate to use "ghash" for other purposes, since it is
- * an "ε-almost-XOR-universal hash function", not a cryptographic hash function.
- * It can only be used securely in crypto modes specially designed to use it.
- *
- * [1] The Galois/Counter Mode of Operation (GCM)
- *     (http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.694.695&rep=rep1&type=pdf)
- * [2] Recommendation for Block Cipher Modes of Operation: Galois/Counter Mode (GCM) and GMAC
- *     (https://csrc.nist.gov/publications/detail/sp/800-38d/final)
- */
-
-#include <crypto/gf128mul.h>
-#include <crypto/ghash.h>
-#include <crypto/internal/hash.h>
-#include <crypto/utils.h>
-#include <linux/err.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/string.h>
-
-static int ghash_init(struct shash_desc *desc)
-{
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-
-	memset(dctx, 0, sizeof(*dctx));
-
-	return 0;
-}
-
-static int ghash_setkey(struct crypto_shash *tfm,
-			const u8 *key, unsigned int keylen)
-{
-	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
-	be128 k;
-
-	if (keylen != GHASH_BLOCK_SIZE)
-		return -EINVAL;
-
-	if (ctx->gf128)
-		gf128mul_free_4k(ctx->gf128);
-
-	BUILD_BUG_ON(sizeof(k) != GHASH_BLOCK_SIZE);
-	memcpy(&k, key, GHASH_BLOCK_SIZE); /* avoid violating alignment rules */
-	ctx->gf128 = gf128mul_init_4k_lle(&k);
-	memzero_explicit(&k, GHASH_BLOCK_SIZE);
-
-	if (!ctx->gf128)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static int ghash_update(struct shash_desc *desc,
-			 const u8 *src, unsigned int srclen)
-{
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
-	u8 *dst = dctx->buffer;
-
-	do {
-		crypto_xor(dst, src, GHASH_BLOCK_SIZE);
-		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
-		src += GHASH_BLOCK_SIZE;
-		srclen -= GHASH_BLOCK_SIZE;
-	} while (srclen >= GHASH_BLOCK_SIZE);
-
-	return srclen;
-}
-
-static void ghash_flush(struct shash_desc *desc, const u8 *src,
-			unsigned int len)
-{
-	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	u8 *dst = dctx->buffer;
-
-	if (len) {
-		crypto_xor(dst, src, len);
-		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
-	}
-}
-
-static int ghash_finup(struct shash_desc *desc, const u8 *src,
-		       unsigned int len, u8 *dst)
-{
-	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
-	u8 *buf = dctx->buffer;
-
-	ghash_flush(desc, src, len);
-	memcpy(dst, buf, GHASH_BLOCK_SIZE);
-
-	return 0;
-}
-
-static void ghash_exit_tfm(struct crypto_tfm *tfm)
-{
-	struct ghash_ctx *ctx = crypto_tfm_ctx(tfm);
-	if (ctx->gf128)
-		gf128mul_free_4k(ctx->gf128);
-}
-
-static struct shash_alg ghash_alg = {
-	.digestsize	= GHASH_DIGEST_SIZE,
-	.init		= ghash_init,
-	.update		= ghash_update,
-	.finup		= ghash_finup,
-	.setkey		= ghash_setkey,
-	.descsize	= sizeof(struct ghash_desc_ctx),
-	.base		= {
-		.cra_name		= "ghash",
-		.cra_driver_name	= "ghash-generic",
-		.cra_priority		= 100,
-		.cra_flags		= CRYPTO_AHASH_ALG_BLOCK_ONLY,
-		.cra_blocksize		= GHASH_BLOCK_SIZE,
-		.cra_ctxsize		= sizeof(struct ghash_ctx),
-		.cra_module		= THIS_MODULE,
-		.cra_exit		= ghash_exit_tfm,
-	},
-};
-
-static int __init ghash_mod_init(void)
-{
-	return crypto_register_shash(&ghash_alg);
-}
-
-static void __exit ghash_mod_exit(void)
-{
-	crypto_unregister_shash(&ghash_alg);
-}
-
-module_init(ghash_mod_init);
-module_exit(ghash_mod_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("GHASH hash function");
-MODULE_ALIAS_CRYPTO("ghash");
-MODULE_ALIAS_CRYPTO("ghash-generic");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index aded37546137..1773f5f71351 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1648,14 +1648,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 
 	case 45:
 		ret = min(ret, tcrypt_test("rfc4309(ccm(aes))"));
 		break;
 
-	case 46:
-		ret = min(ret, tcrypt_test("ghash"));
-		break;
-
 	case 48:
 		ret = min(ret, tcrypt_test("sha3-224"));
 		break;
 
 	case 49:
@@ -2249,15 +2245,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		fallthrough;
 	case 317:
 		test_hash_speed("blake2b-512", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
-	case 318:
-		klen = 16;
-		test_hash_speed("ghash", sec, generic_hash_speed_template);
-		if (mode > 300 && mode < 400) break;
-		fallthrough;
 	case 319:
 		test_hash_speed("crc32c", sec, generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
 		fallthrough;
 	case 322:
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0b0ad358e091..dd01f86dd6fe 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4983,16 +4983,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.generic_driver = "gcm_base(ctr(sm4-generic),ghash-lib)",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = __VECS(sm4_gcm_tv_template)
 		}
-	}, {
-		.alg = "ghash",
-		.test = alg_test_hash,
-		.suite = {
-			.hash = __VECS(ghash_tv_template)
-		}
 	}, {
 		.alg = "hctr2(aes)",
 		.generic_driver = "hctr2_base(xctr(aes-lib),polyval-lib)",
 		.test = alg_test_skcipher,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 1c69c11c0cdb..a3274abacfde 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -6181,119 +6181,10 @@ static const struct hash_testvec wp256_tv_template[] = {
 			  "\x8A\x7A\x5A\x52\xDE\xEE\x65\x62"
 			  "\x07\xC5\x62\xF9\x88\xE9\x5C\x69",
 	},
 };
 
-static const struct hash_testvec ghash_tv_template[] =
-{
-	{
-		.key	= "\xdf\xa6\xbf\x4d\xed\x81\xdb\x03"
-			  "\xff\xca\xff\x95\xf8\x30\xf0\x61",
-		.ksize	= 16,
-		.plaintext = "\x95\x2b\x2a\x56\xa5\x60\x04a\xc0"
-			     "\xb3\x2b\x66\x56\xa0\x5b\x40\xb6",
-		.psize	= 16,
-		.digest	= "\xda\x53\xeb\x0a\xd2\xc5\x5b\xb6"
-			  "\x4f\xc4\x80\x2c\xc3\xfe\xda\x60",
-	}, {
-		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
-			  "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
-		.ksize	= 16,
-		.plaintext = "what do ya want for nothing?",
-		.psize	= 28,
-		.digest	= "\x3e\x1f\x5c\x4d\x65\xf0\xef\xce"
-			  "\x0d\x61\x06\x27\x66\x51\xd5\xe2",
-	}, {
-		.key	= "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
-			  "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa",
-		.ksize	= 16,
-		.plaintext = "\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
-			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
-			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd"
-			"\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd\xdd",
-		.psize	= 50,
-		.digest	= "\xfb\x49\x8a\x36\xe1\x96\xe1\x96"
-			  "\xe1\x96\xe1\x96\xe1\x96\xe1\x96",
-	}, {
-		.key	= "\xda\x53\xeb\x0a\xd2\xc5\x5b\xb6"
-			  "\x4f\xc4\x80\x2c\xc3\xfe\xda\x60",
-		.ksize	= 16,
-		.plaintext = "\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
-			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
-			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd"
-			"\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd\xcd",
-		.psize	= 50,
-		.digest	= "\x2b\x5c\x0c\x7f\x52\xd1\x60\xc2"
-			  "\x49\xed\x6e\x32\x7a\xa9\xbe\x08",
-	}, {
-		.key	= "\x95\x2b\x2a\x56\xa5\x60\x04a\xc0"
-			  "\xb3\x2b\x66\x56\xa0\x5b\x40\xb6",
-		.ksize	= 16,
-		.plaintext = "Test With Truncation",
-		.psize	= 20,
-		.digest	= "\xf8\x94\x87\x2a\x4b\x63\x99\x28"
-			  "\x23\xf7\x93\xf7\x19\xf5\x96\xd9",
-	}, {
-		.key	= "\x0a\x1b\x2c\x3d\x4e\x5f\x64\x71"
-			"\x82\x93\xa4\xb5\xc6\xd7\xe8\xf9",
-		.ksize	= 16,
-		.plaintext = "\x56\x6f\x72\x20\x6c\x61\x75\x74"
-			"\x65\x72\x20\x4c\x61\x75\x73\x63"
-			"\x68\x65\x6e\x20\x75\x6e\x64\x20"
-			"\x53\x74\x61\x75\x6e\x65\x6e\x20"
-			"\x73\x65\x69\x20\x73\x74\x69\x6c"
-			"\x6c\x2c\x0a\x64\x75\x20\x6d\x65"
-			"\x69\x6e\x20\x74\x69\x65\x66\x74"
-			"\x69\x65\x66\x65\x73\x20\x4c\x65"
-			"\x62\x65\x6e\x3b\x0a\x64\x61\x73"
-			"\x73\x20\x64\x75\x20\x77\x65\x69"
-			"\xc3\x9f\x74\x20\x77\x61\x73\x20"
-			"\x64\x65\x72\x20\x57\x69\x6e\x64"
-			"\x20\x64\x69\x72\x20\x77\x69\x6c"
-			"\x6c\x2c\x0a\x65\x68\x20\x6e\x6f"
-			"\x63\x68\x20\x64\x69\x65\x20\x42"
-			"\x69\x72\x6b\x65\x6e\x20\x62\x65"
-			"\x62\x65\x6e\x2e\x0a\x0a\x55\x6e"
-			"\x64\x20\x77\x65\x6e\x6e\x20\x64"
-			"\x69\x72\x20\x65\x69\x6e\x6d\x61"
-			"\x6c\x20\x64\x61\x73\x20\x53\x63"
-			"\x68\x77\x65\x69\x67\x65\x6e\x20"
-			"\x73\x70\x72\x61\x63\x68\x2c\x0a"
-			"\x6c\x61\x73\x73\x20\x64\x65\x69"
-			"\x6e\x65\x20\x53\x69\x6e\x6e\x65"
-			"\x20\x62\x65\x73\x69\x65\x67\x65"
-			"\x6e\x2e\x0a\x4a\x65\x64\x65\x6d"
-			"\x20\x48\x61\x75\x63\x68\x65\x20"
-			"\x67\x69\x62\x74\x20\x64\x69\x63"
-			"\x68\x2c\x20\x67\x69\x62\x20\x6e"
-			"\x61\x63\x68\x2c\x0a\x65\x72\x20"
-			"\x77\x69\x72\x64\x20\x64\x69\x63"
-			"\x68\x20\x6c\x69\x65\x62\x65\x6e"
-			"\x20\x75\x6e\x64\x20\x77\x69\x65"
-			"\x67\x65\x6e\x2e\x0a\x0a\x55\x6e"
-			"\x64\x20\x64\x61\x6e\x6e\x20\x6d"
-			"\x65\x69\x6e\x65\x20\x53\x65\x65"
-			"\x6c\x65\x20\x73\x65\x69\x74\x20"
-			"\x77\x65\x69\x74\x2c\x20\x73\x65"
-			"\x69\x20\x77\x65\x69\x74\x2c\x0a"
-			"\x64\x61\x73\x73\x20\x64\x69\x72"
-			"\x20\x64\x61\x73\x20\x4c\x65\x62"
-			"\x65\x6e\x20\x67\x65\x6c\x69\x6e"
-			"\x67\x65\x2c\x0a\x62\x72\x65\x69"
-			"\x74\x65\x20\x64\x69\x63\x68\x20"
-			"\x77\x69\x65\x20\x65\x69\x6e\x20"
-			"\x46\x65\x69\x65\x72\x6b\x6c\x65"
-			"\x69\x64\x0a\xc3\xbc\x62\x65\x72"
-			"\x20\x64\x69\x65\x20\x73\x69\x6e"
-			"\x6e\x65\x6e\x64\x65\x6e\x20\x44"
-			"\x69\x6e\x67\x65\x2e\x2e\x2e\x0a",
-		.psize	= 400,
-		.digest = "\xad\xb1\xc1\xe9\x56\x70\x31\x1d"
-			"\xbb\x5b\xdf\x5e\x70\x72\x1a\x57",
-	},
-};
-
 /*
  * HMAC-MD5 test vectors from RFC2202
  * (These need to be fixed to not use strlen).
  */
 static const struct hash_testvec hmac_md5_tv_template[] =
-- 
2.53.0

