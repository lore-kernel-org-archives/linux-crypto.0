Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95DBC3A5A8
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B602339D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567528614;
	bh=9MJwHwx/i5eFDX9Gr3lWzuowR0jSdDPVE76DZgdiHJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ny9Frs/z8lthslDjgLh5d1oKjjyfZcKJI7EiNUSt4B4kymQdHF3hRtAni8Dh8XBde
	 3duv4rumrJLOa6CmO1FX0IjcinyAR4vG0qjE9O5lJu1DNIsDVCZiWLzO1TcZzrxklb
	 njiBbRH01oYBKaa609LWfn/iiYn1VcweLCz4PD6s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbfICQ1B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730757AbfICQ1A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1FD523431;
        Tue,  3 Sep 2019 16:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528019;
        bh=9MJwHwx/i5eFDX9Gr3lWzuowR0jSdDPVE76DZgdiHJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLZDi4Fsps4vnlzBTIcaZ+mE4YqYj/fDJ8R+FxT/CK01LcEwQ98HBbACtiwhTVWKa
         ceVGVNXQXPMIKQToDl3y7IZbU9xaDa57VIVDxlRnInjAEnRNJJmPP52lO6oicPaLj/
         gPojHzBURCdlrHRsUCdSapiyFnHVBwf8gcN5PCcA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        stable@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 056/167] crypto: ccree - fix resume race condition on init
Date:   Tue,  3 Sep 2019 12:23:28 -0400
Message-Id: <20190903162519.7136-56-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit 1358c13a48c43f5e4de0c1835291837a27b9720c ]

We were enabling autosuspend, which is using data set by the
hash module, prior to the hash module being inited, casuing
a crash on resume as part of the startup sequence if the race
was lost.

This was never a real problem because the PM infra was using low
res timers so we were always winning the race, until commit 8234f6734c5d
("PM-runtime: Switch autosuspend over to using hrtimers") changed that :-)

Fix this by seperating the PM setup and enablement and doing the
latter only at the end of the init sequence.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: stable@kernel.org # v4.20
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_driver.c |  7 ++++---
 drivers/crypto/ccree/cc_pm.c     | 13 ++++++-------
 drivers/crypto/ccree/cc_pm.h     |  3 +++
 3 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 1ff229c2aeab1..186a2536fb8b9 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -364,7 +364,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	rc = cc_ivgen_init(new_drvdata);
 	if (rc) {
 		dev_err(dev, "cc_ivgen_init failed\n");
-		goto post_power_mgr_err;
+		goto post_buf_mgr_err;
 	}
 
 	/* Allocate crypto algs */
@@ -387,6 +387,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_hash_err;
 	}
 
+	/* All set, we can allow autosuspend */
+	cc_pm_go(new_drvdata);
+
 	/* If we got here and FIPS mode is enabled
 	 * it means all FIPS test passed, so let TEE
 	 * know we're good.
@@ -401,8 +404,6 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_cipher_free(new_drvdata);
 post_ivgen_err:
 	cc_ivgen_fini(new_drvdata);
-post_power_mgr_err:
-	cc_pm_fini(new_drvdata);
 post_buf_mgr_err:
 	 cc_buffer_mgr_fini(new_drvdata);
 post_req_mgr_err:
diff --git a/drivers/crypto/ccree/cc_pm.c b/drivers/crypto/ccree/cc_pm.c
index 79fc0a37ba6e4..638082dff183a 100644
--- a/drivers/crypto/ccree/cc_pm.c
+++ b/drivers/crypto/ccree/cc_pm.c
@@ -103,20 +103,19 @@ int cc_pm_put_suspend(struct device *dev)
 
 int cc_pm_init(struct cc_drvdata *drvdata)
 {
-	int rc = 0;
 	struct device *dev = drvdata_to_dev(drvdata);
 
 	/* must be before the enabling to avoid resdundent suspending */
 	pm_runtime_set_autosuspend_delay(dev, CC_SUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(dev);
 	/* activate the PM module */
-	rc = pm_runtime_set_active(dev);
-	if (rc)
-		return rc;
-	/* enable the PM module*/
-	pm_runtime_enable(dev);
+	return pm_runtime_set_active(dev);
+}
 
-	return rc;
+/* enable the PM module*/
+void cc_pm_go(struct cc_drvdata *drvdata)
+{
+	pm_runtime_enable(drvdata_to_dev(drvdata));
 }
 
 void cc_pm_fini(struct cc_drvdata *drvdata)
diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index 020a5403c58ba..f626243570209 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -16,6 +16,7 @@
 extern const struct dev_pm_ops ccree_pm;
 
 int cc_pm_init(struct cc_drvdata *drvdata);
+void cc_pm_go(struct cc_drvdata *drvdata);
 void cc_pm_fini(struct cc_drvdata *drvdata);
 int cc_pm_suspend(struct device *dev);
 int cc_pm_resume(struct device *dev);
@@ -29,6 +30,8 @@ static inline int cc_pm_init(struct cc_drvdata *drvdata)
 	return 0;
 }
 
+static void cc_pm_go(struct cc_drvdata *drvdata) {}
+
 static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
 
 static inline int cc_pm_suspend(struct device *dev)
-- 
2.20.1

