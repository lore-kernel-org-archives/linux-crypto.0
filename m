Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235E3C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Nov 2022 12:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbiKWMKx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Nov 2022 07:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236767AbiKWMKs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Nov 2022 07:10:48 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2198D657E1
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2022 04:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669205444; x=1700741444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ana/8X9K/din3bz2QWQrf6BPVh0IWX70613kJ3TiII=;
  b=Z7Tn+g1H+aeUwSgP60SLUFu4ek4Ky/Zmn1LAHbMpy0ztYkJB7S7lqaut
   J6s7siBe7tBpNNWk1XoDyGbttbZSlnom2ZMfxyIOJ57ZgMImvDgFGrBQ8
   aL8dGg5SrK3Vv+K/jDYt4L/72dIlp1kr3sOnx1T0QFY4Eccv/VqUoH7Ln
   TddmmN1+MrIlAg266+g00UluEn30Ud176QlJ3HQU/Ckk7P2XT1REYs/L5
   n3xEffVw63f2KhW2OkTNjuOZTI0QWdly/ShwUjZN1/mD5wicbXLcStqPh
   y2UCqOl/KcBxzS8UeQmx2rFReY2X8yC6n9CRg+yHRRyAE/zwPH+smrEUD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="312752464"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="312752464"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 04:10:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784227467"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784227467"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 04:10:42 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 02/11] crypto: qat - rename bufferlist functions
Date:   Wed, 23 Nov 2022 12:10:23 +0000
Message-Id: <20221123121032.71991-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
References: <20221123121032.71991-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rename the functions qat_alg_sgl_to_bufl() and qat_alg_free_bufl() as
qat_bl_sgl_to_bufl() and qat_bl_free_bufl() after their relocation into
the qat_bl module.

This commit does not implement any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c | 20 ++++++++++----------
 drivers/crypto/qat/qat_common/qat_bl.c   | 14 +++++++-------
 drivers/crypto/qat/qat_common/qat_bl.h   | 14 +++++++-------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 2ee4fa64032f..3e7e9fffe28b 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -673,7 +673,7 @@ static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
-	qat_alg_free_bufl(inst, qat_req);
+	qat_bl_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EBADMSG;
 	areq->base.complete(&areq->base, res);
@@ -743,7 +743,7 @@ static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	u8 stat_filed = qat_resp->comn_resp.comn_status;
 	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
 
-	qat_alg_free_bufl(inst, qat_req);
+	qat_bl_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EINVAL;
 
@@ -799,7 +799,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	if (cipher_len % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -821,7 +821,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
@@ -842,7 +842,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, areq->src, areq->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -866,7 +866,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
@@ -1027,7 +1027,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1048,7 +1048,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
@@ -1093,7 +1093,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	if (req->cryptlen == 0)
 		return 0;
 
-	ret = qat_alg_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
+	ret = qat_bl_sgl_to_bufl(ctx->inst, req->src, req->dst, qat_req, f);
 	if (unlikely(ret))
 		return ret;
 
@@ -1115,7 +1115,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 
 	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
 	if (ret == -ENOSPC)
-		qat_alg_free_bufl(ctx->inst, qat_req);
+		qat_bl_free_bufl(ctx->inst, qat_req);
 
 	return ret;
 }
diff --git a/drivers/crypto/qat/qat_common/qat_bl.c b/drivers/crypto/qat/qat_common/qat_bl.c
index 6d0a39f8ce10..8f7743f3c89b 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.c
+++ b/drivers/crypto/qat/qat_common/qat_bl.c
@@ -10,8 +10,8 @@
 #include "qat_bl.h"
 #include "qat_crypto.h"
 
-void qat_alg_free_bufl(struct qat_crypto_instance *inst,
-		       struct qat_crypto_request *qat_req)
+void qat_bl_free_bufl(struct qat_crypto_instance *inst,
+		      struct qat_crypto_request *qat_req)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	struct qat_alg_buf_list *bl = qat_req->buf.bl;
@@ -50,11 +50,11 @@ void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 	}
 }
 
-int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
-			struct scatterlist *sgl,
-			struct scatterlist *sglout,
-			struct qat_crypto_request *qat_req,
-			gfp_t flags)
+int qat_bl_sgl_to_bufl(struct qat_crypto_instance *inst,
+		       struct scatterlist *sgl,
+		       struct scatterlist *sglout,
+		       struct qat_crypto_request *qat_req,
+		       gfp_t flags)
 {
 	struct device *dev = &GET_DEV(inst->accel_dev);
 	int i, sg_nctr = 0;
diff --git a/drivers/crypto/qat/qat_common/qat_bl.h b/drivers/crypto/qat/qat_common/qat_bl.h
index 7a916f1ec645..ed4c200ac619 100644
--- a/drivers/crypto/qat/qat_common/qat_bl.h
+++ b/drivers/crypto/qat/qat_common/qat_bl.h
@@ -6,12 +6,12 @@
 #include <linux/types.h>
 #include "qat_crypto.h"
 
-void qat_alg_free_bufl(struct qat_crypto_instance *inst,
-		       struct qat_crypto_request *qat_req);
-int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
-			struct scatterlist *sgl,
-			struct scatterlist *sglout,
-			struct qat_crypto_request *qat_req,
-			gfp_t flags);
+void qat_bl_free_bufl(struct qat_crypto_instance *inst,
+		      struct qat_crypto_request *qat_req);
+int qat_bl_sgl_to_bufl(struct qat_crypto_instance *inst,
+		       struct scatterlist *sgl,
+		       struct scatterlist *sglout,
+		       struct qat_crypto_request *qat_req,
+		       gfp_t flags);
 
 #endif
-- 
2.38.1

