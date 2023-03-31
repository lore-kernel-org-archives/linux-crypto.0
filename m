Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FB4C77B60
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 16:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjCaQqp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjCaQqM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 12:46:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E631236A4
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:23 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o2so21776025plg.4
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680281060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQeWB7xzGpVsc7eSrbLdl2ydZmcfTTPBoAGH1zyjD1o=;
        b=MgbGb9+BajR7U9Py9m3Waklr7ZRT5TbXE0rkhdrigVGuXvy9FH1Mb9DCA3RNwdC8P+
         W7gZj6Ayj1u7v5GHACtoETocx4IX0wY59TWhL2ZoOe3M8NixjXSkKTgWNJTp1RzJICpb
         S1Tbb0eHpfCXHhRThqTFDgJNW5eKxLs9MLiN5qjnOEoM8X0lB43Wg6tSE2eQDMOZRu2a
         5V1QJZ0WcDvQ00tFobV3d3AcdHLlyG7xOw+94sfLv9Wk5WxkXVNTou8mq5050nSyQIT1
         wG3x3rq4uE1egPNbGXjb7YRjJMqwssU4MHc1tQg4loQyoM+gzu3yVZPS5tJXspbmaApF
         yDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pQeWB7xzGpVsc7eSrbLdl2ydZmcfTTPBoAGH1zyjD1o=;
        b=Y0zwOuOS5SDVtlbiyzjCizl8z+aI+EZdjseQzW099nZvTkXOAG0n5W76SKF/gohzEC
         0Nte+ItM6d1VqLypzOHMoi21d+6OSo1ZHsqG7wMzMP6aHAsL4oyO2gPqR4sPJ+MB4QP5
         9TuMxFAdA7ZzKmLnUE9saYSAz62dWHU/Gj9MtXimyD3AcamTl+AAdusYQfDb4hSZ8U9e
         +HGAeeOa1REoKEubAjivY0P205l+hReA5Yl+3NYvt+1qtdT8Ym3uRifkUzDZbPjGHQd9
         Ee9h1D5QRo1OTHKBzZmCg1kvpiunwhxGZGAwnRK3U8xeyFQ0weZh0PrV1tiXkS4dlVxa
         fC4g==
X-Gm-Message-State: AAQBX9cXPJOMRZc49HZNr3ZNu88L5xDHkDvfohCsutmWCaXNS1ZBoxed
        t7yuh0Sftzb6dLyjrex/a6g98w==
X-Google-Smtp-Source: AKy350b+9sXAELUkkF3jqAghaMeDCPUqUPxSM1UJMNGAYXF0XGG/jRg976mLigMSa5OmDBAqdFIUoQ==
X-Received: by 2002:a17:903:886:b0:1a1:bcaa:aaea with SMTP id kt6-20020a170903088600b001a1bcaaaaeamr26472474plb.3.1680281060248;
        Fri, 31 Mar 2023 09:44:20 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5e:53ce:1f39:30a5:d20f:f205])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902b40d00b0019b089bc8d7sm1798767plr.78.2023.03.31.09.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:44:19 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v4 10/11] arm64: dts: qcom: sm8350: Add Crypto Engine support
Date:   Fri, 31 Mar 2023 22:13:22 +0530
Message-Id: <20230331164323.729093-11-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
'sm8350.dtsi'.

Co-developed-by and Signed-off-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 7fbc288eca58..090ee07d1800 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1730,6 +1730,28 @@ ufs_mem_phy_lanes: phy@1d87400 {
 			};
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x596 0x0011>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8350-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x596 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO &mc_virt SLAVE_EBI1>;
+			interconnect-names = "memory";
+		};
+
 		ipa: ipa@1e40000 {
 			compatible = "qcom,sm8350-ipa";
 
-- 
2.38.1

