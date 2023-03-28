Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2D9C77B61
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Mar 2023 09:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbjC1J32 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Mar 2023 05:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjC1J3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2023 05:29:01 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196605FFD
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 02:28:54 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id i15so7526743pfo.8
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 02:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679995733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=XEybTPAhej0C8WKdXNNHULqyYs87J4fUSAh7ZMvT3KBg8nUEaJz6vABo0+euB8ml0s
         0SmXYf8/1JBB8RM/YXSCUnGgAJqs78jE2i4xZ4ICgMITQULqUzzSusE5zYtkTPhgXU+r
         HejKKwYa/jhcKcqZiHQLEUtg+iLRlKkWY0ZGKk/nxxgXqZFOkcpx1OX5wsDihAfUrPJA
         IAuC75ylJB4cpuZo9RDmcOtENl+PQyh0rDzmfu3L/4sgMB34IPHlPIwqBKt3QfECE/F4
         HwRw4AeqgLV6hgojSWkgeNhbYyt6tgnkYRIsRPa+EyIgjElezK+rL4XarMnMVDLFj4Fb
         iu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679995733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=hqVfSuBj90pHgsg+/1+Mx3bygmGYFghuQ+zEU/Jr73UsLq4jjHLqRUUNPWYMkMYT6X
         Hab12eAWV0aavYSKpj8vRMpwpgUmPcyekV29HSYJ1+ZuLODLYGbWtdXx56UEK250zCS+
         SMWeWZ04q9AdQHl0Sjc5iMDqXUabujMEn3UUi2Y/CTteZHLACN1FoeoxDNPpBSQ8ZL3I
         s5oDQievlj/Sp2HfoxmV9q0kjlSExVqORRV3yj/xmd6zUj3QiWfN90dRdavQD2HLe/Hg
         BXc7Y35hFycSyWTcowJhnhum3NFEJWp+7qOFbBCBtgiqdmV8PhjMmUrBFIqs3vr6RxCK
         Tsyw==
X-Gm-Message-State: AAQBX9dExSIZ3Tq7/SFSPS06jUklLmSixlY2z9yRAcOtV1EgUVjK1ASD
        mJK4B6cUmr/2QHufhAj8aBR8Ww==
X-Google-Smtp-Source: AKy350ZoA4fHiKqG9VdFdQEBwDRs3UI1UA4TeyFjBtslZCmyiD8b1P4QENvH1QglqYzrczv0sfLKnw==
X-Received: by 2002:aa7:9472:0:b0:627:fe8f:716f with SMTP id t18-20020aa79472000000b00627fe8f716fmr14978973pfq.12.1679995733444;
        Tue, 28 Mar 2023 02:28:53 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:449a:10df:e7c1:9bdd:74f0])
        by smtp.gmail.com with ESMTPSA id a24-20020aa78658000000b005a8bc11d259sm21261518pfo.141.2023.03.28.02.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:28:53 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v3 6/9] arm64: dts: qcom: sm8150: Add Crypto Engine support
Date:   Tue, 28 Mar 2023 14:58:12 +0530
Message-Id: <20230328092815.292665-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230328092815.292665-1-bhupesh.sharma@linaro.org>
References: <20230328092815.292665-1-bhupesh.sharma@linaro.org>
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

