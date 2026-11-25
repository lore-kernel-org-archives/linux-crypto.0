Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592807;
	b=5JUoTASXfWUueO4F4Gn5Yx+6xhjiqep4DSRfUc4T4mlhdf+2wAdBFhXZVZ+DO8p88rsz
	 k0eUqSielldEvg8se5/zOaaIBp1kaLwuTeFExjHuC2CBSn9Y+d66V/BlaEnNaGnp3RZEn
	 TdTBG1D7uGD+IzyvOPHlqRdelXsl58sz/awIa2yP1muaOCdyXA1ob4YyWhYcn49LU6CNz
	 J76ZS7hgL5lKi3pQZQXtYhnplbDU1gQf5eg61zvWdSPrY4o6nhawM4EV3QNvJHEqZAZet
	 Duggt1ow9hmkaieCMw6uCwE+Mg3WW9pHgN/WpBEUvTK/WM7cf6do+gGQRu93Bv4TFMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592807;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=P0/sHMKx1nM3+tAGlYcaVNuwzg4ex84aUQC3ab8XZCs=;
	b=aJnvFsLgoKBLVxxmvq8DWtDiIXhkcEQuSnZ1bZK2FFrk/M4iXz90BhEk9nUbUM9PHFNV
	 f5BY/S6lVahBMwx70Iyqw8ePFZpB8iwpiCHs2cYUPovE7wlrE274BeSTf6e+shqywo9hN
	 HAHPTYVGrtZuCAYpgG0mfhzuJfUsd1bVtTtqTA1PKvz1aYhdt6uNheqzRJ0/FU+IJuc8X
	 Ds6fhW24T66h3Bg57ts0u8VBfEmnC+FE4bq3zlU2cfpxzv/idzKogW9URutPGqUgjrTPy
	 SuEM2Yz94cn2h3ViwpgP03+9GwsyTYa4HFi8mot/1XhVu8d5T1TxlTNW34sQBA4ZiUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D92060A5BC1;
	Wed, 25 Nov 2026 07:46:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D92060A5BC1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZr6FSZzVcBF;
	Wed, 25 Nov 2026 15:46:44 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZp2hq2zVcBB;
	Wed, 25 Nov 2026 15:46:42 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id BCC0A157D;
	Wed, 25 Nov 2026 15:46:35 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:42 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 11/11] crypto: ccp - add SM3 engine and ahash algorithms
Date: Wed, 25 Nov 2026 15:46:09 +0800
Message-ID: <7cc3e8096373670b553d0e469b245b444d295ff7.1795588986.git.yangdepei@hygon.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cncheex05.Hygon.cn (172.23.18.115) To cncheex04.Hygon.cn
 (172.23.18.114)

Add the SM3 command builder, the ccp-ops request handling and the ahash
front end, including hmac(sm3).  sm3 and hmac(sm3) are registered when a
device advertises the SM3 engine.

CRYPTO_DEV_SP_CCP selects CRYPTO_SM3 so that the shash used to hash HMAC
keys longer than the block size is always available, as it does for
CRYPTO_SHA1 and CRYPTO_SHA256.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/Kconfig           |   1 +
 drivers/crypto/ccp/Makefile          |   3 +-
 drivers/crypto/ccp/ccp-crypto-main.c |   6 +
 drivers/crypto/ccp/ccp-crypto-sm3.c  | 468 +++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |   1 -
 drivers/crypto/ccp/ccp-dev-v5.c      |  37 +++
 drivers/crypto/ccp/ccp-dev.h         |   1 +
 drivers/crypto/ccp/ccp-ops.c         | 191 +++++++++++
 8 files changed, 706 insertions(+), 2 deletions(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-sm3.c

diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index f16a0f611317..a226720201fe 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -15,6 +15,7 @@ config CRYPTO_DEV_SP_CCP
 	select DMA_ENGINE
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
+	select CRYPTO_SM3
 	help
 	  Provides the support for AMD Cryptographic Coprocessor (CCP) device
 	  which can be used to offload encryption operations such as SHA, AES
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index dd0177961465..db7630b476e2 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -29,4 +29,5 @@ ccp-crypto-objs := ccp-crypto-main.o \
 		   ccp-crypto-des3.o \
 		   ccp-crypto-rsa.o \
 		   ccp-crypto-sha.o \
-		   ccp-crypto-sm4.o
+		   ccp-crypto-sm4.o \
+		   ccp-crypto-sm3.o
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index e68c843ce3fb..284a78234854 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -367,6 +367,12 @@ static int ccp_register_algs(void)
 			return ret;
 	}
 
