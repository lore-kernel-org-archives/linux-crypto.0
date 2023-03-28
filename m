Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C40F7C761A6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Mar 2023 09:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjC1JaX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Mar 2023 05:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjC1J3b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2023 05:29:31 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4597299
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 02:29:03 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id ja10so11071383plb.5
        for <linux-crypto@vger.kernel.org>; Tue, 28 Mar 2023 02:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679995743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQeWB7xzGpVsc7eSrbLdl2ydZmcfTTPBoAGH1zyjD1o=;
        b=spfH8d3eP8L76VQ3aGrjxh0xAXDyNstLt4YDaU29ERkOYABQ67u2Z3Zxf3yp0AUQI1
         7aK+QNMTZIY4HGmqjAWTrARyhCwlmpdDM6fBnuhYXfDXQLVcFzcrc8UTQd0UQt++Q8Ub
         XG7Mbdc9KvnTxMrvWHxg6nP4Hncjr9RN1unM43SN2WFlIiPNkTuXpujZoiSH5mezWuPo
         C6loxzvwNyPs+xK6FewX9DVddhamPp+W5YgXnT0qYv+SkLVqHxvLEpTmnGz7e9IMEnxM
         HAXDi8J/4pTnCZ0EfmcZqEs/hA+cFT7in+c6IWdc68qebKovq4hQXJZxTkE+eIbUAjo2
         kl3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679995743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pQeWB7xzGpVsc7eSrbLdl2ydZmcfTTPBoAGH1zyjD1o=;
        b=H0oE9G78F6uLbUuFL0swnSUUqlOWY0I4zdjlDJ4+GtQEENWgs/gRNLPRSZllMZKD0V
         zkRE449mAsPcnkVLaTctI5KAEOe/+h3aeuppS1U5BoG8grM7roHnNr9VPPLd4nxmfERd
         +jb7n21yjISVl9Dz63zBJ6vweKf+y0YNhiOsZjlprtoiK9Oi6Z+gjaLT1w2T1eKCteQb
         SEyVhIRMDsl+oRIfkRxXN2wsfCrzL7faRUgR8ZfPsrPm5vubBft17v50+Mm0s1LefhL9
         gdLDws5UpuA2bNz59kYjAGVMpX4p9UWUShjBAndblo3ks9/zqeQvn2Q3bw6i2fIczhpe
         AStA==
X-Gm-Message-State: AO0yUKV7HS2dxUAHWWTKlDOk/jOe9PALGnLFFb9zvbivVCdFZs65nE8v
        Hs7+daGZfQVt2zovi36+vw+olQ==
X-Google-Smtp-Source: AK7set8uBNcWen6h776gRMwwVw1bPE2ljWWVEVrsotwoeXnZIvJ1eZCQuwjBLDgtfVINqLPNkg4Nqg==
X-Received: by 2002:a05:6a20:9146:b0:db:c5c:e0a3 with SMTP id x6-20020a056a20914600b000db0c5ce0a3mr17872712pzc.10.1679995742712;
        Tue, 28 Mar 2023 02:29:02 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:449a:10df:e7c1:9bdd:74f0])
        by smtp.gmail.com with ESMTPSA id a24-20020aa78658000000b005a8bc11d259sm21261518pfo.141.2023.03.28.02.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:29:02 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v3 8/9] arm64: dts: qcom: sm8350: Add Crypto Engine support
Date:   Tue, 28 Mar 2023 14:58:14 +0530
Message-Id: <20230328092815.292665-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230328092815.292665-1-bhupesh.sharma@linaro.org>
References: <20230328092815.292665-1-bhupesh.sharma@linaro.org>
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

