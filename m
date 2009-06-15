From: "Shasi Pulijala" <spulijala@amcc.com>
Subject: [PATCH 2/3] AMCC Crypto4xx Device Driver v7
Date: Mon, 15 Jun 2009 10:26:56 -0700
Message-ID: <DB599F406D04E34389140B7D99C71B1B07D83E97@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <kim.phillips@freescale.com>, <jwboyer@linux.vnet.ibm.com>,
	<linux-crypto@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail01.amcc.com ([198.137.200.72]:8312 "EHLO
	sdcmail01.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762355AbZFORdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2009 13:33:44 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


From: Shasi Pulijala <spulijala@amcc.com>

This patch adds further support for AMCC ppc4xx security device driver. This is the
second release that adds algorithms like:
 des/3des
 rfc3686(ctr(aes))
 gcm, ccm
 hmac(md5,sha1,..,sha512)
 xcbc(aes), arc4 and kasumi.

Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
Acked-by: Loc Ho <lho@amcc.com>
---
 drivers/crypto/amcc/crypto4xx_alg.c | 1492 ++++++++++++++++++++++++++++++++++-
 1 files changed, 1476 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_alg.c b/drivers/crypto/amcc/crypto4xx_alg.c
index 61b6e1b..fac3543 100644
--- a/drivers/crypto/amcc/crypto4xx_alg.c
+++ b/drivers/crypto/amcc/crypto4xx_alg.c
@@ -24,10 +24,13 @@
 #include <linux/crypto.h>
 #include <linux/hash.h>
 #include <crypto/internal/hash.h>
+#include <crypto/aead.h>
 #include <linux/dma-mapping.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/des.h>
 #include <crypto/sha.h>
+#include <crypto/authenc.h>
 #include "crypto4xx_reg_def.h"
 #include "crypto4xx_sa.h"
 #include "crypto4xx_core.h"
@@ -58,9 +61,10 @@ void set_dynamic_sa_command_1(struct dynamic_sa_ctl *sa, u32 cm, u32 hmac_mc,
 {
 	sa->sa_command_1.w = 0;
 	sa->sa_command_1.bf.crypto_mode31 = (cm & 4) >> 2;
-	sa->sa_command_1.bf.crypto_mode9_8 = cm & 3;
+	sa->sa_command_1.bf.crypto_mode9_8 = (cm & 3);
 	sa->sa_command_1.bf.feedback_mode = cfb,
 	sa->sa_command_1.bf.sa_rev = 1;
+	sa->sa_command_1.bf.hmac_muting = hmac_mc;
 	sa->sa_command_1.bf.extended_seq_num = esn;
 	sa->sa_command_1.bf.seq_num_mask = sn_mask;
 	sa->sa_command_1.bf.mutable_bit_proc = mute;
@@ -69,6 +73,338 @@ void set_dynamic_sa_command_1(struct dynamic_sa_ctl *sa, u32 cm, u32 hmac_mc,
 	sa->sa_command_1.bf.copy_hdr = cp_hdr;
 }
 
+/** Table lookup for SA Hash Digest length and
+ *  Hash Contents (based on Hash type)
+ */
+unsigned int crypto4xx_sa_hash_tbl[3][HASH_ALG_MAX_CNT] = {
+	/* Hash Contents */
+	{ SA_HASH128_CONTENTS, SA_HASH160_CONTENTS, SA_HASH256_CONTENTS,
+	SA_HASH256_CONTENTS, SA_HASH512_CONTENTS, SA_HASH512_CONTENTS },
+	/* Digest len */
+	{4 * 4, 5 * 4, 7 * 4, 8 * 4, 12 * 4, 16 * 4},
+	/* SA Length */
+	{ SA_HASH128_LEN, SA_HASH160_LEN, SA_HASH256_LEN, SA_HASH256_LEN,
+	SA_HASH512_LEN, SA_HASH512_LEN }
+};
+
+/** Table lookup for Hash Algorithms based on Hash type, used in
+ *  crypto4xx_pre_compute_hmac()
+ */
+char *crypto4xx_hash_alg_map_tbl[HASH_ALG_MAX_CNT] = CRYPTO4XX_MAC_ALGS;
+
+static void crypto4xx_sg_setbuf(unsigned char *data, size_t bufsize,
+				struct scatterlist *sg, int sg_num)
+{
+	int remainder_of_page;
+	int i = 0;
+
+	sg_init_table(sg, sg_num);
+	while (bufsize > 0 && i < sg_num) {
+		sg_set_buf(&sg[i], data, bufsize);
+		remainder_of_page = PAGE_SIZE - sg[i].offset;
+		if (bufsize > remainder_of_page) {
+			/* the buffer was split over multiple pages */
+			sg[i].length = remainder_of_page;
+			bufsize -= remainder_of_page;
+			data += remainder_of_page;
+		} else {
+			bufsize = 0;
+		}
+		i++;
+	}
+}
+
+void crypto4xx_compute_immediate_hash(struct crypto_tfm *child_tfm, u8 *data,
+				     unsigned char ha)
+{
+	switch (ha) {
+	case SA_HASH_ALG_MD5:
+		md5_get_immediate_hash(child_tfm, data);
+		break;
+	case SA_HASH_ALG_SHA1:
+		sha1_get_immediate_hash(child_tfm, data);
+		break;
+	case SA_HASH_ALG_SHA256:
+	case SA_HASH_ALG_SHA224:
+		sha256_get_immediate_hash(child_tfm, data);
+		break;
+	case SA_HASH_ALG_SHA384:
+	case SA_HASH_ALG_SHA512:
+		sha512_get_immediate_hash(child_tfm, data);
+		break;
+	default:
+		break;
+	}
+}
+
+int crypto4xx_pre_compute_hmac(struct crypto4xx_ctx *ctx,
+			       void *key,
+			       unsigned int keylen,
+			       unsigned int bs,
+			       unsigned char ha,
+			       unsigned char digs)
+{
+	u8 *ipad = NULL;
+	u8 *opad;
+	struct crypto_hash *child_hash = NULL;
+	struct hash_desc desc;
+	struct scatterlist sg[1];
+	struct scatterlist asg[2];
+	struct crypto_tfm *child_tfm;
+	char *child_name = NULL;
+	int i, rc = 0;
+	int ds;
+
+	BUG_ON(ha >= HASH_ALG_MAX_CNT);
+	child_name = crypto4xx_hash_alg_map_tbl[ha];
+	child_hash = crypto_alloc_hash(child_name, 0, 0);
+	if (IS_ERR(child_hash)) {
+		rc = PTR_ERR(child_hash);
+		printk(KERN_ERR "failed to load "
+				"transform for %s error %d\n",
+				child_name, rc);
+		return rc;
+	}
+
+	ipad =  kmalloc(bs * 2, GFP_KERNEL);
+	if (ipad == NULL) {
+		crypto_free_hash(child_hash);
+		return -ENOMEM;
+	}
+
+	opad = ipad + bs;
+	child_tfm = crypto_hash_tfm(child_hash);
+	ds = crypto_hash_digestsize(child_hash);
+	desc.tfm = child_hash;
+	desc.flags = 0;
+	if (keylen > bs) {
+		crypto4xx_sg_setbuf(key, keylen, asg, 2);
+		rc = crypto_hash_init(&desc);
+		if (rc < 0)
+			goto err_alg_hash_key;
+		rc = crypto_hash_update(&desc, asg, keylen);
+		if (rc < 0)
+			goto err_alg_hash_key;
+		rc = crypto_hash_final(&desc, ipad);
+		keylen = ds;
+	} else {
+		memcpy(ipad, key, keylen);
+	}
+	memset(ipad + keylen, 0, bs-keylen);
+	memcpy(opad, ipad, bs);
+
+	for (i = 0; i < bs; i++) {
+		ipad[i] ^= 0x36;
+		opad[i] ^= 0x5c;
+	}
+
+	sg_init_one(&sg[0], ipad, bs);
+	rc = crypto_hash_init(&desc);
+	if (rc < 0)
+		goto err_alg_hash_key;
+	rc = crypto_hash_update(&desc, sg, bs);
+	if (rc < 0)
+		goto err_alg_hash_key;
+
+	if (ha == SA_HASH_ALG_SHA224)
+		ds = SHA256_DIGEST_SIZE;
+	else if (ha == SA_HASH_ALG_SHA384)
+		ds = SHA512_DIGEST_SIZE;
+
+	crypto4xx_compute_immediate_hash(child_tfm, ipad, ha);
+	crypto4xx_memcpy_le(ctx->sa_in +
+			get_dynamic_sa_offset_inner_digest(ctx), ipad, ds);
+
+	sg_init_one(&sg[0], opad, bs);
+	rc = crypto_hash_init(&desc);
+	if (rc < 0)
+		goto err_alg_hash_key;
+
+	rc = crypto_hash_update(&desc, sg, bs);
+	if (rc < 0)
+		goto err_alg_hash_key;
+
+	crypto4xx_compute_immediate_hash(child_tfm, opad, ha);
+	crypto4xx_memcpy_le(ctx->sa_in +
+			get_dynamic_sa_offset_outer_digest(ctx), opad, ds);
+
+err_alg_hash_key:
+	kfree(ipad);
+	crypto_free_hash(child_hash);
+	return rc;
+}
+
+int crypto4xx_compute_gcm_hash_key_sw(struct crypto4xx_ctx *ctx,
+				      const u8 *key,
+				      unsigned int keylen)
+{
+	struct crypto_blkcipher *aes_tfm = NULL;
+	struct blkcipher_desc 	desc;
+	struct scatterlist sg[1];
+	char src[16];
+	int rc = 0;
+
+	aes_tfm = crypto_alloc_blkcipher("ecb(aes)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(aes_tfm)) {
+		printk(KERN_ERR "failed to load transform for %ld\n",
+		       PTR_ERR(aes_tfm));
+		rc = PTR_ERR(aes_tfm);
+		return rc;
+	}
+	desc.tfm    = aes_tfm;
+	desc.flags  = 0;
+
+	memset(src, 0, 16);
+	rc = crypto_blkcipher_setkey(aes_tfm, key, keylen);
+	if (rc) {
+		printk(KERN_ERR "setkey() failed flags=%x\n",
+		       crypto_blkcipher_get_flags(aes_tfm));
+		goto out;
+	}
+
+	sg_init_one(sg, src, 16);
+	rc = crypto_blkcipher_encrypt(&desc, sg, sg, 16);
+	if (rc)
+		goto out;
+	crypto4xx_memcpy_le(ctx->sa_in +
+			get_dynamic_sa_offset_inner_digest(ctx), src, 16);
+
+out:
+	crypto_free_blkcipher(aes_tfm);
+	return rc;
+}
+
+/**
+ * 3DES/DES Functions
+ *
+ */
+static int crypto4xx_setkey_3des(struct crypto_ablkcipher *cipher,
+				 const u8 *key,
+				 unsigned int keylen,
+				 unsigned char cm,
+				 unsigned char fb)
+{
+	struct crypto_tfm    *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dynamic_sa_ctl *sa;
+	int rc;
+
+	if (keylen != DES_KEY_SIZE && keylen != DES3_EDE_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(cipher,
+			CRYPTO_TFM_RES_BAD_KEY_LEN);
+
+		return -EINVAL;
+	}
+
+	if (keylen == DES_KEY_SIZE) {
+		u32 tmp[32];
+		rc = des_ekey(tmp, key);
+		if (unlikely(rc == 0) &&
+				  (tfm->crt_flags & CRYPTO_TFM_REQ_WEAK_KEY)) {
+			crypto_ablkcipher_set_flags(cipher,
+				CRYPTO_TFM_RES_WEAK_KEY);
+			return -EINVAL;
+		}
+	}
+
+	/* Create SA */
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		crypto4xx_free_sa(ctx);
+
+	rc = crypto4xx_alloc_sa(ctx, keylen == 8 ? SA_DES_LEN : SA_3DES_LEN);
+	if (rc)
+		return rc;
+	/*
+	 *  state record will state in base ctx, so iv and
+	 *  hash result can be reused
+	 *  also don't need to alloc each packet coming
+	 */
+	if (ctx->state_record_dma_addr == 0) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc) {
+			crypto4xx_free_sa(ctx);
+			return rc;
+		}
+	}
+
+	/* Setup SA */
+	ctx->direction = DIR_INBOUND;
+	ctx->hash_final = 0;
+
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+				 SA_NO_HEADER_PROC, SA_HASH_ALG_NULL,
+				 SA_CIPHER_ALG_DES,
+				 SA_PAD_TYPE_ZERO, SA_OP_GROUP_BASIC,
+				 SA_OPCODE_DECRYPT, DIR_INBOUND);
+
+	set_dynamic_sa_command_1(sa, cm, SA_HASH_MODE_HASH,
+				 fb, SA_EXTENDED_SN_OFF,
+				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
+				 SA_NOT_COPY_PAD, SA_COPY_PAYLOAD,
+				 SA_NOT_COPY_HDR);
+
+	if (keylen == DES_KEY_SIZE) {
+		crypto4xx_memcpy_le(((struct dynamic_sa_des *) sa)->key,
+				      key, keylen);
+		((struct dynamic_sa_des *)sa)->ctrl.sa_contents =
+				SA_DES_CONTENTS;
+		sa->sa_command_0.bf.cipher_alg = SA_CIPHER_ALG_DES;
+	} else {
+		crypto4xx_memcpy_le(((struct dynamic_sa_3des *) sa)->key,
+				      key, keylen);
+		((struct dynamic_sa_3des *)sa)->ctrl.sa_contents =
+				SA_3DES_CONTENTS;
+		sa->sa_command_0.bf.cipher_alg = SA_CIPHER_ALG_3DES;
+	}
+
+	memcpy((void *)(ctx->sa_in +
+			get_dynamic_sa_offset_state_ptr_field(ctx)),
+			(void *)&ctx->state_record_dma_addr, 4);
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+	ctx->is_hash = 0;
+	sa->sa_command_0.bf.dir = DIR_INBOUND;
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+
+	return 0;
+}
+
+int crypto4xx_setkey_3des_cfb(struct crypto_ablkcipher *cipher,
+			      const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_3des(cipher, key, keylen,
+					CRYPTO_MODE_CFB,
+					CRYPTO_FEEDBACK_MODE_8BIT_CFB);
+}
+
+int crypto4xx_setkey_3des_ofb(struct crypto_ablkcipher *cipher,
+			      const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_3des(cipher, key, keylen,
+				       CRYPTO_MODE_OFB,
+				       CRYPTO_FEEDBACK_MODE_64BIT_OFB);
+}
+
+int crypto4xx_setkey_3des_cbc(struct crypto_ablkcipher *cipher,
+			      const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_3des(cipher, key, keylen,
+				     CRYPTO_MODE_CBC,
+				     CRYPTO_FEEDBACK_MODE_NO_FB);
+}
+
+int crypto4xx_setkey_3des_ecb(struct crypto_ablkcipher *cipher,
+			      const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_3des(cipher, key, keylen,
+				     CRYPTO_MODE_ECB,
+				     CRYPTO_FEEDBACK_MODE_NO_FB);
+}
+
+
 int crypto4xx_encrypt(struct ablkcipher_request *req)
 {
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
@@ -79,22 +415,54 @@ int crypto4xx_encrypt(struct ablkcipher_request *req)
 	ctx->pd_ctl = 0x1;
 
 	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
-				  req->nbytes, req->info,
-				  get_dynamic_sa_iv_size(ctx));
+				   req->nbytes, NULL, 0, req->info,
+				   get_dynamic_sa_iv_size(ctx));
 }
 
 int crypto4xx_decrypt(struct ablkcipher_request *req)
 {
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
 
+	ctx->hash_final = 0;
+	ctx->is_hash = 0;
+	ctx->pd_ctl = 0x1;
 	ctx->direction = DIR_INBOUND;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				   req->nbytes, NULL, 0, req->info,
+				   get_dynamic_sa_iv_size(ctx));
+}
+
+int crypto4xx_encrypt_ctr(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+
 	ctx->hash_final = 0;
 	ctx->is_hash = 0;
-	ctx->pd_ctl = 1;
+	ctx->pd_ctl = 0x1;
+	ctx->direction = DIR_OUTBOUND;
 
 	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
-				  req->nbytes, req->info,
-				  get_dynamic_sa_iv_size(ctx));
+				  req->nbytes, NULL, 0,
+				  req->info,
+				  crypto_ablkcipher_ivsize(ablkcipher));
+}
+
+int crypto4xx_decrypt_ctr(struct ablkcipher_request *req)
+{
+	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+
+	ctx->hash_final = 0;
+	ctx->is_hash = 0;
+	ctx->pd_ctl = 0x1;
+	ctx->direction = DIR_INBOUND;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->nbytes, NULL, 0,
+				  req->info,
+				  crypto_ablkcipher_ivsize(ablkcipher));
 }
 
 /**
@@ -166,6 +534,13 @@ static int crypto4xx_setkey_aes(struct crypto_ablkcipher *cipher,
 	return 0;
 }
 
+int crypto4xx_setkey_aes_ecb(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_ECB,
+				    CRYPTO_FEEDBACK_MODE_NO_FB);
+}
+
 int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
 			     const u8 *key, unsigned int keylen)
 {
@@ -173,8 +548,677 @@ int crypto4xx_setkey_aes_cbc(struct crypto_ablkcipher *cipher,
 				    CRYPTO_FEEDBACK_MODE_NO_FB);
 }
 
+int crypto4xx_setkey_aes_ctr(struct crypto_ablkcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	struct crypto_tfm    *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dynamic_sa_ctl *sa;
+	u32 cnt = 1;
+	int    rc;
+	u32 cm = CRYPTO_MODE_AES_CTR;
+
+	keylen -= 4;
+	/* Create SA */
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		 crypto4xx_free_sa(ctx);
+
+	if (keylen != AES_KEYSIZE_256 &&
+		   keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_128) {
+		crypto_ablkcipher_set_flags(cipher,
+					    CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	rc = crypto4xx_alloc_sa(ctx, SA_AES128_LEN + (keylen-16) / 4);
+	if (rc)
+		return rc;
+
+	if (ctx->state_record_dma_addr == 0) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc) {
+			crypto4xx_free_sa(ctx);
+			return rc;
+		}
+	}
+
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	ctx->hash_final = 0;
+	ctx->ctr_aes = 1;
+	/* Setup SA */
+	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+				 SA_NO_HEADER_PROC, SA_HASH_ALG_NULL,
+				 SA_CIPHER_ALG_AES, SA_PAD_TYPE_ZERO,
+				 SA_OP_GROUP_BASIC, SA_OPCODE_ENCRYPT,
+				 DIR_INBOUND);
+	set_dynamic_sa_command_1(sa, cm, SA_HASH_MODE_HASH,
+				 CRYPTO_FEEDBACK_MODE_NO_FB,
+				 SA_EXTENDED_SN_OFF, SA_SEQ_MASK_OFF,
+				 SA_MC_ENABLE, SA_NOT_COPY_PAD,
+				 SA_NOT_COPY_PAYLOAD,
+				 SA_NOT_COPY_HDR);
+
+	crypto4xx_memcpy_le(ctx->sa_in + get_dynamic_sa_offset_key_field(ctx),
+			    key, keylen);
+	sa->sa_contents = SA_AES_CONTENTS | (keylen << 2);
+	sa->sa_command_1.bf.key_len = keylen >> 3;
+
+	ctx->direction = DIR_INBOUND;
+	memcpy(ctx->sa_in + get_dynamic_sa_offset_state_ptr_field(ctx),
+	       (void *)&ctx->state_record_dma_addr, 4);
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+
+	crypto4xx_memcpy_le(ctx->state_record, key + keylen, 4);
+	crypto4xx_memcpy_le(ctx->state_record + 12, (void *)&cnt, 4);
+
+	sa->sa_command_0.bf.dir = DIR_INBOUND;
+
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+
+	return 0;
+}
+
+int crypto4xx_setkey_aes_cfb(struct crypto_ablkcipher *cipher,
+					  const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_CFB,
+				    CRYPTO_FEEDBACK_MODE_128BIT_CFB);
+}
+
+int crypto4xx_setkey_aes_ofb(struct crypto_ablkcipher *cipher,
+					  const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_OFB,
+				    CRYPTO_FEEDBACK_MODE_64BIT_OFB);
+}
+
+int crypto4xx_setkey_aes_icm(struct crypto_ablkcipher *cipher,
+					  const u8 *key, unsigned int keylen)
+{
+	return crypto4xx_setkey_aes(cipher, key, keylen, CRYPTO_MODE_AES_ICM,
+				    CRYPTO_FEEDBACK_MODE_NO_FB);
+}
+
+/**
+ * AES-GCM Functions
+ */
+static inline int crypto4xx_aes_gcm_validate_keylen(unsigned int keylen)
+{
+	switch (keylen) {
+	case 16:
+	case 20:
+	case 24:
+	case 30:
+	case 32:
+	case 36:
+		return 0;
+	default:
+		printk(KERN_ERR "crypto4xx_setkey_aes_gcm: "
+				"ERROR keylen = 0x%08x\n", keylen);
+		return -EINVAL;
+	}
+	return -EINVAL;
+}
+
+int crypto4xx_setkey_aes_gcm(struct crypto_aead *cipher,
+				     const u8 *key, unsigned int keylen)
+
+{
+	struct crypto_tfm    *tfm = crypto_aead_tfm(cipher);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dynamic_sa_ctl *sa;
+	int    rc = 0;
+
+	u32 cm = 4;
+
+	if (crypto4xx_aes_gcm_validate_keylen(keylen) != 0) {
+		printk(KERN_ERR "crypto4xx_setkey_aes_gcm:"
+				"ERROR keylen = 0x%08x\n", keylen);
+		crypto_aead_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	    return -EINVAL;
+	}
+
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		 crypto4xx_free_sa(ctx);
+
+	rc = crypto4xx_alloc_sa(ctx, SA_AES128_GCM_LEN + (keylen-16) / 4);
+	if (rc)
+		return rc;
+
+	if (ctx->state_record_dma_addr == 0) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc)
+			goto err;
+	}
+
+	sa  = (struct dynamic_sa_ctl *) ctx->sa_in;
+
+	sa->sa_contents = SA_AES_GCM_CONTENTS | (keylen << 2);
+	sa->sa_command_1.bf.key_len = keylen >> 3;
+
+	ctx->direction = DIR_INBOUND;
+	crypto4xx_memcpy_le(ctx->sa_in + get_dynamic_sa_offset_key_field(ctx),
+			    key, keylen);
+
+	memcpy(ctx->sa_in + get_dynamic_sa_offset_state_ptr_field(ctx),
+	       (void *)&ctx->state_record_dma_addr, 4);
+
+	rc = crypto4xx_compute_gcm_hash_key_sw(ctx, key, keylen);
+	if (rc) {
+		printk(KERN_ERR "GCM hash key setting failed = %d\n", rc);
+		goto err;
+	}
+
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+	ctx->is_gcm = 1;
+	ctx->hash_final = 1;
+	ctx->is_hash = 0;
+	ctx->pd_ctl = 0x11;
+
+	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+				 SA_NO_HEADER_PROC, SA_HASH_ALG_GHASH,
+				 SA_CIPHER_ALG_AES, SA_PAD_TYPE_ZERO,
+				 SA_OP_GROUP_BASIC, SA_OPCODE_HASH_DECRYPT,
+				 DIR_INBOUND);
+
+	sa->sa_command_1.bf.crypto_mode31 = (cm & 4) >> 2;
+	sa->sa_command_1.bf.crypto_mode9_8 = (cm & 3);
+	sa->sa_command_1.bf.feedback_mode = 0;
+
+	sa->sa_command_1.bf.hash_crypto_offset = 0;
+	sa->sa_command_1.bf.sa_rev = 1;
+	sa->sa_command_1.bf.copy_payload = 1;
+
+	sa->sa_command_1.bf.copy_pad = 0;
+	sa->sa_command_1.bf.copy_hdr = 0;
+	sa->sa_command_1.bf.mutable_bit_proc = 1;
+	sa->sa_command_1.bf.seq_num_mask = 1;
+
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+	sa->sa_command_0.bf.opcode = SA_OPCODE_ENCRYPT_HASH;
+
+	return 0;
+err:
+	crypto4xx_free_sa(ctx);
+	return rc;
+}
+
+int crypto4xx_encrypt_aes_gcm(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+
+	ctx->direction = DIR_OUTBOUND;
+	ctx->append_icv = 1;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->cryptlen, req->assoc, req->assoclen,
+				  req->iv, crypto_aead_ivsize(aead));
+}
+
+int crypto4xx_decrypt_aes_gcm(struct aead_request *req)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+	int len = req->cryptlen - crypto_aead_authsize(aead);
+
+	ctx->direction = DIR_INBOUND;
+	ctx->append_icv = 0;
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  len, req->assoc, req->assoclen,
+				  req->iv, crypto_aead_ivsize(aead));
+}
+
+int crypto4xx_givencrypt_aes_gcm(struct aead_givcrypt_request *req)
+{
+	return -ENOSYS;
+}
+
+int crypto4xx_givdecrypt_aes_gcm(struct aead_givcrypt_request *req)
+{
+	return -ENOSYS;
+}
+
 /**
- * HASH SHA1 Functions
+ * AES-CCM Functions
+ */
+int crypto4xx_setauthsize_aes(struct crypto_aead *ciper,
+			      unsigned int authsize)
+{
+	struct aead_tfm *tfm = crypto_aead_crt(ciper);
+
+	switch (authsize) {
+	case 8:
+	case 12:
+	case 16:
+	case 10:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tfm->authsize = authsize;
+	return 0;
+}
+
+int crypto4xx_setkey_aes_ccm(struct crypto_aead *cipher, const u8 *key,
+				unsigned int keylen)
+{
+	struct crypto_tfm    *tfm = crypto_aead_tfm(cipher);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dynamic_sa_ctl *sa;
+	int rc = 0;
+
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		 crypto4xx_free_sa(ctx);
+
+	rc = crypto4xx_alloc_sa(ctx, SA_AES128_CCM_LEN + (keylen-16) / 4);
+	if (rc)
+		return rc;
+
+	if (ctx->state_record_dma_addr == 0) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc) {
+			crypto4xx_free_sa(ctx);
+			return rc;
+		}
+	}
+
+	/* Setup SA */
+	sa  = (struct dynamic_sa_ctl *) ctx->sa_in;
+	sa->sa_contents = SA_AES_CCM_CONTENTS | (keylen << 2);
+
+	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+				 SA_NO_HEADER_PROC, SA_HASH_ALG_CBC_MAC,
+				 SA_CIPHER_ALG_AES,
+				 SA_PAD_TYPE_ZERO, SA_OP_GROUP_BASIC,
+				 SA_OPCODE_HASH_DECRYPT, DIR_INBOUND);
+
+	sa->sa_command_0.bf.digest_len = 0;
+	sa->sa_command_1.bf.key_len = keylen >> 3;
+	ctx->direction = DIR_INBOUND;
+	ctx->append_icv = 0;
+	ctx->is_gcm = 0;
+	ctx->hash_final = 1;
+	ctx->is_hash = 0;
+	ctx->pd_ctl = 0x11;
+
+	crypto4xx_memcpy_le(ctx->sa_in + get_dynamic_sa_offset_key_field(ctx),
+			    key, keylen);
+	memcpy(ctx->sa_in + get_dynamic_sa_offset_state_ptr_field(ctx),
+	       (void *)&ctx->state_record_dma_addr, 4);
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+
+	set_dynamic_sa_command_1(sa, CRYPTO_MODE_AES_CTR, SA_HASH_MODE_HASH,
+				 CRYPTO_FEEDBACK_MODE_NO_FB, SA_EXTENDED_SN_OFF,
+				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
+				 SA_NOT_COPY_PAD, SA_COPY_PAYLOAD,
+				 SA_NOT_COPY_HDR);
+
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+				 SA_NO_HEADER_PROC, SA_HASH_ALG_CBC_MAC,
+				 SA_CIPHER_ALG_AES,
+				 SA_PAD_TYPE_ZERO, SA_OP_GROUP_BASIC,
+				 SA_OPCODE_ENCRYPT_HASH, DIR_OUTBOUND);
+	set_dynamic_sa_command_1(sa, CRYPTO_MODE_AES_CTR, SA_HASH_MODE_HASH,
+				 CRYPTO_FEEDBACK_MODE_NO_FB, SA_EXTENDED_SN_OFF,
+				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
+				 SA_NOT_COPY_PAD, SA_COPY_PAYLOAD,
+				 SA_NOT_COPY_HDR);
+
+	return 0;
+}
+
+int crypto4xx_encrypt_aes_ccm(struct aead_request *req)
+{
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct dynamic_sa_ctl *sa;
+
+	ctx->direction = DIR_OUTBOUND;
+
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	if (req->assoclen)
+		sa->sa_command_1.bf.hash_crypto_offset = req->assoclen >> 2;
+
+	sa->sa_command_0.bf.digest_len = (crypto_aead_authsize(aead) >> 2);
+	if ((req->iv[0] & 7) == 1)
+		sa->sa_command_1.bf.crypto_mode9_8 = 1;
+
+	ctx->append_icv = 1;
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->cryptlen, req->assoc, req->assoclen,
+				  req->iv, 16);
+}
+
+int crypto4xx_decrypt_aes_ccm(struct aead_request *req)
+{
+	struct crypto4xx_ctx   *ctx  = crypto_tfm_ctx(req->base.tfm);
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct dynamic_sa_ctl *sa;
+
+	/* Support only counter field length of 2 and 4 bytes */
+	if ((req->iv[0] & 0x7) != 1 && (req->iv[0] & 0x7) != 3) {
+		printk(KERN_ERR "algorithm AES-CCM "
+				"unsupported counter length %d\n",
+			req->iv[0] & 0x7);
+		return -EINVAL;
+	}
+
+	ctx->direction = DIR_INBOUND;
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+
+	sa->sa_command_0.bf.digest_len = (crypto_aead_authsize(aead) >> 2);
+	if ((req->iv[0] & 7) == 1)
+		sa->sa_command_1.bf.crypto_mode9_8 = 1;
+	else
+		sa->sa_command_1.bf.crypto_mode9_8 = 0;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->cryptlen, req->assoc, req->assoclen,
+				  req->iv, 16);
+}
+
+int crypto4xx_givencrypt_aes_ccm(struct aead_givcrypt_request *req)
+{
+	return -ENOSYS;
+}
+
+int crypto4xx_givdecrypt_aes_ccm(struct aead_givcrypt_request *req)
+{
+	return -ENOSYS;
+}
+
+/**
+ * Kasumi Functions
+ *
+ */
+int crypto4xx_setkey_kasumi(struct crypto_ablkcipher *cipher,
+				   const u8 *key,
+				   unsigned int keylen,
+				   unsigned char cm)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dynamic_sa_ctl *sa;
+	u32 sa_len = 0;
+	int rc;
+
+	if (keylen != 16) {
+		crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		printk(KERN_ERR "%s: keylen fail\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Create SA - SA is created here as the alg init function is
+	 * common to many algorithm and it does not have the SA length
+	 * as it is specify to an algorithm. See setkey function has
+	 * to be called for encryption/decryption algorithm once,
+	 * it is okay to do this here.
+	 */
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		 crypto4xx_free_sa(ctx);
+
+	if (cm == CRYPTO_MODE_KASUMI)
+		 sa_len = SA_KASUMI_LEN;
+	else if (cm == CRYPTO_MODE_KASUMI_f8)
+		 sa_len = SA_KASUMI_F8_LEN;
+
+	rc = crypto4xx_alloc_sa(ctx, sa_len);
+	if (rc)
+		return rc;
+
+	if (!ctx->state_record) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc) {
+			crypto4xx_free_sa(ctx);
+			return rc;
+		}
+	}
+
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	/* Setup SA - SA is a shared resource for request operation. As
+	 * crypto alg and crypto mode can not be change, it should be
+	 * ok to store them there. SA control words are not used by the
+	 * hardware (configured in token instead), we use it to store
+	 * software algorithm and mode selected.
+	 */
+
+	if (cm == CRYPTO_MODE_KASUMI) {
+		sa->sa_contents = SA_KASUMI_CONTENTS;
+		sa->sa_command_0.bf.cipher_alg = SA_CIPHER_ALG_KASUMI;
+		sa->sa_command_0.bf.hash_alg = SA_HASH_ALG_NULL;
+		sa->sa_command_0.bf.pad_type = 3; /* set to zero padding */
+		sa->sa_command_0.bf.opcode = 0;
+		sa->sa_command_1.bf.crypto_mode31 = (cm & 4) >> 2;
+		sa->sa_command_1.bf.crypto_mode9_8 = (cm & 3);
+		sa->sa_command_1.bf.feedback_mode = 0;
+	} else {
+		sa->sa_contents = SA_KASUMI_F8_CONTENTS;
+		sa->sa_command_0.bf.cipher_alg = SA_CIPHER_ALG_KASUMI;
+		sa->sa_command_0.bf.hash_alg = SA_HASH_ALG_NULL;
+		sa->sa_command_0.bf.pad_type = 3;
+		sa->sa_command_0.bf.load_iv = SA_LOAD_IV_FROM_STATE;
+		sa->sa_command_0.bf.opcode = SA_OPCODE_ENCRYPT;
+		sa->sa_command_1.bf.crypto_mode31 = (cm & 4) >> 2;;
+		sa->sa_command_1.bf.crypto_mode9_8 = (cm & 3);
+		sa->sa_command_1.bf.feedback_mode = 0;
+		sa->sa_command_1.bf.mutable_bit_proc = 1;
+	}
+
+	ctx->direction = DIR_INBOUND;
+	sa->sa_command_1.bf.sa_rev = 1;
+	crypto4xx_memcpy_le(ctx->sa_in + get_dynamic_sa_offset_key_field(ctx),
+			    key, keylen);
+	ctx->is_hash = 0;
+
+	memcpy(ctx->sa_in + get_dynamic_sa_offset_state_ptr_field(ctx),
+	       (void *)&ctx->state_record_dma_addr, 4);
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+	sa->sa_command_0.bf.dir = DIR_INBOUND;
+
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+
+	return 0;
+}
+
+int crypto4xx_setkey_kasumi_p(struct crypto_ablkcipher *cipher,
+					const u8 *key,
+					unsigned int keylen)
+{
+	return crypto4xx_setkey_kasumi(cipher, key, keylen,
+				       CRYPTO_MODE_KASUMI);
+}
+
+int crypto4xx_setkey_kasumi_f8(struct crypto_ablkcipher *cipher,
+					     const u8 *key,
+					     unsigned int keylen)
+{
+	return crypto4xx_setkey_kasumi(cipher, key, keylen,
+				       CRYPTO_MODE_KASUMI_f8);
+}
+
+/**
+ * Kasumi and Kasumi f8 work with number of bits.
+ * The crypto engine can only take number bytes as source/destination length
+ * User should round up bit number to byte number. When receive the result
+ * packet and then mask off the extra bits in the last
+ * byte.
+ */
+int crypto4xx_encrypt_kasumi(struct ablkcipher_request *req)
+{
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+	ctx->direction = DIR_OUTBOUND;
+	ctx->pd_ctl = 0x1;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->nbytes, NULL, 0, NULL, 0);
+}
+
+/**
+ * Kasumi and Kasumi f8 work with number of bits.
+ * The crypto engine can only take number bytes as source/destination length
+ * User should round up bit number to byte number.
+ * When receive the result packet and then mask off the extra bits in the last
+ * byte.
+ */
+int crypto4xx_decrypt_kasumi(struct aead_request *req)
+{
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+
+	ctx->pd_ctl = 0x1;
+	ctx->direction = DIR_INBOUND;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->cryptlen, NULL, 0, NULL, 0);
+}
+
+/**
+ * Kasumi and Kasumi f8 work with number of bits.
+ * The crypto engine can only take number bytes as source/destination length
+ * The user should round up bit number to byte number.
+ * When receive the result packet and then mask
+ * off the extra bits in the last byte.
+ */
+int crypto4xx_encrypt_kasumi_f8(struct ablkcipher_request *req)
+{
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+
+	ctx->direction = DIR_OUTBOUND;
+	ctx->is_hash = 0;
+	ctx->pd_ctl = 0x1;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->nbytes, NULL, 0, req->info, 8);
+}
+
+/** Note:
+ * Kasumi and Kasumi f8 work with number of bits.
+ * The crypto engine can only take number bytes as source/destination length
+ *  User should round up bit number to byte number.
+ * When receive the result packet and then mask off the extra bits in the last
+ * byte.
+ */
+int crypto4xx_decrypt_kasumi_f8(struct ablkcipher_request *req)
+{
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+
+	ctx->direction = DIR_INBOUND;
+	ctx->is_hash = 0;
+	ctx->pd_ctl = 0x1;
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src, req->dst,
+				  req->nbytes, NULL, 0, req->info, 8);
+}
+
+/**
+ * ARC4 Functions
+ *
+ */
+int crypto4xx_setkey_arc4(struct crypto_ablkcipher *cipher,
+				 const u8 *key, unsigned int keylen)
+{
+	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct dynamic_sa_ctl *sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	int rc = 0;
+
+	/* Create SA */
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		crypto4xx_free_sa(ctx);
+
+	rc = crypto4xx_alloc_sa(ctx, SA_ARC4_LEN);
+	if (rc)
+		return rc;
+
+	crypto4xx_alloc_arc4_state_record(ctx);
+	if (ctx->arc4_state_record == NULL) {
+		crypto4xx_free_sa(ctx);
+		return -ENOMEM;
+	}
+
+	/* Setup SA */
+	ctx->sa_len = SA_ARC4_LEN;
+	ctx->init_arc4 = 1;
+	ctx->direction = DIR_INBOUND;
+
+	sa = ctx->sa_in;
+	memset(((struct dynamic_sa_arc4 *)sa)->key, 0, 16);
+
+	crypto4xx_memcpy_le(((struct dynamic_sa_arc4 *)sa)->key, key, keylen);
+	sa->sa_contents = SA_ARC4_CONTENTS;
+
+	set_dynamic_sa_command_0(sa, SA_NOT_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_LOAD_HASH_FROM_SA, SA_LOAD_IV_FROM_STATE,
+				 SA_NO_HEADER_PROC, SA_HASH_ALG_NULL,
+				 SA_CIPHER_ALG_ARC4, SA_PAD_TYPE_ZERO,
+				 SA_OP_GROUP_BASIC, SA_OPCODE_ENCRYPT,
+				 DIR_INBOUND);
+
+	set_dynamic_sa_command_1(sa, 0, SA_HASH_MODE_HASH,
+				 CRYPTO_FEEDBACK_MODE_NO_FB,
+				 SA_EXTENDED_SN_OFF, SA_SEQ_MASK_OFF,
+				 SA_MC_ENABLE, SA_NOT_COPY_PAD,
+				 SA_COPY_PAYLOAD, SA_NOT_COPY_HDR);
+
+	sa->sa_command_1.bf.key_len = keylen;
+	memcpy(sa + get_dynamic_sa_offset_arc4_state_ptr(ctx),
+	       (void *)&ctx->arc4_state_record_dma_addr, 4);
+
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+
+	return 0;
+}
+
+int crypto4xx_arc4_encrypt(struct ablkcipher_request *req)
+{
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+
+	if (ctx->init_arc4) {
+		ctx->init_arc4 = 0;
+		ctx->pd_ctl = 9;
+	} else {
+		ctx->pd_ctl = 0x1;
+	}
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src,
+				  req->dst,
+				  req->nbytes, NULL, 0, NULL, 0);
+}
+
+int crypto4xx_arc4_decrypt(struct ablkcipher_request *req)
+{
+	struct crypto4xx_ctx *ctx  = crypto_tfm_ctx(req->base.tfm);
+
+	if (ctx->init_arc4) {
+		ctx->init_arc4 = 0;
+		ctx->pd_ctl = 9;
+	} else {
+		ctx->pd_ctl = 0x1;
+	}
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src,
+				  req->dst,
+				  req->nbytes, NULL, 0, NULL, 0);
+}
+
+/**
+ * Support MD5/SHA/HMAC Hashing Algorithms
+ *
  */
 static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 				   unsigned int sa_len,
