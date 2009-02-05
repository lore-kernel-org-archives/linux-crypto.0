From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: zeroing tfms in crypto_free_tfm()
Date: Thu, 5 Feb 2009 16:54:37 +1100
Message-ID: <20090205055437.GF22749@gondor.apana.org.au>
References: <alpine.LRH.2.00.0902041606460.29216@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51746 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752265AbZBEFyo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Feb 2009 00:54:44 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902041606460.29216@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 04, 2009 at 04:09:04PM +0100, Geert Uytterhoeven wrote:
>
> However, in the mean time, the allocation mechanism for crypto_tfm objects has
> been changed twice, by:
>   1. commit fbdae9f3e7fb57c07cb0d973f113eb25da2e8ff2 ("[CRYPTO] Ensure cit_iv
>      is aligned correctly"), which replaced "alg->cra_ctxsize" by
>      "crypto_ctxsize(alg, flags)" in crypto_alloc_tfm(),
>   2. commit 7b0bac64cd5b74d6f1147524c26216de13a501fd ("crypto: api - Rebirth of
>      crypto_alloc_tfm"), which introduced the alternative crypto_create_tfm(),
>      where the memory requirements are based on
>      "frontend->extsize(alg, frontend)" instead of "alg->cra_ctxsize".

Good catch.  In fact we've been freeing the wrong pointer with
shash all along.  I wonder how it avoided crashing.

I'm going to add these to commits to fix them.

commit 412e87ae5d852bc3d836f475c19d954b3324363d
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Feb 5 16:51:25 2009 +1100

    crypto: shash - Fix tfm destruction
    
    We were freeing an offset into the slab object instead of the
    start.  This patch fixes it by calling crypto_destroy_tfm which
    allows the correct address to be given.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index cd16d6e..d797e11 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -222,7 +222,7 @@ static inline struct crypto_tfm *crypto_shash_tfm(struct crypto_shash *tfm)
 
 static inline void crypto_free_shash(struct crypto_shash *tfm)
 {
-	crypto_free_tfm(crypto_shash_tfm(tfm));
+	crypto_destroy_tfm(tfm, crypto_shash_tfm(tfm));
 }
 
 static inline unsigned int crypto_shash_alignmask(

commit 7b2cd92adc5430b0c1adeb120971852b4ea1ab08
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Feb 5 16:48:24 2009 +1100

    crypto: api - Fix zeroing on free
    
    Geert Uytterhoeven pointed out that we're not zeroing all the
    memory when freeing a transform.  This patch fixes it by calling
    ksize to ensure that we zero everything in sight.
    
    Reported-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/api.c b/crypto/api.c
index 9975a7b..efe77df 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -557,34 +557,34 @@ err:
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
- 
+
 /*
- *	crypto_free_tfm - Free crypto transform
+ *	crypto_destroy_tfm - Free crypto transform
+ *	@mem: Start of tfm slab
  *	@tfm: Transform to free
  *
- *	crypto_free_tfm() frees up the transform and any associated resources,
+ *	This function frees up the transform and any associated resources,
  *	then drops the refcount on the associated algorithm.
  */
-void crypto_free_tfm(struct crypto_tfm *tfm)
+void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm)
 {
 	struct crypto_alg *alg;
 	int size;
 
-	if (unlikely(!tfm))
+	if (unlikely(!mem))
 		return;
 
 	alg = tfm->__crt_alg;
-	size = sizeof(*tfm) + alg->cra_ctxsize;
+	size = ksize(mem);
 
 	if (!tfm->exit && alg->cra_exit)
 		alg->cra_exit(tfm);
 	crypto_exit_ops(tfm);
 	crypto_mod_put(alg);
-	memset(tfm, 0, size);
-	kfree(tfm);
+	memset(mem, 0, size);
+	kfree(mem);
 }
-
-EXPORT_SYMBOL_GPL(crypto_free_tfm);
+EXPORT_SYMBOL_GPL(crypto_destroy_tfm);
 
 int crypto_has_alg(const char *name, u32 type, u32 mask)
 {
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 3bacd71..1f2e902 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -552,7 +552,12 @@ struct crypto_tfm *crypto_alloc_tfm(const char *alg_name,
 				    const struct crypto_type *frontend,
 				    u32 type, u32 mask);
 struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask);
-void crypto_free_tfm(struct crypto_tfm *tfm);
+void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm);
+
+static inline void crypto_free_tfm(struct crypto_tfm *tfm)
+{
+	return crypto_destroy_tfm(tfm, tfm);
+}
 
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
