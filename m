From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1]: Revised CTR mode implementation
Date: Thu, 4 Oct 2007 15:27:46 +0800
Message-ID: <20071004072746.GB22945@gondor.apana.org.au>
References: <200710020547.l925l9in011560@faith.austin.ibm.com> <20071003102149.GA8203@gondor.apana.org.au> <1191453429.2477.162.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tgraf@redhat.com
To: Joy Latten <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1335 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753731AbXJDH1t (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Oct 2007 03:27:49 -0400
Content-Disposition: inline
In-Reply-To: <1191453429.2477.162.camel@faith.austin.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 03, 2007 at 06:17:08PM -0500, Joy Latten wrote:
>
> Since the last block of data to CTR may be a partial block, I changed
> the following in crypto_ctr_crypt_segment(),

Good catch.  In that case we can probably merge in_place and
_segment into one function.

> while (walk.nbytes) {
>                 if (walk.src.virt.addr == walk.dst.virt.addr)
>                         nbytes = crypto_ctr_crypt_inplace(&walk, ctx,
>                                                           counterblk,
>                                                           countersize);
>                 else
>                         nbytes = crypto_ctr_crypt_segment(&walk, ctx
>                                                           counterblk,
>                                                           countersize);
> 
>                 err = blkcipher_walk_done(desc, &walk, nbytes);
>         }
> 
> I assumed that if there is a partial block, it will occur at the
> very end of all the data. However, looking at this loop, I wondered

Good point.  We need to change the blkcipher helper so that it
lets you walk by a specified block size instead of the block
size of the algorithm.

The following patch should let you get the desired result if
you call blkcipher_walk_virt_block and specify the underlying
block size.

> > > +	u8 counterblk[bsize];
> > 
> > This needs to be aligned by the underlying mask and at least 4.
> > 
> Ok, sorry I missed that.
> However, I don't understand what the check 
> for 4 is for... my bsize should be at least 4?

Depending on the compiler a u8 might only be byte-aligned
regardless of its size.

The 4 is because xor/ctr_inc will access the data in words.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
[CRYPTO] blkcipher: Added blkcipher_walk_virt_block

This patch adds the helper blkcipher_walk_virt_block which is similar to
blkcipher_walk_virt but uses a supplied block size instead of the block
size of the block cipher.  This is useful for CTR where the block size is
1 but we still want to walk by the block size of the underlying cipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 1b2a14a..77ee73b 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -84,8 +84,6 @@ static inline unsigned int blkcipher_done_slow(struct crypto_blkcipher *tfm,
 static inline unsigned int blkcipher_done_fast(struct blkcipher_walk *walk,
 					       unsigned int n)
 {
-	n = walk->nbytes - n;
-
 	if (walk->flags & BLKCIPHER_WALK_COPY) {
 		blkcipher_map_dst(walk);
 		memcpy(walk->dst.virt.addr, walk->page, n);
@@ -109,13 +107,15 @@ int blkcipher_walk_done(struct blkcipher_desc *desc,
 	unsigned int nbytes = 0;
 
 	if (likely(err >= 0)) {
-		unsigned int bsize = crypto_blkcipher_blocksize(tfm);
-		unsigned int n;
+		unsigned int n = walk->nbytes - err;
 
 		if (likely(!(walk->flags & BLKCIPHER_WALK_SLOW)))
-			n = blkcipher_done_fast(walk, err);
-		else
-			n = blkcipher_done_slow(tfm, walk, bsize);
+			n = blkcipher_done_fast(walk, n);
+		else if (WARN_ON(err)) {
+			err = -EINVAL;
+			goto err;
+		} else
+			n = blkcipher_done_slow(tfm, walk, n);
 
 		nbytes = walk->total - n;
 		err = 0;
@@ -132,6 +132,7 @@ int blkcipher_walk_done(struct blkcipher_desc *desc,
 		return blkcipher_walk_next(desc, walk);
 	}
 
+err:
 	if (walk->iv != desc->info)
 		memcpy(desc->info, walk->iv, crypto_blkcipher_ivsize(tfm));
 	if (walk->buffer != walk->page)
@@ -225,12 +226,12 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
 {
 	struct crypto_blkcipher *tfm = desc->tfm;
 	unsigned int alignmask = crypto_blkcipher_alignmask(tfm);
-	unsigned int bsize = crypto_blkcipher_blocksize(tfm);
+	unsigned int bsize;
 	unsigned int n;
 	int err;
 
 	n = walk->total;
-	if (unlikely(n < bsize)) {
+	if (unlikely(n < crypto_blkcipher_blocksize(tfm))) {
 		desc->flags |= CRYPTO_TFM_RES_BAD_BLOCK_LEN;
 		return blkcipher_walk_done(desc, walk, -EINVAL);
 	}
@@ -247,6 +248,7 @@ static int blkcipher_walk_next(struct blkcipher_desc *desc,
 		}
 	}
 
+	bsize = min(walk->blocksize, n);
 	n = scatterwalk_clamp(&walk->in, n);
 	n = scatterwalk_clamp(&walk->out, n);
 
@@ -277,7 +279,7 @@ static inline int blkcipher_copy_iv(struct blkcipher_walk *walk,
 				    struct crypto_blkcipher *tfm,
 				    unsigned int alignmask)
 {
-	unsigned bs = crypto_blkcipher_blocksize(tfm);
+	unsigned bs = walk->blocksize;
 	unsigned int ivsize = crypto_blkcipher_ivsize(tfm);
 	unsigned aligned_bs = ALIGN(bs, alignmask + 1);
 	unsigned int size = aligned_bs * 2 + ivsize + max(aligned_bs, ivsize) -
@@ -302,6 +304,7 @@ int blkcipher_walk_virt(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk)
 {
 	walk->flags &= ~BLKCIPHER_WALK_PHYS;
+	walk->blocksize = crypto_blkcipher_blocksize(desc->tfm);
 	return blkcipher_walk_first(desc, walk);
 }
 EXPORT_SYMBOL_GPL(blkcipher_walk_virt);
@@ -310,6 +313,7 @@ int blkcipher_walk_phys(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk)
 {
 	walk->flags |= BLKCIPHER_WALK_PHYS;
+	walk->blocksize = crypto_blkcipher_blocksize(desc->tfm);
 	return blkcipher_walk_first(desc, walk);
 }
 EXPORT_SYMBOL_GPL(blkcipher_walk_phys);
@@ -342,6 +346,16 @@ static int blkcipher_walk_first(struct blkcipher_desc *desc,
 	return blkcipher_walk_next(desc, walk);
 }
 
+int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
+			      struct blkcipher_walk *walk,
+			      unsigned int blocksize)
+{
+	walk->flags &= ~BLKCIPHER_WALK_PHYS;
+	walk->blocksize = blocksize;
+	return blkcipher_walk_first(desc, walk);
+}
+EXPORT_SYMBOL_GPL(blkcipher_walk_virt_block);
+
 static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
 			    unsigned int keylen)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 4af72dc..b9b05d3 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -91,6 +91,7 @@ struct blkcipher_walk {
 	u8 *iv;
 
 	int flags;
+	unsigned int blocksize;
 };
 
 extern const struct crypto_type crypto_ablkcipher_type;
@@ -129,6 +130,9 @@ int blkcipher_walk_virt(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk);
 int blkcipher_walk_phys(struct blkcipher_desc *desc,
 			struct blkcipher_walk *walk);
+int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
+			      struct blkcipher_walk *walk,
+			      unsigned int blocksize);
 
 static inline void *crypto_tfm_ctx_aligned(struct crypto_tfm *tfm)
 {
