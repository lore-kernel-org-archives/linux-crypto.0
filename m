Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63E95C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 05:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC2964FF6
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 05:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCJF0r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Mar 2021 00:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbhCJF0Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Mar 2021 00:26:16 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D59C061762
        for <linux-crypto@vger.kernel.org>; Tue,  9 Mar 2021 21:26:16 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so6839890pjb.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Mar 2021 21:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zXfGW3C/eyJGoM/FwxHjQxTW8J2zzfoCdheICm9OVYg=;
        b=n6VbBrQ13srYdvKCmulXAHcEeJR8T0zB9pKat/yMjFByjcRhu15QJB2rqWkhNJSnaJ
         n5wZDSD9yzInpstrl4NovgtW0j2VGCMfWDdwo+nI2j1DC0U9nKuoT6LiOql1x1TxnfRx
         4tDKsdn+UhUCDok7rz1Ptso28KE7FvysykznoNzl+haxh13Tr/5y4fQtsXa+4Vs5lPBW
         WdgPHPwU9j4G1Dkz1tGveA5yqcUwvT6avACKxvQNWzku4jBkXLIcacjnGh2FxbxDqZUT
         y1WCel1Kh4PM4p0XkkhkuAhhXITRXBh3xKIbKLlSAchr1NSL+ApnlZqqhkC6QCV8FKpk
         zpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zXfGW3C/eyJGoM/FwxHjQxTW8J2zzfoCdheICm9OVYg=;
        b=XvISI1MukrBNF3+a46ij4S1QgQVpox9Ts033UMikZSaxXTxCL91hljaVij8mRsw+Sd
         K3WTNjDmRmjogK9FKeJ3pgKU5RC5EKEUDsb48RK18KImMOKGXvZjTLLXz3qOmmKk0Def
         cUWcF4+jRNbwgoFnLvnk9ncel0sI9ihE6xuT7uBkNn95VX+AQjklO1cbuslEjEgADsHP
         HBhwxqfm6cT4Q+Hs9jyEbWNCn2QidzMMeWbNHaSTRVhTHcM0t5ePijG462HSWGyKUI1I
         gxPdIJOVWxBMauHxCN/EcslXZY5FkPm8Xr+5oBBhdwWyYcipoVjj3laQkEdPFpvBMOnu
         obEw==
X-Gm-Message-State: AOAM533MgAvj2CssLfG7QbkVNtBTRjI1DcjKrhKAC0kJ+bOaeCQC6qIU
        XEiskcyBSCCBSNcfoKYPQq6SBQ==
X-Google-Smtp-Source: ABdhPJzm27HUg4lrkThEsU9SV8JMIoKlbjldZ5rkx3DceISLNo35RQECDjMsR+evkGoULAU5rGDjSw==
X-Received: by 2002:a17:902:da81:b029:e5:de44:af5b with SMTP id j1-20020a170902da81b02900e5de44af5bmr1492283plx.27.1615353975983;
        Tue, 09 Mar 2021 21:26:15 -0800 (PST)
Received: from localhost.localdomain ([2402:3a80:9f4:a436:21bd:7573:25c0:73a0])
        by smtp.gmail.com with ESMTPSA id g7sm13915224pgb.10.2021.03.09.21.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:26:15 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH 8/8] arm64/dts: qcom: sm8250: Add dt entries to support crypto engine.
Date:   Wed, 10 Mar 2021 10:55:03 +0530
Message-Id: <20210310052503.3618486-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310052503.3618486-1-bhupesh.sharma@linaro.org>
References: <20210310052503.3618486-1-bhupesh.sharma@linaro.org>
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
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 36 ++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 947e1accae3a..4f7482dbc2bf 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -3744,6 +3744,42 @@ cpufreq_hw: cpufreq@18591000 {
 
 			#freq-domain-cells = <1>;
 		};
+
+		cryptobam: dma@1dc4000 {
+			compatible = "qcom,bam-v1.7.0";
+			reg = <0 0x01dc4000 0 0x24000>;
+			interrupts = <GIC_SPI 272 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&rpmhcc RPMH_CE_CLK>;
+			clock-names = "bam_clk";
+			num-channels = <2>;
+			qcom,num-ees = <1>;
+			#dma-cells = <1>;
+			qcom,ee = <0>;
+			qcom,controlled-remotely = <1>;
+			iommus = <&apps_smmu 0x584 0x0011>,
+				 <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x592 0>,
+				 <&apps_smmu 0x598 0>,
+				 <&apps_smmu 0x599 0>,
+				 <&apps_smmu 0x59F 0>;
+		};
+
+		crypto: crypto@1dfa000 {
+			compatible = "qcom,crypto-v5.5";
+			reg = <0 0x01dfa000 0 0x6000>;
+			clocks = <&gcc GCC_CE1_AHB_CLK>,
+				 <&gcc GCC_CE1_AHB_CLK>,
+				 <&rpmhcc RPMH_CE_CLK>;
+			clock-names = "iface", "bus", "core";
+			dmas = <&cryptobam 6>, <&cryptobam 7>;
+			dma-names = "rx", "tx";
+			iommus = <&apps_smmu 0x584 0x0011>,
+				 <&apps_smmu 0x594 0x0011>,
+				 <&apps_smmu 0x592 0>,
+				 <&apps_smmu 0x598 0>,
+				 <&apps_smmu 0x599 0>,
+				 <&apps_smmu 0x59F 0>;
+		};
 	};
 
 	timer {
-- 
2.29.2

