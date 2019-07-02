Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9070EC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EF9B21473
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 11:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfGBLjo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 07:39:44 -0400
Received: from foss.arm.com ([217.140.110.172]:48126 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfGBLjn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 07:39:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71EA5344;
        Tue,  2 Jul 2019 04:39:42 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [10.50.4.178])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38B113F246;
        Tue,  2 Jul 2019 04:39:41 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] crypto: ccree: notify TEE on FIPS tests errors
Date:   Tue,  2 Jul 2019 14:39:21 +0300
Message-Id: <20190702113922.24911-5-gilad@benyossef.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190702113922.24911-1-gilad@benyossef.com>
References: <20190702113922.24911-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Register a FIPS test failure notifier and use it to notify
TEE side of FIPS test failures on our side prior to panic.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_fips.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 040e09c0e1af..4c8bce33abcf 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -3,6 +3,7 @@
 
 #include <linux/kernel.h>
 #include <linux/fips.h>
+#include <linux/notifier.h>
 
 #include "cc_driver.h"
 #include "cc_fips.h"
@@ -11,6 +12,8 @@ static void fips_dsr(unsigned long devarg);
 
 struct cc_fips_handle {
 	struct tasklet_struct tasklet;
+	struct notifier_block nb;
+	struct cc_drvdata *drvdata;
 };
 
 /* The function called once at driver entry point to check
@@ -46,6 +49,21 @@ void cc_set_ree_fips_status(struct cc_drvdata *drvdata, bool status)
 	cc_iowrite(drvdata, CC_REG(HOST_GPR0), val);
 }
 
+/* Push REE side FIPS test failure to TEE side */
+static int cc_ree_fips_failure(struct notifier_block *nb, unsigned long unused1,
+			       void *unused2)
+{
+	struct cc_fips_handle *fips_h =
+				container_of(nb, struct cc_fips_handle, nb);
+	struct cc_drvdata *drvdata = fips_h->drvdata;
+	struct device *dev = drvdata_to_dev(drvdata);
+
+	cc_set_ree_fips_status(drvdata, false);
+	dev_info(dev, "Notifying TEE of FIPS test failure...\n");
+
+	return NOTIFY_OK;
+}
+
 void cc_fips_fini(struct cc_drvdata *drvdata)
 {
 	struct cc_fips_handle *fips_h = drvdata->fips_handle;
@@ -53,6 +71,8 @@ void cc_fips_fini(struct cc_drvdata *drvdata)
 	if (drvdata->hw_rev < CC_HW_REV_712 || !fips_h)
 		return;
 
+	atomic_notifier_chain_unregister(&fips_fail_notif_chain, &fips_h->nb);
+
 	/* Kill tasklet */
 	tasklet_kill(&fips_h->tasklet);
 	drvdata->fips_handle = NULL;
@@ -124,6 +144,9 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
 
 	dev_dbg(dev, "Initializing fips tasklet\n");
 	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
+	fips_h->drvdata = p_drvdata;
+	fips_h->nb.notifier_call = cc_ree_fips_failure;
+	atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->nb);
 
 	cc_tee_handle_fips_error(p_drvdata);
 
-- 
2.21.0

