Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835824A2A5E
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356572; cv=none; b=dhT9aQcMCK9syR1+pZ2xgddNF+XcTu0wJu/dBzdAXCFR6HUAjRxGjljG0EgJyg6u/6LpMe8xl0+Xd7QdMhnFK3uG0tvL1pp2gjl1xpZJ6OSxCOBljmnCU6K9Y8Ge70Fs08CElLP+lRZdXxuPSDJ8wFPUlgKW+RESa8bSdcv0mXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356572; c=relaxed/simple;
	bh=bmUw6/twq6V9MHND/iqOKbNe+crBtd1YDW4/iazaa9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JisA7jeaFAz3BoKCXvapkHuwEeomjVoAJzkIuMcBlL7v91Wg5LfmQgghON6d36BtizpmWsbOTp4hAr+6pYtiRyfZh83oig//ywaklsyufqxJDw05WlLybZ2YxyrfRMHKE5cfptWRvnwR1oEVb9QX61KhCiTyOxPKH5UWBdjAKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ir6mj2n/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ir6mj2n/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF151F000C6;
	Sun, 18 Oct 2026 20:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356569;
	bh=Y++XZG1o+goL6xKl2iLDpJ+kYeIvZKmczUnWWIyI3qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ir6mj2n/FAZR1cEevrLkNhjrbm8rO8Scs6Gt2ZXbo0aNQp3s32Ekq2KT09t3RXRMY
	 RdQtCm8wBHyqXjlAk3eRqzbQaq02JSQP7mh2WLi7+eG5vRzKmfRuhSGCrmE6Vb5FWa
	 M5/9fEAH6QYMw1rVIv0zekhy4c6Wg1xbZMmGpAXm4mopHhgsK3UROFSBdaskvDb0qj
	 mEuN84gFskuY77djXHHYBm3Kdyb+aNa9H5Qat/cFFKoZEd+qKTg71RkJPvhit9aizD
	 HFRvDtWsl/jMWq2GEck55EvaYGmQrF8rXDIHxAbqObFCWfRJkbvIpOgKR7ITXWnewc
	 /xrN/6p1nz20A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 10/14] crypto: drbg - Remove crypto_rng support
Date: Sun, 18 Oct 2026 13:46:14 -0700
Message-ID: <20261018204618.104876-11-ebiggers@kernel.org>
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

Now that drbg is used only via its library API instead of crypto_rng,
remove its obsolete crypto_rng support.  Also remove the associated
self-test, which has been superseded by the built-in self-test.

Note: /proc/crypto will no longer list the DRBG algorithm.  However,
this should be fine.  Its existence is implied by either fips=1 or the
support for the "rng" algorithm type in AF_ALG.  When fips=1 there is
also the "DRBG: self-tests passed" log message, which makes it clear
that the DRBG code is built into the kernel and is tested.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig   |   2 -
 crypto/drbg.c    | 150 +-------------------------------
 crypto/testmgr.c |  98 ---------------------
 crypto/testmgr.h | 218 -----------------------------------------------
 4 files changed, 2 insertions(+), 466 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c41c2f3475d0b..ed8612dcc5212 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -151,7 +151,6 @@ config CRYPTO_MANAGER2
 	select CRYPTO_SIG2 if CRYPTO_SELFTESTS
 	select CRYPTO_HASH2 if CRYPTO_SELFTESTS
 	select CRYPTO_KPP2 if CRYPTO_SELFTESTS
-	select CRYPTO_RNG2 if CRYPTO_SELFTESTS
 	select CRYPTO_SKCIPHER2 if CRYPTO_SELFTESTS
 
 config CRYPTO_USER
@@ -1109,7 +1108,6 @@ config CRYPTO_DRBG
 	tristate "NIST SP800-90A DRBG (Deterministic Random Bit Generator)"
 	select CRYPTO_JITTERENTROPY
 	select CRYPTO_LIB_SHA512
-	select CRYPTO_RNG
 	help
 	  DRBG (Deterministic Random Bit Generator) (NIST SP800-90A)
 
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 0f36aa45bfaca..831178f7bc001 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -87,7 +87,7 @@
  * Just mix both scenarios above.
  */
 
-#include <crypto/internal/rng.h>
+#include <crypto/rng.h>
 #include <crypto/sha2.h>
 #include <linux/fips.h>
 #include <linux/kernel.h>
@@ -95,8 +95,6 @@
 #include <linux/mutex.h>
 #include <linux/once.h>
 #include <linux/slab.h>
-#include <linux/string_choices.h>
-#include <linux/unaligned.h>
 #include "drbg.h"
 #include "drbg-testvecs.h"
 #include "jitterentropy-kcapi.h"
@@ -405,121 +403,6 @@ static int drbg_generate(struct drbg_state *drbg, u8 *out, size_t outlen,
 	return 0;
 }
 
