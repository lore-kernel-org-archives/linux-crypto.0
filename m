Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F580C6FD1C
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Mar 2023 11:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjCVLqk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Mar 2023 07:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjCVLqU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Mar 2023 07:46:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9214861888
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 04:46:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso18840702pjb.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2023 04:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679485562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+8IuRB7wPiG8RcwMJh7jwuTW8oHkpDSzf2to+aWgkk=;
        b=JuLXRqui+5M3hNGpgOtC9Y1YzExdFvkHC7RdPWtEVyntoiFH4r1wOhLskjgGLJ6R7S
         kyF3jr7HMLgYOS3+21KKkGK8s0ampd+vWvtbDuBppPfizAk9uEmwlAs6Yq78q6rTXR/T
         qTQGNFy5JepXGqOzWu5ALkuNQIQwFnQmjU+7VPLZw+mIvB4fmHNlk8g4LTpkzLOAA9lZ
         r5iJjoV5ec8AjSp7y87rJHORt0smLFVW5rgM36zMGAofEQw9YyF31Faq/A7t1jAbbk17
         9enRAWne3t/FrurWH7t6qF4w8jSI2Ejp6VmUplWhrtMRnVSFXb9CAcy7ikrL+FpAQZrm
         SOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679485562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b+8IuRB7wPiG8RcwMJh7jwuTW8oHkpDSzf2to+aWgkk=;
        b=TRz1jASsR06ibttWQL1UrbAthTW8yaCX1ryR+R3XhRhKfvzf7DbYo3nlmzQhddJsD7
         Fc2hVDWUVsNxfBdH+W0XKzHzAd5ruS3IFKZhLIAdJXdIt47ETDk52EekK423SxRDinOl
         LUQXfd5uGzSJNI1C54fV6+n+oD37VszwGuARJuopTspln3/3j8bnBv8wL39p6J5fbjZw
         v9jMI2lKiniwqHOoqaKxFEJSPYgZdIAReCKWsHUBXc7VyGw1FG6LCQJdGBnvIyqykewo
         xHdK1lnE8l9Bx1oRwH/p+f4Odx++oB/E7P7kKTohG3g3I4X3zSoVKWwKRpygM2VK1s4T
         FmoA==
X-Gm-Message-State: AO0yUKXyjX4L2RXNnMoJOL//R72UrEPyLQE6MbZeFQ9O4KlCvE37pbSk
        ndiSEYwfwVyOoCR5awoAUz/wGw==
X-Google-Smtp-Source: AK7set+F3wpRKm+Db+oMEjWCn4c0Sm1f/STvNvb3oavqA99YGNuNdkttA/+lpNvzjMwz3/4RWrFbjg==
X-Received: by 2002:a17:903:686:b0:1a0:4b9a:bae6 with SMTP id ki6-20020a170903068600b001a04b9abae6mr2459904plb.30.1679485562498;
        Wed, 22 Mar 2023 04:46:02 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c60:d4c3:8671:83c0:33ae:5a96])
        by smtp.gmail.com with ESMTPSA id jd1-20020a170903260100b0019b0afc24e8sm10386649plb.250.2023.03.22.04.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:46:02 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v2 06/10] arm64: dts: qcom: sm6115: Add Crypto Engine support
Date:   Wed, 22 Mar 2023 17:15:15 +0530
Message-Id: <20230322114519.3412469-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230322114519.3412469-1-bhupesh.sharma@linaro.org>
References: <20230322114519.3412469-1-bhupesh.sharma@linaro.org>
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
index c56738633431..d657e1b02062 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -664,6 +664,28 @@ usb_1_hsphy: phy@1613000 {
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

