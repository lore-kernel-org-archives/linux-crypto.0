Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1638A3CF1ED
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356570; cv=none; b=DgsHZ+y/PX7WJ2T3ljwNusNj6b8hDQzTlYoFGo5yWAdhqZVsSg72wwOSoq15bHf/HZvzb2LYFkXLclWsDs2zN/BANfYm5od4gSunCOgVVzBida14RRh+o/DsnCreKpM/U+UaVkB0PFG3zSO+vkwiD6Srw2VEevLs6RYxZLkJDfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356570; c=relaxed/simple;
	bh=Foegg8pr8KX42cuCCCOkoz/hqDpQFoYkgMujzccH3cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqbuTZRxqAJIdD/39xTw3UEwFVpNb+tYA6YWkpmWf4Irr2b4H5Y9QeQgbmydKwGZGRHwrnRPFv6ZZe9uVrYNlL16vS6NKHLWpyy09MdH+xOBu2BidJNJ8/pjFmdvPrsOwHy0IjvsPzR76va0vo6/znuAMTng8yIUtOsW5Y3OV80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oo0IhI2R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oo0IhI2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B889F1F000C8;
	Sun, 18 Oct 2026 20:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356569;
	bh=otcvChKaZYbqUJ3zyTMx5lnXHwoZ3Vr3tFlNyIMwgDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oo0IhI2RgLjWngzswAn3JhBv082pA+CVxGRDhNQg3HQrXZNLY3lMENj+TtEfgPNk1
	 i/Wyz9J+dLCByGU/DDwSMqb4tKwe+vBFozKD8uYbHB03KLNx23E2rQh1yumEs6j46I
	 Z8ru/ezqo+0wplSC+6iJsvGBRiRd1M+hMs45smNYpLOZ5GeXAF9Sj7279mI8CSAY9n
	 w3VBIIhT2F8Fb+SpPjJDXDbCjdWv7OFmvnrR4L0xeUee+ER8WOCPuXxics5NqnCPMn
	 d1g0IBTfyrwVgGobSxzldRKcggMKCVduuYh0LgPm7RrwO2ZO4z7W1kQhCy9hj19ZiJ
	 wtTNcj5QiWf/w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/14] crypto: stdrng - Reimplement "stdrng" using direct DRBG calls
Date: Sun, 18 Oct 2026 13:46:13 -0700
Message-ID: <20261018204618.104876-10-ebiggers@kernel.org>
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

When fips=1, the so-called "stdrng" is always the NIST SP800-90A DRBG.
Simplify the code by making __crypto_stdrng_get_bytes() call into the
DRBG directly instead of going through the unnecessary crypto_rng API.

This required moving the shared DRBG instance (and the function to
delete it) from rng.c to drbg.c.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig                |  1 -
 crypto/crypto_user.c          |  2 +-
 crypto/drbg.c                 | 66 ++++++++++++++++++++++++++
 crypto/rng.c                  | 88 -----------------------------------
 include/crypto/internal/rng.h |  9 ----
 include/crypto/rng.h          | 14 ++++--
 6 files changed, 78 insertions(+), 102 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 5b0806432694f..c41c2f3475d0b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -158,7 +158,6 @@ config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
 	depends on NET
 	select CRYPTO_MANAGER
-	select CRYPTO_RNG
 	help
 	  Userspace configuration for cryptographic instantiations such as
 	  cbc(aes).
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index d3ccb507153b2..08e2b4fb9bf73 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -16,9 +16,9 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/internal/rng.h>
 #include <crypto/akcipher.h>
 #include <crypto/kpp.h>
+#include <crypto/rng.h>
 
 #include "internal.h"
 
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9c99b2d510e0a..0f36aa45bfaca 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -638,6 +638,67 @@ void crypto_drbg_free(struct drbg_state *drbg)
 }
 EXPORT_SYMBOL_NS_GPL(crypto_drbg_free, "CRYPTO_INTERNAL");
 
+#ifdef CONFIG_CRYPTO_FIPS
+static DEFINE_MUTEX(crypto_default_rng_lock);
+static struct drbg_state *crypto_default_rng;
+static int crypto_default_rng_refcnt;
+
+static int crypto_get_default_rng(void)
+{
+	struct drbg_state *drbg;
+	int err;
+
+	guard(mutex)(&crypto_default_rng_lock);
+	if (!crypto_default_rng) {
+		drbg = crypto_drbg_alloc();
+		if (IS_ERR(drbg))
+			return PTR_ERR(drbg);
+
+		err = crypto_drbg_seed(drbg, NULL, 0);
+		if (err) {
+			crypto_drbg_free(drbg);
+			return err;
+		}
+		crypto_default_rng = drbg;
+	}
+
+	crypto_default_rng_refcnt++;
+	return 0;
+}
+
+static void crypto_put_default_rng(void)
+{
+	guard(mutex)(&crypto_default_rng_lock);
+	crypto_default_rng_refcnt--;
+}
+
+int __crypto_stdrng_get_bytes(void *buf, unsigned int len)
+{
+	int err;
+
+	err = crypto_get_default_rng();
+	if (err)
+		return err;
+
+	err = crypto_drbg_get_bytes(crypto_default_rng, buf, len, NULL, 0);
+	crypto_put_default_rng();
+	return err;
+}
+EXPORT_SYMBOL_GPL(__crypto_stdrng_get_bytes);
+
+int crypto_del_default_rng(void)
+{
+	guard(mutex)(&crypto_default_rng_lock);
+	if (crypto_default_rng_refcnt)
+		return -EBUSY;
+
+	crypto_drbg_free(crypto_default_rng);
+	crypto_default_rng = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_del_default_rng);
+#endif /* CONFIG_CRYPTO_FIPS */
+
 /*
  * Tests as defined in 11.3.2 in addition to the cipher tests: testing
  * of the error handling.
@@ -812,6 +873,11 @@ static int __init drbg_init(void)
 static void __exit drbg_exit(void)
 {
 	crypto_unregister_rng(&drbg_alg);
+
+	/*
+	 * Note there's no need to call crypto_del_default_rng() from here, as
+	 * it can exist only when this file is built-in.
+	 */
 }
 
 module_init(drbg_init);
