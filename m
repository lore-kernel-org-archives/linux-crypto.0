Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8536FC001DF
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 20:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbjGJU3i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 16:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbjGJU3e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 16:29:34 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2642195;
        Mon, 10 Jul 2023 13:29:29 -0700 (PDT)
Received: from 250.57.4.146.static.wline.lns.sme.cust.swisscom.ch ([146.4.57.250] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qIxVf-0002mg-1g; Mon, 10 Jul 2023 22:29:27 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     aric.pzqi@ingenic.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 3/7] hwrng: ingenic - remove dead assignments
Date:   Mon, 10 Jul 2023 22:27:29 +0200
Message-Id: <20230710202733.116133-4-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230710202733.116133-1-martin@kaiser.cx>
References: <20230710202733.116133-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Don't assign a value to ret if we're about to return from the probe
function and ret's value is not used.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/ingenic-trng.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/hw_random/ingenic-trng.c b/drivers/char/hw_random/ingenic-trng.c
index 64286cbdf158..bfec28ceab00 100644
--- a/drivers/char/hw_random/ingenic-trng.c
+++ b/drivers/char/hw_random/ingenic-trng.c
@@ -86,13 +86,11 @@ static int ingenic_trng_probe(struct platform_device *pdev)
 	trng->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(trng->base)) {
 		pr_err("%s: Failed to map DTRNG registers\n", __func__);
-		ret = PTR_ERR(trng->base);
 		return PTR_ERR(trng->base);
 	}
 
 	trng->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(trng->clk)) {
-		ret = PTR_ERR(trng->clk);
 		pr_crit("%s: Cannot get DTRNG clock\n", __func__);
 		return PTR_ERR(trng->clk);
 	}
-- 
2.30.2

