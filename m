Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7939BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 19:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F7861278
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Sep 2021 19:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbhI3TOh (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Sep 2021 15:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhI3TOh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Sep 2021 15:14:37 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F63C06176A
        for <linux-crypto@vger.kernel.org>; Thu, 30 Sep 2021 12:12:53 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id i6-20020a1c3b06000000b0030d05169e9bso7110182wma.4
        for <linux-crypto@vger.kernel.org>; Thu, 30 Sep 2021 12:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3dpOnDXlgJcFTCuS+F/+JL7imW1C4nTJ31Epoj0e+I=;
        b=bwAS4qXyVy5lrCFNe3bp3qWlLe4NhL1c36wauGEWB6DyD18i4Ss7dObFv4YdMqDGZW
         skhpVHNiYGzPXclorFKhF9zPBjfhDnzW/qpNsANXsPMKKYLxc/XviSoH+sJAiBkMzdgI
         wKEx5UKAxPCIL8hdltmLbcOlHDNP+AQ4PpzueOtP9j4vx22We2l03/wwpCea8a9o0T2V
         FYwNPUkk8C7WfQan6eDbF8HI4PDVuZ33RSefMmtiPDFQFj+l6izgK1Uz42X2AnQ0QTli
         O0xEhuaqx4DgcH5xDKKHJE/F5qeaUOit6yCZTajclWlYqEC+pG3Tr1nZweP/b/RMnrEw
         1vWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y3dpOnDXlgJcFTCuS+F/+JL7imW1C4nTJ31Epoj0e+I=;
        b=Zjrg2pMF2o6FgNZcc8nERqvoBxB0aShuOfjnvczL+o/Ca072HR9azm3ejjscn/N1L1
         QZUX3/5juaOjD15kXwO1R1ClOtvUHa28GkKOXccCKpT8AWpSJ38lgSNamqCwinzal/mw
         KvnnTeXel4S3MmqrBNVuqAyOhsOTdlD/edLtUenSw3ZyTUNzqWAcCCqED5C/Alh7C93E
         I+OQpgvp4MaZzwo6vu5XFZchAHzKF6mtOYWJMP5MnPVP1aSmRAX/W0tLtQYgmL+YQojc
         EPS3HZv/yeUIvEjg2EEPcmpzx4ZAsIEoP7coT82bkNZBpS3dsPpUfkc7W8aQRShtN8eB
         MAaA==
X-Gm-Message-State: AOAM533dt7S1zhZkNo0InosXqFvpDjKckgepEsvf46xgcd7PgXL5gZNR
        6I7cRXBVpRaLCyQHt8wW2bzb+g==
X-Google-Smtp-Source: ABdhPJwrtPqllvSZg5XcCvZ2XXZZaUirsC+ZKZwYlgp++pji+2vnfiAHalOo1fEL4a19NSKpsLasvA==
X-Received: by 2002:a05:600c:3506:: with SMTP id h6mr782894wmq.62.1633029172329;
        Thu, 30 Sep 2021 12:12:52 -0700 (PDT)
Received: from blmsp.lan ([2a02:2454:3e6:c900::97e])
        by smtp.gmail.com with ESMTPSA id l11sm4813809wms.45.2021.09.30.12.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 12:12:52 -0700 (PDT)
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
Cc:     linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Markus Schneider-Pargmann <msp@baylibre.com>
Subject: [PATCH] hwrng: mediatek - Force runtime pm ops for sleep ops
Date:   Thu, 30 Sep 2021 21:12:42 +0200
Message-Id: <20210930191242.2542315-1-msp@baylibre.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently mtk_rng_runtime_suspend/resume is called for both runtime pm
and system sleep operations.

This is wrong as these should only be runtime ops as the name already
suggests. Currently freezing the system will lead to a call to
mtk_rng_runtime_suspend even if the device currently isn't active. This
leads to a clock warning because it is disabled/unprepared although it
isn't enabled/prepared currently.

This patch fixes this by only setting the runtime pm ops and forces to
call the runtime pm ops from the system sleep ops as well if active but
not otherwise.

Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
---
 drivers/char/hw_random/mtk-rng.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index 8ad7b515a51b..6c00ea008555 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -166,8 +166,13 @@ static int mtk_rng_runtime_resume(struct device *dev)
 	return mtk_rng_init(&priv->rng);
 }
 
-static UNIVERSAL_DEV_PM_OPS(mtk_rng_pm_ops, mtk_rng_runtime_suspend,
-			    mtk_rng_runtime_resume, NULL);
+static const struct dev_pm_ops mtk_rng_pm_ops = {
+	SET_RUNTIME_PM_OPS(mtk_rng_runtime_suspend,
+			   mtk_rng_runtime_resume, NULL)
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
+};
+
 #define MTK_RNG_PM_OPS (&mtk_rng_pm_ops)
 #else	/* CONFIG_PM */
 #define MTK_RNG_PM_OPS NULL
-- 
2.33.0

