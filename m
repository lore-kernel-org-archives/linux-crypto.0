Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E0CC77B7A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 21:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjESVuI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 17:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjESVte (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 17:49:34 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E841C199F
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:49:19 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d24136685so1012193b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684532958; x=1687124958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THzd+EMBnTlDtq026V58SAU7TYzPh0/G9GARo8OpvXo=;
        b=Y0KODrdYDTlnYU5iok6ajWjS4SzzMynklnL9SWyMwWXUwR7jsKeIqRtLTg/dT3dDqH
         /+Ef/6wAW9UYKEXDclnU1hIRE3WDh7DKTomEpbeU0mif6KHopElXOsDNXeCmK4VzHYq5
         qKbjcsdLc5VRO1lmKfAJ+WWnl0kmGMDhIilK2ugJsLzwRyCFpclRJMeoniD7R4P4Yizd
         A4Sz6LAwMPBUTke0B06bmYmlILN0lMPw5eHEy4o9hA9UuXbyYcVBtNOFvlOq3mZLKLKj
         vdIIaohkxfJkfjatCZD9yWDEIQMziN0nIGL1UIS1YZXL+cN52hFqd9XlkhawcVKwWUKK
         /Oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684532958; x=1687124958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THzd+EMBnTlDtq026V58SAU7TYzPh0/G9GARo8OpvXo=;
        b=Bxbdfhcj9wMPqi6Z5Ku5vr9DYqKzjHyhm4l59K5OjlYEOaeX+Drca6+wBJjYzD629e
         62nCah60cGMfqWjAYnuJGCRViNpbfDp5mRfbcs0nEJDEl7xROJTmss4+mU5y5GinbC36
         ZDXrbsnch5CztRn7AYsC04OpJkbRCC8X+4T2i3lWIaBokiyJr7Sm6lQKP8mZ1c4cpNdE
         3bKslnqP5UfQg24FA5K+1NnK5zyOxU2CcuTBSezWXNWlZtZk1RrCdPLueDuk2oEJIo/w
         iHoJtBRxg1aa1U5w0ydzDVKPu7qjkJNCLcN43p1VW0aWg0BK+lls4J/B7Js1vsvkYk0f
         95eA==
X-Gm-Message-State: AC+VfDwHemCBa8v2rwqnCZlu0ofC/8fs6nCfLp3j3EOnDrUN+Sm7VGQg
        u0Q7Q2x5CXF1HQZ6mMBgPl9BWQ==
X-Google-Smtp-Source: ACHHUZ5iIb1vtBHQNa+VUl+WCmsgyd9ZCfJGnfi7eYVhUaNpOPOQPf2fFhfHgJvL6g6SdU838Fl9rA==
X-Received: by 2002:a05:6a00:27aa:b0:64d:42b9:6895 with SMTP id bd42-20020a056a0027aa00b0064d42b96895mr789752pfb.5.1684532957845;
        Fri, 19 May 2023 14:49:17 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d309:883d:817e:8e91:be39])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7904e000000b006470a6ef529sm144891pfo.88.2023.05.19.14.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 14:49:17 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org,
        stephan@gerhold.net, Anders Roxell <anders.roxell@linaro.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH v7 08/11] arm64: dts: qcom: sm8150: Add Crypto Engine support
Date:   Sat, 20 May 2023 03:18:10 +0530
Message-Id: <20230519214813.2593271-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
References: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
'sm8150.dtsi'.

Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 2c377d7bb3a2..2a5b2b99968a 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -2085,6 +2085,36 @@ ufs_mem_phy_lanes: phy@1d87400 {
 			};
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			num-channels = <8>;
+			qcom,num-ees = <2>;
+			iommus = <&apps_smmu 0x502 0x0641>,
+				 <&apps_smmu 0x504 0x0011>,
+				 <&apps_smmu 0x506 0x0011>,
+				 <&apps_smmu 0x508 0x0011>,
+				 <&apps_smmu 0x512 0x0000>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8150-qce", "qcom,qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x502 0x0641>,
+				 <&apps_smmu 0x504 0x0011>,
+				 <&apps_smmu 0x506 0x0011>,
+				 <&apps_smmu 0x508 0x0011>,
+				 <&apps_smmu 0x512 0x0000>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
+
 		tcsr_mutex: hwlock@1f40000 {
 			compatible = "qcom,tcsr-mutex";
 			reg = <0x0 0x01f40000 0x0 0x20000>;
-- 
2.38.1

