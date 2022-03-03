Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2264BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Mar 2022 18:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiCCSOZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Mar 2022 13:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbiCCSOX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Mar 2022 13:14:23 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917EDED97F
        for <linux-crypto@vger.kernel.org>; Thu,  3 Mar 2022 10:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646331216; x=1677867216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=475KWS36204xKiy0tqQJ+UmV+QHP6FZza11GytI92l8=;
  b=cC5RqPaSlgDoe+cRmsKis5bsjRhVZU/MewBkY6AePifmE4IqfkLQDqLe
   tmch4b0yuTweSimlw1Ku3cHElAinXZvGZR1xbqzgclJBx8/x7VbgL6SM/
   lpPBp8McfMg6yJqRVmSE3XbJ1YRCCcSNyuni7DEUdf4pgZeS5PJKC1gS7
   HTjZC4L7JOmNaTUQ34TPbiLTMxHfzsaNFTs1O8RmGy+AY/DuybG+4tRiD
   HRGnVSodkG1jXT2ZLgQ+HsviWbCM5KmB3KhNt0YyHuQteLN4Wf40d7GLu
   9GGs44/B9DrX4rbydx7RDDWepRlS3scos2nOtDDqEz8UMGCSIwB4LpmPW
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="278447770"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="278447770"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 10:00:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="640279706"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2022 10:00:52 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Kyle Sanderson <kyle.leet@gmail.com>,
        Vlad Dronov <vdronov@redhat.com>,
        Vishnu Das Ramachandran <vishnu.dasx.ramachandran@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [RFC 2/3] crypto: qat - add backlog mechanism
Date:   Thu,  3 Mar 2022 18:00:35 +0000
Message-Id: <20220303180036.13475-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220303180036.13475-1-giovanni.cabiddu@intel.com>
References: <20220303180036.13475-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Vishnu Das Ramachandran <vishnu.dasx.ramachandran@intel.com>

The implementations of aead and skcipher in the QAT driver are not
properly supporting requests with the CRYPTO_TFM_REQ_MAY_BACKLOG flag set.
If the HW queue is full, the driver returns -EBUSY but does not enqueue
the request.
This can result in applications like dm-crypt waiting indefinitely for a
completion of a request that was never submitted to the hardware.

Fix this by adding a software backlog queue: if the ring buffer is more
than eighty five percent full, then the request is enqueued to a backlog
list, a worker thread is scheduled to resubmit it at later time and the
error code -EBUSY is returned up to the caller.
The request for which -EBUSY is returned is then marked as -EINPROGRESS
in response callback, when response for that request is received.

Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Kyle Sanderson <kyle.leet@gmail.com>
Signed-off-by: Vishnu Das Ramachandran <vishnu.dasx.ramachandran@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c |  12 +
 drivers/crypto/qat/qat_common/adf_transport.h |   1 +
 .../qat/qat_common/adf_transport_internal.h   |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c      | 230 ++++++++++++++----
 drivers/crypto/qat/qat_common/qat_crypto.h    |   2 +
 5 files changed, 204 insertions(+), 42 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 8ba28409fb74..bc81a91b681a 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -8,6 +8,9 @@
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 
+#define ADF_MAX_RING_THRESHOLD 85
+#define ADF_CFG_PERCENT_TO_NUM(tot, percent)	(((tot) * (percent)) / 100)
+
 static inline u32 adf_modulo(u32 data, u32 shift)
 {
 	u32 div = data >> shift;
@@ -77,6 +80,11 @@ static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, u32 ring)
 				      bank->irq_mask);
 }
 
