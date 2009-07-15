From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 16/35] crypto: hash - Remove legacy hash/digest implementaion
Date: Wed, 15 Jul 2009 15:16:09 +0800
Message-ID: <E1MQyin-0004zx-Of@gondolin.me.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53633 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752637AbZGOHQM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 03:16:12 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1MQyio-0004rc-3Y
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2009 17:16:10 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: hash - Remove legacy hash/digest implementaion

This patch removes the implementation of hash and digest now that
no algorithms use them anymore.  The interface though will remain
until the users are converted across.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Makefile   |    3 +--
 crypto/api.c      |   19 ++-----------------
 crypto/internal.h |   15 ---------------
 3 files changed, 3 insertions(+), 34 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 673d9f7..3c961b4 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -3,7 +3,7 @@
 #
 
 obj-$(CONFIG_CRYPTO) += crypto.o
-crypto-objs := api.o cipher.o digest.o compress.o
+crypto-objs := api.o cipher.o compress.o
 
 obj-$(CONFIG_CRYPTO_WORKQUEUE) += crypto_wq.o
 
@@ -22,7 +22,6 @@ obj-$(CONFIG_CRYPTO_BLKCIPHER2) += chainiv.o
 obj-$(CONFIG_CRYPTO_BLKCIPHER2) += eseqiv.o
 obj-$(CONFIG_CRYPTO_SEQIV) += seqiv.o
 
-crypto_hash-objs := hash.o
 crypto_hash-objs += ahash.o
 crypto_hash-objs += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
diff --git a/crypto/api.c b/crypto/api.c
index ba81221..c8ac18f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -285,13 +285,6 @@ static int crypto_init_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	switch (crypto_tfm_alg_type(tfm)) {
 	case CRYPTO_ALG_TYPE_CIPHER:
 		return crypto_init_cipher_ops(tfm);
-		
-	case CRYPTO_ALG_TYPE_DIGEST:
-		if ((mask & CRYPTO_ALG_TYPE_HASH_MASK) !=
-		    CRYPTO_ALG_TYPE_HASH_MASK)
-			return crypto_init_digest_ops_async(tfm);
-		else
-			return crypto_init_digest_ops(tfm);
 
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		return crypto_init_compress_ops(tfm);
@@ -318,11 +311,7 @@ static void crypto_exit_ops(struct crypto_tfm *tfm)
 	case CRYPTO_ALG_TYPE_CIPHER:
 		crypto_exit_cipher_ops(tfm);
 		break;
-		
-	case CRYPTO_ALG_TYPE_DIGEST:
-		crypto_exit_digest_ops(tfm);
-		break;
-		
+
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		crypto_exit_compress_ops(tfm);
 		break;
@@ -349,11 +338,7 @@ static unsigned int crypto_ctxsize(struct crypto_alg *alg, u32 type, u32 mask)
 	case CRYPTO_ALG_TYPE_CIPHER:
 		len += crypto_cipher_ctxsize(alg);
 		break;
-		
-	case CRYPTO_ALG_TYPE_DIGEST:
-		len += crypto_digest_ctxsize(alg);
-		break;
-		
+
 	case CRYPTO_ALG_TYPE_COMPRESS:
 		len += crypto_compress_ctxsize(alg);
 		break;
diff --git a/crypto/internal.h b/crypto/internal.h
index 7efa4d0..030e229 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -60,18 +60,6 @@ static inline void crypto_exit_proc(void)
 { }
 #endif
 
-static inline unsigned int crypto_digest_ctxsize(struct crypto_alg *alg)
-{
-	unsigned int len = alg->cra_ctxsize;
-
-	if (alg->cra_alignmask) {
-		len = ALIGN(len, (unsigned long)alg->cra_alignmask + 1);
-		len += alg->cra_digest.dia_digestsize;
-	}
-
-	return len;
-}
