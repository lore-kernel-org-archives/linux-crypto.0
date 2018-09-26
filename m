From: valdis.kletnieks@vt.edu
Subject: [PATCH] crypto/morus(640,1280) - make crypto_...-algs static
Date: Wed, 26 Sep 2018 18:49:38 -0400
Message-ID: <113445.1538002178@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

sparse complains thusly:

  CHECK   arch/x86/crypto/morus640-sse2-glue.c
arch/x86/crypto/morus640-sse2-glue.c:38:1: warning: symbol 'crypto_morus640_sse2_algs' was not declared. Should it be static?
  CHECK   arch/x86/crypto/morus1280-sse2-glue.c
arch/x86/crypto/morus1280-sse2-glue.c:38:1: warning: symbol 'crypto_morus1280_sse2_algs' was not declared. Should it be static?
  CHECK   arch/x86/crypto/morus1280-avx2-glue.c
arch/x86/crypto/morus1280-avx2-glue.c:38:1: warning: symbol 'crypto_morus1280_avx2_algs' was not declared. Should it be static?

and sparse is correct - these don't need to be global and polluting the namespace.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
diff --git a/include/crypto/morus1280_glue.h b/include/crypto/morus1280_glue.h
index b26dd70efd9a..ba782e10065e 100644
--- a/include/crypto/morus1280_glue.h
+++ b/include/crypto/morus1280_glue.h
@@ -82,7 +82,7 @@ void cryptd_morus1280_glue_exit_tfm(struct crypto_aead *aead);
 	{ \
 	} \
 	\
-	struct aead_alg crypto_morus1280_##id##_algs[] = {\
+	static struct aead_alg crypto_morus1280_##id##_algs[] = {\
 		{ \
 			.setkey = crypto_morus1280_glue_setkey, \
 			.setauthsize = crypto_morus1280_glue_setauthsize, \
diff --git a/include/crypto/morus640_glue.h b/include/crypto/morus640_glue.h
index 90c8db07e740..27fa790a2362 100644
--- a/include/crypto/morus640_glue.h
+++ b/include/crypto/morus640_glue.h
@@ -82,7 +82,7 @@ void cryptd_morus640_glue_exit_tfm(struct crypto_aead *aead);
 	{ \
 	} \
 	\
-	struct aead_alg crypto_morus640_##id##_algs[] = {\
+	static struct aead_alg crypto_morus640_##id##_algs[] = {\
 		{ \
 			.setkey = crypto_morus640_glue_setkey, \
 			.setauthsize = crypto_morus640_glue_setauthsize, \
