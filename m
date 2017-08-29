From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: [PATCH] crypto: brcm - Explicity ACK mailbox message
Date: Tue, 29 Aug 2017 15:08:10 +0530
Message-ID: <1503999490-14527-1-git-send-email-raveendra.padasalagi@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com,
        Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Steve Lin <steven.lin1@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        Anup Patel <anup.patel@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35981 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdH2JiY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Aug 2017 05:38:24 -0400
Received: by mail-wr0-f173.google.com with SMTP id p14so8446446wrg.3
        for <linux-crypto@vger.kernel.org>; Tue, 29 Aug 2017 02:38:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support to explicity ACK mailbox message
because after sending message we can know
the send status via error attribute of brcm_message.

This is needed to support "txdone_ack" supported in
mailbox controller driver.

Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")
Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Reviewed-by: Anup Patel <anup.patel@broadcom.com>
Reviewed-by: Scott Branden <scott.branden@broadcom.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/crypto/bcm/cipher.c b/drivers/crypto/bcm/cipher.c
index 9cfd36c..45440ac 100644
--- a/drivers/crypto/bcm/cipher.c
+++ b/drivers/crypto/bcm/cipher.c
@@ -258,6 +258,44 @@ static u8 select_channel(void)
 	return 0;
 }
 
+static int mailbox_send_message(struct brcm_message *mssg, u32 flags,
+				u8 chan_idx)
+{
+	int err;
+	int retry_cnt = 0;
+	struct device *dev = &(iproc_priv.pdev->dev);
+
+	err = mbox_send_message(iproc_priv.mbox[chan_idx], mssg);
+	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
+		while ((err == -ENOBUFS) && (retry_cnt < SPU_MB_RETRY_MAX)) {
+			/*
+			 * Mailbox queue is full. Since MAY_SLEEP is set, assume
+			 * not in atomic context and we can wait and try again.
+			 */
+			retry_cnt++;
+			usleep_range(MBOX_SLEEP_MIN, MBOX_SLEEP_MAX);
+			err = mbox_send_message(iproc_priv.mbox[chan_idx],
+						mssg);
+			atomic_inc(&iproc_priv.mb_no_spc);
+		}
+	}
+	if (err < 0) {
+		atomic_inc(&iproc_priv.mb_send_fail);
+		return err;
+	}
+
+	/* Check error returned by mailbox controller */
+	err = mssg->error;
+	if (unlikely(err < 0)) {
+		dev_err(dev, "message error %d", err);
+		/* Signal txdone for mailbox channel */
+	}
+
+	/* Signal txdone for mailbox channel */
+	mbox_client_txdone(iproc_priv.mbox[chan_idx], err);
+	return err;
+}
+
 /**
  * handle_ablkcipher_req() - Submit as much of a block cipher request as fits in
  * a single SPU request message, starting at the current position in the request
@@ -295,7 +333,6 @@ static int handle_ablkcipher_req(struct iproc_reqctx_s *rctx)
 	u32 pad_len;		/* total length of all padding */
 	bool update_key = false;
 	struct brcm_message *mssg;	/* mailbox message */
-	int retry_cnt = 0;
 
 	/* number of entries in src and dst sg in mailbox message. */
 	u8 rx_frag_num = 2;	/* response header and STATUS */
@@ -464,24 +501,9 @@ static int handle_ablkcipher_req(struct iproc_reqctx_s *rctx)
 	if (err)
 		return err;
 
-	err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx], mssg);
-	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
-		while ((err == -ENOBUFS) && (retry_cnt < SPU_MB_RETRY_MAX)) {
-			/*
-			 * Mailbox queue is full. Since MAY_SLEEP is set, assume
-			 * not in atomic context and we can wait and try again.
-			 */
-			retry_cnt++;
-			usleep_range(MBOX_SLEEP_MIN, MBOX_SLEEP_MAX);
-			err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx],
-						mssg);
-			atomic_inc(&iproc_priv.mb_no_spc);
-		}
-	}
-	if (unlikely(err < 0)) {
-		atomic_inc(&iproc_priv.mb_send_fail);
+	err = mailbox_send_message(mssg, req->base.flags, rctx->chan_idx);
+	if (unlikely(err < 0))
 		return err;
-	}
 
 	return -EINPROGRESS;
 }
@@ -712,7 +734,6 @@ static int handle_ahash_req(struct iproc_reqctx_s *rctx)
 	u32 spu_hdr_len;
 	unsigned int digestsize;
 	u16 rem = 0;
-	int retry_cnt = 0;
 
 	/*
 	 * number of entries in src and dst sg. Always includes SPU msg header.
@@ -906,24 +927,10 @@ static int handle_ahash_req(struct iproc_reqctx_s *rctx)
 	if (err)
 		return err;
 
-	err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx], mssg);
-	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
-		while ((err == -ENOBUFS) && (retry_cnt < SPU_MB_RETRY_MAX)) {
-			/*
-			 * Mailbox queue is full. Since MAY_SLEEP is set, assume
-			 * not in atomic context and we can wait and try again.
-			 */
-			retry_cnt++;
-			usleep_range(MBOX_SLEEP_MIN, MBOX_SLEEP_MAX);
-			err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx],
-						mssg);
-			atomic_inc(&iproc_priv.mb_no_spc);
-		}
-	}
-	if (err < 0) {
-		atomic_inc(&iproc_priv.mb_send_fail);
+	err = mailbox_send_message(mssg, req->base.flags, rctx->chan_idx);
+	if (unlikely(err < 0))
 		return err;
-	}
+
 	return -EINPROGRESS;
 }
 
@@ -1322,7 +1329,6 @@ static int handle_aead_req(struct iproc_reqctx_s *rctx)
 	int assoc_nents = 0;
 	bool incl_icv = false;
 	unsigned int digestsize = ctx->digestsize;
-	int retry_cnt = 0;
 
 	/* number of entries in src and dst sg. Always includes SPU msg header.
 	 */
@@ -1560,24 +1566,9 @@ static int handle_aead_req(struct iproc_reqctx_s *rctx)
 	if (err)
 		return err;
 
-	err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx], mssg);
-	if (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) {
-		while ((err == -ENOBUFS) && (retry_cnt < SPU_MB_RETRY_MAX)) {
-			/*
-			 * Mailbox queue is full. Since MAY_SLEEP is set, assume
-			 * not in atomic context and we can wait and try again.
-			 */
-			retry_cnt++;
-			usleep_range(MBOX_SLEEP_MIN, MBOX_SLEEP_MAX);
-			err = mbox_send_message(iproc_priv.mbox[rctx->chan_idx],
-						mssg);
-			atomic_inc(&iproc_priv.mb_no_spc);
-		}
-	}
-	if (err < 0) {
-		atomic_inc(&iproc_priv.mb_send_fail);
+	err = mailbox_send_message(mssg, req->base.flags, rctx->chan_idx);
+	if (unlikely(err < 0))
 		return err;
-	}
 
 	return -EINPROGRESS;
 }
@@ -4534,7 +4525,7 @@ static int spu_mb_init(struct device *dev)
 	mcl->dev = dev;
 	mcl->tx_block = false;
 	mcl->tx_tout = 0;
-	mcl->knows_txdone = false;
+	mcl->knows_txdone = true;
 	mcl->rx_callback = spu_rx_callback;
 	mcl->tx_done = NULL;
 
-- 
1.9.1
