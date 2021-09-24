Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470A3C433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A5436105A
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Sep 2021 09:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245038AbhIXJaY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:30:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:20007 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244976AbhIXJaX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Sep 2021 05:30:23 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HG6771nD7zbmh1;
        Fri, 24 Sep 2021 17:24:35 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 17:28:48 +0800
Received: from huawei.com (10.69.192.56) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 24 Sep
 2021 17:28:48 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>
Subject: [PATCH v2 4/6] crypto: hisilicon/sec - ahash adapt to Kunpeng930 SQE
Date:   Fri, 24 Sep 2021 17:27:14 +0800
Message-ID: <20210924092716.12848-5-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924092716.12848-1-yekai13@huawei.com>
References: <20210924092716.12848-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SEC ahash needs to supporting next generation of SEC
accelerator hardware. So add the new BD filling process.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 137 ++++++++++++++++++++-
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   1 +
 2 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index a13df2bb5654..f52862ab0f96 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -55,6 +55,8 @@
 #define SEC_AUTH_ALG_OFFSET_V3	15
 #define SEC_CIPHER_AUTH_V3	0xbf
 #define SEC_AUTH_CIPHER_V3	0x40
+#define SEC_AI_GEN_OFFSET_V3	2
+
 #define SEC_FLAG_OFFSET		7
 #define SEC_FLAG_MASK		0x0780
 #define SEC_TYPE_MASK		0x0F
@@ -1681,6 +1683,69 @@ static void sec_ahash_stream_bd_fill(struct sec_auth_ctx *actx,
 	}
 }
 
+static void sec_ahash_stream_bd_fill_v3(struct sec_auth_ctx *actx,
+					struct sec_req *req,
+					struct sec_sqe3 *sqe3)
+{
+	struct sec_ahash_req *sareq = &req->hash_req;
+	int sid = sareq->sid;
+	char *idx = &actx->metamac_idx[sid];
+
+	 /*
+	  * Mac addr for ahash result
+	  *
+	  * First BD: idx == -1 && sec_ahash_req->op == SEC_OP_UPDATE
+	  * Middle BD: idx != -1 && sec_ahash_req->op == SEC_OP_UPDATE
+	  * End BD: sec_ahash_req->op == SEC_OP_FINAL ||
+	  *              sec_ahash_req->op == SEC_OP_FINUP
+	  * NOT stream BD, idx == -1, && sec_ahash_req->op == SEC_OP_FINAL ||
+	  *              sec_ahash_req->op == SEC_OP_FINUP
+	  */
+	if (*idx != (char)-1) {
+		sqe3->auth_ivin.a_ivin_addr = cpu_to_le64(actx->metamac_dma +
+				(sid + *idx) * SEC_MAX_DIGEST_SZ);
+
+		sqe3->mac_addr = cpu_to_le64(actx->metamac_dma +
+		(sid + ((unsigned char)*idx ^ 0x1)) * SEC_MAX_DIGEST_SZ);
+		/* Middle BD */
+		if (sareq->op == SEC_SHA_UPDATE) {
+			sqe3->auth_mac_key |= cpu_to_le32((u32)AIGEN_NOGEN <<
+							SEC_AI_GEN_OFFSET_V3);
+			sqe3->stream_scene.stream_auth_pad = AUTHPAD_NOPAD;
+		}
+	} else {
+		/* No meta-mac */
+		sqe3->mac_addr = cpu_to_le64(actx->metamac_dma +
+				sid * SEC_MAX_DIGEST_SZ);
+		/* First BD */
+		if (sareq->op == SEC_SHA_UPDATE) {
+			sqe3->auth_mac_key |= cpu_to_le32((u32)AIGEN_GEN <<
+							SEC_AI_GEN_OFFSET_V3);
+			sqe3->stream_scene.stream_auth_pad = AUTHPAD_NOPAD;
+			sareq->is_stream_mode = true;
+		}
+	}
+
+	/* End BD */
+	if ((sareq->op == SEC_SHA_FINAL || sareq->op == SEC_SHA_FINUP) &&
+	    sareq->is_stream_mode) {
+		sqe3->auth_ivin.a_ivin_addr = cpu_to_le64(actx->metamac_dma +
+					(sid + *idx) * SEC_MAX_DIGEST_SZ);
+
+		sqe3->mac_addr = cpu_to_le64(actx->metamac_dma + (sid +
+			((unsigned char)*idx ^ 0x1)) * SEC_MAX_DIGEST_SZ);
+
+		sqe3->auth_mac_key |= cpu_to_le32((u32)AIGEN_NOGEN <<
+							SEC_AI_GEN_OFFSET_V3);
+		sqe3->stream_scene.stream_auth_pad = AUTHPAD_PAD;
+
+		/* Fill the total hash data length */
+		sqe3->stream_scene.long_a_data_len =
+				cpu_to_le64(sareq->total_data_len << 0x3);
+		sareq->is_stream_mode = false;
+	}
+}
+
 static void sec_ahash_data_len_fill(struct sec_ahash_req *sareq,
 				    struct sec_sqe *sec_sqe)
 {
@@ -1693,6 +1758,18 @@ static void sec_ahash_data_len_fill(struct sec_ahash_req *sareq,
 		sec_sqe->type2.alen_ivllen = cpu_to_le32(sareq->req_data_len);
 }
 
+static void sec_ahash_data_len_fill_v3(struct sec_ahash_req *sareq,
+				       struct sec_sqe3 *sec_sqe3)
+{
+	if ((sareq->op == SEC_SHA_UPDATE || sareq->op == SEC_SHA_FINAL) &&
+	    sareq->pp_data_len)
+		sec_sqe3->a_len_key = cpu_to_le32(sareq->block_data_len);
+	else if (!sareq->pp_data_len && sareq->op == SEC_SHA_FINAL)
+		sec_sqe3->a_len_key = cpu_to_le32(0);
+	else
+		sec_sqe3->a_len_key = cpu_to_le32(sareq->req_data_len);
+}
+
 static int sec_ahash_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct sec_auth_ctx *actx = &ctx->a_ctx;
@@ -1733,6 +1810,47 @@ static int sec_ahash_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
 	return 0;
 }
 
