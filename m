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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1627C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 14:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE40F64FD6
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Mar 2021 14:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbhCLOTa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Mar 2021 09:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhCLOTY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Mar 2021 09:19:24 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE24C061574;
        Fri, 12 Mar 2021 06:19:24 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id j7so3815450qtx.5;
        Fri, 12 Mar 2021 06:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=J1fY4blEKmb8305im2jPfcvAwNmR+NC2lQDS8t/p8Zw=;
        b=fgGKvTuhi+859ctGHAnilch9Dvge9MH9m5KGNAlx+BngiT6boIp2M+3VuCf9G++nmb
         /Vgdm0WIOj1aovZBqIn4AZo1kkDizI0YtnlO/ChQDewEwJZN6ogwNkCA/g7YpNfXUo+T
         FAQDkwu2TNJMbAlz7THOITtyXaYP34RLF04jeI7EIp8zTIyocPSY5uWe8e2y/OGsPWDq
         odTVkJj1Lia9HiRvPK+vYim34H4EBzIdigOGvjZMZrt7lzG5magnWNerscsTC6RTtpSa
         LraNg44/5lxi96z+vvqKObNNR/o33t+4Bvma0GCCKkpbiaxiDfuJLjscS2pMT488Y9oX
         KtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J1fY4blEKmb8305im2jPfcvAwNmR+NC2lQDS8t/p8Zw=;
        b=Qphbja8tAucxfZrEjawWy16olxWsiz9gsDReLxitUtE/GJ7GwUqgKlUAG/BHqJvHpH
         roEAVIZnZYg1v6clabITpQoC1Td4yTFm0ti3MvCXHiI+PmQLYD4beU8ay1XsECO8BUeU
         QbUfqB8WesZE6t6BD1RcLxNxeus9cRYz0oVQJRWmh/FN1SGpVhIV8mLO6MhtYjenCmfe
         1qDgV8fT2Qls9jjHS8N/VhghvvdYT7+bGR6B1hiEj6sfPhKE+7auG9GT8VmxQcgxGW7l
         KpgrRJbUhb+6pyjUWYuBBdHcWyeGqI8gn6LRJZHB7ARdcE88G5d9ROXQ7al1wurQ9Otn
         9t6w==
X-Gm-Message-State: AOAM530JdB5xx0FCM1BF2jqwbrdjk6Hd9T/wtr98NewjW0L8zOK8Yx1K
        HqVbkjYebM72viRSxboXJTU=
X-Google-Smtp-Source: ABdhPJwUtk/b0OpYs5E722IjXrs1AummkMYz7yOxA0R3elfirHFxxNOZWkWVIaL8V2N3yqwJT8SQPQ==
X-Received: by 2002:a05:622a:293:: with SMTP id z19mr11617426qtw.309.1615558763683;
        Fri, 12 Mar 2021 06:19:23 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:b9e0:c84:da81:d749])
        by smtp.googlemail.com with ESMTPSA id v2sm3979478qti.94.2021.03.12.06.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:19:23 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tong Zhang <ztong0001@gmail.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/2] crypto: qat - dont release uninitialized resources
Date:   Fri, 12 Mar 2021 09:19:07 -0500
Message-Id: <20210312141908.2388121-2-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210312141908.2388121-1-ztong0001@gmail.com>
References: <20210312141908.2388121-1-ztong0001@gmail.com>
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

