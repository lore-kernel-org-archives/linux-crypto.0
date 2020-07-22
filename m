Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5502C433E5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 09:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 763AF2077D
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 09:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u4B0jnZF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgGVJez (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 05:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgGVJez (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 05:34:55 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C637C0619DC;
        Wed, 22 Jul 2020 02:34:55 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so910677pgf.0;
        Wed, 22 Jul 2020 02:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k5E+V6ct6HyLJ6yKPQ9T6SLmM+2VDiZ6UKk3SsdlnAc=;
        b=u4B0jnZFr5l1a+refeXSmVWldsk+ZDFx993cLNpD6979m8ayY0j7qLoX0EsWyIR3gG
         jbCgHqOXkJcmgpvaGNNy86qLHJdosY2BIJAq5MR5mZzDHfE7eVlMgTQjM8uQUqyAwXS8
         TyW5jpySSyg25Z1CqBZn9C6ZYedNfYO/Kf/k68qMj338YZmBIoGpyEw5DQadqM+lcZpK
         9qooTRtiLmPWJ9lZEAP80xWXlzEZEiqiXleHgx155dgKxMGPiKVAn2iTldjsEMFV2Q2p
         sWsnf1NNJO66Jzz0tD2TltbuH24RGoLfkyp/OU0zVKU9MwNuROjUn3nj33rPWMxHe79G
         cg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k5E+V6ct6HyLJ6yKPQ9T6SLmM+2VDiZ6UKk3SsdlnAc=;
        b=PR++eQyQqlvV9jq9yFD7koSRUQ4xbA+7RVST3aPWOziyXzg9qIKqF//XPhC5f93XhT
         x202Yn+0/kG9cMWIxpfs7ikeivxDam/ZWt/gPnWEhq3uSQ6A0eKy1hDcfY582JW7CAcc
         9XF+9VpdRp2P2AxLGMHe6/zSnfviecxPDfTIy2o0AyTfaC8x0Alq9rrqlvC//g31qia3
         iJZhx3hGys3EbdaqW5jjLSFTJXD8qYRtwTJ4cF/1lf+Xx2VVwUcbBtXus7diwlx4371J
         wP1lpjcnLBXFjKhrUsuKJaFsHarJJUtdsQ1wgzryCatbXd8jBPsehj+mGmRm139LeYUu
         WBNA==
X-Gm-Message-State: AOAM533+DlLdGRGbobdh3zGeCjLioTCvwtBsfiX77zfwiB/oVis+10/B
        DjEhnn6VMluFT2dnZvFusLk=
X-Google-Smtp-Source: ABdhPJyhAeLuCtJ1p7M4iB/fKrlUHccP0jnK2PCgVftmV1SPQBIY6yVZhi1Gkc8zmLp+iJJXr8LvdA==
X-Received: by 2002:a05:6a00:78a:: with SMTP id g10mr28487647pfu.0.1595410494405;
        Wed, 22 Jul 2020 02:34:54 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id b22sm5775644pju.26.2020.07.22.02.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 02:34:53 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2] crypto: ccp: sp-pci: use generic power management
Date:   Wed, 22 Jul 2020 15:00:58 +0530
Message-Id: <20200722093057.98551-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <95db9ba2-ffbb-ca92-6a70-1ee401920eed@amd.com>
References: <95db9ba2-ffbb-ca92-6a70-1ee401920eed@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drivers using legacy power management .suspen()/.resume() callbacks
have to manage PCI states and device's PM states themselves. They also
need to take care of standard configuration registers.

Switch to generic power management framework using a single
"struct dev_pm_ops" variable to take the unnecessary load from the driver.
This also avoids the need for the driver to directly call most of the PCI
helper functions and device power state control functions as through
the generic framework, PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/crypto/ccp/ccp-dev.c     |  4 +---
 drivers/crypto/ccp/sp-dev.c      |  6 ++----
 drivers/crypto/ccp/sp-dev.h      |  6 +++---
 drivers/crypto/ccp/sp-pci.c      | 17 ++++++-----------
 drivers/crypto/ccp/sp-platform.c |  2 +-
 5 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index 19ac509ed76e..0971ee60f840 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -531,7 +531,6 @@ int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 	return len;
 }
 
-#ifdef CONFIG_PM
 bool ccp_queues_suspended(struct ccp_device *ccp)
 {
 	unsigned int suspended = 0;
@@ -549,7 +548,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
 	return ccp->cmd_q_count == suspended;
 }
 
