From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH] [crypto] geode: do not copy the IV too often
Date: Thu, 15 Nov 2007 22:23:35 +0100
Message-ID: <20071115212335.GB21159@Chamillionaire.breakpoint.cc>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33226 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275AbXKOVXg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Nov 2007 16:23:36 -0500
Content-Disposition: inline
In-Reply-To: <20071114142253.GA15201@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

There is no reason to keep the IV in the private structre.
This also remove a few memcpy()s

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---

Herbert, could I please squash that one into the bad one so there are no
broken commits?

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 0ca92d4..061ad58 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -67,7 +67,7 @@ do_crypt(void *src, void *dst, int len, u32 flags)
 }
 
 static unsigned int
-geode_aes_crypt(struct geode_aes_op *op)
+geode_aes_crypt(struct geode_aes_op *op, u8 *iv)
 {
 	u32 flags = 0;
 	unsigned long iflags;
@@ -92,7 +92,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 
 	if (op->mode == AES_MODE_CBC) {
 		flags |= AES_CTRL_CBC;
-		_writefield(AES_WRITEIV0_REG, op->iv);
+		_writefield(AES_WRITEIV0_REG, iv);
 	}
 
 	if (!(op->flags & AES_FLAGS_HIDDENKEY)) {
@@ -104,7 +104,7 @@ geode_aes_crypt(struct geode_aes_op *op)
 	BUG_ON(ret);
 
 	if (op->mode == AES_MODE_CBC)
-		_readfield(AES_WRITEIV0_REG, op->iv);
+		_readfield(AES_WRITEIV0_REG, iv);
 
 	spin_unlock_irqrestore(&lock, iflags);
 
@@ -229,7 +229,7 @@ geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	op->len = AES_MIN_BLOCK_SIZE;
 	op->dir = AES_DIR_ENCRYPT;
 
-	geode_aes_crypt(op);
+	geode_aes_crypt(op, NULL);
 }
 
 
@@ -250,7 +250,7 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	op->len = AES_MIN_BLOCK_SIZE;
 	op->dir = AES_DIR_DECRYPT;
 
-	geode_aes_crypt(op);
+	geode_aes_crypt(op, NULL);
 }
 
 static int fallback_init_cip(struct crypto_tfm *tfm)
@@ -315,7 +315,6 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
@@ -324,13 +323,12 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
 		op->dir = AES_DIR_DECRYPT;
 
-		ret = geode_aes_crypt(op);
+		ret = geode_aes_crypt(op, walk.iv);
 
 		nbytes -= ret;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
 	return err;
 }
 
@@ -348,7 +346,6 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
@@ -357,12 +354,11 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
 		op->dir = AES_DIR_ENCRYPT;
 
-		ret = geode_aes_crypt(op);
+		ret = geode_aes_crypt(op, walk.iv);
 		nbytes -= ret;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
 	return err;
 }
 
@@ -438,7 +434,7 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
 		op->dir = AES_DIR_DECRYPT;
 
-		ret = geode_aes_crypt(op);
+		ret = geode_aes_crypt(op, NULL);
 		nbytes -= ret;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
@@ -468,7 +464,7 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
 		op->dir = AES_DIR_ENCRYPT;
 
-		ret = geode_aes_crypt(op);
+		ret = geode_aes_crypt(op, NULL);
 		nbytes -= ret;
 		ret =  blkcipher_walk_done(desc, &walk, nbytes);
 	}
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index 14cc763..d6b2824 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -65,7 +65,6 @@ struct geode_aes_op {
 	int len;
 
 	u8 key[AES_KEY_LENGTH];
-	u8 iv[AES_IV_LENGTH];
 
 	union {
 		struct crypto_blkcipher *blk;
-- 
1.5.3.4
