From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/6] crypto: SHA1 multibuffer map scatter gather walk's
 buffer address directly for x86_64
Date: Wed, 21 May 2014 21:05:04 +0800
Message-ID: <20140521130504.GA24401@gondor.apana.org.au>
References: <cover.1399990803.git.tim.c.chen@linux.intel.com>
 <1400023182.2970.238.camel@schen9-DESK>
 <20140513233410.GA28134@gondor.apana.org.au>
 <1400024458.2970.247.camel@schen9-DESK>
 <20140513235813.GA28455@gondor.apana.org.au>
 <1400177523.2970.267.camel@schen9-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58643 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUNFx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2014 09:05:53 -0400
Content-Disposition: inline
In-Reply-To: <1400177523.2970.267.camel@schen9-DESK>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 15, 2014 at 11:12:03AM -0700, Tim Chen wrote:
>
> > In which case your patch would basically do kmap if ASYNC and
> > kmap_atomic otherwise.
> > 
> > I'll try to make such a patch.

Please see attached.

> It will be nice if scatterwalk_map and unmap can also be made
> async aware. Right now it also uses kmap_atomic.
> This will allow multi-buffer encryption to make use of it.  

Is this for ciphers? Could you use ablkcipher_walk since it doesn't
actually map anything meaning that you can map it yourself?

commit 75ecb231ff45b54afa9f4ec9137965c3c00868f4
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed May 21 20:56:12 2014 +0800

    crypto: hash - Add real ahash walk interface
    
    Although the existing hash walk interface has already been used
    by a number of ahash crypto drivers, it turns out that none of
    them were really asynchronous.  They were all essentially polling
    for completion.
    
    That's why nobody has noticed until now that the walk interface
    couldn't work with a real asynchronous driver since the memory
    is mapped using kmap_atomic.
    
    As we now have a use-case for a real ahash implementation on x86,
    this patch creates a minimal ahash walk interface.  Basically it
    just calls kmap instead of kmap_atomic and does away with the
    crypto_yield call.  Real ahash crypto drivers don't need to yield
    since by definition they won't be hogging the CPU.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 6e72233..f2a5d8f 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -15,6 +15,7 @@
 
 #include <crypto/internal/hash.h>
 #include <crypto/scatterwalk.h>
+#include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -46,7 +47,10 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
-	walk->data = kmap_atomic(walk->pg);
+	if (walk->flags & CRYPTO_ALG_ASYNC)
+		walk->data = kmap(walk->pg);
+	else
+		walk->data = kmap_atomic(walk->pg);
 	walk->data += offset;
 
 	if (offset & alignmask) {
@@ -93,8 +97,16 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 		return nbytes;
 	}
 
-	kunmap_atomic(walk->data);
-	crypto_yield(walk->flags);
+	if (walk->flags & CRYPTO_ALG_ASYNC)
+		kunmap(walk->pg);
+	else {
+		kunmap_atomic(walk->data);
+		/*
+		 * The may sleep test only makes sense for sync users.
+		 * Async users don't need to sleep here anyway.
+		 */
+		crypto_yield(walk->flags);
+	}
 
 	if (err)
 		return err;
@@ -124,12 +136,31 @@ int crypto_hash_walk_first(struct ahash_request *req,
 
 	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
 	walk->sg = req->src;
-	walk->flags = req->base.flags;
+	walk->flags = req->base.flags & CRYPTO_TFM_REQ_MASK;
 
 	return hash_walk_new_entry(walk);
 }
 EXPORT_SYMBOL_GPL(crypto_hash_walk_first);
 
+int crypto_ahash_walk_first(struct ahash_request *req,
+			    struct crypto_hash_walk *walk)
+{
+	walk->total = req->nbytes;
+
+	if (!walk->total)
+		return 0;
+
+	walk->alignmask = crypto_ahash_alignmask(crypto_ahash_reqtfm(req));
+	walk->sg = req->src;
+	walk->flags = req->base.flags & CRYPTO_TFM_REQ_MASK;
+	walk->flags |= CRYPTO_ALG_ASYNC;
+
+	BUILD_BUG_ON(CRYPTO_TFM_REQ_MASK & CRYPTO_ALG_ASYNC);
+
+	return hash_walk_new_entry(walk);
+}
+EXPORT_SYMBOL_GPL(crypto_ahash_walk_first);
+
 int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 				  struct crypto_hash_walk *walk,
 				  struct scatterlist *sg, unsigned int len)
@@ -141,7 +172,7 @@ int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 
 	walk->alignmask = crypto_hash_alignmask(hdesc->tfm);
 	walk->sg = sg;
-	walk->flags = hdesc->flags;
+	walk->flags = hdesc->flags & CRYPTO_TFM_REQ_MASK;
 
 	return hash_walk_new_entry(walk);
 }
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 821eae8..9b6f32a 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -55,15 +55,28 @@ extern const struct crypto_type crypto_ahash_type;
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err);
 int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk);
+int crypto_ahash_walk_first(struct ahash_request *req,
+			   struct crypto_hash_walk *walk);
 int crypto_hash_walk_first_compat(struct hash_desc *hdesc,
 				  struct crypto_hash_walk *walk,
 				  struct scatterlist *sg, unsigned int len);
 
+static inline int crypto_ahash_walk_done(struct crypto_hash_walk *walk,
+					 int err)
+{
+	return crypto_hash_walk_done(walk, err);
+}
+
 static inline int crypto_hash_walk_last(struct crypto_hash_walk *walk)
 {
 	return !(walk->entrylen | walk->total);
 }
 
+static inline int crypto_ahash_walk_last(struct crypto_hash_walk *walk)
+{
+	return crypto_hash_walk_last(walk);
+}
+
 int crypto_register_ahash(struct ahash_alg *alg);
 int crypto_unregister_ahash(struct ahash_alg *alg);
 int ahash_register_instance(struct crypto_template *tmpl,

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
