Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A478C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 09:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 208ED610CF
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Oct 2021 09:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhJVJPT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Oct 2021 05:15:19 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14846 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbhJVJPL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Oct 2021 05:15:11 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HbJQy3Rbsz90QY;
        Fri, 22 Oct 2021 17:07:54 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 22 Oct 2021 17:12:50 +0800
Received: from huawei.com (10.69.192.56) by dggpeml100012.china.huawei.com
 (7.185.36.121) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Fri, 22 Oct
 2021 17:12:50 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>, <yekai13@huawei.com>,
        <liulongfang@huawei.com>
Subject: [PATCH v3 2/6] crypto: hisilicon/sec - add ahash alg features for Kunpeng920
Date:   Fri, 22 Oct 2021 17:10:51 +0800
Message-ID: <20211022091055.15369-3-yekai13@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211022091055.15369-1-yekai13@huawei.com>
References: <20211022091055.15369-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The length of the first BD and the middle BD is limited by the
hardware. so the pingpong sg be used to assemble packets. Each
time send the pingpong buffer to the hardware when using the
update stream mode. Due to the hardware not be limited for the
final BD. So the diver can combine the last pingpong buffer and
the remain src into a sgl list. then send it to hardware. Also
the driver will output the hash's result in the callback.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 drivers/crypto/hisilicon/sec2/sec.h        |  40 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c | 945 ++++++++++++++++++++-
 drivers/crypto/hisilicon/sec2/sec_crypto.h |   6 +
 3 files changed, 974 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
index 0ddfac937ef0..c9a00ef1dbc6 100644
--- a/drivers/crypto/hisilicon/sec2/sec.h
+++ b/drivers/crypto/hisilicon/sec2/sec.h
@@ -38,6 +38,28 @@ struct sec_aead_req {
 	struct aead_request *aead_req;
 };
 
