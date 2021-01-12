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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBE1C433E9
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF3F22D6D
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Jan 2021 01:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbhALBr5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbhALBr5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Jan 2021 20:47:57 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDE2C061786;
        Mon, 11 Jan 2021 17:47:16 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id x12so508554plr.10;
        Mon, 11 Jan 2021 17:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qu9jTq4Mhds1PLReGFI6BuQWWjoITkJw1sqRT7XAn7M=;
        b=H63y7TytVzVANKOVA7sdCA6vVgUHNtSjJ0nN8hlQEHDbjOF4g5m8MJRGfQkutbNkX0
         QqecOfP6JEf05JZm1qT88AeNGR2IleB6D0vIhRITllMtZ44HM5F3SbrJlWL0phqLac3J
         3q6Wz5eIKCj5xza64orBo519XLAkn0icn82vDvA/tKr9AfQYigPbbNNTMgDF2Wk38Bjl
         ZYKEGf+1pjClpaJTY3CbQAb3YW2Lzvc1IXAThCVLdrJ07knO+CP5u9k2ssAFWC95H36o
         sKJZj3sKgDIvwYyrq9NQR0yx/wUmlS7zN9d0wcjrKifHQDvv+nOMQ2sEJUV+IEIsJQFR
         Ct4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qu9jTq4Mhds1PLReGFI6BuQWWjoITkJw1sqRT7XAn7M=;
        b=bstXdBcqS4xe37rEP2dK6faDp2udKwpVQ5MYbwNBAKEuzkleKH1kr09G1X2w09DBTa
         Sxd7DGvBLhApEDeQYe6VnV9OMs93mkLNZ/ocpJ3OMGhpcd+pC+AdYPaIJyfFhA40ZG3a
         n4a1cJi6vbqXdr//cnFa2v9PZp+ZgaNrzwgID1ukTc47S5P0+pVv7l+STXtCslF7p4bT
         ag7yOgdxJsyXFUq2InoUmDV+0or/JrCeblA11DO+i9ujbI44VVthuhiZfpvLxurt+Fsr
         rTPYPXNRwJo2pKqE1ttyhb/bK4FL/LKCfVByGtAGqfNJchqcS4k6HJl/WqjjUWnNEfhW
         EZvw==
X-Gm-Message-State: AOAM533aheZ5k+vd8AEJpjHB1jVq561siODyPN0B5zAwdExSPgfH43mx
        GneB6nCofU/MDv3pwlqSs+c=
X-Google-Smtp-Source: ABdhPJwwk0s1+U0eEIms8qHWr9weNGl7FRq+v0mFtEWayniloff6bmrtW7bVMClYALWDK/at4Reeqw==
X-Received: by 2002:a17:90b:3907:: with SMTP id ob7mr218173pjb.18.1610416036496;
        Mon, 11 Jan 2021 17:47:16 -0800 (PST)
Received: from localhost.localdomain ([49.207.194.207])
        by smtp.gmail.com with ESMTPSA id 14sm904376pfy.55.2021.01.11.17.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 17:47:15 -0800 (PST)
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
Subject: [PATCH v3 01/19] crypto: amcc: convert tasklets to use new tasklet_setup() API
Date:   Tue, 12 Jan 2021 07:16:32 +0530
Message-Id: <20210112014650.10887-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112014650.10887-1-allen.lkml@gmail.com>
References: <20210112014650.10887-1-allen.lkml@gmail.com>
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
 drivers/crypto/amcc/crypto4xx_core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8d1b918a0533..0e13430a5b9b 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1072,9 +1072,9 @@ static void crypto4xx_unregister_alg(struct crypto4xx_device *sec_dev)
 	}
 }
 
-static void crypto4xx_bh_tasklet_cb(unsigned long data)
+static void crypto4xx_bh_tasklet_cb(struct tasklet_struct *t)
 {
-	struct device *dev = (struct device *)data;
+	struct device *dev = from_tasklet(dev, t, tasklet);
 	struct crypto4xx_core_device *core_dev = dev_get_drvdata(dev);
 	struct pd_uinfo *pd_uinfo;
 	struct ce_pd *pd;
@@ -1452,8 +1452,7 @@ static int crypto4xx_probe(struct platform_device *ofdev)
 		goto err_build_sdr;
 
 	/* Init tasklet for bottom half processing */
-	tasklet_init(&core_dev->tasklet, crypto4xx_bh_tasklet_cb,
-		     (unsigned long) dev);
+	tasklet_setup(&core_dev->tasklet, crypto4xx_bh_tasklet_cb);
 
 	core_dev->dev->ce_base = of_iomap(ofdev->dev.of_node, 0);
 	if (!core_dev->dev->ce_base) {
-- 
2.25.1

