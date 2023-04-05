Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A26C7619A
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 07:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbjDEHcw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 03:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237055AbjDEHcZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 03:32:25 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A6D559B
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 00:31:44 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q191so3865270pgq.7
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 00:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680679903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oFHBwDflAuoBx3nAvQZJqLFUNje4jYksqgr3MUJ8Rg=;
        b=iXUMZHc446PS3IQBnpaoYwlsVWtesXSS14qR/2raGp8D9arZ2hC9sa7ua9uL3LlVWz
         ODVIdaWILyr+HCGJo8szz2pHi3D19q5+yC2y3dK5Ue2H96BOwQ7Bx9GedzGCAz0TSqzQ
         yLnvyeBLmNEoIveXrjAFAzyx6gjpmqkCFwz0gyUerlMBPip6iTofHr3jRF5glsxqTL3Z
         O5oGrcm8Gr7qkVYb/sd3WePQtA5khwlR2liNu5y0GiyN/JA+z50i2VAsfp1VV2osfDBT
         s078Ck6ypD0yAnFyG7Kv0NmlgK94VgCD2CKuLabl3K+D4yGbBCW/HQC8L0g8o3lfeCnY
         baEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680679903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oFHBwDflAuoBx3nAvQZJqLFUNje4jYksqgr3MUJ8Rg=;
        b=cJQAqK5Do8KEehpkhprtmvuIpAalZwzN/ZO24yGEg0t0KFVW+IMLCpUxVbNBKzpG+9
         Lbhq+mEwFYKt8GRkUS44a0JZm+CFx0wqypvCx9X3uuKwbaDJEbWLwzhYjV/AfsQOolei
         95RIjBJR5ooro5WEI/AA1ennBdAAJxrMCclaV2lpjnMjLjFKWI7DNFfNl3mJOEJ3V7HK
         9Uc1WsPjYGJftbYyd2PaszbYSOlc8HN/b33tWwJQHc8NTiJg+qf9gNtvFXEMmEP+JkPy
         XgU/QNM3zYhA2IxV9IXtFSw0MMkTvEPIa0XPOAPTsMj3LzNqKw32qRnvnk+cVQS0jxhw
         tXoQ==
X-Gm-Message-State: AAQBX9fLM2evULviTswUmD/AHJGdHmrAcTrykHBsO/OPTIhDFVr8zN/o
        ppYBte9QT2Y42PcWWE3SylZu8Q==
X-Google-Smtp-Source: AKy350YhwcabbMAVUwTuagacxKx3KGMxiWOnBOsSG28WbyONpgKoA/kMxM9LvBpYrEs/YV0r2K8kzA==
X-Received: by 2002:aa7:93da:0:b0:62d:d748:94d2 with SMTP id y26-20020aa793da000000b0062dd74894d2mr5410013pff.28.1680679903377;
        Wed, 05 Apr 2023 00:31:43 -0700 (PDT)
Received: from localhost.localdomain ([223.233.67.41])
        by smtp.gmail.com with ESMTPSA id l7-20020a635b47000000b004facdf070d6sm8781507pgm.39.2023.04.05.00.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:31:43 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
Subject: [PATCH v6 11/11] arm64: dts: qcom: sm8450: add crypto nodes
Date:   Wed,  5 Apr 2023 12:58:36 +0530
Message-Id: <20230405072836.1690248-12-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Neil Armstrong <neil.armstrong@linaro.org>

Add crypto engine (CE) and CE BAM related nodes and definitions
for the SM8450 SoC.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
[Bhupesh: Corrected the compatible list]
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 31877f18dce2..d7a28cac4f47 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -4146,6 +4146,34 @@ ufs_mem_phy_lanes: phy@1d87400 {
 			};
 		};
 
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x28000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x584 0x11>,
+				 <&apps_smmu 0x588 0x0>,
+				 <&apps_smmu 0x598 0x5>,
+				 <&apps_smmu 0x59a 0x0>,
+				 <&apps_smmu 0x59f 0x0>;
+		};
+
+		crypto: crypto@1de0000 {
+			compatible = "qcom,sm8450-qce", "qcom,sm8150-qce", "qcom,qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x584 0x11>,
+				 <&apps_smmu 0x588 0x0>,
+				 <&apps_smmu 0x598 0x5>,
+				 <&apps_smmu 0x59a 0x0>,
+				 <&apps_smmu 0x59f 0x0>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO 0 &mc_virt SLAVE_EBI1 0>;
+			interconnect-names = "memory";
+		};
+
 		sdhc_2: mmc@8804000 {
 			compatible = "qcom,sm8450-sdhci", "qcom,sdhci-msm-v5";
 			reg = <0 0x08804000 0 0x1000>;
-- 
2.38.1

