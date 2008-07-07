From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: hash - Removed bogus ahash base field
Date: Mon, 7 Jul 2008 20:55:56 +0800
Message-ID: <20080707125556.GA12387@gondor.apana.org.au>
References: <20080707124748.GA12291@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37885 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751833AbYGGMz7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2008 08:55:59 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian))
	id 1KFqG4-0005SR-Or
	for <linux-crypto@vger.kernel.org>; Mon, 07 Jul 2008 22:55:57 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1KFqG4-0003E6-00
	for <linux-crypto@vger.kernel.org>; Mon, 07 Jul 2008 20:55:56 +0800
Content-Disposition: inline
In-Reply-To: <20080707124748.GA12291@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 07, 2008 at 08:47:48PM +0800, Herbert Xu wrote:
> Hi:
> 
> Here's a fix on the ahash stuff for cryptodev-2.6:
> 
> commit 636e6a699b27fa2776b821b12d3773c2b03e9101
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Mon Jul 7 20:46:11 2008 +0800
> 
>     crypto: hash - Removed bogus ahash base field

Found another useless field, so here is an updated patch:

commit fa782d685942e182d6e33a4b5b908ab524c05c70
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Mon Jul 7 20:54:35 2008 +0800

    crypto: hash - Removed vestigial ahash fields
    
    The base field in ahash_tfm appears to have been cut-n-pasted from
    ablkcipher.  It isn't needed here at all.  Similarly, the info field
    in ahash_request also appears to have originated from its cipher
    counter-part and is vestigial.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 8c1f918..e6e5906 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -76,7 +76,6 @@ static int crypto_init_ahash_ops(struct crypto_tfm *tfm, u32 type, u32 mask)
 	crt->final  = alg->final;
 	crt->digest = alg->digest;
 	crt->setkey = ahash_setkey;
-	crt->base   = __crypto_ahash_cast(tfm);
 	crt->digestsize = alg->digestsize;
 
 	return 0;
diff --git a/crypto/digest.c b/crypto/digest.c
index d63d5d9..bf33298 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -234,7 +234,6 @@ int crypto_init_digest_ops_async(struct crypto_tfm *tfm)
 	crt->setkey     = dalg->dia_setkey ? digest_async_setkey :
 						digest_async_nosetkey;
 	crt->digestsize = dalg->dia_digestsize;
-	crt->base       = __crypto_ahash_cast(tfm);
 
 	return 0;
 }
diff --git a/crypto/hash.c b/crypto/hash.c
index 0d7caa9..140a755 100644
--- a/crypto/hash.c
+++ b/crypto/hash.c
@@ -128,7 +128,6 @@ static int crypto_init_hash_ops_async(struct crypto_tfm *tfm)
 	crt->digest     = hash_async_digest;
 	crt->setkey     = hash_async_setkey;
 	crt->digestsize = alg->digestsize;
-	crt->base       = __crypto_ahash_cast(tfm);
 
 	return 0;
 }
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b6efe56..68ef293 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -137,8 +137,6 @@ struct ablkcipher_request {
 struct ahash_request {
 	struct crypto_async_request base;
 
-	void *info;
-
 	unsigned int nbytes;
 	struct scatterlist *src;
 	u8		   *result;
@@ -420,7 +418,6 @@ struct ahash_tfm {
 			unsigned int keylen);
 
 	unsigned int digestsize;
-	struct crypto_ahash *base;
 	unsigned int reqsize;
 };
 
@@ -1384,7 +1381,7 @@ static inline int crypto_ahash_setkey(struct crypto_ahash *tfm,
 {
 	struct ahash_tfm *crt = crypto_ahash_crt(tfm);
 
-	return crt->setkey(crt->base, key, keylen);
+	return crt->setkey(tfm, key, keylen);
 }
 
 static inline int crypto_ahash_digest(struct ahash_request *req)
@@ -1396,7 +1393,7 @@ static inline int crypto_ahash_digest(struct ahash_request *req)
 static inline void ahash_request_set_tfm(struct ahash_request *req,
 					 struct crypto_ahash *tfm)
 {
-	req->base.tfm = crypto_ahash_tfm(crypto_ahash_crt(tfm)->base);
+	req->base.tfm = crypto_ahash_tfm(tfm);
 }
 
 static inline struct ahash_request *ahash_request_alloc(

-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
