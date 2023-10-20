Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B8CC07480
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376498AbjJTH5A (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376495AbjJTH4r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:47 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3A3114
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:43 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN4-0003L4-F3; Fri, 20 Oct 2023 09:56:38 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN1-002yVA-22; Fri, 20 Oct 2023 09:56:35 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-002OJN-PF; Fri, 20 Oct 2023 09:56:34 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Weili Qian <qianweili@huawei.com>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 19/42] crypto: hisilicon/trng - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:41 +0200
Message-ID: <20231020075521.2121571-63-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2002; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=f5rGnK44f5rPCAkQOF5xAJph5SYzt3jk1ac1yBHvcLg=; b=owGbwMvMwMXY3/A7olbonx/jabUkhlQjo3oH8yX+PUbGnp7GUVuKWBdzhDveWxDt3hkX03f6s +LKSbqdjMYsDIxcDLJiiiz2jWsyrarkIjvX/rsMM4iVCWQKAxenAExEIJH9v7fC0TrGbTtXKsTY 6Rav7s4JMnGvju89KF3f9UNgOqfF/8jfHdlZzikOatut77emq95VDdoz9VKCcuRjpj8TRQ37fl5 heqjCHDJ3I+vr4ievnUxMrx/dGy7q9uHQ6qlGyUVmlmla9bqebKfmPIm8Iv4kzVWtUHZFepfiTs +wuYdbVhbxbF00ufiFHrvL0oc/1KYXRnPU73+Tv0KLb9fO178FZ7FPWO/WuiY6/dnEbf3bxTKW2 rOV/knv3vpCd5aOpZj8ut6k0DcHdubuS3z26ePMQzoz5k6LCY6YLppkO4+9ZJL3gzOTr8hlpDzb 0ZvLrXY4wtrK9Fy2/Jbbu1e1m3BVFK6bmjBN7ODbVdHdAA==
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
 drivers/crypto/hisilicon/trng/trng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/hisilicon/trng/trng.c b/drivers/crypto/hisilicon/trng/trng.c
index 97e500db0a82..451b167bcc73 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -303,7 +303,7 @@ static int hisi_trng_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int hisi_trng_remove(struct platform_device *pdev)
+static void hisi_trng_remove(struct platform_device *pdev)
 {
 	struct hisi_trng *trng = platform_get_drvdata(pdev);
 
@@ -314,8 +314,6 @@ static int hisi_trng_remove(struct platform_device *pdev)
 	if (trng->ver != HISI_TRNG_VER_V1 &&
 	    atomic_dec_return(&trng_active_devs) == 0)
 		crypto_unregister_rng(&hisi_trng_alg);
-
-	return 0;
 }
 
 static const struct acpi_device_id hisi_trng_acpi_match[] = {
@@ -326,7 +324,7 @@ MODULE_DEVICE_TABLE(acpi, hisi_trng_acpi_match);
 
 static struct platform_driver hisi_trng_driver = {
 	.probe		= hisi_trng_probe,
-	.remove         = hisi_trng_remove,
+	.remove_new     = hisi_trng_remove,
 	.driver		= {
 		.name	= "hisi-trng-v2",
 		.acpi_match_table = ACPI_PTR(hisi_trng_acpi_match),
-- 
2.42.0

