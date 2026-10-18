Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881D1426693
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356567; cv=none; b=XxtukpJzzbyjtAvMtMVcY/+E+yzkGf3I2umzbCnJOa+Abuq9qlp4xadJpEwUZp16kpegPjqanuE5X+esVYnMvydTEEt4jZ+jZnGIq390oINJaNzGpiFBmDJMghiCoIxRETNrYcZsxJZgGHYB1+LNIaYellzs3T7VMO9XaNlqXMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356567; c=relaxed/simple;
	bh=4w0nLA4dvdeH459fnsGG3XFIks3ROccujqDsBSs7ERY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X64HlIIsNExZzCn3nH1j5mlFIP5CO/wzsgl85DDsZhjENkzf7YujaHglTiK/lcRMEh4nxQC+AJX19XF/Iq8EC7iDa+uc5LskU2g+BOplsEXrkgwxrhf1i75+nwqSMjgDFGlFKa/CusC8vQb/N+3cfoAwOYhrKdmLEFYhEOFTGIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdk4i0Ic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdk4i0Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65E01F000C8;
	Sun, 18 Oct 2026 20:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356566;
	bh=4ND2XPFpSLRf7OTzJhspUA+zGlRwVCjtUZxF+BzuLXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdk4i0IcAT4KGW2kOKrZ+YOkcbBsjLB4Bl+c3a5DD/4nFnTjpjWHQDPJFotb6Le4w
	 aSBU7vYQ35R8vK8w0smEusRAD7R0yXjBE8R+j5EsHYeTltPrG4G7tXpPFKpDOF7uGh
	 UR4a7vjXQSuEjCnfVO1ccVVX/5moXyVjjS46oFxjg6xW/rrQd4mC/ZWi3sZRzyCV1F
	 vhtoug1J/Q968a4LQ7d+Hs0NkWcQXumvNIO9Jio/A4zRqbbHCaV9gSRLnL5aMuGlJh
	 ymnzEhpRUIRidTcCjTeSbS+gwG6M4e9VkpEJImxPpFVLDeQ27NMWFIdsBHWfsct56k
	 U3saUBNtX5gpw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 03/14] crypto: jitterentropy - Move health check to first use
Date: Sun, 18 Oct 2026 13:46:07 -0700
Message-ID: <20261018204618.104876-4-ebiggers@kernel.org>
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

Building jitterentropy into the kernel causes the expensive health check
to run on boot, even if jitterentropy is never used.

With the upcoming addition of direct linking, this problem would get
worse since it will happen even if jitterentropy is built as a module.

To fix this, do the health check on first use instead of in module_init.

Note that this shouldn't have any impact on FIPS 140-3 certifiability.
A failed health check now panics on first use instead of on boot, but
that is acceptable.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 72 ++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 19 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 652852649a312..84c2c74240a0a 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -178,6 +178,54 @@ struct jitterentropy {
 	struct sha3_ctx hash_state;
 };
 
+static int jent_init_err;
+
+static void jent_init_once(void)
+{
+	struct sha3_ctx hash_state;
+	int err;
+
+	sha3_256_init(&hash_state);
+	err = jent_entropy_init(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, &hash_state,
+				NULL);
+	memzero_explicit(&hash_state, sizeof(hash_state));
+	if (err) {
+		/* Handle permanent health test error */
+		if (fips_enabled)
+			panic("jitterentropy: Initialization failed with host not compliant with requirements: %d\n",
+			      err);
+
+		pr_info("jitterentropy: Initialization failed with host not compliant with requirements: %d\n",
+			err);
+		jent_init_err = err;
+	}
+}
+
+static int jent_init(void)
+{
+	static DEFINE_MUTEX(jent_init_mutex);
+	static bool initialized;
+
+	/*
+	 * To avoid lockdep reports of inconsistent ordering of drbg_mutex and
+	 * once_mutex, implement one-time-init locally instead of using
+	 * DO_ONCE_SLEEPABLE.
+	 */
+	guard(mutex)(&jent_init_mutex);
+	if (!initialized) {
+		jent_init_once();
+		initialized = true;
+	}
+	if (jent_init_err) {
+		/*
+		 * jent_init_err is a private custom error code from
+		 * jitterentropy.c.  Select an errno value instead.
+		 */
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
 static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
@@ -195,7 +243,11 @@ static void jent_kcapi_cleanup(struct crypto_tfm *tfm)
 static int jent_kcapi_init(struct crypto_tfm *tfm)
 {
 	struct jitterentropy *rng = crypto_tfm_ctx(tfm);
-	int ret = 0;
+	int ret;
+
+	ret = jent_init();
+	if (ret)
+		return ret;
 
 	mutex_init(&rng->jent_lock);
 
@@ -277,25 +329,7 @@ static struct rng_alg jent_alg = {
 
 static int __init jent_mod_init(void)
 {
-	struct sha3_ctx hash_state;
-	int ret = 0;
-
 	jent_testing_init();
-
-	sha3_256_init(&hash_state);
-
-	ret = jent_entropy_init(CONFIG_CRYPTO_JITTERENTROPY_OSR, 0, &hash_state,
-				NULL);
-	memzero_explicit(&hash_state, sizeof(hash_state));
-	if (ret) {
-		/* Handle permanent health test error */
-		if (fips_enabled)
-			panic("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
-
-		jent_testing_exit();
-		pr_info("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
-		return -EFAULT;
-	}
 	return crypto_register_rng(&jent_alg);
 }
 
-- 
2.56.0

