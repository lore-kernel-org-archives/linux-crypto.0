Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 627E4C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 10:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E02761279
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 10:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhKJLCe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhKJLCd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:02:33 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EC0C061766
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 02:59:46 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id r130so2353824pfc.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 02:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QYYqWkSF0jbV84eY1f/qlBJe1yt7+OpWykcTHwVzfUs=;
        b=YPOyr3wozw0D/eHhgHNRiEI8BOWdv6kMuV3VZWqCLN5TcKYU9MSpBsEa+U76q9tEvU
         AdgPsekD9mgYzO/7J9hUj6iM5a8DgJ6+5tEVDgYLuYJN90L9Spy4RUq2O/C1VHxO/fmY
         88Cl3Snoxggqu2Ce55TvuzfiZXSvhUQUTiCCMiJgDGxV6om+vDS6L13G+tgiunZWCmwd
         bjWZ3ylvRZkL993HiC11vGSitMkEviAVoEExZp5z0zdFFy4tgU3/VvrWwIYO3B/5v2dZ
         J8xfL1px342ZFTB2udE0DLwjMsVVDA2MMcX/Ov0h/mIvzNns77rss53MmiEeVkqObJou
         cOcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QYYqWkSF0jbV84eY1f/qlBJe1yt7+OpWykcTHwVzfUs=;
        b=j1NiX3fC2Ecwou8tJWYNEF4iW8vCuqyK7w9SPxRt+dPH8boStDU0idNLRQPFf2kTk7
         V92S/ag8xBrPybEbckZWfEnsl5RHBqhw6YZ0uHVkh2zmIXghm9KHAnKR/xofW+ke9pr1
         dhu1yyn+xLNw22Js/RozuJMcCYsHhajsF5KVOfohxeRyalz97D/hCD1CjAAkNC5MdojN
         7rWTPyUmxurBMePYc9NiAYvHb3qPVe8SuFWP7tLvCG75tz5V0iA+LFDfpUlXtmJWzRh8
         ST60G6Zsg9HECu3p2YoIQsqvLuP+j9VczZYUtlKTYN+km95QC+y2hi59GPdZT4yv+P1A
         UwNg==
X-Gm-Message-State: AOAM5320FlpZoATCQx9d6+2+7bowvftZoIRIE143fwgVKoZSJawnON5Z
        V8Mmsm6WfjFQNQQ2QjhG3EpE7Q==
X-Google-Smtp-Source: ABdhPJw57NcpOzofx+IMYY43mlLCAtfB8iyjkZ0/QQx32Ip2jplTFylh/FMnlUzaPdjV5w0pXSKr2w==
X-Received: by 2002:a63:86c1:: with SMTP id x184mr11206316pgd.114.1636541986052;
        Wed, 10 Nov 2021 02:59:46 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.02.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 02:59:45 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 01/22] arm64: dts: qcom: msm8996: Fix qcom,controlled-remotely property
Date:   Wed, 10 Nov 2021 16:29:01 +0530
Message-Id: <20211110105922.217895-2-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Property qcom,controlled-remotely should be boolean. Fix it.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index bccc2d0b35a8..27683d7fdfe6 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -713,7 +713,7 @@ cryptobam: dma@644000 {
 			clock-names = "bam_clk";
 			#dma-cells = <1>;
 			qcom,ee = <0>;
-			qcom,controlled-remotely = <1>;
+			qcom,controlled-remotely;
 		};
 
 		crypto: crypto@67a000 {
-- 
2.31.1