-int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
+int ccp_dev_suspend(struct sp_device *sp)
 {
 	struct ccp_device *ccp = sp->ccp_data;
 	unsigned long flags;
@@ -601,7 +600,6 @@ int ccp_dev_resume(struct sp_device *sp)
 
 	return 0;
 }
-#endif
 
 int ccp_dev_init(struct sp_device *sp)
 {
diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
index ce42675d3274..6284a15e5047 100644
--- a/drivers/crypto/ccp/sp-dev.c
+++ b/drivers/crypto/ccp/sp-dev.c
@@ -211,13 +211,12 @@ void sp_destroy(struct sp_device *sp)
 	sp_del_device(sp);
 }
 
-#ifdef CONFIG_PM
-int sp_suspend(struct sp_device *sp, pm_message_t state)
+int sp_suspend(struct sp_device *sp)
 {
 	int ret;
 
 	if (sp->dev_vdata->ccp_vdata) {
-		ret = ccp_dev_suspend(sp, state);
+		ret = ccp_dev_suspend(sp);
 		if (ret)
 			return ret;
 	}
@@ -237,7 +236,6 @@ int sp_resume(struct sp_device *sp)
 
 	return 0;
 }
-#endif
 
 struct sp_device *sp_get_psp_master_device(void)
 {
diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
index f913f1494af9..0218d0670eee 100644
--- a/drivers/crypto/ccp/sp-dev.h
+++ b/drivers/crypto/ccp/sp-dev.h
@@ -119,7 +119,7 @@ int sp_init(struct sp_device *sp);
 void sp_destroy(struct sp_device *sp);
 struct sp_device *sp_get_master(void);
 
-int sp_suspend(struct sp_device *sp, pm_message_t state);
+int sp_suspend(struct sp_device *sp);
 int sp_resume(struct sp_device *sp);
 int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
 		       const char *name, void *data);
@@ -134,7 +134,7 @@ struct sp_device *sp_get_psp_master_device(void);
 int ccp_dev_init(struct sp_device *sp);
 void ccp_dev_destroy(struct sp_device *sp);
 
-int ccp_dev_suspend(struct sp_device *sp, pm_message_t state);
+int ccp_dev_suspend(struct sp_device *sp);
 int ccp_dev_resume(struct sp_device *sp);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_CCP */
@@ -145,7 +145,7 @@ static inline int ccp_dev_init(struct sp_device *sp)
 }
 static inline void ccp_dev_destroy(struct sp_device *sp) { }
 
-static inline int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
+static inline int ccp_dev_suspend(struct sp_device *sp)
 {
 	return 0;
 }
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index cb6cb47053f4..f471dbaef1fb 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -252,23 +252,19 @@ static void sp_pci_remove(struct pci_dev *pdev)
 	sp_free_irqs(sp);
 }
 
-#ifdef CONFIG_PM
-static int sp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused sp_pci_suspend(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
 	struct sp_device *sp = dev_get_drvdata(dev);
 
-	return sp_suspend(sp, state);
+	return sp_suspend(sp);
 }
 
-static int sp_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused sp_pci_resume(struct device *dev)
 {
-	struct device *dev = &pdev->dev;
 	struct sp_device *sp = dev_get_drvdata(dev);
 
 	return sp_resume(sp);
 }
-#endif
 
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
 static const struct sev_vdata sevv1 = {
@@ -365,15 +361,14 @@ static const struct pci_device_id sp_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, sp_pci_table);
 
+static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
+
 static struct pci_driver sp_pci_driver = {
 	.name = "ccp",
 	.id_table = sp_pci_table,
 	.probe = sp_pci_probe,
 	.remove = sp_pci_remove,
-#ifdef CONFIG_PM
-	.suspend = sp_pci_suspend,
-	.resume = sp_pci_resume,
-#endif
+	.driver.pm = &sp_pci_pm_ops,
 };
 
 int sp_pci_init(void)
diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 831aac1393a2..9dba52fbee99 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -207,7 +207,7 @@ static int sp_platform_suspend(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	struct sp_device *sp = dev_get_drvdata(dev);
 
-	return sp_suspend(sp, state);
+	return sp_suspend(sp);
 }
 
 static int sp_platform_resume(struct platform_device *pdev)
-- 
2.27.0

