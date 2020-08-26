Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC753C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 15:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7FCF208E4
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 15:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598455999;
	bh=vVqjzCOh+/tzkusGVweW2Ls2+a6FFfIhNB9EcG+IeYY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=DqPCuVJBJhyEcUgj3/FgparrjCpK0sEIpyoPS8CY/EzsFq02FYcERhLnefdsLUrcT
	 lOrOwASCS3jnKF3+WSiaaoVTEDVM4wtjjkYzhD1aVO6Obk+FT+k3+d59r/TSZw72XV
	 B9lhHVFNCiVhawcKkckRJYo0CYjknjUFuacMpzQE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHZPdT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 11:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbgHZPdS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 11:33:18 -0400
Received: from localhost.localdomain (unknown [194.230.155.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 641CB2078A;
        Wed, 26 Aug 2020 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598455998;
        bh=vVqjzCOh+/tzkusGVweW2Ls2+a6FFfIhNB9EcG+IeYY=;
        h=From:To:Cc:Subject:Date:From;
        b=eQDUm+v7tGSDNMaHk1t7HThMfJN82m75NJdlouLlWb6uE/Wb4lpzPfxHB1ZWiGgUn
         az28ypH6e4CLHEDpcs9IQtWiFcgL3mM6g6AxsML9p3bOgSCN7tc/7ywDhWafFtSpz6
         fJvPhXBVbDZ95gRFWQkkejUtHLsRjwgqpsCCtcUE=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Hadar Gat <hadar.gat@arm.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] hwrng: cctrn - Simplify with dev_err_probe()
Date:   Wed, 26 Aug 2020 17:32:33 +0200
Message-Id: <20200826153233.27586-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Common pattern of handling deferred probe can be simplified with
dev_err_probe().  Less code and also it prints the error value.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/char/hw_random/cctrng.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index 619148fb2dc9..7a293f2147a0 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -463,11 +463,10 @@ static int cc_trng_clk_init(struct cctrng_drvdata *drvdata)
 	int rc = 0;
 
 	clk = devm_clk_get_optional(dev, NULL);
-	if (IS_ERR(clk)) {
-		if (PTR_ERR(clk) != -EPROBE_DEFER)
-			dev_err(dev, "Error getting clock: %pe\n", clk);
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk),
+				     "Error getting clock\n");
+
 	drvdata->clk = clk;
 
 	rc = clk_prepare_enable(drvdata->clk);
-- 
2.17.1

