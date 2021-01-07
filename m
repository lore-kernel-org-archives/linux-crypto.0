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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8080C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72375225AC
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Jan 2021 12:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbhAGM16 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Jan 2021 07:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbhAGM15 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Jan 2021 07:27:57 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC84C0612F5;
        Thu,  7 Jan 2021 04:27:17 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c12so3750995pfo.10;
        Thu, 07 Jan 2021 04:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qu9jTq4Mhds1PLReGFI6BuQWWjoITkJw1sqRT7XAn7M=;
        b=QC08WxFbW+qIztVxBinWE5vs7IHHEhE3+M6tuDRvQi69LJbJ6fap5aP6NxviDUZ0Fv
         NOYboVzE5XO/yPpV1qHjKJMTd0JsECGmnj14cr6L3G39uy9Pjq5P19dNdg8wMtr8i3pt
         dUkrZB/iH0b2l84GCJyEKnaAJrykR6bRNhJEKV/3MOo1JRovquSz4KiMtuW5pzQT7iSg
         /EDg45nLnuGsvTelzscW1WfpG1eXUsifA/ZD0Hto17AEq4yMv3rQsg1JoSsLiTDLLv2o
         3JEncImGFvwY3tXhhD1XSHIdxY6+ltkiQ/C/B4njyP41JG5Fk6SINZ5gJTQl88Zi171p
         bwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qu9jTq4Mhds1PLReGFI6BuQWWjoITkJw1sqRT7XAn7M=;
        b=uRp7syZABtuL/M2TY0n+cAIPopxMhxiJTFToT/yEDe3ALAKuve+cuN/isMWBp8J/zI
         k4RpbdDwt8pcrEGpMOZR4rGjhz8v+fvGApK40sIx98GYP805qvX7TqVE5vb6Lna0SOyo
         tis+xJfSVy7udQcJVPtblLHP1mjqmtcnpZMPcXwrSGALA5iv0BXmklcu4MBLgQZDvgrT
         v7oeq1MDW04zqw+bcV6MX1reET37Jb5+tAu6Z1scKq9WlbgOQrXc9VGNTdyg7ug+K5FO
         dCkLYLBOWbHphJxOzuLhU3ZvBamy0xmY1zObhz4ewjY5XckNTur2pV8udiuOowowayRF
         FhKw==
X-Gm-Message-State: AOAM532o3goJbxMaLqN1LrxX/mvqpttkZ26Z26qIl0O+DxaSYOG2bwfj
        hgB3Wjq5O4f3ZRf6j2VPBbM=
X-Google-Smtp-Source: ABdhPJzmtC0ZYYtJdJncyLo9jUcCmBc8rPOUk0rIqkXUz5Z6T+Z47y0DxRXaN43On1iH8mzHPPPjJg==
X-Received: by 2002:a63:2ccf:: with SMTP id s198mr1638747pgs.30.1610022436883;
        Thu, 07 Jan 2021 04:27:16 -0800 (PST)
Received: from localhost.localdomain ([49.207.207.140])
        by smtp.gmail.com with ESMTPSA id x28sm5860403pff.182.2021.01.07.04.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 04:27:16 -0800 (PST)
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
Subject: [PATCH v2 01/19] crypto: amcc: convert tasklets to use new tasklet_setup() API
Date:   Thu,  7 Jan 2021 17:56:28 +0530
Message-Id: <20210107122646.16055-2-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107122646.16055-1-allen.lkml@gmail.com>
References: <20210107122646.16055-1-allen.lkml@gmail.com>
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

