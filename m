Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE73AC33CB3
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B52122176D
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbgAPKPY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 05:15:24 -0500
Received: from foss.arm.com ([217.140.110.172]:47512 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgAPKPY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 05:15:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6781A139F;
        Thu, 16 Jan 2020 02:15:23 -0800 (PST)
Received: from e110176-lin.arm.com (unknown [10.50.4.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D903D3F534;
        Thu, 16 Jan 2020 02:15:21 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        stable@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] crypto: ccree - fix PM race condition
Date:   Thu, 16 Jan 2020 12:14:43 +0200
Message-Id: <20200116101447.20374-9-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116101447.20374-1-gilad@benyossef.com>
References: <20200116101447.20374-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The PM code was racy, possibly causing the driver to submit
requests to a powered down device. Fix the race and while
at it simplify the PM code.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
Cc: stable@kernel.org # v4.20
---
 drivers/crypto/ccree/cc_driver.h      |  1 +
 drivers/crypto/ccree/cc_pm.c          | 28 ++++-----------
 drivers/crypto/ccree/cc_request_mgr.c | 50 ---------------------------
 drivers/crypto/ccree/cc_request_mgr.h |  8 -----
 4 files changed, 7 insertions(+), 80 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.h b/drivers/crypto/ccree/cc_driver.h
index 7b6b5d6f1b33..9d77cfdb10d9 100644
--- a/drivers/crypto/ccree/cc_driver.h
+++ b/drivers/crypto/ccree/cc_driver.h
@@ -160,6 +160,7 @@ struct cc_drvdata {
 	int std_bodies;
 	bool sec_disabled;
 	u32 comp_mask;
+	bool pm_on;
 };
 
 struct cc_crypto_alg {
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 79c612144310..ee9e9cba2fbb 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -22,14 +22,8 @@ const struct dev_pm_ops ccree_pm = {
 int cc_pm_suspend(struct device *dev)
 {
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
-	int rc;
 
 	dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
-	rc = cc_suspend_req_queue(drvdata);
-	if (rc) {
-		dev_err(dev, "cc_suspend_req_queue (%x)\n", rc);
-		return rc;
-	}
 	fini_cc_regs(drvdata);
 	cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
 	cc_clk_off(drvdata);
@@ -63,13 +57,6 @@ int cc_pm_resume(struct device *dev)
 	/* check if tee fips error occurred during power down */
 	cc_tee_handle_fips_error(drvdata);
 
-	rc = cc_resume_req_queue(drvdata);
-	if (rc) {
-		dev_err(dev, "cc_resume_req_queue (%x)\n", rc);
-		return rc;
-	}
-
-	/* must be after the queue resuming as it uses the HW queue*/
 	cc_init_hash_sram(drvdata);
 
 	return 0;
@@ -80,10 +67,8 @@ int cc_pm_get(struct device *dev)
 	int rc = 0;
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
-	if (cc_req_queue_suspended(drvdata))
+	if (drvdata->pm_on)
 		rc = pm_runtime_get_sync(dev);
-	else
-		pm_runtime_get_noresume(dev);
 
 	return (rc == 1 ? 0 : rc);
 }
@@ -93,14 +78,11 @@ int cc_pm_put_suspend(struct device *dev)
 	int rc = 0;
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
-	if (!cc_req_queue_suspended(drvdata)) {
+	if (drvdata->pm_on) {
 		pm_runtime_mark_last_busy(dev);
 		rc = pm_runtime_put_autosuspend(dev);
-	} else {
-		/* Something wrong happens*/
-		dev_err(dev, "request to suspend already suspended queue");
-		rc = -EBUSY;
 	}
+
 	return rc;
 }
 
@@ -117,7 +99,7 @@ int cc_pm_init(struct cc_drvdata *drvdata)
 	/* must be before the enabling to avoid redundant suspending */
 	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
-	/* activate the PM module */
+	/* set us as active - note we won't do PM ops until cc_pm_go()! */
 	return pm_runtime_set_active(dev);
 }
 
@@ -125,9 +107,11 @@ int cc_pm_init(struct cc_drvdata *drvdata)
 void cc_pm_go(struct cc_drvdata *drvdata)
 {
 	pm_runtime_enable(drvdata_to_dev(drvdata));
+	drvdata->pm_on = true;
 }
 
 void cc_pm_fini(struct cc_drvdata *drvdata)
 {
 	pm_runtime_disable(drvdata_to_dev(drvdata));
+	drvdata->pm_on = false;
 }
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index ce09c430c8b9..9d61e6f12478 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -41,7 +41,6 @@ struct cc_req_mgr_handle {
 #else
 	struct tasklet_struct comptask;
 #endif
-	bool is_runtime_suspended;
 };
 
 struct cc_bl_item {
@@ -664,52 +663,3 @@ static void comp_handler(unsigned long devarg)
 	cc_proc_backlog(drvdata);
 	dev_dbg(dev, "Comp. handler done.\n");
 }
-
-/*
- * resume the queue configuration - no need to take the lock as this happens
- * inside the spin lock protection
- */
-#if defined(CONFIG_PM)
-int cc_resume_req_queue(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-		drvdata->request_mgr_handle;
-
-	spin_lock_bh(&request_mgr_handle->hw_lock);
-	request_mgr_handle->is_runtime_suspended = false;
-	spin_unlock_bh(&request_mgr_handle->hw_lock);
-
-	return 0;
-}
-
-/*
- * suspend the queue configuration. Since it is used for the runtime suspend
- * only verify that the queue can be suspended.
- */
-int cc_suspend_req_queue(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	/* lock the send_request */
-	spin_lock_bh(&request_mgr_handle->hw_lock);
-	if (request_mgr_handle->req_queue_head !=
-	    request_mgr_handle->req_queue_tail) {
-		spin_unlock_bh(&request_mgr_handle->hw_lock);
-		return -EBUSY;
-	}
-	request_mgr_handle->is_runtime_suspended = true;
-	spin_unlock_bh(&request_mgr_handle->hw_lock);
-
-	return 0;
-}
-
-bool cc_req_queue_suspended(struct cc_drvdata *drvdata)
-{
-	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
-
-	return	request_mgr_handle->is_runtime_suspended;
-}
-
-#endif
diff --git a/drivers/crypto/ccree/cc_request_mgr.h b/drivers/crypto/ccree/cc_request_mgr.h
index f46cf766fe4d..ff7746aaaf35 100644
--- a/drivers/crypto/ccree/cc_request_mgr.h
+++ b/drivers/crypto/ccree/cc_request_mgr.h
@@ -40,12 +40,4 @@ void complete_request(struct cc_drvdata *drvdata);
 
 void cc_req_mgr_fini(struct cc_drvdata *drvdata);
 
-#if defined(CONFIG_PM)
-int cc_resume_req_queue(struct cc_drvdata *drvdata);
-
-int cc_suspend_req_queue(struct cc_drvdata *drvdata);
-
-bool cc_req_queue_suspended(struct cc_drvdata *drvdata);
-#endif
-
 #endif /*__REQUEST_MGR_H__*/
-- 
2.23.0

