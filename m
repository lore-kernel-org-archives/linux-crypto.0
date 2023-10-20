Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECE9C004C0
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376488AbjJTH4n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376467AbjJTH4l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:41 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E61D6D
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-0003JR-EA; Fri, 20 Oct 2023 09:56:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002yUy-Dk; Fri, 20 Oct 2023 09:56:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002OJB-4Z; Fri, 20 Oct 2023 09:56:34 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 16/42] crypto: exynos-rng - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:38 +0200
Message-ID: <20231020075521.2121571-60-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1707; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=UacrIPwaulEYZNHEF3e9yLVdfE5LSigzPahDQNQWQ9c=; b=owGbwMvMwMXY3/A7olbonx/jabUkhlQjo5pde1N92UKyW6rnXw0vejNlt0tSkl7JL4fkTJGip Qnbpkh0MhqzMDByMciKKbLYN67JtKqSi+xc++8yzCBWJpApDFycAjCRE2zsf6Xn9l/co8dgNiE2 W3Xi1Pnxs24uOby0MVROt3LuG/WeUB3L/z7sJzj2+Vxof2r9I4lnQl5l3/vPPrcCDuxecoWHyWD vmQrn7XXV2RuipJ2fZBatlu8UL07WeiIZ/vnE1Ek9i6PV9my7vHjRvQNTZG44cM+uWCK4IlRUVN DkZ8A6Ax6vYO9QrYIw4exz57bEvHU8v8C3kb3lgPcpg8oQdpatXt+yttgqNym/y1xnUG7/3v/e2 udnI5/odZ+/o8ijmnT5pNmRoxWvWFLr99vvNu4/7l1j+ZYtktNHqrq5WttZeJuXwC/Fq3bba7as mbnJmsXtH8PBuhfyj7Kswt72SG2bJhPGs+R7JEveP+MPAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/exynos-rng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
index 5d60a4bcb511..0dd8baf16cb4 100644
--- a/drivers/crypto/exynos-rng.c
+++ b/drivers/crypto/exynos-rng.c
@@ -306,13 +306,11 @@ static int exynos_rng_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int exynos_rng_remove(struct platform_device *pdev)
+static void exynos_rng_remove(struct platform_device *pdev)
 {
 	crypto_unregister_rng(&exynos_rng_alg);
 
 	exynos_rng_dev = NULL;
-
-	return 0;
 }
 
 static int __maybe_unused exynos_rng_suspend(struct device *dev)
@@ -391,7 +389,7 @@ static struct platform_driver exynos_rng_driver = {
 		.of_match_table = exynos_rng_dt_match,
 	},
 	.probe		= exynos_rng_probe,
-	.remove		= exynos_rng_remove,
+	.remove_new	= exynos_rng_remove,
 };
 
 module_platform_driver(exynos_rng_driver);
-- 
2.42.0

