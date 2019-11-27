Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECDAC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 08:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFA2B20674
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 08:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfK0ItZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 03:49:25 -0500
Received: from foss.arm.com ([217.140.110.172]:44554 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfK0ItY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 03:49:24 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5776631B;
        Wed, 27 Nov 2019 00:49:23 -0800 (PST)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.153])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC69E3F52E;
        Wed, 27 Nov 2019 00:49:21 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] crypto: ccree: fix typos in comments
Date:   Wed, 27 Nov 2019 10:49:06 +0200
Message-Id: <20191127084909.14472-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127084909.14472-1-gilad@benyossef.com>
References: <20191127084909.14472-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hadar Gat <hadar.gat@arm.com>

Fix some typos in code comments.

Signed-off-by: Hadar Gat <hadar.gat@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

---
 drivers/crypto/ccree/cc_driver.c      |  2 +-
 drivers/crypto/ccree/cc_fips.c        |  2 +-
 drivers/crypto/ccree/cc_pm.c          |  2 +-
 drivers/crypto/ccree/cc_request_mgr.c | 12 ++++++------
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 8b8eee513c27..929ae5b468d8 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -133,7 +133,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	u32 imr;
 
 	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
-	/* if driver suspended return, probebly shared interrupt */
+	/* if driver suspended return, probably shared interrupt */
 	if (cc_pm_is_dev_suspended(dev))
 		return IRQ_NONE;
 
diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 4c8bce33abcf..702aefc21447 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -120,7 +120,7 @@ static void fips_dsr(unsigned long devarg)
 		cc_tee_handle_fips_error(drvdata);
 	}
 
-	/* after verifing that there is nothing to do,
+	/* after verifying that there is nothing to do,
 	 * unmask AXI completion interrupt.
 	 */
 	val = (CC_REG(HOST_IMR) & ~irq);
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index dbc508fb719b..c1066f433a28 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -114,7 +114,7 @@ int cc_pm_init(struct cc_drvdata *drvdata)
 {
 	struct device *dev = drvdata_to_dev(drvdata);
 
-	/* must be before the enabling to avoid resdundent suspending */
+	/* must be before the enabling to avoid redundant suspending */
 	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
 	/* activate the PM module */
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index a947d5a2cf35..3ed3164820eb 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -230,7 +230,7 @@ static int cc_queues_status(struct cc_drvdata *drvdata,
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* SW queue is checked only once as it will not
-	 * be chaned during the poll because the spinlock_bh
+	 * be changed during the poll because the spinlock_bh
 	 * is held by the thread
 	 */
 	if (((req_mgr_h->req_queue_head + 1) & (MAX_REQUEST_QUEUE_SIZE - 1)) ==
@@ -303,8 +303,8 @@ static int cc_do_send_request(struct cc_drvdata *drvdata,
 
 	/*
 	 * We are about to push command to the HW via the command registers
-	 * that may refernece hsot memory. We need to issue a memory barrier
-	 * to make sure there are no outstnading memory writes
+	 * that may reference host memory. We need to issue a memory barrier
+	 * to make sure there are no outstanding memory writes
 	 */
 	wmb();
 
@@ -532,8 +532,8 @@ int send_request_init(struct cc_drvdata *drvdata, struct cc_hw_desc *desc,
 
 	/*
 	 * We are about to push command to the HW via the command registers
-	 * that may refernece hsot memory. We need to issue a memory barrier
-	 * to make sure there are no outstnading memory writes
+	 * that may reference host memory. We need to issue a memory barrier
+	 * to make sure there are no outstanding memory writes
 	 */
 	wmb();
 	enqueue_seq(drvdata, desc, len);
@@ -668,7 +668,7 @@ static void comp_handler(unsigned long devarg)
 		request_mgr_handle->axi_completed += cc_axi_comp_count(drvdata);
 	}
 
-	/* after verifing that there is nothing to do,
+	/* after verifying that there is nothing to do,
 	 * unmask AXI completion interrupt
 	 */
 	cc_iowrite(drvdata, CC_REG(HOST_IMR),
-- 
2.23.0

