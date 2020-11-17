Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A36EC64E75
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E7BC221F8
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AzK6Yrvt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgKQNr2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387720AbgKQNrX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 08:47:23 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAADC061A04
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 05:47:23 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id g15so15525472qtq.13
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 05:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ncm4tg3t1i7YF0Acj05l9+ZFtRqok/Gt9GCUMfnO+SI=;
        b=AzK6Yrvt4ojnePSkMjrD04IdokAWSGtpGueCwZFlbrhy7hQtMjiEOjBlKkuMmv6pF4
         leZpG5bdulABRj/GDDtcY6PUZ5V1E/u5F0ajbytrEoDoQcJOiWgT7x4ZeNaOQEDTqidx
         f76yEpQVEvddQO9gwcy6YJ9Pu7setxaG5HL22KwMqHotBYmx6iXb+A3xsegUbQDBXIUL
         ZoTMtx1W8jBbgR35hor5jUn8/hJl7XabBUYuGd1xYcFXg1cKrkYUKXxyFrjyUMBsp9k8
         2/tZf+yEKOzk10sjnHHvV+6+biGQXnG0cz68sUCmsxOQvv1zb2MeGo3yoRDCqHj5Vve9
         GLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ncm4tg3t1i7YF0Acj05l9+ZFtRqok/Gt9GCUMfnO+SI=;
        b=iJQSDozk8yf8Ui9RjXEgz6I5evjY4TNrcgsrBGYvInQRMDa1JZhwf/AI4/04URlolR
         tXGvZthcU64u69HmB2cYE9mV54f0u9xLbigro57CswtT3fmUb/q22MN7+5EzgkmSDF0m
         boZtnbVyMZJ7Z9fif0Qpjp2w5RkiQ9OXEhiSdpx18s3J7Shios/VHtuGNpxIxAwlYDXM
         m2x5P8vGPNZA/pFe8XD/OgnbbCkEDKstGdnsTR3wi247RU+9AUnO1nF0p4hJJtdT31ET
         IbbiTK2sZQ7tKXNS2ZPyWvUb6GWeovsggc43muwuHW5MVhnMsp4EgJ0LnEc4L6Ca/ZZM
         a1oQ==
X-Gm-Message-State: AOAM530x2JRU6StSOPykgKj9JljEPBN5AV/u2pqHuycu0h2xE8+nDFJz
        7zL2ZcCSZPeQlfbQ8EHCqasBDw==
X-Google-Smtp-Source: ABdhPJz6BaJRt+WobpIKxxa/qL817BHczc/hh2+505mPvUD5hs095V7MOW6E6PqU2VyJwlCynf75fA==
X-Received: by 2002:aed:3fb7:: with SMTP id s52mr19611498qth.100.1605620842278;
        Tue, 17 Nov 2020 05:47:22 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id t133sm14607355qke.82.2020.11.17.05.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:47:21 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH 5/6] dts:qcom:sdm845: Add dt entries to support crypto engine.
Date:   Tue, 17 Nov 2020 08:47:13 -0500
Message-Id: <20201117134714.3456446-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117134714.3456446-1-thara.gopinath@linaro.org>
References: <20201117134714.3456446-1-thara.gopinath@linaro.org>
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

