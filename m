Return-Path: <SRS0=nWKA=DA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A8FC4741F
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 10:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EEE02083B
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Sep 2020 10:11:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="vC8ZfRkS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgIWKLr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Sep 2020 06:11:47 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35712 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbgIWKLr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Sep 2020 06:11:47 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08NABbuk108420;
        Wed, 23 Sep 2020 05:11:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1600855897;
        bh=4K3vXW+y7CSBk7IGrIqxIvxwgGJYatT30YgE1JdEAzI=;
        h=From:To:CC:Subject:Date;
        b=vC8ZfRkSqfWVutBZb0eJW7qgvgM+H+dUphaiHqHhhphe9WATl82Ynn1on7Q8DCcyh
         +r068/3RmjZD1vHGvgobCj/9O/++GJj45FfCVhWPOZxqSXwl6iHgLkNHNTZj2LCxQS
         5fKhpMnJ8+Y41GfN6nP7uiAXq7FXa17oigVdbqIo=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08NABbvY075902
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 05:11:37 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 23
 Sep 2020 05:11:36 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 23 Sep 2020 05:11:36 -0500
Received: from feketebors.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08NABYbD096066;
        Wed, 23 Sep 2020 05:11:34 -0500
From:   Peter Ujfalusi <peter.ujfalusi@ti.com>
To:     <herbert@gondor.apana.org.au>, <t-kristo@ti.com>,
        <davem@davemloft.net>, <hch@infradead.org>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <j-keerthy@ti.com>
Subject: [PATCH v2] crypto: sa2ul: Fix DMA mapping API usage
Date:   Wed, 23 Sep 2020 13:11:44 +0300
Message-ID: <20200923101144.24748-1-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Make sure that we call the dma_unmap_sg on the correct scatterlist on
completion with the correct sg_nents.

Use sg_table to managed the DMA mapping and at the same time add the needed
dma_sync calls for the sg_table.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi,

Changes since v1:
- use sg_table to manage the mapped sgl as suggested by Christoph

Regards,
Peter

 drivers/crypto/sa2ul.c | 215 ++++++++++++++++++++++-------------------
 1 file changed, 117 insertions(+), 98 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index a0b398ac6723..eda93fab95fe 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -142,34 +142,39 @@ struct sa_alg_tmpl {
 	bool registered;
 };
 
