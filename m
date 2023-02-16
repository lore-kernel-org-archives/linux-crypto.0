Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E201CC6FA99
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjBPNPJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjBPNOu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:50 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC7E521C1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:44 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id b16so1860630ljr.11
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hw0gmk5DREE6xenNGf5tShOJfXuGFkAiD+ibfoL6i8w=;
        b=kcQe0fvMi7RmeErGk6kwGQi9Dp19dC7szgvGWadGNO9t28dqq6QOyh3JIq6vOcaAJl
         wWhWOUOFriEbLIGCFSUI3sQuSrmcocQEfZKSKWyZBYC9iaTMdv7yrVkGAejTzqCT9xlm
         TsVBSb8rTIwtR2VOjrlyQl9zGlQObyrZ+tqFYCVdnfVmO4jEg+CbIwwQX83yXL5QHtaw
         bkSbExeLtMQI6e0ClxcLOglfN45UHzQl+gUidqEHoIIeB+H9PuClX0HvM7C1j+sAGzkD
         XQe20sjoySO8NbN0KHZ6q9iJDUYA7FTZIkfZeDd6Mzt7OIyQEQmRnNwW8qHCnOAz22TR
         a2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hw0gmk5DREE6xenNGf5tShOJfXuGFkAiD+ibfoL6i8w=;
        b=cYEZkSOSpQKJP0CK4sP/fr7Tqv5uCMUYt2miMNh+vEeRJoGQOd9JhDCjAmm6JZ/Xy5
         3rIp6AwgA3YBvA8JY4V173E7jiulFiGCJa7lHLfQw17/9hFSDZuXSn1uQ9mpMUb5riYt
         DPJc6Teo6SBylJ1gl2bTn3m4WkcedP+CiZC/laAQZdBkgFVfg6ZH5lK2JA6jiS3XOvLN
         sG9IW6be8E5HuxMpqFDagiSthm7hGAYEnvqTQDIUCRVLgLRSwkTzPv+PMfdTaZS2L+aE
         7v5dhBzlMs/CpZPEVdUOD7G6D4P2IVOJ84ema6b/pHLBJAPk6cUGKkOfcR8XJeg8e+vr
         d3AQ==
X-Gm-Message-State: AO0yUKXjqMLA0xhcPUo6qcwS2cuXC/a6q8bxWvyicKnh0cmxjOfRQkC6
        Krv864/WySbpbjMvpbt/WwLu5BMvw59BtQmFIiQESQ==
X-Google-Smtp-Source: AK7set9mDE9My+3H2Im+b+rWgprK+5YdqwwwYgPVHiBEkLf8SgNzgrG9EOF2J/gGdr6kZMrK3b4uNA==
X-Received: by 2002:a05:651c:1543:b0:293:52a4:9717 with SMTP id y3-20020a05651c154300b0029352a49717mr2515916ljp.4.1676553282904;
        Thu, 16 Feb 2023 05:14:42 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:42 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v10 07/10] arm64: dts: qcom: sm8550: add QCE IP family compatible values
Date:   Thu, 16 Feb 2023 15:14:27 +0200
Message-Id: <20230216131430.3107308-8-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a family compatible for QCE IP on SM8550 SoC, which is equal to QCE IP
found on SM8150 SoC and described in the recently updated device tree
bindings documentation, as well add a generic QCE IP family compatible.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index ff4d342c0725..05ab0d5014c6 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1861,7 +1861,7 @@ cryptobam: dma-controller@1dc4000 {
 		};
 
 		crypto: crypto@1de0000 {
-			compatible = "qcom,sm8550-qce";
+			compatible = "qcom,sm8550-qce", "qcom,sm8150-qce", "qcom,qce";
 			reg = <0x0 0x01dfa000 0x0 0x6000>;
 			dmas = <&cryptobam 4>, <&cryptobam 5>;
 			dma-names = "rx", "tx";
-- 
2.33.0

