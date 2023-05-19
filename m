Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA890C7EE2A
	for <linux-crypto@archiver.kernel.org>; Fri, 19 May 2023 21:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbjESVt5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 May 2023 17:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbjESVtc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 May 2023 17:49:32 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A18198C
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:49:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-64d2981e3abso1540776b3a.1
        for <linux-crypto@vger.kernel.org>; Fri, 19 May 2023 14:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684532952; x=1687124952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LH1rRa/7IYlgT4Q+3AvDcvG+o8xhzF/wa8bWuYRFB/c=;
        b=zNKIave/svuppU9Xc5i/CG9DwvgCn2G8/z8MI9Ur9dfm5MJEriyyl/7P0UQX91SV6I
         yzdYZldI4TrfqdKgS9wT2pf9FolkYeZGFlNMqegmHZfEeBUXF2w+RxWUyrdcj+vwbFP5
         UNQkYcjD+IjiS/ob5dSBcl64Ga4iYHJcXHN0QJdqMBffDOxdbWSQjFsdQ5YjbjBsRuTU
         XZNPFFgUC6eJmt3TFCJppkZHVJL3vTMUfoJjtCcUyc/suR1icBXAjA9Lse9r2XoIvFPi
         Tagx1D54QMTEGGR8oPOOzPsrDYunWPVQhc6tEsL2GNQCmvJq/uTTOO2BDxFukrbe2qp8
         t42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684532952; x=1687124952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LH1rRa/7IYlgT4Q+3AvDcvG+o8xhzF/wa8bWuYRFB/c=;
        b=VSKGLvLV8nnI179VmA8CZy71vfBl8TQB6niyghVhkwyUKhr+pi4rw4naw0vqWumH9A
         RZzJcmDPfc2zG1SuTblworPi+eHfSZswohwIx0VrX9PV2gVs6+N6AGoDa5u2ZpanbAH9
         RnWAWhNYH4p9WelKAGzzn4BGkRf4fm0A/VUNv2dXqq9Qhk+avVLl1H9iwSmsRodApsKT
         faKrU9HRd2bfdqJ2c0g/Orc1Jx4dgHV0NX5YOqL5Wug2jPSetsHMmzbMmpgWG2v/HeTb
         WRn55svEe/l1g/KYkPolfk8f/7iGW3nWICHRd3jPZaYXjTF5NoclwoPgqP2wxuwURi34
         r4BQ==
X-Gm-Message-State: AC+VfDxFYQpSQKxegH9/AqJe1AQaAVHD4Lbdi2y7VetcQXzvLWx8/8IB
        lhFL4/rgMgBp7t3dVZDPWxl30A==
X-Google-Smtp-Source: ACHHUZ4V5ONtblcsfGxR4AEa7mtX473lfAufDVVCCtzfBWymG8Hg3mOKpj7rfc6TVkwYQoUC06hRPA==
X-Received: by 2002:a05:6a00:198f:b0:63b:2320:a39f with SMTP id d15-20020a056a00198f00b0063b2320a39fmr5004995pfl.19.1684532952208;
        Fri, 19 May 2023 14:49:12 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d309:883d:817e:8e91:be39])
        by smtp.gmail.com with ESMTPSA id n14-20020aa7904e000000b006470a6ef529sm144891pfo.88.2023.05.19.14.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 14:49:11 -0700 (PDT)
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
Subject: [PATCH v7 07/11] arm64: dts: qcom: sm6115: Add Crypto Engine support
Date:   Sat, 20 May 2023 03:18:09 +0530
Message-Id: <20230519214813.2593271-8-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
References: <20230519214813.2593271-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
'sm6115.dtsi'.

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 631ca327e064..27ff42cf6066 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -661,6 +661,31 @@ usb_hsphy: phy@1613000 {
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
+			compatible = "qcom,sm6115-qce", "qcom,ipq4019-qce", "qcom,qce";
+			reg = <0x0 0x01b3a000 0x0 0x6000>;
+			clocks = <&rpmcc RPM_SMD_CE1_CLK>;
+			clock-names = "core";
+
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