@@ -185,7 +1229,6 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 	struct crypto4xx_alg *my_alg = crypto_alg_to_crypto4xx_alg(alg);
 	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct dynamic_sa_ctl *sa;
-	struct dynamic_sa_hash160 *sa_in;
 	int rc;
 
 	ctx->dev   = my_alg->dev;
@@ -210,6 +1253,9 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 
 	tfm->crt_ahash.reqsize = sizeof(struct crypto4xx_ctx);
 	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	/*
+	 * Setup hash algorithm and hash mode
+	 */
 	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
 				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
 				 SA_NO_HEADER_PROC, ha, SA_CIPHER_ALG_NULL,
@@ -220,13 +1266,12 @@ static int crypto4xx_hash_alg_init(struct crypto_tfm *tfm,
 				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
 				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
 				 SA_NOT_COPY_HDR);
+
+	BUG_ON(ha >= HASH_ALG_MAX_CNT);
+	sa->sa_contents = crypto4xx_sa_hash_tbl[0][ha];
 	ctx->direction = DIR_INBOUND;
-	sa->sa_contents = SA_HASH160_CONTENTS;
-	sa_in = (struct dynamic_sa_hash160 *) ctx->sa_in;
-	/* Need to zero hash digest in SA */
-	memset(sa_in->inner_digest, 0, sizeof(sa_in->inner_digest));
-	memset(sa_in->outer_digest, 0, sizeof(sa_in->outer_digest));
-	sa_in->state_ptr = ctx->state_record_dma_addr;
+	memcpy(ctx->sa_in + get_dynamic_sa_offset_state_ptr_field(ctx),
+		(void *)&ctx->state_record_dma_addr, 4);
 	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
 
 	return 0;
