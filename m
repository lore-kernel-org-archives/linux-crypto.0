From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: LRW endian issues?
Date: Wed, 18 Feb 2009 21:44:51 +0800
Message-ID: <20090218134451.GA29520@gondor.apana.org.au>
References: <20090206040124.GA4299@gondor.apana.org.au> <alpine.LRH.2.00.0902061117570.26894@vixen.sonytel.be> <20090210120218.GA23234@gondor.apana.org.au> <alpine.LRH.2.00.0902121629480.29413@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: rsnel@cube.dyndns.org, linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42446 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750859AbZBRNo6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 08:44:58 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902121629480.29413@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 12, 2009 at 04:30:11PM +0100, Geert Uytterhoeven wrote:
>
> > Thanks, could you try this patch?
> 
> Unfortunately it doesn't seem to make any difference.

Thanks for testing.  I've reproduced the problem here and this
is the fix I've come up with.

commit 6fe4a28d8855e072036f36ee22f0a8f43f44918f
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Feb 18 21:41:29 2009 +0800

    crypto: testmgr - Test skciphers with no IVs
    
    As it is an skcipher with no IV escapes testing altogether because
    we only test givcipher objects.  This patch fixes the bypass logic
    to test these algorithms.
    
    Conversely, we're currently testing nivaead algorithms with IVs,
    which would have deadlocked had it not been for the fact that no
    nivaead algorithms have any test vectors.  This patch also fixes
    that case.
    
    Both fixes are ugly as hell, but this ugliness should hopefully
    disappear once we move them into the per-type code (i.e., the
    AEAD test would live in aead.c and the skcipher stuff in ablkcipher.c).
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 4601e42..6906f92 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -10,7 +10,7 @@
  *
  */
 
-#include <linux/crypto.h>
+#include <crypto/internal/aead.h>
 #include <linux/ctype.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -206,8 +206,7 @@ static int cryptomgr_test(void *data)
 	u32 type = param->type;
 	int err = 0;
 
-	if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
-	      CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV))
+	if (type & CRYPTO_ALG_TESTED)
 		goto skiptest;
 
 	err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);
@@ -223,6 +222,7 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 {
 	struct task_struct *thread;
 	struct crypto_test_param *param;
+	u32 type;
 
 	if (!try_module_get(THIS_MODULE))
 		goto err;
@@ -233,7 +233,19 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
 
 	memcpy(param->driver, alg->cra_driver_name, sizeof(param->driver));
 	memcpy(param->alg, alg->cra_name, sizeof(param->alg));
-	param->type = alg->cra_flags;
+	type = alg->cra_flags;
+
+	/* This piece of crap needs to disappear into per-type test hooks. */
+	if ((!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
+	       CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
+	     ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	      CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
+					  alg->cra_ablkcipher.ivsize)) ||
+	    (!((type ^ CRYPTO_ALG_TYPE_AEAD) & CRYPTO_ALG_TYPE_MASK) &&
+	     alg->cra_type == &crypto_nivaead_type && alg->cra_aead.ivsize))
+		type |= CRYPTO_ALG_TESTED;
+
+	param->type = type;
 
 	thread = kthread_run(cryptomgr_test, param, "cryptomgr_test");
 	if (IS_ERR(thread))

commit 5852ae42424e3ddba2d3bdf594f72189497f17ee
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Feb 18 20:41:47 2009 +0800

    crypto: aead - Avoid infinite loop when nivaead fails selftest
    
    When an aead constructed through crypto_nivaead_default fails
    its selftest, we'll loop forever trying to construct new aead
    objects but failing because it already exists.
    
    The crux of the issue is that once an aead fails the selftest,
    we'll ignore it on the next run through crypto_aead_lookup and
    attempt to construct a new aead.
    
    We should instead return an error to the caller if we find an
    an that has failed the test.
    
    This bug hasn't manifested itself yet because we don't have any
    test vectors for the existing nivaead algorithms.  They're tested
    through the underlying algorithms only.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/aead.c b/crypto/aead.c
