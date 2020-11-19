Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB15BC83012
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C25246D1
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Dwn1JI3I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgKSPwv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728938AbgKSPwn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 10:52:43 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9583C061A04
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:42 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id 11so5779519qkd.5
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ncm4tg3t1i7YF0Acj05l9+ZFtRqok/Gt9GCUMfnO+SI=;
        b=Dwn1JI3IGVVrz9y1hJnMh9HlIiQF+/UE4yWOgcnTq+QHQ0LRgSEKDOa17UhFgxvw5W
         sfrnXKLoLKvWfb3hD8atziUk3EsE1xbMU/Paxw0f04Jrx9FaVGupvJVC8PtlLpAz9mTT
         YZNyEHaqD1c1sHi+lAHPsqQjYNB2C7hVqGlHXZ346pyCia0Td+Bn9V2H9gMwvS3F3cE+
         /sXSXGVVWvDmDNU98wXz3r+hkVy1GpHWJZfSnFhTybRekpDX3GQiha9tvuFs2S1EoNH5
         NtNal34ErNuxWUva/p0UbDHeDlh7hwO4BxyWAjjyqCuHOohH8T6OZelQaslPySs52tMO
         kVFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ncm4tg3t1i7YF0Acj05l9+ZFtRqok/Gt9GCUMfnO+SI=;
        b=XJneSHif1b4GB7rl+P2FievbMHWc7SfT5S/j8G300U/zo3qtqbbAyUZgbbU9OlSP4v
         yB1Z+/t3EMqMPa4w2yGcUtT3oROKGD3o9wqg/3LiAzZqgmYKda0/nGW96guGV1Lef2Tw
         4w+RNUSBwBb/VYAOj7Zu+pcCQHXkI7TOCikwPNE5cZHI8hKVheDAWUh+toTUa3AiUtMs
         rywajxPPdmAyRj+axHHpyFNyGjiN/Wchzi1ewS0JsfT/MMZVZ4JP1YhHjqRiaZqHJtnL
         fSwd6zDHszlq14kTV6qEzsNQ1r9PVkqmmfPe7R9yKVBSCXP5GtQQbxg0Skw0qGbnLNNY
         3EAA==
X-Gm-Message-State: AOAM530KJKNYPBVmJZib2dpC75Y339D8CtzbpvLFH4FDCztvn/WjhFVW
        hgZ8VMoxfKqRD4UzO7en5CcpKQ==
X-Google-Smtp-Source: ABdhPJzBzlC9keR57VmYhsWPTNkQgkbnigWXOFO/CWaItdZnYLjbu3+faOf09WY8SRnpqH5zJU98Ww==
X-Received: by 2002:a05:620a:d41:: with SMTP id o1mr11295674qkl.338.1605801161839;
        Thu, 19 Nov 2020 07:52:41 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id g70sm127290qke.8.2020.11.19.07.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:52:41 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [Patch v2 5/6] dts: qcom: sdm845: Add dt entries to support crypto engine.
Date:   Thu, 19 Nov 2020 10:52:32 -0500
Message-Id: <20201119155233.3974286-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119155233.3974286-1-thara.gopinath@linaro.org>
References: <20201119155233.3974286-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto engine (CE) and CE BAM related nodes and definitions to
"sdm845.dtsi".

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 30 ++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 40e8c11f23ab..b5b2ea97681f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2138,6 +2138,36 @@ ufs_mem_phy_lanes: lanes@1d87400 {
 			};
 		};
 
+		cryptobam: dma@1dc4000 {
+			compatible = "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&rpmhcc RPMH_CE_CLK>;
+			clock-names = "bam_clk";
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely = <1>;
+			iommus = <&apps_smmu 0x704 0x1>,
+				 <&apps_smmu 0x706 0x1>,
+				 <&apps_smmu 0x714 0x1>,
+				 <&apps_smmu 0x716 0x1>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,crypto-v5.4";
+			reg = <0 0x01dfa000 0 0x6000>;
+			clocks = <&gcc GCC_CE1_AHB_CLK>,
+				 <&gcc GCC_CE1_AHB_CLK>,
+				 <&rpmhcc RPMH_CE_CLK>;
+			clock-names = "iface", "bus", "core";
+			dmas = <&cryptobam 6>, <&cryptobam 7>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x704 0x1>,
+				 <&apps_smmu 0x706 0x1>,
+				 <&apps_smmu 0x714 0x1>,
+				 <&apps_smmu 0x716 0x1>;
+		};
+
 		ipa: ipa@1e40000 {
 			compatible = "qcom,sdm845-ipa";
 
-- 
2.25.1

