From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Possible bug in CTR (and Salsa20) for large test vectors
Date: Mon, 26 Nov 2007 21:21:53 +0800
Message-ID: <20071126132153.GB27228@gondor.apana.org.au>
References: <fd3e431c0711241207u462cacdfre0ca957cd16a6b58@mail.gmail.com> <fd3e431c0711250758k6cbfa13fja73f5298a4c356f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto <linux-crypto@vger.kernel.org>
To: Tan Swee Heng <thesweeheng@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4383 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752853AbXKZNV7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 08:21:59 -0500
Content-Disposition: inline
In-Reply-To: <fd3e431c0711250758k6cbfa13fja73f5298a4c356f4@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 25, 2007 at 11:58:15PM +0800, Tan Swee Heng wrote:
> 
> It seems the CTR bug is due to crypto_ctr_crypt_inplace() and
> crypto_ctr_crypt_segment() always returning 0. For the 4096 bytes test
> case I previously described, they should return 8 when walk.nbytes =
> 4008 and refrain from processing the last 8 bytes. (This is based on
> my current understanding of blkcipher. I may be wrong.)

Thanks for the report and patch!

Here is my attempt at fixing it and optimising it a bit more.
The idea is that we should only process partial blocks when
we're at the end.  Otherwise we should do whole blocks.

Please let me know if this works or not.

Oh any chance you could post a tcrypt patch for the large test?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/ctr.c b/crypto/ctr.c
index b816e95..96a81ab 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -59,6 +59,21 @@ static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
 	return err;
 }
 
+static void crypto_ctr_crypt_final(struct blkcipher_walk *walk,
+				   struct crypto_cipher *tfm, u8 *ctrblk,
+				   unsigned int countersize)
+{
+	unsigned int bsize = crypto_cipher_blocksize(tfm);
+	u8 *keystream = ctrblk + bsize;
+	u8 *src = walk->src.virt.addr;
+	u8 *dst = walk->dst.virt.addr;
+	unsigned int nbytes = walk->nbytes;
+
+	crypto_cipher_encrypt_one(tfm, keystream, ctrblk);
+	crypto_xor(keystream, src, nbytes);
+	memcpy(dst, keystream, nbytes);
+}
+
 static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 				    struct crypto_cipher *tfm, u8 *ctrblk,
 				    unsigned int countersize)
@@ -66,33 +81,21 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	unsigned long alignmask = crypto_cipher_alignmask(tfm) |
-				  (__alignof__(u32) - 1);
-	u8 ks[bsize + alignmask];
-	u8 *keystream = (u8 *)ALIGN((unsigned long)ks, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
 	u8 *dst = walk->dst.virt.addr;
 	unsigned int nbytes = walk->nbytes;
 
 	do {
 		/* create keystream */
-		fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
-		crypto_xor(keystream, src, min(nbytes, bsize));
-
-		/* copy result into dst */
-		memcpy(dst, keystream, min(nbytes, bsize));
+		fn(crypto_cipher_tfm(tfm), dst, ctrblk);
+		crypto_xor(dst, src, bsize);
 
 		/* increment counter in counterblock */
 		crypto_inc(ctrblk + bsize - countersize, countersize);
 
-		if (nbytes < bsize)
-			break;
-
 		src += bsize;
 		dst += bsize;
-		nbytes -= bsize;
-
-	} while (nbytes);
+	} while ((nbytes -= bsize) >= bsize);
 
 	return 0;
 }
@@ -104,28 +107,20 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	unsigned long alignmask = crypto_cipher_alignmask(tfm) |
-				  (__alignof__(u32) - 1);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
-	u8 ks[bsize + alignmask];
-	u8 *keystream = (u8 *)ALIGN((unsigned long)ks, alignmask + 1);
+	u8 *keystream = ctrblk + bsize;
 
 	do {
 		/* create keystream */
 		fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
-		crypto_xor(src, keystream, min(nbytes, bsize));
+		crypto_xor(src, keystream, bsize);
 
 		/* increment counter in counterblock */
 		crypto_inc(ctrblk + bsize - countersize, countersize);
 
-		if (nbytes < bsize)
-			break;
-
 		src += bsize;
-		nbytes -= bsize;
-
-	} while (nbytes);
+	} while ((nbytes -= bsize) >= bsize);
 
 	return 0;
 }
@@ -143,7 +138,7 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 		crypto_instance_ctx(crypto_tfm_alg_instance(&tfm->base));
 	unsigned long alignmask = crypto_cipher_alignmask(child) |
 				  (__alignof__(u32) - 1);
-	u8 cblk[bsize + alignmask];
+	u8 cblk[bsize * 2 + alignmask];
 	u8 *counterblk = (u8 *)ALIGN((unsigned long)cblk, alignmask + 1);
 	int err;
 
@@ -158,7 +153,7 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 	/* initialize counter portion of counter block */
 	crypto_inc(counterblk + bsize - ictx->countersize, ictx->countersize);
 
-	while (walk.nbytes) {
+	while (walk.nbytes >= bsize) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
 			nbytes = crypto_ctr_crypt_inplace(&walk, child,
 							  counterblk,
@@ -170,6 +165,13 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
+
+	if (walk.nbytes) {
+		crypto_ctr_crypt_final(&walk, child, counterblk,
+				       ictx->countersize);
+		err = blkcipher_walk_done(desc, &walk, nbytes);
+	}
+
 	return err;
 }
 
@@ -277,7 +279,7 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
 	inst->alg.cra_priority = alg->cra_priority;
 	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = __alignof__(u32) - 1;
+	inst->alg.cra_alignmask = alg->cra_alignmask | (__alignof__(u32) - 1);
 	inst->alg.cra_type = &crypto_blkcipher_type;
 
 	inst->alg.cra_blkcipher.ivsize = ivsize;
