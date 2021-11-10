Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8DDC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98A4B6134F
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 11:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhKJLFZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 06:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhKJLFM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 06:05:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86836C06120E
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:37 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id e65so1931873pgc.5
        for <linux-crypto@vger.kernel.org>; Wed, 10 Nov 2021 03:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jxo26PM+v+FavVwWJDiflViEe+y1rULkr8xHn7NoreQ=;
        b=zhftXFPYnO12H4n30/cgoywIiLqysx+A7rPrWK22HI7wvhzbJwGLfp2YaFIpdBKxZ2
         C2uHrfQ7YgTL+K6kIkFJigdyw9jy0vE5FwcIWmfEde4bswYdI40yrRBaxRprUOmjKrwv
         zSlF/X1iO+sJ0SBudjcl7j9ud4HCBdOvjeOJl+cnHrzWMidplmYiEs6KPsUBYgUBbeOv
         7y4uVSUUnRsDh42AVPrB+5cnc5lTxjBURJ2jJv0poNUmsPyOjTjLPi+2Gn0pgdRwXcVU
         XsV6RwYTs1SHUlm0GNWE744r1IgXycmFobSd/alnPxDfZQiTq/haljbfWNGu1vSxF1B4
         iCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jxo26PM+v+FavVwWJDiflViEe+y1rULkr8xHn7NoreQ=;
        b=pKsIzauYv0wPsGuG/V+Rki+MII0HWFqG5foVJF9m73o+ZpEY3ZJgI5+Xz0Y74ZO2Hz
         wc/gH7Lu6GE/Viuhwac++3PR8aTsJ9Vk1sN59k9dn0zk1AHm1LpEb7uds3OXiTKYS3kI
         Ausa7uCouGSdTrqDgA0sKDq8+kgfpihqm/H8bMmnxpY1V51/oQ9yGft4Vd5c67IAERPC
         64fxGoH43FKJ0uL2mdhjXWJD+eXlnHCM8iOwGSZ6A8EpCVv2xNNEWP9AhJISxEN7J9De
         Yg6DsKd6fJ0xHJXuieqcEYNNd/Rt5littBAIhl7udzZnmb078gE5uLe16BHc1toqDqNO
         5OkA==
X-Gm-Message-State: AOAM530EiObS1nsDkDt8qS6JDEEsH7kKlnbS9cSbDM15WSUMFox5vH0M
        g/k616MmropyGa0ASHf2wV8AJw==
X-Google-Smtp-Source: ABdhPJwfrC9ZDNHn68Fi6Mn1jXishCHGAfMAf6ZHJ5MivI8p6rLke2bsknx/eSpwXFD+wj09yjYriw==
X-Received: by 2002:a05:6a00:168c:b0:44c:dc5a:7ee0 with SMTP id k12-20020a056a00168c00b0044cdc5a7ee0mr15974796pfc.40.1636542092668;
        Wed, 10 Nov 2021 03:01:32 -0800 (PST)
Received: from localhost.name ([122.161.52.143])
        by smtp.gmail.com with ESMTPSA id e11sm5585282pjl.20.2021.11.10.03.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:01:32 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, stephan@gerhold.net,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v5 22/22] arm64/dts: qcom: sm8150: Add dt entries to support crypto engine.
Date:   Wed, 10 Nov 2021 16:29:22 +0530
Message-Id: <20211110105922.217895-23-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
References: <20211110105922.217895-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
"sm8150.dtsi".

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 81b4ff2cc4cd..2af74a11da69 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3672,6 +3672,34 @@ wifi: wifi@18800000 {
 			iommus = <&apps_smmu 0x0640 0x1>;
 			status = "disabled";
 		};
+
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x504 0x0011>,
+				 <&apps_smmu 0x506 0x0011>,
+				 <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8150-qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x504 0x0011>,
+				 <&apps_smmu 0x506 0x0011>,
+				 <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
 	};
 
 	timer {
-- 
2.31.1

