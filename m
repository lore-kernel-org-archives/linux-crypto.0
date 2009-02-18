From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: shash - Handle failures in
	crypto_alloc_shash() correctly
Date: Wed, 18 Feb 2009 16:58:42 +0800
Message-ID: <20090218085842.GA28120@gondor.apana.org.au>
References: <alpine.LRH.2.00.0902171845420.13163@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40435 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751131AbZBRI6q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 03:58:46 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902171845420.13163@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 17, 2009 at 06:46:40PM +0100, Geert Uytterhoeven wrote:
> crypto_alloc_tfm() returns an error-valued pointer in case of failure,
> which must not be translated using __crypto_shash_cast().
> 
> Currently everything works fine because __crypto_shash_cast() is a no-op
> (crypto_shash.base is at offset zero).
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Thanks for the patch.  I think it's easier to just do the casting
in the underlying functions directly, like this:

commit 3f683d6175748ef9daf4698d9ef5a488dd037063
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Feb 18 16:56:59 2009 +0800

    crypto: api - Fix crypto_alloc_tfm/create_create_tfm return convention
    
    This is based on a report and patch by Geert Uytterhoeven.
    
    The functions crypto_alloc_tfm and create_create_tfm return a
    pointer that needs to be adjusted by the caller when successful
    and otherwise an error value.  This means that the caller has
    to check for the error and only perform the adjustment if the
    pointer returned is valid.
    
    Since all callers want to make the adjustment and we know how
    to adjust it ourselves, it's much easier to just return adjusted
    pointer directly.
    
    The only caveat is that we have to return a void * instead of
    struct crypto_tfm *.  However, this isn't that bad because both
    of these functions are for internal use only (by types code like
    shash.c, not even algorithms code).
    
    This patch also moves crypto_alloc_tfm into crypto/internal.h
    (crypto_create_tfm is already there) to reflect this.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/api.c b/crypto/api.c
index 56b6e0e..22385ca 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -453,8 +453,8 @@ err:
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
 
-struct crypto_tfm *crypto_create_tfm(struct crypto_alg *alg,
-				     const struct crypto_type *frontend)
+void *crypto_create_tfm(struct crypto_alg *alg,
+			const struct crypto_type *frontend)
 {
 	char *mem;
 	struct crypto_tfm *tfm = NULL;
@@ -488,9 +488,9 @@ out_free_tfm:
 		crypto_shoot_alg(alg);
 	kfree(mem);
 out_err:
-	tfm = ERR_PTR(err);
+	mem = ERR_PTR(err);
 out:
-	return tfm;
+	return mem;
 }
 EXPORT_SYMBOL_GPL(crypto_create_tfm);
 
@@ -514,12 +514,11 @@ EXPORT_SYMBOL_GPL(crypto_create_tfm);
  *
  *	In case of error the return value is an error pointer.
  */
-struct crypto_tfm *crypto_alloc_tfm(const char *alg_name,
-				    const struct crypto_type *frontend,
-				    u32 type, u32 mask)
+void *crypto_alloc_tfm(const char *alg_name,
+		       const struct crypto_type *frontend, u32 type, u32 mask)
 {
 	struct crypto_alg *(*lookup)(const char *name, u32 type, u32 mask);
-	struct crypto_tfm *tfm;
+	void *tfm;
 	int err;
 
 	type &= frontend->maskclear;
diff --git a/crypto/internal.h b/crypto/internal.h
index 3c19a27..fc76e1f 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -109,8 +109,10 @@ void crypto_alg_tested(const char *name, int err);
 void crypto_shoot_alg(struct crypto_alg *alg);
 struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 				      u32 mask);
-struct crypto_tfm *crypto_create_tfm(struct crypto_alg *alg,
-				     const struct crypto_type *frontend);
+void *crypto_create_tfm(struct crypto_alg *alg,
+			const struct crypto_type *frontend);
+void *crypto_alloc_tfm(const char *alg_name,
+		       const struct crypto_type *frontend, u32 type, u32 mask);
 
 int crypto_register_instance(struct crypto_template *tmpl,
 			     struct crypto_instance *inst);
diff --git a/crypto/shash.c b/crypto/shash.c
index 13a0dc1..7a65973 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -18,15 +18,10 @@
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 
-static const struct crypto_type crypto_shash_type;
-
-static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
-{
-	return container_of(tfm, struct crypto_shash, base);
-}
-
 #include "internal.h"
 
+static const struct crypto_type crypto_shash_type;
+
 static int shash_setkey_unaligned(struct crypto_shash *tfm, const u8 *key,
 				  unsigned int keylen)
 {
@@ -282,8 +277,7 @@ static int crypto_init_shash_ops_async(struct crypto_tfm *tfm)
 	if (!crypto_mod_get(calg))
 		return -EAGAIN;
 
-	shash = __crypto_shash_cast(crypto_create_tfm(
-		calg, &crypto_shash_type));
+	shash = crypto_create_tfm(calg, &crypto_shash_type);
 	if (IS_ERR(shash)) {
 		crypto_mod_put(calg);
 		return PTR_ERR(shash);
@@ -391,8 +385,7 @@ static int crypto_init_shash_ops_compat(struct crypto_tfm *tfm)
 	if (!crypto_mod_get(calg))
 		return -EAGAIN;
 
-	shash = __crypto_shash_cast(crypto_create_tfm(
-		calg, &crypto_shash_type));
+	shash = crypto_create_tfm(calg, &crypto_shash_type);
 	if (IS_ERR(shash)) {
 		crypto_mod_put(calg);
 		return PTR_ERR(shash);
@@ -480,8 +473,7 @@ static const struct crypto_type crypto_shash_type = {
 struct crypto_shash *crypto_alloc_shash(const char *alg_name, u32 type,
 					u32 mask)
 {
-	return __crypto_shash_cast(
-		crypto_alloc_tfm(alg_name, &crypto_shash_type, type, mask));
+	return crypto_alloc_tfm(alg_name, &crypto_shash_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_shash);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1f2e902..29729b8 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -548,9 +548,6 @@ struct crypto_attr_u32 {
  * Transform user interface.
  */
  
-struct crypto_tfm *crypto_alloc_tfm(const char *alg_name,
-				    const struct crypto_type *frontend,
-				    u32 type, u32 mask);
 struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask);
 void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
