Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAF7C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA132611AD
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhKJLE4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhKJLEh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:04:37 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D9BC061234
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:08 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so1528928pja.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pEmrGhMt5x9KzAGjex8hd2BnItJeKAQ0mSWNoFozY7Y=;
        b=hTM4hCpWUUSnZxEfUppK6dcKEnhxFuEnHZOfw4MtmSuRm9Cvxcgzwo9oTX4COdaodE
         T1GmDKU4P+ibQCSbh+9cZWhShhbtMqNaanJDOucbTSWXvEPftv/zAaYwi1BvBEiQwWdA
         USSUTxc3c3ySXfDDC6AhSy1CE3B2dVdlwzeC9V30WaGEC0en7dss290s7SwtbN14XUwO
         0TaFj2mB+EBYANm3UwUWy2xRWZk2gtLr3Z8tclCeJvmrXoz2bnRfhbj/3krWuojf8j06
         RbGdaUX4jFb9d+Ep6aVR6YukPGS6hAOvKXLQ5Oop4FrWCHC6A3/dW1f94O0gJGDtJ1Xc
         PRsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pEmrGhMt5x9KzAGjex8hd2BnItJeKAQ0mSWNoFozY7Y=;
        b=3jf5h9bSt5AVzJH+q0ShX6Skjpeo8Iq9txsN+L71m67t/7sMmZmqKDcDlpSqfseDdu
         sy3yGQbJbhRN6XDcBB0mEjcPwkHdU31SL653IBztg3nvuvakX9kluohpda/IWxaw1vF7
         FEGKSiEj+RSCge0XS5RZLqgnvAHY8lT5dW8aFH7+yOCmJOos8WGUzZzmsUm/Y35YiVRG
         1O1RUuccHry2g7Umct7BgDoyYCz7REQClMogLeLi+LZiM5pbAboPBvjRgKQdmkF+4/4Q
         FAHOEK9Rp657STMoqRB9GSZP3+Lf5bqutdPneucL7jD4D6JnU7m55GOWKFcRUsVzFMYy
         UBXw==
X-Gm-Message-State: AOAM531a4BIorvYT7HUr2aZOsyyv5nAfHm6rR+UfCZcmkS1oUOnjnjBb
        zsaZqzDqFMVUYrc6k1wwjHVMHg==
X-Google-Smtp-Source: ABdhPJyWq5dZS0dYnEesfHptwZiGNCpxGMUNYO5DOYrhNDof2xAUJhafmenwSdNzwnFox6ZcHapjeA==
X-Received: by 2002:a17:90a:df01:: with SMTP id gp1mr15743014pjb.28.1636542067732;
        Wed, 10 Nov 2021 03:01:07 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:01:07 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v5 17/22] crypto: qce: Print a failure msg in case probe() fails
Date:   Wed, 10 Nov 2021 16:29:17 +0530
Message-Id: <20211110105922.217895-18-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Print a failure message (dev_err) in case the qcom qce crypto
driver probe() fails.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Reviewed-by: Thara Gopinath <thara.gopinath@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/crypto/qce/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 98784d63d78c..7c90401a2ef1 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -280,6 +280,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 err_mem_path_disable:
 	icc_set_bw(qce->mem_path, 0, 0);
 err:
+	dev_err(dev, "%s failed : %d\n", __func__, ret);
 	return ret;
 }
 
-- 
2.31.1

