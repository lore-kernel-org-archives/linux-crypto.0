Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DF017C64
	for <linux-crypto@vger.kernel.org>; Tue, 21 May 2024 02:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716260096; cv=none; b=fYB1SxG7OAjnRFg7BFtWPPWGQyONCOW7pvWa0sLsf1wMat8OviR3ZWwA1tvQUirH2y0Rup3SUzjXzqGitKqFQZPaI13Ntr1UZF575QjE2mAZH1Df+nFNjZt8dnyjWZL5ELp4xGbhZmEoOPBRZV1aMqPG8sdrcYPMGhk/9Km+Bjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716260096; c=relaxed/simple;
	bh=JbQAFAJ2lRfJeNGSS2jp8wtesTar94I2QwnwW+5Zx0E=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fy+r9Le6B0t6Brlt4r2PnmhFJNxCqNno9tFwjuVY10ItZJPEBoTvWYhWovUAH0xM9pjd7AZ7+9IJzCYt7aNxy/LqTffOFlPvxu5NtMx+9COcbSqUNQs46EYuGAeHwkwIhYGYbFx4hkRF+XkkNtaI6VRDZ2zircCw7TXTL60QYWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1s9FeL-000M9C-1Z;
	Tue, 21 May 2024 10:54:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 21 May 2024 10:54:50 +0800
Date: Tue, 21 May 2024 10:54:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: api - Disable boot-test-finished if algapi is a
 module
Message-ID: <ZkwM-pIwNkLc9ZOS@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The boot-test-finished toggle is only necessary if algapi
is built into the kernel.  Do not include this code if it is a module.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algapi.c   | 3 +++
 crypto/api.c      | 4 ++--
 crypto/internal.h | 7 +++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index 85bc279b4233..122cd910c4e1 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1056,6 +1056,9 @@ EXPORT_SYMBOL_GPL(crypto_type_has_alg);
 
 static void __init crypto_start_tests(void)
 {
+	if (!IS_BUILTIN(CONFIG_CRYPTO_ALGAPI))
+		return;
+
 	if (IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS))
 		return;
 
diff --git a/crypto/api.c b/crypto/api.c
index 6aa5a3b4ed5e..22556907b3bc 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -31,9 +31,9 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
 BLOCKING_NOTIFIER_HEAD(crypto_chain);
 EXPORT_SYMBOL_GPL(crypto_chain);
 
-#ifndef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+#if IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) && \
+    !IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)
 DEFINE_STATIC_KEY_FALSE(__crypto_boot_test_finished);
-EXPORT_SYMBOL_GPL(__crypto_boot_test_finished);
 #endif
 
 static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
diff --git a/crypto/internal.h b/crypto/internal.h
index 63e59240d5fb..aee31319be2e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -66,7 +66,8 @@ extern struct blocking_notifier_head crypto_chain;
 
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask);
 
-#ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+#if !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) || \
+    IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)
 static inline bool crypto_boot_test_finished(void)
 {
 	return true;
@@ -84,7 +85,9 @@ static inline void set_crypto_boot_test_finished(void)
 {
 	static_branch_enable(&__crypto_boot_test_finished);
 }
-#endif /* !CONFIG_CRYPTO_MANAGER_DISABLE_TESTS */
+#endif /* !IS_BUILTIN(CONFIG_CRYPTO_ALGAPI) ||
+	* IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)
+	*/
 
 #ifdef CONFIG_PROC_FS
 void __init crypto_init_proc(void);
-- 
2.39.2

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