@@ -260,7 +1305,7 @@ int crypto4xx_hash_update(struct ahash_request *req)
 
 	return crypto4xx_build_pd(&req->base, ctx, req->src,
 				  (struct scatterlist *) req->result,
-				  req->nbytes, NULL, 0);
+				  req->nbytes, NULL, 0, NULL, 0);
 }
 
 int crypto4xx_hash_final(struct ahash_request *req)
@@ -278,16 +1323,431 @@ int crypto4xx_hash_digest(struct ahash_request *req)
 
 	return crypto4xx_build_pd(&req->base, ctx, req->src,
 				  (struct scatterlist *) req->result,
-				  req->nbytes, NULL, 0);
+				  req->nbytes, NULL, 0, NULL, 0);
 }
 
 /**
  * SHA1 Algorithm
  */
+
+int crypto4xx_md5_alg_init(struct crypto_tfm *tfm)
+{
+	return crypto4xx_hash_alg_init(tfm, SA_HASH128_LEN, SA_HASH_ALG_MD5,
+				       SA_HASH_MODE_HASH);
+}
+
+int crypto4xx_hash_hmac_setkey(struct crypto_ahash *hash,
+				      const u8 *key,
+				      unsigned int keylen,
+				      unsigned int sa_len,
+				      unsigned char ha,
+				      unsigned char hm,
+				      unsigned int max_keylen)
+{
+	struct crypto_tfm	*tfm = crypto_ahash_tfm(hash);
+	struct crypto_alg	*alg	 = tfm->__crt_alg;
+	struct crypto4xx_alg   *my_alg   = crypto_alg_to_crypto4xx_alg(alg);
+	struct crypto4xx_ctx	*ctx = crypto_tfm_ctx(tfm);
+	struct dynamic_sa_ctl *sa;
+	int bs 	= crypto_tfm_alg_blocksize(tfm);
+	int ds 	= crypto_ahash_digestsize(hash);
+	int rc;
+
+	ctx->dev = my_alg->dev;
+
+	if (keylen > max_keylen) {
+		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -1;
+	}
+
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		crypto4xx_free_sa(ctx);
+
+	/* Create SA */
+	rc = crypto4xx_alloc_sa(ctx, sa_len);
+	if (rc)
+		return rc;
+
+	if (ctx->state_record_dma_addr == 0) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc)
+			goto err;
+	}
+
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+
+	/*
+	 * Setup hash algorithm and hash mode
+	 */
+	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
+				 SA_NO_HEADER_PROC,
+				 ha, SA_CIPHER_ALG_NULL, SA_PAD_TYPE_ZERO,
+				 SA_OP_GROUP_BASIC, SA_OPCODE_HASH,
+				 DIR_INBOUND);
+	set_dynamic_sa_command_1(sa, 0, hm,
+				 CRYPTO_FEEDBACK_MODE_NO_FB,
+				 SA_EXTENDED_SN_OFF,
+				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
+				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
+				 SA_NOT_COPY_HDR);
+
+	BUG_ON(ha >= HASH_ALG_MAX_CNT);
+	sa->sa_contents = crypto4xx_sa_hash_tbl[0][ha];
+	ctx->direction = DIR_INBOUND;
+	memcpy((ctx->sa_in) + get_dynamic_sa_offset_state_ptr_field(ctx),
+	       (void *)&ctx->state_record_dma_addr, 4);
+
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+	rc = crypto4xx_pre_compute_hmac(ctx, (void *)key, keylen, bs, ha, ds);
+	if (rc) {
+		printk(KERN_ERR "Hmac Initial Digest Calculation failed\n");
+		goto err;
+	}
+
+	ctx->hash_final = 1;
+	ctx->is_hash = 1;
+
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+
+	return 0;
+err:
+	crypto4xx_free_sa(ctx);
+	return rc;
+}
+
+int crypto4xx_md5_hmac_setkey(struct crypto_ahash *hash, const u8 *key,
+			      unsigned int keylen)
+{
+	return crypto4xx_hash_hmac_setkey(hash, key, keylen, SA_HASH128_LEN,
+					  SA_HASH_ALG_MD5, SA_HASH_MODE_HMAC,
+					  256);
+}
+
+/**
+ * SHA1 and SHA2 Algorithm
+ *
+ */
 int crypto4xx_sha1_alg_init(struct crypto_tfm *tfm)
 {
 	return crypto4xx_hash_alg_init(tfm, SA_HASH160_LEN, SA_HASH_ALG_SHA1,
 				       SA_HASH_MODE_HASH);
 }
 
