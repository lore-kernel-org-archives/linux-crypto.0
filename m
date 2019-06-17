Return-Path: <SRS0=Ym9l=UQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BABA0C31E44
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:46:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91CDA20861
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Jun 2019 08:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbfFQIqp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Jun 2019 04:46:45 -0400
Received: from foss.arm.com ([217.140.110.172]:41826 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbfFQIqp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jun 2019 04:46:45 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44C6F28;
        Mon, 17 Jun 2019 01:46:44 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 108B53F246;
        Mon, 17 Jun 2019 01:46:42 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] crypto: ccree: prevent isr handling in case driver is suspended
Date:   Mon, 17 Jun 2019 11:46:29 +0300
Message-Id: <20190617084631.23551-4-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617084631.23551-1-gilad@benyossef.com>
References: <20190617084631.23551-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ofir Drang <ofir.drang@arm.com>

ccree irq may be shared with other devices, in order to prevent ccree isr
handling while device maybe suspended we added a check to verify that the
device is not suspended.

Signed-off-by: Ofir Drang <ofir.drang@arm.com>
---
 drivers/crypto/ccree/cc_driver.c | 3 +++
 drivers/crypto/ccree/cc_pm.c     | 6 ++++++
 drivers/crypto/ccree/cc_pm.h     | 7 +++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 1e73d32148dd..667bc73d7a00 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -134,6 +134,9 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
 	u32 imr;
 
 	/* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
+	/* if driver suspended return, probebly shared interrupt */
+	if (cc_pm_is_dev_suspended(dev))
+		return IRQ_NONE;
 
 	/* read the interrupt status */
 	irr = cc_ioread(drvdata, CC_REG(HOST_IRR));
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 20f7f3d34e27..899a52f05b7a 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -106,6 +106,12 @@ int cc_pm_put_suspend(struct device *dev)
 	return rc;
 }
 
+bool cc_pm_is_dev_suspended(struct device *dev)
+{
+	/* check device state using runtime api */
+	return pm_runtime_suspended(dev);
+}
+
 int cc_pm_init(struct cc_drvdata *drvdata)
 {
 	struct device *dev = drvdata_to_dev(drvdata);
diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index 6190cdba5dad..a7d98a5da2e1 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -22,6 +22,7 @@ int cc_pm_suspend(struct device *dev);
 int cc_pm_resume(struct device *dev);
 int cc_pm_get(struct device *dev);
 int cc_pm_put_suspend(struct device *dev);
+bool cc_pm_is_dev_suspended(struct device *dev);
 
 #else
 
@@ -54,6 +55,12 @@ static inline int cc_pm_put_suspend(struct device *dev)
 	return 0;
 }
 
+static inline bool cc_pm_is_dev_suspended(struct device *dev)
+{
+	/* if PM not supported device is never suspend */
+	return false;
+}
+
 #endif
 
 #endif /*__POWER_MGR_H__*/
-- 
2.21.0

