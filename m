From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] blkcipher: Add IV generation
Date: Sat, 29 Sep 2007 21:36:48 +0800
Message-ID: <20070929133648.GA3828@gondor.apana.org.au>
References: <20070929133450.GB3619@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2512 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752583AbXI2Ngv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Sep 2007 09:36:51 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IbcUz-0001jL-KG
	for <linux-crypto@vger.kernel.org>; Sat, 29 Sep 2007 23:36:49 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IbcUy-0000zy-00
	for <linux-crypto@vger.kernel.org>; Sat, 29 Sep 2007 21:36:48 +0800
Content-Disposition: inline
In-Reply-To: <20070929133450.GB3619@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

[CRYPTO] blkcipher: Remove alignment restriction on block size

Previously we assumed for convenience that the block size is a multiple of
the algorithm's required alignment.  With the pending addition of CTR this
will no longer be the case as the block size will be 1 due to it being a
stream cipher.  However, the alignment requirement will be that of the
underlying implementation which will most likely be greater than 1.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/algapi.c b/crypto/algapi.c
index d891f56..58cc191 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -63,9 +63,6 @@ static int crypto_check_alg(struct crypto_alg *alg)
 	if (alg->cra_alignmask & (alg->cra_alignmask + 1))
 		return -EINVAL;
 
-	if (alg->cra_alignmask & alg->cra_blocksize)
-		return -EINVAL;
-
 	if (alg->cra_blocksize > PAGE_SIZE / 8)
 		return -EINVAL;
 
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 1f8e9e5..ea9e240 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -149,6 +149,7 @@ static inline int blkcipher_next_slow(struct blkcipher_desc *desc,
 				      unsigned int alignmask)
 {
 	unsigned int n;
+	unsigned aligned_bsize = ALIGN(bsize, alignmask + 1);
 
 	if (walk->buffer)
 		goto ok;
@@ -167,8 +168,8 @@ ok:
 	walk->dst.virt.addr = (u8 *)ALIGN((unsigned long)walk->buffer,
 					  alignmask + 1);
 	walk->dst.virt.addr = blkcipher_get_spot(walk->dst.virt.addr, bsize);
-	walk->src.virt.addr = blkcipher_get_spot(walk->dst.virt.addr + bsize,
-						 bsize);
+	walk->src.virt.addr = blkcipher_get_spot(walk->dst.virt.addr +
+						 aligned_bsize, bsize);
 
 	scatterwalk_copychunks(walk->src.virt.addr, &walk->in, bsize, 0);
 
@@ -278,7 +279,9 @@ static inline int blkcipher_copy_iv(struct blkcipher_walk *walk,
 {
 	unsigned bs = crypto_blkcipher_blocksize(tfm);
 	unsigned int ivsize = crypto_blkcipher_ivsize(tfm);
-	unsigned int size = bs * 2 + ivsize + max(bs, ivsize) - (alignmask + 1);
+	unsigned aligned_bs = ALIGN(bs, alignmask + 1);
+	unsigned int size = aligned_bs * 2 + ivsize + max(aligned_bs, ivsize) -
+			    (alignmask + 1);
 	u8 *iv;
 
 	size += alignmask & ~(crypto_tfm_ctx_alignment() - 1);
@@ -287,8 +290,8 @@ static inline int blkcipher_copy_iv(struct blkcipher_walk *walk,
 		return -ENOMEM;
 
 	iv = (u8 *)ALIGN((unsigned long)walk->buffer, alignmask + 1);
-	iv = blkcipher_get_spot(iv, bs) + bs;
-	iv = blkcipher_get_spot(iv, bs) + bs;
+	iv = blkcipher_get_spot(iv, bs) + aligned_bs;
+	iv = blkcipher_get_spot(iv, bs) + aligned_bs;
 	iv = blkcipher_get_spot(iv, ivsize);
 
 	walk->iv = memcpy(iv, walk->iv, ivsize);
