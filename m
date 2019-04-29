Return-Path: <SRS0=wtno=S7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F8AC43219
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3FE420675
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Apr 2019 15:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbfD2PoH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Apr 2019 11:44:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:22431 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728438AbfD2PoH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Apr 2019 11:44:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Apr 2019 08:44:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,410,1549958400"; 
   d="scan'208";a="319990335"
Received: from silvixa00391824.ir.intel.com (HELO silvixa00391824.ger.corp.intel.com) ([10.237.222.24])
  by orsmga005.jf.intel.com with ESMTP; 29 Apr 2019 08:44:05 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, Xin Zeng <xin.zeng@intel.com>,
        Conor Mcloughlin <conor.mcloughlin@intel.com>,
        Sergey Portnoy <sergey.portnoy@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/7] crypto: qat - remove spin_lock in qat_ablkcipher_setkey
Date:   Mon, 29 Apr 2019 16:43:15 +0100
Message-Id: <20190429154321.21098-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Xin Zeng <xin.zeng@intel.com>

Remove unnecessary spin lock in qat_ablkcipher_setkey.

Reviewed-by: Conor Mcloughlin <conor.mcloughlin@intel.com>
Tested-by: Sergey Portnoy <sergey.portnoy@intel.com>
Signed-off-by: Xin Zeng <xin.zeng@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index c8d401646902..413e05e8891e 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -131,7 +131,6 @@ struct qat_alg_ablkcipher_ctx {
 	struct icp_qat_fw_la_bulk_req dec_fw_req;
 	struct qat_crypto_instance *inst;
 	struct crypto_tfm *tfm;
-	spinlock_t lock;	/* protects qat_alg_ablkcipher_ctx struct */
 };
 
 static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
@@ -912,7 +911,6 @@ static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 	struct qat_alg_ablkcipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
 	struct device *dev;
 
-	spin_lock(&ctx->lock);
 	if (ctx->enc_cd) {
 		/* rekeying */
 		dev = &GET_DEV(ctx->inst->accel_dev);
@@ -925,29 +923,22 @@ static int qat_alg_ablkcipher_setkey(struct crypto_ablkcipher *tfm,
 		int node = get_current_node();
 		struct qat_crypto_instance *inst =
 				qat_crypto_get_instance_node(node);
-		if (!inst) {
-			spin_unlock(&ctx->lock);
+		if (!inst)
 			return -EINVAL;
-		}
 
 		dev = &GET_DEV(inst->accel_dev);
 		ctx->inst = inst;
 		ctx->enc_cd = dma_alloc_coherent(dev, sizeof(*ctx->enc_cd),
 						 &ctx->enc_cd_paddr,
 						 GFP_ATOMIC);
-		if (!ctx->enc_cd) {
-			spin_unlock(&ctx->lock);
+		if (!ctx->enc_cd)
 			return -ENOMEM;
-		}
 		ctx->dec_cd = dma_alloc_coherent(dev, sizeof(*ctx->dec_cd),
 						 &ctx->dec_cd_paddr,
 						 GFP_ATOMIC);
-		if (!ctx->dec_cd) {
-			spin_unlock(&ctx->lock);
+		if (!ctx->dec_cd)
 			goto out_free_enc;
-		}
 	}
-	spin_unlock(&ctx->lock);
 	if (qat_alg_ablkcipher_init_sessions(ctx, key, keylen, mode))
 		goto out_free_all;
 
@@ -1119,7 +1110,6 @@ static int qat_alg_ablkcipher_init(struct crypto_tfm *tfm)
 {
 	struct qat_alg_ablkcipher_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	spin_lock_init(&ctx->lock);
 	tfm->crt_ablkcipher.reqsize = sizeof(struct qat_crypto_request);
 	ctx->tfm = tfm;
 	return 0;
-- 
2.20.1

