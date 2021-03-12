Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5137C433E6
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6D416501A
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbhCLQWy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhCLQWb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 11:22:31 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D147C061574;
        Fri, 12 Mar 2021 08:22:31 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id g24so4135815qts.6;
        Fri, 12 Mar 2021 08:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UdlJ/0FmcyetgWOgiJ9n2FEJ4JnK1uArLI5wZiWImF4=;
        b=cWSA9k4bWa/h+kmv8D1w5ts2/3ae/D+6M8h3StbyONRH1F40R0fpOZvMeqIQtsK8sO
         WugwHKq2bvaQlgDsCGpufeHlKJtHzmcqlD9gLYWhFfa8SEtQ6ygjXztZblJ0H3rVMKF9
         Jy3Lw7ZaG9jl4a8kt4EOhuUW2tk7JtDL1mIAeNSMwUhdODyzag5bQZypfC9FR+eQEvmv
         Lmo+CT1mAaQh9kxNv0prbQs7o/M07ZrTXOiBYwtDEEBLGujqydhYCCIxP5/z4d0JXntR
         7D7PaPUBvcy8g9QLF8rgAEyQJ0XMmHxsdqcepwGWwtzETSvuxo0Qcm+/RHLoGAZbEq61
         Vy+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UdlJ/0FmcyetgWOgiJ9n2FEJ4JnK1uArLI5wZiWImF4=;
        b=nneTP8zRDX17OnmsbCIPuYPDJMRsYLijQTS9peJm4+PFx1JHZQO1Od3kQ09Ijj9eAw
         5TIm6WxRRCQ7htroLrHQjBaPHwZ3yAbnzBSGcT/Jxb7oHRvxZBQQULTl/8dOEgM6hCXx
         IAPAlIQ7H7USEBXp1hy6fQX1r9VXtsEQ63f8yjh32dsF7czisnLrZ93DSvHA8QyOTivy
         RPf/ggLCDeRPCUUDp4GEYl5FqU+Y9aCLC7XtfSIHBmFOa10QD9o7PKMwCY1jYMEAuZfw
         84NoSEUK3JH9H5HPzjOwheQi+7Prif+C9tdxi5XynX+nLo1PXzufCTizSOp3lXZQLxCE
         xWCA==
X-Gm-Message-State: AOAM532pFTRrmRKkHCR8D6qZqYrm+JD1X0UeNEgGdbQsAEzBFk17L2V7
        1507rXpzUFksB1YsNbnYh/C/s5JfUgk+5w==
X-Google-Smtp-Source: ABdhPJxr4IKUFGdc3A1HKdPAqR1KpIP4qoPrsZLDO3UulbcaaA2/fVt/eZYuljfLg54M1ZhBWvuyOw==
X-Received: by 2002:aed:20b0:: with SMTP id 45mr11559377qtb.84.1615566150888;
        Fri, 12 Mar 2021 08:22:30 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b9e0:c84:da81:d749])
        by smtp.googlemail.com with ESMTPSA id e15sm4178623qti.79.2021.03.12.08.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:22:30 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tong Zhang <ztong0001@gmail.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set after adf_dev_init
Date:   Fri, 12 Mar 2021 11:22:03 -0500
Message-Id: <20210312162203.2416149-3-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210312162203.2416149-1-ztong0001@gmail.com>
References: <20210312162203.2416149-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ADF_STATUS_PF_RUNNING is (only) used and checked  by adf_vf2pf_shutdown()
before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
use of vf2pf_lock will cause issue.
To fix this issue, only set this flag if adf_dev_init() returns 0.

[    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
[    7.180345] Call Trace:
[    7.182576]  mutex_lock+0xc9/0xd0
[    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
[    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
[    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
[    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 4 ++--
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 4 ++--
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 1d1532e8fb6d..067ca5e17d38 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 04742a6d91ca..51ea88c0b17d 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index c972554a755e..29999da716cc 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_free_reg;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_init(accel_dev);
 	if (ret)
 		goto out_err_dev_shutdown;
 
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
-- 
2.25.1

