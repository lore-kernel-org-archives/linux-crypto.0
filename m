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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E49C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:41:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F36BD64DE2
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Mar 2021 03:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhCSDks (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233569AbhCSDkQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 23:40:16 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50DAC06174A;
        Thu, 18 Mar 2021 20:40:15 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id c3so1588469qkc.5;
        Thu, 18 Mar 2021 20:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=R0Wyu6JtDk3sKuQzQotniaU+SO/8poiFBmzfwHY3Ipo=;
        b=KfpFzhx+5t/tF8GxycVacXrOtQ+6S2S2c89rlcSftJFhWJZFXW5z+GebDccZYUkT3Z
         MtO8pE1SAUFKKoTVzIAubCeVubKp9dPFTD/GygDNgCaPP/zapEMgk+GBTBrshnmF/qZy
         qskpVsZ979s8nsqZ20rnJLiY9S3wTIBC2ss5hxupLXnq7yx6zjmqbm5xqJ8WkGYx+XLK
         oKU987fXs3JVbp2/9xrpo/0dJOHzK1CM8kCRcxW40Q1L6oZjWlwhNAAQP1tff3MDi0mK
         wyJYZtwKYDw2eM54xuJ/bZBc51Evc5gN+cgSME9Q5prbSQjVPbQCG80kjSVtHq0mGlf6
         9c6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R0Wyu6JtDk3sKuQzQotniaU+SO/8poiFBmzfwHY3Ipo=;
        b=It1z6X9eDxxKw4QVfGoVFuTQzh42HcKk3YQkvwQJ/jXA8R0mFiNZAFI1Y0xI/ypqvD
         qHKAEq2uZfkjpPJUzA5zRGsPjpkJfF+0PPGq0T1QwsJXTBfppP5Zsjcaau2aI9g7a2ZS
         PrRQKk5dIycdHDRzM4+V0GjH469YUzKlF8SqIOPqNTNv5SQkGjcJQh2vpF5wGURhnIcI
         STIQbvvOWktqlqxb3XC2aCoMr44kbpTwcPEpAUx3RCXfrc0hMLbZj6Vn2T+LbUXXdp5p
         mVSKKJr71A6bN1qLaf2nt6kDAV+3l95sX0cjiCCL5zJ6C6XsCu33JKhSrZZLCnVsQE48
         +GnQ==
X-Gm-Message-State: AOAM5322pOx3wSZAUg2s8/WFbUO80rXXlqibBFMDDXpPVH+t10t6Y8pa
        TcCrb8U+A81+X2Gbd7uSGu0=
X-Google-Smtp-Source: ABdhPJzOdJoftYPx1xIp9ZEJtBHcdQPASttN4IrkgoT7XByaaVpXiqe06Y/u/sOdtq/vcNAKWl/Fgw==
X-Received: by 2002:a37:a282:: with SMTP id l124mr7467658qke.37.1616125214990;
        Thu, 18 Mar 2021 20:40:14 -0700 (PDT)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:ed59:df3e:7ad8:c600])
        by smtp.googlemail.com with ESMTPSA id 19sm3344621qkv.95.2021.03.18.20.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 20:40:14 -0700 (PDT)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/2] crypto: qat - don't release uninitialized resources
Date:   Thu, 18 Mar 2021 23:39:59 -0400
Message-Id: <20210319034001.435117-2-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210319034001.435117-1-ztong0001@gmail.com>
References: <YFOLPn31KF7bW6T/@silpixa00400314>
 <20210319034001.435117-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

adf_vf_isr_resource_alloc() is not unwinding correctly when error
happens and it want to release uninitialized resources.
To fix this, only release initialized resources.

[    1.792845] Trying to free already-free IRQ 11
[    1.793091] WARNING: CPU: 0 PID: 182 at kernel/irq/manage.c:1821 free_irq+0x202/0x380
[    1.801340] Call Trace:
[    1.801477]  adf_vf_isr_resource_free+0x32/0xb0 [intel_qat]
[    1.801785]  adf_vf_isr_resource_alloc+0x14d/0x150 [intel_qat]
[    1.802105]  adf_dev_init+0xba/0x140 [intel_qat]

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Fixes: dd0f368398ea ("crypto: qat - Add qat dh895xcc VF driver")
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
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

