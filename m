Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1115CC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA4A4610D0
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhJMLBv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhJMLBa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 07:01:30 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF50C0613A0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:09 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 66so1935242pgc.9
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MT9l55bItKwW4zbHDysvvnWQI2UpXg0GRXR7AA0D6+o=;
        b=Hy2WLbWTgOpyChziGWJlhfOCbotX2DDfa5kzMQ5n6qYKet4py0CRZu1NhbxYnM7EkY
         0b6Hk7h0+GL9McCDXiPm82b6yveXBn+uE1fUPYfb91MlcEKoNuj2XG+0Yfk5gQS1xcH7
         NlANVKMJF7eHtBfZaLGwER+EPMvZmFInxy10FQElVZ/DT1UEAv4vnQS/kr3tU67QVj7+
         eCYsAXk7YNwIkgIqcSoc2+J4Yxo2lrfmIkyWSTzr7dHqp/a/+MH/Q/bGaJ5ZXnPDbO2k
         ggcP+iyXvwav4A1eMPl+hikrhhf9vFts7RIJ8uuS1ivYHWrOk4ZRvlU22SOw8xHi4Iev
         jnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MT9l55bItKwW4zbHDysvvnWQI2UpXg0GRXR7AA0D6+o=;
        b=NXAJInHpRwWsyGFx3ohOSLth/vvbh99Ii76qqurdZ/BI4j89yfycXDX6NagzjRASdQ
         PV4AbuEI+ljbf5PUkTQ0k8LOzzS5kMConW5OSVS0f+tceH5DWckL/5syXoiw39T8sGZV
         ohunLo3RUvPUcNsyW/UHGHlpU5kU/NtGMhfsw0ifmEb74LN7w0a9jud29ns0JN6MHmFf
         7QHNqK1TITzkyX1rkVeru+A28BdaY5nI5a/IAmvSmJu3K8Dp6i3bCjHuT19XOgq4Z9M+
         nFm09APtjRhIeFGstVcLBhk7h5JveVLaDSp9S/O6Ck+F9pKHjEP0Zuhyx4b9R0D6bmDK
         dcXA==
X-Gm-Message-State: AOAM533EzePEpYlmfAj4TlwKOHJJhTsKbDhupzdaiaZ0GUAz10+NSRJw
        OAYA5EU1uNZ3WlDR1q3VccyNng==
X-Google-Smtp-Source: ABdhPJxGPNE1Rn2FeiHga0quikOJnmZU+UBnn7ejHiZqtRROQ/ynCxTBRbppnJCacUDIkwaXGM+cFg==
X-Received: by 2002:a63:5453:: with SMTP id e19mr27288018pgm.178.1634122628771;
        Wed, 13 Oct 2021 03:57:08 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:57:08 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v4 16/20] crypto: qce: core: Make clocks optional
Date:   Wed, 13 Oct 2021 16:25:37 +0530
Message-Id: <20211013105541.68045-17-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Thara Gopinath <thara.gopinath@linaro.org>

On certain Snapdragon processors, the crypto engine clocks are enabled by
default by security firmware and the driver need not/ should not handle the
clocks. Make acquiring of all the clocks optional in crypto enginer driver
so that the driver intializes properly even if no clocks are specified in
the dt.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 2ab0b97d718c..576c416461f9 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -213,19 +213,19 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(qce->mem_path))
 		return PTR_ERR(qce->mem_path);
 
-	qce->core = devm_clk_get(qce->dev, "core");
+	qce->core = devm_clk_get_optional(qce->dev, "core");
 	if (IS_ERR(qce->core)) {
 		ret = PTR_ERR(qce->core);
 		goto err_mem_path_put;
 	}
 
-	qce->iface = devm_clk_get(qce->dev, "iface");
+	qce->iface = devm_clk_get_optional(qce->dev, "iface");
 	if (IS_ERR(qce->iface)) {
 		ret = PTR_ERR(qce->iface);
 		goto err_mem_path_put;
 	}
 
-	qce->bus = devm_clk_get(qce->dev, "bus");
+	qce->bus = devm_clk_get_optional(qce->dev, "bus");
 	if (IS_ERR(qce->bus)) {
 		ret = PTR_ERR(qce->bus);
 		goto err_mem_path_put;
-- 
2.31.1