+bool adf_ring_nearly_full(struct adf_etr_ring_data *ring)
+{
+	return atomic_read(ring->inflights) > ring->threshold;
+}
+
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg)
 {
 	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(ring->bank->accel_dev);
@@ -217,6 +225,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	struct adf_etr_bank_data *bank;
 	struct adf_etr_ring_data *ring;
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	int max_inflights;
 	u32 ring_num;
 	int ret;
 
@@ -261,6 +270,9 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	ring->callback = callback;
 	ring->msg_size = ADF_BYTES_TO_MSG_SIZE(msg_size);
 	ring->ring_size = adf_verify_ring_size(msg_size, num_msgs);
+	max_inflights = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
+	ring->threshold = ADF_CFG_PERCENT_TO_NUM(max_inflights,
+						 ADF_MAX_RING_THRESHOLD);
 	ring->head = 0;
 	ring->tail = 0;
 	atomic_set(ring->inflights, 0);
diff --git a/drivers/crypto/qat/qat_common/adf_transport.h b/drivers/crypto/qat/qat_common/adf_transport.h
index 2c95f1697c76..e6ef6f9b7691 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.h
+++ b/drivers/crypto/qat/qat_common/adf_transport.h
@@ -14,6 +14,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		    const char *ring_name, adf_callback_fn callback,
 		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
 
+bool adf_ring_nearly_full(struct adf_etr_ring_data *ring);
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index 501bcf0f1809..8b2c92ba7ca1 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -22,6 +22,7 @@ struct adf_etr_ring_data {
 	spinlock_t lock;	/* protects ring data struct */
 	u16 head;
 	u16 tail;
+	u32 threshold;
 	u8 ring_number;
 	u8 ring_size;
 	u8 msg_size;
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 862184aec3d4..765377cebcca 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -43,6 +43,8 @@
 	(GET_HW_DATA(accel_dev)->accel_capabilities_mask & \
 	 ICP_ACCEL_CAPABILITIES_AES_V2)
 
+#define ADF_MAX_RETRIES	10
+
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
@@ -60,6 +62,13 @@ struct qat_alg_cd {
 	};
 } __aligned(64);
 
+struct qat_alg_crypto_backlog {
+	struct workqueue_struct *wq;
+	struct list_head backlog_list;
+	spinlock_t list_lock; /* protects backlog list */
+	struct work_struct work;
+};
+
 struct qat_alg_aead_ctx {
 	struct qat_alg_cd *enc_cd;
 	struct qat_alg_cd *dec_cd;
@@ -77,6 +86,7 @@ struct qat_alg_aead_ctx {
 	};
 	char ipad[SHA512_BLOCK_SIZE]; /* sufficient for SHA-1/SHA-256 as well */
 	char opad[SHA512_BLOCK_SIZE];
+	struct qat_alg_crypto_backlog bk_log;
 };
 
 struct qat_alg_skcipher_ctx {
@@ -89,6 +99,7 @@ struct qat_alg_skcipher_ctx {
 	struct qat_crypto_instance *inst;
 	struct crypto_skcipher *ftfm;
 	struct crypto_cipher *tweak;
+	struct qat_alg_crypto_backlog bk_log;
 	bool fallback;
 	int mode;
 };
@@ -849,6 +860,8 @@ static void qat_aead_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 	qat_alg_free_bufl(inst, qat_req);
 	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
 		res = -EBADMSG;
+	if (qat_req->enqueued)
+		areq->base.complete(&areq->base, -EINPROGRESS);
 	areq->base.complete(&areq->base, res);
 }
 
@@ -907,6 +920,130 @@ static void qat_alg_update_iv(struct qat_crypto_request *qat_req)
 	}
 }
 
