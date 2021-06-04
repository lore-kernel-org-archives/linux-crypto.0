Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA48CC47082
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 01:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D582B61263
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Jun 2021 01:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFDBda (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 21:33:30 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7098 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhFDBd3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 21:33:29 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fx4t10KXPzYqcf;
        Fri,  4 Jun 2021 09:28:57 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 09:31:42 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 09:31:42 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 4/4] crypto: hisilicon/sec - modify the SEC request structure
Date:   Fri, 4 Jun 2021 09:31:29 +0800
Message-ID: <1622770289-21588-5-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622770289-21588-1-git-send-email-yekai13@huawei.com>
References: <1622770289-21588-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Modify the SEC request structure, combines two common parameters of the
SEC request into one parameter.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  7 ++++--
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 34 +++++++++++++++---------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 3fe7875..018415b 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -21,8 +21,6 @@ struct sec_alg_res {
 
 /* Cipher request of SEC private */
 struct sec_cipher_req {
-	struct hisi_acc_hw_sgl *c_in;
-	dma_addr_t c_in_dma;
 	struct hisi_acc_hw_sgl *c_out;
 	dma_addr_t c_out_dma;
 	u8 *c_ivin;
@@ -49,6 +47,11 @@ struct sec_req {
 	struct sec_ctx *ctx;
 	struct sec_qp_ctx *qp_ctx;
 
+	/**
+	 * Common parameter of the SEC request.
+	 */
+	struct hisi_acc_hw_sgl *in;
+	dma_addr_t in_dma;
 	struct sec_cipher_req c_req;
 	struct sec_aead_req aead_req;
 	struct list_head backlog_head;
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 75122f0..f23af61 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -871,8 +871,8 @@ static int sec_cipher_pbuf_map(struct sec_ctx *ctx, struct sec_req *req,
 		memcpy(a_req->out_mac, mac_offset, authsize);
 	}
 
-	c_req->c_in_dma = qp_ctx->res[req_id].pbuf_dma;
-	c_req->c_out_dma = c_req->c_in_dma;
+	req->in_dma = qp_ctx->res[req_id].pbuf_dma;
+	c_req->c_out_dma = req->in_dma;
 
 	return 0;
 }
@@ -950,14 +950,13 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 		a_req->out_mac_dma = res->out_mac_dma;
 	}
 
-	c_req->c_in = hisi_acc_sg_buf_map_to_hw_sgl(dev, src,
-						    qp_ctx->c_in_pool,
-						    req->req_id,
-						    &c_req->c_in_dma);
-
-	if (IS_ERR(c_req->c_in)) {
+	req->in = hisi_acc_sg_buf_map_to_hw_sgl(dev, src,
+						qp_ctx->c_in_pool,
+						req->req_id,
+						&req->in_dma);
+	if (IS_ERR(req->in)) {
 		dev_err(dev, "fail to dma map input sgl buffers!\n");
-		return PTR_ERR(c_req->c_in);
+		return PTR_ERR(req->in);
 	}
 
 	if (!c_req->encrypt && ctx->alg_type == SEC_AEAD) {
@@ -967,9 +966,10 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 			return ret;
 		}
 	}
+
 	if (dst == src) {
-		c_req->c_out = c_req->c_in;
-		c_req->c_out_dma = c_req->c_in_dma;
+		c_req->c_out = req->in;
+		c_req->c_out_dma = req->in_dma;
 	} else {
 		c_req->c_out = hisi_acc_sg_buf_map_to_hw_sgl(dev, dst,
 							     qp_ctx->c_out_pool,
@@ -978,7 +978,7 @@ static int sec_cipher_map(struct sec_ctx *ctx, struct sec_req *req,
 
 		if (IS_ERR(c_req->c_out)) {
 			dev_err(dev, "fail to dma map output sgl buffers!\n");
-			hisi_acc_sg_buf_unmap(dev, src, c_req->c_in);
+			hisi_acc_sg_buf_unmap(dev, src, req->in);
 			return PTR_ERR(c_req->c_out);
 		}
 	}
@@ -996,7 +996,7 @@ static void sec_cipher_unmap(struct sec_ctx *ctx, struct sec_req *req,
 		sec_cipher_pbuf_unmap(ctx, req, dst);
 	} else {
 		if (dst != src)
-			hisi_acc_sg_buf_unmap(dev, src, c_req->c_in);
+			hisi_acc_sg_buf_unmap(dev, src, req->in);
 
 		hisi_acc_sg_buf_unmap(dev, dst, c_req->c_out);
 	}
@@ -1236,7 +1236,7 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 
 	sec_sqe->type2.c_key_addr = cpu_to_le64(c_ctx->c_key_dma);
 	sec_sqe->type2.c_ivin_addr = cpu_to_le64(c_req->c_ivin_dma);
-	sec_sqe->type2.data_src_addr = cpu_to_le64(c_req->c_in_dma);
+	sec_sqe->type2.data_src_addr = cpu_to_le64(req->in_dma);
 	sec_sqe->type2.data_dst_addr = cpu_to_le64(c_req->c_out_dma);
 
 	sec_sqe->type2.icvw_kmode |= cpu_to_le16(((u16)c_ctx->c_mode) <<
@@ -1263,7 +1263,7 @@ static int sec_skcipher_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 
 	sec_sqe->sdm_addr_type |= da_type;
 	scene = SEC_COMM_SCENE << SEC_SCENE_OFFSET;
-	if (c_req->c_in_dma != c_req->c_out_dma)
+	if (req->in_dma != c_req->c_out_dma)
 		de = 0x1 << SEC_DE_OFFSET;
 
 	sec_sqe->sds_sa_type = (de | scene | sa_type);
@@ -1286,7 +1286,7 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 
 	sec_sqe3->c_key_addr = cpu_to_le64(c_ctx->c_key_dma);
 	sec_sqe3->no_scene.c_ivin_addr = cpu_to_le64(c_req->c_ivin_dma);
-	sec_sqe3->data_src_addr = cpu_to_le64(c_req->c_in_dma);
+	sec_sqe3->data_src_addr = cpu_to_le64(req->in_dma);
 	sec_sqe3->data_dst_addr = cpu_to_le64(c_req->c_out_dma);
 
 	sec_sqe3->c_mode_alg = ((u8)c_ctx->c_alg << SEC_CALG_OFFSET_V3) |
@@ -1309,7 +1309,7 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 	}
 
 	bd_param |= SEC_COMM_SCENE << SEC_SCENE_OFFSET_V3;
-	if (c_req->c_in_dma != c_req->c_out_dma)
+	if (req->in_dma != c_req->c_out_dma)
 		bd_param |= 0x1 << SEC_DE_OFFSET_V3;
 
 	bd_param |= SEC_BD_TYPE3;
-- 
2.8.1

