Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57541C761A6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 16:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCaQqr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbjCaQqQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 12:46:16 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EB32221D
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:25 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id ja10so21771078plb.5
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680281064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oFHBwDflAuoBx3nAvQZJqLFUNje4jYksqgr3MUJ8Rg=;
        b=il3cTrMbr5JNkWMDf/06GZqg3tgIq0sGJwg2KvEEbljX+AQ0HVXtv+TmdGc9Ez4Tcl
         SRpgTWmfSEcz9F9gONJV43wEI+M7i5eJDK/SGFKUwzGz7fIyhJ2z5E6Bx2PVLT6fGHE5
         90ZGyGe8uFxDDws8xQx5mfFFBzSfjuOrWWAOGvKA9gAcaTAFuQ2SQt/2jv++uGt1O+DZ
         sn13tRafhaqPlvhCJPVX3nwLM1kEQqkO6Y45OXgNrduoYgrNZfRVEAK3pHUdonbtyHvY
         aLPkVwxudSj3zXVR4fgY4JMMZlvN/GIWSiWA6lo+noRv/zeKLxdVqCUZ2ZlkZkOMUe/i
         aBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9oFHBwDflAuoBx3nAvQZJqLFUNje4jYksqgr3MUJ8Rg=;
        b=i7llNreF1Z3FwE2YRf7OpGeJwgGmE9IpOw89IcXw4fjA6sTtusRAR3XfGfQYHjGfKi
         jZSQc6rnfuoSPTqOWAq5RPFYT6nIJos6AI8LCCJVEI7ok6LLojMWQ2D0kUq2ZFZHRMac
         e2qWJmIe+A4VA1t5BSm0Nf9x0CKfq51lEisPYlf3Udl8FdmZzavy3sZU/N3MzjXJ988R
         bI4EeE+gSL6TI93UKrh0yZG7iZdfB9XQ8YQfDLb59SmwfRxHazLRh+BQVbatcoJRZEql
         BTvjXlme30nd2nkj0Nym6jvy74qGszD/pTgIrhjzllwkW/2MkXh/d7IORIXwHYQ4Lr3L
         BDjg==
X-Gm-Message-State: AAQBX9duLc4t8W8GIr0SUcLHr3sDx6CYrifH55pydjgxVDF3a6eXn0KM
        uArdEpknS9OYjiZE5/us9hYaKQ==
X-Google-Smtp-Source: AKy350az2m8ukvlx0xv24TkXLrJ+E8amqHcOA4VfZ/exIUOmE+EYOKV0M/EQ2yRGMgccir6UdTTSKA==
X-Received: by 2002:a17:902:f983:b0:1a0:50bd:31aa with SMTP id ky3-20020a170902f98300b001a050bd31aamr23244015plb.66.1680281064724;
        Fri, 31 Mar 2023 09:44:24 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5e:53ce:1f39:30a5:d20f:f205])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902b40d00b0019b089bc8d7sm1798767plr.78.2023.03.31.09.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:44:24 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v4 11/11] arm64: dts: qcom: sm8450: add crypto nodes
Date:   Fri, 31 Mar 2023 22:13:23 +0530
Message-Id: <20230331164323.729093-12-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
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

