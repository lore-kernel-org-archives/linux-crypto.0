Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C317FC04E87
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 11:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 936BC2053B
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 11:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfEOLZz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 07:25:55 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51932 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732065AbfEOLZz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 07:25:55 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 07262200114;
        Wed, 15 May 2019 13:25:53 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id ED6B62000D3;
        Wed, 15 May 2019 13:25:52 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A26FD205F4;
        Wed, 15 May 2019 13:25:52 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH v2 1/2] crypto: caam - fix pkcs1pad(rsa-caam, sha256) failure because of invalid input
Date:   Wed, 15 May 2019 14:25:45 +0300
Message-Id: <1557919546-360-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The problem is with the input data size sent to CAAM for encrypt/decrypt.
Pkcs1pad is failing due to pkcs1 padding done in SW starting with0x01
instead of 0x00 0x01.
CAAM expects an input of modulus size. For this we strip the leading
zeros in case the size is more than modulus or pad the input with zeros
until the modulus size is reached.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
Changes since V1:
	- remove not needed initialization of a variable;
	- free resources on error path.
---
 drivers/crypto/caam/caampkc.c | 84 +++++++++++++++++++++++++++++++++++--------
 drivers/crypto/caam/caampkc.h |  2 ++
 2 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index fe24485..e356413 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -24,6 +24,10 @@
 				 sizeof(struct rsa_priv_f2_pdb))
 #define DESC_RSA_PRIV_F3_LEN	(2 * CAAM_CMD_SZ + \
 				 sizeof(struct rsa_priv_f3_pdb))
+#define CAAM_RSA_MAX_INPUT_SIZE	512 /* for a 4096-bit modulus */
+
+/* buffer filled with zeros, used for padding */
+static u8 *zero_buffer;
 
 static void rsa_io_unmap(struct device *dev, struct rsa_edesc *edesc,
 			 struct akcipher_request *req)
@@ -168,6 +172,13 @@ static void rsa_priv_f3_done(struct device *dev, u32 *desc, u32 err,
 	akcipher_request_complete(req, err);
 }
 
+/**
+ * Count leading zeros, need it to strip, from a given scatterlist
+ *
+ * @sgl   : scatterlist to count zeros from
+ * @nbytes: number of zeros, in bytes, to strip
+ * @flags : operation flags
+ */
 static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
 					unsigned int nbytes,
 					unsigned int flags)
