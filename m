From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH] crypto: skcipher - introduce walksize attribute for SIMD algos
Date: Thu, 29 Dec 2016 14:09:08 +0000
Message-ID: <1483020548-19233-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38128 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbcL2OJQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2016 09:09:16 -0500
Received: by mail-wm0-f43.google.com with SMTP id k184so138032433wme.1
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2016 06:09:15 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In some cases, SIMD algorithms can only perform optimally when
allowed to operate on multiple input blocks in parallel. This is
especially true for bit slicing algorithms, which typically take
the same amount of time processing a single block or 8 blocks in
parallel. However, other SIMD algorithms may benefit as well from
bigger strides.

So add a walksize attribute to the skcipher algorithm definition, and
wire it up to the skcipher walk API. To avoid confusion between the
skcipher and AEAD attributes, rename the skcipher_walk chunksize
attribute to 'stride', and set it from the walksize (in the skcipher
case) or from the chunksize (in the AEAD case).

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/skcipher.c                  | 20 +++++++-----
 include/crypto/internal/skcipher.h |  2 +-
 include/crypto/skcipher.h          | 34 ++++++++++++++++++++
 3 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index aca07c643d41..7570d7c958e8 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -185,12 +185,12 @@ void skcipher_walk_complete(struct skcipher_walk *walk, int err)
 		data = p->data;
 		if (!data) {
 			data = PTR_ALIGN(&p->buffer[0], walk->alignmask + 1);
-			data = skcipher_get_spot(data, walk->chunksize);
+			data = skcipher_get_spot(data, walk->stride);
 		}
 
 		scatterwalk_copychunks(data, &p->dst, p->len, 1);
 
