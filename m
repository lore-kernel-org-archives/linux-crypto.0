Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C43C83016
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 772CB246E8
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A331nUgW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbgKSPwl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728905AbgKSPwk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 10:52:40 -0500
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF73C061A04
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:38 -0800 (PST)
Received: by mail-qv1-xf43.google.com with SMTP id z17so3045976qvy.11
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4MCvCRmAMrx9hEGjjAJklgqSdTLavuT99AZ/bugFCos=;
        b=A331nUgWpYis9cgDM+H9IflfmtXE8u7sy5s92VZ6qlPcq3ZPDIlJsHqw1/ta/Y2qN+
         9uDbQikKonrGHPWZQs8GljIwkUssWr8JAhYELG0zYCgATDn2+N2mr6Ab5Lt69OLvZBwq
         DDe9BHj0r+7d4AxKDQp5badoafP9TPsKZIR62l1ACovFvtX/ALLbj57OaqbV/8tck0nv
         lrptbm9LgZ4t3S9aNEn6RAz3nCRI4wA6pWOujVakHNQmW7guGiVPLk7gCaBY0Zi3I+Zr
         eBI6gBI4O4UtDVrUuiQOUbli0S2LUcktQyDh8PfubJHRD7nCqAygCSINMcN7qYOXSc9R
         T65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4MCvCRmAMrx9hEGjjAJklgqSdTLavuT99AZ/bugFCos=;
        b=RFD0nuOsY1I24MwqpCVWspdZFDwLcp8ytKBhuP3Ern0xFofBWyehci6x3t7ZPLy9bZ
         UXr9jX7ozf4bJjXsJYhf7aR2FJmHM88LXYLDrdnkxBIc8ybhRJS1voyosMgA0otQMcv2
         FmMSHjbAhGv7DTIgnTLzIPaPIVORZ7BwJyaB4s/pW9vWkuLwzXhX6Sz8cf4P2ttqqIGQ
         2Npkx1djeob+BuFo70HXDu+qulZud+s3vgMVBDsYifus1wfSivVvJRzQPZVWHEEYAbf8
         ogMebcqQcu7Pdd6HX9BI92X8lJZJAwdJ2F4hJmQZMghde8mHnaySqPr+BioOCsIK8R/n
         6Ojw==
X-Gm-Message-State: AOAM532bCseHDbUC398n7oOwDTPZptYI6+6nUgOIH4N0Nb98ARvgVVMU
        FyDVxc8ix2cBJJqI79mo/Qh0IQ==
X-Google-Smtp-Source: ABdhPJzw0guC1FRcPUMM6ggVF5poQsV6NfMqLMhm9/eeXgiHTjzxQjRQ4eyp1THPYSO/wEHEiAl/7w==
X-Received: by 2002:a0c:c984:: with SMTP id b4mr11609562qvk.10.1605801157619;
        Thu, 19 Nov 2020 07:52:37 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id g70sm127290qke.8.2020.11.19.07.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:52:36 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [Patch v2 2/6] clk: qcom: rpmh: Add CE clock on sdm845.
Date:   Thu, 19 Nov 2020 10:52:29 -0500
Message-Id: <20201119155233.3974286-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119155233.3974286-1-thara.gopinath@linaro.org>
References: <20201119155233.3974286-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Qualcomm CE clock resource that is managed by BCM is required
by crypto driver to access the core clock.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/clk/qcom/clk-rpmh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
index e2c669b08aff..7e2a4a9b9bf6 100644
--- a/drivers/clk/qcom/clk-rpmh.c
+++ b/drivers/clk/qcom/clk-rpmh.c
@@ -349,6 +349,7 @@ DEFINE_CLK_RPMH_VRM(sdm845, rf_clk2, rf_clk2_ao, "rfclka2", 1);
 DEFINE_CLK_RPMH_VRM(sdm845, rf_clk3, rf_clk3_ao, "rfclka3", 1);
 DEFINE_CLK_RPMH_VRM(sm8150, rf_clk3, rf_clk3_ao, "rfclka3", 1);
 DEFINE_CLK_RPMH_BCM(sdm845, ipa, "IP0");
+DEFINE_CLK_RPMH_BCM(sdm845, ce, "CE0");
 
 static struct clk_hw *sdm845_rpmh_clocks[] = {
 	[RPMH_CXO_CLK]		= &sdm845_bi_tcxo.hw,
@@ -364,6 +365,7 @@ static struct clk_hw *sdm845_rpmh_clocks[] = {
 	[RPMH_RF_CLK3]		= &sdm845_rf_clk3.hw,
 	[RPMH_RF_CLK3_A]	= &sdm845_rf_clk3_ao.hw,
 	[RPMH_IPA_CLK]		= &sdm845_ipa.hw,
+	[RPMH_CE_CLK]		= &sdm845_ce.hw,
 };
 
 static const struct clk_rpmh_desc clk_rpmh_sdm845 = {
-- 
2.25.1

