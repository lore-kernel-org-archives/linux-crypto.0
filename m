From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/3] crypto: allow blkcipher walks over AEAD data
Date: Tue,  4 Mar 2014 13:28:39 +0800
Message-ID: <1393910920-5796-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36975 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbaCDF3B (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Mar 2014 00:29:01 -0500
Received: by mail-pd0-f173.google.com with SMTP id z10so4658893pdj.18
        for <linux-crypto@vger.kernel.org>; Mon, 03 Mar 2014 21:29:01 -0800 (PST)
In-Reply-To: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the function blkcipher_aead_walk_virt_block, which allows the caller
to use the blkcipher walk API to handle the input and output scatterlists.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/blkcipher.c      | 14 ++++++++++++++
 include/crypto/algapi.h |  4 ++++
 2 files changed, 18 insertions(+)

diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 46fdab5e9cc7..0122bec38564 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -357,6 +357,20 @@ int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 }
 EXPORT_SYMBOL_GPL(blkcipher_walk_virt_block);
 
+int blkcipher_aead_walk_virt_block(struct blkcipher_desc *desc,
+				   struct blkcipher_walk *walk,
+				   struct crypto_aead *tfm,
+				   unsigned int blocksize)
+{
+	walk->flags &= ~BLKCIPHER_WALK_PHYS;
+	walk->walk_blocksize = blocksize;
+	walk->cipher_blocksize = crypto_aead_blocksize(tfm);
+	walk->ivsize = crypto_aead_ivsize(tfm);
+	walk->alignmask = crypto_aead_alignmask(tfm);
+	return blkcipher_walk_first(desc, walk);
+}
+EXPORT_SYMBOL_GPL(blkcipher_aead_walk_virt_block);
+
 static int setkey_unaligned(struct crypto_tfm *tfm, const u8 *key,
 			    unsigned int keylen)
 {
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index d9d14a0f0653..016c2f110f63 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -195,6 +195,10 @@ int blkcipher_walk_phys(struct blkcipher_desc *desc,
 int blkcipher_walk_virt_block(struct blkcipher_desc *desc,
 			      struct blkcipher_walk *walk,
 			      unsigned int blocksize);
+int blkcipher_aead_walk_virt_block(struct blkcipher_desc *desc,
+				   struct blkcipher_walk *walk,
+				   struct crypto_aead *tfm,
+				   unsigned int blocksize);
 
 int ablkcipher_walk_done(struct ablkcipher_request *req,
 			 struct ablkcipher_walk *walk, int err);
-- 
1.8.3.2
