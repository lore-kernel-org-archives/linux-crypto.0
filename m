From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 21/28] crypto: aead - Add skcipher null for IV generators
Date: Wed, 29 Jun 2016 18:04:08 +0800
Message-ID: <E1bICLo-0006wT-4U@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35292 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbcF2KEK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:04:10 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLo-0005MB-8b
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:04:08 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds an skcipher null object alongside the existing
null blkcipher so that IV generators using it can switch over
to skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c                   |   10 +++++++++-
 include/crypto/internal/geniv.h |    1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 9b18a1e..1ede34c 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -294,10 +294,15 @@ int aead_init_geniv(struct crypto_aead *aead)
 	if (err)
 		goto out;
 
+	ctx->sknull = crypto_get_default_null_skcipher2();
+	err = PTR_ERR(ctx->sknull);
+	if (IS_ERR(ctx->sknull))
+		goto out;
+
 	ctx->null = crypto_get_default_null_skcipher();
 	err = PTR_ERR(ctx->null);
 	if (IS_ERR(ctx->null))
-		goto out;
+		goto drop_sknull;
 
 	child = crypto_spawn_aead(aead_instance_ctx(inst));
 	err = PTR_ERR(child);
@@ -315,6 +320,8 @@ out:
 
 drop_null:
 	crypto_put_default_null_skcipher();
+drop_sknull:
+	crypto_put_default_null_skcipher2();
 	goto out;
 }
 EXPORT_SYMBOL_GPL(aead_init_geniv);
@@ -325,6 +332,7 @@ void aead_exit_geniv(struct crypto_aead *tfm)
 
 	crypto_free_aead(ctx->child);
 	crypto_put_default_null_skcipher();
+	crypto_put_default_null_skcipher2();
 }
 EXPORT_SYMBOL_GPL(aead_exit_geniv);
 
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 5933363..e8447c9 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -21,6 +21,7 @@ struct aead_geniv_ctx {
 	spinlock_t lock;
 	struct crypto_aead *child;
 	struct crypto_blkcipher *null;
+	struct crypto_skcipher *sknull;
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