-/***************************************************************
- * Kernel crypto API interface to DRBG
- ***************************************************************/
-
-static int drbg_kcapi_init(struct crypto_tfm *tfm)
-{
-	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
-
-	mutex_init(&drbg->drbg_mutex);
-
-	return 0;
-}
-
-/* Set test entropy in the DRBG. */
-static void drbg_kcapi_set_entropy(struct crypto_rng *tfm,
-				   const u8 *data, unsigned int len)
-{
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-
-	mutex_lock(&drbg->drbg_mutex);
-	drbg->test_entropy = data;
-	drbg->test_entropylen = len;
-	mutex_unlock(&drbg->drbg_mutex);
-}
-
-/* Seed (i.e. instantiate) or re-seed the DRBG. */
-static int drbg_kcapi_seed(struct crypto_rng *tfm,
-			   const u8 *pers, unsigned int pers_len)
-{
-	static const u8 initial_key[DRBG_STATE_LEN]; /* all zeroes */
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-	int ret;
-
-	pr_devel("DRBG: Initializing DRBG\n");
-	guard(mutex)(&drbg->drbg_mutex);
-
-	if (drbg->instantiated)
-		return drbg_seed(drbg, pers, pers_len, /* reseed= */ true);
-
-	/* 9.1 step 1 is implicit with the selected DRBG type */
-
-	/*
-	 * 9.1 step 2 is implicit, as this implementation doesn't support
-	 * prediction resistance
-	 */
-
-	/* 9.1 step 4 is implicit in DRBG_SEC_STRENGTH */
-
-	memset(drbg->V, 1, DRBG_STATE_LEN);
-	hmac_sha512_preparekey(&drbg->key, initial_key, DRBG_STATE_LEN);
-
-	/* Allocate jitterentropy_rng if not in test mode. */
-	if (drbg->test_entropylen == 0) {
-		drbg->jent = crypto_jent_alloc();
-		if (IS_ERR(drbg->jent)) {
-			ret = PTR_ERR(drbg->jent);
-			drbg->jent = NULL;
-			if (fips_enabled)
-				return ret;
-			pr_info("DRBG: Continuing without Jitter RNG\n");
-		}
-	}
-
-	ret = drbg_seed(drbg, pers, pers_len, /* reseed= */ false);
-	if (ret) {
-		crypto_jent_free(drbg->jent);
-		drbg->jent = NULL;
-		return ret;
-	}
-	drbg->instantiated = true;
-	return 0;
-}
-
-/*
- * Generate random numbers invoked by the kernel crypto API:
- *
- * src is additional input supplied to the RNG.
- * slen is the length of src.
- * dst is the output buffer where random data is to be stored.
- * dlen is the length of dst.
- */
-static int drbg_kcapi_generate(struct crypto_rng *tfm,
-			       const u8 *src, unsigned int slen,
-			       u8 *dst, unsigned int dlen)
-{
-	struct drbg_state *drbg = crypto_rng_ctx(tfm);
-
-	/*
-	 * Break the request into multiple requests if needed, to avoid
-	 * exceeding the maximum request length of the core algorithm.
-	 */
-	do {
-		unsigned int n = min(dlen, DRBG_MAX_REQUEST_BYTES);
-		int err;
-
-		mutex_lock(&drbg->drbg_mutex);
-		err = drbg_generate(drbg, dst, n, src, slen);
-		mutex_unlock(&drbg->drbg_mutex);
-		if (err < 0)
-			return err;
-		dst += n;
-		dlen -= n;
-	} while (dlen);
-	return 0;
-}
-
-/* Uninstantiate the DRBG. */
-static void drbg_kcapi_exit(struct crypto_tfm *tfm)
-{
-	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
-
-	crypto_jent_free(drbg->jent);
-	memzero_explicit(drbg, sizeof(*drbg));
-}
-
 /***************************************************************
  * Public API
  ***************************************************************/
@@ -751,19 +634,6 @@ static void drbg_healthcheck_sanity(void)
 	kfree_sensitive(drbg);
 }
 
-static struct rng_alg drbg_alg = {
-	.base.cra_name		= "stdrng",
-	.base.cra_driver_name	= "drbg_nopr_hmac_sha512",
-	.base.cra_priority	= 201,
-	.base.cra_ctxsize	= sizeof(struct drbg_state),
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_init		= drbg_kcapi_init,
-	.set_ent		= drbg_kcapi_set_entropy,
-	.seed			= drbg_kcapi_seed,
-	.generate		= drbg_kcapi_generate,
-	.base.cra_exit		= drbg_kcapi_exit,
-};
-
 DEFINE_FREE(crypto_drbg_free, struct drbg_state *, crypto_drbg_free(_T))
 
 static int drbg_selftest_one_vec(const struct drbg_testvec *test)
