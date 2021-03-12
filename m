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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD581C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90AFF6500F
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 16:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhCLQWx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbhCLQW2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 11:22:28 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5C2C061574;
        Fri, 12 Mar 2021 08:22:27 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id s7so24791789qkg.4;
        Fri, 12 Mar 2021 08:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QhgfXHm7JMNLxaGuMOt0UB9F9jq+pEo0UurX510z2yw=;
        b=a554od4MmkxDBz6mnnQ7pc6s8c3zamHX/uMv5RerZWchHj2euuxQO2bfDuHxrussr5
         S12+gRtuzm400BMK7mGBj2ADze+QUqOALzA1/+9cI2FMEvg6drmEYY4crnLMuPtWxioo
         fNOASvSdIEWYk4TIRP1frJtk8HflVXKxn+jf5yCZzXMHMq96dmPER2APbnf9QV/P8wWR
         Zx3ztAlrepngNSm9Od6SYnN5+IOwVOQ37v6vQ/RagCKkEqX6UDQuilJtD9QEUIX+4qpC
         FB2jOQKjpnapPWW8D1Uql4hSzZsNQ3szKB1+fvt3+m9cXtczPWer2bY1KVdgBhPEH37X
         gO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QhgfXHm7JMNLxaGuMOt0UB9F9jq+pEo0UurX510z2yw=;
        b=LLSWI/hqM3qcuh0d2Rc5SnxZ0UD4yPUqhwS1ELu8BNZSM2BQzCqbQNB50c56g5UtfE
         C+da6WcD59EhoSABtF11A0guFFUxzDh9L32FUmPnZ0m6LZvFB2Y3L/rTL0QUhsWkorx9
         uhImEKiezMYm0IiDMyS7K8lIAhiAw8ed3aI7+KTUK4pDSPerjx25U+OHqdQs16S04gRl
         8nJEeP92e9TlXvtMI2Xhrbg9oBEPqGYLgpMNK1oQsuTGgjhyXqVPWTmF7c43BJlaSbqx
         7eNe66N3r2yXGhGMRTj/EGuW/0bnR0Fgfl/JJn7YpjzGln+PdeVe0sag9+24RkPOg5ne
         qbpQ==
X-Gm-Message-State: AOAM531vPsScKmawJiuiYYeuTGHstb943vLiAHZbod/wdk4K2wdJzTGq
        5ZHDK0rmBzXkVErkVoYRyDo=
X-Google-Smtp-Source: ABdhPJyOJ4hCCgtG0z6pd84htCzVThHBgSo34eElDCeppOX4/Bs3rlIoTHFIgumDQGO13xiomEDg2g==
X-Received: by 2002:a37:a8c7:: with SMTP id r190mr12268501qke.126.1615566147108;
        Fri, 12 Mar 2021 08:22:27 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b9e0:c84:da81:d749])
        by smtp.googlemail.com with ESMTPSA id e15sm4178623qti.79.2021.03.12.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:22:26 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tong Zhang <ztong0001@gmail.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] crypto: qat - dont release uninitialized resources
Date:   Fri, 12 Mar 2021 11:22:02 -0500
Message-Id: <20210312162203.2416149-2-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210312162203.2416149-1-ztong0001@gmail.com>
References: <20210312162203.2416149-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

adf_vf_isr_resource_alloc() is not unwinding correctly when error
happens and it trys to release uninitialized resources.
To fix this, only release initialized resources.

[    1.792845] Trying to free already-free IRQ 11
[    1.793091] WARNING: CPU: 0 PID: 182 at kernel/irq/manage.c:1821 free_irq+0x202/0x380
[    1.801340] Call Trace:
[    1.801477]  adf_vf_isr_resource_free+0x32/0xb0 [intel_qat]
[    1.801785]  adf_vf_isr_resource_alloc+0x14d/0x150 [intel_qat]
[    1.802105]  adf_dev_init+0xba/0x140 [intel_qat]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 38d316a42ba6..888388acb6bd 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -261,17 +261,26 @@ int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 		goto err_out;
 
 	if (adf_setup_pf2vf_bh(accel_dev))
-		goto err_out;
+		goto err_disable_msi;
 
 	if (adf_setup_bh(accel_dev))
-		goto err_out;
+		goto err_cleanup_pf2vf_bh;
 
 	if (adf_request_msi_irq(accel_dev))
-		goto err_out;
+		goto err_cleanup_bh;
 
 	return 0;
+
+err_cleanup_bh:
+	adf_cleanup_bh(accel_dev);
+
+err_cleanup_pf2vf_bh:
+	adf_cleanup_pf2vf_bh(accel_dev);
+
+err_disable_msi:
+	adf_disable_msi(accel_dev);
+
 err_out:
-	adf_vf_isr_resource_free(accel_dev);
 	return -EFAULT;
 }
 EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);
-- 
2.25.1

