Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0003C433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Apr 2022 13:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiDPN5a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Apr 2022 09:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiDPN53 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Apr 2022 09:57:29 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D16511A2D
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 06:54:57 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-de3ca1efbaso10294028fac.9
        for <linux-crypto@vger.kernel.org>; Sat, 16 Apr 2022 06:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5b19KHtPhP/9hGkyZMw7Ki/2FQK5FSTjZHzlUEDJ8fo=;
        b=SvfmfHWfpjc0T6UKg7kbOlqlrJY7pG0PNZPTwpoUmxXrLUdbmjWM6IKv4z83PzP8W1
         LClRHRp82Fg0xaVztX2N4o43ALuNmtn0k95keYQTFJjYtQN9Of2udP+vRQMuxRZlN654
         TaKABFCQsZiDUj1QodOYpUFPPfaMEvw2vNajQhFYSZ1DJEvCOAmo8G6riXtFui6GPMrI
         6ixl6WruoFoIzYN2W/d/HGZOorJ7JTgDncnv2WGk8U65FIuXbZcL0iGPrnkZvGk+4Z7Y
         QRlyYX/wp9jL5963ZqkpTfwif2sWXbF/26Yqhf4ZywyWj/hvj0XLqTKr22geSFwuOXAJ
         hQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5b19KHtPhP/9hGkyZMw7Ki/2FQK5FSTjZHzlUEDJ8fo=;
        b=YBi9NxNgkRZ+peeRCpoTw6LE65GQwPf2Za/vFaBxO7uvpr4FI2/os9aCa4MKnnoUJ4
         X6wjGI8vday9XMgusoC9qkbG/cnVqyTpYanfbUzldak7O0l0pbx2aUIDJswKXIcz6sjz
         8TMZ+wyEd5ClnRDyed5PMYae0K+ASWP9BYkTgeIlnlcFTFoxxtAXSLLnMj1RaLap6xz4
         kB0CFTElkrR8GKVMMpmacWzq6fg16neVAcRu2clDl7FesP7ioUThryvB3ECfChj5fd/c
         0jPOrDsbeeWKjPzAiOekOai4HsnEHfCphRs7jhQygavSWMiEXdH1mmqwCCnxl2u3QZwC
         /OUw==
X-Gm-Message-State: AOAM532RUZ0/z3fvxQy4hqlY1QTTgWJSl5vTqMxEpdsWp0LlmlyD3hOG
        FUHByBKBEGLiD0txhSd6/LY=
X-Google-Smtp-Source: ABdhPJwxHBtamfeb3PttJU5F1NANhIKRz83c41MuzLlDboVWInDBlJ3eRQKnc4eZj9Ns/bKQJirbwg==
X-Received: by 2002:a05:6870:2498:b0:e5:9555:2546 with SMTP id s24-20020a056870249800b000e595552546mr1299407oaq.292.1650117296790;
        Sat, 16 Apr 2022 06:54:56 -0700 (PDT)
Received: from localhost.localdomain ([2804:431:d77e:d8:f62d:d99e:5077:44f7])
        by smtp.gmail.com with ESMTPSA id w25-20020a9d6759000000b005e6b6424611sm2095976otm.50.2022.04.16.06.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Apr 2022 06:54:56 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     horia.geanta@nxp.com, gaurav.jain@nxp.com, V.Sethi@nxp.com,
        linux-crypto@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: [PATCH v2] crypto: caam - fix i.MX6SX entropy delay value
Date:   Sat, 16 Apr 2022 10:54:12 -0300
Message-Id: <20220416135412.4109213-1-festevam@gmail.com>
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
...

This error is due to an incorrect entropy delay for i.MX6SX.

Fix it by increasing the minimum entropy delay for i.MX6SX
as done in U-Boot:
https://patchwork.ozlabs.org/project/uboot/patch/20220415111049.2565744-1-gaurav.jain@nxp.com/

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
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