@@ -187,7 +198,8 @@ static int caam_rsa_count_leading_zeros(struct scatterlist *sgl,
 	lzeros = 0;
 	len = 0;
 	while (nbytes > 0) {
-		while (len && !*buff) {
+		/* do not strip more than given bytes */
+		while (len && !*buff && lzeros < nbytes) {
 			lzeros++;
 			len--;
 			buff++;
@@ -218,6 +230,7 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *dev = ctx->dev;
 	struct caam_rsa_req_ctx *req_ctx = akcipher_request_ctx(req);
+	struct caam_rsa_key *key = &ctx->key;
 	struct rsa_edesc *edesc;
 	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
@@ -225,20 +238,37 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	int sgc;
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	int src_nents, dst_nents;
+	unsigned int diff_size = 0;
 	int lzeros;
 
-	lzeros = caam_rsa_count_leading_zeros(req->src, req->src_len, sg_flags);
-	if (lzeros < 0)
-		return ERR_PTR(lzeros);
-
-	req->src_len -= lzeros;
-	req->src = scatterwalk_ffwd(req_ctx->src, req->src, lzeros);
+	if (req->src_len > key->n_sz) {
+		/*
+		 * strip leading zeros and
+		 * return the number of zeros to skip
+		 */
+		lzeros = caam_rsa_count_leading_zeros(req->src, req->src_len -
+						      key->n_sz, sg_flags);
+		if (lzeros < 0)
+			return ERR_PTR(lzeros);
+
+		req->src_len -= lzeros;
+		req->src = scatterwalk_ffwd(req_ctx->src, req->src, lzeros);
+	} else {
+		/*
+		 * input src is less then n key modulus,
+		 * so there will be zero padding
+		 */
+		diff_size = key->n_sz - req->src_len;
+	}
 
 	src_nents = sg_nents_for_len(req->src, req->src_len);
 	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
 
-	if (src_nents > 1)
-		sec4_sg_len = src_nents;
+	if (!diff_size && src_nents == 1)
+		sec4_sg_len = 0; /* no need for an input hw s/g table */
+	else
+		sec4_sg_len = src_nents + !!diff_size;
+	sec4_sg_index = sec4_sg_len;
 	if (dst_nents > 1)
 		sec4_sg_len += dst_nents;
 
@@ -263,12 +293,14 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	}
 
 	edesc->sec4_sg = (void *)edesc + sizeof(*edesc) + desclen;
+	if (diff_size)
+		dma_to_sec4_sg_one(edesc->sec4_sg, ctx->padding_dma, diff_size,
+				   0);
+
+	if (sec4_sg_index)
+		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg +
+				   !!diff_size, 0);
 
-	sec4_sg_index = 0;
-	if (src_nents > 1) {
-		sg_to_sec4_sg_last(req->src, src_nents, edesc->sec4_sg, 0);
-		sec4_sg_index += src_nents;
-	}
 	if (dst_nents > 1)
 		sg_to_sec4_sg_last(req->dst, dst_nents,
 				   edesc->sec4_sg + sec4_sg_index, 0);
@@ -289,6 +321,10 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 
+	print_hex_dump_debug("caampkc sec4_sg@" __stringify(__LINE__) ": ",
+			     DUMP_PREFIX_ADDRESS, 16, 4, edesc->sec4_sg,
+			     edesc->sec4_sg_bytes, 1);
+
 	return edesc;
 
 sec4_sg_fail:
@@ -978,6 +1014,15 @@ static int caam_rsa_init_tfm(struct crypto_akcipher *tfm)
 		return PTR_ERR(ctx->dev);
 	}
 
+	ctx->padding_dma = dma_map_single(ctx->dev, zero_buffer,
+					  CAAM_RSA_MAX_INPUT_SIZE - 1,
+					  DMA_TO_DEVICE);
+	if (dma_mapping_error(ctx->dev, ctx->padding_dma)) {
+		dev_err(ctx->dev, "unable to map padding\n");
+		caam_jr_free(ctx->dev);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -987,6 +1032,8 @@ static void caam_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	struct caam_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct caam_rsa_key *key = &ctx->key;
 
+	dma_unmap_single(ctx->dev, ctx->padding_dma, CAAM_RSA_MAX_INPUT_SIZE -
+			 1, DMA_TO_DEVICE);
 	caam_rsa_free_key(key);
 	caam_jr_free(ctx->dev);
 }
@@ -1058,6 +1105,14 @@ static int __init caam_pkc_init(void)
 		goto out_put_dev;
 	}
 
+	/* allocate zero buffer, used for padding input */
+	zero_buffer = kzalloc(CAAM_RSA_MAX_INPUT_SIZE - 1, GFP_DMA |
+			      GFP_KERNEL);
+	if (!zero_buffer) {
+		err = -ENOMEM;
+		goto out_put_dev;
+	}
+
 	err = crypto_register_akcipher(&caam_rsa);
 	if (err)
 		dev_warn(ctrldev, "%s alg registration failed\n",
@@ -1072,6 +1127,7 @@ static int __init caam_pkc_init(void)
 
 static void __exit caam_pkc_exit(void)
 {
+	kfree(zero_buffer);
 	crypto_unregister_akcipher(&caam_rsa);
 }
 
diff --git a/drivers/crypto/caam/caampkc.h b/drivers/crypto/caam/caampkc.h
index 82645bc..5ac7201 100644
--- a/drivers/crypto/caam/caampkc.h
+++ b/drivers/crypto/caam/caampkc.h
@@ -89,10 +89,12 @@ struct caam_rsa_key {
  * caam_rsa_ctx - per session context.
  * @key         : RSA key in DMA zone
  * @dev         : device structure
+ * @padding_dma : dma address of padding, for adding it to the input
  */
 struct caam_rsa_ctx {
 	struct caam_rsa_key key;
 	struct device *dev;
+	dma_addr_t padding_dma;
 };
 
 /**
-- 
2.1.0

