Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1B1C761A6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 16:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjCaQqL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbjCaQpU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 12:45:20 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E87B763
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id z19so21782154plo.2
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680281046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PuEDYxPh1iqRLp/0Giai1ZnY3ruEMo64qCfhktsCtAU=;
        b=Ux+Q3qKm93LGW1CPI1uH9edfXV60TnNyp231STi5a0jylVo3YVPtuFwGbfLcKnphCq
         suXMco85bicN22P5FfzSSIKWDGaUpFO/PAXuWxGsV3TlPKXTnj7FlOfnr1HxcCzMDgGq
         GIQQu5zGRy7xh9ym91vUK8bjbWq2iIpQdu8wYOifkrndI4f2/keq74jtn5+P+/18EDFD
         OdPyvDhzt/0auzhWvdF6+Ga8Gdi+VEBGhEy4PGnzk7tUr4QIaYVigT329Z9wVf5NPQ21
         YPP4p3wiyQ7586U95iZEedGGAWl1vZrlFyH/YytW9n6N4D//2T9vUuzDI2ndC4uXUUcT
         +nOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PuEDYxPh1iqRLp/0Giai1ZnY3ruEMo64qCfhktsCtAU=;
        b=VKRDX9PrDPcyFiJDBF7OXaWz62mjUYTZsZ6N9BsLcNYYtjguWQK/VzI07bYutqPUHR
         0oGzec02NX+Jbi4QUDKhRZ7yaRcjwZxpjqxnUZAZtXxNbUtgG6dFc0ooBXk9ZXz7MITH
         g2+R/ve2oUQ4MFWrK44JevKG0xRstbpvCqfPC2Y8o3ORgnm6wiOHP92ZIPWqQ3sZxUq5
         rJYdLMVvUSY1QwXJxu5Lo59ueKZM+GM07fK7wEjqhrKfnf+EDNbIlLQP/VkO4nrEmV2q
         gTaXW2epL9xyUGnE9pAL4tp89WA1yzpPGdiUbDLXgmvkEazEVJTRQRFin7YFWcOaTkYJ
         EhPA==
X-Gm-Message-State: AAQBX9ekCnQiab2FtnvZn4jmT8Yoe4NVLkc/WFNXRcl53qRETokV2S6v
        1p+SkgDdq1+o7WSXoKZkYHuEbw==
X-Google-Smtp-Source: AKy350YrFnTQteSVPXoJ1DU+cOvZPqDc0sncTaXFpNr4hMxTFxsVvJ8G4XF9n0y5AWbND7vrZOgvWA==
X-Received: by 2002:a17:90b:1a88:b0:23e:aba9:d51d with SMTP id ng8-20020a17090b1a8800b0023eaba9d51dmr30114332pjb.7.1680281046637;
        Fri, 31 Mar 2023 09:44:06 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5e:53ce:1f39:30a5:d20f:f205])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902b40d00b0019b089bc8d7sm1798767plr.78.2023.03.31.09.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:44:06 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v4 07/11] arm64: dts: qcom: sm6115: Add Crypto Engine support
Date:   Fri, 31 Mar 2023 22:13:19 +0530
Message-Id: <20230331164323.729093-8-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
'sm6115.dtsi'.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 2a51c938bbcb..ebac026b4cc7 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -650,6 +650,28 @@ usb_hsphy: phy@1613000 {
 			status = "disabled";
 		};
 
+		cryptobam: dma-controller@1b04000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0x0 0x01b04000 0x0 0x24000>;
+			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			num-channels = <8>;
+			qcom,num-ees = <2>;
+			iommus = <&apps_smmu 0x94 0x11>,
+				 <&apps_smmu 0x96 0x11>;
+		};
+
+		crypto: crypto@1b3a000 {
+			compatible = "qcom,sm6115-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0x0 0x01b3a000 0x0 0x6000>;
+			dmas = <&cryptobam 6>, <&cryptobam 7>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x94 0x11>,
+				 <&apps_smmu 0x96 0x11>;
+		};
+
 		qfprom@1b40000 {
 			compatible = "qcom,sm6115-qfprom", "qcom,qfprom";
 			reg = <0x0 0x01b40000 0x0 0x7000>;
-- 
2.38.1

