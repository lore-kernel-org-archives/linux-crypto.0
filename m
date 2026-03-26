Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7D3249E5;
	Thu, 26 Mar 2026 00:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774484216; cv=none; b=iFBxTTIvdm7+XtD2DY9sWuPUhZZPV7eUgmZ/oElwRhU4dbqiyiounYr/VdzNWSXgUbcNEFMnpuM8QWvxcfi1gWi7Mh4oJDLl/gysGBdO1FANY0jgLcqkI9GMbdanB5ZKlGBm7SqsOP2NQ1l/dO2+AKFseDsJny7a1zLm4vAunDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774484216; c=relaxed/simple;
	bh=nmi817YIkL7ox8Zps1fGLGLUBGKM1rMUbPb1VZNqjPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLBGhryN7erSxzCaGQxYvHmplTzzvmIC/h6BYdeTERNnAFbEv+1nTYV1uVkwvju/1uxVBNrmTMCBMH5YF31MzM2tX9FNgxTl3nPteSGU6ht3oSqboZ70eDUbTan9DAIa+elHwGk4YXXhlOZRUwcLohTALlcT96cHVGvA+hjomy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eweshMVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eweshMVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC12C4CEF7;
	Thu, 26 Mar 2026 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774484214;
	bh=nmi817YIkL7ox8Zps1fGLGLUBGKM1rMUbPb1VZNqjPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eweshMVUCXMzZRRsI7njXxgeBTjXcBMKmJpoNC9jNCZyfIr/4c6DKo7DSLf6uvq1k
	 9nnVRPEEgZXPRynSM/FGx6iVXPuKub2TSg1cxv6UFO0l/lMrKT5I+dUXOnVWexp75y
	 OP6UApBY4y3/iW5rdcQb5x8o11niALeP1VbrEXHd+pHos7Xe/mm0NW7/B7UREFpOIS
	 fLHgnPM84IHjtgXG4A2O5HuLOTAv52gYBehRnlmhEgvjDXOWt1wMLkfpx5YD8zLYh4
	 bD/d10NJ8BVjITNfjDwzme3S9VAsIgw76Bnp8dBuNAG6VS31zPB1nLoKIPU55852lh
	 q8vYqS42XkyaQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Stephan Mueller <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/11] crypto: rng - Make crypto_stdrng_get_bytes() use normal RNG in non-FIPS mode
Date: Wed, 25 Mar 2026 17:15:05 -0700
Message-ID: <20260326001507.66500-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260326001507.66500-1-ebiggers@kernel.org>
References: <20260326001507.66500-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"stdrng" is needed only in "FIPS mode".  Therefore, make
crypto_stdrng_get_bytes() delegate to either the normal Linux RNG or to
"stdrng", depending on the current mode.

This will eliminate the need to built the SP800-90A DRBG and its
dependencies into CRYPTO_FIPS=n kernels.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/rng.c         |  4 ++--
 include/crypto/rng.h | 15 +++++++++++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index f52f4793f9ea..1d4b9177bad4 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -140,11 +140,11 @@ static void crypto_put_default_rng(void)
 	mutex_lock(&crypto_default_rng_lock);
 	crypto_default_rng_refcnt--;
 	mutex_unlock(&crypto_default_rng_lock);
 }
 
-int crypto_stdrng_get_bytes(void *buf, unsigned int len)
+int __crypto_stdrng_get_bytes(void *buf, unsigned int len)
 {
 	int err;
 
 	err = crypto_get_default_rng();
 	if (err)
@@ -152,11 +152,11 @@ int crypto_stdrng_get_bytes(void *buf, unsigned int len)
 
 	err = crypto_rng_get_bytes(crypto_default_rng, buf, len);
 	crypto_put_default_rng();
 	return err;
 }
-EXPORT_SYMBOL_GPL(crypto_stdrng_get_bytes);
+EXPORT_SYMBOL_GPL(__crypto_stdrng_get_bytes);
 
 #if defined(CONFIG_CRYPTO_RNG) || defined(CONFIG_CRYPTO_RNG_MODULE)
 int crypto_del_default_rng(void)
 {
 	int err = -EBUSY;
diff --git a/include/crypto/rng.h b/include/crypto/rng.h
index f61e037afed9..07f494b2c881 100644
--- a/include/crypto/rng.h
+++ b/include/crypto/rng.h
@@ -10,10 +10,12 @@
 #define _CRYPTO_RNG_H
 
 #include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
+#include <linux/fips.h>
+#include <linux/random.h>
 
 struct crypto_rng;
 
 /**
  * struct rng_alg - random number generator definition
@@ -55,22 +57,31 @@ struct rng_alg {
 
 struct crypto_rng {
 	struct crypto_tfm base;
 };
 
+int __crypto_stdrng_get_bytes(void *buf, unsigned int len);
+
 /**
  * crypto_stdrng_get_bytes() - get cryptographically secure random bytes
  * @buf: output buffer holding the random numbers
  * @len: length of the output buffer
  *
  * This function fills the caller-allocated buffer with random numbers using the
- * highest-priority "stdrng" algorithm in the crypto_rng subsystem.
+ * normal Linux RNG if fips_enabled=0, or the highest-priority "stdrng"
+ * algorithm in the crypto_rng subsystem if fips_enabled=1.
  *
  * Context: May sleep
  * Return: 0 function was successful; < 0 if an error occurred
  */
-int crypto_stdrng_get_bytes(void *buf, unsigned int len);
+static inline int crypto_stdrng_get_bytes(void *buf, unsigned int len)
+{
+	might_sleep();
+	if (fips_enabled)
+		return __crypto_stdrng_get_bytes(buf, len);
+	return get_random_bytes_wait(buf, len);
+}
 
 /**
  * DOC: Random number generator API
  *
  * The random number generator API is used with the ciphers of type
-- 
2.53.0

