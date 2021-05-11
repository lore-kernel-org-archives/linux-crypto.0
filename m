Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318FEC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F35BB61159
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhEKNaw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 09:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKNaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 09:30:52 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348ADC061760
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:45 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id y9so25118699ljn.6
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X1K7rwa/77HQwchJ9fJE8GZcfgMpgknk71cF9VgYv1o=;
        b=xlDW7nnBqI5/8ogVeHOoccWHafRm5Ctg21qga+VPtpuLBc1DC9fDMT06++MoURMO0S
         x8jpIB4SQELDG+KXL1D1VwmN2WMSc7RpTbjWRf80bRQO55PqcfU1xFxw9AU3J7WgP2XH
         1a39u8xDD9erSER3QGkNoSv4zmJh8nWb9tXsUgqz4cGoswbGKW89AhvW9hcxnNEe7j4u
         6MvmgLrgbnAFFklDCDDURq0MrYxybnJastgpriYTzT/SQPE2YYIqtt1NkBROGwV30Mof
         Fe9fV3C9muEOkAhXZ770mBnJbeyhBY4RvDW1ssftvOdV4Y5pDLAKtSlSgIdTOlvxZhuQ
         2vpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X1K7rwa/77HQwchJ9fJE8GZcfgMpgknk71cF9VgYv1o=;
        b=DjIoI7hUvIzX2wWuByVtkb7/BsuhVVzhStY44t4cUl5o240WnWuXOoI6Xoa+msT1KN
         JmlHKwyrvHe43vpnROBQWHqpISagYSbW56Dd8+LQm2XLnRTif1n3dXW8DMpAb9tfOd8T
         KXM/Cuvm2Z1JJ//IhzM51aKDxA/mEL/xf1l98JG+KL4hyaCofjj7chKXtD3sphXQ3iot
         y0YJzeLRkQjpIhhMz9AjqHXC/APVANEmvejfNFbZzLdFPydLayKFcy3RLJK7bszU14hu
         bWOmS6HQGSMjUQV0EakY8IOUsY+cqd2X2jJfnKldNT+X9drbREssxBlgezRFugFNWHAB
         o1QQ==
X-Gm-Message-State: AOAM532wklYc/9+Cvxg4FdmP0adNiABQVaEjrQxrqqguXgApw7Nvkn9z
        QUH57MrIacRemQj+q6Gxu0b1Aw==
X-Google-Smtp-Source: ABdhPJyDmnwdL16PDw0PUP1YKPwqTMJj0o0sNMewcKSf3Pt55F025LCcWVAbPYWYg7y8/AGiPq9SKw==
X-Received: by 2002:a05:651c:485:: with SMTP id s5mr24967388ljc.364.1620739783661;
        Tue, 11 May 2021 06:29:43 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m4sm3699740ljc.20.2021.05.11.06.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:29:43 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Deepak Saxena <dsaxena@plexity.net>
Cc:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 5/5] hw_random: ixp4xx: Add OF support
Date:   Tue, 11 May 2021 15:29:28 +0200
Message-Id: <20210511132928.814697-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511132928.814697-1-linus.walleij@linaro.org>
References: <20210511132928.814697-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This makes the hardware random number generator found in
the IXP46x SoCs probe from the device tree.

Cc: Deepak Saxena <dsaxena@plexity.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
The idea is to apply this through the ARM SoC tree along
with other IXP4xx refactorings.
Please tell me if you prefer another solution.
---
 drivers/char/hw_random/ixp4xx-rng.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/char/hw_random/ixp4xx-rng.c b/drivers/char/hw_random/ixp4xx-rng.c
index 8b59aeefd4a4..188854dd16a9 100644
--- a/drivers/char/hw_random/ixp4xx-rng.c
+++ b/drivers/char/hw_random/ixp4xx-rng.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/hw_random.h>
+#include <linux/of.h>
 #include <linux/soc/ixp4xx/cpu.h>
 
 #include <asm/io.h>
@@ -55,9 +56,18 @@ static int ixp4xx_rng_probe(struct platform_device *pdev)
 	return devm_hwrng_register(dev, &ixp4xx_rng_ops);
 }
 
+static const struct of_device_id ixp4xx_rng_of_match[] = {
+	{
+		.compatible = "intel,ixp46x-rng",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, ixp4xx_rng_of_match);
+
 static struct platform_driver ixp4xx_rng_driver = {
 	.driver = {
 		.name = "ixp4xx-hwrandom",
+		.of_match_table = ixp4xx_rng_of_match,
 	},
 	.probe = ixp4xx_rng_probe,
 };
-- 
2.30.2

