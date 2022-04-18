Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A1DC3525B
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 12:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbiDRMjx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 08:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbiDRMgw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 08:36:52 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F408B22293
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 05:27:43 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-e2fa360f6dso14035533fac.2
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 05:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oonWYiLK2dbr9KUWpkKrJkyq8BPovFZPrZvJXi+R02g=;
        b=BOEBa7eM1g9ev4uPJulwlWQRrcF/Jc6ZJ/DZHuPC9W9p7gKuZHCT3/9cGOkUZsO/ki
         1kr9gx5klCV2VtiFA3UsTvjiJo/H43qWP+SLIeUirmhAM8TaNTXHAIPxvYAvLjWMqJsu
         OFJp73ikJw/FBmlUfqKsN42MWbBSe9hgmSw1IIfCg8GWUOsaeWDLqSLiHjpSmN3Epx+J
         iz9gzpRlABE3GbvBciXUMbzALgUSfXb86GvxSYMleRzRXAwFQ3ZtxWnmdzd6zZCNjMQs
         PQRpgEsNzTZxz5Ym9bDpHQwdVxJyLKSvPqLTQ/HJD94ZA3uVNDDnC/m70ylYIi4d1WAi
         IJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oonWYiLK2dbr9KUWpkKrJkyq8BPovFZPrZvJXi+R02g=;
        b=U4wTVJjPu2O2mbbpPHcyJcaY4nFoT2N+8gSrhWqRxxctU6zsXpkuCKgy00jMLeO0Cg
         EiDdntgFggNSP6q3WFQjX+hddQ3zlf6kaggwAzzD7Wsq2vp5Vr4L4D31AE3fvjJsyuXO
         pVc2NnnrLAlLBffvkIMWjlu9HmtLlK/6Od1IDwy8wpBLq8gJ/G1cy15AdxpZ2aEh+c9k
         m0rDInq+XQUor6RoYfmvVPfPvy7Wkf353WkCG0/xY0omU9gbCQre88CGwpYXRW1XiG8X
         TMI6i/G55kGE666TWqJOpQjsuYIprVmlGXUq+hyUdvCSxTkJR0xAn31mGoiAph7Y12K0
         yKCw==
X-Gm-Message-State: AOAM530Gmnxlhyef+9ROu66NVSy/pQJEsqM6z/07TX2Ab1D+AiK0pR50
        UwGLhT8gX7dG0l0hgDyVptYtfsQVlf0=
X-Google-Smtp-Source: ABdhPJy2P3GkwBDEdWAJizYHixknmYPabq4GT0Ql7e0kyQKfPqfQRWav5+1Eo/n2zqr3Q9XE9KxaZA==
X-Received: by 2002:a05:6870:d28d:b0:da:b3f:2b51 with SMTP id d13-20020a056870d28d00b000da0b3f2b51mr5741611oae.240.1650284862902;
        Mon, 18 Apr 2022 05:27:42 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:5307:398a:5694:27c])
        by smtp.gmail.com with ESMTPSA id k15-20020a4a2a0f000000b0033a34a057c8sm1712684oof.11.2022.04.18.05.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 05:27:42 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     horia.geanta@nxp.com, gaurav.jain@nxp.com, V.Sethi@nxp.com,
        linux-crypto@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: [PATCH v3] crypto: caam - fix i.MX6SX entropy delay value
Date:   Mon, 18 Apr 2022 09:27:28 -0300
Message-Id: <20220418122728.203919-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
in HRWNG") the following CAAM errors can be seen on i.MX6SX:

caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
hwrng: no data available
caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error

This error is due to an incorrect entropy delay for i.MX6SX.

Fix it by increasing the minimum entropy delay for i.MX6SX
as done in U-Boot:
https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/

Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG") 
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v2:
- Added Fixes tag. (Horia)

Change since v1:
- Align the fix with U-Boot.

 drivers/crypto/caam/ctrl.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..c515c20442d5 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -648,6 +648,8 @@ static int caam_probe(struct platform_device *pdev)
 			return ret;
 	}
 
+	if (of_machine_is_compatible("fsl,imx6sx"))
+		ent_delay = 12000;
 
 	/* Get configuration properties from device tree */
 	/* First, get register page */
@@ -871,6 +873,15 @@ static int caam_probe(struct platform_device *pdev)
 			 */
 			ret = instantiate_rng(dev, inst_handles,
 					      gen_sk);
+			/*
+			 * Entropy delay is calculated via self-test method.
+			 * Self-test is run across different voltages and
+			 * temperatures.
+			 * If worst case value for ent_dly is identified,
+			 * the loop can be skipped for that platform.
+			 */
+			if (of_machine_is_compatible("fsl,imx6sx"))
+				break;
 			if (ret == -EAGAIN)
 				/*
 				 * if here, the loop will rerun,
-- 
2.25.1

