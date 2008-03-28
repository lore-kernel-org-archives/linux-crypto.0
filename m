From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Fri, 28 Mar 2008 23:33:33 +0100
Message-ID: <20080328223333.GB24018@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43356 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757558AbYC1Wdf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 28 Mar 2008 18:33:35 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
Stefan, if you have some spare time could you please look if this patch
improves padlock + xts performance somehow?

 drivers/crypto/padlock-aes.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index bb30eb9..1ebbe8c 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -48,6 +48,8 @@ struct aes_ctx {
 	u32 *D;
 };
 
+static struct aes_ctx *last_key;
+
 /* Tells whether the ACE is capable to generate
    the extended key for a given key_len. */
 static inline int
@@ -115,6 +117,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->cword.encrypt.ksize = (key_len - 16) / 8;
 	ctx->cword.decrypt.ksize = ctx->cword.encrypt.ksize;
 
+	last_key  = ctx;
 	/* Don't generate extended keys if the hardware can do it. */
 	if (aes_hw_extkey_available(key_len))
 		return 0;
@@ -205,14 +208,22 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_reset_key();
+
+	if (last_key != ctx) {
+		last_key = ctx;
+		padlock_reset_key();
+	}
 	aes_crypt(in, out, ctx->E, &ctx->cword.encrypt);
 }
 
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct aes_ctx *ctx = aes_ctx(tfm);
-	padlock_reset_key();
+
+	if (last_key != ctx) {
+		last_key = ctx;
+		padlock_reset_key();
+	}
 	aes_crypt(in, out, ctx->D, &ctx->cword.decrypt);
 }
 
@@ -245,7 +256,10 @@ static int ecb_aes_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	if (last_key != ctx) {
+		last_key = ctx;
+		padlock_reset_key();
+	}
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -269,7 +283,10 @@ static int ecb_aes_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	if (last_key != ctx) {
+		last_key = ctx;
+		padlock_reset_key();
+	}
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -315,7 +332,10 @@ static int cbc_aes_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	if (last_key != ctx) {
+		last_key = ctx;
+		padlock_reset_key();
+	}
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
@@ -341,7 +361,10 @@ static int cbc_aes_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err;
 
-	padlock_reset_key();
+	if (last_key != ctx) {
+		last_key = ctx;
+		padlock_reset_key();
+	}
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-- 
1.5.4.3