+struct sec_ahash_req {
+	struct scatterlist *req_sg;
+	u8 sg_cut_len[SEC_MAX_SG_OF_REMAIN];
+	u32 cut_num;
+	u8 op;
+	u8 done;
+	struct ahash_request *ahash_req;
+	/* Means long hash and ping-pong buffer flag */
+	bool is_stream_mode;
+	u32 req_data_len;
+	/* Currently ping-pong data len */
+	u32 pp_data_len;
+	u64 total_data_len;
+	/* Length of data every bd sent to hardware */
+	u32 block_data_len;
+	int sid;
+
+	struct scatterlist *pp_sg;
+	/* Current pingpong hw sg dma address */
+	dma_addr_t pp_dma;
+};
+
 /* SEC request of Crypto */
 struct sec_req {
 	union {
@@ -49,11 +71,13 @@ struct sec_req {
 
 	/**
 	 * Common parameter of the SEC request.
+	 * ahash, hardware sgl used to hold request's source buffers
 	 */
 	struct hisi_acc_hw_sgl *in;
 	dma_addr_t in_dma;
 	struct sec_cipher_req c_req;
 	struct sec_aead_req aead_req;
+	struct sec_ahash_req hash_req;
 	struct list_head backlog_head;
 
 	int err_type;
@@ -91,8 +115,21 @@ struct sec_auth_ctx {
 	u8 a_key_len;
 	u8 mac_len;
 	u8 a_alg;
+	u32 blk_size;
+	u32 align_sz;
+	dma_addr_t metamac_dma;
+	void *metamac;
 	bool fallback;
+
+	/*
+	 * There are two buffers in the above 'metamac' for each stream.
+	 * -1: no meta-mac (no input hash digest), the 0th buffer is out-mac
+	 * 0: the 0th buffer is meta-mac, the 1th buffer is out-mac
+	 * 1: the 1th buffer is meta-mac, the 0th buffer is out-mac
+	 */
+	char metamac_idx[SEC_MAX_STREAMS];
 	struct crypto_shash *hash_tfm;
+	struct shash_desc *desc;
 	struct crypto_aead *fallback_aead_tfm;
 };
 
@@ -127,7 +164,8 @@ struct sec_qp_ctx {
 
 enum sec_alg_type {
 	SEC_SKCIPHER,
-	SEC_AEAD
+	SEC_AEAD,
+	SEC_AHASH
 };
 
 struct pending_sgl {
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
index 66f461f64288..c2010995d4b8 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
@@ -9,8 +9,12 @@
 #include <crypto/hash.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/des.h>
+#include <crypto/internal/hash.h>
+#include <crypto/md5.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
+#include <crypto/sm3.h>
 #include <crypto/skcipher.h>
 #include <crypto/xts.h>
 #include <linux/crypto.h>
@@ -36,8 +40,9 @@
 #define SEC_CKEY_OFFSET		9
 #define SEC_CMODE_OFFSET	12
 #define SEC_AKEY_OFFSET         5
-#define SEC_AEAD_ALG_OFFSET     11
+#define SEC_AUTH_ALG_OFFSET	11
 #define SEC_AUTH_OFFSET		6
+#define SEC_APD_OFFSET		2
 
 #define SEC_DE_OFFSET_V3		9
 #define SEC_SCENE_OFFSET_V3	5
@@ -64,6 +69,8 @@
 #define SEC_MAX_MAC_LEN		64
 #define SEC_MAX_AAD_LEN		65535
 #define SEC_TOTAL_MAC_SZ	(SEC_MAX_MAC_LEN * QM_Q_DEPTH)
+#define SEC_HW_MAX_LEN		0xF00000
+#define INVALID_MATEMAC_INDEX	(-1)
 
 #define SEC_PBUF_SZ			512
 #define SEC_PBUF_IV_OFFSET		SEC_PBUF_SZ
@@ -84,7 +91,14 @@
 #define SEC_SQE_AEAD_FLAG	3
 #define SEC_SQE_DONE		0x1
 #define SEC_ICV_ERR		0x2
+#define SEC_SHA_UPDATE		1
+#define SEC_SHA_FINAL		2
+#define SEC_SHA_FINUP		3
+#define SEC_SHA_DIGEST		4
+#define SEC_MAX_DIGEST_SZ	SHA512_DIGEST_SIZE
+#define WORD_ALIGNMENT_MASK	0x3
 #define MIN_MAC_LEN		4
+#define HMAC_HASH_MAX_LEN	20
 #define MAC_LEN_MASK		0x1U
 #define MAX_INPUT_DATA_LEN	0xFFFE00
 #define BITS_MASK		0xFF
@@ -104,8 +118,12 @@
 #define IV_BYTE_OFFSET		0x8
 
 /* Get an en/de-cipher queue cyclically to balance load over queues of TFM */
-static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
+static inline u32 sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 {
+	if (ctx->alg_type == SEC_AHASH)
+		return (u32)atomic_inc_return(&ctx->enc_qcyclic) %
+				 ctx->sec->ctx_q_num;
+
 	if (req->c_req.encrypt)
 		return (u32)atomic_inc_return(&ctx->enc_qcyclic) %
 				 ctx->hlf_q_num;
@@ -116,7 +134,8 @@ static inline int sec_alloc_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 
 static inline void sec_free_queue_id(struct sec_ctx *ctx, struct sec_req *req)
 {
-	if (req->c_req.encrypt)
+	if (ctx->alg_type == SEC_AHASH ||
+	    (ctx->alg_type != SEC_AHASH && req->c_req.encrypt))
 		atomic_dec(&ctx->enc_qcyclic);
 	else
 		atomic_dec(&ctx->dec_qcyclic);
@@ -498,6 +517,83 @@ static int sec_alloc_pbuf_resource(struct device *dev, struct sec_alg_res *res)
 	return 0;
 }
 
+static int sec_cut_sg_taildata(struct sec_ahash_req *req,
+			       struct scatterlist *sgl, int need_len)
+{
+	u8 *cuts = req->sg_cut_len;
+	int nents = sg_nents(sgl);
+	struct scatterlist *sg;
+	int i;
+
+	if (unlikely(nents > SEC_MAX_SG_OF_REMAIN)) {
+		pr_err("hisi sec2: input scatter list is too long!\n");
+		return -EINVAL;
+	}
+	req->cut_num = 0;
+	for_each_sg(sgl, sg, nents, i) {
+		req->cut_num++;
+
+		if (!need_len) {
+			cuts[i] = 0;
+			break;
+		}
+		if (sg->length < need_len) {
+			cuts[i] = 0;
+			need_len -= sg->length;
+			continue;
+		} else if (sg->length == need_len) {
+			need_len = 0;
+		} else {
+			cuts[i] = sg->length - need_len;
+			sg->length = need_len;
+			need_len = 0;
+		}
+	}
+
+	return 0;
+}
+
+static void sec_restore_sg_tail_data(struct sec_ahash_req *req,
+				     struct scatterlist *sgl)
+{
+	u8 *cuts = req->sg_cut_len;
+	int nents = sg_nents(sgl);
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(sgl, sg, nents, i) {
+		if (req->cut_num == i)
+			break;
+		sg->length += cuts[i];
+	}
+
+	req->cut_num = 0;
+}
+
+static int sec_alloc_metamac_buf(struct device *dev, struct sec_ctx *ctx)
+{
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+
+	/* Alloc two block mac memory for every stream */
+	a_ctx->metamac = dma_alloc_coherent(dev, SEC_MAX_DIGEST_SZ *
+			SEC_MAX_STREAMS * PINGPONG_BUF_NUM,
+			&a_ctx->metamac_dma, GFP_KERNEL);
+
+	if (!a_ctx->metamac)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void sec_free_metamac_buf(struct device *dev, struct sec_ctx *ctx)
+{
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+
+	if (a_ctx->metamac)
+		dma_free_coherent(dev, SEC_MAX_DIGEST_SZ * SEC_MAX_STREAMS *
+			PINGPONG_BUF_NUM, a_ctx->metamac, a_ctx->metamac_dma);
+}
+
 static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 				  struct sec_qp_ctx *qp_ctx)
 {
@@ -505,10 +601,11 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 	struct device *dev = ctx->dev;
 	int ret;
 
-	ret = sec_alloc_civ_resource(dev, res);
-	if (ret)
-		return ret;
-
+	if (ctx->alg_type != SEC_AHASH) {
+		ret = sec_alloc_civ_resource(dev, res);
+		if (ret)
+			return ret;
+	}
 	if (ctx->alg_type == SEC_AEAD) {
 		ret = sec_alloc_aiv_resource(dev, res);
 		if (ret)
@@ -535,7 +632,8 @@ static int sec_alg_resource_alloc(struct sec_ctx *ctx,
 	if (ctx->alg_type == SEC_AEAD)
 		sec_free_aiv_resource(dev, res);
 alloc_aiv_fail:
-	sec_free_civ_resource(dev, res);
+	if (ctx->alg_type != SEC_AHASH)
+		sec_free_civ_resource(dev, res);
 	return ret;
 }
 
@@ -701,21 +799,35 @@ static void sec_cipher_uninit(struct sec_ctx *ctx)
 static int sec_auth_init(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	struct device *dev = ctx->dev;
+	int ret;
 
-	a_ctx->a_key = dma_alloc_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
+	a_ctx->a_key = dma_alloc_coherent(dev, SEC_MAX_KEY_SIZE,
 					  &a_ctx->a_key_dma, GFP_KERNEL);
 	if (!a_ctx->a_key)
 		return -ENOMEM;
 
+	if (ctx->alg_type == SEC_AHASH) {
+		ret = sec_alloc_metamac_buf(dev, ctx);
+		if (ret) {
+			dma_free_coherent(dev, SEC_MAX_KEY_SIZE,
+					  a_ctx->a_key, a_ctx->a_key_dma);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
 static void sec_auth_uninit(struct sec_ctx *ctx)
 {
 	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	struct device *dev = ctx->dev;
 
+	if (ctx->alg_type == SEC_AHASH)
+		sec_free_metamac_buf(dev, ctx);
 	memzero_explicit(a_ctx->a_key, SEC_MAX_KEY_SIZE);
-	dma_free_coherent(ctx->dev, SEC_MAX_KEY_SIZE,
+	dma_free_coherent(dev, SEC_MAX_KEY_SIZE,
 			  a_ctx->a_key, a_ctx->a_key_dma);
 }
 
@@ -1101,6 +1213,110 @@ static void sec_skcipher_sgl_unmap(struct sec_ctx *ctx, struct sec_req *req)
 	sec_cipher_unmap(ctx, req, sq->src, sq->dst);
 }
 
+static int sec_ahash_set_key(struct crypto_ahash *tfm, const u8 *key,
+			     const u32 keylen)
+{
+	struct sec_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	struct crypto_shash *shash_tfm = a_ctx->hash_tfm;
+	int blocksize, ret, digestsize;
+
+	blocksize = crypto_shash_blocksize(shash_tfm);
+	digestsize = crypto_shash_digestsize(shash_tfm);
+	if (keylen > blocksize) {
+		/* Must hash the input key */
+		ret = crypto_shash_tfm_digest(shash_tfm, key, keylen, a_ctx->a_key);
+		if (ret) {
+			pr_err("hisi_sec2: ahash digest key error!\n");
+			return -EINVAL;
+		}
+		a_ctx->a_key_len = digestsize;
+	} else {
+		memcpy(a_ctx->a_key, key, keylen);
+		a_ctx->a_key_len = keylen;
+	}
+
+	return 0;
+}
+
+static void sec_hash_unmap(struct sec_ctx *ctx, struct sec_req *req,
+			   struct scatterlist *req_sg)
+{
+	struct sec_ahash_req *sareq = &req->hash_req;
+
+	/* If use ping-pong buffer, chain sgl not need to split */
+	if (sareq->pp_data_len) {
+		if (req->in)
+			hisi_acc_sg_buf_unmap(ctx->dev, sareq->pp_sg, req->in);
+	} else {
+		/* Just unmap the request sgl */
+		if (req->in)
+			hisi_acc_sg_buf_unmap(ctx->dev, req_sg, req->in);
+	}
+}
+
+static int sec_hash_map(struct sec_ctx *ctx, struct sec_req *req,
+			struct scatterlist *req_sg)
+{
+	struct sec_ahash_req *sareq = &req->hash_req;
+	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	struct device *dev = ctx->dev;
+
+	req->in = NULL;
+
+	/* If pingpong buffer also has data for the request */
+	if (sareq->pp_data_len && sareq->req_data_len) {
+		/* Chain two sglists together */
+		sg_chain(sareq->pp_sg, MERGE_SGL_NUM, req_sg);
+
+		req->in = hisi_acc_sg_buf_map_to_hw_sgl(dev, sareq->pp_sg,
+							qp_ctx->c_out_pool,
+							req->req_id,
+							&sareq->pp_dma);
+		if (IS_ERR(req->in)) {
+			dev_err(dev, "hash failed to map chain buffers!\n");
+			return PTR_ERR(req->in);
+		}
+	} else if (sareq->pp_data_len && !sareq->req_data_len) {
+		/* Only map pingpong sgl buffers */
+		sg_mark_end(sareq->pp_sg);
+		req->in = hisi_acc_sg_buf_map_to_hw_sgl(dev, sareq->pp_sg,
+							qp_ctx->c_out_pool,
+							req->req_id,
+							&sareq->pp_dma);
+		if (IS_ERR(req->in)) {
+			dev_err(dev, "hash failed to map pingpong buffers!\n");
+			return PTR_ERR(req->in);
+		}
+	} else {
+		/* Map user inputing sgl buffers */
+		req->in = hisi_acc_sg_buf_map_to_hw_sgl(dev, req_sg,
+							qp_ctx->c_out_pool,
+							req->req_id,
+							&sareq->pp_dma);
+		if (IS_ERR(req->in)) {
+			dev_err(dev, "hash failed to map input sgl buffers!\n");
+			return PTR_ERR(req->in);
+		}
+	}
+
+	return 0;
+}
+
+static int sec_ahash_sgl_map(struct sec_ctx *ctx, struct sec_req *req)
+{
+	struct ahash_request *ahreq = req->hash_req.ahash_req;
+
+	return sec_hash_map(ctx, req, ahreq->src);
+}
+
+static void sec_ahash_sgl_unmap(struct sec_ctx *ctx, struct sec_req *req)
+{
+	struct ahash_request *ahreq = req->hash_req.ahash_req;
+
+	sec_hash_unmap(ctx, req, ahreq->src);
+}
+
 static int sec_aead_aes_set_key(struct sec_cipher_ctx *c_ctx,
 				struct crypto_authenc_keys *keys)
 {
@@ -1406,6 +1622,117 @@ static int sec_skcipher_bd_fill_v3(struct sec_ctx *ctx, struct sec_req *req)
 	return 0;
 }
 
+static void sec_ahash_stream_bd_fill(struct sec_auth_ctx *actx,
+				     struct sec_req *req, struct sec_sqe *sqe)
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
+		sqe->type2.a_ivin_addr = cpu_to_le64(actx->metamac_dma +
+				(sid + *idx) * SEC_MAX_DIGEST_SZ);
+
+		sqe->type2.mac_addr = cpu_to_le64(actx->metamac_dma +
+		(sid + ((unsigned char)*idx ^ 0x1)) * SEC_MAX_DIGEST_SZ);
+		/* Middle BD */
+		if (sareq->op == SEC_SHA_UPDATE) {
+			sqe->ai_apd_cs = AIGEN_NOGEN;
+			sqe->ai_apd_cs |= AUTHPAD_NOPAD << SEC_APD_OFFSET;
+		}
+	} else {
+		/* No meta-mac */
+		sqe->type2.mac_addr = cpu_to_le64(actx->metamac_dma +
+				sid * SEC_MAX_DIGEST_SZ);
+		/* First BD */
+		if (sareq->op == SEC_SHA_UPDATE) {
+			sqe->ai_apd_cs = AIGEN_GEN;
+			sqe->ai_apd_cs |= AUTHPAD_NOPAD << SEC_APD_OFFSET;
+			sareq->is_stream_mode = true;
+		}
+	}
+
+	/* End BD */
+	if ((sareq->op == SEC_SHA_FINAL || sareq->op == SEC_SHA_FINUP) &&
+	    sareq->is_stream_mode) {
+		sqe->type2.a_ivin_addr = cpu_to_le64(actx->metamac_dma +
+			(sid + *idx) * SEC_MAX_DIGEST_SZ);
+
+		sqe->type2.mac_addr = cpu_to_le64(actx->metamac_dma + (sid +
+		((unsigned char)*idx ^ 0x1)) * SEC_MAX_DIGEST_SZ);
+
+		sqe->ai_apd_cs = AIGEN_NOGEN;
+		sqe->ai_apd_cs |= AUTHPAD_PAD << SEC_APD_OFFSET;
+
+		/* Fill the total hash data length */
+		sqe->type2.long_a_data_len = cpu_to_le64(sareq->total_data_len <<
+							0x3);
+		sareq->is_stream_mode = false;
+	}
+}
+
+static void sec_ahash_data_len_fill(struct sec_ahash_req *sareq,
+				    struct sec_sqe *sec_sqe)
+{
+	if ((sareq->op == SEC_SHA_UPDATE || sareq->op == SEC_SHA_FINAL) &&
+	    sareq->pp_data_len)
+		sec_sqe->type2.alen_ivllen = cpu_to_le32(sareq->block_data_len);
+	else if (!sareq->pp_data_len && sareq->op == SEC_SHA_FINAL)
+		sec_sqe->type2.alen_ivllen = cpu_to_le32(0);
+	else
+		sec_sqe->type2.alen_ivllen = cpu_to_le32(sareq->req_data_len);
+}
+
+static int sec_ahash_bd_fill(struct sec_ctx *ctx, struct sec_req *req)
+{
+	struct sec_auth_ctx *actx = &ctx->a_ctx;
+	struct sec_sqe *sec_sqe = &req->sec_sqe;
+	struct sec_ahash_req *sareq = &req->hash_req;
+	dma_addr_t pp_dma = sareq->pp_dma;
+	u8 scene, sa_type;
+
+	sareq->done = 0;
+	memset(sec_sqe, 0, sizeof(struct sec_sqe));
+	sec_sqe->type_cipher_auth = SEC_BD_TYPE2;
+
+	scene = SEC_IPSEC_SCENE << SEC_SCENE_OFFSET;
+	sa_type = SEC_SGL << SEC_SRC_SGL_OFFSET;
+	/* de:1~2 bits| scene:3~6 bits| sa_type:~7 bit, de = 0 means disable */
+	sec_sqe->sds_sa_type = (scene | sa_type);
+
+	sec_sqe->type2.data_src_addr = cpu_to_le64(pp_dma);
+
+	sec_sqe->type2.a_key_addr = cpu_to_le64(actx->a_key_dma);
+
+	sec_sqe->type2.mac_key_alg = cpu_to_le32(actx->mac_len /
+						 SEC_SQE_LEN_RATE);
+	sec_sqe->type2.mac_key_alg |=
+			cpu_to_le32((u32)((actx->a_key_len) /
+			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET);
+
+	sec_sqe->type2.mac_key_alg |=
+			cpu_to_le32((u32)(actx->a_alg) << SEC_AUTH_ALG_OFFSET);
+
+	sec_sqe->type_cipher_auth |= SEC_AUTH_TYPE1 << SEC_AUTH_OFFSET;
+
+	sec_ahash_data_len_fill(sareq, sec_sqe);
+
+	sec_ahash_stream_bd_fill(actx, req, sec_sqe);
+	sec_sqe->type2.tag = cpu_to_le16((u16)req->req_id);
+
+	return 0;
+}
+
 /* increment counter (128-bit int) */
 static void ctr_iv_inc(__u8 *counter, __u8 bits, __u32 nums)
 {
@@ -1500,6 +1827,71 @@ static void sec_skcipher_callback(struct sec_ctx *ctx, struct sec_req *req,
 	sk_req->base.complete(&sk_req->base, err);
 }
 
+static void sec_ahash_callback(struct sec_ctx *ctx, struct sec_req *req, int err)
+{
+	struct sec_ahash_req *sareq = &req->hash_req;
+	struct ahash_request *areq = sareq->ahash_req;
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	struct sec_qp_ctx *qp_ctx = req->qp_ctx;
+	struct ahash_request *backlog_ahash_req;
+	struct sec_req *backlog_req;
+	int sid = sareq->sid;
+	char *idx = &a_ctx->metamac_idx[sid];
+
+	sec_free_req_id(req);
+
+	/* Restore the original request */
+	sec_restore_sg_tail_data(sareq, areq->src);
+
+	while (1) {
+		backlog_req = sec_back_req_clear(ctx, qp_ctx);
+		if (!backlog_req)
+			break;
+
+		backlog_ahash_req = backlog_req->hash_req.ahash_req;
+		backlog_ahash_req->base.complete(&backlog_ahash_req->base,
+						-EINPROGRESS);
+		atomic64_inc(&ctx->sec->debug.dfx.recv_busy_cnt);
+	}
+
+	/*
+	 * As update, just change the meta mac buffer,
+	 * -1 is invalid metamac index
+	 */
+	if (sareq->op == SEC_SHA_UPDATE) {
+		if (*idx == (char)-1)
+			*idx = 0;
+		else
+			*idx = (unsigned char)*idx ^ 1;
+	} else {
+		/*
+		 * This hash is finished, op == final or finup,
+		 * output digest value
+		 */
+		if (*idx == (char)-1) {
+			memcpy(areq->result, a_ctx->metamac +
+				sid * SEC_MAX_DIGEST_SZ,
+				a_ctx->mac_len);
+		} else {
+			*idx = (unsigned char)*idx ^ 0x1;
+			memcpy(areq->result, a_ctx->metamac +
+				(sid + *idx) * SEC_MAX_DIGEST_SZ,
+				a_ctx->mac_len);
+		}
+		*idx = -1;
+		sareq->total_data_len = 0;
+		/* The hash stream is end */
+		sec_free_stream_id(ctx, sid);
+	}
+
+	sareq->done = SEC_SQE_DONE;
+
+	sareq->req_data_len = 0;
+	sareq->pp_data_len = 0;
+
+	areq->base.complete(&areq->base, err);
+}
+
 static void set_aead_auth_iv(struct sec_ctx *ctx, struct sec_req *req)
 {
 	struct aead_request *aead_req = req->aead_req.aead_req;
@@ -1621,6 +2013,11 @@ static void sec_auth_bd_fill_xcm_v3(struct sec_auth_ctx *ctx, int dir,
 	sqe3->mac_addr = cpu_to_le64(a_req->out_mac_dma);
 }
 
+static void sec_ahash_transfer(struct sec_ctx *ctx, struct sec_req *req)
+{
+	/* No need to do anything */
+}
+
 static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
 			       struct sec_req *req, struct sec_sqe *sec_sqe)
 {
@@ -1638,7 +2035,7 @@ static void sec_auth_bd_fill_ex(struct sec_auth_ctx *ctx, int dir,
 			SEC_SQE_LEN_RATE) << SEC_AKEY_OFFSET);
 
 	sec_sqe->type2.mac_key_alg |=
-			cpu_to_le32((u32)(ctx->a_alg) << SEC_AEAD_ALG_OFFSET);
+			cpu_to_le32((u32)(ctx->a_alg) << SEC_AUTH_ALG_OFFSET);
 
 	if (dir) {
 		sec_sqe->type_cipher_auth |= SEC_AUTH_TYPE1 << SEC_AUTH_OFFSET;
@@ -1816,9 +2213,11 @@ static int sec_process(struct sec_ctx *ctx, struct sec_req *req)
 		goto err_uninit_req;
 
 	/* Output IV as decrypto */
-	if (!req->c_req.encrypt && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
-	    ctx->c_ctx.c_mode == SEC_CMODE_CTR))
-		sec_update_iv(req, ctx->alg_type);
+	if (ctx->alg_type != SEC_AHASH) {
+		if (!req->c_req.encrypt && (ctx->c_ctx.c_mode == SEC_CMODE_CBC ||
+		    ctx->c_ctx.c_mode == SEC_CMODE_CTR))
+			sec_update_iv(req, ctx->alg_type);
+	}
 
 	ret = ctx->req_op->bd_send(ctx, req);
 	if (unlikely((ret != -EBUSY && ret != -EINPROGRESS) ||
@@ -1866,6 +2265,16 @@ static const struct sec_req_op sec_aead_req_ops = {
 	.process	= sec_process,
 };
 
+static const struct sec_req_op sec_ahash_req_ops = {
+	.buf_map	= sec_ahash_sgl_map,
+	.buf_unmap	= sec_ahash_sgl_unmap,
+	.do_transfer	= sec_ahash_transfer,
+	.bd_fill	= sec_ahash_bd_fill,
+	.bd_send	= sec_bd_send,
+	.callback	= sec_ahash_callback,
+	.process	= sec_process,
+};
+
 static const struct sec_req_op sec_skcipher_req_ops_v3 = {
 	.buf_map	= sec_skcipher_sgl_map,
 	.buf_unmap	= sec_skcipher_sgl_unmap,
@@ -2027,6 +2436,457 @@ static void sec_aead_xcm_ctx_exit(struct crypto_aead *tfm)
 	sec_aead_exit(tfm);
 }
 
+static int sec_ahash_req_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ahash_req *areq = &sreq->hash_req;
+	struct sec_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	char *tfm_alg_name;
+	int sid;
+
+	sreq->ctx = ctx;
+
+	tfm_alg_name = tfm->base.__crt_alg->cra_name;
+	a_ctx->mac_len = crypto_ahash_digestsize(tfm);
+	a_ctx->align_sz = SEC_SHA1_ALIGN_SZ;
+
+	switch (a_ctx->mac_len) {
+	case MD5_DIGEST_SIZE:
+		a_ctx->blk_size = MD5_HMAC_BLOCK_SIZE;
+		a_ctx->a_alg = SEC_A_HMAC_MD5;
+		break;
+	case SHA1_DIGEST_SIZE:
+		a_ctx->blk_size = SHA1_BLOCK_SIZE;
+		a_ctx->a_alg = SEC_A_HMAC_SHA1;
+		break;
+	case SHA256_DIGEST_SIZE:
+		a_ctx->blk_size = SHA256_BLOCK_SIZE;
+		if (strcmp(tfm_alg_name, "hmac(sha256)"))
+			a_ctx->a_alg = SEC_A_HMAC_SM3;
+		else
+			a_ctx->a_alg = SEC_A_HMAC_SHA256;
+		break;
+	case SHA512_DIGEST_SIZE:
+		a_ctx->blk_size = SHA512_BLOCK_SIZE;
+		a_ctx->a_alg = SEC_A_HMAC_SHA512;
+		a_ctx->align_sz = SEC_SHA512_ALIGN_SZ;
+		break;
+	default:
+		pr_err("hisi_sec2: mac length error: %u\n", a_ctx->mac_len);
+		return -EINVAL;
+	}
+
+	sid = sec_alloc_stream_id(ctx);
+	if (unlikely(sid < 0))
+		return sid;
+
+	ctx->pingpong_idx[sid] = 0;
+	ctx->pingpong_sg[sid][0].len = 0;
+	areq->req_sg = req->src;
+
+	/*
+	 * Init ping-pong buffer, At the first time, we use the first
+	 * ping sg buffer
+	 */
+	areq->pp_sg = ctx->pingpong_sg[sid][0].sgl;
+	areq->sid = sid;
+	areq->total_data_len = 0;
+	areq->block_data_len = 0;
+	areq->ahash_req = req;
+	areq->is_stream_mode = false;
+	areq->done = 0;
+	areq->op = 0;
+	ctx->a_ctx.metamac_idx[sid] = -1;
+
+	return 0;
+}
+
+static int hash_total_len(struct sec_ahash_req *ahreq)
+{
+	if (unlikely(ahreq->req_data_len + ahreq->pp_data_len >
+		  SEC_HW_MAX_LEN)) {
+		pr_err("Too long input buffer for Hisilicon SEC2!\n");
+		return -EINVAL;
+	}
+
+	if (ahreq->op == SEC_SHA_FINAL)
+		/* there is no data in the final request */
+		ahreq->total_data_len += ahreq->pp_data_len;
+	else
+		ahreq->total_data_len += ahreq->req_data_len +
+					 ahreq->pp_data_len;
+
+	return 0;
+}
+
+static int sec_ahash_process(struct ahash_request *req)
+{
+	struct scatterlist *curr_pp_sg, *next_pp_sg;
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ahash_req *ahreq = &sreq->hash_req;
+	struct scatterlist *req_sg = req->src;
+	struct sec_ctx *ctx = sreq->ctx;
+	u32 align_sz = ctx->a_ctx.align_sz;
+	int nents = sg_nents(req_sg);
+	u32 remain, data_len;
+	int sid = ahreq->sid;
+	u8 current_idx;
+	int ret;
+
+	current_idx = ctx->pingpong_idx[sid];
+	curr_pp_sg = ahreq->pp_sg;
+
+	data_len = ctx->pingpong_sg[sid][current_idx].len;
+
+	/* Check if current data length is aligned */
+	remain = (data_len + req->nbytes) % align_sz;
+
+	if (remain && ahreq->op == SEC_SHA_UPDATE) {
+		u8 idx = current_idx ^ 0x1;
+
+		next_pp_sg = ctx->pingpong_sg[sid][idx].sgl;
+
+		/* If the request's data is enough for cutting the remain size */
+		if (req->nbytes > remain) {
+			/*
+			 * Copy end 'remain' data of the current request into
+			 * next pingpong buffer for the next operation
+			 */
+			sg_pcopy_to_buffer(req_sg, nents, sg_virt(next_pp_sg), remain,
+					   req->nbytes - remain);
+			/*
+			 * Update the pingpong buffer data length of the next
+			 * pingpong buffer
+			 */
+			ctx->pingpong_sg[sid][idx].len = remain;
+			/*
+			 * Save need data from req, cut has been copied to next
+			 * pingpong buffer data
+			 */
+			ret = sec_cut_sg_taildata(ahreq, req_sg, req->nbytes - remain);
+			if (unlikely(ret))
+				return ret;
+
+			ahreq->req_data_len = req->nbytes - remain;
+			ahreq->pp_data_len = data_len;
+			ahreq->block_data_len = data_len + req->nbytes - remain;
+		} else if (req->nbytes == remain) {
+			/*
+			 * Copy all data in current request to next
+			 * pingpong buffer
+			 */
+			sg_pcopy_to_buffer(req_sg, nents, sg_virt(next_pp_sg), remain, 0);
+			ahreq->req_data_len = 0;
+			ahreq->pp_data_len = data_len;
+			ahreq->block_data_len = data_len;
+			/* Update next buff data length */
+			ctx->pingpong_sg[sid][idx].len = remain;
+		} else if (req->nbytes < remain) {
+			u8 buf_minus = remain - req->nbytes;
+			/*
+			 * Copy part data of current pingpong buffer and all
+			 * data of the request to next pingpong buffer.
+			 */
+			memcpy(sg_virt(next_pp_sg), sg_virt(curr_pp_sg) + data_len - buf_minus,
+			       buf_minus);
+			/*
+			 * Current request source scatterlist has no data
+			 * since they are moved into next pp buffer
+			 */
+			ahreq->req_data_len = 0;
+
+			/* Update current data length */
+			ctx->pingpong_sg[sid][current_idx].len -= buf_minus;
+
+			/* Update current request's pp data length */
+			ahreq->pp_data_len = data_len - buf_minus;
+
+			sg_pcopy_to_buffer(req_sg, nents, sg_virt(next_pp_sg) +
+					   buf_minus, req->nbytes, 0);
+			ctx->pingpong_sg[sid][idx].len = req->nbytes + buf_minus;
+			ahreq->block_data_len = data_len - buf_minus;
+		}
+
+		/* Update ping-pong index for the next operation */
+		ctx->pingpong_idx[sid] = idx;
+	} else if (ahreq->op == SEC_SHA_FINAL) {
+		ahreq->req_data_len = 0;
+		ahreq->pp_data_len = data_len;
+		ahreq->block_data_len = data_len;
+	} else {
+		ahreq->req_data_len = req->nbytes;
+		ahreq->pp_data_len = data_len;
+		ahreq->block_data_len = data_len;
+	}
+
+	ret = hash_total_len(ahreq);
+	if (ret)
+		return -EINVAL;
+	/*
+	 * Now, all the input data is ready, there may be two scatterlists,
+	 * and send them with at least one scatterlist into the hardware
+	 */
+	return ctx->req_op->process(ctx, sreq);
+}
+
+static int sec_ahash_update(struct ahash_request *req)
+{
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ahash_req *sareq = &sreq->hash_req;
+	struct scatterlist *pingpong_sg;
+	struct sec_ctx *ctx = sreq->ctx;
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	int sid = sareq->sid;
+	u32 data_len;
+	u8 idx;
+
+	if (unlikely(req->nbytes > SEC_HW_MAX_LEN)) {
+		dev_err_ratelimited(ctx->dev, "too long input for updating!\n");
+		return -EINVAL;
+	}
+
+	/* Just update as no data */
+	if (!req->nbytes)
+		return 0;
+
+	if (unlikely(sid >= SEC_MAX_STREAMS || sid < 0)) {
+		pr_err("hisilicon SEC2 stream id %d error!\n", sid);
+		return -EINVAL;
+	}
+
+	idx = ctx->pingpong_idx[sid];
+
+	pingpong_sg = ctx->pingpong_sg[sid][idx].sgl;
+	data_len = ctx->pingpong_sg[sid][idx].len;
+
+	sareq->op = SEC_SHA_UPDATE;
+	sareq->pp_sg = pingpong_sg;
+
+	/* The pingpong buffer can hold the input of this request */
+	if (data_len + req->nbytes <= SEC_SID_BUF_LEN) {
+		scatterwalk_map_and_copy(sg_virt(pingpong_sg) + data_len,
+					 req->src, 0, req->nbytes, 0);
+		ctx->pingpong_sg[sid][idx].len += req->nbytes;
+
+		return 0;
+	}
+
+	return sec_ahash_process(req);
+}
+
+static int sec_ahash_final(struct ahash_request *req)
+{
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ahash_req *sareq = &sreq->hash_req;
+	struct sec_ctx *ctx = sreq->ctx;
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	u32 sid = sareq->sid;
+	u8 idx;
+
+	sareq->op = SEC_SHA_FINAL;
+	if (sareq->is_stream_mode) {
+		idx = ctx->pingpong_idx[sid];
+		sareq->pp_sg = ctx->pingpong_sg[sid][idx].sgl;
+	}
+
+	return sec_ahash_process(req);
+}
+
+static void stream_hash_wait(struct sec_ahash_req *sareq)
+{
+	while (sareq->is_stream_mode && sareq->done != SEC_SQE_DONE)
+		cpu_relax();
+}
+
+static int sec_ahash_finup(struct ahash_request *req)
+{
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ahash_req *sareq = &sreq->hash_req;
+	struct sec_ctx *ctx = sreq->ctx;
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	int nents = sg_nents(req->src);
+	struct scatterlist *sg;
+	int i = 0;
+	int ret;
+
+	if (sareq->op == SEC_SHA_UPDATE) {
+		if (unlikely(req->nbytes > SEC_HW_MAX_LEN)) {
+			dev_err_ratelimited(ctx->dev, "too long input for update+finup!\n");
+			return -EINVAL;
+		}
+
+		ret = sec_ahash_update(req);
+		/* Update process return -EINPROGRESS not return failed */
+		if (unlikely(ret == -EINVAL)) {
+			pr_err("ahash update+finup mode last update process is error!\n");
+			return ret;
+		}
+
+		stream_hash_wait(sareq);
+
+		return sec_ahash_final(req);
+	}
+
+	return sec_ahash_process(req);
+}
+
+static int sec_ahash_digest(struct ahash_request *req)
+{
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ahash_req *sareq = &sreq->hash_req;
+	int nents = sg_nents(req->src);
+	struct sec_auth_ctx *a_ctx;
+	struct scatterlist *sg;
+	struct sec_ctx *ctx;
+	int ret, i;
+
+	ret = sec_ahash_req_init(req);
+	if (ret)
+		return -EINVAL;
+
+	ctx = sreq->ctx;
+	a_ctx = &ctx->a_ctx;
+
+	sareq->op = SEC_SHA_DIGEST;
+
+	return sec_ahash_finup(req);
+}
+
+static int sec_ahash_export(struct ahash_request *req, void *out)
+{
+	/*
+	 * This function dumps the
+	 * entire state of the ongoing transformation into a provided block of
+	 * data so it can be @import'ed back later on.
+	 */
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_auth_ctx *a_ctx = &sreq->ctx->a_ctx;
+	u8 mac_len = a_ctx->mac_len;
+
+	memcpy(out, &sreq->hash_req, sizeof(struct sec_ahash_req));
+
+	/* Export the partial hash data */
+	memcpy(out + sizeof(struct sec_ahash_req), a_ctx->metamac, mac_len);
+
+	return 0;
+}
+
+static int sec_ahash_import(struct ahash_request *req, const void *in)
+{
+	/*
+	 * Import partial state of the transformation. This function loads the
+	 * entire state of the ongoing transformation from a provided block of
+	 * data so the transformation can continue from this point onward.
+	 */
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sec_req *sreq = ahash_request_ctx(req);
+	struct sec_ctx *ctx = crypto_ahash_ctx(tfm);
+	u8 mac_len = ctx->a_ctx.mac_len;
+
+	sreq->ctx = ctx;
+	memcpy(&sreq->hash_req, in, sizeof(struct sec_ahash_req));
+
+	/* Import the existing hash data */
+	memcpy(ctx->a_ctx.metamac, in + sizeof(struct sec_ahash_req), mac_len);
+
+	return 0;
+}
+
+static void sec_ahash_tfm_uninit(struct crypto_tfm *tfm)
+{
+	struct sec_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	sec_release_fallback_shash(ctx->a_ctx.fallback_ahash_tfm, ctx->a_ctx.desc);
+	crypto_free_shash(ctx->a_ctx.hash_tfm);
+	sec_stream_mode_uninit(ctx);
+	sec_auth_uninit(ctx);
+	sec_ctx_base_uninit(ctx);
+}
+
+static int sec_ahash_tfm_init(struct crypto_tfm *tfm, const char *ahash_name)
+{
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct sec_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sec_auth_ctx *a_ctx = &ctx->a_ctx;
+	char hmac_ahash_name[HMAC_HASH_MAX_LEN];
+	int ret;
+
+	ctx->alg_type = SEC_AHASH;
+	crypto_ahash_set_reqsize(ahash, sizeof(struct sec_req));
+
+	ret = sec_ctx_base_init(ctx);
+	if (ret) {
+		pr_err("hisi_sec2: sec hash ctx base init error!\n");
+		return ret;
+	}
+
+	ret = sec_auth_init(ctx);
+	if (ret)
+		goto err_auth_init;
+
+	ctx->type_supported = SEC_BD_TYPE2;
+	ctx->req_op = &sec_ahash_req_ops;
+
+	/* Support 128 streams/threads per TFM, memory for small packets */
+	ret = sec_stream_mode_init(ctx);
+	if (ret < 0)
+		goto err_mem_init;
+
+	a_ctx->fallback = false;
+	a_ctx->hash_tfm = crypto_alloc_shash(ahash_name, 0, 0);
+	if (IS_ERR(a_ctx->hash_tfm)) {
+		dev_err(ctx->dev, "ahash driver alloc shash error!\n");
+		ret = PTR_ERR(a_ctx->hash_tfm);
+		goto err_alloc_shash;
+	}
+
+	ret = snprintf(hmac_ahash_name, HMAC_HASH_MAX_LEN, "hmac(%s)", ahash_name);
+	if (ret <= 0)
+		goto err_alloc_hmac;
+
+	ret = sec_alloc_fallback_shash(hmac_ahash_name, &a_ctx->fallback_ahash_tfm, &a_ctx->desc);
+	if (ret)
+		goto err_alloc_hmac;
+
+	return 0;
+err_alloc_hmac:
+	crypto_free_shash(ctx->a_ctx.hash_tfm);
+err_alloc_shash:
+	sec_stream_mode_uninit(ctx);
+err_mem_init:
+	sec_auth_uninit(ctx);
+err_auth_init:
+	sec_ctx_base_uninit(ctx);
+	return ret;
+}
+
+static int sec_ahash_md5_init(struct crypto_tfm *tfm)
+{
+	return sec_ahash_tfm_init(tfm, "md5");
+}
+
+static int sec_ahash_sm3_init(struct crypto_tfm *tfm)
+{
+	return sec_ahash_tfm_init(tfm, "sm3");
+}
+
+static int sec_ahash_sha1_init(struct crypto_tfm *tfm)
+{
+	return sec_ahash_tfm_init(tfm, "sha1");
+}
+
+static int sec_ahash_sha256_init(struct crypto_tfm *tfm)
+{
+	return sec_ahash_tfm_init(tfm, "sha256");
+}
+
+static int sec_ahash_sha512_init(struct crypto_tfm *tfm)
+{
+	return sec_ahash_tfm_init(tfm, "sha512");
+}
+
 static int sec_aead_sha1_ctx_init(struct crypto_aead *tfm)
 {
 	return sec_aead_ctx_init(tfm, "sha1");
@@ -2042,7 +2902,6 @@ static int sec_aead_sha512_ctx_init(struct crypto_aead *tfm)
 	return sec_aead_ctx_init(tfm, "sha512");
 }
 
-
 static int sec_skcipher_cryptlen_ckeck(struct sec_ctx *ctx,
 	struct sec_req *sreq)
 {
@@ -2129,7 +2988,7 @@ static int sec_skcipher_soft_crypto(struct sec_ctx *ctx,
 
 	skcipher_request_set_sync_tfm(subreq, c_ctx->fbtfm);
 
-	/* software need sync mode to do crypto */
+	/* Software need sync mode to do crypto */
 	skcipher_request_set_callback(subreq, sreq->base.flags,
 				      NULL, NULL);
 	skcipher_request_set_crypt(subreq, sreq->src, sreq->dst,
@@ -2481,6 +3340,49 @@ static struct aead_alg sec_aeads_v3[] = {
 		     SEC_AIV_SIZE, AES_BLOCK_SIZE)
 };
 
+#define SEC_AHASH_ALG(sec_cra_name, digest_size, blksize, ahash_cra_init) \
+{\
+	.halg = {\
+		.digestsize = digest_size,\
+		.statesize = sizeof(struct sec_ahash_req) + SEC_MAX_MAC_LEN,\
+		.base = {\
+			.cra_name = sec_cra_name,\
+			.cra_driver_name = "hisi_sec_"sec_cra_name,\
+			.cra_priority = 300,\
+			.cra_flags = CRYPTO_ALG_ASYNC |\
+				CRYPTO_ALG_KERN_DRIVER_ONLY |\
+				CRYPTO_ALG_NEED_FALLBACK,\
+			.cra_blocksize = blksize,\
+			.cra_ctxsize = sizeof(struct sec_ctx),\
+			.cra_alignmask = 3,\
+			.cra_init = ahash_cra_init,\
+			.cra_exit = sec_ahash_tfm_uninit,\
+			.cra_module = THIS_MODULE,\
+		},\
+	},\
+	.init = sec_ahash_req_init,\
+	.update = sec_ahash_update,\
+	.final = sec_ahash_final,\
+	.finup = sec_ahash_finup,\
+	.digest = sec_ahash_digest,\
+	.export = sec_ahash_export,\
+	.import = sec_ahash_import,\
+	.setkey = sec_ahash_set_key,\
+}
+
+static struct ahash_alg sec_ahashes[] = {
+	SEC_AHASH_ALG("hmac(md5)", MD5_DIGEST_SIZE,
+		      MD5_HMAC_BLOCK_SIZE, sec_ahash_md5_init),
+	SEC_AHASH_ALG("hmac(sm3)", SM3_DIGEST_SIZE,
+		      SM3_BLOCK_SIZE, sec_ahash_sm3_init),
+	SEC_AHASH_ALG("hmac(sha1)", SHA1_DIGEST_SIZE,
+		      SHA1_BLOCK_SIZE, sec_ahash_sha1_init),
+	SEC_AHASH_ALG("hmac(sha256)", SHA256_DIGEST_SIZE,
+		      SHA256_BLOCK_SIZE, sec_ahash_sha256_init),
+	SEC_AHASH_ALG("hmac(sha512)", SHA512_DIGEST_SIZE,
+		      SHA512_BLOCK_SIZE, sec_ahash_sha512_init),
+};
+
 int sec_register_to_crypto(struct hisi_qm *qm)
 {
 	int ret;
@@ -2506,8 +3408,17 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 		if (ret)
 			goto reg_aead_v3_fail;
 	}
+
+	ret = crypto_register_ahashes(sec_ahashes, ARRAY_SIZE(sec_ahashes));
+	if (ret)
+		goto reg_ahash_fail;
+
 	return ret;
 
+reg_ahash_fail:
+	if (qm->ver > QM_HW_V2)
+		crypto_unregister_aeads(sec_aeads_v3,
+					ARRAY_SIZE(sec_aeads_v3));
 reg_aead_v3_fail:
 	crypto_unregister_aeads(sec_aeads, ARRAY_SIZE(sec_aeads));
 reg_aead_fail:
@@ -2522,6 +3433,8 @@ int sec_register_to_crypto(struct hisi_qm *qm)
 
 void sec_unregister_from_crypto(struct hisi_qm *qm)
 {
+	crypto_unregister_ahashes(sec_ahashes, ARRAY_SIZE(sec_ahashes));
+
 	if (qm->ver > QM_HW_V2)
 		crypto_unregister_aeads(sec_aeads_v3,
 					ARRAY_SIZE(sec_aeads_v3));
diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.h b/drivers/crypto/hisilicon/sec2/sec_crypto.h
index 62add3ebb862..9af9f864e6d0 100644
--- a/drivers/crypto/hisilicon/sec2/sec_crypto.h
+++ b/drivers/crypto/hisilicon/sec2/sec_crypto.h
@@ -8,7 +8,11 @@
 #define SEC_IV_SIZE		24
 #define SEC_MAX_KEY_SIZE	64
 #define SEC_COMM_SCENE		0
+#define SEC_IPSEC_SCENE		1
 #define SEC_MAX_STREAMS		128
+#define SEC_SHA1_ALIGN_SZ	64
+#define SEC_SHA512_ALIGN_SZ	128
+#define SEC_MAX_SG_OF_REMAIN	8
 #define PINGPONG_BUF_NUM	2
 #define SEC_MIN_BLOCK_SZ	1
 #define MERGE_SGL_NUM		2
@@ -22,7 +26,9 @@ enum sec_calg {
 enum sec_hash_alg {
 	SEC_A_HMAC_SHA1   = 0x10,
 	SEC_A_HMAC_SHA256 = 0x11,
+	SEC_A_HMAC_MD5    = 0x12,
 	SEC_A_HMAC_SHA512 = 0x15,
+	SEC_A_HMAC_SM3	  = 0x26,
 };
 
 enum sec_mac_len {
-- 
2.33.0

