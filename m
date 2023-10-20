Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CF56CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376516AbjJTH5A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376491AbjJTH4p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:45 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17A1D55
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:42 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-0003KU-F2; Fri, 20 Oct 2023 09:56:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002yV6-SB; Fri, 20 Oct 2023 09:56:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002OJJ-JD; Fri, 20 Oct 2023 09:56:34 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ruan Jinjie <ruanjinjie@huawei.com>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 18/42] crypto: hisilicon/sec - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:40 +0200
Message-ID: <20231020075521.2121571-62-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1850; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=tZ6e+IH+dxUAavTJYzBY4f+9q0LmXpIohCn9zbxKlLA=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ+tJhUUEclQTllz+1kqMKs5wsx2si2oL4X9 APxQIvNf9uJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyfgAKCRCPgPtYfRL+ Tj4mB/9mWXyd4094WuJ9k5smC3HvVlumKMITHmG8QVnOtjNZ/3yVaD932jKvk38fVFPuoKKk3xW snCLtXCeMzdazbi0nPvj37SfIwO2EUV5fP3Ybdv9pkODgEVS00Ce39Y6Riace5JAfGsoaPE5+tx qqMBbWbG01oYtdncVul8+W2ubdwqtlVzwC3BUCfpmvq1q/S79LK0SXxoMV6T1LLPUERB0zzj01U sLIkNg9wrjzNTyspwjpmzs6mvmh88m5irh1jCJQlzkQ4UggV6PvEilaDJaYUjH3LWHY9EV//w/k n67y+U+GJbcz8WFjQld3zf46ztHow4uefNGUChryPfnTs7es
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
 drivers/crypto/hisilicon/sec/sec_drv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index e1e08993de12..afdddf87cc34 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -1271,7 +1271,7 @@ static int sec_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int sec_remove(struct platform_device *pdev)
+static void sec_remove(struct platform_device *pdev)
 {
 	struct sec_dev_info *info = platform_get_drvdata(pdev);
 	int i;
@@ -1287,8 +1287,6 @@ static int sec_remove(struct platform_device *pdev)
 	}
 
 	sec_base_exit(info);
-
-	return 0;
 }
 
 static const __maybe_unused struct of_device_id sec_match[] = {
@@ -1306,7 +1304,7 @@ MODULE_DEVICE_TABLE(acpi, sec_acpi_match);
 
 static struct platform_driver sec_driver = {
 	.probe = sec_probe,
-	.remove = sec_remove,
+	.remove_new = sec_remove,
 	.driver = {
 		.name = "hisi_sec_platform_driver",
 		.of_match_table = sec_match,
-- 
2.42.0

