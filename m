From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: hash - Fixed digest size check
Date: Mon, 7 Jul 2008 20:31:31 +0800
Message-ID: <20080707123131.GA12105@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34688 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753344AbYGGMbe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2008 08:31:34 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KFpsR-00056B-Kz
	for <linux-crypto@vger.kernel.org>; Mon, 07 Jul 2008 22:31:32 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KFpsR-00039W-00
	for <linux-crypto@vger.kernel.org>; Mon, 07 Jul 2008 20:31:31 +0800
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I'm going to add this patch to cryptodev-2.6:

commit cbc5176dbb8d80d50efa515d7f8bed90b1fdc922
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Jul 7 20:23:56 2008 +0800

    crypto: hash - Fixed digest size check
    
    The digest size check on hash algorithms is incorrect.  It's
    perfectly valid for hash algorithms to have a digest length
    longer than their block size.  For example crc32c has a block
    size of 1 and a digest size of 4.  Rather than having it lie
    about its block size, this patch fixes the checks to do what
    they really should which is to bound the digest size so that
    code placing the digest on the stack continue to work.
    
    HMAC however still needs to check this as it's only defined
    for such algorithms.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index a83e035..8c1f918 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -68,7 +68,7 @@ static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	struct ahash_alg *alg = &tfm->__crt_alg->cra_ahash;
 	struct ahash_tfm *crt   = &tfm->crt_ahash;
 
-	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
+	if (alg->digestsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	crt->init = alg->init;
diff --git a/crypto/digest.c b/crypto/digest.c
index 025c9ae..d63d5d9 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -141,7 +141,7 @@ int crypto_init_digest_ops(struct crypto_tfm *tfm)
 	struct hash_tfm *ops = &tfm->crt_hash;
 	struct digest_alg *dalg = &tfm->__crt_alg->cra_digest;
 
-	if (dalg->dia_digestsize > crypto_tfm_alg_blocksize(tfm))
+	if (dalg->dia_digestsize > PAGE_SIZE / 8)
 		return -EINVAL;
 	
 	ops->init	= init;
diff --git a/crypto/hash.c b/crypto/hash.c
index f9400a0..0d7caa9 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -152,7 +152,7 @@ static int crypto_init_hash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 {
 	struct hash_alg *alg = &tfm->__crt_alg->cra_hash;
 
-	if (alg->digestsize > crypto_tfm_alg_blocksize(tfm))
+	if (alg->digestsize > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	if ((mask & CRYPTO_ALG_TYPE_HASH_MASK) != CRYPTO_ALG_TYPE_HASH_MASK)
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 14c6351..7ff2d6a 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -226,6 +226,7 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 	struct crypto_instance *inst;
 	struct crypto_alg *alg;
 	int err;
+	int ds;
 
 	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_HASH);
 	if (err)
@@ -236,6 +237,13 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 	if (IS_ERR(alg))
 		return ERR_CAST(alg);
 
+	inst = ERR_PTR(-EINVAL);
+	ds = (alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	     CRYPTO_ALG_TYPE_HASH ? alg->cra_hash.digestsize :
+				    alg->cra_digest.dia_digestsize;
+	if (ds > alg->cra_blocksize)
+		goto out_put_alg;
+
 	inst = crypto_alloc_instance("hmac", alg);
 	if (IS_ERR(inst))
 		goto out_put_alg;
@@ -246,14 +254,10 @@ static struct crypto_instance *hmac_alloc(struct rtattr **tb)
 	inst->alg.cra_alignmask = alg->cra_alignmask;
 	inst->alg.cra_type = &crypto_hash_type;
 
-	inst->alg.cra_hash.digestsize =
-		(alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
-		CRYPTO_ALG_TYPE_HASH ? alg->cra_hash.digestsize :
-				       alg->cra_digest.dia_digestsize;
+	inst->alg.cra_hash.digestsize = ds;
 
 	inst->alg.cra_ctxsize = sizeof(struct hmac_ctx) +
-				ALIGN(inst->alg.cra_blocksize * 2 +
-				      inst->alg.cra_hash.digestsize,
+				ALIGN(inst->alg.cra_blocksize * 2 + ds,
 				      sizeof(void *));
 
 	inst->alg.cra_init = hmac_init_tfm;
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