@@ -855,25 +725,11 @@ static int drbg_selftest(void)
 
 static int __init drbg_init(void)
 {
-	int err = drbg_selftest();
-
-	if (err)
-		return err;
-
-	/*
-	 * In FIPS mode, boost the algorithm priority to ensure that when users
-	 * request "stdrng", they really get the algorithm from here.
-	 */
-	if (fips_enabled)
-		drbg_alg.base.cra_priority += 2000;
-
-	return crypto_register_rng(&drbg_alg);
+	return drbg_selftest();
 }
 
 static void __exit drbg_exit(void)
 {
-	crypto_unregister_rng(&drbg_alg);
-
 	/*
 	 * Note there's no need to call crypto_del_default_rng() from here, as
 	 * it can exist only when this file is built-in.
@@ -885,6 +741,4 @@ module_exit(drbg_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG)");
-MODULE_ALIAS_CRYPTO("stdrng");
-MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
 MODULE_IMPORT_NS("CRYPTO_INTERNAL"); /* for jitterentropy */
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 9419d61d06027..4abb18bc2fa79 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -33,7 +33,6 @@
 #include <crypto/acompress.h>
 #include <crypto/sig.h>
 #include <crypto/internal/cipher.h>
-#include <crypto/internal/rng.h>
 #include <crypto/internal/simd.h>
 
 #include "internal.h"
@@ -116,11 +115,6 @@ struct hash_test_suite {
 	unsigned int count;
 };
 
-struct drbg_test_suite {
-	const struct drbg_testvec *vecs;
-	unsigned int count;
-};
-
 struct akcipher_test_suite {
 	const struct akcipher_testvec *vecs;
 	unsigned int count;
@@ -148,7 +142,6 @@ struct alg_test_desc {
 		struct cipher_test_suite cipher;
 		struct comp_test_suite comp;
 		struct hash_test_suite hash;
-		struct drbg_test_suite drbg;
 		struct akcipher_test_suite akcipher;
 		struct sig_test_suite sig;
 		struct kpp_test_suite kpp;
@@ -3481,90 +3474,6 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 	return err;
 }
 
-static int drbg_cavs_test(const struct drbg_testvec *test, const char *driver,
-			  u32 type, u32 mask)
-{
-	int ret = -EAGAIN;
-	struct crypto_rng *drng;
-	unsigned char *buf = kzalloc(test->expectedlen, GFP_KERNEL);
-
-	if (!buf)
-		return -ENOMEM;
-
-	drng = crypto_alloc_rng(driver, type, mask);
-	if (IS_ERR(drng)) {
-		kfree_sensitive(buf);
-		if (PTR_ERR(drng) == -ENOENT)
-			return 0;
-		printk(KERN_ERR "alg: drbg: could not allocate DRNG handle for "
-		       "%s\n", driver);
-		return PTR_ERR(drng);
-	}
-
-	crypto_rng_set_entropy(drng, test->entropy, test->entropylen);
-	ret = crypto_rng_reset(drng, test->pers, test->perslen);
-	if (ret) {
-		printk(KERN_ERR "alg: drbg: Failed to instantiate rng\n");
-		goto outbuf;
-	}
-
-	if (test->ent_reseed_len) {
-		crypto_rng_set_entropy(drng, test->ent_reseed,
-				       test->ent_reseed_len);
-		ret = crypto_rng_reset(drng, test->addtl_reseed,
-				       test->addtl_reseed_len);
-		if (ret) {
-			printk(KERN_ERR "alg: drbg: Failed to reseed rng\n");
-			goto outbuf;
-		}
-	}
-
-	ret = crypto_rng_generate(drng, test->addtla, test->addtllen,
-				  buf, test->expectedlen);
-	if (ret < 0) {
-		printk(KERN_ERR "alg: drbg: could not obtain random data for "
-		       "driver %s\n", driver);
-		goto outbuf;
-	}
-
-	ret = crypto_rng_generate(drng, test->addtlb, test->addtllen,
-				  buf, test->expectedlen);
-	if (ret < 0) {
-		printk(KERN_ERR "alg: drbg: could not obtain random data for "
-		       "driver %s\n", driver);
-		goto outbuf;
-	}
-
-	ret = memcmp(test->expected, buf, test->expectedlen);
-
-outbuf:
-	crypto_free_rng(drng);
-	kfree_sensitive(buf);
-	return ret;
-}
-
-
-static int alg_test_drbg(const struct alg_test_desc *desc, const char *driver,
-			 u32 type, u32 mask)
-{
-	int err = 0;
-	int i = 0;
-	const struct drbg_testvec *template = desc->suite.drbg.vecs;
-	unsigned int tcount = desc->suite.drbg.count;
-
-	for (i = 0; i < tcount; i++) {
-		err = drbg_cavs_test(&template[i], driver, type, mask);
-		if (err) {
-			printk(KERN_ERR "alg: drbg: Test %d failed for %s\n",
-			       i, driver);
-			err = -EINVAL;
-			break;
-		}
-	}
-	return err;
-
-}
-
 static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 		       const char *alg)
 {
@@ -4644,13 +4553,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "digest_null",
 		.test = alg_test_null,
-	}, {
-		.alg = "drbg_nopr_hmac_sha512",
-		.test = alg_test_drbg,
-		.fips_allowed = 1,
-		.suite = {
-			.drbg = __VECS(drbg_nopr_hmac_sha512_tv_template)
-		}
 	}, {
 		.alg = "ecb(aes)",
 		.generic_driver = "ecb(aes-lib)",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 0ee15a8fae27b..0e196ebc933ab 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -119,29 +119,6 @@ struct aead_testvec {
 	int crypt_error;
 };
 
-struct drbg_testvec {
-	/* Instantiate */
-	const unsigned char *entropy;
-	size_t entropylen;
-	const unsigned char *pers;
-	size_t perslen;
-
-	/* Reseed (optional) */
-	const unsigned char *ent_reseed;
-	size_t ent_reseed_len;
-	const unsigned char *addtl_reseed;
-	size_t addtl_reseed_len;
-
-	/* Generate (twice) */
-	const unsigned char *addtla;
-	const unsigned char *addtlb;
-	size_t addtllen;
-
-	/* Expected output from last call to Generate */
-	const unsigned char *expected;
-	size_t expectedlen;
-};
-
 struct akcipher_testvec {
 	const unsigned char *key;
 	const unsigned char *m;
@@ -23755,201 +23732,6 @@ static const struct aead_testvec aegis128_tv_template[] = {
 	},
 };
 
-static const struct drbg_testvec drbg_nopr_hmac_sha512_tv_template[] = {
-	/*
-	 * Borrowed from the first applicable test vector from ACVP:
-	 * https://github.com/usnistgov/ACVP-Server/blob/v1.1.0.33/gen-val/json-files/hmacDRBG-1.0/prompt.json#L4596
-	 * https://github.com/usnistgov/ACVP-Server/blob/v1.1.0.33/gen-val/json-files/hmacDRBG-1.0/expectedResults.json#L986
-	 */
-	{
-		/* .entropy = ACVP entropyInput || nonce */
-		.entropy = "\x47\x28\x33\x05\x82\xE8\xA7\x58\x05\xBD\x07\x9E"
-			   "\xDB\x59\x87\x08\x3B\x82\x40\x70\xA1\xB7\x33\x4F"
-			   "\x0F\x53\xBE\xF6\x98\x75\xFA\x21\x00\x04\xBC\x58"
-			   "\x9B\xB1\xB3\xBC\x2A\xF6\xA4\x2A\xE1\xB3\x65\x24"
-			   "\xA8\xEE\x56\x70\x5E\x28\x06\x04\x80\xCE\xB7\x36"
-			   "\xA4\xD1\x4E\xAA\xE7\xE8\x51\x40\x7D\x30\xF7\x91"
-			   "\xF2\x9E\x98\xA7\xBB\xB3\x1D\xC6\x8A\x62\xC7\xE7"
-			   "\x1F\xE1\x0A\x52\x45\x39\x88\x92\x43\xA6\x5B\xC3"
-			   "\x9D\x60\xDE\xFE\x79\xEF\x87\x6F\xD5\x76\x51\x69"
-			   "\x7B\x4C\x3D\x08\x60\xFA\xDC\x00\x94\xEC\x0A\xC5"
-			   "\xE7\xCB\x30\x05\x9F\xCC\x07\x44\x07\x14\xF4\xF9"
-			   "\xBC\x7D\xC0\x66\x63\x5B\xD3\x2A\xA7\xF2\x1D\x75"
-			   "\x3F\x28\x5F\x4A\xEB\x63\xD7\x92\x5A\x9A\x7C\x3A"
-			   "\x56\xEA\xCB\xA9\xA0\xF9\x5B\x99\xC2\x7D\x31\xBF"
-			   "\x44\xC7\x64\x6B\x7E\x64\x60\x64\x05\x86\xF0\x6B"
-			   "\x76\xA7\x3E\x63\xAD\xB6\x76\xED\x3D\x05\x2E\xC7"
-			   "\xC7\x52\x8F\x07\x56\x23\xFC\x2F\x93\xD5\xF2\x29"
-			   "\xC6\x84\x48\xD1\x88\xB9\x3F\x84\xB2\x93\xFC\x2F"
-			   "\x00\xB1\xBC\xBE\xAC\xC4\x94\x36\xF1\x2B\xF0\xC7"
-			   "\x36\xE8\x1D\x45\x0A\xA2\xFE\x72\xD7\x3E\x15\x6A"
-			   "\x74\x23\xB2\xD1\x3C\x20\xF2\xB7\x19\xC5\xF0\x74"
-			   "\x69\x06\xD1\x92\x47\xC9\x68\xDC\xEE\xBC\xF4\x3A"
-			   "\x8B\x7C\xA4\xA4\x4A\x15\xF4\xF0\x26\x26\xC5\x7D"
-			   "\x57\xDC\x00\x59\x07\xDF\x84\x2A\x23\xA9\xC1\xAF"
-			   "\x47\x49\x88\xCC\x2F\x3B\x90\x39\xA0\x09\xAE\x3C"
-			   "\x79\xF9\x97\x9D\xEF\x13\x1D\x2B\xB6\x18\xDB\xCF"
-			   "\x95\x98\x17\x7F\xF6\x95\x44\x3A\x40\x90\x63\x16"
-			   "\x70\x38\x22\xC5\xD8\xE4\x57\xA0\x8E\x51\x6B\xED"
-			   "\x03\x18\xC6\x74\xFA\xCA\xF2\xD5\xB2\x5A\x0C\x02"
-			   "\x48\x9F\x70\x0B\x1C\x0A\xD1\xD6\x4F\x3F\x70\x3C"
-			   "\x1A\x62\x29\x63\xD0\x92\x76\x30\x7C\xB9\x54\xEC"
-			   "\xF6\x92\xA3\x11\x66\xB2\x56\xE0\x75\x3D\x27\x01",
-		.entropylen = 384,
-		.pers = "\x03\x75\x33\x7B\x6B\xE5\x14\xAF\x0E\x43\x33\xCC\xD3"
-			"\xF4\xF0\x8B\x8A\xCC\xFE\x95\xC1\x20\xB9\x56\x3D\x2C"
-			"\x34\xC7\xA1\x4C\xBC\xDC\x0A\x8D\xBE\x68\x28\x89\x2A"
-			"\x92\x10\x05\x4E\xF9\xE2\x51\xF7\x4F\xF4\x48\x76\xC9"
-			"\xCE\xA8\x6D\xC1\xDE\x5C\x05\x95\x77\x24\xB4\x5D\x3D"
-			"\x16\x1D\xCB\x43\xE5\xD3\x01\x96\xCC\x3E\x2E\xE1\x97"
-			"\xB3\x42\xC2\xAB\xEC\x56\xA9\xF9\xF2\x28\x59\x01\x4E"
-			"\xFC\x8A\xC0\x5E\x4E\x33\x30\x91\x96\x93\xBA\xFA\xE1"
-			"\x9F\x20\xC3\xC1\xD1\xC6\xC3\x2C\x59\x8F\x56\xD5\x73"
-			"\xE8\x8D\xCF\xAC\xB1\x85\x3E\xC7\x73\x21\x59\x8D\x0F"
-			"\xF4\xA4\xC4\x0C\xD2\x18\x81\x5F\x3E\x37\xC9\x9F\xD9"
-			"\xDE\x3F\x15\x6F\xAC\x1A\xEC\x5E\x28\xD5\x56\xA2\x65"
-			"\xD2\x7C\x41\xDE\x57\x8C\x60\xAB\xA5\x03\x42\xC8\x3C"
-			"\x70\xC2\xD1\x11\x62\x25\x4E\x17\x58\xBB\x08\x51\x79"
-			"\xE6\xED\xBA\x9A\xA7\x07\xD5\x0E\x89\x43\x31\x4F\x99"
-			"\xEE\xED\xF1\x36\xFA\x1E\xC0\x25\x01\xDA\x19\xC2\x7D"
-			"\x5D\x78\x74\x5C\xC0\x72\x2E\xF1\x7B\x4E\x9C\xDB\xFE"
-			"\x60\x89\x62\x71\x9C\xEA\xD3\xDF\x82\xC7\x8B\xB4\x7B"
-			"\x7B\x7F\x6A\x62\x3C\x57\x76\xA5\x67\x5F\x70\xFB\xE0"
-			"\x1B\x23\x79\x71\xB5\x7C\xEA\x76\x99",
-		.perslen = 256,
-
-		.ent_reseed = "\xE0\x5B\x69\xC5\xF9\xD4\x5A\x1F\xC1\x71\x0C"
-			      "\x37\x6F\xFE\x31\xE0\xEF\x3E\x9B\xD5\x46\x43"
-			      "\xA2\x15\xFA\x86\x75\x1C\x95\x9F\xE6\xD6\x41"
-			      "\x50\x36\x0F\x67\x68\x4A\x72\x32\x85\xB0\xCB"
-			      "\xA4\x0D\x1F\xA2\x43\xCA\x30\xF1\x42\xF8\xC4"
-			      "\x17\x6A\xD1\x2D\x43\x46\x8C\xA5\x72\x3C\xB1"
-			      "\x44\x8E\xA1\x75\xAA\x20\x30\xDD\xCD\x0B\x5A"
-			      "\x0D\xE6\x28\xCA\xBC\xA9\x3B\x11\x23\x88\x85"
-			      "\xDF\xD8\x84\x11\x89\x7A\x4F\x00\x90\x0B\xD8"
-			      "\x8A\x35\xE9\x5F\xEC\x05\x42\x15\xCA\x7E\xA3"
-			      "\xEF\xEF\xE3\xB7\xBE\x96\x8C\x36\x7D\x15\x3C"
-			      "\x7A\x78\x00\x61\xAF\x62\x45\xA7\x4B\xAE\x4A"
-			      "\xFD\xC9\xE0\x89\x53\x36\x71\x8F\x38\xC4\x00"
-			      "\x57\xD9\xE6\xC1\xEC\xBF\xF7\x4B\x3F\x55\xD6"
-			      "\x54\x15\x72\xB2\x23\x76\xD1\x4E\x8E\x7E\xFB"
-			      "\xC8\xD6\xA4\xA4\x7E\x8E\xD8\x76\xD3\xEB\x90"
-			      "\x90\xEB\xB3\x84\x26\x34\x93\x36\xCA\xA9\x12"
-			      "\xD3\x6D\x84\x07\xE1\x0E\xE7\x63\x24\x54\x90"
-			      "\x42\x8C\x6B\xE7\x21\x53\x2D\x16\xE9\x68\xA9"
-			      "\xC2\x9A\x7A\x93\x31\x5E\x35\x72\xE2\x0F\x3D"
-			      "\x55\x41\x8C\xC5\xD1\xBB\xEE\x5F\x3C\x95\x52"
-			      "\x2A\x65\x47\xB6\x84\x6A\x05\x19\xD9\xE7\x68"
-			      "\x15\xFA\x49\xD9\x9D\xFD\x47\x9F\xB9\xA6\xBB"
-			      "\xA8\xD4\x22\x6C\x8B\x59\x47\xEF\xD1\xD0\xBF"
-			      "\xBC\xE4\x53\x31\x2F\xA5\xD4\x2C\x89\xCA\xE5"
-			      "\x29\x64\xF8\x51\x2A\x02\xDE\x31\x0D\x54\x0E"
-			      "\x0E\xB8\x78\xE6\x2A\x3E\x31\xA2\xA4\xCD\x91"
-			      "\x79\xF2\x9B\x04\xA0\xDB\x78\xAC\x0D\xB5\xCA"
-			      "\x60\x4C\x08\x96\xCA\x8A\xE9\x93\x9F\x62\x38"
-			      "\xAE",
-		.ent_reseed_len = 320,
-		.addtl_reseed = "\xD5\x46\x71\x38\x46\xE0\xC1\x27\x2C\xF1\x07"
-				"\xDD\x29\x73\xD7\xF4\x5A\x3A\xE0\x99\x98\x0A"
-				"\xEB\xA5\x9E\x2E\x49\x21\x7B\x18\xC0\xD8\x3D"
-				"\xEE\x49\xF9\x52\x7C\x55\x5E\x5E\x06\xC2\x7E"
-				"\x34\x3A\xA5\xB7\x78\x21\xC1\xB8\x8B\x4E\x07"
-				"\x1F\x3F\xC4\xB4\x9B\x3F\x20\x2D\xEE\x70\x3B"
-				"\x18\xCF\x2B\x50\x15\x1B\xF3\x6C\xE7\x9F\x2A"
-				"\x2B\x69\x53\xCA\x88\x41\xA9\x07\x31\x14\x55"
-				"\xBD\x75\x49\x68\x98\x48\xCA\x46\xA5\xEC\xAA"
-				"\x9D\x8E\x6F\x40\xBA\xCA\xC8\xE9\x9F\xA4\xC5"
-				"\x94\x89\x2C\x4D\xE4\x0A\x66\xD3\xDB\x1A\xD9"
-				"\xA7\x3F\x6B\x0A\xE0\xE4\xDC\x0B\x8B\x64\xBF"
-				"\xB4\x95\xA1\xAE\x92\xA8\x7C\xE2\x4B\xED\xFD"
-				"\xFD\xE0\x54\x48\x7C\x25\xD6\xD1\x0A\xAB\x5E"
-				"\x33\x2F\x1D\xD3\x62\x47\xAB\x35\x8C\xA1\xC2"
-				"\x75\xDD\x75\xCA\x09\xE1\x38\xDE\x87\x79\x0C"
-				"\xD7\x5D\x3E\x6D\x28\x8F\x12\x98\x2C\x26\x34"
-				"\x91\x0B\x6B\xB7\x73",
-		.addtl_reseed_len = 192,
-
-		.addtla = "\xC8\xE1\x03\x59\xEA\x9F\xD3\x1F\xCC\xCB\x5A\x3E"
-			  "\x23\xDB\x47\x75\x1B\x3A\x6C\x0B\xED\xE6\xC0\xB6"
-			  "\x4B\x82\x53\x5B\x6D\xEE\x2B\x97\x0F\x59\x07\xA4"
-			  "\xFE\xE2\x26\x4F\xFF\xF7\x46\xAF\x62\xC4\x42\xE8"
-			  "\x06\xFA\x1F\xAA\x66\xF3\xA4\xCF\x85\x02\x3C\x11"
-			  "\xEF\xD2\x16\x13\x7A\xBD\x03\x66\xC3\x4D\x6F\x3A"
-			  "\xE5\xD3\xFF\x92\xB6\x45\xB8\x88\x94\x42\x2E\x84"
-			  "\x02\xA5\x54\x12\xBF\xCB\xF1\x6E\x1C\x0C\x23\xFE"
-			  "\x8A\xFD\xF5\x1A\x4C\xD6\x2A\x34\x7F\x21\x50\xBB"
-			  "\x06\x64\x9A\x77\x70\x59\x1D\x12\xD1\xA0\x10\x70"
-			  "\xD7\x4F\x3C\xEE\x82\xEF\x5B\x35\x8F\x05\xF6\x51"
-			  "\xBC\x28\xE1\xB1\x54\xFF\x25\x12\x16\x2C\x62\xFC"
-			  "\xB9\x74\x5E\x78\x41\xB2\x04\x80\x4E\xB1\x43\x2E"
-			  "\x88\x7F\x34\xA4\x33\x66\xE8\x68\x60\x54\xEB\xCE"
-			  "\xD1\x5F\xC4\xD6\x21\x5E\x22\x1A\x7E\xC5\x6D\xB7"
-			  "\x93\x8F\x9C\x77\x6E\x56\xA5\xA8\xF7\xB2\x10\x19",
-		.addtlb = "\xB8\x1E\x9E\xE2\xB3\xE4\x04\x43\x51\x7B\x96\x32"
-			  "\xAC\x95\xF2\x1E\x5E\x7A\xBF\x68\xE3\x7A\xCE\xE5"
-			  "\x2B\x3B\xB0\x34\x7F\xE1\xB5\x37\x3C\x5B\xD2\x6B"
-			  "\x17\xF6\x18\xAF\x7C\x01\xA5\x84\xFE\x07\x0B\x46"
-			  "\xCC\x96\x61\xAB\xCD\x81\x95\x8A\x8A\xB6\xD8\xCC"
-			  "\x94\x80\x45\xF6\xFF\x95\x3A\xB8\xDC\xBF\xB4\xBF"
-			  "\x26\x8C\xE9\x79\x05\x58\x9C\x03\x08\x45\xB5\xC4"
-			  "\xD8\xB4\xCD\x76\x13\xAE\x2B\xCC\xB5\x3E\x3C\x65"
-			  "\x7A\xAA\xDC\x9B\x0B\x13\x8B\x82\x5A\x39\x60\x9A"
-			  "\xF7\xA8\x38\xB5\x83\x8E\x0B\xD1\xE6\xBF\xA1\xDC"
-			  "\x30\x45\xCC\x67\x41\x0F\xF9\x86\x27\xE0\x22\x3E"
-			  "\x0D\x1F\x92\x13\x16\x9B\x84\x79\x91\xFE\xBC\xDF"
-			  "\x15\x6C\xDC\xAE\xC5\x64\x46\x9C\xE8\xEA\xBB\x9D"
-			  "\x27\xA2\x1E\xDF\xB2\xF2\x98\xB4\x88\x4E\x22\x5F"
-			  "\x3C\xD0\x35\x2C\x5C\x89\xC7\xEC\xE3\xF3\x09\x60"
-			  "\xEF\xAC\x78\xBF\x94\xAA\x8C\x30\x7F\xCF\xE4\x4B",
-		.addtllen = 192,
-
-		.expected = "\x93\xFF\x4F\x4A\xA7\xE0\xFC\x3B\xCF\xCE\x57\xCD"
-			    "\xFD\xE9\x94\x6D\x0D\x45\x7E\xA3\x98\xBB\xE6\x54"
-			    "\x36\xF9\x92\xE6\xBB\xC5\x93\x16\x69\x35\x01\xF0"
-			    "\x5A\xE2\x43\xFC\x73\x7C\xA3\x5C\x5B\x49\x72\x69"
-			    "\x6A\xC4\xB6\xD4\xB2\x48\x27\x72\xCA\xE3\xF3\xB8"
-			    "\xD6\x95\x9F\x39\xC8\xD7\x72\xAF\xC2\x7C\x75\xE5"
-			    "\xA4\xF7\x52\x4F\xDF\x80\x75\xCA\x4B\xFA\x75\x9A"
-			    "\x7A\x8D\x48\x94\x30\x1C\x82\x5E\xD6\x3F\xF1\x78"
-			    "\x84\xAA\x8D\x8B\x4F\x6A\x20\x12\xA2\x65\xC5\x02"
-			    "\x32\xA1\xE4\x6B\x86\x2F\xCF\x92\xCD\x01\x55\xF7"
-			    "\xB8\xAB\xC3\x2C\x42\xC3\xFD\x9B\x59\x2D\x47\x8E"
-			    "\xB6\x8D\xE7\x04\x2E\x67\xD9\x07\x14\xA3\xF2\x74"
-			    "\x79\x9C\xAB\xC6\xD6\x52\x3E\x91\x81\xA4\x3C\x9A"
-			    "\x3E\x10\x1E\xD0\x28\xBC\x1C\x50\xF0\xB6\xEC\x01"
-			    "\xE5\x40\x16\x08\xB5\x58\xE0\xC4\xC2\x9A\xBB\x13"
-			    "\xAB\x10\x4B\x07\x24\x09\xEB\xF9\x5E\xAA\x3E\x3A"
-			    "\x25\x34\x5B\x97\x92\xF9\x46\x8A\x8E\x5A\x06\x9C"
-			    "\x2B\x1C\x8E\x47\x19\xC3\x3B\x14\x8A\xC1\xEB\xF7"
-			    "\xB0\xA2\x05\xE0\x70\x12\x88\x21\xFF\xC0\x35\x6D"
-			    "\xE9\x08\x7E\x11\x6E\xD7\x16\x48\x24\x43\xAF\x33"
-			    "\xA3\x48\x44\x91\xC5\x32\x1D\x87\xF6\x9B\x10\x1C"
-			    "\xA4\x7A\x74\x23\xB3\xFC\xB9\x87\x08\xE6\x9A\xEF"
-			    "\xD5\x93\x82\x17\xD4\x78\xDA\x46\x34\xC2\x61\x8C"
-			    "\xB7\x53\x89\xC4\x8A\xD8\xA0\x2E\xCE\xCA\x24\x16"
-			    "\xF0\x18\x7F\xC3\x12\x3F\xD0\xB1\xEF\x37\x99\xA8"
-			    "\x04\x1F\x76\x50\x81\x08\xCD\x4D\x43\xEF\x64\xB6"
-			    "\x03\x57\xB7\x5F\xDD\xF6\xBA\x34\xE2\x88\xE7\x1F"
-			    "\x62\xA5\xA4\x05\xEB\x1A\xFE\x0B\xFE\x74\x7D\x64"
-			    "\x29\x83\xE8\x0B\x97\x7D\x94\x5B\xF9\x3C\x8E\xC8"
-			    "\x6B\xCD\xAD\x63\x32\x6E\x00\xBF\x8E\x57\xF2\x32"
-			    "\x88\x53\x17\x40\xE3\xF8\xF8\xD9\xFD\xCD\x76\x84"
-			    "\xC6\xFD\xB1\x10\x40\xED\x75\xDD\xBD\x78\x8B\x0A"
-			    "\x61\x1E\xCC\xC4\x4F\x95\xF1\x2F\x8F\x5A\xF0\x12"
-			    "\x00\xCE\x75\xB8\xE9\xAB\x63\xC0\x7A\xF6\x9A\x47"
-			    "\xD2\x3C\xB0\xAD\xAF\x03\xDF\x25\xDD\x0C\x0F\xB6"
-			    "\x29\x09\x0F\x28\x5E\xA8\x67\xBB\xC9\x78\xBE\x12"
-			    "\xD8\xD6\xD0\x98\x82\x29\xA3\x82\xFB\x8E\x1C\x79"
-			    "\x28\x52\x22\x73\x3C\x6F\xB5\x33\xFF\x40\x26\x4C"
-			    "\x30\xE4\xE0\x39\x59\x72\x65\x79\x9F\xB7\x89\x87"
-			    "\x64\xAC\x45\x11\x0D\xDD\xC0\x44\x5E\x0D\xDF\xDB"
-			    "\x91\x42\x5F\x52\x7F\xBB\x66\xEE\x32\x90\x8F\x6F"
-			    "\xF8\xB9\xFE\xEA\x42\xFB\x60\x2B\xE3\xD9\xB2\xD1"
-			    "\x74\x37\x14\xC6\xDA\x68\xE6\x09",
-		.expectedlen = 512,
-	}
-};
-
 /* Cast5 test vectors from RFC 2144 */
 static const struct cipher_testvec cast5_tv_template[] = {
 	{
-- 
2.56.0