+static void qat_alg_send_backlogged_req(struct qat_alg_crypto_backlog *bk_log,
+					struct adf_etr_ring_data *sym_tx,
+					work_func_t worker_func)
+{
+	struct qat_crypto_request *qat_req = NULL;
+	struct list_head *request = NULL;
+
+	spin_lock_bh(&bk_log->list_lock);
+	while (!list_empty(&bk_log->backlog_list)) {
+		request = bk_log->backlog_list.next;
+		qat_req = list_entry(request, struct qat_crypto_request, list);
+
+		if (adf_send_message(sym_tx, (u32 *)&qat_req->req)) {
+			/* If adf_send_message() fails, trigger worker */
+			INIT_WORK(&bk_log->work, worker_func);
+			queue_work(bk_log->wq, &bk_log->work);
+			break;
+		}
+		list_del(request);
+	}
+	spin_unlock_bh(&bk_log->list_lock);
+}
+
+static void qat_alg_aead_swq_worker(struct work_struct *work)
+{
+	struct qat_alg_crypto_backlog *bk_log =
+		container_of(work, struct qat_alg_crypto_backlog, work);
+	struct qat_alg_aead_ctx *aead_ctx =
+		container_of(bk_log, struct qat_alg_aead_ctx, bk_log);
+
+	qat_alg_send_backlogged_req(bk_log,
+				    aead_ctx->inst->sym_tx,
+				    qat_alg_aead_swq_worker);
+}
+
+static void qat_alg_skciph_swq_worker(struct work_struct *work)
+{
+	struct qat_alg_crypto_backlog *bk_log =
+		container_of(work, struct qat_alg_crypto_backlog, work);
+	struct qat_alg_skcipher_ctx *skcipher_ctx =
+		container_of(bk_log, struct qat_alg_skcipher_ctx, bk_log);
+
+	qat_alg_send_backlogged_req(bk_log,
+				    skcipher_ctx->inst->sym_tx,
+				    qat_alg_skciph_swq_worker);
+}
+
+static int qat_alg_backlog_req(struct qat_crypto_request *qat_req,
+			       struct qat_alg_crypto_backlog *bk_log,
+			       work_func_t worker_func)
+{
+	/* For any backlogged request, enqueued should be true. */
+	qat_req->enqueued = true;
+
+	/* Add request to backlog list */
+	spin_lock_bh(&bk_log->list_lock);
+	if (list_empty(&bk_log->backlog_list)) {
+		/* Add work to queue, only if it is the first element in list */
+		INIT_WORK(&bk_log->work, worker_func);
+		queue_work(bk_log->wq, &bk_log->work);
+	}
+	list_add_tail(&qat_req->list, &bk_log->backlog_list);
+	spin_unlock_bh(&bk_log->list_lock);
+
+	return -EBUSY;
+}
+
+static int qat_alg_send_may_backlog_req(struct qat_crypto_request *qat_req,
+					struct qat_alg_crypto_backlog *bk_log,
+					struct adf_etr_ring_data *sym_tx,
+					work_func_t worker_func)
+{
+	/* If any request is already backlogged, then add to backlog list */
+	if (!list_empty(&bk_log->backlog_list))
+		return qat_alg_backlog_req(qat_req, bk_log, worker_func);
+
+	qat_req->enqueued = adf_ring_nearly_full(sym_tx);
+
+	/*
+	 * If ring utilization is more than ADF_MAX_RING_THRESHOLD percent,
+	 * then add to backlog list.
+	 */
+	if (qat_req->enqueued)
+		return qat_alg_backlog_req(qat_req, bk_log, worker_func);
+
+	/* If adding request to HW ring fails, then add to backlog list */
+	if (adf_send_message(sym_tx, (u32 *)&qat_req->req))
+		return qat_alg_backlog_req(qat_req, bk_log, worker_func);
+
+	return -EINPROGRESS;
+}
+
+static int qat_alg_send_message(struct qat_crypto_request *qat_req,
+				struct qat_crypto_instance *inst)
+{
+	int ret = 0, ctr = 0;
+
+	/* For requests without backlog support, enqueued should be false. */
+	qat_req->enqueued = false;
+
+	do {
+		ret = adf_send_message(inst->sym_tx, (u32 *)&qat_req->req);
+	} while (ret == -EAGAIN && ctr++ < ADF_MAX_RETRIES);
+	if (ret == -EAGAIN) {
+		qat_alg_free_bufl(inst, qat_req);
+		return -EAGAIN;
+	}
+
+	return -EINPROGRESS;
+}
+
+static int qat_alg_skcipher_send_message(struct qat_crypto_request *qat_req)
+{
+	struct qat_alg_skcipher_ctx *ctx = qat_req->skcipher_ctx;
+
+	if (qat_req->skcipher_req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		return qat_alg_send_may_backlog_req(qat_req, &ctx->bk_log,
+						    ctx->inst->sym_tx,
+						    qat_alg_skciph_swq_worker);
+	}
+
+	return qat_alg_send_message(qat_req, ctx->inst);
+}
+
 static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 				      struct qat_crypto_request *qat_req)
 {
@@ -925,6 +1062,8 @@ static void qat_skcipher_alg_callback(struct icp_qat_fw_la_resp *qat_resp,
 
 	memcpy(sreq->iv, qat_req->iv, AES_BLOCK_SIZE);
 
+	if (qat_req->enqueued)
+		sreq->base.complete(&sreq->base, -EINPROGRESS);
 	sreq->base.complete(&sreq->base, res);
 }
 
@@ -937,6 +1076,19 @@ void qat_alg_callback(void *resp)
 	qat_req->cb(qat_resp, qat_req);
 }
 
+static int qat_alg_aead_send_message(struct qat_crypto_request *qat_req)
+{
+	struct qat_alg_aead_ctx *ctx = qat_req->aead_ctx;
+
+	if (qat_req->aead_req->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG) {
+		return qat_alg_send_may_backlog_req(qat_req, &ctx->bk_log,
+						    ctx->inst->sym_tx,
+						    qat_alg_aead_swq_worker);
+	}
+
+	return qat_alg_send_message(qat_req, ctx->inst);
+}
+
 static int qat_alg_aead_dec(struct aead_request *areq)
 {
 	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(areq);
@@ -947,7 +1099,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
-	int ret, ctr = 0;
+	int ret;
 	u32 cipher_len;
 
 	cipher_len = areq->cryptlen - digst_size;
@@ -973,15 +1125,8 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
-	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+	return qat_alg_aead_send_message(qat_req);
 }
 
 static int qat_alg_aead_enc(struct aead_request *areq)
@@ -994,7 +1139,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	u8 *iv = areq->iv;
-	int ret, ctr = 0;
+	int ret;
 
 	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
