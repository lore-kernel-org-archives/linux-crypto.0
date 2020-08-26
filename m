Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 834CEC433E3
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 16:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 536E920825
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 16:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598459425;
	bh=r7Vp/eVDXlcODkpEM7XJbFBXBlDYqAsaBZjmk94rYt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HdpELvO4EoHXwf7v6yx1Vz67XFjk9Y91CAD/pvzP+cCfYUtgJXg0OJcwWeycKfZaS
	 aLIh/i6jYF4xxtyRrRej2h/bIdrwk/xQ7Peb8PkJv2hSShny0dixOUuhDisGlB+Z5D
	 HwMZnOEsmcazyVVFrES/nbn4teHuYTFw5NUeb1u8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgHZQaX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 12:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgHZQaF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 12:30:05 -0400
Received: from localhost.localdomain (unknown [194.230.155.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A60D02074A;
        Wed, 26 Aug 2020 16:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598459405;
        bh=r7Vp/eVDXlcODkpEM7XJbFBXBlDYqAsaBZjmk94rYt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLI8s9HCKZF7PUkLKePWDqdTYTXjpnjYzcpnYeIuiZaeYwl8DyzQQEkr2Njb2SnFb
         V+rrdrN38xQD6FZuIrWiMgFqzuJfuh569MSYkIGQNZiw1tpy1p/kjelFxzalRGVg3i
         7jJCD1wT8TmIIyoWybUf1VoxEWoABDkEWk9bUfO0=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/3] crypto: ccree - Simplify with dev_err_probe()
Date:   Wed, 26 Aug 2020 18:29:54 +0200
Message-Id: <20200826162954.28636-3-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200826162954.28636-1-krzk@kernel.org>
References: <20200826162954.28636-1-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Common pattern of handling deferred probe can be simplified with
dev_err_probe().  Less code and also it prints the error value.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/ccree/cc_driver.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index 2d50991b9a17..6f519d3e896c 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -300,11 +300,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	new_drvdata->plat_dev = plat_dev;
 
 	clk = devm_clk_get_optional(dev, NULL);
-	if (IS_ERR(clk)) {
-		if (PTR_ERR(clk) != -EPROBE_DEFER)
-			dev_err(dev, "Error getting clock: %pe\n", clk);
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "Error getting clock\n");
 	new_drvdata->clk = clk;
 
 	new_drvdata->coherent = of_dma_is_coherent(np);
-- 
2.17.1

