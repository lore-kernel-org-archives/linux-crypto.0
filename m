Return-Path: <SRS0=HYoH=NT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva021.nxp.com ([92.121.34.21]:37060 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbeKHXMb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Nov 2018 18:12:31 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cristian Stoica <cristian.stoica@microchip.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 5/5] crypto: caam/qi2 - add support for Chacha20 + Poly1305
Date: Thu,  8 Nov 2018 15:36:31 +0200
Message-Id: <20181108133631.15779-6-horia.geanta@nxp.com>
In-Reply-To: <20181108133631.15779-1-horia.geanta@nxp.com>
References: <20181108133631.15779-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for Chacha20 + Poly1305 combined AEAD:
-generic (rfc7539)
-IPsec (rfc7634 - known as rfc7539esp in the kernel)

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c      |   4 +-
 drivers/crypto/caam/caamalg_desc.c |  24 ++++++-
 drivers/crypto/caam/caamalg_desc.h |   3 +-
 drivers/crypto/caam/caamalg_qi2.c  | 129 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 154 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index cbaeb264a261..523565ce0060 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -527,13 +527,13 @@ static int chachapoly_set_sh_desc(struct crypto_aead *aead)
 
 	desc = ctx->sh_desc_enc;
 	cnstr_shdsc_chachapoly(desc, &ctx->cdata, &ctx->adata, ivsize,
-			       ctx->authsize, true);
+			       ctx->authsize, true, false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_enc_dma,
 				   desc_bytes(desc), ctx->dir);
 
 	desc = ctx->sh_desc_dec;
 	cnstr_shdsc_chachapoly(desc, &ctx->cdata, &ctx->adata, ivsize,
-			       ctx->authsize, false);
+			       ctx->authsize, false, false);
 	dma_sync_single_for_device(jrdev, ctx->sh_desc_dec_dma,
 				   desc_bytes(desc), ctx->dir);
 
diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 0eb2add7e4e2..7db1640d3577 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -1227,10 +1227,12 @@ EXPORT_SYMBOL(cnstr_shdsc_rfc4543_decap);
  * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
  * @encap: true if encapsulation, false if decapsulation
+ * @is_qi: true when called from caam/qi
  */
 void cnstr_shdsc_chachapoly(u32 * const desc, struct alginfo *cdata,
 			    struct alginfo *adata, unsigned int ivsize,
-			    unsigned int icvsize, const bool encap)
+			    unsigned int icvsize, const bool encap,
+			    const bool is_qi)
 {
 	u32 *key_jump_cmd, *wait_cmd;
 	u32 nfifo;
@@ -1267,6 +1269,26 @@ void cnstr_shdsc_chachapoly(u32 * const desc, struct alginfo *cdata,
 				 OP_ALG_DECRYPT);
 	}
 
+	if (is_qi) {
+		u32 *wait_load_cmd;
+		u32 ctx1_iv_off = is_ipsec ? 8 : 4;
+
+		/* REG3 = assoclen */
+		append_seq_load(desc, 4, LDST_CLASS_DECO |
+				LDST_SRCDST_WORD_DECO_MATH3 |
+				4 << LDST_OFFSET_SHIFT);
+
+		wait_load_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+					    JUMP_COND_CALM | JUMP_COND_NCP |
+					    JUMP_COND_NOP | JUMP_COND_NIP |
+					    JUMP_COND_NIFP);
+		set_jump_tgt_here(desc, wait_load_cmd);
+
+		append_seq_load(desc, ivsize, LDST_CLASS_1_CCB |
+				LDST_SRCDST_BYTE_CONTEXT |
+				ctx1_iv_off << LDST_OFFSET_SHIFT);
+	}
+
 	/*
 	 * MAGIC with NFIFO
 	 * Read associated data from the input and send them to class1 and
diff --git a/drivers/crypto/caam/caamalg_desc.h b/drivers/crypto/caam/caamalg_desc.h
index a1a7b0e6889d..d5ca42ff961a 100644
--- a/drivers/crypto/caam/caamalg_desc.h
+++ b/drivers/crypto/caam/caamalg_desc.h
@@ -98,7 +98,8 @@ void cnstr_shdsc_rfc4543_decap(u32 * const desc, struct alginfo *cdata,
 
 void cnstr_shdsc_chachapoly(u32 * const desc, struct alginfo *cdata,
 			    struct alginfo *adata, unsigned int ivsize,
-			    unsigned int icvsize, const bool encap);
+			    unsigned int icvsize, const bool encap,
+			    const bool is_qi);
 
 void cnstr_shdsc_skcipher_encap(u32 * const desc, struct alginfo *cdata,
 				unsigned int ivsize, const bool is_rfc3686,
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a9e264bb9629..2598640aa98b 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -462,7 +462,15 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	edesc->dst_nents = dst_nents;
 	edesc->iv_dma = iv_dma;
 
-	edesc->assoclen = cpu_to_caam32(req->assoclen);
+	if ((alg->caam.class1_alg_type & OP_ALG_ALGSEL_MASK) ==
+	    OP_ALG_ALGSEL_CHACHA20 && ivsize != CHACHAPOLY_IV_SIZE)
+		/*
+		 * The associated data comes already with the IV but we need
+		 * to skip it when we authenticate or encrypt...
+		 */
+		edesc->assoclen = cpu_to_caam32(req->assoclen - ivsize);
+	else
+		edesc->assoclen = cpu_to_caam32(req->assoclen);
 	edesc->assoclen_dma = dma_map_single(dev, &edesc->assoclen, 4,
 					     DMA_TO_DEVICE);
 	if (dma_mapping_error(dev, edesc->assoclen_dma)) {
@@ -532,6 +540,68 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 	return edesc;
 }
 