-		if (offset_in_page(p->data) + p->len + walk->chunksize >
+		if (offset_in_page(p->data) + p->len + walk->stride >
 		    PAGE_SIZE)
 			free_page((unsigned long)p->data);
 
@@ -297,7 +297,7 @@ static int skcipher_next_copy(struct skcipher_walk *walk)
 	p->len = walk->nbytes;
 	skcipher_queue_write(walk, p);
 
-	if (offset_in_page(walk->page) + walk->nbytes + walk->chunksize >
+	if (offset_in_page(walk->page) + walk->nbytes + walk->stride >
 	    PAGE_SIZE)
 		walk->page = NULL;
 	else
@@ -342,7 +342,7 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 			 SKCIPHER_WALK_DIFF);
 
 	n = walk->total;
-	bsize = min(walk->chunksize, max(n, walk->blocksize));
+	bsize = min(walk->stride, max(n, walk->blocksize));
 	n = scatterwalk_clamp(&walk->in, n);
 	n = scatterwalk_clamp(&walk->out, n);
 
@@ -391,7 +391,7 @@ static int skcipher_copy_iv(struct skcipher_walk *walk)
 	unsigned a = crypto_tfm_ctx_alignment() - 1;
 	unsigned alignmask = walk->alignmask;
 	unsigned ivsize = walk->ivsize;
-	unsigned bs = walk->chunksize;
+	unsigned bs = walk->stride;
 	unsigned aligned_bs;
 	unsigned size;
 	u8 *iv;
@@ -461,7 +461,7 @@ static int skcipher_walk_skcipher(struct skcipher_walk *walk,
 		       SKCIPHER_WALK_SLEEP : 0;
 
 	walk->blocksize = crypto_skcipher_blocksize(tfm);
-	walk->chunksize = crypto_skcipher_chunksize(tfm);
+	walk->stride = crypto_skcipher_walksize(tfm);
 	walk->ivsize = crypto_skcipher_ivsize(tfm);
 	walk->alignmask = crypto_skcipher_alignmask(tfm);
 
@@ -523,7 +523,7 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 		walk->flags &= ~SKCIPHER_WALK_SLEEP;
 
 	walk->blocksize = crypto_aead_blocksize(tfm);
-	walk->chunksize = crypto_aead_chunksize(tfm);
+	walk->stride = crypto_aead_chunksize(tfm);
 	walk->ivsize = crypto_aead_ivsize(tfm);
 	walk->alignmask = crypto_aead_alignmask(tfm);
 
@@ -819,6 +819,7 @@ static void crypto_skcipher_show(struct seq_file *m, struct crypto_alg *alg)
 	seq_printf(m, "max keysize  : %u\n", skcipher->max_keysize);
 	seq_printf(m, "ivsize       : %u\n", skcipher->ivsize);
 	seq_printf(m, "chunksize    : %u\n", skcipher->chunksize);
+	seq_printf(m, "walksize     : %u\n", skcipher->walksize);
 }
 
 #ifdef CONFIG_NET
@@ -891,11 +892,14 @@ static int skcipher_prepare_alg(struct skcipher_alg *alg)
 {
 	struct crypto_alg *base = &alg->base;
 
-	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8)
+	if (alg->ivsize > PAGE_SIZE / 8 || alg->chunksize > PAGE_SIZE / 8 ||
+	    alg->walksize > PAGE_SIZE / 8)
 		return -EINVAL;
 
 	if (!alg->chunksize)
 		alg->chunksize = base->cra_blocksize;
+	if (!alg->walksize)
+		alg->walksize = alg->chunksize;
 
 	base->cra_type = &crypto_skcipher_type2;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 8735979ed341..e42f7063f245 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -66,7 +66,7 @@ struct skcipher_walk {
 
 	int flags;
 	unsigned int blocksize;
-	unsigned int chunksize;
+	unsigned int stride;
 	unsigned int alignmask;
 };
 
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index cc4d98a7892e..3c17a33255b0 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -115,6 +115,9 @@ struct crypto_skcipher {
  *	    IV of exactly that size to perform the encrypt or decrypt operation.
  * @chunksize: Equal to the block size except for stream ciphers such as
  *	       CTR where it is set to the underlying block size.
+ * @walksize: Equal to the chunk size except in cases where the algorithm is
+ * 	      considerably more efficient if it can operate on multiple chunks
+ * 	      in parallel. Should be a multiple of chunksize.
  * @base: Definition of a generic crypto algorithm.
  *
  * All fields except @ivsize are mandatory and must be filled.
@@ -131,6 +134,7 @@ struct skcipher_alg {
 	unsigned int max_keysize;
 	unsigned int ivsize;
 	unsigned int chunksize;
+	unsigned int walksize;
 
 	struct crypto_alg base;
 };
@@ -289,6 +293,19 @@ static inline unsigned int crypto_skcipher_alg_chunksize(
 	return alg->chunksize;
 }
 
+static inline unsigned int crypto_skcipher_alg_walksize(
+	struct skcipher_alg *alg)
+{
+	if ((alg->base.cra_flags & CRYPTO_ALG_TYPE_MASK) ==
+	    CRYPTO_ALG_TYPE_BLKCIPHER)
+		return alg->base.cra_blocksize;
+
+	if (alg->base.cra_ablkcipher.encrypt)
+		return alg->base.cra_blocksize;
+
+	return alg->walksize;
+}
+
 /**
  * crypto_skcipher_chunksize() - obtain chunk size
  * @tfm: cipher handle
@@ -307,6 +324,23 @@ static inline unsigned int crypto_skcipher_chunksize(
 }
 
 /**
+ * crypto_skcipher_walksize() - obtain walk size
+ * @tfm: cipher handle
+ *
+ * In some cases, algorithms can only perform optimally when operating on
+ * multiple blocks in parallel. This is reflected by the walksize, which
+ * must be a multiple of the chunksize (or equal if the concern does not
+ * apply)
+ *
+ * Return: walk size in bytes
+ */
+static inline unsigned int crypto_skcipher_walksize(
+	struct crypto_skcipher *tfm)
+{
+	return crypto_skcipher_alg_walksize(crypto_skcipher_alg(tfm));
+}
+
+/**
  * crypto_skcipher_blocksize() - obtain block size of cipher
  * @tfm: cipher handle
  *
-- 
2.7.4
