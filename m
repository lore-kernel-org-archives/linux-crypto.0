From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 24/28] crypto: aead - Remove blkcipher null for IV generators
Date: Wed, 29 Jun 2016 18:04:11 +0800
Message-ID: <E1bICLr-0006xI-Dx@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46815 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcF2KEO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:14 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLr-0005O3-LX
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:11 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The blkcipher null object is no longer used and can now be removed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                   |    8 --------
 include/crypto/internal/geniv.h |    1 -
 2 files changed, 9 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 1ede34c..ee58ab4 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -299,11 +299,6 @@ int aead_init_geniv(struct crypto_aead *aead)
 	if (IS_ERR(ctx->sknull))
 		goto out;
 
-	ctx->null = crypto_get_default_null_skcipher();
-	err = PTR_ERR(ctx->null);
-	if (IS_ERR(ctx->null))
-		goto drop_sknull;
-
 	child = crypto_spawn_aead(aead_instance_ctx(inst));
 	err = PTR_ERR(child);
 	if (IS_ERR(child))
@@ -319,8 +314,6 @@ out:
 	return err;
 
 drop_null:
-	crypto_put_default_null_skcipher();
-drop_sknull:
 	crypto_put_default_null_skcipher2();
 	goto out;
 }
@@ -331,7 +324,6 @@ void aead_exit_geniv(struct crypto_aead *tfm)
 	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_aead(ctx->child);
-	crypto_put_default_null_skcipher();
 	crypto_put_default_null_skcipher2();
 }
 EXPORT_SYMBOL_GPL(aead_exit_geniv);
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index e8447c9..2bcfb93 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -20,7 +20,6 @@
 struct aead_geniv_ctx {
 	spinlock_t lock;
 	struct crypto_aead *child;
-	struct crypto_blkcipher *null;
 	struct crypto_skcipher *sknull;
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
