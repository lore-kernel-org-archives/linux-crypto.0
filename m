Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A317C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44F8E61248
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhKJLEg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhKJLER (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:04:17 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269C5C0797BF
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:58 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so1340393pjb.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lLtW749UnPe8jWQgBOfGf+QUHkMztbxEo2aPck0k24g=;
        b=vpIOVzQeIzghGE7J3rYVia2sr88yR3iRc2AGjdxEhk0bXR8F4D/fmI0Eh7JeWdG+Nu
         S8hLBxRGKEt7Ob4Me9aHmlWg5ZHl2pkArYUijvZEaSwXdOtjn2HBZyI26XEmqeBz1xhq
         PGC/x4KO94A+zWlnJ+vb8gYKm6xOb9rBT1baIkUxEW7tCqe6JKwZXdGHRe/mxAYhayoR
         2aej04aWygudAhQ9k5ElUkMtg1z9jWgWCCYTQ34YnrOpug/gfqFPJiYdfOb+FeEL7GVg
         P8zVgvvXfdalsnREtTQ4nmtrLSuzG3dX/8bM2p1EonmTmXmSJr9scRzxSnT5bEaOfdeg
         wObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lLtW749UnPe8jWQgBOfGf+QUHkMztbxEo2aPck0k24g=;
        b=JZgnNF+iBmcTNpnWYBHcu0CIx63MAz8cD5R41gkD7QOLQH7ExxBnanU0rK6uDlxcmF
         lTAm1aP6kTF7WoyI8mkXdjpajkdcmiPTDZKK8Z7NMkitcDPaTaUzIJATDhyJ0hU5fPxm
         1uKrYYafmenwekWh94ypFDpQt7KSgroBxzC6WjFDCDd/NtGEDkZPy5zQ4bMLDnHvqMb4
         mEx8OeTssVrVl2G39gyXgbBFTib18/HnEuuabjD55S+Ld2gusmm8t+vGeiuyQj4264OV
         cO8m+A5cPVG93iIsBk5Lll6w7cdtxWHa+QU1+llw3B4haHirrQ2XXrB/U2gUYhm7W6YG
         uGjA==
X-Gm-Message-State: AOAM531MwQn5TCnJI71VqcCGLS+9SbtB7Zhh0Ns59r68QemrO39iqgAr
        heK9PMlBTYq/XgzvcUXo5JXiHw==
X-Google-Smtp-Source: ABdhPJwh0Tzmi+5nyx2iM9XRIK65GSIjFf2+5/qMqtdl5e1N7qd8E19Oi6DqExoVLC4VmQfNdFAhRw==
X-Received: by 2002:a17:90a:e7d0:: with SMTP id kb16mr15567760pjb.22.1636542057729;
        Wed, 10 Nov 2021 03:00:57 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:00:57 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 15/22] crypto: qce: Add new compatibles for qce crypto driver
Date:   Wed, 10 Nov 2021 16:29:15 +0530
Message-Id: <20211110105922.217895-16-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since we decided to use soc specific compatibles for describing
the qce crypto IP nodes in the device-trees, adapt the driver
now to handle the same.

Keep the old deprecated compatible strings still in the driver,
to ensure backward compatibility.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/crypto/qce/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 89d9c01ba009..dd2604f5ce6a 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -297,8 +297,12 @@ static int qce_crypto_remove(struct platform_device *pdev)
 }
 
 static const struct of_device_id qce_crypto_of_match[] = {
+	/* Following two entries are deprecated (kept only for backward compatibility) */
 	{ .compatible = "qcom,crypto-v5.1", },
 	{ .compatible = "qcom,crypto-v5.4", },
+	/* Add compatible strings as per updated dt-bindings, here: */
+	{ .compatible = "qcom,ipq6018-qce", },
+	{ .compatible = "qcom,sdm845-qce", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, qce_crypto_of_match);
-- 
2.31.1

