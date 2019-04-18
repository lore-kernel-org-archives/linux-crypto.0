Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8E6C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6D18217FA
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 13:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389041AbfDRNje (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:39:34 -0400
Received: from foss.arm.com ([217.140.101.70]:33440 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733192AbfDRNjd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 09:39:33 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05E8680D;
        Thu, 18 Apr 2019 06:39:33 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (e110176-lin.kfn.arm.com [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5490E3F5AF;
        Thu, 18 Apr 2019 06:39:31 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/35] crypto: ccree: move key load desc. before flow desc.
Date:   Thu, 18 Apr 2019 16:38:37 +0300
Message-Id: <20190418133913.9122-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190418133913.9122-1-gilad@benyossef.com>
References: <20190418133913.9122-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor the descriptor setup code in order to move the key loading
descriptor to one before last position. This has no effect on current
functionality but is needed for later support of Content Protection
Policy keys.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 107 +++++++++++++++++++++----------
 1 file changed, 73 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 0abcdc224ab0..dcab96861d6f 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -399,7 +399,7 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	return 0;
 }
 
-static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
+static void cc_setup_state_desc(struct crypto_tfm *tfm,
 				 struct cipher_req_ctx *req_ctx,
 				 unsigned int ivsize, unsigned int nbytes,
 				 struct cc_hw_desc desc[],
@@ -423,11 +423,13 @@ static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
 		du_size = cc_alg->data_unit;
 
 	switch (cipher_mode) {
+	case DRV_CIPHER_ECB:
+		break;
 	case DRV_CIPHER_CBC:
 	case DRV_CIPHER_CBC_CTS:
 	case DRV_CIPHER_CTR:
 	case DRV_CIPHER_OFB:
-		/* Load cipher state */
+		/* Load IV */
 		hw_desc_init(&desc[*seq_size]);
 		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr, ivsize,
 			     NS_BIT);
@@ -441,7 +443,71 @@ static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
 			set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE0);
 		}
 		(*seq_size)++;
-		/*FALLTHROUGH*/
+		break;
+	case DRV_CIPHER_XTS:
+	case DRV_CIPHER_ESSIV:
+	case DRV_CIPHER_BITLOCKER:
+		/* load XEX key */
+		hw_desc_init(&desc[*seq_size]);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		if (cc_is_hw_key(tfm)) {
+			set_hw_crypto_key(&desc[*seq_size],
+					  ctx_p->hw.key2_slot);
+		} else {
+			set_din_type(&desc[*seq_size], DMA_DLLI,
+				     (key_dma_addr + (key_len / 2)),
+				     (key_len / 2), NS_BIT);
+		}
+		set_xex_data_unit_size(&desc[*seq_size], du_size);
+		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
+		(*seq_size)++;
+
+		/* Load IV */
+		hw_desc_init(&desc[*seq_size]);
+		set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
+		set_cipher_mode(&desc[*seq_size], cipher_mode);
+		set_cipher_config0(&desc[*seq_size], direction);
+		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_flow_mode(&desc[*seq_size], flow_mode);
+		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr,
+			     CC_AES_BLOCK_SIZE, NS_BIT);
+		(*seq_size)++;
+		break;
+	default:
+		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
+	}
+}
+
+
+static void cc_setup_key_desc(struct crypto_tfm *tfm,
+			      struct cipher_req_ctx *req_ctx,
+			      unsigned int nbytes, struct cc_hw_desc desc[],
+			      unsigned int *seq_size)
+{
+	struct cc_cipher_ctx *ctx_p = crypto_tfm_ctx(tfm);
+	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
+	int cipher_mode = ctx_p->cipher_mode;
+	int flow_mode = ctx_p->flow_mode;
+	int direction = req_ctx->gen_ctx.op_type;
+	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
+	unsigned int key_len = ctx_p->keylen;
+	unsigned int du_size = nbytes;
+
+	struct cc_crypto_alg *cc_alg =
+		container_of(tfm->__crt_alg, struct cc_crypto_alg,
+			     skcipher_alg.base);
+
+	if (cc_alg->data_unit)
+		du_size = cc_alg->data_unit;
+
+	switch (cipher_mode) {
+	case DRV_CIPHER_CBC:
+	case DRV_CIPHER_CBC_CTS:
+	case DRV_CIPHER_CTR:
+	case DRV_CIPHER_OFB:
 	case DRV_CIPHER_ECB:
 		/* Load key */
 		hw_desc_init(&desc[*seq_size]);
@@ -486,35 +552,6 @@ static void cc_setup_cipher_desc(struct crypto_tfm *tfm,
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		set_setup_mode(&desc[*seq_size], SETUP_LOAD_KEY0);
 		(*seq_size)++;
-
-		/* load XEX key */
-		hw_desc_init(&desc[*seq_size]);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		if (cc_is_hw_key(tfm)) {
-			set_hw_crypto_key(&desc[*seq_size],
-					  ctx_p->hw.key2_slot);
-		} else {
-			set_din_type(&desc[*seq_size], DMA_DLLI,
-				     (key_dma_addr + (key_len / 2)),
-				     (key_len / 2), NS_BIT);
-		}
-		set_xex_data_unit_size(&desc[*seq_size], du_size);
-		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
-		set_key_size_aes(&desc[*seq_size], (key_len / 2));
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
-		(*seq_size)++;
-
-		/* Set state */
-		hw_desc_init(&desc[*seq_size]);
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		set_key_size_aes(&desc[*seq_size], (key_len / 2));
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr,
-			     CC_AES_BLOCK_SIZE, NS_BIT);
-		(*seq_size)++;
 		break;
 	default:
 		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
@@ -755,8 +792,10 @@ static int cc_cipher_process(struct skcipher_request *req,
 
 	/* STAT_PHASE_2: Create sequence */
 
-	/* Setup processing */
-	cc_setup_cipher_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
+	/* Setup IV and XEX key used */
+	cc_setup_state_desc(tfm, req_ctx, ivsize, nbytes, desc, &seq_len);
+	/* Setup key */
+	cc_setup_key_desc(tfm, req_ctx, nbytes, desc, &seq_len);
 	/* Data processing */
 	cc_setup_cipher_data(tfm, req_ctx, dst, src, nbytes, req, desc,
 			     &seq_len);
-- 
2.21.0

