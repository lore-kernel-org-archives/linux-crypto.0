Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9BDCDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376532AbjJTH5w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376534AbjJTH5O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:14 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB3110D0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:48 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN7-0003jz-P1; Fri, 20 Oct 2023 09:56:41 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002yWX-Vu; Fri, 20 Oct 2023 09:56:40 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN5-002OKs-MM; Fri, 20 Oct 2023 09:56:39 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Michal Simek <michal.simek@amd.com>, Rob Herring <robh@kernel.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 41/42] crypto: xilinx/zynqmp-aes-gcm - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:56:03 +0200
Message-ID: <20231020075521.2121571-85-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1840; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=0YRy5Ck9WqwgT+T3cQ0SSqnxHXNP9TuQevedBOzuzmo=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKZYvpdWKPb0uyCmT5Xuo9ssI948P0gOD91Z BZnMmKTk7qJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIymQAKCRCPgPtYfRL+ TlDwB/9zDv8PO7osS/f9v5m4dzkXzb7PW6XopRyyCXRIrh+jsvD9y+COPVzh8Od748qHIChpuyF AyjZMTBDKElLk1R+4jgrkSnEGhFVtWbXtK05/PvBFlM0JVm70AH94Lp/QpOSMw9Ci2Wv079W3TE LAu6ummya13aJqeBDv2Rsij3CHvn3a+GaD6v86ILC0JUY0wgpn4r+eLEJMIZltijnUIoFKApApA 6gaT2Ehd4tRhKB/FHVt9lHSIIBfO0zB7jLMvt749xYmcSq/ZA1bJ32oALQ8mMJuIsWx5AoPuaNg G7FpRz0rS41FzuCmgk/iPrfCwvzEnoETqThNbT68/NjPo1e8
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
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index ce335578b759..3c205324b22b 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -421,12 +421,10 @@ static int zynqmp_aes_aead_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int zynqmp_aes_aead_remove(struct platform_device *pdev)
+static void zynqmp_aes_aead_remove(struct platform_device *pdev)
 {
 	crypto_engine_exit(aes_drv_ctx.engine);
 	crypto_engine_unregister_aead(&aes_drv_ctx.alg.aead);
-
-	return 0;
 }
 
 static const struct of_device_id zynqmp_aes_dt_ids[] = {
@@ -437,7 +435,7 @@ MODULE_DEVICE_TABLE(of, zynqmp_aes_dt_ids);
 
 static struct platform_driver zynqmp_aes_driver = {
 	.probe	= zynqmp_aes_aead_probe,
-	.remove = zynqmp_aes_aead_remove,
+	.remove_new = zynqmp_aes_aead_remove,
 	.driver = {
 		.name		= "zynqmp-aes",
 		.of_match_table = zynqmp_aes_dt_ids,
-- 
2.42.0

