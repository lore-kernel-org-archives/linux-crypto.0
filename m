Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D73A4C63697
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FBE7216C4
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Nov 2020 13:47:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xNK2Dv0l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387731AbgKQNr0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387730AbgKQNrY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Nov 2020 08:47:24 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26506C061A4E
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 05:47:24 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id n132so20352865qke.1
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2020 05:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H9iD0vb59nEfd0VuYA1RFQfZKltqvw1+ddifT0t8kKQ=;
        b=xNK2Dv0l/RS6jOxorOPlj4wF5Hm9Kcn7P3JHnJx5slQTGiKq12OhEu+qhyEOErdJrX
         r8W6lPr8C1hJTJB2I/ZbVk5aXKQAZeeid7tFVdhxEEaQgIm4EKzktFnMbPYnbAZzLMJV
         R+EHgazzvJT+Sln0/q2Tc6mBjWdqQBV/P9HW0uP0vP4q20NXnOQG6QsRqK18D5KURi/j
         KadLP6sU4ITKWQJNdLj00TPPMUQ+VTqC8B//eO0dcoccI0GAqxcF7EZEdOEqpTcQrWmn
         c/0ULiqzsBXaaLqflVUpUwWklJUmLthVs9ORrZ+3M/Tb/zrogNaKjNiaR0nta/JDuO+r
         O2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H9iD0vb59nEfd0VuYA1RFQfZKltqvw1+ddifT0t8kKQ=;
        b=pfprahnQPX6rwH+pshiAP6Zwe/eiJc1tvoWeIHkMrVQfIQjziJEgReObzUu1FLoqg9
         FiNkIUVL+pR+SrhC5Xd+yiERnTOngpthSTrFpMB8SNDGHCaZ8pZ+cLo4jwYkbfx96d3i
         nlyjD9+EqMPnh3iWxtsbwDGinzP4CdVWGl8pfjqxLgaj8sHvIxR0o5jFD/XacPKYXf+r
         yknN/cc3hqFS/acml5/hoBIkEg1kVbVUDRRK0ZtYYFWnuF4ZBOi3LV7DCz70Xy0kn6aH
         da4l70bUEH6u3005bDgdvb7+upC/zKmtinb4s72On0dWqk+9VL2L2S4aIvPmIdaD1I35
         J1cw==
X-Gm-Message-State: AOAM532pTAyAJK5AzmBZrmibWDddk13SnzV9l4ho/OU2Y35O4mIeh+g6
        RQdQJKpwl4KWn70l/IeYvKiEUg==
X-Google-Smtp-Source: ABdhPJyptcWBVT5M2++jj9hPPhmMcL9cKttwWytv2NLfLJoew0OcWZWypoNx+gJzkYTRIn3Tq13U9Q==
X-Received: by 2002:a37:b782:: with SMTP id h124mr20237761qkf.169.1605620843333;
        Tue, 17 Nov 2020 05:47:23 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id t133sm14607355qke.82.2020.11.17.05.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 05:47:22 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH 6/6] devicetree:bindings:crypto: Extend qcom-qce binding to add support for crypto engine version 5.4
Date:   Tue, 17 Nov 2020 08:47:14 -0500
Message-Id: <20201117134714.3456446-7-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201117134714.3456446-1-thara.gopinath@linaro.org>
References: <20201117134714.3456446-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add compatible string to support v5.4 crypto engine.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
index fdd53b184ba8..ed1ede9c0acc 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.txt
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
@@ -2,7 +2,9 @@ Qualcomm crypto engine driver
 
 Required properties:
 
-- compatible  : should be "qcom,crypto-v5.1"
+- compatible  : should be
+		"qcom,crypto-v5.1" for ipq6018
+		"qcom,crypto-v5.4" for sdm845
 - reg         : specifies base physical address and size of the registers map
 - clocks      : phandle to clock-controller plus clock-specifier pair
 - clock-names : "iface" clocks register interface
-- 
2.25.1

