Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B2BC64EBC
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D3BB246D1
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ietn0vzu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgKSPwl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbgKSPwk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 10:52:40 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B5C0613CF
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:39 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id g17so4681058qts.5
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WK7dbS/2WIcf7lppGbM/SVGTBQiYrXQBAamVJT++jdI=;
        b=Ietn0vzuyHymF+fGLpMED5gPejOJx5P9PsMQ9QZfIf/wzyM1FEyilGjb3Dq1VORSyu
         IcqI45ReNY1xEI/igFPRVwVYyhZ8mdbCKPvufR3ia25oIq2M9rB9vjloVAWzsd83//2P
         XF1VGcmFA2KVWMgvGLfHGSaBBgn0NiLfpDBO9SnALlYew2c5xzQVv2I7bO+VFyj6pfGI
         CZ6v49PaCRj2t4atGj5HcPptxxaunnlvtR5YnUF3Tl1QPDak7R/+0RafesR9OKED/aX5
         92VThVXyQyW79fWALN/m0wrLttVwkmsh4dvP7mJ2vwlcTvfTbLIbXPqh4PRq2rQ/crr9
         PlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WK7dbS/2WIcf7lppGbM/SVGTBQiYrXQBAamVJT++jdI=;
        b=NOQmxNA/KHHFyaV1AJKuCc1TNpGcuOVjHWvDgnRG4MiTgSM0iL+2CDY3b9eLll2n4E
         dYiC0Abbwz5Pr524LzTT1/axpBzbYs1E/Qyl6n2bicBt/hENCMPdvw7NQKghDtXuThce
         smL059Fm90QNo++TuU316KLkNXxIap1dE0QrFM49o+y9Jotn+dVvxT/JveJFMIuagYoi
         ozw9S+TJvg83RG1TvS9AO5gmcuv+x3SGwrDlILD/DN4qrRPTOYL8uS7jM31CTztm5IxR
         z4nqUiL72643KrmK0R1T1x9JngAzuGQRh1nXPBLPvwukXAldEd1pMvPYIE41+E0pttQd
         LPiA==
X-Gm-Message-State: AOAM5321WRu8brtu03+SqMmA4Ahz4tCk6uBwxgtqfNzvoRBv0YXiep+e
        TpPUOQwmyT5JZk5jz9HI8ZuZYA==
X-Google-Smtp-Source: ABdhPJzf8dTp0eeFb0ZcGPAqgK0gpZPZnoFCsXJb4OzIL6xCMGCHwTQWbO9Cvc8LdVyi5IZuS3G6sg==
X-Received: by 2002:ac8:ec8:: with SMTP id w8mr6998038qti.371.1605801159080;
        Thu, 19 Nov 2020 07:52:39 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id g70sm127290qke.8.2020.11.19.07.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:52:38 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [Patch v2 3/6] drivers: crypto: qce: Enable support for crypto engine on sdm845.
Date:   Thu, 19 Nov 2020 10:52:30 -0500
Message-Id: <20201119155233.3974286-4-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119155233.3974286-1-thara.gopinath@linaro.org>
References: <20201119155233.3974286-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support Qualcomm Crypto Engine accelerated encryption and
authentication algorithms on sdm845.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/core.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index ea616b7259ae..67c3ca13e55b 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -160,7 +160,21 @@ static int qce_check_version(struct qce_device *qce)
 		return -ENODEV;
 
 	qce->burst_size = QCE_BAM_BURST_SIZE;
-	qce->pipe_pair_id = 1;
+
+	/*
+	 * Rx and tx pipes are treated as a pair inside CE.
+	 * Pipe pair number depends on the actual BAM dma pipe
+	 * that is used for transfers. The BAM dma pipes are passed
+	 * from the device tree and used to derive the pipe pair
+	 * id in the CE driver as follows.
+	 * 	BAM dma pipes(rx, tx)		CE pipe pair id
+	 *		0,1				0
+	 *		2,3				1
+	 *		4,5				2
+	 *		6,7				3
+	 *		...
+	 */
+	qce->pipe_pair_id = qce->dma.rxchan->chan_id >> 1;
 
 	dev_dbg(qce->dev, "Crypto device found, version %d.%d.%d\n",
 		major, minor, step);
@@ -261,6 +275,7 @@ static int qce_crypto_remove(struct platform_device *pdev)
 
 static const struct of_device_id qce_crypto_of_match[] = {
 	{ .compatible = "qcom,crypto-v5.1", },
+	{ .compatible = "qcom,crypto-v5.4", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
-- 
2.25.1