diff --git a/crypto/rng.c b/crypto/rng.c
index 828b0d8074738..be4873bec679b 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -23,10 +23,6 @@
 
 #include "internal.h"
 
-static DEFINE_MUTEX(crypto_default_rng_lock);
-static struct crypto_rng *crypto_default_rng;
-static int crypto_default_rng_refcnt;
-
 int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 {
 	u8 *buf = NULL;
@@ -103,79 +99,6 @@ struct crypto_rng *crypto_alloc_rng(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_rng);
 
-static int crypto_get_default_rng(void)
-{
-	struct crypto_rng *rng;
-	int err;
-
-	mutex_lock(&crypto_default_rng_lock);
-	if (!crypto_default_rng) {
-		rng = crypto_alloc_rng("stdrng", 0, 0);
-		err = PTR_ERR(rng);
-		if (IS_ERR(rng))
-			goto unlock;
-
-		err = crypto_rng_reset(rng, NULL, crypto_rng_seedsize(rng));
-		if (err) {
-			crypto_free_rng(rng);
-			goto unlock;
-		}
-
-		crypto_default_rng = rng;
-	}
-
-	crypto_default_rng_refcnt++;
-	err = 0;
-
-unlock:
-	mutex_unlock(&crypto_default_rng_lock);
-
-	return err;
-}
-
-static void crypto_put_default_rng(void)
-{
-	mutex_lock(&crypto_default_rng_lock);
-	crypto_default_rng_refcnt--;
-	mutex_unlock(&crypto_default_rng_lock);
-}
-
-int __crypto_stdrng_get_bytes(void *buf, unsigned int len)
-{
-	int err;
-
-	err = crypto_get_default_rng();
-	if (err)
-		return err;
-
-	err = crypto_rng_get_bytes(crypto_default_rng, buf, len);
-	crypto_put_default_rng();
-	return err;
-}
-EXPORT_SYMBOL_GPL(__crypto_stdrng_get_bytes);
-
-#if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
-int crypto_del_default_rng(void)
-{
-	int err = -EBUSY;
-
-	mutex_lock(&crypto_default_rng_lock);
-	if (crypto_default_rng_refcnt)
-		goto out;
-
-	crypto_free_rng(crypto_default_rng);
-	crypto_default_rng = NULL;
-
-	err = 0;
-
-out:
-	mutex_unlock(&crypto_default_rng_lock);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(crypto_del_default_rng);
-#endif
-
 static void rng_default_set_ent(struct crypto_rng *tfm, const u8 *data,
 				unsigned int len)
 {
@@ -230,16 +153,5 @@ void crypto_unregister_rngs(struct rng_alg *algs, int count)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_rngs);
 
-static void __exit rng_exit(void)
-{
-	int err;
-
-	err = crypto_del_default_rng();
-	if (err)
-		pr_err("Failed delete default RNG: %d\n", err);
-}
-
-module_exit(rng_exit);
-
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Random Number Generator");
diff --git a/include/crypto/internal/rng.h b/include/crypto/internal/rng.h
index e0711b6a597fc..8c9f560d6449c 100644
--- a/include/crypto/internal/rng.h
+++ b/include/crypto/internal/rng.h
@@ -17,15 +17,6 @@ void crypto_unregister_rng(struct rng_alg *alg);
 int crypto_register_rngs(struct rng_alg *algs, int count);
 void crypto_unregister_rngs(struct rng_alg *algs, int count);
 
-#if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
-int crypto_del_default_rng(void);
-#else
-static inline int crypto_del_default_rng(void)
-{
-	return 0;
-}
-#endif
-
 static inline void *crypto_rng_ctx(struct crypto_rng *tfm)
 {
 	return crypto_tfm_ctx(&tfm->base);
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index 07f494b2c8817..463bbdce11c2c 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -66,9 +66,8 @@ int __crypto_stdrng_get_bytes(void *buf, unsigned int len);
  * @buf: output buffer holding the random numbers
  * @len: length of the output buffer
  *
- * This function fills the caller-allocated buffer with random numbers using the
- * normal Linux RNG if fips_enabled=0, or the highest-priority "stdrng"
- * algorithm in the crypto_rng subsystem if fips_enabled=1.
+ * This function fills the given buffer with random numbers using the normal
+ * Linux RNG if fips_enabled=0, or a NIST SP800-90A DRBG if fips_enabled=1.
  *
  * Context: May sleep
  * Return: 0 function was successful; < 0 if an error occurred
@@ -81,6 +80,15 @@ static inline int crypto_stdrng_get_bytes(void *buf, unsigned int len)
 	return get_random_bytes_wait(buf, len);
 }
 
+#ifdef CONFIG_CRYPTO_FIPS
+int crypto_del_default_rng(void);
+#else
+static inline int crypto_del_default_rng(void)
+{
+	return 0;
+}
+#endif
+
 /**
  * DOC: Random number generator API
  *
-- 
2.56.0

