Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6743CF1ED
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356568; cv=none; b=WYhpZTC8pPEbWdYUFjnuBTiaZ1z8W9GLFkiIr5KOnS89rDlKQdm/UL3z6GuXr6VzvbtNiopr/AuS6lJM6XTBoGkKkeZgAMn8evlWhm8NZhVbWZrM+BN7JNuvlkRW7K0PUSj2fZxlF9RqY8+jxJQm6cXMWRekplDCmq8xdCT8oy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356568; c=relaxed/simple;
	bh=WZCupfKV/z5IK5k3xb2pc9fy00k47U/Dc+jXkg2D6Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6iQRwK49+EIJAm15WzHpHJ5oeuuaqWwYXdb0xYOLgslWar5dGuS2t+WHOGHn8GHGvWA75uqUPfbR3XpXfaRBaqcjGa+wagNQ4MEScZt3l+AsKyj97scTRtNNAA9wgAd7LXP4tjwbbdnnxeOEqRfMGWVeEjmt6811TSKpiFNRMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3TNqcrF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3TNqcrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C757A1F000C5;
	Sun, 18 Oct 2026 20:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356567;
	bh=HIAjcDeZmvlp91PdTCJa/UrU1Ym4miy9TZUX7Cj+aVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3TNqcrFoxiOwdZ0AV8JMqqMf4K/YYU3OVdacuqOi6gXIYpSunbLlRUc4IFk+wIma
	 9CTodbi84E5H9xujV1B+0HE7APqOmtHVsnEGymU393Xu/hu959wRkZH9dlkF393WNt
	 O5rCc414RWhBbCzP0U3LBPdHtvYDuU3x0+HLhBkhCPlYdsyNSBx4bXTrmTkmDWUew+
	 deqUb4SqQkPLs49iqhCXyLKhkxdvmJa9UHcekWfwAxZHMR44UFONFS4s2k4Z1CVoi/
	 xekEi/K3vIc2Palhh1xyAaGgENLCB+mjXXqxPyggxegLiJDAOxIjjhYGu0PD6fkU73
	 2y9wN/26KjC6g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 05/14] crypto: drbg - Use jitterentropy library API
Date: Sun, 18 Oct 2026 13:46:09 -0700
Message-ID: <20261018204618.104876-6-ebiggers@kernel.org>
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

Now that the jitterentropy RNG is accessible via a regular set of
functions, make drbg.c just use those instead of crypto_rng.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/drbg.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index e057b00e74f5b..6015822129edc 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -96,6 +96,7 @@
 #include <linux/mutex.h>
 #include <linux/string_choices.h>
 #include <linux/unaligned.h>
+#include "jitterentropy-kcapi.h"
 
 /* State length in bytes */
 #define DRBG_STATE_LEN		SHA512_DIGEST_SIZE
@@ -130,7 +131,7 @@ struct drbg_state {
 	/* Number of RNG requests since last reseed -- 10.1.2.1 1c */
 	size_t reseed_ctr;
 	bool instantiated;
-	struct crypto_rng *jent;
+	struct jitterentropy *jent;
 	const u8 *test_entropy;
 	size_t test_entropylen;
 };
@@ -272,9 +273,9 @@ static int drbg_seed(struct drbg_state *drbg, const u8 *pers, size_t pers_len,
 			 * Get seed from Jitter RNG, failures are
 			 * fatal only in FIPS mode.
 			 */
-			ret = crypto_rng_get_bytes(drbg->jent,
-						   &entropy_buf[entropylen],
-						   entropylen);
+			ret = crypto_jent_get_bytes(drbg->jent,
+						    &entropy_buf[entropylen],
+						    entropylen);
 			if (fips_enabled && ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
 
@@ -454,7 +455,7 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 
 	/* Allocate jitterentropy_rng if not in test mode. */
 	if (drbg->test_entropylen == 0) {
-		drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
+		drbg->jent = crypto_jent_alloc();
 		if (IS_ERR(drbg->jent)) {
 			ret = PTR_ERR(drbg->jent);
 			drbg->jent = NULL;
@@ -466,7 +467,7 @@ static int drbg_kcapi_seed(struct crypto_rng *tfm,
 
 	ret = drbg_seed(drbg, pers, pers_len, /* reseed= */ false);
 	if (ret) {
-		crypto_free_rng(drbg->jent);
+		crypto_jent_free(drbg->jent);
 		drbg->jent = NULL;
 		return ret;
 	}
@@ -512,7 +513,7 @@ static void drbg_kcapi_exit(struct crypto_tfm *tfm)
 {
 	struct drbg_state *drbg = crypto_tfm_ctx(tfm);
 
-	crypto_free_rng(drbg->jent);
+	crypto_jent_free(drbg->jent);
 	memzero_explicit(drbg, sizeof(*drbg));
 }
 
@@ -615,3 +616,4 @@ MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG)");
 MODULE_ALIAS_CRYPTO("stdrng");
 MODULE_ALIAS_CRYPTO("drbg_nopr_hmac_sha512");
+MODULE_IMPORT_NS("CRYPTO_INTERNAL"); /* for jitterentropy */
-- 
2.56.0