+static int sec_ahash_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
+{
+	struct sec_auth_ctx *actx = &ctx->a_ctx;
+	struct sec_sqe3 *sec_sqe3 = &req->sec_sqe3;
+	struct sec_ahash_req *sareq = &req->hash_req;
+	dma_addr_t pp_dma = sareq->pp_dma;
+	u32 bd_param = 0;
+
+	memset(sec_sqe3, 0, sizeof(struct sec_sqe3));
+
+	bd_param |= SEC_SGL << SEC_SRC_SGL_OFFSET_V3;
+	bd_param |= SEC_STREAM_SCENE << SEC_SCENE_OFFSET_V3;
+	bd_param |= SEC_BD_TYPE3;
+	sec_sqe3->bd_param = cpu_to_le32(bd_param);
+
+	sec_sqe3->data_src_addr = cpu_to_le64(pp_dma);
+
+	sec_sqe3->a_key_addr = cpu_to_le64(actx->a_key_dma);
+
+	sec_sqe3->auth_mac_key = cpu_to_le32((u32)SEC_AUTH_TYPE1);
+
+	sec_sqe3->auth_mac_key |=
+			cpu_to_le32((u32)(actx->mac_len /
+			SEC_SQE_LEN_RATE) << SEC_MAC_OFFSET_V3);
+
+	sec_sqe3->auth_mac_key |=
+			cpu_to_le32((u32)((actx->a_key_len) /
+			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET_V3);
+
+	sec_sqe3->auth_mac_key |=
+			cpu_to_le32((u32)(actx->a_alg) << SEC_AUTH_ALG_OFFSET_V3);
+
+	sec_ahash_data_len_fill_v3(sareq, sec_sqe3);
+
+	sec_ahash_stream_bd_fill_v3(actx, req, sec_sqe3);
+
+	sec_sqe3->tag = cpu_to_le64((unsigned long)(uintptr_t)req);
+
+	return 0;
+}
+
 /* increment counter (128-bit int) */
 static void ctr_iv_inc(__u8 *counter, __u8 bits, __u32 nums)
 {
@@ -2295,6 +2413,16 @@ static const struct sec_req_op sec_aead_req_ops_v3 = {
 	.process	= sec_process,
 };
 
+static const struct sec_req_op sec_ahash_req_ops_v3 = {
+	.buf_map	= sec_ahash_sgl_map,
+	.buf_unmap	= sec_ahash_sgl_unmap,
+	.do_transfer	= sec_ahash_transfer,
+	.bd_fill	= sec_ahash_bd_fill_v3,
+	.bd_send	= sec_bd_send,
+	.callback	= sec_ahash_callback,
+	.process	= sec_process,
+};
+
 static int sec_skcipher_ctx_init(struct crypto_skcipher *tfm)
 {
 	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
@@ -2882,8 +3010,13 @@ static int sec_ahash_tfm_init(struct crypto_tfm *tfm, const char *ahash_name)
 	if (ret)
 		goto err_auth_init;
 
-	ctx->type_supported = SEC_BD_TYPE2;
-	ctx->req_op = &sec_ahash_req_ops;
+	if (ctx->sec->qm.ver < QM_HW_V3) {
+		ctx->type_supported = SEC_BD_TYPE2;
+		ctx->req_op = &sec_ahash_req_ops;
+	} else {
+		ctx->type_supported = SEC_BD_TYPE3;
+		ctx->req_op = &sec_ahash_req_ops_v3;
+	}
 
 	/* Support 128 streams/threads per TFM, memory for small packets */
 	ret = sec_stream_mode_init(ctx);
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 2157b9868e1b..9f117b5967df 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -9,6 +9,7 @@
 #define SEC_MAX_KEY_SIZE	64
 #define SEC_COMM_SCENE		0
 #define SEC_IPSEC_SCENE		1
+#define SEC_STREAM_SCENE	0x7
 #define SEC_MAX_STREAMS		128
 #define SEC_SHA1_ALIGN_SZ	64
 #define SEC_SHA512_ALIGN_SZ	128
-- 
2.33.0