+	if (!sm_disable && ccp_has_cap(CCP_CAPS_SM3)) {
+		ret = ccp_register_sm3_algs(&hash_algs);
+		if (ret)
+			return ret;
+	}
+
 	if (!sm_disable && ccp_has_cap(CCP_CAPS_SM4)) {
 		ret = ccp_register_sm4_algs(&skcipher_algs);
 		if (ret)
diff --git a/drivers/crypto/ccp/ccp-crypto-sm3.c b/drivers/crypto/ccp/ccp-crypto-sm3.c
new file mode 100644
index 000000000000..10a26a03a524
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-crypto-sm3.c
@@ -0,0 +1,468 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * CCP SM3 crypto API support
+ *
+ * Copyright (C) 2022 Hygon Info Technologies Ltd.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/hash.h>
+#include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/hmac.h>
+
+#include "ccp-crypto.h"
+
+static int ccp_sm3_complete(struct crypto_async_request *async_req, int ret)
+{
+	struct ahash_request *req = ahash_request_cast(async_req);
+	struct ccp_sm3_req_ctx *rctx = ahash_request_ctx_dma(req);
+
+	if (ret)
+		goto e_free;
+
+	rctx->msg_bits += (rctx->hash_cnt << 3);
+	if (rctx->hash_rem) {
+		/* save remaining data to buffer */
+		unsigned int offset = rctx->nbytes - rctx->hash_rem;
+
+		scatterwalk_map_and_copy(rctx->buf, rctx->src, offset,
+					 rctx->hash_rem, 0);
+		rctx->buf_count = rctx->hash_rem;
+	} else {
+		rctx->buf_count = 0;
+	}
+
+	if (rctx->final) {
+		if (req->result)
+			memcpy(req->result, rctx->ctx, SM3_DIGEST_SIZE);
+
+		memset(rctx->ctx, 0, SM3_DIGEST_SIZE);
+	}
+
+e_free:
+	sg_free_table(&rctx->data_sg);
+
+	return ret;
+}
+
+static int ccp_do_sm3_update(struct ahash_request *req, unsigned int nbytes,
+			     unsigned int final)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_ahash_ctx_dma(tfm);
+	struct ccp_sm3_req_ctx *rctx = ahash_request_ctx_dma(req);
+	struct scatterlist *sg = req->src;
+	struct ccp_sm3_engine *sm3;
+	unsigned int sg_count;
+	gfp_t gfp;
+	u64 len, msg_bits = 0;
+	int nents;
+	int ret;
+
+	if (nbytes) {
+		nents = sg_nents_for_len(req->src, nbytes);
+		if (nents < 0)
+			return -EINVAL;
+	}
+
+	len = (u64)rctx->buf_count + nbytes;
+	if (len <= SM3_BLOCK_SIZE) {
+		scatterwalk_map_and_copy(rctx->buf + rctx->buf_count,
+					 req->src, 0, nbytes, 0);
+		rctx->buf_count += nbytes;
+		if (!final)
+			return 0;
+
+		sg_init_one(&rctx->buf_sg, rctx->buf, rctx->buf_count);
+		sg = &rctx->buf_sg;
+	} else {
+		gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+			GFP_KERNEL : GFP_ATOMIC;
+
+		if (rctx->buf_count) {
+			/* build the scatterlist: buffered data + new data */
+			sg_count = sg_nents(req->src) + 1;
+			ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
+			if (ret)
+				return ret;
+
+			sg_init_one(&rctx->buf_sg, rctx->buf,
+				    rctx->buf_count);
+			sg = ccp_crypto_sg_table_add(&rctx->data_sg,
+						     &rctx->buf_sg);
+			if (!sg) {
+				ret = -EINVAL;
+				goto e_free;
+			}
+			sg = ccp_crypto_sg_table_add(&rctx->data_sg,
+						     req->src);
+			if (!sg) {
+				ret = -EINVAL;
+				goto e_free;
+			}
+			sg_mark_end(sg);
+
+			sg = rctx->data_sg.sgl;
+		} else {
+			sg = req->src;
+		}
+	}
+
+	rctx->final = final;
+	if (final) {
+		rctx->hash_rem = 0;
+		rctx->hash_cnt = len;
+		msg_bits = rctx->msg_bits + (len << 3);
+	} else {
+		rctx->hash_rem = len & (SM3_BLOCK_SIZE - 1);
+		rctx->hash_cnt = len - rctx->hash_rem;
+		rctx->src = req->src;
+		rctx->nbytes = nbytes;
+	}
+
+	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
+	INIT_LIST_HEAD(&rctx->cmd.entry);
+	rctx->cmd.engine = CCP_ENGINE_SM3;
+
+	sm3 = &rctx->cmd.u.sm3;
+	sm3->type = CCP_SM3_TYPE_256;
+	sm3->ctx = &rctx->ctx_sg;
+	sm3->ctx_len = SM3_DIGEST_SIZE;
+	sm3->src = sg;
+	sm3->src_len = rctx->hash_cnt;
+	sm3->first = rctx->msg_bits ? 0 : 1;
+	sm3->final = final;
+	sm3->msg_bits = msg_bits;
+	if (final && ctx->u.sm3.hmac_tfm) {
+		sm3->opad = &ctx->u.sm3.opad_sg;
+		sm3->opad_len = SM3_BLOCK_SIZE;
+	}
+
+	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
+	if (ret && ret != -EINPROGRESS && ret != -EBUSY)
+		goto e_free;
+
+	return ret;
+
+e_free:
+	sg_free_table(&rctx->data_sg);
+
+	return ret;
+}
+
+static int ccp_sm3_init(struct ahash_request *req)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_ahash_ctx_dma(tfm);
+	struct ccp_sm3_req_ctx *rctx = ahash_request_ctx_dma(req);
+
+	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
+		return -ENOKEY;
+
+	memset(rctx, 0, sizeof(*rctx));
+	if (ctx->u.sm3.hmac_tfm) {
+		/* buffer the HMAC ipad for the first update */
+		memcpy(rctx->buf, ctx->u.sm3.ipad, SM3_BLOCK_SIZE);
+		rctx->buf_count = SM3_BLOCK_SIZE;
+	}
+
+	sg_init_one(&rctx->ctx_sg, rctx->ctx, SM3_DIGEST_SIZE);
+
+	return 0;
+}
+
+static int ccp_sm3_update(struct ahash_request *req)
+{
+	return ccp_do_sm3_update(req, req->nbytes, 0);
+}
+
+static int ccp_sm3_final(struct ahash_request *req)
+{
+	return ccp_do_sm3_update(req, 0, 1);
+}
+
+static int ccp_sm3_finup(struct ahash_request *req)
+{
+	return ccp_do_sm3_update(req, req->nbytes, 1);
+}
+
+static int ccp_sm3_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = ccp_sm3_init(req);
+	if (unlikely(ret))
+		return ret;
+
+	return ccp_sm3_finup(req);
+}
+
+static int ccp_sm3_export(struct ahash_request *req, void *out)
+{
+	struct ccp_sm3_req_ctx *rctx = ahash_request_ctx_dma(req);
+	struct ccp_sm3_exp_ctx state;
+
+	if (!out)
+		return -EINVAL;
+
+	/* don't let anything leak to 'out' */
+	memset(&state, 0, sizeof(state));
+
+	state.msg_bits = rctx->msg_bits;
+	memcpy(state.ctx, rctx->ctx, SM3_DIGEST_SIZE);
+	state.buf_count = rctx->buf_count;
+	memcpy(state.buf, rctx->buf, rctx->buf_count);
+
+	/* 'out' may not be aligned so memcpy from a local variable */
+	memcpy(out, &state, sizeof(state));
+	memset(&state, 0, sizeof(state));
+
+	return 0;
+}
+
+static int ccp_sm3_import(struct ahash_request *req, const void *in)
+{
+	struct ccp_sm3_req_ctx *rctx = ahash_request_ctx_dma(req);
+	struct ccp_sm3_exp_ctx state;
+
+	if (!in)
+		return -EINVAL;
+
+	/* 'in' may not be aligned so memcpy to a local variable */
+	memcpy(&state, in, sizeof(state));
+
+	if (state.buf_count > SM3_BLOCK_SIZE)
+		return -EINVAL;
+
+	memset(rctx, 0, sizeof(*rctx));
+	rctx->msg_bits = state.msg_bits;
+	memcpy(rctx->ctx, state.ctx, SM3_DIGEST_SIZE);
+	sg_init_one(&rctx->ctx_sg, rctx->ctx, SM3_DIGEST_SIZE);
+	rctx->buf_count = state.buf_count;
+	memcpy(rctx->buf, state.buf, SM3_BLOCK_SIZE);
+
+	memset(&state, 0, sizeof(state));
+
+	return 0;
+}
+
+static int ccp_sm3_setkey(struct crypto_ahash *tfm, const u8 *key,
+			  unsigned int key_len)
+{
+	struct ccp_ctx *ctx = crypto_ahash_ctx_dma(tfm);
+	struct crypto_shash *shash = ctx->u.sm3.hmac_tfm;
+	SHASH_DESC_ON_STACK(sdesc, shash);
+	int i, ret;
+
+	if (!key)
+		return -EINVAL;
+
+	/*
+	 * clear the key area to provide zero padding for keys smaller
+	 * than the block size
+	 */
+	memset(ctx->u.sm3.key, 0, SM3_BLOCK_SIZE);
+
+	if (key_len > SM3_BLOCK_SIZE) {
+		/* must hash the input key */
+		sdesc->tfm = shash;
+		ret = crypto_shash_digest(sdesc, key, key_len,
+					  ctx->u.sm3.key);
+		if (ret) {
+			crypto_ahash_set_flags(tfm, CRYPTO_TFM_NEED_KEY);
+			return -EINVAL;
+		}
+
+		key_len = SM3_DIGEST_SIZE;
+	} else {
+		memcpy(ctx->u.sm3.key, key, key_len);
+	}
+
+	for (i = 0; i < SM3_BLOCK_SIZE; i++) {
+		ctx->u.sm3.ipad[i] = ctx->u.sm3.key[i] ^ HMAC_IPAD_VALUE;
+		ctx->u.sm3.opad[i] = ctx->u.sm3.key[i] ^ HMAC_OPAD_VALUE;
+	}
+
+	sg_init_one(&ctx->u.sm3.opad_sg, ctx->u.sm3.opad, SM3_BLOCK_SIZE);
+
+	return 0;
+}
+
+static int ccp_sm3_cra_init(struct crypto_tfm *tfm)
+{
+	struct crypto_ahash *ahash = __crypto_ahash_cast(tfm);
+	struct ccp_ctx *ctx = crypto_ahash_ctx_dma(ahash);
+
+	ctx->complete = ccp_sm3_complete;
+	crypto_ahash_set_reqsize_dma(ahash, sizeof(struct ccp_sm3_req_ctx));
+
+	return 0;
+}
+
+static void ccp_sm3_cra_exit(struct crypto_tfm *tfm)
+{
+}
+
+static int ccp_hmac_sm3_cra_init(struct crypto_tfm *tfm)
+{
+	struct ccp_ctx *ctx = crypto_tfm_ctx_dma(tfm);
+	struct ccp_crypto_ahash_alg *alg = ccp_crypto_ahash_alg(tfm);
+	struct crypto_shash *hmac_tfm;
+
+	hmac_tfm = crypto_alloc_shash(alg->child_alg, 0, 0);
+	if (IS_ERR(hmac_tfm)) {
+		pr_warn("could not load driver %s needed for HMAC support\n",
+			alg->child_alg);
+		return PTR_ERR(hmac_tfm);
+	}
+
+	ctx->u.sm3.hmac_tfm = hmac_tfm;
+
+	return ccp_sm3_cra_init(tfm);
+}
+
+static void ccp_hmac_sm3_cra_exit(struct crypto_tfm *tfm)
+{
+	struct ccp_ctx *ctx = crypto_tfm_ctx_dma(tfm);
+
+	if (ctx->u.sm3.hmac_tfm)
+		crypto_free_shash(ctx->u.sm3.hmac_tfm);
+
+	ccp_sm3_cra_exit(tfm);
+}
+
+struct ccp_sm3_def {
+	const char *name;
+	const char *drv_name;
+	enum ccp_sm3_type type;
+	u32 digest_size;
+	u32 block_size;
+};
+
+static const struct ccp_sm3_def sm3_algs[] = {
+	{
+		.name		= "sm3",
+		.drv_name	= "sm3-ccp",
+		.type		= CCP_SM3_TYPE_256,
+		.digest_size	= SM3_DIGEST_SIZE,
+		.block_size	= SM3_BLOCK_SIZE,
+	},
+};
+
+static int ccp_register_hmac_sm3_alg(struct list_head *head,
+				     const struct ccp_sm3_def *def,
+				     const struct ccp_crypto_ahash_alg *base_alg)
+{
+	struct ccp_crypto_ahash_alg *ccp_alg;
+	struct ahash_alg *alg;
+	struct crypto_alg *base;
+	int ret;
+
+	ccp_alg = kzalloc_obj(*ccp_alg);
+	if (!ccp_alg)
+		return -ENOMEM;
+
+	/* copy the base algorithm and only change what's necessary */
+	*ccp_alg = *base_alg;
+	INIT_LIST_HEAD(&ccp_alg->entry);
+
+	strscpy(ccp_alg->child_alg, def->name);
+
+	alg = &ccp_alg->alg;
+	alg->setkey = ccp_sm3_setkey;
+
+	base = &alg->halg.base;
+	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)", def->name);
+	snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME, "hmac-%s",
+		 def->drv_name);
+	base->cra_init = ccp_hmac_sm3_cra_init;
+	base->cra_exit = ccp_hmac_sm3_cra_exit;
+
+	ret = crypto_register_ahash(alg);
+	if (ret) {
+		pr_err("%s ahash algorithm registration error (%d)\n",
+		       base->cra_name, ret);
+		kfree(ccp_alg);
+		return ret;
+	}
+
+	list_add(&ccp_alg->entry, head);
+
+	return 0;
+}
+
+static int ccp_register_sm3_alg(struct list_head *head,
+				const struct ccp_sm3_def *def)
+{
+	struct ccp_crypto_ahash_alg *ccp_alg;
+	struct ahash_alg *alg;
+	struct hash_alg_common *halg;
+	struct crypto_alg *base;
+	int ret;
+
+	ccp_alg = kzalloc_obj(*ccp_alg);
+	if (!ccp_alg)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&ccp_alg->entry);
+
+	ccp_alg->type = def->type;
+
+	alg = &ccp_alg->alg;
+	alg->init = ccp_sm3_init;
+	alg->update = ccp_sm3_update;
+	alg->final = ccp_sm3_final;
+	alg->finup = ccp_sm3_finup;
+	alg->digest = ccp_sm3_digest;
+	alg->export = ccp_sm3_export;
+	alg->import = ccp_sm3_import;
+
+	halg = &alg->halg;
+	halg->digestsize = def->digest_size;
+	halg->statesize = sizeof(struct ccp_sm3_exp_ctx);
+
+	base = &halg->base;
+	strscpy(base->cra_name, def->name);
+	strscpy(base->cra_driver_name, def->drv_name);
+	base->cra_flags = CRYPTO_ALG_ASYNC |
+			  CRYPTO_ALG_ALLOCATES_MEMORY |
+			  CRYPTO_ALG_KERN_DRIVER_ONLY |
+			  CRYPTO_ALG_NEED_FALLBACK;
+	base->cra_blocksize = def->block_size;
+	base->cra_ctxsize = sizeof(struct ccp_ctx) + crypto_dma_padding();
+	base->cra_priority = CCP_CRA_PRIORITY;
+	base->cra_init = ccp_sm3_cra_init;
+	base->cra_exit = ccp_sm3_cra_exit;
+	base->cra_module = THIS_MODULE;
+
+	ret = crypto_register_ahash(alg);
+	if (ret) {
+		pr_err("%s ahash algorithm registration error (%d)\n",
+		       base->cra_name, ret);
+		kfree(ccp_alg);
+		return ret;
+	}
+
+	list_add(&ccp_alg->entry, head);
+
+	return ccp_register_hmac_sm3_alg(head, def, ccp_alg);
+}
+
+int ccp_register_sm3_algs(struct list_head *head)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(sm3_algs); i++) {
+		ret = ccp_register_sm3_alg(head, &sm3_algs[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index 9d6f2983f39f..e5036cd5169d 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -262,7 +262,6 @@ struct ccp_rsa_req_ctx {
 
 /***** SM3 related defines *****/
 struct ccp_sm3_ctx {
-	u32 key_len;
 	u8 key[SM3_BLOCK_SIZE];
 
 	u8 ipad[SM3_BLOCK_SIZE];
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 8cbbb8d81d17..e8204f6afdd4 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -632,6 +632,42 @@ static int ccp5_perform_ecc(struct ccp_op *op)
 	return ccp5_do_cmd(&desc, op->cmd_q);
 }
 
+static int ccp5_perform_sm3(struct ccp_op *op)
+{
+	struct ccp5_desc desc;
+	union ccp_function function;
+
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = CCP_ENGINE_SM3;
+
+	CCP5_CMD_SOC(&desc) = op->soc;
+	CCP5_CMD_IOC(&desc) = op->ioc;
+	CCP5_CMD_INIT(&desc) = op->init;
+	CCP5_CMD_EOM(&desc) = op->eom;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	function.raw = 0;
+	CCP_SM3_TYPE(&function) = op->u.sm3.type;
+	CCP5_CMD_FUNCTION(&desc) = function.raw;
+
+	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
+
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
+
+	if (op->eom) {
+		CCP5_CMD_SM3_LO(&desc) = lower_32_bits(op->u.sm3.msg_bits);
+		CCP5_CMD_SM3_HI(&desc) = upper_32_bits(op->u.sm3.msg_bits);
+	}
+
+	ccp5_submit_cmd(&desc, op->cmd_q);
+
+	return 0;
+}
+
 static int ccp5_perform_sm4_common(struct ccp_op *op, enum ccp_engine engine,
 				   u32 function)
 {
@@ -1222,6 +1258,7 @@ static const struct ccp_actions ccp5_actions = {
 	.passthru = ccp5_perform_passthru,
 	.ecc = ccp5_perform_ecc,
 	.run = ccp5_run_cmd,
+	.sm3 = ccp5_perform_sm3,
 	.sm4 = ccp5_perform_sm4,
 	.sm4_ctr = ccp5_perform_sm4_ctr,
 	.sballoc = ccp_lsb_alloc,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 544c7079882f..2141bffb745f 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -683,6 +683,7 @@ struct ccp_actions {
 	int (*passthru)(struct ccp_op *);
 	int (*ecc)(struct ccp_op *);
 	int (*run)(struct ccp_op *op);
+	int (*sm3)(struct ccp_op *op);
 	int (*sm4)(struct ccp_op *op);
 	int (*sm4_ctr)(struct ccp_op *op);
 	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 7c8464b1db6b..cc8c44574bdb 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -10,6 +10,7 @@
 
 #include <crypto/des.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/sm3.h>
 #include <crypto/sm4.h>
 #include <crypto/utils.h>
 #include <linux/ccp.h>
@@ -2489,6 +2490,188 @@ static bool ccp_sm_queue_full(struct ccp_cmd_queue *cmd_q)
 	return perform->get_free_slots(cmd_q) <= 1;
 }
 
+static int ccp_run_sm3_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_sm3_engine *sm3 = &cmd->u.sm3;
+	struct ccp_dm_workarea ctx;
+	struct ccp_data src;
+	struct ccp_op op;
+	u8 sm3_zero_message_hash[SM3_DIGEST_SIZE] = {
+		0x1A, 0xB2, 0x1D, 0x83, 0x55, 0xCF, 0xA1, 0x7F,
+		0x8e, 0x61, 0x19, 0x48, 0x31, 0xE8, 0x1A, 0x8F,
+		0x22, 0xBE, 0xC8, 0xC7, 0x28, 0xFE, 0xFB, 0x74,
+		0x7E, 0xD0, 0x35, 0xEB, 0x50, 0x82, 0xAA, 0x2B,
+	};
+	int ret;
+
+	if (!sm3->ctx || sm3->ctx_len != SM3_DIGEST_SIZE)
+		return -EINVAL;
+
+	if (sm3->src_len && !sm3->src)
+		return -EINVAL;
+
+	if (!sm3->final && (sm3->src_len & (SM3_BLOCK_SIZE - 1)))
+		return -EINVAL;
+
+	if (sm3->opad &&
+	    (sm3->opad_len != SM3_BLOCK_SIZE ||
+	     sg_nents_for_len(sm3->opad, SM3_BLOCK_SIZE) < 0))
+		return -EINVAL;
+
+	if (sg_nents_for_len(sm3->ctx, SM3_DIGEST_SIZE) < 0)
+		return -EINVAL;
+
+	if (sm3->final && sm3->first && !sm3->src_len) {
+		scatterwalk_map_and_copy(sm3_zero_message_hash, sm3->ctx,
+					 0, SM3_DIGEST_SIZE, 1);
+		return 0;
+	}
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.ioc = 1;
+	op.sb_ctx = cmd_q->sb_ctx;
+	op.init = sm3->first & 0x1;
+	op.u.sm3.type = sm3->type;
+	op.u.sm3.msg_bits = sm3->msg_bits;
+
+	memset(&ctx, 0, sizeof(ctx));
+	ret = ccp_init_dm_workarea(&ctx, cmd_q, SM3_DIGEST_SIZE,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		return ret;
+
+	if (!sm3->first) {
+		/* load the previous hash value */
+		ccp_set_dm_area(&ctx, 0, sm3->ctx, 0, SM3_DIGEST_SIZE);
+
+		ret = ccp_copy_to_sb(cmd_q, &ctx, 0, op.sb_ctx,
+				     CCP_PASSTHRU_BYTESWAP_NOOP);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_ctx;
+		}
+	}
+
+	ret = ccp_init_data(&src, cmd_q, sm3->src, sm3->src_len,
+			    SM3_BLOCK_SIZE, DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	if (sm3->src_len) {
+		while (src.sg_wa.bytes_left) {
+			ccp_prepare_data(&src, NULL, &op, SM3_BLOCK_SIZE,
+					 false);
+			if (!src.sg_wa.bytes_left && sm3->final)
+				op.eom = 1;
+
+			if (!src.sg_wa.bytes_left || op.soc ||
+			    ccp_sm_queue_full(cmd_q))
+				op.ioc = 1;
+			else
+				op.ioc = 0;
+
+			ret = cmd_q->ccp->vdata->perform->sm3(&op);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_data;
+			}
+
+			if (op.ioc) {
+				ret = cmd_q->ccp->vdata->perform->run(&op);
+				if (ret) {
+					cmd->engine_error = cmd_q->cmd_error;
+					goto e_data;
+				}
+			}
+
+			ccp_process_data(&src, NULL, &op);
+		}
+	} else {
+		/*
+		 * The hardware does not pad, so build the final block in
+		 * software.
+		 */
+		src.dm_wa.address[0] = 0x80;
+		*(__be64 *)&src.dm_wa.address[56] =
+			cpu_to_be64(sm3->msg_bits);
+
+		op.soc = 0;
+		op.ioc = 1;
+		op.eom = 0;
+		op.src.u.dma.address = src.dm_wa.dma.address;
+		op.src.u.dma.offset = 0;
+		op.src.u.dma.length = SM3_BLOCK_SIZE;
+
+		ret = cmd_q->ccp->vdata->perform->sm3(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_data;
+		}
+
+		ret = cmd_q->ccp->vdata->perform->run(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_data;
+		}
+	}
+
+	ret = ccp_copy_from_sb(cmd_q, &ctx, 0, op.sb_ctx,
+			       CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_data;
+	}
+
+	if (sm3->final && sm3->opad) {
+		/* HMAC: run a second SM3 over opad || inner hash */
+		struct ccp_cmd hmac_cmd;
+		struct scatterlist sg;
+		u8 *hmac_buf;
+
+		hmac_buf = kmalloc(SM3_BLOCK_SIZE + SM3_DIGEST_SIZE,
+				   GFP_KERNEL);
+		if (!hmac_buf) {
+			ret = -ENOMEM;
+			goto e_data;
+		}
+		scatterwalk_map_and_copy(hmac_buf, sm3->opad, 0,
+					 SM3_BLOCK_SIZE, 0);
+		memcpy(hmac_buf + SM3_BLOCK_SIZE, ctx.address,
+		       SM3_DIGEST_SIZE);
+		sg_init_one(&sg, hmac_buf, SM3_BLOCK_SIZE + SM3_DIGEST_SIZE);
+
+		memset(&hmac_cmd, 0, sizeof(hmac_cmd));
+		hmac_cmd.engine = CCP_ENGINE_SM3;
+		hmac_cmd.u.sm3.type = sm3->type;
+		hmac_cmd.u.sm3.ctx = sm3->ctx;
+		hmac_cmd.u.sm3.ctx_len = sm3->ctx_len;
+		hmac_cmd.u.sm3.src = &sg;
+		hmac_cmd.u.sm3.src_len = SM3_BLOCK_SIZE + SM3_DIGEST_SIZE;
+		hmac_cmd.u.sm3.first = 1;
+		hmac_cmd.u.sm3.final = 1;
+		hmac_cmd.u.sm3.msg_bits =
+			(SM3_BLOCK_SIZE + SM3_DIGEST_SIZE) << 3;
+
+		ret = ccp_run_sm3_cmd(cmd_q, &hmac_cmd);
+		if (ret)
+			cmd->engine_error = hmac_cmd.engine_error;
+
+		kfree(hmac_buf);
+	} else {
+		ccp_get_dm_area(&ctx, 0, sm3->ctx, 0, SM3_DIGEST_SIZE);
+	}
+
+e_data:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+	return ret;
+}
+
 static int ccp_run_sm4_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	struct ccp_sm4_engine *sm4 = &cmd->u.sm4;
@@ -2797,6 +2980,14 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	case CCP_ENGINE_ECC:
 		ret = ccp_run_ecc_cmd(cmd_q, cmd);
 		break;
+	case CCP_ENGINE_SM3:
+		if (!(cmd_q->ccp->caps.engines & CCP_CAPS_SM3) ||
+		    !cmd_q->ccp->vdata->perform->sm3) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ccp_run_sm3_cmd(cmd_q, cmd);
+		break;
 	case CCP_ENGINE_SM4:
 		if (!(cmd_q->ccp->caps.engines & CCP_CAPS_SM4) ||
 		    !cmd_q->ccp->vdata->perform->sm4) {
-- 
2.34.1