+/**
+ * struct sa_mapped_sg: scatterlist information for tx and rx
+ * @mapped: Set to true if the @sgt is mapped
+ * @dir: mapping direction used for @sgt
+ * @split_sg: Set if the sg is split and needs to be freed up
+ * @static_sg: Static scatterlist entry for overriding data
+ * @sgt: scatterlist table for DMA API use
+ */
+struct sa_mapped_sg {
+	bool mapped;
+	enum dma_data_direction dir;
+	struct scatterlist static_sg;
+	struct scatterlist *split_sg;
+	struct sg_table sgt;
+};
 /**
  * struct sa_rx_data: RX Packet miscellaneous data place holder
  * @req: crypto request data pointer
  * @ddev: pointer to the DMA device
  * @tx_in: dma_async_tx_descriptor pointer for rx channel
- * @split_src_sg: Set if the src sg is split and needs to be freed up
- * @split_dst_sg: Set if the dst sg is split and needs to be freed up
+ * @mapped_sg: Information on tx (0) and rx (1) scatterlist DMA mapping
  * @enc: Flag indicating either encryption or decryption
  * @enc_iv_size: Initialisation vector size
  * @iv_idx: Initialisation vector index
- * @rx_sg: Static scatterlist entry for overriding RX data
- * @tx_sg: Static scatterlist entry for overriding TX data
- * @src: Source data pointer
- * @dst: Destination data pointer
  */
 struct sa_rx_data {
 	void *req;
 	struct device *ddev;
 	struct dma_async_tx_descriptor *tx_in;
-	struct scatterlist *split_src_sg;
-	struct scatterlist *split_dst_sg;
+	struct sa_mapped_sg mapped_sg[2];
 	u8 enc;
 	u8 enc_iv_size;
 	u8 iv_idx;
-	struct scatterlist rx_sg;
-	struct scatterlist tx_sg;
-	struct scatterlist *src;
-	struct scatterlist *dst;
 };
 
 /**
@@ -976,23 +981,46 @@ static int sa_3des_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	return sa_cipher_setkey(tfm, key, keylen, &ad);
 }
 
+static void sa_sync_from_device(struct sa_rx_data *rxd)
+{
+	struct sg_table *sgt;
+
+	if (rxd->mapped_sg[0].dir == DMA_BIDIRECTIONAL)
+		sgt = &rxd->mapped_sg[0].sgt;
+	else
+		sgt = &rxd->mapped_sg[1].sgt;
+
+	dma_sync_sgtable_for_cpu(rxd->ddev, sgt, DMA_FROM_DEVICE);
+}
+
+static void sa_free_sa_rx_data(struct sa_rx_data *rxd)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(rxd->mapped_sg); i++) {
+		struct sa_mapped_sg *mapped_sg = &rxd->mapped_sg[i];
+
+		if (mapped_sg->mapped) {
+			dma_unmap_sgtable(rxd->ddev, &mapped_sg->sgt,
+					  mapped_sg->dir, 0);
+			kfree(mapped_sg->split_sg);
+		}
+	}
+
+	kfree(rxd);
+}
+
 static void sa_aes_dma_in_callback(void *data)
 {
 	struct sa_rx_data *rxd = (struct sa_rx_data *)data;
 	struct skcipher_request *req;
-	int sglen;
 	u32 *result;
 	__be32 *mdptr;
 	size_t ml, pl;
 	int i;
-	enum dma_data_direction dir_src;
-	bool diff_dst;
 
+	sa_sync_from_device(rxd);
 	req = container_of(rxd->req, struct skcipher_request, base);
-	sglen = sg_nents_for_len(req->src, req->cryptlen);
-
-	diff_dst = (req->src != req->dst) ? true : false;
-	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
 
 	if (req->iv) {
 		mdptr = (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl,
@@ -1003,18 +1031,7 @@ static void sa_aes_dma_in_callback(void *data)
 			result[i] = be32_to_cpu(mdptr[i + rxd->iv_idx]);
 	}
 
-	dma_unmap_sg(rxd->ddev, req->src, sglen, dir_src);
-	kfree(rxd->split_src_sg);
-
-	if (diff_dst) {
-		sglen = sg_nents_for_len(req->dst, req->cryptlen);
-
-		dma_unmap_sg(rxd->ddev, req->dst, sglen,
-			     DMA_FROM_DEVICE);
-		kfree(rxd->split_dst_sg);
-	}
-
-	kfree(rxd);
+	sa_free_sa_rx_data(rxd);
 
 	skcipher_request_complete(req, 0);
 }
@@ -1043,7 +1060,6 @@ static int sa_run(struct sa_req *req)
 	struct device *ddev;
 	struct dma_chan *dma_rx;
 	int sg_nents, src_nents, dst_nents;
-	int mapped_src_nents, mapped_dst_nents;
 	struct scatterlist *src, *dst;
 	size_t pl, ml, split_size;
 	struct sa_ctx_info *sa_ctx = req->enc ? &req->ctx->enc : &req->ctx->dec;
@@ -1052,6 +1068,7 @@ static int sa_run(struct sa_req *req)
 	u32 *mdptr;
 	bool diff_dst;
 	enum dma_data_direction dir_src;
+	struct sa_mapped_sg *mapped_sg;
 
 	gfp_flags = req->base->flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 		GFP_KERNEL : GFP_ATOMIC;
@@ -1082,6 +1099,7 @@ static int sa_run(struct sa_req *req)
 		dma_rx = pdata->dma_rx1;
 
 	ddev = dma_rx->device->dev;
+	rxd->ddev = ddev;
 
 	memcpy(cmdl, sa_ctx->cmdl, sa_ctx->cmdl_size);
 
@@ -1109,56 +1127,88 @@ static int sa_run(struct sa_req *req)
 
 	split_size = req->size;
 
+	mapped_sg = &rxd->mapped_sg[0];
 	if (sg_nents == 1 && split_size <= req->src->length) {
-		src = &rxd->rx_sg;
+		src = &mapped_sg->static_sg;
+		src_nents = 1;
 		sg_init_table(src, 1);
 		sg_set_page(src, sg_page(req->src), split_size,
 			    req->src->offset);
-		src_nents = 1;
-		dma_map_sg(ddev, src, sg_nents, dir_src);
+
+		mapped_sg->sgt.sgl = src;
+		mapped_sg->sgt.orig_nents = src_nents;
+		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
+		if (ret)
+			return ret;
+
+		mapped_sg->dir = dir_src;
+		mapped_sg->mapped = true;
 	} else {
-		mapped_src_nents = dma_map_sg(ddev, req->src, sg_nents,
-					      dir_src);
-		ret = sg_split(req->src, mapped_src_nents, 0, 1, &split_size,
-			       &src, &src_nents, gfp_flags);
+		mapped_sg->sgt.sgl = req->src;
+		mapped_sg->sgt.orig_nents = sg_nents;
+		ret = dma_map_sgtable(ddev, &mapped_sg->sgt, dir_src, 0);
+		if (ret)
+			return ret;
+
+		mapped_sg->dir = dir_src;
+		mapped_sg->mapped = true;
+
+		ret = sg_split(mapped_sg->sgt.sgl, mapped_sg->sgt.nents, 0, 1,
+			       &split_size, &src, &src_nents, gfp_flags);
 		if (ret) {
-			src_nents = sg_nents;
-			src = req->src;
+			src_nents = mapped_sg->sgt.nents;
+			src = mapped_sg->sgt.sgl;
 		} else {
-			rxd->split_src_sg = src;
+			mapped_sg->split_sg = src;
 		}
 	}
 
+	dma_sync_sgtable_for_device(ddev, &mapped_sg->sgt, DMA_TO_DEVICE);
+
 	if (!diff_dst) {
 		dst_nents = src_nents;
 		dst = src;
 	} else {
 		dst_nents = sg_nents_for_len(req->dst, req->size);
+		mapped_sg = &rxd->mapped_sg[1];
 
 		if (dst_nents == 1 && split_size <= req->dst->length) {
-			dst = &rxd->tx_sg;
+			dst = &mapped_sg->static_sg;
+			dst_nents = 1;
 			sg_init_table(dst, 1);
 			sg_set_page(dst, sg_page(req->dst), split_size,
 				    req->dst->offset);
-			dst_nents = 1;
-			dma_map_sg(ddev, dst, dst_nents, DMA_FROM_DEVICE);
+
+			mapped_sg->sgt.sgl = dst;
+			mapped_sg->sgt.orig_nents = dst_nents;
+			ret = dma_map_sgtable(ddev, &mapped_sg->sgt,
+					      DMA_FROM_DEVICE, 0);
+			if (ret)
+				goto err_cleanup;
+
+			mapped_sg->dir = DMA_FROM_DEVICE;
+			mapped_sg->mapped = true;
 		} else {
-			mapped_dst_nents = dma_map_sg(ddev, req->dst, dst_nents,
-						      DMA_FROM_DEVICE);
-			ret = sg_split(req->dst, mapped_dst_nents, 0, 1,
-				       &split_size, &dst, &dst_nents,
-				       gfp_flags);
+			mapped_sg->sgt.sgl = req->dst;
+			mapped_sg->sgt.orig_nents = dst_nents;
+			ret = dma_map_sgtable(ddev, &mapped_sg->sgt,
+					      DMA_FROM_DEVICE, 0);
 			if (ret)
-				dst = req->dst;
-			else
-				rxd->split_dst_sg = dst;
-		}
-	}
+				goto err_cleanup;
 
-	if (unlikely(src_nents != sg_nents)) {
-		dev_warn_ratelimited(sa_k3_dev, "failed to map tx pkt\n");
-		ret = -EIO;
-		goto err_cleanup;
+			mapped_sg->dir = DMA_FROM_DEVICE;
+			mapped_sg->mapped = true;
+
+			ret = sg_split(mapped_sg->sgt.sgl, mapped_sg->sgt.nents,
+				       0, 1, &split_size, &dst, &dst_nents,
+				       gfp_flags);
+			if (ret) {
+				dst_nents = mapped_sg->sgt.nents;
+				dst = mapped_sg->sgt.sgl;
+			} else {
+				mapped_sg->split_sg = dst;
+			}
+		}
 	}
 
 	rxd->tx_in = dmaengine_prep_slave_sg(dma_rx, dst, dst_nents,
@@ -1172,9 +1222,6 @@ static int sa_run(struct sa_req *req)
 
 	rxd->req = (void *)req->base;
 	rxd->enc = req->enc;
-	rxd->ddev = ddev;
-	rxd->src = src;
-	rxd->dst = dst;
 	rxd->iv_idx = req->ctx->iv_idx;
 	rxd->enc_iv_size = sa_ctx->cmdl_upd_info.enc_iv.size;
 	rxd->tx_in->callback = req->callback;
@@ -1212,16 +1259,7 @@ static int sa_run(struct sa_req *req)
 	return -EINPROGRESS;
 
 err_cleanup:
-	dma_unmap_sg(ddev, req->src, sg_nents, DMA_TO_DEVICE);
-	kfree(rxd->split_src_sg);
-
-	if (req->src != req->dst) {
-		dst_nents = sg_nents_for_len(req->dst, req->size);
-		dma_unmap_sg(ddev, req->dst, dst_nents, DMA_FROM_DEVICE);
-		kfree(rxd->split_dst_sg);
-	}
-
-	kfree(rxd);
+	sa_free_sa_rx_data(rxd);
 
 	return ret;
 }
@@ -1291,11 +1329,12 @@ static void sa_sha_dma_in_callback(void *data)
 	struct ahash_request *req;
 	struct crypto_ahash *tfm;
 	unsigned int authsize;
-	int i, sg_nents;
+	int i;
 	size_t ml, pl;
 	u32 *result;
 	__be32 *mdptr;
 
+	sa_sync_from_device(rxd);
 	req = container_of(rxd->req, struct ahash_request, base);
 	tfm = crypto_ahash_reqtfm(req);
 	authsize = crypto_ahash_digestsize(tfm);
@@ -1306,12 +1345,7 @@ static void sa_sha_dma_in_callback(void *data)
 	for (i = 0; i < (authsize / 4); i++)
 		result[i] = be32_to_cpu(mdptr[i + 4]);
 
-	sg_nents = sg_nents_for_len(req->src, req->nbytes);
-	dma_unmap_sg(rxd->ddev, req->src, sg_nents, DMA_FROM_DEVICE);
-
-	kfree(rxd->split_src_sg);
-
-	kfree(rxd);
+	sa_free_sa_rx_data(rxd);
 
 	ahash_request_complete(req, 0);
 }
@@ -1635,43 +1669,28 @@ static void sa_aead_dma_in_callback(void *data)
 	unsigned int authsize;
 	u8 auth_tag[SA_MAX_AUTH_TAG_SZ];
 	size_t pl, ml;
-	int i, sglen;
+	int i;
 	int err = 0;
 	u16 auth_len;
 	u32 *mdptr;
-	bool diff_dst;
-	enum dma_data_direction dir_src;
 
+	sa_sync_from_device(rxd);
 	req = container_of(rxd->req, struct aead_request, base);
 	tfm = crypto_aead_reqtfm(req);
 	start = req->assoclen + req->cryptlen;
 	authsize = crypto_aead_authsize(tfm);
 
-	diff_dst = (req->src != req->dst) ? true : false;
-	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
-
 	mdptr = (u32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl, &ml);
 	for (i = 0; i < (authsize / 4); i++)
 		mdptr[i + 4] = swab32(mdptr[i + 4]);
 
 	auth_len = req->assoclen + req->cryptlen;
-	if (!rxd->enc)
-		auth_len -= authsize;
-
-	sglen =  sg_nents_for_len(rxd->src, auth_len);
-	dma_unmap_sg(rxd->ddev, rxd->src, sglen, dir_src);
-	kfree(rxd->split_src_sg);
-
-	if (diff_dst) {
-		sglen = sg_nents_for_len(rxd->dst, auth_len);
-		dma_unmap_sg(rxd->ddev, rxd->dst, sglen, DMA_FROM_DEVICE);
-		kfree(rxd->split_dst_sg);
-	}
 
 	if (rxd->enc) {
 		scatterwalk_map_and_copy(&mdptr[4], req->dst, start, authsize,
 					 1);
 	} else {
+		auth_len -= authsize;
 		start -= authsize;
 		scatterwalk_map_and_copy(auth_tag, req->src, start, authsize,
 					 0);
@@ -1679,7 +1698,7 @@ static void sa_aead_dma_in_callback(void *data)
 		err = memcmp(&mdptr[4], auth_tag, authsize) ? -EBADMSG : 0;
 	}
 
-	kfree(rxd);
+	sa_free_sa_rx_data(rxd);
 
 	aead_request_complete(req, err);
 }
-- 
Peter

Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