+static int chachapoly_set_sh_desc(struct crypto_aead *aead)
+{
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+	struct device *dev = ctx->dev;
+	struct caam_flc *flc;
+	u32 *desc;
+
+	if (!ctx->cdata.keylen || !ctx->authsize)
+		return 0;
+
+	flc = &ctx->flc[ENCRYPT];
+	desc = flc->sh_desc;
+	cnstr_shdsc_chachapoly(desc, &ctx->cdata, &ctx->adata, ivsize,
+			       ctx->authsize, true, true);
+	flc->flc[1] = cpu_to_caam32(desc_len(desc)); /* SDL */
+	dma_sync_single_for_device(dev, ctx->flc_dma[ENCRYPT],
+				   sizeof(flc->flc) + desc_bytes(desc),
+				   ctx->dir);
+
+	flc = &ctx->flc[DECRYPT];
+	desc = flc->sh_desc;
+	cnstr_shdsc_chachapoly(desc, &ctx->cdata, &ctx->adata, ivsize,
+			       ctx->authsize, false, true);
+	flc->flc[1] = cpu_to_caam32(desc_len(desc)); /* SDL */
+	dma_sync_single_for_device(dev, ctx->flc_dma[DECRYPT],
+				   sizeof(flc->flc) + desc_bytes(desc),
+				   ctx->dir);
+
+	return 0;
+}
+
+static int chachapoly_setauthsize(struct crypto_aead *aead,
+				  unsigned int authsize)
+{
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+
+	if (authsize != POLY1305_DIGEST_SIZE)
+		return -EINVAL;
+
+	ctx->authsize = authsize;
+	return chachapoly_set_sh_desc(aead);
+}
+
+static int chachapoly_setkey(struct crypto_aead *aead, const u8 *key,
+			     unsigned int keylen)
+{
+	struct caam_ctx *ctx = crypto_aead_ctx(aead);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+	unsigned int saltlen = CHACHAPOLY_IV_SIZE - ivsize;
+
+	if (keylen != CHACHA20_KEY_SIZE + saltlen) {
+		crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	ctx->cdata.key_virt = key;
+	ctx->cdata.keylen = keylen - saltlen;
+
+	return chachapoly_set_sh_desc(aead);
+}
+
 static int gcm_set_sh_desc(struct crypto_aead *aead)
 {
 	struct caam_ctx *ctx = crypto_aead_ctx(aead);
@@ -2626,6 +2696,50 @@ static struct caam_aead_alg driver_aeads[] = {
 			.geniv = true,
 		},
 	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "rfc7539(chacha20,poly1305)",
+				.cra_driver_name = "rfc7539-chacha20-poly1305-"
+						   "caam-qi2",
+				.cra_blocksize = 1,
+			},
+			.setkey = chachapoly_setkey,
+			.setauthsize = chachapoly_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = CHACHAPOLY_IV_SIZE,
+			.maxauthsize = POLY1305_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_CHACHA20 |
+					   OP_ALG_AAI_AEAD,
+			.class2_alg_type = OP_ALG_ALGSEL_POLY1305 |
+					   OP_ALG_AAI_AEAD,
+		},
+	},
+	{
+		.aead = {
+			.base = {
+				.cra_name = "rfc7539esp(chacha20,poly1305)",
+				.cra_driver_name = "rfc7539esp-chacha20-"
+						   "poly1305-caam-qi2",
+				.cra_blocksize = 1,
+			},
+			.setkey = chachapoly_setkey,
+			.setauthsize = chachapoly_setauthsize,
+			.encrypt = aead_encrypt,
+			.decrypt = aead_decrypt,
+			.ivsize = 8,
+			.maxauthsize = POLY1305_DIGEST_SIZE,
+		},
+		.caam = {
+			.class1_alg_type = OP_ALG_ALGSEL_CHACHA20 |
+					   OP_ALG_AAI_AEAD,
+			.class2_alg_type = OP_ALG_ALGSEL_POLY1305 |
+					   OP_ALG_AAI_AEAD,
+		},
+	},
 	{
 		.aead = {
 			.base = {
@@ -4963,11 +5077,22 @@ static int dpaa2_caam_probe(struct fsl_mc_device *dpseci_dev)
 		    c1_alg_sel == OP_ALG_ALGSEL_AES)
 			continue;
 
+		/* Skip CHACHA20 algorithms if not supported by device */
+		if (c1_alg_sel == OP_ALG_ALGSEL_CHACHA20 &&
+		    !priv->sec_attr.ccha_acc_num)
+			continue;
+
+		/* Skip POLY1305 algorithms if not supported by device */
+		if (c2_alg_sel == OP_ALG_ALGSEL_POLY1305 &&
+		    !priv->sec_attr.ptha_acc_num)
+			continue;
+
 		/*
 		 * Skip algorithms requiring message digests
 		 * if MD not supported by device.
 		 */
-		if (!priv->sec_attr.md_acc_num && c2_alg_sel)
+		if ((c2_alg_sel & ~OP_ALG_ALGSEL_SUBMASK) == 0x40 &&
+		    !priv->sec_attr.md_acc_num)
 			continue;
 
 		t_alg->caam.dev = dev;
-- 
2.16.2
