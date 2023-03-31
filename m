Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED40C76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 16:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjCaQqS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjCaQpi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 12:45:38 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C0B22211
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:12 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id o2so21775562plg.4
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680281051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=TQiB4R55/WdgZqihCOYe0hueyPFgcPTGGlzurKjQi4zPOhVvb+Vj0JY+mU0T1jtfDY
         3O6UZDf4/BS3N568NmYa4WWYNYlNmArkIgDpo37otAykKLnTusTpDzwg8DKRERZWHGwR
         h3kjAAdraoAVsrCD+KA50NrAnxpiD5LHpnHrISqgLrSPB4gmd0KdNdaRYGfbBo8hIxZ/
         vqJWY3IPBprw9/peWQjs5dnH+K8oqR4DIbBBhy+UDkWNlcTNEExf8eN9KFkLV3HEBAGP
         1rJs7irFhXp0YDeiUqhBilMc5ZegFS2sFTg5igN2mldfRJzo7WWCO28YwGALDlcLGo/m
         iX6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=ZIvd0chi8kN3qIiBsP3xkLk4A01NL2WKY+J8Z08/RwTKJYygZeBX1HNR2EQ16YzOcR
         1y5IzR8O5xQ5lbR4fV+evE3nRv6uBvHvp3SN/97IWULwCQ6m0qJ9shpbMN4eKOmUHZ8H
         8ggFy2HbvAhpUTK9fgSvUaCdJzWWWfxZsTCdvkJkxL9Ju7ySIIRuFJ/W92SZe/i8cD/V
         hV/QYwmsVnB8/T8rek8gPnefGOxkOLmrRK9xUtZQ5qeoRY4I7wJVbtxJzldeRHI83oZT
         p6OqtHkqWhSa6ZJ+r9A/FNRgbdD4SIUHdqRhTfNC8xwCGJx4AR17JQmza26/Y+PEwcj5
         deSw==
X-Gm-Message-State: AAQBX9fF9gUSC0uXHP4xB6By84xVb1pCl5yDqr09AidSkAQU8qFBknm2
        zwZLQ7dA9UNLTIQuaWlMKpZ4qg==
X-Google-Smtp-Source: AKy350YaMydpB176mJRTqkcfcka5RAdgO3drOTBe4s7bznkU93ZzbYbqP3LbPxRKqhCV0ADjWifTag==
X-Received: by 2002:a17:90b:4b8d:b0:239:fd9b:85bd with SMTP id lr13-20020a17090b4b8d00b00239fd9b85bdmr32370105pjb.27.1680281051234;
        Fri, 31 Mar 2023 09:44:11 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5e:53ce:1f39:30a5:d20f:f205])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902b40d00b0019b089bc8d7sm1798767plr.78.2023.03.31.09.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:44:10 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v4 08/11] arm64: dts: qcom: sm8150: Add Crypto Engine support
Date:   Fri, 31 Mar 2023 22:13:20 +0530
Message-Id: <20230331164323.729093-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
'sm8150.dtsi'.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 9491be4a6bf0..c104d0b12dc6 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -2081,6 +2081,28 @@ ufs_mem_phy_lanes: phy@1d87400 {
 			};
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8150-qce", "qcom,qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;
-- 
2.38.1

