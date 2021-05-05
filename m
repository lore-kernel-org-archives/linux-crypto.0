Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0920C43470
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D883B613D6
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234191AbhEEVjp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 17:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhEEVjm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 17:39:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C5EC06138E
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 14:38:44 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cl24-20020a17090af698b0290157efd14899so1738383pjb.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 14:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E5tl04v9finFgI5dTLUvXSF6+C6BwGNEbEHhfHuvsdY=;
        b=ACKDEi3d8y/Es5bvtxn0l07L22kbFP+Tg3bHthNBDjeNhLT0RD0b30luapq6h1jr+k
         ihA0lPDekyGXGNtEsizSa93QkooYXi0yYZ/Hbhgssk+gGhl8Tnpf0bq+Vh+Mh5exkjBd
         L/xDggHHQz56PSkFhqnOEn+NeB+a0Hzp4BjOAVaPK3GhI7G1jIYpFOMnzJyNNJT8Hp8d
         0WuYvDLSLn7AzU5isvMdBRcgavBQQCabPXAsJyTA6Pa3VhV1OvUBxmVdQbr7TOONLK7y
         W944jvb43h9iBU4Sq+rKDsnM81Kq6DcFxOfRsgXcwnqaNUY7LOXwewEsdrmgQZKmjP5T
         P0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E5tl04v9finFgI5dTLUvXSF6+C6BwGNEbEHhfHuvsdY=;
        b=RUyLQGbqROpU9hgJsWiQElW0kbyjO0Exf7ZAv7eGZuiT2BWsTwiNzGRlCf4t6Z0mPK
         5Z9XIVXEMc8O5LIHk5Xvea2phDpl0UqbVPbyd5OIu65s3I1qf8h0+P/5SJvTPWR5cYb3
         +cp5QWUsuvvXROc6Nsu/eWfJbYXSC3qhW3vQyK4+telFgidOHZdLpn8f0TNbpcdvUOMR
         Fcw5Sqrs6N4u9MUDEZFYmsr1LKFOiVF+V9plJjr5vtzKC//2OOFkNt0N9pczlLCFXEii
         AODGtoaanyb/zl8bIUq8D7pTQX5Hneat4sm3spRQHbJMT3YmLZvcnEXxqi8PzxaJeRHJ
         Zh5A==
X-Gm-Message-State: AOAM530ko2pjU1w6IUP/M217BifumIPG7yOfkbpOB7UCJR3cvY2tLypp
        60ekSOcE2bKYle+DC/TsyE1WiA==
X-Google-Smtp-Source: ABdhPJxokI0TPxCQxyWx3qoUxcst1Tw4Diqii8RFo16frzYUDUMAAjgoOQ4pxTkscIz5IfuV9xAs2A==
X-Received: by 2002:a17:90b:8d5:: with SMTP id ds21mr13382570pjb.65.1620250723426;
        Wed, 05 May 2021 14:38:43 -0700 (PDT)
Received: from localhost.localdomain.name ([223.235.141.68])
        by smtp.gmail.com with ESMTPSA id z26sm167031pfq.86.2021.05.05.14.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:38:42 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH v2 07/17] arm64/dts: qcom: Use new compatibles for crypto nodes
Date:   Thu,  6 May 2021 03:07:21 +0530
Message-Id: <20210505213731.538612-8-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since we are using soc specific qce crypto IP compatibles
in the bindings now, use the same in the device tree files
which include the crypto nodes.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 9fa5b028e4f3..978c34f176de 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -205,7 +205,7 @@ cryptobam: dma-controller@704000 {
 		};
 
 		crypto: crypto@73a000 {
-			compatible = "qcom,crypto-v5.1";
+			compatible = "qcom,ipq6018-qce";
 			reg = <0x0 0x0073a000 0x0 0x6000>;
 			clocks = <&gcc GCC_CRYPTO_AHB_CLK>,
 				<&gcc GCC_CRYPTO_AXI_CLK>,
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 2ec4be930fd6..6423991fa303 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2328,7 +2328,7 @@ cryptobam: dma@1dc4000 {
 		};
 
 		crypto: crypto@1dfa000 {
-			compatible = "qcom,crypto-v5.4";
+			compatible = "qcom,sdm845-qce";
 			reg = <0 0x01dfa000 0 0x6000>;
 			clocks = <&gcc GCC_CE1_AHB_CLK>,
 				 <&gcc GCC_CE1_AHB_CLK>,
-- 
2.30.2

