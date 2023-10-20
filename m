Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B46C25B40
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376486AbjJTH6K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376540AbjJTH5P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:15 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4E510DD
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:53 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN7-0003lJ-Sq; Fri, 20 Oct 2023 09:56:41 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN6-002yWc-77; Fri, 20 Oct 2023 09:56:40 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002OKw-U2; Fri, 20 Oct 2023 09:56:39 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Harsha <harsha.harsha@amd.com>,
        Michal Simek <michal.simek@amd.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 42/42] crypto: xilinx/zynqmp-sha - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:56:04 +0200
Message-ID: <20231020075521.2121571-86-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1813; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=gPYZkWjMK0YxXdO6vFAwk9bH3uOIfVA2GNcUWtwIS9E=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKavbyAfJWtCTmFH9OnlFdpVDIp9hZVyUk5i 3oJf7qoxKOJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIymgAKCRCPgPtYfRL+ Tm5RB/sFV9x720XRP/6h3js75u1CIlO68Ioy+hhnxnoB3xldi4/8V4mz2regS7tOz/6f+oNSnju V2DpemkhgJN90/MZWlTVXvnqq9kI+599iq6PdSGyK1Dh5FK9Xzo99j+o8XqrqpuRu7sHfo3wfTt 9Min/B+qO53mHb0i1NbJJOhcauBnNgwnSKKkuRWFvgUKPOzTt89vooadlQWVpD1AApUZukrsgE/ RhRlo5eyhFlIHNvbGuChjTe2uxv7yL7OvyOPcoPu2HrVqcGoL6+KmAEuhIyZpiQdzRDVqFfLhLw 6+P2hwiAp+w/KFAFMbmYh7M6a4ocRG3oy93t4VdusbU7Bzkl
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
 drivers/crypto/xilinx/zynqmp-sha.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-sha.c b/drivers/crypto/xilinx/zynqmp-sha.c
index 426bf1a72ba6..e6c45ceb4bf7 100644
--- a/drivers/crypto/xilinx/zynqmp-sha.c
+++ b/drivers/crypto/xilinx/zynqmp-sha.c
@@ -238,20 +238,18 @@ static int zynqmp_sha_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int zynqmp_sha_remove(struct platform_device *pdev)
+static void zynqmp_sha_remove(struct platform_device *pdev)
 {
 	sha3_drv_ctx.dev = platform_get_drvdata(pdev);
 
 	dma_free_coherent(sha3_drv_ctx.dev, ZYNQMP_DMA_ALLOC_FIXED_SIZE, ubuf, update_dma_addr);
 	dma_free_coherent(sha3_drv_ctx.dev, SHA3_384_DIGEST_SIZE, fbuf, final_dma_addr);
 	crypto_unregister_shash(&sha3_drv_ctx.sha3_384);
-
-	return 0;
 }
 
 static struct platform_driver zynqmp_sha_driver = {
 	.probe = zynqmp_sha_probe,
-	.remove = zynqmp_sha_remove,
+	.remove_new = zynqmp_sha_remove,
 	.driver = {
 		.name = "zynqmp-sha3-384",
 	},
-- 
2.42.0

