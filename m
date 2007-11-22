From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/5] [CRYPTO] ctr: Use crypto_inc and crypto_xor
Date: Thu, 22 Nov 2007 16:37:49 +0800
Message-ID: <E1Iv7ZF-0001we-00@gondolin.me.apana.org.au>
References: <20071122083656.GB7368@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4612 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751053AbXKVIsE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:48:04 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7j5-0008A8-ET
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:48:00 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] ctr: Use crypto_inc and crypto_xor

This patch replaces the custom inc/xor in CTR with the generic functions.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/ctr.c |   71 +++++++++++++----------------------------------------------
 1 files changed, 16 insertions(+), 55 deletions(-)

diff --git a/crypto/ctr.c b/crypto/ctr.c
index b974a9f..b816e95 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -31,51 +31,6 @@ struct crypto_ctr_ctx {
 	u8 *nonce;
 };
 
-static inline void __ctr_inc_byte(u8 *a, unsigned int size)
-{
-	u8 *b = (a + size);
-	u8 c;
-
-	for (; size; size--) {
-		c = *--b + 1;
-		*b = c;
-		if (c)
-			break;
-	}
-}
-
-static void ctr_inc_quad(u8 *a, unsigned int size)
-{
-	__be32 *b = (__be32 *)(a + size);
-	u32 c;
-
-	for (; size >= 4; size -=4) {
-		c = be32_to_cpu(*--b) + 1;
-		*b = cpu_to_be32(c);
-		if (c)
-			return;
-	}
-
-	__ctr_inc_byte(a, size);
-}
-
-static void xor_byte(u8 *a, const u8 *b, unsigned int bs)
-{
-	for (; bs; bs--)
-		*a++ ^= *b++;
-}
-
-static void xor_quad(u8 *dst, const u8 *src, unsigned int bs)
-{
-	u32 *a = (u32 *)dst;
-	u32 *b = (u32 *)src;
-
-	for (; bs >= 4; bs -= 4)
-		*a++ ^= *b++;
-
-	xor_byte((u8 *)a, (u8 *)b, bs);
-}
-
 static int crypto_ctr_setkey(struct crypto_tfm *parent, const u8 *key,
 			     unsigned int keylen)
 {
@@ -111,7 +66,8 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	unsigned long alignmask = crypto_cipher_alignmask(tfm);
+	unsigned long alignmask = crypto_cipher_alignmask(tfm) |
+				  (__alignof__(u32) - 1);
 	u8 ks[bsize + alignmask];
 	u8 *keystream = (u8 *)ALIGN((unsigned long)ks, alignmask + 1);
 	u8 *src = walk->src.virt.addr;
@@ -121,13 +77,13 @@ static int crypto_ctr_crypt_segment(struct blkcipher_walk *walk,
 	do {
 		/* create keystream */
 		fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
-		xor_quad(keystream, src, min(nbytes, bsize));
+		crypto_xor(keystream, src, min(nbytes, bsize));
 
 		/* copy result into dst */
 		memcpy(dst, keystream, min(nbytes, bsize));
 
 		/* increment counter in counterblock */
-		ctr_inc_quad(ctrblk + (bsize - countersize), countersize);
+		crypto_inc(ctrblk + bsize - countersize, countersize);
 
 		if (nbytes < bsize)
 			break;
@@ -148,7 +104,8 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
 		   crypto_cipher_alg(tfm)->cia_encrypt;
 	unsigned int bsize = crypto_cipher_blocksize(tfm);
-	unsigned long alignmask = crypto_cipher_alignmask(tfm);
+	unsigned long alignmask = crypto_cipher_alignmask(tfm) |
+				  (__alignof__(u32) - 1);
 	unsigned int nbytes = walk->nbytes;
 	u8 *src = walk->src.virt.addr;
 	u8 ks[bsize + alignmask];
@@ -157,10 +114,10 @@ static int crypto_ctr_crypt_inplace(struct blkcipher_walk *walk,
 	do {
 		/* create keystream */
 		fn(crypto_cipher_tfm(tfm), keystream, ctrblk);
-		xor_quad(src, keystream, min(nbytes, bsize));
+		crypto_xor(src, keystream, min(nbytes, bsize));
 
 		/* increment counter in counterblock */
-		ctr_inc_quad(ctrblk + (bsize - countersize), countersize);
+		crypto_inc(ctrblk + bsize - countersize, countersize);
 
 		if (nbytes < bsize)
 			break;
@@ -184,7 +141,8 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 	unsigned int bsize = crypto_cipher_blocksize(child);
 	struct ctr_instance_ctx *ictx =
 		crypto_instance_ctx(crypto_tfm_alg_instance(&tfm->base));
-	unsigned long alignmask = crypto_cipher_alignmask(child);
+	unsigned long alignmask = crypto_cipher_alignmask(child) |
+				  (__alignof__(u32) - 1);
 	u8 cblk[bsize + alignmask];
 	u8 *counterblk = (u8 *)ALIGN((unsigned long)cblk, alignmask + 1);
 	int err;
@@ -198,8 +156,7 @@ static int crypto_ctr_crypt(struct blkcipher_desc *desc,
 	memcpy(counterblk + ictx->noncesize, walk.iv, ictx->ivsize);
 
 	/* initialize counter portion of counter block */
-	ctr_inc_quad(counterblk + (bsize - ictx->countersize),
-		     ictx->countersize);
+	crypto_inc(counterblk + bsize - ictx->countersize, ictx->countersize);
 
 	while (walk.nbytes) {
 		if (walk.src.virt.addr == walk.dst.virt.addr)
@@ -284,6 +241,10 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	    (countersize > alg->cra_blocksize) || (countersize < 4))
 		goto out_put_alg;
 
+	/* If this is false we'd fail the alignment of crypto_inc. */
+	if ((alg->cra_blocksize - countersize) % 4)
+		goto out_put_alg;
+
 	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!inst)
@@ -316,7 +277,7 @@ static struct crypto_instance *crypto_ctr_alloc(struct rtattr **tb)
 	inst->alg.cra_flags = CRYPTO_ALG_TYPE_BLKCIPHER;
 	inst->alg.cra_priority = alg->cra_priority;
 	inst->alg.cra_blocksize = 1;
-	inst->alg.cra_alignmask = 3;
+	inst->alg.cra_alignmask = __alignof__(u32) - 1;
 	inst->alg.cra_type = &crypto_blkcipher_type;
 
 	inst->alg.cra_blkcipher.ivsize = ivsize;
