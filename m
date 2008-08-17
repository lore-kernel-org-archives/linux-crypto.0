From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: obscure state information on free
Date: Sun, 17 Aug 2008 22:23:50 +1000
Message-ID: <20080817122350.GB26195@gondor.apana.org.au>
References: <20080811202607.GA11527@hmsreliant.think-freely.org> <20080814115137.GA5721@gondor.apana.org.au> <20080814122137.GA10969@hmsendeavour.rdu.redhat.com> <20080817122047.GA26084@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43725 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752573AbYHQMXx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Aug 2008 08:23:53 -0400
Content-Disposition: inline
In-Reply-To: <20080817122047.GA26084@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 17, 2008 at 10:20:47PM +1000, Herbert Xu wrote:
> 
> There is also a new global rng object for everyone to use rather
> than having it allocated by every user separately.

And here is the new IV generator patch to use the global RNG object.

commit 1da64c8d0d573dcb1b67c42d41c0adf511f81dfc
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
index cf68d43..7c37a49 100644
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
@@ -83,6 +83,7 @@ static int chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_ablkcipher_crt(geniv)->givencrypt !=
@@ -90,11 +91,15 @@ static int chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = chainiv_givencrypt;
-	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->iv,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return chainiv_givencrypt(req);
 }
 
@@ -203,6 +208,7 @@ static int async_chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct async_chainiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	if (test_and_set_bit(CHAINIV_STATE_INUSE, &ctx->state))
 		goto out;
@@ -212,11 +218,15 @@ static int async_chainiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = async_chainiv_givencrypt;
-	get_random_bytes(ctx->iv, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->iv,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	clear_bit(CHAINIV_STATE_INUSE, &ctx->state);
 
+	if (err)
+		return err;
+
 out:
 	return async_chainiv_givencrypt(req);
 }
@@ -284,9 +294,13 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 	if (IS_ERR(algt))
 		return ERR_PTR(err);
 
+	err = crypto_get_default_rng();
+	if (err)
+		return ERR_PTR(err);
+
 	inst = skcipher_geniv_alloc(&chainiv_tmpl, tb, 0, 0);
 	if (IS_ERR(inst))
-		goto out;
+		goto put_rng;
 
 	inst->alg.cra_ablkcipher.givencrypt = chainiv_givencrypt_first;
 
@@ -311,12 +325,22 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 
 out:
 	return inst;
+
+put_rng:
+	crypto_put_default_rng();
+	goto out;
+}
+
+static void chainiv_free(struct crypto_instance *inst)
+{
+	skcipher_geniv_free(inst);
+	crypto_put_default_rng();
 }
 
 static struct crypto_template chainiv_tmpl = {
 	.name = "chainiv",
 	.alloc = chainiv_alloc,
-	.free = skcipher_geniv_free,
+	.free = chainiv_free,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
index f5def21..2a342c8 100644
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
@@ -163,17 +163,22 @@ static int eseqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct eseqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_ablkcipher_crt(geniv)->givencrypt != eseqiv_givencrypt_first)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = eseqiv_givencrypt;
-	get_random_bytes(ctx->salt, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return eseqiv_givencrypt(req);
 }
 
@@ -216,9 +221,13 @@ static struct crypto_instance *eseqiv_alloc(struct rtattr **tb)
 	struct crypto_instance *inst;
 	int err;
 
+	err = crypto_get_default_rng();
+	if (err)
+		return ERR_PTR(err);
+
 	inst = skcipher_geniv_alloc(&eseqiv_tmpl, tb, 0, 0);
 	if (IS_ERR(inst))
-		goto out;
+		goto put_rng;
 
 	err = -EINVAL;
 	if (inst->alg.cra_ablkcipher.ivsize != inst->alg.cra_blocksize)
@@ -238,13 +247,21 @@ out:
 free_inst:
 	skcipher_geniv_free(inst);
 	inst = ERR_PTR(err);
+put_rng:
+	crypto_put_default_rng();
 	goto out;
 }
 
+static void eseqiv_free(struct crypto_instance *inst)
+{
+	skcipher_geniv_free(inst);
+	crypto_put_default_rng();
+}
+
 static struct crypto_template eseqiv_tmpl = {
 	.name = "eseqiv",
 	.alloc = eseqiv_alloc,
-	.free = skcipher_geniv_free,
+	.free = eseqiv_free,
 	.module = THIS_MODULE,
 };
 
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index b903aab..5a013a8 100644
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
 
@@ -189,17 +189,22 @@ static int seqiv_givencrypt_first(struct skcipher_givcrypt_request *req)
 {
 	struct crypto_ablkcipher *geniv = skcipher_givcrypt_reqtfm(req);
 	struct seqiv_ctx *ctx = crypto_ablkcipher_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_ablkcipher_crt(geniv)->givencrypt != seqiv_givencrypt_first)
 		goto unlock;
 
 	crypto_ablkcipher_crt(geniv)->givencrypt = seqiv_givencrypt;
-	get_random_bytes(ctx->salt, crypto_ablkcipher_ivsize(geniv));
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_ablkcipher_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return seqiv_givencrypt(req);
 }
 
@@ -207,17 +212,22 @@ static int seqiv_aead_givencrypt_first(struct aead_givcrypt_request *req)
 {
 	struct crypto_aead *geniv = aead_givcrypt_reqtfm(req);
 	struct seqiv_ctx *ctx = crypto_aead_ctx(geniv);
+	int err = 0;
 
 	spin_lock_bh(&ctx->lock);
 	if (crypto_aead_crt(geniv)->givencrypt != seqiv_aead_givencrypt_first)
 		goto unlock;
 
 	crypto_aead_crt(geniv)->givencrypt = seqiv_aead_givencrypt;
-	get_random_bytes(ctx->salt, crypto_aead_ivsize(geniv));
+	err = crypto_rng_get_bytes(crypto_default_rng, ctx->salt,
+				   crypto_aead_ivsize(geniv));
 
 unlock:
 	spin_unlock_bh(&ctx->lock);
 
+	if (err)
+		return err;
+
 	return seqiv_aead_givencrypt(req);
 }
 
@@ -298,19 +308,27 @@ static struct crypto_instance *seqiv_alloc(struct rtattr **tb)
 	if (IS_ERR(algt))
 		return ERR_PTR(err);
 
+	err = crypto_get_default_rng();
+	if (err)
+		return ERR_PTR(err);
+
 	if ((algt->type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK)
 		inst = seqiv_ablkcipher_alloc(tb);
 	else
 		inst = seqiv_aead_alloc(tb);
 
 	if (IS_ERR(inst))
-		goto out;
+		goto put_rng;
 
 	inst->alg.cra_alignmask |= __alignof__(u32) - 1;
 	inst->alg.cra_ctxsize += sizeof(struct seqiv_ctx);
 
 out:
 	return inst;
+
+put_rng:
+	crypto_put_default_rng();
+	goto out;
 }
 
 static void seqiv_free(struct crypto_instance *inst)
@@ -319,6 +337,7 @@ static void seqiv_free(struct crypto_instance *inst)
 		skcipher_geniv_free(inst);
 	else
 		aead_geniv_free(inst);
+	crypto_put_default_rng();
 }
 
 static struct crypto_template seqiv_tmpl = {

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