index 3a6f3f5..d9aa733 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -422,6 +422,22 @@ static struct crypto_alg *crypto_lookup_aead(const char *name, u32 type,
 	if (!alg->cra_aead.ivsize)
 		return alg;
 
+	crypto_mod_put(alg);
+	alg = crypto_alg_mod_lookup(name, type | CRYPTO_ALG_TESTED,
+				    mask & ~CRYPTO_ALG_TESTED);
+	if (IS_ERR(alg))
+		return alg;
+
+	if (alg->cra_type == &crypto_aead_type) {
+		if ((alg->cra_flags ^ type ^ ~mask) & CRYPTO_ALG_TESTED) {
+			crypto_mod_put(alg);
+			alg = ERR_PTR(-ENOENT);
+		}
+		return alg;
+	}
+
+	BUG_ON(!alg->cra_aead.ivsize);
+
 	return ERR_PTR(crypto_nivaead_default(alg, type, mask));
 }
 

commit b170a137f467ea951c3f256da1b911545acf3ffd
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Feb 18 20:33:55 2009 +0800

    crypto: skcipher - Avoid infinite loop when cipher fails selftest
    
    When an skcipher constructed through crypto_givcipher_default fails
    its selftest, we'll loop forever trying to construct new skcipher
    objects but failing because it already exists.
    
    The crux of the issue is that once a givcipher fails the selftest,
    we'll ignore it on the next run through crypto_skcipher_lookup and
    attempt to construct a new givcipher.
    
    We should instead return an error to the caller if we find a
    givcipher that has failed the test.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
index 94140b3..e11ce37 100644
--- a/crypto/ablkcipher.c
+++ b/crypto/ablkcipher.c
@@ -282,6 +282,25 @@ static struct crypto_alg *crypto_lookup_skcipher(const char *name, u32 type,
 					  alg->cra_ablkcipher.ivsize))
 		return alg;
 
+	crypto_mod_put(alg);
+	alg = crypto_alg_mod_lookup(name, type | CRYPTO_ALG_TESTED,
+				    mask & ~CRYPTO_ALG_TESTED);
+	if (IS_ERR(alg))
+		return alg;
+
+	if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_GIVCIPHER) {
+		if ((alg->cra_flags ^ type ^ ~mask) & CRYPTO_ALG_TESTED) {
+			crypto_mod_put(alg);
+			alg = ERR_PTR(-ENOENT);
+		}
+		return alg;
+	}
+
+	BUG_ON(!((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+		 CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
+					     alg->cra_ablkcipher.ivsize));
+
 	return ERR_PTR(crypto_givcipher_default(alg, type, mask));
 }
 
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index d70a41c..90d26c9 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -521,7 +521,7 @@ static int crypto_grab_nivcipher(struct crypto_skcipher_spawn *spawn,
 	int err;
 
 	type = crypto_skcipher_type(type);
-	mask = crypto_skcipher_mask(mask) | CRYPTO_ALG_GENIV;
+	mask = crypto_skcipher_mask(mask)| CRYPTO_ALG_GENIV;
 
 	alg = crypto_alg_mod_lookup(name, type, mask);
 	if (IS_ERR(alg))

commit ff753308d2f70f210ba468492cd9a01274d9d7ce
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Feb 17 20:18:34 2009 +0800

    crypto: api - crypto_alg_mod_lookup either tested or untested
    
    As it stands crypto_alg_mod_lookup will search either tested or
    untested algorithms, but never both at the same time.  However,
    we need exactly that when constructing givcipher and aead so
    this patch adds support for that by setting the tested bit in
    type but clearing it in mask.  This combination is currently
    unused.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/api.c b/crypto/api.c
index efe77df..56b6e0e 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -244,7 +244,7 @@ struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 type, u32 mask)
 	struct crypto_alg *larval;
 	int ok;
 
-	if (!(mask & CRYPTO_ALG_TESTED)) {
+	if (!((type | mask) & CRYPTO_ALG_TESTED)) {
 		type |= CRYPTO_ALG_TESTED;
 		mask |= CRYPTO_ALG_TESTED;
 	}

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
