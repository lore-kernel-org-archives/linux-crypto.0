Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7E5C3DA6F
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Aug 2023 19:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243319AbjHXToC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 15:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243290AbjHXTnc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 15:43:32 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B1A1BE6;
        Thu, 24 Aug 2023 12:43:31 -0700 (PDT)
Received: from dslb-188-097-211-187.188.097.pools.vodafone-ip.de ([188.97.211.187] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qZGEr-0003HB-MF; Thu, 24 Aug 2023 21:43:29 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 3/3] hwrng: ks-sa - use dev_err_probe
Date:   Thu, 24 Aug 2023 21:40:37 +0200
Message-Id: <20230824194037.1575276-4-martin@kaiser.cx>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230824194037.1575276-1-martin@kaiser.cx>
References: <20230824194037.1575276-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace dev_err + return with dev_err_probe.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/ks-sa-rng.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/ks-sa-rng.c b/drivers/char/hw_random/ks-sa-rng.c
index 70d21bf657ce..dff7b9db7044 100644
--- a/drivers/char/hw_random/ks-sa-rng.c
+++ b/drivers/char/hw_random/ks-sa-rng.c
@@ -228,17 +228,14 @@ static int ks_sa_rng_probe(struct platform_device *pdev)
 		syscon_regmap_lookup_by_phandle(dev->of_node,
 						"ti,syscon-sa-cfg");
 
-	if (IS_ERR(ks_sa_rng->regmap_cfg)) {
-		dev_err(dev, "syscon_node_to_regmap failed\n");
-		return -EINVAL;
-	}
+	if (IS_ERR(ks_sa_rng->regmap_cfg))
+		return dev_err_probe(dev, -EINVAL, "syscon_node_to_regmap failed\n");
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0) {
-		dev_err(dev, "Failed to enable SA power-domain\n");
 		pm_runtime_disable(dev);
-		return ret;
+		return dev_err_probe(dev, ret, "Failed to enable SA power-domain\n");
 	}
 
 	return devm_hwrng_register(&pdev->dev, &ks_sa_rng->rng);
-- 
2.39.2

