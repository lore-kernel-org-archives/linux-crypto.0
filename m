Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6928C001DF
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jul 2023 07:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbjGMHGt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jul 2023 03:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbjGMHGm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jul 2023 03:06:42 -0400
Received: from viti.kaiser.cx (viti.kaiser.cx [IPv6:2a01:238:43fe:e600:cd0c:bd4a:7a3:8e9f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E17199D;
        Thu, 13 Jul 2023 00:06:40 -0700 (PDT)
Received: from 74.172.62.81.static.wline.lns.sme.cust.swisscom.ch ([81.62.172.74] helo=martin-debian-2.paytec.ch)
        by viti.kaiser.cx with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <martin@kaiser.cx>)
        id 1qJqPM-0004KN-Kp; Thu, 13 Jul 2023 09:06:36 +0200
From:   Martin Kaiser <martin@kaiser.cx>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     olivier@sobrie.be, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 2/3] hwrng: ba431 - don't init of_device_id's data
Date:   Thu, 13 Jul 2023 09:04:45 +0200
Message-Id: <20230713070446.230978-3-martin@kaiser.cx>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230713070446.230978-1-martin@kaiser.cx>
References: <20230713070446.230978-1-martin@kaiser.cx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We have no device-specific data for silex-insight,ba431-rng. There's no
need to set .data = NULL, this is the default.

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
---
 drivers/char/hw_random/ba431-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ba431-rng.c b/drivers/char/hw_random/ba431-rng.c
index b1518dd52a24..d2a9d16323a6 100644
--- a/drivers/char/hw_random/ba431-rng.c
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -201,7 +201,7 @@ static int ba431_trng_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id ba431_trng_dt_ids[] = {
-	{ .compatible = "silex-insight,ba431-rng", .data = NULL },
+	{ .compatible = "silex-insight,ba431-rng" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, ba431_trng_dt_ids);
-- 
2.30.2

