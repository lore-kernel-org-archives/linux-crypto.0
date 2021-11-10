Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43692C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 272C1611BF
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhKJLEr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbhKJLEd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:04:33 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42891C061228
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:03 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id b68so2307613pfg.11
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zajz8wlcJ/lmsrGc+Bku0OSeAwVpyzSmtcytIJmQ1Lo=;
        b=Rl/9j+gVyJ49tf3n/+dMojXFkhnC4v0DXwaB0ozTMpSH5XBLHxac76ivFTKmJcCUpV
         1xZwL16K7gNbIyx+N4e5tENrdu7WD5dxr9/qwfBpb+1Re9eELaTp1/C38ey1rd+Fzz/3
         7867dycwCsInKyRM/qdCzVGXzutOmDbeTUcRRSN/PlIvVcYCji0ysxMHfA3ETYgMWA3K
         RlynN0vw17HB/udoO2JslImMWG0HqHeTogLiFXeAzxjZkHHs1HdlVzzDk12WI3NHbRHy
         umsRGwdv9vDNh4pHdovg4Ehi0Zshyx4VuLOEmAUWN6IfnXloLgaunpPol5SrR81DtOPn
         aGtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zajz8wlcJ/lmsrGc+Bku0OSeAwVpyzSmtcytIJmQ1Lo=;
        b=5F1n91CBKEXv9+0vsa6dNl8nStkj76imDLtY6em0R03ziRWB7In01Qm40gBKOnIOfz
         hLBppnWGjuQNPvXbZjPphz4nvIm2NVEG0ak1R6Lv8XCNrnq0hVZZ97cUUnCKcXWKBo1O
         bV0J+r8Sxc+kSINXNII8fGqv2osO5AxEYtdFDVXaHc93ODi0R7WkPDBZdIlt65nYXJ+7
         j3LupDuCSppbNIFqFN4bsmNNbdq/lgkqnwVZQBnlm6C4xxoIxWjyIxq6hJt7uXxn9Dj/
         wYMkumj/jCTCHcrZiWL3CxA7uF60k+pf+WjyFqfZamTJmRbU0Sl1w/hjyn4O0K7oPDxx
         uO4g==
X-Gm-Message-State: AOAM533HTsds7GMTzq1FbHFyJFEgpgcw/uCLdYGAB8RL9ElaCgSdKdpu
        qw07xoDvMcKHzF99RV/a7xMvdg==
X-Google-Smtp-Source: ABdhPJwd7pZZQElvm6V1On9VHWVR8qHrrG6qVljBZ0zfBJeLZ4TAJLio9NR5kWfoi/eDpB8ctO6cIg==
X-Received: by 2002:a63:8bc3:: with SMTP id j186mr10954336pge.250.1636542062715;
        Wed, 10 Nov 2021 03:01:02 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:01:02 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 16/22] crypto: qce: core: Make clocks optional
Date:   Wed, 10 Nov 2021 16:29:16 +0530
Message-Id: <20211110105922.217895-17-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Thara Gopinath <thara.gopinath@linaro.org>

On certain Snapdragon processors, the crypto engine clocks are enabled by
default by security firmware and the driver need not/ should not handle the
clocks. Make acquiring of all the clocks optional in crypto engine driver
so that the driver initializes properly even if no clocks are specified in
the dt.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
[Massage the commit log]
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index dd2604f5ce6a..98784d63d78c 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -213,19 +213,19 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (IS_ERR(qce->mem_path))
 		return PTR_ERR(qce->mem_path);
 
-	qce->core = devm_clk_get(qce->dev, "core");
+	qce->core = devm_clk_get_optional(qce->dev, "core");
 	if (IS_ERR(qce->core)) {
 		ret = PTR_ERR(qce->core);
 		goto err;
 	}
 
-	qce->iface = devm_clk_get(qce->dev, "iface");
+	qce->iface = devm_clk_get_optional(qce->dev, "iface");
 	if (IS_ERR(qce->iface)) {
 		ret = PTR_ERR(qce->iface);
 		goto err;
 	}
 
-	qce->bus = devm_clk_get(qce->dev, "bus");
+	qce->bus = devm_clk_get_optional(qce->dev, "bus");
 	if (IS_ERR(qce->bus)) {
 		ret = PTR_ERR(qce->bus);
 		goto err;
-- 
2.31.1

