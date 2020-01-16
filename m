Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B908C33CB6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E743D206B7
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 10:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731792AbgAPKPa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 05:15:30 -0500
Received: from foss.arm.com ([217.140.110.172]:47526 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731897AbgAPKP3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 05:15:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A42E13D5;
        Thu, 16 Jan 2020 02:15:29 -0800 (PST)
Received: from e110176-lin.arm.com (unknown [10.50.4.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 30BEC3F534;
        Thu, 16 Jan 2020 02:15:28 -0800 (PST)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] crypto: ccree - make cc_pm_put_suspend() void
Date:   Thu, 16 Jan 2020 12:14:45 +0200
Message-Id: <20200116101447.20374-11-gilad@benyossef.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200116101447.20374-1-gilad@benyossef.com>
References: <20200116101447.20374-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

cc_pm_put_suspend() return value was never checked and is not
useful. Turn it into a void functions.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_pm.c | 7 ++-----
 drivers/crypto/ccree/cc_pm.h | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index ee9e9cba2fbb..24c368b866f6 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -73,17 +73,14 @@ int cc_pm_get(struct device *dev)
 	return (rc == 1 ? 0 : rc);
 }
 
-int cc_pm_put_suspend(struct device *dev)
+void cc_pm_put_suspend(struct device *dev)
 {
-	int rc = 0;
 	struct cc_drvdata *drvdata = dev_get_drvdata(dev);
 
 	if (drvdata->pm_on) {
 		pm_runtime_mark_last_busy(dev);
-		rc = pm_runtime_put_autosuspend(dev);
+		pm_runtime_put_autosuspend(dev);
 	}
-
-	return rc;
 }
 
 bool cc_pm_is_dev_suspended(struct device *dev)
diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index a7d98a5da2e1..04289beb6e3e 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -21,7 +21,7 @@ void cc_pm_fini(struct cc_drvdata *drvdata);
 int cc_pm_suspend(struct device *dev);
 int cc_pm_resume(struct device *dev);
 int cc_pm_get(struct device *dev);
-int cc_pm_put_suspend(struct device *dev);
+void cc_pm_put_suspend(struct device *dev);
 bool cc_pm_is_dev_suspended(struct device *dev);
 
 #else
@@ -50,10 +50,7 @@ static inline int cc_pm_get(struct device *dev)
 	return 0;
 }
 
-static inline int cc_pm_put_suspend(struct device *dev)
-{
-	return 0;
-}
+static inline void cc_pm_put_suspend(struct device *dev) {}
 
 static inline bool cc_pm_is_dev_suspended(struct device *dev)
 {
-- 
2.23.0