@@ -1021,15 +1166,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
-	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+	return qat_alg_aead_send_message(qat_req);
 }
 
 static int qat_alg_skcipher_rekey(struct qat_alg_skcipher_ctx *ctx,
@@ -1182,7 +1319,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	int ret, ctr = 0;
+	int ret;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1206,15 +1343,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 
 	qat_alg_set_req_iv(qat_req);
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
-	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+	return qat_alg_skcipher_send_message(qat_req);
 }
 
 static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
@@ -1251,7 +1380,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	int ret, ctr = 0;
+	int ret;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1276,15 +1405,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	qat_alg_set_req_iv(qat_req);
 	qat_alg_update_iv(qat_req);
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
-	if (ret == -EAGAIN) {
-		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+	return qat_alg_skcipher_send_message(qat_req);
 }
 
 static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
@@ -1313,6 +1434,19 @@ static int qat_alg_skcipher_xts_decrypt(struct skcipher_request *req)
 	return qat_alg_skcipher_decrypt(req);
 }
 
+static int qat_alg_wq_init(struct qat_alg_crypto_backlog *bk_log, char *wq_name)
+{
+	bk_log->wq = alloc_ordered_workqueue(wq_name, WQ_MEM_RECLAIM);
+	if (!bk_log->wq) {
+		pr_err("work queue allocation failure");
+		return -EFAULT;
+	}
+	INIT_LIST_HEAD(&bk_log->backlog_list);
+	spin_lock_init(&bk_log->list_lock);
+
+	return 0;
+}
+
 static int qat_alg_aead_init(struct crypto_aead *tfm,
 			     enum icp_qat_hw_auth_algo hash,
 			     const char *hash_name)
@@ -1324,7 +1458,8 @@ static int qat_alg_aead_init(struct crypto_aead *tfm,
 		return PTR_ERR(ctx->hash_tfm);
 	ctx->qat_hash_alg = hash;
 	crypto_aead_set_reqsize(tfm, sizeof(struct qat_crypto_request));
-	return 0;
+
+	return qat_alg_wq_init(&ctx->bk_log, "qat_alg_aead_send_wq");
 }
 
 static int qat_alg_aead_sha1_init(struct crypto_aead *tfm)
@@ -1364,13 +1499,20 @@ static void qat_alg_aead_exit(struct crypto_aead *tfm)
 		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
 	}
+	if (ctx->bk_log.wq)
+		destroy_workqueue(ctx->bk_log.wq);
+	ctx->bk_log.wq = NULL;
+
 	qat_crypto_put_instance(inst);
 }
 
 static int qat_alg_skcipher_init_tfm(struct crypto_skcipher *tfm)
 {
+	struct qat_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+
 	crypto_skcipher_set_reqsize(tfm, sizeof(struct qat_crypto_request));
-	return 0;
+
+	return qat_alg_wq_init(&ctx->bk_log, "qat_alg_skciph_send_wq");
 }
 
 static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
@@ -1394,7 +1536,7 @@ static int qat_alg_skcipher_init_xts_tfm(struct crypto_skcipher *tfm)
 		      crypto_skcipher_reqsize(ctx->ftfm));
 	crypto_skcipher_set_reqsize(tfm, reqsize);
 
-	return 0;
+	return qat_alg_wq_init(&ctx->bk_log, "qat_alg_skciph_send_wq");
 }
 
 static void qat_alg_skcipher_exit_tfm(struct crypto_skcipher *tfm)
@@ -1421,6 +1563,10 @@ static void qat_alg_skcipher_exit_tfm(struct crypto_skcipher *tfm)
 				  sizeof(struct icp_qat_hw_cipher_algo_blk),
 				  ctx->dec_cd, ctx->dec_cd_paddr);
 	}
+	if (ctx->bk_log.wq)
+		destroy_workqueue(ctx->bk_log.wq);
+	ctx->bk_log.wq = NULL;
+
 	qat_crypto_put_instance(inst);
 }
 
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index 8f2aa4804ed0..136516190a50 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -53,6 +53,7 @@ struct qat_crypto_request_buffs {
 struct qat_crypto_request;
 
 struct qat_crypto_request {
+	struct list_head list;
 	struct icp_qat_fw_la_bulk_req req;
 	union {
 		struct qat_alg_aead_ctx *aead_ctx;
@@ -65,6 +66,7 @@ struct qat_crypto_request {
 	struct qat_crypto_request_buffs buf;
 	void (*cb)(struct icp_qat_fw_la_resp *resp,
 		   struct qat_crypto_request *req);
+	bool enqueued;
 	union {
 		struct {
 			__be64 iv_hi;
-- 
2.35.1