+int crypto4xx_sha1_hmac_setkey(struct crypto_ahash *hash, const u8 *key,
+			       unsigned int keylen)
+{
+	return crypto4xx_hash_hmac_setkey(hash, key, keylen, SA_HASH160_LEN,
+					  SA_HASH_ALG_SHA1, SA_HASH_MODE_HMAC,
+					  256);
+}
+
+int crypto4xx_sha2_alg_init(struct crypto_tfm *tfm)
+{
+	int ds = crypto_ahash_digestsize(__crypto_ahash_cast(tfm));
+	u8 ha;
+
+	switch (ds) {
+	default:
+	case 256/8:
+		ha = SA_HASH_ALG_SHA256;
+		break;
+	case 224/8:
+		ha = SA_HASH_ALG_SHA224;
+		break;
+	case 512/8:
+		ha = SA_HASH_ALG_SHA512;
+		break;
+	case 384/8:
+		ha = SA_HASH_ALG_SHA384;
+		break;
+	}
+	BUG_ON(ha >= HASH_ALG_MAX_CNT);
+
+	return crypto4xx_hash_alg_init(tfm,
+				       crypto4xx_sa_hash_tbl[2][ha], ha, 0);
+}
+
+int crypto4xx_sha2_hmac_setkey(struct crypto_ahash *hash,
+				      const u8 *key,
+				      unsigned int keylen)
+{
+	int ds = crypto_ahash_digestsize(hash);
+	unsigned char ha;
+
+	switch (ds) {
+	default:
+	case 256/8:
+		ha = SA_HASH_ALG_SHA256;
+		break;
+	case 224/8:
+		ha = SA_HASH_ALG_SHA224;
+		break;
+	case 512/8:
+		ha = SA_HASH_ALG_SHA512;
+		break;
+	case 384/8:
+		ha = SA_HASH_ALG_SHA384;
+		break;
+	}
+	BUG_ON(ha >= HASH_ALG_MAX_CNT);
+
+	return crypto4xx_hash_hmac_setkey(hash, key, keylen,
+					  crypto4xx_sa_hash_tbl[2][ha],
+					  ha,
+					  SA_HASH_MODE_HMAC,
+					  512);
+}
+
+/**
+ * AES-XCBC-MAC Algorithm
+ *
+ */
+int crypto4xx_xcbc_digest(const unsigned char *key,
+			  unsigned int keylen,
+			  u8 *sa_hash, int bs)
+{
+	struct scatterlist 	sg[1];
+	struct crypto_blkcipher *aes_tfm = NULL;
+	struct blkcipher_desc 	desc;
+	int rc;
+	u8 *digest;
+
+	/* Load pre-computed key value into SA */
+	aes_tfm = crypto_alloc_blkcipher("ecb(aes)", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(aes_tfm)) {
+		rc = PTR_ERR(aes_tfm);
+		printk(KERN_ERR "failed to load transform"
+				" for ecb(aes) error %d\n", rc);
+		goto err_alg;
+	}
+	desc.tfm    = aes_tfm;
+	desc.flags  = 0;
+	rc = crypto_blkcipher_setkey(desc.tfm, key, keylen);
+	if (rc) {
+		printk(KERN_ERR  "failed to load key error %d\n", rc);
+		goto err_alg;
+	}
+	digest =  kmalloc(16, GFP_KERNEL);
+	if (digest == NULL) {
+		rc = -ENOMEM;
+		goto err_alg;
+	}
+
+	memset(digest, 0x01, bs);
+	sg_init_one(&sg[0], digest, bs);
+	rc = crypto_blkcipher_encrypt(&desc, sg, sg, bs);
+	if (rc < 0) {
+		printk(KERN_ERR "failed to hash key error %d\n", rc);
+		goto err_alg;
+	}
+
+	crypto4xx_memcpy_le((void *) sa_hash, digest, bs);
+
+	memset(digest, 0x02, bs);
+	sg_init_one(&sg[0], digest, bs);
+	rc = crypto_blkcipher_encrypt(&desc, sg, sg, bs);
+	if (rc < 0) {
+		printk(KERN_ERR "failed to hash key error %d\n", rc);
+		goto err_alg;
+	}
+
+	sa_hash += 32;
+	crypto4xx_memcpy_le((void *) sa_hash, digest, bs);
+
+	memset(digest, 0x03, bs);
+	sg_init_one(&sg[0], digest, bs);
+	rc = crypto_blkcipher_encrypt(&desc, sg, sg, bs);
+	if (rc < 0) {
+		printk(KERN_ERR "failed to hash key error %d\n", rc);
+		goto err_alg;
+	}
+
+	sa_hash += 16;
+	crypto4xx_memcpy_le((void *) sa_hash, digest, bs);
+
+	crypto_free_blkcipher(aes_tfm);
+
+	return 0;
+err_alg:
+	if (aes_tfm)
+		crypto_free_blkcipher(aes_tfm);
+	return rc;
+}
+
+int crypto4xx_xcbc_setkey(struct crypto_ahash *hash,
+				      const u8 *key,
+				      unsigned int keylen)
+{
+	struct crypto_tfm    	*tfm = crypto_ahash_tfm(hash);
+	struct crypto4xx_ctx 	*ctx = crypto_tfm_ctx(tfm);
+	int bs = crypto_tfm_alg_blocksize(tfm);
+	struct dynamic_sa_ctl *sa;
+	u8 *sa_hash;
+	int rc = 0;
+
+	if (keylen != 128/8) {
+		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		 crypto4xx_free_sa(ctx);
+
+	/* Create SA */
+	rc = crypto4xx_alloc_sa(ctx, SA_AES128_XCBC_MAC_LEN);
+	if (rc)
+		return rc;
 
+	if (ctx->state_record_dma_addr == 0) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc) {
+			rc = -ENOMEM;
+			goto err;
+		}
+	}
+
+	ctx->direction = DIR_INBOUND;
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	/*
+	 * Setup hash algorithm and hash mode
+	 */
+	sa->sa_contents = SA_AES128_XCBC_MAC_CONTENTS;
+	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
+				 SA_NO_HEADER_PROC,
+				 SA_HASH_ALG_AES_XCBC_MAC_128,
+				 SA_CIPHER_ALG_NULL, SA_PAD_TYPE_ZERO,
+				 SA_OP_GROUP_BASIC, SA_OPCODE_HASH,
+				 DIR_INBOUND);
+	set_dynamic_sa_command_1(sa, 0, SA_HASH_MODE_HASH,
+				 CRYPTO_FEEDBACK_MODE_NO_FB,
+				 SA_EXTENDED_SN_OFF,
+				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
+				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
+				 SA_NOT_COPY_HDR);
+	crypto4xx_memcpy_le(ctx->sa_in + get_dynamic_sa_offset_key_field(ctx),
+			    key, keylen);
+
+	memcpy((void *)(ctx->sa_in +
+			get_dynamic_sa_offset_state_ptr_field(ctx)),
+		(void *)&ctx->state_record_dma_addr, 4);
+	ctx->is_hash = 1;
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+	sa_hash = (u8 *)(&(((struct dynamic_sa_aes128_xcbc_mac *)
+			ctx->sa_in)->inner_digest));
+	rc = crypto4xx_xcbc_digest(key, keylen, sa_hash, bs);
+	if (rc) {
+		printk(KERN_ERR "XCBC Digest Calculation Failed %d\n", rc);
+		goto err;
+	}
+
+	ctx->is_hash = 1;
+	ctx->hash_final = 1;
+	ctx->pd_ctl = 0x11;
+
+	ctx->direction = DIR_INBOUND;
+
+	memcpy(ctx->sa_out, ctx->sa_in, ctx->sa_len * 4);
+	sa = (struct dynamic_sa_ctl *) ctx->sa_out;
+	sa->sa_command_0.bf.dir = DIR_OUTBOUND;
+
+	return 0;
+err:
+	crypto4xx_free_sa(ctx);
+	return rc;
+}
+
+/**
+ * Kasumi F9 - Hash Algorithms
+ *
+ */
+int crypto4xx_kasumi_f9_setkey(struct crypto_ahash *hash,
+			       const u8 *key, unsigned int keylen)
+{
+	struct crypto_tfm	*tfm = crypto_ahash_tfm(hash);
+	struct crypto4xx_ctx	*ctx = crypto_tfm_ctx(tfm);
+	int 	rc;
+	struct dynamic_sa_ctl *sa;
+
+	if (keylen != 16) {
+		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	/* Create SA */
+	if (ctx->sa_in_dma_addr || ctx->sa_out_dma_addr)
+		 crypto4xx_free_sa(ctx);
+
+	rc = crypto4xx_alloc_sa(ctx, SA_KASUMI_F9_LEN);
+	if (rc)
+		return rc;
+
+	if (ctx->state_record_dma_addr == 0) {
+		rc = crypto4xx_alloc_state_record(ctx);
+		if (rc) {
+			crypto4xx_free_sa(ctx);
+			return rc;
+		}
+	}
+
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+	/*
+	 * Setup hash algorithm and hash mode
+	 */
+	set_dynamic_sa_command_0(sa, SA_SAVE_HASH, SA_NOT_SAVE_IV,
+				 SA_NOT_LOAD_HASH, SA_LOAD_IV_FROM_SA,
+				 SA_NO_HEADER_PROC, SA_HASH_ALG_KASUMI_f9,
+				 SA_CIPHER_ALG_NULL, SA_PAD_TYPE_ZERO,
+				 SA_OP_GROUP_BASIC, SA_OPCODE_HASH,
+				 DIR_INBOUND);
+	set_dynamic_sa_command_1(sa, 0, SA_HASH_MODE_HASH,
+				 CRYPTO_FEEDBACK_MODE_NO_FB, SA_EXTENDED_SN_OFF,
+				 SA_SEQ_MASK_OFF, SA_MC_ENABLE,
+				 SA_NOT_COPY_PAD, SA_NOT_COPY_PAYLOAD,
+				 SA_NOT_COPY_HDR);
+	sa->sa_contents = SA_KASUMI_F9_CONTENTS;
+
+	ctx->direction = DIR_INBOUND;
+	memcpy((void *)(ctx->sa_in +
+			get_dynamic_sa_offset_state_ptr_field(ctx)),
+			(void *)&ctx->state_record_dma_addr, 4);
+
+	crypto4xx_memcpy_le(ctx->sa_in +
+			get_dynamic_sa_offset_inner_digest(ctx), key, keylen);
+	ctx->offset_to_sr_ptr = get_dynamic_sa_offset_state_ptr_field(ctx);
+	ctx->is_hash = 1;
+	ctx->hash_final = 1;
+	ctx->pd_ctl = 0x11;
+	ctx->bypass = 4;
+
+	return 0;
+}
+
+int crypto4xx_kasumi_f9_digest(struct ahash_request *req)
+{
+	struct crypto4xx_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct scatterlist *src = req->src;
+	struct dynamic_sa_ctl *sa;
+	dma_addr_t addr;
+
+	/*
+	 * We have prepended count/fresh/direction/reserv total
+	 * 16byte before the plaintext
+	 * so, need to modify the length.
+	 * We doing so, to make use of tcrypt.c's hash_test.
+	 */
+	sa = (struct dynamic_sa_ctl *) ctx->sa_in;
+
+	addr = dma_map_page(NULL, sg_page(src), src->offset,
+			    src->length, DMA_TO_DEVICE);
+	crypto4xx_memcpy_le((void *)sa +
+			get_dynamic_sa_offset_outer_digest(ctx),
+			phys_to_virt(addr), 12);
+
+	return crypto4xx_build_pd(&req->base, ctx, req->src,
+				  (struct scatterlist *)req->result,
+				  req->nbytes, NULL, 0, NULL, 0);
+}
-- 
1.5.5

