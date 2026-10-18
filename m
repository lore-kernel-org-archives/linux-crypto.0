Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC934D37B8
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356571; cv=none; b=UeX4lKi/GM+dbrtIB36lQQZhJiUvzdhfvp2gn0eYbPxTRt1687GHdY6RLRaJcOL2To/NR8hD306Zxmytou+t90sTOmNXJMlPkmxEGJvA0Mvgmx58aIwHc1twfCCLj/XDw+7vHN6t1qG3Wn3AQKOnrcMQu8qtJ6Uuz6vCYGbWekg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356571; c=relaxed/simple;
	bh=tiUOviZY4QR0fdbro6k0d3Q0lCM+331qxewRCRbMBx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFxpsv+Ssqx/ibyKxtwdTtJFwenCBJsKzWfznjX9iOlwDxBz44hIsl6UincW8TlbfhJGWHSTLschGjFuGaLvoiBSFxxvwbkfOKQfeEtYtoJ3k8kdOFAAOVf92Z8HfkiqqQk+h94jDblf38+JxzXaAOuK5onGv2LesxZwt9S99Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0fN512h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0fN512h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981141F000C5;
	Sun, 18 Oct 2026 20:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356569;
	bh=WXsHFYFPUM2vzThKic0hBxYSMm6YDuUSA/DtewcwjVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0fN512h6SJpG9UGV/plG0hp9bYOHY2FpOHE9gM/HiEu3ODIWsEZF2GwHbr5JfJzP
	 2rkKiAAAS3Rz1v5B5qBaoQlqnx/ZXJjX+HnlTdOKYH5W7blJJwKEAbxkarZXaSynyG
	 TrAYcSBfrYvKZdj/Ay7Uzxq8rllR0XrJ8q2dwEt6mmhmxYcMi1oGEgB5tFJK5etI21
	 iTTvr+zXH+76iNVI5/L01nQAqhxqG9Y3ulzSsHpwD4AYy82lq+7KX+FppPbYCPqZYA
	 jeP+pOPGifS0IU3S/tnPw4tT+bdRdCIAJAEbwg1J8se4Bi0AnfcjVxUXRKUTPjkm/X
	 OoVpeS1r9qV3Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 11/14] crypto: jitterentropy - Remove crypto_rng support
Date: Sun, 18 Oct 2026 13:46:15 -0700
Message-ID: <20261018204618.104876-12-ebiggers@kernel.org>
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

Now that jitterentropy is used only via its library API instead of
crypto_rng, remove its obsolete crypto_rng support.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig               |   1 -
 crypto/jitterentropy-kcapi.c | 106 +----------------------------------
 crypto/testmgr.c             |   4 --
 3 files changed, 1 insertion(+), 110 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ed8612dcc5212..c9d842706b9ff 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1117,7 +1117,6 @@ config CRYPTO_DRBG
 config CRYPTO_JITTERENTROPY
 	tristate "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
 	select CRYPTO_LIB_SHA3
-	select CRYPTO_RNG
 	help
 	  CPU Jitter RNG (Random Number Generator) from the Jitterentropy library
 
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 2786303195950..1311df9882228 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -44,7 +44,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/time.h>
-#include <crypto/internal/rng.h>
 
 #include "jitterentropy.h"
 #include "jitterentropy-kcapi.h"
@@ -302,117 +301,15 @@ void crypto_jent_free(struct jitterentropy *rng)
 }
 EXPORT_SYMBOL_NS_GPL(crypto_jent_free, "CRYPTO_INTERNAL");
 
-static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
-{
-	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-
-	mutex_lock(&rng->jent_lock);
-
-	memzero_explicit(&rng->hash_state, sizeof(rng->hash_state));
-
-	if (rng->entropy_collector)
-		jent_entropy_collector_free(rng->entropy_collector);
-	rng->entropy_collector = NULL;
-	mutex_unlock(&rng->jent_lock);
-}
-
-static int jent_kcapi_init(struct crypto_tfm *tfm)
-{
-	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-	int ret;
-
-	ret = jent_init();
-	if (ret)
-		return ret;
-
-	mutex_init(&rng->jent_lock);
-
-	/* Use SHA3-256 as conditioner */
-	sha3_256_init(&rng->hash_state);
-
-	rng->entropy_collector = jent_entropy_collector_alloc(
-		CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, &rng->hash_state);
-	if (!rng->entropy_collector) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	return 0;
-
-err:
-	jent_kcapi_cleanup(tfm);
-	return ret;
-}
-
-static int jent_kcapi_random(struct crypto_rng *tfm,
-			     const u8 *src, unsigned int slen,
-			     u8 *rdata, unsigned int dlen)
-{
-	struct jitterentropy *rng = crypto_rng_ctx(tfm);
-	int ret = 0;
-
-	mutex_lock(&rng->jent_lock);
-
-	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
-
-	if (ret == -3) {
-		/* Handle permanent health test error */
-		/*
-		 * If the kernel was booted with fips=1, it implies that
-		 * the entire kernel acts as a FIPS 140 module. In this case
-		 * an SP800-90B permanent health test error is treated as
-		 * a FIPS module error.
-		 */
-		if (fips_enabled)
-			panic("Jitter RNG permanent health test failure\n");
-
-		pr_err("Jitter RNG permanent health test failure\n");
-		ret = -EFAULT;
-	} else if (ret == -2) {
-		/* Handle intermittent health test error */
-		pr_warn_ratelimited("Reset Jitter RNG due to intermittent health test failure\n");
-		ret = -EAGAIN;
-	} else if (ret == -1) {
-		/* Handle other errors */
-		ret = -EINVAL;
-	}
-
-	mutex_unlock(&rng->jent_lock);
-
-	return ret;
-}
-
-static int jent_kcapi_reset(struct crypto_rng *tfm,
-			    const u8 *seed, unsigned int slen)
-{
-	return 0;
-}
-
-static struct rng_alg jent_alg = {
-	.generate		= jent_kcapi_random,
-	.seed			= jent_kcapi_reset,
-	.seedsize		= 0,
-	.base			= {
-		.cra_name               = "jitterentropy_rng",
-		.cra_driver_name        = "jitterentropy_rng",
-		.cra_priority           = 100,
-		.cra_ctxsize            = sizeof(struct jitterentropy),
-		.cra_module             = THIS_MODULE,
-		.cra_init               = jent_kcapi_init,
-		.cra_exit               = jent_kcapi_cleanup,
-	}
-};
-
 static int __init jent_mod_init(void)
 {
 	jent_testing_init();
-	return crypto_register_rng(&jent_alg);
+	return 0;
 }
 
 static void __exit jent_mod_exit(void)
 {
 	jent_testing_exit();
-	crypto_unregister_rng(&jent_alg);
 }
 
 module_init(jent_mod_init);
@@ -421,4 +318,3 @@ module_exit(jent_mod_exit);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("Non-physical True Random Number Generator based on CPU Jitter");
-MODULE_ALIAS_CRYPTO("jitterentropy_rng");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4abb18bc2fa79..0e60702ab6a4c 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4923,10 +4923,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(hmac_streebog512_tv_template)
 		}
-	}, {
-		.alg = "jitterentropy_rng",
-		.fips_allowed = 1,
-		.test = alg_test_null,
 	}, {
 		.alg = "krb5enc(cmac(camellia),cts(cbc(camellia)))",
 		.test = alg_test_aead,
-- 
2.56.0

