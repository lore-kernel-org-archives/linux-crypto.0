Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B8DC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 16:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649D46109E
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 16:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbhJMRBB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbhJMRAw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 13:00:52 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAB2C061749
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 09:58:48 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g5so2280894plg.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 09:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUoKrGcGLIv4lsj8yIkvr9z3hdI9OO4fYaXMDY/s9e4=;
        b=uz3prg1HuUeYXkunN46aUS+v3dYsKILB/foYmwnqhxQoSGnQ++/av9sIDK2iu+bNKr
         J5PgQBOP4OfuHFfov97yEz0VlI3M1fMqxzOezwO0FjhSS8IULI91ny5FChRop5E5oD2P
         39TQkFyHtSrjLohYvji+13Nh1eto8GqunP+Lf/Mnli9ef8MHakOSwt0gQkc+oSQ9YWEH
         DhKeVOXx73cTgUXm/EHql3WUwz0dgyEGS1i6E3MeX3wEOOEqc6Fz9LgwXMXMQg1Quyqu
         Lh2J1eboJt2lXCPyWFC3m9xB1msPucqzKj2L3oXxqi8JskRpFFv3n6XzxmtdivT4mQqj
         yevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MUoKrGcGLIv4lsj8yIkvr9z3hdI9OO4fYaXMDY/s9e4=;
        b=KfCJCUiGsIgbV/YhbNLzgHc7qap27iilU10KjyovlrWXUHnt/yE2o3pjv7RH6s69p1
         l+cuj8r4KZFCuKiOvm0LAsNssg+zE56l9kOL2V4bUiOBniDaF+ip4dPqQGKQnSyAQiqA
         5Lsr1sIwI/A36c6K+7KwmA0ZobDHXE1ybiNTt2w149289WZZ+Ruhakwclq4n9DnaqCg5
         pCzwLA9JZ7LN/EnbGSFFQKrU8QlNWEWym2vPKjWoEPVfC1ODQLJOXCSSJEuLA13v/nNu
         O06Q+YsJsSxJ2HRM9ebAh+w4rrLcjg87UgRwtnNXCE8sUqYeNQhGzGVSjXR30xaYdlgX
         Fqrw==
X-Gm-Message-State: AOAM530CNIBLUoNmyBcrx8iums69lCWw53eGE0Dhuwkf4VEHgKajt9L4
        vWpsaDQsBKvNORC/K9bBuTl3Qg==
X-Google-Smtp-Source: ABdhPJyK2z8cX7c0EYkxG+jtF4nxOaRP127Xwod0uI/2UUuARE1XdH4NAKcpTeCJhYNS+bIemLT0hQ==
X-Received: by 2002:a17:90b:4d8e:: with SMTP id oj14mr6111763pjb.237.1634144328439;
        Wed, 13 Oct 2021 09:58:48 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id z11sm6661602pjl.45.2021.10.13.09.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:58:48 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 2/2] arm64/dts: qcom: sm8150: Add dt entries to support crypto engine.
Date:   Wed, 13 Oct 2021 22:28:23 +0530
Message-Id: <20211013165823.88123-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013165823.88123-1-bhupesh.sharma@linaro.org>
References: <20211013165823.88123-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
"sm8150.dtsi".

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index ef0232c2cf45..2f7ce1fdad55 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3549,6 +3549,34 @@ wifi: wifi@18800000 {
 			iommus = <&apps_smmu 0x0640 0x1>;
 			status = "disabled";
 		};
+
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x504 0x0011>,
+				 <&apps_smmu 0x506 0x0011>,
+				 <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8150-qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x504 0x0011>,
+				 <&apps_smmu 0x506 0x0011>,
+				 <&apps_smmu 0x514 0x0011>,
+				 <&apps_smmu 0x516 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
 	};
 
 	timer {
-- 
2.31.1

