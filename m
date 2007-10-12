From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 6/6] [crypto] geode: use proper defines
Date: Fri, 12 Oct 2007 15:32:29 +0200
Message-ID: <E1IgMP4-0002l6-AM@Chamillionaire.breakpoint.cc>
References: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.2.5"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50918 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683AbXJLP0T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Oct 2007 11:26:19 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc authenticated by bigeasy with local
	(easymta 1.00 BETA 1)
	id 1IgMP4-0002l6-AM
	for linux-crypto@vger.kernel.org; Fri, 12 Oct 2007 17:26:18 +0200
In-Reply-To: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.2.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Use proper defines for constants even if they point to the same
value:
- there is no min/max blocksize, there is one for AES.
- the size of the IV is the algorithm's block size in case of CBC.
- there is no key size for AES but three different :)

This is a nitpicker patch, no added value :)

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |   44 ++++++++++++++++++++++----------------------
 drivers/crypto/geode-aes.h |    9 +++------
 2 files changed, 25 insertions(+), 28 deletions(-)
--------------1.5.2.5
Content-Type: text/x-patch; name="b743c412b4d75286c40fa054e53189eabdd4cf8c.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="b743c412b4d75286c40fa054e53189eabdd4cf8c.diff"

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 761d600..5c7ed90 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -123,12 +123,12 @@ geode_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int len)
 
 	op->keylen = len;
 
-	if (len == AES_KEY_LENGTH) {
+	if (len == AES_KEYSIZE_128) {
 		memcpy(op->key, key, len);
 		return 0;
 	}
 
-	if (len != 24 && len != 32) {
+	if (len != AES_KEYSIZE_192 && len != AES_KEYSIZE_256) {
 		/* not supported at all */
 		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
@@ -201,7 +201,7 @@ geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	if (unlikely(op->keylen != 16)) {
+	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
 		crypto_cipher_encrypt_one(op->fallback.cip, out, in);
 		return;
 	}
@@ -210,7 +210,7 @@ geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	op->dst = (void *) out;
 	op->mode = AES_MODE_ECB;
 	op->flags = 0;
-	op->len = AES_MIN_BLOCK_SIZE;
+	op->len = AES_BLOCK_SIZE;
 	op->dir = AES_DIR_ENCRYPT;
 
 	geode_aes_crypt(op);
@@ -222,7 +222,7 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct geode_aes_op *op = crypto_tfm_ctx(tfm);
 
-	if (unlikely(op->keylen != 16)) {
+	if (unlikely(op->keylen != AES_KEYSIZE_128)) {
 		crypto_cipher_decrypt_one(op->fallback.cip, out, in);
 		return;
 	}
@@ -231,7 +231,7 @@ geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	op->dst = (void *) out;
 	op->mode = AES_MODE_ECB;
 	op->flags = 0;
-	op->len = AES_MIN_BLOCK_SIZE;
+	op->len = AES_BLOCK_SIZE;
 	op->dir = AES_DIR_DECRYPT;
 
 	geode_aes_crypt(op);
@@ -299,7 +299,7 @@ static struct crypto_alg geode_alg = {
 					CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init               =       fallback_init,
 	.cra_exit               =       fallback_exit,
-	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_module		=	THIS_MODULE,
 	.cra_list		=	LIST_HEAD_INIT(geode_alg.cra_list),
@@ -323,18 +323,18 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
-	if (unlikely(op->keylen != 16))
+	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
+	memcpy(op->iv, walk.iv, AES_BLOCK_SIZE);
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_CBC;
-		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir = AES_DIR_DECRYPT;
 
 		ret = geode_aes_crypt(op);
@@ -343,7 +343,7 @@ geode_cbc_decrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
+	memcpy(walk.iv, op->iv, AES_BLOCK_SIZE);
 	return err;
 }
 
@@ -356,18 +356,18 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
-	if (unlikely(op->keylen != 16))
+	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
-	memcpy(op->iv, walk.iv, AES_IV_LENGTH);
+	memcpy(op->iv, walk.iv, AES_BLOCK_SIZE);
 
 	while((nbytes = walk.nbytes)) {
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_CBC;
-		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir = AES_DIR_ENCRYPT;
 
 		ret = geode_aes_crypt(op);
@@ -375,7 +375,7 @@ geode_cbc_encrypt(struct blkcipher_desc *desc,
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
 
-	memcpy(walk.iv, op->iv, AES_IV_LENGTH);
+	memcpy(walk.iv, op->iv, AES_BLOCK_SIZE);
 	return err;
 }
 
@@ -387,7 +387,7 @@ static struct crypto_alg geode_cbc_alg = {
 					CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init               =       fallback_init,
 	.cra_exit               =       fallback_exit,
-	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_alignmask		=	15,
 	.cra_type		=	&crypto_blkcipher_type,
@@ -400,7 +400,7 @@ static struct crypto_alg geode_cbc_alg = {
 			.setkey			=	geode_setkey,
 			.encrypt		=	geode_cbc_encrypt,
 			.decrypt		=	geode_cbc_decrypt,
-			.ivsize			=	AES_IV_LENGTH,
+			.ivsize			=	AES_BLOCK_SIZE,
 		}
 	}
 };
@@ -414,7 +414,7 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
-	if (unlikely(op->keylen != 16))
+	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_dec(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -424,7 +424,7 @@ geode_ecb_decrypt(struct blkcipher_desc *desc,
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_ECB;
-		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir = AES_DIR_DECRYPT;
 
 		ret = geode_aes_crypt(op);
@@ -444,7 +444,7 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 	struct blkcipher_walk walk;
 	int err, ret;
 
-	if (unlikely(op->keylen != 16))
+	if (unlikely(op->keylen != AES_KEYSIZE_128))
 		return fallback_blk_enc(desc, dst, src, nbytes);
 
 	blkcipher_walk_init(&walk, dst, src, nbytes);
@@ -454,7 +454,7 @@ geode_ecb_encrypt(struct blkcipher_desc *desc,
 		op->src = walk.src.virt.addr,
 		op->dst = walk.dst.virt.addr;
 		op->mode = AES_MODE_ECB;
-		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
+		op->len = nbytes - (nbytes % AES_BLOCK_SIZE);
 		op->dir = AES_DIR_ENCRYPT;
 
 		ret = geode_aes_crypt(op);
@@ -473,7 +473,7 @@ static struct crypto_alg geode_ecb_alg = {
 					CRYPTO_ALG_NEED_FALLBACK,
 	.cra_init               =       fallback_init,
 	.cra_exit               =       fallback_exit,
-	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
+	.cra_blocksize		=	AES_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct geode_aes_op),
 	.cra_alignmask		=	15,
 	.cra_type		=	&crypto_blkcipher_type,
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index 14cc763..a395df8 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -8,12 +8,9 @@
 
 #ifndef _GEODE_AES_H_
 #define _GEODE_AES_H_
+#include <crypto/aes.h>
 
 /* driver logic flags */
-#define AES_IV_LENGTH  16
-#define AES_KEY_LENGTH 16
-#define AES_MIN_BLOCK_SIZE 16
-
 #define AES_MODE_ECB 0
 #define AES_MODE_CBC 1
 
@@ -64,8 +61,8 @@ struct geode_aes_op {
 	u32 flags;
 	int len;
 
-	u8 key[AES_KEY_LENGTH];
-	u8 iv[AES_IV_LENGTH];
+	u8 key[AES_KEYSIZE_128];
+	u8 iv[AES_BLOCK_SIZE];
 
 	union {
 		struct crypto_blkcipher *blk;

--------------1.5.2.5--
