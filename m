Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4CDC43461
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46E9A6124C
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354278AbhESOlu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 10:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348343AbhESOlN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 10:41:13 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9C2C06134A
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 07:39:19 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id s19so7789255pfe.8
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 07:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ha/LaDJaWqJqGFUOZ/CIIY7Ny0kkYMvLA61pIJyDFZ0=;
        b=WLOYc+Zws2OfLaWguoyIkyA1m4y1KdTsBz7yZ364G202kFhg5Cz8wae1i/DUrnQHh1
         HBeM5YDGHk7LZ98IXVwaHuqR6OYbgMNOt9yY43rqwglS9/2svFr72RgIxvfI7HyIe0vc
         gBjIwofSIcAXXCjfK7daf+hKjL/Ov9zRgQVvNfI+sW2xNj+oUyJk2cHZDPRxC9d7PyLj
         AjUBTsoIlgPuTpoNBp/SqFHUBY4G59V5KiNlfdFPX2sWdvG/ykFt3dJY4iHLokwCDR4T
         VGAL6RoKhXBZn6TUmJxWyNrcHT2Nsxa/gVWl+XiW3yAWyOwzHT03zZTVDjnTVJUYKxxW
         ez+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ha/LaDJaWqJqGFUOZ/CIIY7Ny0kkYMvLA61pIJyDFZ0=;
        b=kvurY0Dv5gMBeRLCDYFnA/R47ZQXt/e2vnJ679zNfLtwe1GhU2FNFpwtynItcU79Nv
         QhuQF9mHILeHS1pf45iSJq8PVaQz/73qdqxn7ouqOzznopkhOqSms2ALPMH2E/TQZyGf
         7UG/wtp7E8dfW9eB+EcAGS8MYjMQvzxX7WTlPleXjoaoaRS96Ak3EsFuCq8J78m/lFZC
         0OvvD7ZGNcacBw59PKpClwkjDzXS66mudtHJ6us2PP9nBwVPJFwoNxXH5pMM1OcffOS1
         x9mmXoUYuM5ATV1nnevjXJSs3jQoPr6S3LWd+/whs7moT5nzLlHZkCrcict8BgR9rtj/
         4MDA==
X-Gm-Message-State: AOAM533xXxPCnYc1TGF67bAWg/bH0e3BH65sFdVQOF2YIF/Uugg6E1bG
        Y00Bei7MwDdELn58VlWKDCBGmw==
X-Google-Smtp-Source: ABdhPJy6oYXhdskz+Yn8nt3Y0Tv5dRWI5TVs9gHJNz0N7OYXa/C/ddOSJ9Mb0VgSbzLMrAfiYCZtuQ==
X-Received: by 2002:aa7:8588:0:b029:28e:dfa1:e31a with SMTP id w8-20020aa785880000b029028edfa1e31amr10952488pfn.77.1621435158778;
        Wed, 19 May 2021 07:39:18 -0700 (PDT)
Received: from localhost.localdomain.name ([122.177.135.250])
        by smtp.gmail.com with ESMTPSA id o24sm9239515pgl.55.2021.05.19.07.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:39:18 -0700 (PDT)
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
Subject: [PATCH v3 17/17] arm64/dts: qcom: sm8250: Add dt entries to support crypto engine.
Date:   Wed, 19 May 2021 20:07:00 +0530
Message-Id: <20210519143700.27392-18-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
"sm8250.dtsi".

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
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 4c0de12aaba6..6700d609a7b8 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3796,6 +3796,34 @@ cpufreq_hw: cpufreq@18591000 {
 
 			#freq-domain-cells = <1>;
 		};
+
+		cryptobam: dma@1dc4000 {
+			compatible = "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely = <1>;
+			iommus = <&apps_smmu 0x584 0x0011>,
+				 <&apps_smmu 0x586 0x0011>,
+				 <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x596 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8250-qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x584 0x0011>,
+				 <&apps_smmu 0x586 0x0011>,
+				 <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x596 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
 	};
 
 	timer {
-- 
2.31.1

