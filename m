Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E16C7619A
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Apr 2023 07:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbjDEHc1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Apr 2023 03:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237196AbjDEHcA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2023 03:32:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276BE5B8F
        for <linux-crypto@vger.kernel.org>; Wed,  5 Apr 2023 00:31:31 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id ix20so33667565plb.3
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2023 00:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680679889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=zGOdeyUuHbssOQ7Z1mPYifIrImzF0vUnQh4Iw+uFJy5hY8QkDtGxFIGiG3kQuaTxhm
         u56fsLmTn4sJoiDloYF0AozECkkKzxU4bafTT7eZ39jiA8sOR1uJLdIRWyBBb8K3inQG
         U6WBpxN3cYIoOt3D8JP6Be5owOmPe147i0mbAtgAph5yWGWSUS4W7KFToxkkbixIceV7
         E7ksTM/lHtxEIRW2e7aeep3WgvtpLn6ituYfGV4kuUNPSEXITCTdqivik/x6DJ1UMdXe
         SnJDBCcNMRVTjDXLGEniSeo8qelBz7zYsciLArvf/ii48/h7WcXJTOmyVW/riM56MsGU
         Ib0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680679889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MVums2xGimULwLAksXbnkYaopPwvTqx5iwZKEFGpjA=;
        b=zDE7ehOvFw2zceoie+BC4fKeda2pn50PJYDU9lnp89BQj2OCkplpimHJiGWxq6pC0O
         ThtIjnwUFVonwf3a1hJpeN1DQi5ODM/W9vrY8jpQ3pO18+3zeiGFvsxrZXISdUM2n520
         JfZ/crZQdbbUKvTVcCOOiCkMahxvm57FCmuGzoHoNECLGXkT86JrkF6B+wFwkExT9yDQ
         pT5lZUoeeK5Y+AShOs9fH9r6phyzKgUz+pbsd+o9Gno0q3hpAKjJXGY226J+OlghF9Ss
         ZDIde2YvQ/9dbhpWMeQCj4jhhh9M9LjfVnX12MpckqzaYnCxQTQUqBG2jYdHxVwUmPUw
         f/mg==
X-Gm-Message-State: AAQBX9ecJeOHq/5MpPvEX187Hic/hRGjdXBaNaLKnFLG5z/79hXVDBd1
        Op/t0sXbbQ706rKv3eGFyoSUEA==
X-Google-Smtp-Source: AKy350ZHbDWY+SUIF0C/sKiPkQp05MMrfJ/2mBdXbCQmwonFN3luVkhQwf72PaKWsmD0OlCGFkcygg==
X-Received: by 2002:a05:6a20:4b16:b0:d9:162d:98e4 with SMTP id fp22-20020a056a204b1600b000d9162d98e4mr4000483pzb.54.1680679888795;
        Wed, 05 Apr 2023 00:31:28 -0700 (PDT)
Received: from localhost.localdomain ([223.233.67.41])
        by smtp.gmail.com with ESMTPSA id l7-20020a635b47000000b004facdf070d6sm8781507pgm.39.2023.04.05.00.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:31:28 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org, djakov@kernel.org
Subject: [PATCH v6 08/11] arm64: dts: qcom: sm8150: Add Crypto Engine support
Date:   Wed,  5 Apr 2023 12:58:33 +0530
Message-Id: <20230405072836.1690248-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
References: <20230405072836.1690248-1-bhupesh.sharma@linaro.org>
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

