From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/3] crypto: allow blkcipher walks with no associated blkcipher transform
Date: Tue, 25 Feb 2014 13:57:51 +0100
Message-ID: <1393333072-15310-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1393333072-15310-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46791 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaBYM6C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Feb 2014 07:58:02 -0500
Received: by mail-wi0-f172.google.com with SMTP id e4so4430438wiv.11
        for <linux-crypto@vger.kernel.org>; Tue, 25 Feb 2014 04:58:00 -0800 (PST)
In-Reply-To: <1393333072-15310-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the functions blkcipher_walk_init_raw and blkcipher_walk_virt_raw,
which allow the caller to initialize the walk struct data members directly.
This allows non-blkcipher uses (e.g., AEADs) of the blkcipher walk API.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/blkcipher.c      | 11 ++++++++++-
 include/crypto/algapi.h | 20 ++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 46fdab5e9cc7..a3ca85c29a76 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -349,7 +349,6 @@ int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 			      unsigned int blocksize)
 {
 	walk->flags &= ~BLKCIPHER_WALK_PHYS;
-	walk->walk_blocksize = blocksize;
 	walk->cipher_blocksize = crypto_blkcipher_blocksize(desc->tfm);
 	walk->ivsize = crypto_blkcipher_ivsize(desc->tfm);
 	walk->alignmask = crypto_blkcipher_alignmask(desc->tfm);
@@ -357,6 +356,16 @@ int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 }
 EXPORT_SYMBOL_GPL(blkcipher_walk_virt_block);
 
+int blkcipher_walk_virt_raw(struct blkcipher_desc *desc,
+			    struct blkcipher_walk *walk,
+			    unsigned int blocksize)
+{
+	walk->flags &= ~BLKCIPHER_WALK_PHYS;
+	walk->walk_blocksize = blocksize;
+	return blkcipher_walk_first(desc, walk);
+}
+EXPORT_SYMBOL_GPL(blkcipher_walk_virt_raw);
+
 static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
 			    unsigned int keylen)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index d9d14a0f0653..7e70ede66c02 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -195,6 +195,9 @@ int blkcipher_walk_phys(struct blkcipher_desc *desc,
 int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 			      struct blkcipher_walk *walk,
 			      unsigned int blocksize);
+int blkcipher_walk_virt_raw(struct blkcipher_desc *desc,
+			    struct blkcipher_walk *walk,
+			    unsigned int blocksize);
 
 int ablkcipher_walk_done(struct ablkcipher_request *req,
 			 struct ablkcipher_walk *walk, int err);
@@ -312,6 +315,23 @@ static inline void blkcipher_walk_init(struct blkcipher_walk *walk,
 	walk->total = nbytes;
 }
 
+static inline void blkcipher_walk_init_raw(struct blkcipher_walk *walk,
+					   struct scatterlist *dst,
+					   struct scatterlist *src,
+					   unsigned int nbytes,
+					   unsigned int blocksize,
+					   unsigned int ivsize,
+					   unsigned int alignmask)
+{
+	walk->in.sg = src;
+	walk->out.sg = dst;
+	walk->total = nbytes;
+
+	walk->cipher_blocksize = blocksize;
+	walk->ivsize = ivsize;
+	walk->alignmask = alignmask;
+}
+
 static inline void ablkcipher_walk_init(struct ablkcipher_walk *walk,
 					struct scatterlist *dst,
 					struct scatterlist *src,
-- 
1.8.3.2
