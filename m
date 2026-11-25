Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.204.27.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795592809;
	b=vUlDASz91SY/eSO4lk7DeelvDAmMJXlySfmimDJcKopAJf8xnScMwTQgIyOIsPTCFPpM
	 a6OBWzZtuYeU1nVMzF4iXzhZ/I9PAIyCgVnKPdXxxmztVFzAgt0AVge6xpyuUJompZXpA
	 MtdsPh5DhvehFqd9T1zcPXisQt2gqDVjckg3FKEawviDxZb1ZaDrft7sfdsbyzvlmI1Hn
	 L74rRzzCnp5n/LR01/QmRpW5b5gUMBZsFvfLPae/EJ+mb/hH6Fhvfvcr5IB7CpI0U328L
	 TpXkU+HINn01Nc29oYD/4rkhd79B8V0PsNdntSk+rBGOY93y8mcrFqCMPCp6CaC0xLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795592809;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=O0dxg9sQR54CoSswMiIYr2rAIrZPN6NcFOT/s/cbJ5M=;
	b=bYD9ZD59lqaktknqEV+bYLNLQbYzc4AZ28Ci/oVEtP7vWUrLMDbOPf0SoBnRSW+NNUVx
	 RjMyCJbUlU8IZ8Kfx0Zv33Z5dQfk5DxFTGXEN2eo4Kyl8B67rXq5RXwrFgi9PPjNP0BMP
	 +zClv3vxl+zADWCkU8f2rQLwbTOgF5ISffaF1U+dqRs5vFQBHQiggRLq4NegOplYfk1CF
	 rYC6SvixgNC1cRXQvP8vTNOGMWZnYx3UYYGMDF417QcdPBsmk7KTEuSBskPBHolR9QnOL
	 wHWo5E7DMITP8jNyv4d1DVQ56eHT+Qb+XIQ4puKIZq4Mj7vNQA9talb4LwIqbhYZzDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hygon.cn;
	spf=pass smtp.mailfrom=hygon.cn;
	arc=none smtp.remote-ip=101.204.27.37
Received: from spam01.hygon.cn (unknown [101.204.27.37])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A05660A5BD7;
	Wed, 25 Nov 2026 07:46:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A05660A5BD7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hygon.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hygon.cn
Received: from maildlp2.hygon.cn (unknown [127.0.0.1])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZn6FPFzVcBM;
	Wed, 25 Nov 2026 15:46:41 +0800 (CST)
Received: from maildlp2.hygon.cn (unknown [172.23.18.61])
	by spam01.hygon.cn (Postfix) with ESMTP id 4jZBZn2mmHzVcB9;
	Wed, 25 Nov 2026 15:46:41 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp2.hygon.cn (Postfix) with ESMTPS id C8A87300B6F1;
	Wed, 25 Nov 2026 15:45:28 +0800 (CST)
Received: from hygon.hygon.cn (172.25.24.133) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Nov
 2026 15:46:41 +0800
From: Depei Yang <yangdepei@hygon.cn>
To: <linux-crypto@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Gary
 R Hook <gary.hook@amd.com>, <linux-kernel@vger.kernel.org>, Depei Yang
	<yangdepei@hygon.cn>, Shan Chen <chenshan@hygon.cn>, Yongwei Xu
	<xuyongwei@hygon.cn>, Xiaochen Shen <shenxiaochen@hygon.cn>
Subject: [PATCH 10/11] crypto: ccp - add SM4 engine and skcipher algorithms
Date: Wed, 25 Nov 2026 15:46:08 +0800
Message-ID: <197a8174e8f0e39b92585c4fa24f228d5e4486d1.1795588986.git.yangdepei@hygon.cn>
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

Add the SM4 and SM4-CTR command builders, the ccp-ops request handling
and the skcipher front end.  ecb(sm4) and cbc(sm4) are registered when a
device advertises the SM4 engine; ctr(sm4) needs the separately reported
SM4-CTR engine.

Reviewed-by: Shan Chen <chenshan@hygon.cn>
Tested-by: Yongwei Xu <xuyongwei@hygon.cn>
Signed-off-by: Depei Yang <yangdepei@hygon.cn>
---
 drivers/crypto/ccp/Makefile          |   3 +-
 drivers/crypto/ccp/ccp-crypto-main.c |  16 ++
 drivers/crypto/ccp/ccp-crypto-sm4.c  | 254 +++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |   1 +
 drivers/crypto/ccp/ccp-dev-v5.c      |  65 ++++++
 drivers/crypto/ccp/ccp-dev.h         |   2 +
 drivers/crypto/ccp/ccp-ops.c         | 296 +++++++++++++++++++++++++++
 7 files changed, 636 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-sm4.c

diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 0424e08561ef..dd0177961465 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -28,4 +28,5 @@ ccp-crypto-objs := ccp-crypto-main.o \
 		   ccp-crypto-aes-galois.o \
 		   ccp-crypto-des3.o \
 		   ccp-crypto-rsa.o \
-		   ccp-crypto-sha.o
+		   ccp-crypto-sha.o \
+		   ccp-crypto-sm4.o
diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 388ecb1694e5..e68c843ce3fb 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -42,6 +42,10 @@ static unsigned int rsa_disable;
 module_param(rsa_disable, uint, 0444);
 MODULE_PARM_DESC(rsa_disable, "Disable use of RSA - any non-zero value");
 
+static unsigned int sm_disable;
+module_param(sm_disable, uint, 0444);
+MODULE_PARM_DESC(sm_disable, "Disable use of SM3/SM4 - any non-zero value");
+
 /* List heads for the supported algorithms */
 static LIST_HEAD(hash_algs);
 static LIST_HEAD(skcipher_algs);
@@ -363,6 +367,18 @@ static int ccp_register_algs(void)
 			return ret;
 	}
 
+	if (!sm_disable && ccp_has_cap(CCP_CAPS_SM4)) {
+		ret = ccp_register_sm4_algs(&skcipher_algs);
+		if (ret)
+			return ret;
+	}
+
+	if (!sm_disable && ccp_has_cap(CCP_CAPS_SM4_CTR)) {
+		ret = ccp_register_sm4_ctr_algs(&skcipher_algs);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/crypto/ccp/ccp-crypto-sm4.c b/drivers/crypto/ccp/ccp-crypto-sm4.c
new file mode 100644
index 000000000000..fbdba8cd0da0
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-crypto-sm4.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * CCP SM4 crypto API support
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
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
+
+#include "ccp-crypto.h"
+
+enum ccp_sm4_alg_mode {
+	CCP_SM4_ALG_MODE_ECB = CCP_SM4_MODE_ECB,
+	CCP_SM4_ALG_MODE_CBC = CCP_SM4_MODE_CBC,
+	CCP_SM4_ALG_MODE_CTR = CCP_SM4_MODE_CTR,
+};
+
+static int ccp_sm4_complete(struct crypto_async_request *async_req, int ret)
+{
+	struct skcipher_request *req = skcipher_request_cast(async_req);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx_dma(crypto_skcipher_reqtfm(req));
+	struct ccp_sm4_req_ctx *rctx = skcipher_request_ctx_dma(req);
+
+	if (ret)
+		return ret;
+
+	if (ctx->u.sm4.mode != CCP_SM4_ALG_MODE_ECB) {
+		memcpy(req->iv, rctx->iv, SM4_BLOCK_SIZE);
+		memset(rctx->iv, 0, SM4_BLOCK_SIZE);
+	}
+
+	return 0;
+}
+
+static int ccp_sm4_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			  unsigned int key_len)
+{
+	struct ccp_ctx *ctx = crypto_skcipher_ctx_dma(tfm);
+
+	if (!key || key_len != SM4_KEY_SIZE)
+		return -EINVAL;
+
+	memcpy(ctx->u.sm4.key, key, key_len);
+	sg_init_one(&ctx->u.sm4.key_sg, ctx->u.sm4.key, key_len);
+
+	ctx->u.sm4.key_len = key_len;
+
+	return 0;
+}
+
+static int ccp_sm4_crypt(struct skcipher_request *req, bool encrypt)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx_dma(tfm);
+	struct ccp_sm4_req_ctx *rctx = skcipher_request_ctx_dma(req);
+	struct scatterlist *iv_sg = NULL;
+	struct ccp_cmd *cmd = &rctx->cmd;
+	enum ccp_sm4_alg_mode mode = ctx->u.sm4.mode;
+	enum ccp_sm4_action action;
+	int ret;
+
+	if (!ctx->u.sm4.key_len)
+		return -ENOKEY;
+
+	if (mode != CCP_SM4_ALG_MODE_CTR &&
+	    (req->cryptlen & (SM4_BLOCK_SIZE - 1)))
+		return -EINVAL;
+
+	if (mode != CCP_SM4_ALG_MODE_ECB) {
+		if (!req->iv)
+			return -EINVAL;
+
+		memcpy(rctx->iv, req->iv, SM4_BLOCK_SIZE);
+		iv_sg = &rctx->iv_sg;
+		sg_init_one(iv_sg, rctx->iv, SM4_BLOCK_SIZE);
+	}
+
+	memset(cmd, 0, sizeof(*cmd));
+	INIT_LIST_HEAD(&cmd->entry);
+	action = encrypt ? CCP_SM4_ACTION_ENCRYPT : CCP_SM4_ACTION_DECRYPT;
+
+	if (mode == CCP_SM4_ALG_MODE_CTR) {
+		cmd->engine = CCP_ENGINE_SM4_CTR;
+		cmd->u.sm4_ctr.action = action;
+		cmd->u.sm4_ctr.size = 63;
+		cmd->u.sm4_ctr.step = 1;
+
+		cmd->u.sm4_ctr.key = &ctx->u.sm4.key_sg;
+		cmd->u.sm4_ctr.key_len = SM4_KEY_SIZE;
+		cmd->u.sm4_ctr.iv = iv_sg;
+		cmd->u.sm4_ctr.iv_len = SM4_BLOCK_SIZE;
+
+		cmd->u.sm4_ctr.src = req->src;
+		cmd->u.sm4_ctr.dst = req->dst;
+		cmd->u.sm4_ctr.src_len = req->cryptlen;
+	} else {
+		cmd->engine = CCP_ENGINE_SM4;
+		cmd->u.sm4.mode = (enum ccp_sm4_mode)mode;
+		cmd->u.sm4.action = action;
+
+		cmd->u.sm4.key = &ctx->u.sm4.key_sg;
+		cmd->u.sm4.key_len = ctx->u.sm4.key_len;
+		cmd->u.sm4.iv = iv_sg;
+		cmd->u.sm4.iv_len = iv_sg ? SM4_BLOCK_SIZE : 0;
+
+		cmd->u.sm4.src = req->src;
+		cmd->u.sm4.dst = req->dst;
+		cmd->u.sm4.src_len = req->cryptlen;
+	}
+
+	ret = ccp_crypto_enqueue_request(&req->base, cmd);
+
+	return ret;
+}
+
+static int ccp_sm4_encrypt(struct skcipher_request *req)
+{
+	return ccp_sm4_crypt(req, true);
+}
+
+static int ccp_sm4_decrypt(struct skcipher_request *req)
+{
+	return ccp_sm4_crypt(req, false);
+}
+
+static int ccp_sm4_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct ccp_crypto_skcipher_alg *alg = ccp_crypto_skcipher_alg(tfm);
+	struct ccp_ctx *ctx = crypto_skcipher_ctx_dma(tfm);
+
+	ctx->complete = ccp_sm4_complete;
+	ctx->u.sm4.mode = alg->mode;
+
+	crypto_skcipher_set_reqsize_dma(tfm, sizeof(struct ccp_sm4_req_ctx));
+
+	return 0;
+}
+
+static const struct skcipher_alg ccp_sm4_defaults = {
+	.setkey			= ccp_sm4_setkey,
+	.encrypt		= ccp_sm4_encrypt,
+	.decrypt		= ccp_sm4_decrypt,
+	.min_keysize		= SM4_KEY_SIZE,
+	.max_keysize		= SM4_KEY_SIZE,
+	.init			= ccp_sm4_init_tfm,
+
+	.base.cra_flags		= CRYPTO_ALG_ASYNC |
+				  CRYPTO_ALG_ALLOCATES_MEMORY |
+				  CRYPTO_ALG_KERN_DRIVER_ONLY |
+				  CRYPTO_ALG_NEED_FALLBACK,
+	.base.cra_blocksize	= SM4_BLOCK_SIZE,
+	.base.cra_ctxsize	= sizeof(struct ccp_ctx) + CRYPTO_DMA_PADDING,
+	.base.cra_priority	= CCP_CRA_PRIORITY,
+	.base.cra_module	= THIS_MODULE,
+};
+
+struct ccp_sm4_def {
+	enum ccp_sm4_alg_mode mode;
+	const char *name;
+	const char *driver_name;
+	unsigned int blocksize;
+	unsigned int ivsize;
+	const struct skcipher_alg *alg_defaults;
+};
+
+static const struct ccp_sm4_def sm4_algs[] = {
+	{
+		.mode		= CCP_SM4_ALG_MODE_ECB,
+		.name		= "ecb(sm4)",
+		.driver_name	= "ecb-sm4-ccp",
+		.blocksize	= SM4_BLOCK_SIZE,
+		.ivsize		= 0,
+		.alg_defaults	= &ccp_sm4_defaults,
+	},
+	{
+		.mode		= CCP_SM4_ALG_MODE_CBC,
+		.name		= "cbc(sm4)",
+		.driver_name	= "cbc-sm4-ccp",
+		.blocksize	= SM4_BLOCK_SIZE,
+		.ivsize		= SM4_BLOCK_SIZE,
+		.alg_defaults	= &ccp_sm4_defaults,
+	},
+};
+
+/* SM4-CTR is a separate engine on the CCP */
+static const struct ccp_sm4_def sm4_ctr_alg = {
+	.mode		= CCP_SM4_ALG_MODE_CTR,
+	.name		= "ctr(sm4)",
+	.driver_name	= "ctr-sm4-ccp",
+	.blocksize	= 1,
+	.ivsize		= SM4_BLOCK_SIZE,
+	.alg_defaults	= &ccp_sm4_defaults,
+};
+
+static int ccp_register_sm4_alg(struct list_head *head,
+				const struct ccp_sm4_def *def)
+{
+	struct ccp_crypto_skcipher_alg *ccp_alg;
+	struct skcipher_alg *alg;
+	int ret;
+
+	ccp_alg = kzalloc_obj(*ccp_alg);
+	if (!ccp_alg)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&ccp_alg->entry);
+
+	ccp_alg->mode = def->mode;
+
+	/* copy the defaults and override as necessary */
+	alg = &ccp_alg->alg;
+	*alg = *def->alg_defaults;
+	strscpy(alg->base.cra_name, def->name);
+	strscpy(alg->base.cra_driver_name, def->driver_name);
+	alg->base.cra_blocksize = def->blocksize;
+	alg->ivsize = def->ivsize;
+
+	ret = crypto_register_skcipher(alg);
+	if (ret) {
+		pr_err("%s skcipher algorithm registration error (%d)\n",
+		       alg->base.cra_name, ret);
+		kfree(ccp_alg);
+		return ret;
+	}
+
+	list_add(&ccp_alg->entry, head);
+
+	return 0;
+}
+
+int ccp_register_sm4_algs(struct list_head *head)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(sm4_algs); i++) {
+		ret = ccp_register_sm4_alg(head, &sm4_algs[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int ccp_register_sm4_ctr_algs(struct list_head *head)
+{
+	return ccp_register_sm4_alg(head, &sm4_ctr_alg);
+}
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
index dfd16df920a3..9d6f2983f39f 100644
--- a/drivers/crypto/ccp/ccp-crypto.h
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -349,5 +349,6 @@ int ccp_register_des3_algs(struct list_head *head);
 int ccp_register_rsa_algs(struct list_head *head);
 int ccp_register_sm3_algs(struct list_head *head);
 int ccp_register_sm4_algs(struct list_head *head);
+int ccp_register_sm4_ctr_algs(struct list_head *head);
 
 #endif
diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
index 0284be103ad1..8cbbb8d81d17 100644
--- a/drivers/crypto/ccp/ccp-dev-v5.c
+++ b/drivers/crypto/ccp/ccp-dev-v5.c
@@ -7,6 +7,7 @@
  * Author: Gary R Hook <gary.hook@amd.com>
  */
 
+#include <crypto/sm4.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/dma-mapping.h>
@@ -631,6 +632,68 @@ static int ccp5_perform_ecc(struct ccp_op *op)
 	return ccp5_do_cmd(&desc, op->cmd_q);
 }
 
+static int ccp5_perform_sm4_common(struct ccp_op *op, enum ccp_engine engine,
+				   u32 function)
+{
+	struct ccp5_desc desc;
+	u32 key_addr = op->sb_ctx * LSB_ITEM_SIZE + SM4_BLOCK_SIZE;
+
+	memset(&desc, 0, Q_DESC_SIZE);
+
+	CCP5_CMD_ENGINE(&desc) = engine;
+
+	CCP5_CMD_SOC(&desc) = op->soc;
+	CCP5_CMD_IOC(&desc) = op->ioc;
+	CCP5_CMD_INIT(&desc) = op->init;
+	CCP5_CMD_EOM(&desc) = op->eom;
+	CCP5_CMD_PROT(&desc) = 0;
+
+	CCP5_CMD_FUNCTION(&desc) = function;
+
+	CCP5_CMD_LEN(&desc) = op->src.u.dma.length;
+
+	CCP5_CMD_SRC_LO(&desc) = ccp_addr_lo(&op->src.u.dma);
+	CCP5_CMD_SRC_HI(&desc) = ccp_addr_hi(&op->src.u.dma);
+	CCP5_CMD_SRC_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+	CCP5_CMD_LSB_ID(&desc) = op->sb_ctx;
+
+	CCP5_CMD_DST_LO(&desc) = ccp_addr_lo(&op->dst.u.dma);
+	CCP5_CMD_DST_HI(&desc) = ccp_addr_hi(&op->dst.u.dma);
+	CCP5_CMD_DST_MEM(&desc) = CCP_MEMTYPE_SYSTEM;
+
+	CCP5_CMD_KEY_LO(&desc) = lower_32_bits(key_addr);
+	CCP5_CMD_KEY_HI(&desc) = 0;
+	CCP5_CMD_KEY_MEM(&desc) = CCP_MEMTYPE_SB;
+
+	ccp5_submit_cmd(&desc, op->cmd_q);
+
+	return 0;
+}
+
+static int ccp5_perform_sm4(struct ccp_op *op)
+{
+	union ccp_function function;
+
+	function.raw = 0;
+	CCP_SM4_ENCRYPT(&function) = op->u.sm4.action;
+	CCP_SM4_MODE(&function) = op->u.sm4.mode;
+	CCP_SM4_SELECT(&function) = op->u.sm4.select;
+
+	return ccp5_perform_sm4_common(op, CCP_ENGINE_SM4, function.raw);
+}
+
+static int ccp5_perform_sm4_ctr(struct ccp_op *op)
+{
+	union ccp_function function;
+
+	function.raw = 0;
+	CCP_SM4_CTR_SIZE(&function) = op->u.sm4_ctr.size;
+	CCP_SM4_CTR_ENCRYPT(&function) = op->u.sm4_ctr.action;
+	CCP_SM4_CTR_STEP(&function) = op->u.sm4_ctr.step;
+
+	return ccp5_perform_sm4_common(op, CCP_ENGINE_SM4_CTR, function.raw);
+}
+
 static int ccp_find_lsb_regions(struct ccp_cmd_queue *cmd_q, u64 status)
 {
 	int q_mask = 1 << cmd_q->id;
@@ -1159,6 +1222,8 @@ static const struct ccp_actions ccp5_actions = {
 	.passthru = ccp5_perform_passthru,
 	.ecc = ccp5_perform_ecc,
 	.run = ccp5_run_cmd,
+	.sm4 = ccp5_perform_sm4,
+	.sm4_ctr = ccp5_perform_sm4_ctr,
 	.sballoc = ccp_lsb_alloc,
 	.sbfree = ccp_lsb_free,
 	.init = ccp5_init,
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index c2b8068bc123..544c7079882f 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -683,6 +683,8 @@ struct ccp_actions {
 	int (*passthru)(struct ccp_op *);
 	int (*ecc)(struct ccp_op *);
 	int (*run)(struct ccp_op *op);
+	int (*sm4)(struct ccp_op *op);
+	int (*sm4_ctr)(struct ccp_op *op);
 	u32 (*sballoc)(struct ccp_cmd_queue *, unsigned int);
 	void (*sbfree)(struct ccp_cmd_queue *, unsigned int, unsigned int);
 	unsigned int (*get_free_slots)(struct ccp_cmd_queue *);
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index f35803c37ab4..7c8464b1db6b 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -10,6 +10,7 @@
 
 #include <crypto/des.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/sm4.h>
 #include <crypto/utils.h>
 #include <linux/ccp.h>
 #include <linux/dma-mapping.h>
@@ -2473,6 +2474,285 @@ ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	}
 }
 
+/*
+ * The SM engines queue several descriptors before running the queue.
+ * Keep one descriptor slot free so that the ring never wraps around an
+ * entry that the hardware has not consumed yet.
+ */
+static bool ccp_sm_queue_full(struct ccp_cmd_queue *cmd_q)
+{
+	const struct ccp_actions *perform = cmd_q->ccp->vdata->perform;
+
+	if (!perform->get_free_slots)
+		return true;
+
+	return perform->get_free_slots(cmd_q) <= 1;
+}
+
+static int ccp_run_sm4_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_sm4_engine *sm4 = &cmd->u.sm4;
+	struct ccp_dm_workarea iv_key;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	bool in_place = false;
+	int ret;
+
+	if (!sm4->src || !sm4->dst)
+		return -EINVAL;
+
+	if (!sm4->key || sm4->key_len != SM4_KEY_SIZE)
+		return -EINVAL;
+
+	if (sg_nents_for_len(sm4->key, SM4_KEY_SIZE) < 0)
+		return -EINVAL;
+
+	if (sm4->mode != CCP_SM4_MODE_ECB) {
+		if (!sm4->iv || sm4->iv_len != SM4_BLOCK_SIZE)
+			return -EINVAL;
+
+		if (sg_nents_for_len(sm4->iv, SM4_BLOCK_SIZE) < 0)
+			return -EINVAL;
+	}
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.ioc = 1;
+	op.sb_ctx = cmd_q->sb_ctx;
+	op.init = (sm4->mode == CCP_SM4_MODE_ECB) ? 0 : 1;
+	op.u.sm4.action = sm4->action;
+	op.u.sm4.mode = sm4->mode;
+	op.u.sm4.select = sm4->select;
+
+	/*
+	 * Prepare the input and output data workareas. For in-place
+	 * operations we need to set the dma direction to BIDIRECTIONAL
+	 * and copy the src workarea to the dst workarea.
+	 */
+	if (sg_virt(sm4->src) == sg_virt(sm4->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, sm4->src, sm4->src_len,
+			    SM4_BLOCK_SIZE,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	if (in_place) {
+		dst = src;
+	} else {
+		ret = ccp_init_data(&dst, cmd_q, sm4->dst, sm4->src_len,
+				    SM4_BLOCK_SIZE, DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* load iv and key */
+	ret = ccp_init_dm_workarea(&iv_key, cmd_q,
+				   SM4_BLOCK_SIZE + SM4_KEY_SIZE,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_dst;
+
+	if (sm4->mode != CCP_SM4_MODE_ECB)
+		ccp_set_dm_area(&iv_key, 0, sm4->iv, 0, SM4_BLOCK_SIZE);
+
+	ccp_set_dm_area(&iv_key, SM4_BLOCK_SIZE, sm4->key, 0, SM4_KEY_SIZE);
+
+	ret = ccp_copy_to_sb(cmd_q, &iv_key, 0, op.sb_ctx,
+			     CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_iv_key;
+	}
+
+	/* send data to the CCP SM4 engine */
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, &dst, &op, SM4_BLOCK_SIZE, true);
+		if (!src.sg_wa.bytes_left)
+			op.eom = 1;
+
+		if (!src.sg_wa.bytes_left || op.soc ||
+		    ccp_sm_queue_full(cmd_q))
+			op.ioc = 1;
+		else
+			op.ioc = 0;
+
+		ret = cmd_q->ccp->vdata->perform->sm4(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_iv_key;
+		}
+
+		if (op.ioc) {
+			ret = cmd_q->ccp->vdata->perform->run(&op);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_iv_key;
+			}
+		}
+
+		ccp_process_data(&src, &dst, &op);
+	}
+
+	if (sm4->mode != CCP_SM4_MODE_ECB) {
+		/* retrieve the SM4 iv */
+		ret = ccp_copy_from_sb(cmd_q, &iv_key, 0, op.sb_ctx,
+				       CCP_PASSTHRU_BYTESWAP_NOOP);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_iv_key;
+		}
+
+		ccp_get_dm_area(&iv_key, 0, sm4->iv, 0, SM4_BLOCK_SIZE);
+	}
+
+e_iv_key:
+	memset(iv_key.address, 0, SM4_BLOCK_SIZE + SM4_KEY_SIZE);
+	ccp_dm_free(&iv_key);
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+	return ret;
+}
+
+static int ccp_run_sm4_ctr_cmd(struct ccp_cmd_queue *cmd_q,
+			       struct ccp_cmd *cmd)
+{
+	struct ccp_sm4_ctr_engine *sm4_ctr = &cmd->u.sm4_ctr;
+	struct ccp_dm_workarea iv_key;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	bool in_place = false;
+	int ret;
+
+	if (!sm4_ctr->src || !sm4_ctr->dst)
+		return -EINVAL;
+
+	if (!sm4_ctr->key || sm4_ctr->key_len != SM4_KEY_SIZE)
+		return -EINVAL;
+
+	if (sg_nents_for_len(sm4_ctr->key, SM4_KEY_SIZE) < 0)
+		return -EINVAL;
+
+	if (!sm4_ctr->iv || sm4_ctr->iv_len != SM4_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (sg_nents_for_len(sm4_ctr->iv, SM4_BLOCK_SIZE) < 0)
+		return -EINVAL;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = CCP_NEW_JOBID(cmd_q->ccp);
+	op.ioc = 1;
+	op.sb_ctx = cmd_q->sb_ctx;
+	op.init = 1;
+	op.u.sm4_ctr.size = sm4_ctr->size;
+	op.u.sm4_ctr.action = sm4_ctr->action;
+	op.u.sm4_ctr.step = sm4_ctr->step;
+
+	if (sg_virt(sm4_ctr->src) == sg_virt(sm4_ctr->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, sm4_ctr->src, sm4_ctr->src_len,
+			    SM4_BLOCK_SIZE,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	if (in_place) {
+		dst = src;
+	} else {
+		ret = ccp_init_data(&dst, cmd_q, sm4_ctr->dst,
+				    sm4_ctr->src_len, SM4_BLOCK_SIZE,
+				    DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* load iv and key */
+	ret = ccp_init_dm_workarea(&iv_key, cmd_q,
+				   SM4_BLOCK_SIZE + SM4_KEY_SIZE,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_dst;
+
+	ccp_set_dm_area(&iv_key, 0, sm4_ctr->iv, 0, SM4_BLOCK_SIZE);
+	ccp_set_dm_area(&iv_key, SM4_BLOCK_SIZE, sm4_ctr->key, 0,
+			SM4_KEY_SIZE);
+
+	ret = ccp_copy_to_sb(cmd_q, &iv_key, 0, op.sb_ctx,
+			     CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_iv_key;
+	}
+
+	/* send data to the CCP SM4_CTR engine */
+	while (src.sg_wa.bytes_left) {
+		/*
+		 * The SM4_CTR engine processes a length that is not a
+		 * multiple of the block size, so the last partial block is
+		 * submitted as is instead of being padded to a full block
+		 * the way the block modes do it.
+		 */
+		ccp_prepare_data(&src, &dst, &op, SM4_BLOCK_SIZE, false);
+		if (!src.sg_wa.bytes_left)
+			op.eom = 1;
+
+		if (!src.sg_wa.bytes_left || op.soc ||
+		    ccp_sm_queue_full(cmd_q))
+			op.ioc = 1;
+		else
+			op.ioc = 0;
+
+		ret = cmd_q->ccp->vdata->perform->sm4_ctr(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_iv_key;
+		}
+
+		if (op.ioc) {
+			ret = cmd_q->ccp->vdata->perform->run(&op);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_iv_key;
+			}
+		}
+
+		ccp_process_data(&src, &dst, &op);
+	}
+
+	/* retrieve the SM4_CTR iv */
+	ret = ccp_copy_from_sb(cmd_q, &iv_key, 0, op.sb_ctx,
+			       CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_iv_key;
+	}
+
+	ccp_get_dm_area(&iv_key, 0, sm4_ctr->iv, 0, SM4_BLOCK_SIZE);
+
+e_iv_key:
+	memset(iv_key.address, 0, SM4_BLOCK_SIZE + SM4_KEY_SIZE);
+	ccp_dm_free(&iv_key);
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+	return ret;
+}
+
 int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 {
 	int ret;
@@ -2517,6 +2797,22 @@ int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	case CCP_ENGINE_ECC:
 		ret = ccp_run_ecc_cmd(cmd_q, cmd);
 		break;
+	case CCP_ENGINE_SM4:
+		if (!(cmd_q->ccp->caps.engines & CCP_CAPS_SM4) ||
+		    !cmd_q->ccp->vdata->perform->sm4) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ccp_run_sm4_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_SM4_CTR:
+		if (!(cmd_q->ccp->caps.engines & CCP_CAPS_SM4_CTR) ||
+		    !cmd_q->ccp->vdata->perform->sm4_ctr) {
+			ret = -EINVAL;
+			break;
+		}
+		ret = ccp_run_sm4_ctr_cmd(cmd_q, cmd);
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.34.1


