Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 551FDC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 15:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377723AbjJTPdi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 11:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377694AbjJTPdh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 11:33:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB3FB3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 08:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697816016; x=1729352016;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kLmMFuvm33J5Y1y/2ynZCrXV8ariL8txDc3lcc6VFFM=;
  b=WrJ5vVTI0YeWUId1dF7iFhp2Ky/ZXR4w3Xq7sL8MxVa3W+LzXkY2sv3/
   hT+EjDfA0fsZHCxtcyG+FvKkccgkk0Eneqx/aiSVMgj6abg/hu81NJpoX
   FBGt/c0ZUEyLd6XqJJu0t0RuZ2aLvBbkY9wOuMiarWuzfi1a6mQJGxoPD
   0lhJTm0W37rtoFdXfgmZsVRb+Og05S+EQPz9dP9LJCm1maKcgLZOipNa4
   fWMPGo8MAAarr4oBV92F7Of/g2h2HoW5a75r5Sw2VMZYrFqzCK3dAj0Wa
   2mote04kkrINwu48TNF1ED5gyNgtBzMeL//0OXuLhN6sbM0jqI2JgjcZR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="5129115"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="5129115"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 08:33:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="827760898"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="827760898"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga004.fm.intel.com with ESMTP; 20 Oct 2023 08:33:33 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] crypto: qat - fix deadlock in backlog processing
Date:   Fri, 20 Oct 2023 16:33:21 +0100
Message-ID: <20231020153330.70845-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If a request has the flag CRYPTO_TFM_REQ_MAY_BACKLOG set, the function
qat_alg_send_message_maybacklog(), enqueues it in a backlog list if
either (1) there is already at least one request in the backlog list, or
(2) the HW ring is nearly full or (3) the enqueue to the HW ring fails.
If an interrupt occurs right before the lock in qat_alg_backlog_req() is
taken and the backlog queue is being emptied, then there is no request
in the HW queues that can trigger a subsequent interrupt that can clear
the backlog queue. In addition subsequent requests are enqueued to the
backlog list and not sent to the hardware.

Fix it by holding the lock while taking the decision if the request
needs to be included in the backlog queue or not. This synchronizes the
flow with the interrupt handler that drains the backlog queue.

For performance reasons, the logic has been changed to try to enqueue
first without holding the lock.

Fixes: 386823839732 ("crypto: qat - add backlog mechanism")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com/T/
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../intel/qat/qat_common/qat_algs_send.c      | 46 ++++++++++---------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
index bb80455b3e81..b97b678823a9 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
@@ -40,40 +40,44 @@ void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
 	spin_unlock_bh(&backlog->lock);
 }
 
-static void qat_alg_backlog_req(struct qat_alg_req *req,
-				struct qat_instance_backlog *backlog)
-{
-	INIT_LIST_HEAD(&req->list);
-
-	spin_lock_bh(&backlog->lock);
-	list_add_tail(&req->list, &backlog->list);
-	spin_unlock_bh(&backlog->lock);
-}
-
-static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+static bool qat_alg_try_enqueue(struct qat_alg_req *req)
 {
 	struct qat_instance_backlog *backlog = req->backlog;
 	struct adf_etr_ring_data *tx_ring = req->tx_ring;
 	u32 *fw_req = req->fw_req;
 
-	/* If any request is already backlogged, then add to backlog list */
+	/* Check if any request is already backlogged */
 	if (!list_empty(&backlog->list))
-		goto enqueue;
+		return false;
 
-	/* If ring is nearly full, then add to backlog list */
+	/* Check if ring is nearly full */
 	if (adf_ring_nearly_full(tx_ring))
-		goto enqueue;
+		return false;
 
-	/* If adding request to HW ring fails, then add to backlog list */
+	/* Try to enqueue to HW ring */
 	if (adf_send_message(tx_ring, fw_req))
-		goto enqueue;
+		return false;
 
-	return -EINPROGRESS;
+	return true;
+}
 
-enqueue:
-	qat_alg_backlog_req(req, backlog);
 
-	return -EBUSY;
+static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+{
+	struct qat_instance_backlog *backlog = req->backlog;
+	int ret = -EINPROGRESS;
+
+	if (qat_alg_try_enqueue(req))
+		return ret;
+
+	spin_lock_bh(&backlog->lock);
+	if (!qat_alg_try_enqueue(req)) {
+		list_add_tail(&req->list, &backlog->list);
+		ret = -EBUSY;
+	}
+	spin_unlock_bh(&backlog->lock);
+
+	return ret;
 }
 
 int qat_alg_send_message(struct qat_alg_req *req)

base-commit: 2ce0d7cbc00a0fc65bb26203efed7ecdc98ba849
-- 
2.41.0

