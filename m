From: Catalin Vasile <catalin.vasile@freescale.com>
Subject: [PATCH] crypto: caam - add support for acipher xts(aes)
Date: Fri, 2 Oct 2015 13:13:18 +0300
Message-ID: <1443780798-11056-1-git-send-email-catalin.vasile@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Catalin Vasile <catalin.vasile@freescale.com>,
	Cristian Hristea <cristi.hristea@gmail.com>,
	Horia Geanta <horia.geanta@freescale.com>,
	"Alex Porosanu" <alexandru.porosanu@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0104.outbound.protection.outlook.com ([65.55.169.104]:25216
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750709AbbJBKN3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 06:13:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for AES working in XEX-based Tweaked-codebook mode with
ciphertext Stealing (XTS)

sector index - HW limitation: CAAM device supports sector index of only
8 bytes to be used for sector index inside IV, instead of whole 16 bytes
received on request. This represents 2 ^ 64 = 16,777,216 Tera of possible
values for sector index.

Signed-off-by: Cristian Hristea <cristi.hristea@gmail.com>
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
Signed-off-by: Catalin Vasile <catalin.vasile@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 138 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index ad0d1ec..ea8189f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1705,6 +1705,126 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	return ret;
 }
 
+static int xts_ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
+				 const u8 *key, unsigned int keylen)
+{
+	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
+	struct device *jrdev = ctx->jrdev;
+	u32 *key_jump_cmd, *desc;
+	__be64 sector_size = cpu_to_be64(512);
+
+	if (keylen != 2 * AES_MIN_KEY_SIZE  && keylen != 2 * AES_MAX_KEY_SIZE) {
+		crypto_ablkcipher_set_flags(ablkcipher,
+					    CRYPTO_TFM_RES_BAD_KEY_LEN);
+		dev_err(jrdev, "key size mismatch\n");
+		return -EINVAL;
+	}
+
+	memcpy(ctx->key, key, keylen);
+	ctx->key_dma = dma_map_single(jrdev, ctx->key, keylen, DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->key_dma)) {
+		dev_err(jrdev, "unable to map key i/o memory\n");
+		return -ENOMEM;
+	}
+	ctx->enckeylen = keylen;
+
+	/* xts_ablkcipher_encrypt shared descriptor */
+	desc = ctx->sh_desc_enc;
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
+	/* Load class1 keys only */
+	append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
+			  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+
+	/* Load sector size with index 40 bytes (0x28) */
+	append_cmd(desc, CMD_LOAD | IMMEDIATE | LDST_SRCDST_BYTE_CONTEXT |
+		   LDST_CLASS_1_CCB | (0x28 << LDST_OFFSET_SHIFT) | 8);
+	append_data(desc, (void *)&sector_size, 8);
+
+	set_jump_tgt_here(desc, key_jump_cmd);
+
+	/*
+	 * create sequence for loading the sector index
+	 * Upper 8B of IV - will be used as sector index
+	 * Lower 8B of IV - will be discarded
+	 */
+	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
+		   LDST_CLASS_1_CCB | (0x20 << LDST_OFFSET_SHIFT) | 8);
+	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
+
+	/* Load operation */
+	append_operation(desc, ctx->class1_alg_type | OP_ALG_AS_INITFINAL |
+			 OP_ALG_ENCRYPT);
+
+	/* Perform operation */
+	ablkcipher_append_src_dst(desc);
+
+	ctx->sh_desc_enc_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_enc_dma)) {
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR,
+		       "xts ablkcipher enc shdesc@" __stringify(__LINE__) ": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+#endif
+
+	/* xts_ablkcipher_decrypt shared descriptor */
+	desc = ctx->sh_desc_dec;
+
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
+	/* Load class1 key only */
+	append_key_as_imm(desc, (void *)ctx->key, ctx->enckeylen,
+			  ctx->enckeylen, CLASS_1 | KEY_DEST_CLASS_REG);
+
+	/* Load sector size with index 40 bytes (0x28) */
+	append_cmd(desc, CMD_LOAD | IMMEDIATE | LDST_SRCDST_BYTE_CONTEXT |
+		   LDST_CLASS_1_CCB | (0x28 << LDST_OFFSET_SHIFT) | 8);
+	append_data(desc, (void *)&sector_size, 8);
+
+	set_jump_tgt_here(desc, key_jump_cmd);
+
+	/*
+	 * create sequence for loading the sector index
+	 * Upper 8B of IV - will be used as sector index
+	 * Lower 8B of IV - will be discarded
+	 */
+	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
+		   LDST_CLASS_1_CCB | (0x20 << LDST_OFFSET_SHIFT) | 8);
+	append_seq_fifo_load(desc, 8, FIFOLD_CLASS_SKIP);
+
+	/* Load operation */
+	append_dec_op1(desc, ctx->class1_alg_type);
+
+	/* Perform operation */
+	ablkcipher_append_src_dst(desc);
+
+	ctx->sh_desc_dec_dma = dma_map_single(jrdev, desc, desc_bytes(desc),
+					      DMA_TO_DEVICE);
+	if (dma_mapping_error(jrdev, ctx->sh_desc_dec_dma)) {
+		dma_unmap_single(jrdev, ctx->sh_desc_enc_dma,
+				 desc_bytes(ctx->sh_desc_enc), DMA_TO_DEVICE);
+		dev_err(jrdev, "unable to map shared descriptor\n");
+		return -ENOMEM;
+	}
+#ifdef DEBUG
+	print_hex_dump(KERN_ERR,
+		       "xts ablkcipher dec shdesc@" __stringify(__LINE__) ": ",
+		       DUMP_PREFIX_ADDRESS, 16, 4, desc, desc_bytes(desc), 1);
+#endif
+
+	return 0;
+}
+
 /*
  * aead_edesc - s/w-extended aead descriptor
  * @assoc_nents: number of segments in associated data (SPI+Seq) scatterlist
@@ -2845,7 +2965,23 @@ static struct caam_alg_template driver_algs[] = {
 			.ivsize = CTR_RFC3686_IV_SIZE,
 			},
 		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_CTR_MOD128,
-	}
+	},
+	{
+		.name = "xts(aes)",
+		.driver_name = "xts-aes-caam",
+		.blocksize = AES_BLOCK_SIZE,
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.template_ablkcipher = {
+			.setkey = xts_ablkcipher_setkey,
+			.encrypt = ablkcipher_encrypt,
+			.decrypt = ablkcipher_decrypt,
+			.geniv = "eseqiv",
+			.min_keysize = 2 * AES_MIN_KEY_SIZE,
+			.max_keysize = 2 * AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.class1_alg_type = OP_ALG_ALGSEL_AES | OP_ALG_AAI_XTS,
+	},
 };
 
 static struct caam_aead_alg driver_aeads[] = {
-- 
1.8.3.1
