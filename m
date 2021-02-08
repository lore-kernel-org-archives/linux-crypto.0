Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94C9C433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E24064E9F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Feb 2021 09:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhBHJta (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbhBHJrH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Feb 2021 04:47:07 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E4AC06178A;
        Mon,  8 Feb 2021 01:44:08 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id t25so9862210pga.2;
        Mon, 08 Feb 2021 01:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uwo40ct7uzVjK8NcMtTbNQmNhWXoxMbACC3WJlaa3jg=;
        b=hYUdepfiK5ExCgf33lhKa/Ie8YhrA3fzDZ3v7JbaxBj7TW1gtUB7q59WA4KBczsw5s
         zWr+udFoEw4JO5ZmkGu5kDxXlDeeblKMFPptEwDSOlxqxDc0I+76HXazsmyocK/gfVxn
         RjwV0XKBu/52n7jowcnfGHMjKFJ/102Xb3J/pcGdtzkkvM06h/Gkr+Ix+y61iICOfDrX
         QrFhIlc5wYvtOdUUaekCk5VUwv66NvszSCWaQamP6VqiGh/bnx6RmPHRaKv46PYf+3jE
         eDs+2tl0cyu7fz1KYlaRr6o2DasnXulEUSQ/YDzQKmrzvCsaYilpc6HuS+iwlNCoAggq
         +lcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uwo40ct7uzVjK8NcMtTbNQmNhWXoxMbACC3WJlaa3jg=;
        b=QeFrMtf0rSgTHMwFSwzESdpekZIM1HxlQmcKQbawHwdIy3a5yVQR7gV5uEH7bb9amY
         RDU6+eKOIwDRAVQ2bOraGfDPW3BfVUM2FiHCwdX+0Q7vWl2CtRR6ZubVK+iTuDeuTEPa
         WNY71DUlnc86cs1ZZOvhTWYnZk4gkRXvXbUsPhfaIqN8mm1VJk+EisU9L96PJQ8+IPej
         fOYBKoUaxlPkshbOuGaROTkFAn7Vm1XkWarCRnbnXmw8bYuYg2I8+0R2mshWw3GMoAJy
         AW3AzpEBnqwO7Mgenq5z3RpqDZwQu9xTcGM98wSqurQYQqNznyWS4UNjMrY+V3Pd5ivx
         MWDw==
X-Gm-Message-State: AOAM533EFBaZLVSDx9IoJVlxqDGFjMIc2axsqK52uQvnS2degGVDQr/a
        5gwihmpIQb60KSrioVattAU=
X-Google-Smtp-Source: ABdhPJwZD0PBJzGUETDpysEySGYtg8JzOtAdSRbHnUPKK9CQwFhy/afhqChRNVSFgmLJd5kep9RAyg==
X-Received: by 2002:a65:5a83:: with SMTP id c3mr16086086pgt.381.1612777448231;
        Mon, 08 Feb 2021 01:44:08 -0800 (PST)
Received: from localhost.localdomain ([49.207.205.214])
        by smtp.gmail.com with ESMTPSA id k69sm12208958pfd.4.2021.02.08.01.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:44:07 -0800 (PST)
From:   Allen Pais <allen.lkml@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v5 07/19] crypto: ccree: convert tasklets to use new tasklet_setup() API
Date:   Mon,  8 Feb 2021 15:12:26 +0530
Message-Id: <20210208094238.571015-8-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210208094238.571015-1-allen.lkml@gmail.com>
References: <20210208094238.571015-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/crypto/ccree/cc_fips.c        |  8 ++++----
 drivers/crypto/ccree/cc_request_mgr.c | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/ccree/cc_fips.c b/drivers/crypto/ccree/cc_fips.c
index 702aefc21447..c1d03d99e3c3 100644
--- a/drivers/crypto/ccree/cc_fips.c
+++ b/drivers/crypto/ccree/cc_fips.c
@@ -8,7 +8,7 @@
 #include "cc_driver.h"
 #include "cc_fips.h"
 
-static void fips_dsr(unsigned long devarg);
+static void fips_dsr(struct tasklet_struct *tsk);
 
 struct cc_fips_handle {
 	struct tasklet_struct tasklet;
@@ -109,9 +109,9 @@ void cc_tee_handle_fips_error(struct cc_drvdata *p_drvdata)
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
-static void fips_dsr(unsigned long devarg)
+static void fips_dsr(struct tasklet_struct *tsk)
 {
-	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
+	struct cc_drvdata *drvdata = from_tasklet(drvdata, tsk, tasklet);
 	u32 irq, val;
 
 	irq = (drvdata->irq & (CC_GPR0_IRQ_MASK));
@@ -143,7 +143,7 @@ int cc_fips_init(struct cc_drvdata *p_drvdata)
 	p_drvdata->fips_handle = fips_h;
 
 	dev_dbg(dev, "Initializing fips tasklet\n");
-	tasklet_init(&fips_h->tasklet, fips_dsr, (unsigned long)p_drvdata);
+	tasklet_setup(&fips_h->tasklet, fips_dsr);
 	fips_h->drvdata = p_drvdata;
 	fips_h->nb.notifier_call = cc_ree_fips_failure;
 	atomic_notifier_chain_register(&fips_fail_notif_chain, &fips_h->nb);
diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
index 33fb27745d52..ec0f3bf00d33 100644
--- a/drivers/crypto/ccree/cc_request_mgr.c
+++ b/drivers/crypto/ccree/cc_request_mgr.c
@@ -70,7 +70,7 @@ static const u32 cc_cpp_int_masks[CC_CPP_NUM_ALGS][CC_CPP_NUM_SLOTS] = {
 	  BIT(CC_HOST_IRR_REE_OP_ABORTED_SM_7_INT_BIT_SHIFT) }
 };
 
-static void comp_handler(unsigned long devarg);
+static void comp_handler(struct tasklet_struct *t);
 #ifdef COMP_IN_WQ
 static void comp_work_handler(struct work_struct *work);
 #endif
@@ -140,8 +140,7 @@ int cc_req_mgr_init(struct cc_drvdata *drvdata)
 	INIT_DELAYED_WORK(&req_mgr_h->compwork, comp_work_handler);
 #else
 	dev_dbg(dev, "Initializing completion tasklet\n");
-	tasklet_init(&req_mgr_h->comptask, comp_handler,
-		     (unsigned long)drvdata);
+	tasklet_setup(&req_mgr_h->comptask, comp_handler);
 #endif
 	req_mgr_h->hw_queue_size = cc_ioread(drvdata,
 					     CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
@@ -611,11 +610,12 @@ static inline u32 cc_axi_comp_count(struct cc_drvdata *drvdata)
 }
 
 /* Deferred service handler, run as interrupt-fired tasklet */
-static void comp_handler(unsigned long devarg)
+static void comp_handler(struct tasklet_struct *t)
 {
-	struct cc_drvdata *drvdata = (struct cc_drvdata *)devarg;
 	struct cc_req_mgr_handle *request_mgr_handle =
-						drvdata->request_mgr_handle;
+				from_tasklet(request_mgr_handle, t, comptask);
+	struct cc_drvdata *drvdata = container_of((void *)request_mgr_handle,
+				     typeof(*drvdata), request_mgr_handle);
 	struct device *dev = drvdata_to_dev(drvdata);
 	u32 irq;
 
-- 
2.25.1

