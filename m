From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: skcipher - Use RNG interface instead of get_random_bytes
Date: Thu, 14 Aug 2008 22:23:31 +1000
Message-ID: <20080814122331.GA21061@gondor.apana.org.au>
References: <20080811202607.GA11527@hmsreliant.think-freely.org> <20080814115137.GA5721@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60979 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754225AbYHNMXf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Aug 2008 08:23:35 -0400
Content-Disposition: inline
In-Reply-To: <20080814115137.GA5721@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 14, 2008 at 09:51:37PM +1000, Herbert Xu wrote:
>
> Here is the final result against cryptodev-2.6.  Let me know if
> you're OK with it and I'll push it out.

And here is the IV generator patch on top.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
commit 560a63d94d36641c83a8f533ed87bab95f6298bb
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Aug 14 22:21:31 2008 +1000

    crypto: skcipher - Use RNG interface instead of get_random_bytes
    
    This patch makes the IV generators use the new RNG interface so
    that the user can pick an RNG other than the default get_random_bytes.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b00860f..a985065 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -33,6 +33,7 @@ config CRYPTO_AEAD
 config CRYPTO_BLKCIPHER
 	tristate
 	select CRYPTO_ALGAPI
+	select CRYPTO_RNG
 
 config CRYPTO_HASH
 	tristate
@@ -117,6 +118,7 @@ config CRYPTO_SEQIV
 	tristate "Sequence Number IV Generator"
 	select CRYPTO_AEAD
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_RNG
 	help
 	  This IV generator generates an IV based on a sequence number by
 	  xoring it with a salt.  This algorithm is mainly useful for CTR
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 9affade..330b5e4 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -14,11 +14,11 @@
  */
 
 #include <crypto/internal/skcipher.h>
+#include <crypto/rng.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/workqueue.h>
@@ -44,6 +44,8 @@ struct async_chainiv_ctx {
 	char iv[];
 };
 
+static struct crypto_rng *rng;
+
 static int chainiv_givencrypt(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
@@ -83,6 +85,7 @@ static int chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_ablkcipher_crt(geniv)->givencrypt !=
@@ -90,11 +93,15 @@ static int chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = chainiv_givencrypt;
-	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(rng, ctx->iv,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return chainiv_givencrypt(req);
 }
 
@@ -203,6 +210,7 @@ static int async_chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
 		goto out;
@@ -212,11 +220,15 @@ static int async_chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = async_chainiv_givencrypt;
-	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(rng, ctx->iv,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
 
+	if (err)
+		return err;
+
 out:
 	return async_chainiv_givencrypt(req);
 }
@@ -322,10 +334,30 @@ static struct crypto_template chainiv_tmpl = {
 
 int __init chainiv_module_init(void)
 {
-	return crypto_register_template(&chainiv_tmpl);
+	int err;
+
+	rng = crypto_alloc_rng("stdrng", 0, 0);
+	if (IS_ERR(rng))
+		return PTR_ERR(rng);
+
+	err = crypto_rng_reset(rng, NULL, crypto_rng_seedsize(rng));
+	if (err)
+		goto free_rng;
+
+	err = crypto_register_template(&chainiv_tmpl);
+	if (err)
+		goto free_rng;
+
+out:
+	return err;
+
+free_rng:
+	crypto_free_rng(rng);
+	goto out;
 }
 
 void chainiv_module_exit(void)
 {
 	crypto_unregister_template(&chainiv_tmpl);
+	crypto_free_rng(rng);
 }
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index 881d309..b450943 100644
--- a/crypto/eseqiv.c
+++ b/crypto/eseqiv.c
@@ -16,13 +16,13 @@
  */
 
 #include <crypto/internal/skcipher.h>
+#include <crypto/rng.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/random.h>
 #include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
@@ -39,6 +39,8 @@ struct eseqiv_ctx {
 	char salt[];
 };
 
+static struct crypto_rng *rng;
+
 static void eseqiv_complete2(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
@@ -163,17 +165,22 @@ static int eseqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_ablkcipher_crt(geniv)->givencrypt != eseqiv_givencrypt_first)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = eseqiv_givencrypt;
-	get_random_bytes(ctx->salt, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(rng, ctx->salt,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return eseqiv_givencrypt(req);
 }
 
@@ -250,10 +257,30 @@ static struct crypto_template eseqiv_tmpl = {
 
 int __init eseqiv_module_init(void)
 {
-	return crypto_register_template(&eseqiv_tmpl);
+	int err;
+
+	rng = crypto_alloc_rng("stdrng", 0, 0);
+	if (IS_ERR(rng))
+		return PTR_ERR(rng);
+
+	err = crypto_rng_reset(rng, NULL, crypto_rng_seedsize(rng));
+	if (err)
+		goto free_rng;
+
+	err = crypto_register_template(&eseqiv_tmpl);
+	if (err)
+		goto free_rng;
+
+out:
+	return err;
+
+free_rng:
+	crypto_free_rng(rng);
+	goto out;
 }
 
 void __exit eseqiv_module_exit(void)
 {
 	crypto_unregister_template(&eseqiv_tmpl);
+	crypto_free_rng(rng);
 }
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index b903aab..1b95c0e 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -15,11 +15,11 @@
 
 #include <crypto/internal/aead.h>
 #include <crypto/internal/skcipher.h>
+#include <crypto/rng.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/random.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 
@@ -28,6 +28,8 @@ struct seqiv_ctx {
 	u8 salt[] __attribute__ ((aligned(__alignof__(u32))));
 };
 
+static struct crypto_rng *rng;
+
 static void seqiv_complete2(struct skcipher_givcrypt_request *req, int err)
 {
 	struct ablkcipher_request *subreq = skcipher_givcrypt_reqctx(req);
@@ -189,17 +191,22 @@ static int seqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_ablkcipher_crt(geniv)->givencrypt != seqiv_givencrypt_first)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = seqiv_givencrypt;
-	get_random_bytes(ctx->salt, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(rng, ctx->salt,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return seqiv_givencrypt(req);
 }
 
@@ -207,17 +214,21 @@ static int seqiv_aead_givencrypt_first(struct aead_givcrypt_request *req)
 {
 	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
 	struct seqiv_ctx *ctx = crypto_aead_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_aead_crt(geniv)->givencrypt != seqiv_aead_givencrypt_first)
 		goto unlock;
 
 	crypto_aead_crt(geniv)->givencrypt = seqiv_aead_givencrypt;
-	get_random_bytes(ctx->salt, crypto_aead_ivsize(geniv));
+	err = crypto_rng_get_bytes(rng, ctx->salt, crypto_aead_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return seqiv_aead_givencrypt(req);
 }
 
@@ -330,12 +341,32 @@ static struct crypto_template seqiv_tmpl = {
 
 static int __init seqiv_module_init(void)
 {
-	return crypto_register_template(&seqiv_tmpl);
+	int err;
+
+	rng = crypto_alloc_rng("stdrng", 0, 0);
+	if (IS_ERR(rng))
+		return PTR_ERR(rng);
+
+	err = crypto_rng_reset(rng, NULL, crypto_rng_seedsize(rng));
+	if (err)
+		goto free_rng;
+
+	err = crypto_register_template(&seqiv_tmpl);
+	if (err)
+		goto free_rng;
+
+out:
+	return err;
+
+free_rng:
+	crypto_free_rng(rng);
+	goto out;
 }
 
 static void __exit seqiv_module_exit(void)
 {
 	crypto_unregister_template(&seqiv_tmpl);
+	crypto_free_rng(rng);
 }
 
 module_init(seqiv_module_init);
