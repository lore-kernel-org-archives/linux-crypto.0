Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1B4C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D90610E5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 11:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234170AbhJMLCa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 07:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhJMLCA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 07:02:00 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44382C0613BD
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:27 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id g5so1555129plg.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=05vhPGITK/dB937rYm1EGwoqzkoLVWtPqjC/WL9LiZw=;
        b=S7V88jjVYtO0IXH6GQgzeyn/ZNIBkw/IeGiok2Aqbs8P0GiGGzyt9qvwqzs7QCrBvz
         Z08fkLYmeALV/+fwJyo+xUqyllDQBJ+YZVTDu23ToaHzaldpRXvhiSP8QRhxyk0Z+noa
         0mjgPf8MtRahtooLr2Q4vU1P+VtB8H0XRVA/ig5i9tih2OX2v4haYeu1kTQABafqz7hl
         n4/qF5qPd7yqlZ8d5rAeKW+OV1qg0MJ7zo/NFgabAf870lbBAI1K0sZY8wuD2aKibKNK
         Fh8yjgD3mnG99kynyoTG0/9P26LAM2LXd+2drz/Txkr8dv+K3ZNjTF3mZ+xNV93Jgptq
         e5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=05vhPGITK/dB937rYm1EGwoqzkoLVWtPqjC/WL9LiZw=;
        b=s8l3OE7b8UC4ExFGZWYPHB67Z4SCqprH70+5FRSMfFcTQWqubOI6SExv9FRwwqMxRC
         HUCrTcVnCzSk+fNh4JX/uxbgNtbFDSb7ozIYHpCQ/P7z0XJTyFudSlW1x/RxeaA94j2O
         WgJZOFp0aZjkRLuitzfT/8xmfIN13REAHORa37CMcj5LzZ3ZKVOa7OalB5pidsF99mfK
         dOQty7mgCmQHKSy29t/RRKmRv6TJGOT4uzSAvk9wFfxSM+unC3jxl9auz9Zp5tD12nS+
         bYVIFTH/Rov44NqFVLXGkmSd4qtnDT7csx3DfOUf/k6CWPOBE44wl6NYCYvflSW+rEMY
         /x5g==
X-Gm-Message-State: AOAM532GUfQJ4exeUxDzCoVT+RRkIFkGFF4hbdrW4qvDlkmewFVaRfAb
        QcNFJorldF76erJZNSa+luCY+A==
X-Google-Smtp-Source: ABdhPJy7X0JUsQ14mPahK8LxYIB78D5vCGE4viyJztdJsBhPviLXJkoAmf3PKl1cq8YfgDAPbAfZ8g==
X-Received: by 2002:a17:90a:6a8f:: with SMTP id u15mr12339071pjj.212.1634122646746;
        Wed, 13 Oct 2021 03:57:26 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:57:26 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v4 20/20] arm64/dts: qcom: sm8250: Add dt entries to support crypto engine.
Date:   Wed, 13 Oct 2021 16:25:41 +0530
Message-Id: <20211013105541.68045-21-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
"sm8250.dtsi".

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 8c15d9fed08f..66cfd0b9c7e3 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -4103,6 +4103,34 @@ cpufreq_hw: cpufreq@18591000 {
 
 			#freq-domain-cells = <1>;
 		};
+
+		cryptobam: dma-controller@1dc4000 {
+			compatible = "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely;
+			iommus = <&apps_smmu 0x584 0x0011>,
+				 <&apps_smmu 0x586 0x0011>,
+				 <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x596 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,sm8250-qce";
+			reg = <0 0x01dfa000 0 0x6000>;
+			dmas = <&cryptobam 4>, <&cryptobam 5>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x584 0x0011>,
+				 <&apps_smmu 0x586 0x0011>,
+				 <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x596 0x0011>;
+			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE_0 &mc_virt SLAVE_EBI_CH0>;
+			interconnect-names = "memory";
+		};
 	};
 
 	timer {
-- 
2.31.1

