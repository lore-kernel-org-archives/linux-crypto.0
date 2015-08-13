From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/13] crypto: aead - Add type-safe geniv init/exit helpers
Date: Thu, 13 Aug 2015 17:28:58 +0800
Message-ID: <E1ZPook-0005qB-5X@gondolin.me.apana.org.au>
References: <20150813092520.GA22268@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53865 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbbHMJ3B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 05:29:01 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZPook-00036X-PD
	for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2015 19:28:59 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds the helpers aead_init_geniv and aead_exit_geniv
which are type-safe and intended the replace the existing geniv
init/exit helpers.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/Kconfig                  |   11 +++++---
 crypto/aead.c                   |   55 ++++++++++++++++++++++++++++++++++++++++
 include/crypto/internal/aead.h  |    6 ----
 include/crypto/internal/geniv.h |   11 ++++++++
 4 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ac7cc62..0e35889 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -48,6 +48,8 @@ config CRYPTO_AEAD
 config CRYPTO_AEAD2
 	tristate
 	select CRYPTO_ALGAPI2
+	select CRYPTO_NULL2
+	select CRYPTO_RNG2
 
 config CRYPTO_BLKCIPHER
 	tristate
@@ -150,12 +152,15 @@ config CRYPTO_GF128MUL
 
 config CRYPTO_NULL
 	tristate "Null algorithms"
-	select CRYPTO_ALGAPI
-	select CRYPTO_BLKCIPHER
-	select CRYPTO_HASH
+	select CRYPTO_NULL2
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
+config CRYPTO_NULL2
+	select CRYPTO_ALGAPI2
+	select CRYPTO_BLKCIPHER2
+	select CRYPTO_HASH2
+
 config CRYPTO_PCRYPT
 	tristate "Parallel crypto engine"
 	depends on SMP
diff --git a/crypto/aead.c b/crypto/aead.c
index 1a5b118..a4dcd19 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -13,6 +13,8 @@
  */
 
 #include <crypto/internal/geniv.h>
+#include <crypto/internal/rng.h>
+#include <crypto/null.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -746,6 +748,59 @@ void aead_geniv_exit(struct crypto_tfm *tfm)
 }
 EXPORT_SYMBOL_GPL(aead_geniv_exit);
 
+int aead_init_geniv(struct crypto_aead *aead)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(aead);
+	struct aead_instance *inst = aead_alg_instance(aead);
+	struct crypto_aead *child;
+	int err;
+
+	spin_lock_init(&ctx->lock);
+
+	err = crypto_get_default_rng();
+	if (err)
+		goto out;
+
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(aead));
+	crypto_put_default_rng();
+	if (err)
+		goto out;
+
+	ctx->null = crypto_get_default_null_skcipher();
+	err = PTR_ERR(ctx->null);
+	if (IS_ERR(ctx->null))
+		goto out;
+
+	child = crypto_spawn_aead(aead_instance_ctx(inst));
+	err = PTR_ERR(child);
+	if (IS_ERR(child))
+		goto drop_null;
+
+	ctx->child = child;
+	crypto_aead_set_reqsize(aead, crypto_aead_reqsize(child) +
+				      sizeof(struct aead_request));
+
+	err = 0;
+
+out:
+	return err;
+
+drop_null:
+	crypto_put_default_null_skcipher();
+	goto out;
+}
+EXPORT_SYMBOL_GPL(aead_init_geniv);
+
+void aead_exit_geniv(struct crypto_aead *tfm)
+{
+	struct aead_geniv_ctx *ctx = crypto_aead_ctx(tfm);
+
+	crypto_free_aead(ctx->child);
+	crypto_put_default_null_skcipher();
+}
+EXPORT_SYMBOL_GPL(aead_exit_geniv);
+
 static int crypto_nivaead_default(struct crypto_alg *alg, u32 type, u32 mask)
 {
 	struct rtattr *tb[3];
diff --git a/include/crypto/internal/aead.h b/include/crypto/internal/aead.h
index a292e96..49f3179 100644
--- a/include/crypto/internal/aead.h
+++ b/include/crypto/internal/aead.h
@@ -123,12 +123,6 @@ static inline struct crypto_aead *crypto_spawn_aead(
 	return crypto_spawn_tfm2(&spawn->base);
 }
 
-struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
-				       struct rtattr **tb, u32 type, u32 mask);
-void aead_geniv_free(struct aead_instance *inst);
-int aead_geniv_init(struct crypto_tfm *tfm);
-void aead_geniv_exit(struct crypto_tfm *tfm);
-
 static inline struct crypto_aead *aead_geniv_base(struct crypto_aead *geniv)
 {
 	return geniv->child;
diff --git a/include/crypto/internal/geniv.h b/include/crypto/internal/geniv.h
index 9ca9b87..b9c55be 100644
--- a/include/crypto/internal/geniv.h
+++ b/include/crypto/internal/geniv.h
@@ -15,10 +15,21 @@
 
 #include <crypto/internal/aead.h>
 #include <linux/spinlock.h>
+#include <linux/types.h>
 
 struct aead_geniv_ctx {
 	spinlock_t lock;
 	struct crypto_aead *child;
+	struct crypto_blkcipher *null;
+	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
+struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
+				       struct rtattr **tb, u32 type, u32 mask);
+void aead_geniv_free(struct aead_instance *inst);
+int aead_geniv_init(struct crypto_tfm *tfm);
+void aead_geniv_exit(struct crypto_tfm *tfm);
+int aead_init_geniv(struct crypto_aead *tfm);
+void aead_exit_geniv(struct crypto_aead *tfm);
+
 #endif	/* _CRYPTO_INTERNAL_GENIV_H */
