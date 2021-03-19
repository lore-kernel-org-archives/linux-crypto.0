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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D2EC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2648064F30
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:41:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbhCSDkt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbhCSDkT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 23:40:19 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E1DAC06174A;
        Thu, 18 Mar 2021 20:40:19 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id r14so5804455qtt.7;
        Thu, 18 Mar 2021 20:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=v5j6GsQ8vHTvN2BKBHKR/KZ/Jo+Q52naC77HAhp4AOM=;
        b=pRI2dvsKz4oBMf9IHQoTRN0k1Vuzmiduruu5qBxF1Uyf1MSLZcyeurQ27Eyx+0Wpht
         X4yy8ibi7LDb4XiojM1FJ8adJSZLba4Q0usTFvsaxC+7/tG3YeH/TDPvT5AeOqWx5Kg5
         pCWie51GDzxu5CbiD7WJ4KMQWgIj0bZEg4qj3J0LEqz2AknEt+dcuiTUgAQOPDWZBEsq
         sM7K3Y0VOGqILB/qtp5jXezmdgmiOHlMzzTJ1R0Imu9YyDJUS7gow7N3mlaDTNkHYLHo
         7LXkQxO+aqBgiOoFK45IrU0WdQolPvpGfMc5v82c1rfg5x87l87MsTOh8uNb7iLnsxY5
         7qPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v5j6GsQ8vHTvN2BKBHKR/KZ/Jo+Q52naC77HAhp4AOM=;
        b=XLkbCqCQsEdTQoQ409zfqxsLYTmapJecn3nC5t51EwPxK/2K+/SKUbrFKuwOlWWyqB
         01hqndKjEars8H7ffBMd6lOdqVnvi5AHJuFQNsYA3V94eHc+Hz5oz2OkXVSuHZOYoiAk
         rT0RiWklTDM7Cnls5U9BbY3IOm6M7Ygqp6y3n2VqpZiq7/jyj99qD9VX3VmWnInH6eAN
         sk88A4oWQkrA3u2pM+9dAn66Fkjoub0sfx7xHaqCDZewbU+zQV6spvjIga8c+DkhxngN
         ZkOJ4xvdYHrcM6switSlyUD13DY/CsfVitwtogYJPFtz5dIlik+c61SUwW+7JeV+N3By
         yrtA==
X-Gm-Message-State: AOAM530LOxz1f3qTHNGz9ER+ae2XnCOnUF5v+9SZbghjQmyhcAm3PHgW
        UVxcMlEkUmZHx5yt29gL0gU=
X-Google-Smtp-Source: ABdhPJwkK3XMsWVCfGa2lTsToA+u2RUJORIt/ULMdDTTGaSCIHwvumEcTHz3IXFGHEmtY801A+N1Bw==
X-Received: by 2002:ac8:519a:: with SMTP id c26mr6586313qtn.342.1616125218604;
        Thu, 18 Mar 2021 20:40:18 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:ed59:df3e:7ad8:c600])
        by smtp.googlemail.com with ESMTPSA id 19sm3344621qkv.95.2021.03.18.20.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 20:40:18 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH v5 2/2] crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init
Date:   Thu, 18 Mar 2021 23:40:00 -0400
Message-Id: <20210319034001.435117-3-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319034001.435117-1-ztong0001@gmail.com>
References: <YFOLPn31KF7bW6T/@silpixa00400314>
 <20210319034001.435117-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ADF_STATUS_PF_RUNNING is (only) used and checked by adf_vf2pf_shutdown()
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
Fixes: 25c6ffb249f6 ("crypto: qat - check if PF is running")
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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

