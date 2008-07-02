From: Lee Nipper <lee.nipper@freescale.com>
Subject: [PATCH] [CRYPTO] talitos: Add support for 3des.
Date: Wed, 02 Jul 2008 17:48:43 -0500
Message-ID: <1215038923.24641.9.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw01.freescale.net ([192.88.158.102]:41677 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYGBWlv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Jul 2008 18:41:51 -0400
Received: from az33smr02.freescale.net (az33smr02.freescale.net [10.64.34.200])
	by az33egw01.freescale.net (8.12.11/az33egw01) with ESMTP id m62Mfl7j009994
	for <linux-crypto@vger.kernel.org>; Wed, 2 Jul 2008 15:41:48 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net [10.64.32.16])
	by az33smr02.freescale.net (8.13.1/8.13.0) with ESMTP id m62MfjLt010179
	for <linux-crypto@vger.kernel.org>; Wed, 2 Jul 2008 17:41:46 -0500 (CDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds support for authenc(hmac(sha1),cbc(des3_ede))
to the talitos crypto driver for the Freescale Security Engine.
Some adjustments were made to the scatterlist to link table conversion
to make 3des work for ping -s 1439..1446.

Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
---
This patch applies against cryptodev-2.6 tree at
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git.

 drivers/crypto/talitos.c |   93 +++++++++++++++++++++++++++++++++------------
 drivers/crypto/talitos.h |    3 +-
 2 files changed, 69 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index e123312..e8459e0 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -642,20 +642,24 @@ static void talitos_unregister_rng(struct device *dev)
 #define TALITOS_MAX_KEY_SIZE		64
 #define TALITOS_MAX_AUTH_SIZE		20
 #define TALITOS_AES_MIN_BLOCK_SIZE	16
+#define TALITOS_3DES_MIN_BLOCK_SIZE	24
+
 #define TALITOS_AES_IV_LENGTH		16
+#define TALITOS_3DES_IV_LENGTH		8
+#define TALITOS_MAX_IV_LENGTH		16
 
 struct talitos_ctx {
 	struct device *dev;
 	__be32 desc_hdr_template;
 	u8 key[TALITOS_MAX_KEY_SIZE];
-	u8 iv[TALITOS_AES_IV_LENGTH];
+	u8 iv[TALITOS_MAX_IV_LENGTH];
 	unsigned int keylen;
 	unsigned int enckeylen;
 	unsigned int authkeylen;
 	unsigned int authsize;
 };
 
-static int aes_cbc_sha1_hmac_authenc_setauthsize(struct crypto_aead *authenc,
+static int aead_authenc_setauthsize(struct crypto_aead *authenc,
 						 unsigned int authsize)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
@@ -665,7 +669,7 @@ static int aes_cbc_sha1_hmac_authenc_setauthsize(struct crypto_aead *authenc,
 	return 0;
 }
 
-static int aes_cbc_sha1_hmac_authenc_setkey(struct crypto_aead *authenc,
+static int aead_authenc_setkey(struct crypto_aead *authenc,
 					    const u8 *key, unsigned int keylen)
 {
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
@@ -825,10 +829,12 @@ static void ipsec_esp_decrypt_done(struct device *dev,
  * convert scatterlist to SEC h/w link table format
  * stop at cryptlen bytes
  */
-static void sg_to_link_tbl(struct scatterlist *sg, int sg_count,
+static int sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 			   int cryptlen, struct talitos_ptr *link_tbl_ptr)
 {
-	while (cryptlen > 0) {
+	int n_sg = sg_count;
+
+	while (n_sg--) {
 		link_tbl_ptr->ptr = cpu_to_be32(sg_dma_address(sg));
 		link_tbl_ptr->len = cpu_to_be16(sg_dma_len(sg));
 		link_tbl_ptr->j_extent = 0;
@@ -837,13 +843,22 @@ static void sg_to_link_tbl(struct scatterlist *sg, int sg_count,
 		sg = sg_next(sg);
 	}
 
-	/* adjust (decrease) last entry's len to cryptlen */
+	/* adjust (decrease) last one (or two) entry's len to cryptlen */
 	link_tbl_ptr--;
+	while (link_tbl_ptr->len <= (-cryptlen)) {
+		/* Empty this entry, and move to previous one */
+		cryptlen += be16_to_cpu(link_tbl_ptr->len);
+		link_tbl_ptr->len = 0;
+		sg_count--;
+		link_tbl_ptr--;
+	}
 	link_tbl_ptr->len = cpu_to_be16(be16_to_cpu(link_tbl_ptr->len)
 					+ cryptlen);
 
 	/* tag end of link table */
 	link_tbl_ptr->j_extent = DESC_PTR_LNKTBL_RETURN;
+
+	return sg_count;
 }
 
 /*
@@ -900,12 +915,17 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	if (sg_count == 1) {
 		desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
 	} else {
-		sg_to_link_tbl(areq->src, sg_count, cryptlen,
-			       &edesc->link_tbl[0]);
-		desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
-		desc->ptr[4].ptr = cpu_to_be32(edesc->dma_link_tbl);
-		dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
+		sg_count = sg_to_link_tbl(areq->src, sg_count, cryptlen,
+					  &edesc->link_tbl[0]);
+		if (sg_count > 1) {
+			desc->ptr[4].j_extent |= DESC_PTR_LNKTBL_JUMP;
+			desc->ptr[4].ptr = cpu_to_be32(edesc->dma_link_tbl);
+			dma_sync_single_for_device(ctx->dev, edesc->dma_link_tbl,
+						   edesc->dma_len, DMA_BIDIRECTIONAL);
+		} else {
+			/* Only one segment now, so no link tbl needed */
+			desc->ptr[4].ptr = cpu_to_be32(sg_dma_address(areq->src));
+		}
 	}
 
 	/* cipher out */
@@ -931,8 +951,8 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 			memcpy(link_tbl_ptr, &edesc->link_tbl[0],
 			       edesc->src_nents * sizeof(struct talitos_ptr));
 		} else {
-			sg_to_link_tbl(areq->dst, sg_count, cryptlen,
-				       link_tbl_ptr);
+			sg_count = sg_to_link_tbl(areq->dst, sg_count, cryptlen,
+						  link_tbl_ptr);
 		}
 		link_tbl_ptr += sg_count - 1;
 
@@ -1038,7 +1058,7 @@ static struct ipsec_esp_edesc *ipsec_esp_edesc_alloc(struct aead_request *areq,
 	return edesc;
 }
 
-static int aes_cbc_sha1_hmac_authenc_encrypt(struct aead_request *req)
+static int aead_authenc_encrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
@@ -1050,12 +1070,12 @@ static int aes_cbc_sha1_hmac_authenc_encrypt(struct aead_request *req)
 		return PTR_ERR(edesc);
 
 	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_AESU_ENC;
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
 	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_encrypt_done);
 }
 
-static int aes_cbc_sha1_hmac_authenc_decrypt(struct aead_request *req)
+static int aead_authenc_decrypt(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
 	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
@@ -1089,7 +1109,7 @@ static int aes_cbc_sha1_hmac_authenc_decrypt(struct aead_request *req)
 	return ipsec_esp(edesc, req, NULL, 0, ipsec_esp_decrypt_done);
 }
 
-static int aes_cbc_sha1_hmac_authenc_givencrypt(
+static int aead_authenc_givencrypt(
 	struct aead_givcrypt_request *req)
 {
 	struct aead_request *areq = &req->areq;
@@ -1103,7 +1123,7 @@ static int aes_cbc_sha1_hmac_authenc_givencrypt(
 		return PTR_ERR(edesc);
 
 	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_AESU_ENC;
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
 
 	memcpy(req->giv, ctx->iv, crypto_aead_ivsize(authenc));
 
@@ -1127,11 +1147,11 @@ static struct talitos_alg_template driver_algs[] = {
 		.driver_name = "authenc(hmac(sha1-talitos),cbc(aes-talitos))",
 		.blocksize = TALITOS_AES_MIN_BLOCK_SIZE,
 		.aead = {
-			.setkey = aes_cbc_sha1_hmac_authenc_setkey,
-			.setauthsize = aes_cbc_sha1_hmac_authenc_setauthsize,
-			.encrypt = aes_cbc_sha1_hmac_authenc_encrypt,
-			.decrypt = aes_cbc_sha1_hmac_authenc_decrypt,
-			.givencrypt = aes_cbc_sha1_hmac_authenc_givencrypt,
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
 			.geniv = "<built-in>",
 			.ivsize = TALITOS_AES_IV_LENGTH,
 			.maxauthsize = TALITOS_MAX_AUTH_SIZE,
@@ -1143,6 +1163,29 @@ static struct talitos_alg_template driver_algs[] = {
 		                     DESC_HDR_MODE1_MDEU_INIT |
 		                     DESC_HDR_MODE1_MDEU_PAD |
 		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{
+		.name = "authenc(hmac(sha1),cbc(des3_ede))",
+		.driver_name = "authenc(hmac(sha1-talitos),cbc(3des-talitos))",
+		.blocksize = TALITOS_3DES_MIN_BLOCK_SIZE,
+		.aead = {
+			.setkey = aead_authenc_setkey,
+			.setauthsize = aead_authenc_setauthsize,
+			.encrypt = aead_authenc_encrypt,
+			.decrypt = aead_authenc_decrypt,
+			.givencrypt = aead_authenc_givencrypt,
+			.geniv = "<built-in>",
+			.ivsize = TALITOS_3DES_IV_LENGTH,
+			.maxauthsize = TALITOS_MAX_AUTH_SIZE,
+			},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+			             DESC_HDR_SEL0_DEU |
+		                     DESC_HDR_MODE0_DEU_CBC |
+		                     DESC_HDR_MODE0_DEU_3DES |
+		                     DESC_HDR_SEL1_MDEUA |
+		                     DESC_HDR_MODE1_MDEU_INIT |
+		                     DESC_HDR_MODE1_MDEU_PAD |
+		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
 	}
 };
 
@@ -1166,7 +1209,7 @@ static int talitos_cra_init(struct crypto_tfm *tfm)
 	ctx->desc_hdr_template = talitos_alg->desc_hdr_template;
 
 	/* random first IV */
-	get_random_bytes(ctx->iv, TALITOS_AES_IV_LENGTH);
+	get_random_bytes(ctx->iv, TALITOS_MAX_IV_LENGTH);
 
 	return 0;
 }
diff --git a/drivers/crypto/talitos.h b/drivers/crypto/talitos.h
index de0e377..c48a405 100644
--- a/drivers/crypto/talitos.h
+++ b/drivers/crypto/talitos.h
@@ -144,11 +144,10 @@
 #define	DESC_HDR_SEL0_CRCU		__constant_cpu_to_be32(0x80000000)
 
 /* primary execution unit mode (MODE0) and derivatives */
+#define	DESC_HDR_MODE0_ENCRYPT		__constant_cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_AESU_CBC		__constant_cpu_to_be32(0x00200000)
-#define	DESC_HDR_MODE0_AESU_ENC		__constant_cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_DEU_CBC		__constant_cpu_to_be32(0x00400000)
 #define	DESC_HDR_MODE0_DEU_3DES		__constant_cpu_to_be32(0x00200000)
-#define	DESC_HDR_MODE0_DEU_ENC		__constant_cpu_to_be32(0x00100000)
 #define	DESC_HDR_MODE0_MDEU_INIT	__constant_cpu_to_be32(0x01000000)
 #define	DESC_HDR_MODE0_MDEU_HMAC	__constant_cpu_to_be32(0x00800000)
 #define	DESC_HDR_MODE0_MDEU_PAD		__constant_cpu_to_be32(0x00400000)
-- 
1.5.6.1


