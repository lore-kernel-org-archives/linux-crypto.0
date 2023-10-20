Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A923CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376469AbjJTH4t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376482AbjJTH4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:42 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86799D61
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:37 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-0003GF-FX; Fri, 20 Oct 2023 09:56:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-002yUR-OK; Fri, 20 Oct 2023 09:56:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMy-002OIf-Eo; Fri, 20 Oct 2023 09:56:32 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@tuxon.dev>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 08/42] crypto: atmel-aes - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:30 +0200
Message-ID: <20231020075521.2121571-52-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1705; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=VG2kxo5PvmaCUx6iOVToUnBggD8T7O7zoLc5JcLrN1I=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJzCu44Az4FtpoXYgaSGmC9VzbpD5M+hicAj ZNHL8DuU2CJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIycwAKCRCPgPtYfRL+ TiM2B/0X/ausX5WpEDoXqaC3dingGqnmSn0WjvARmPjiZxa9awZGxALKGjAwldVErQWn1BtwlfU 7jxZqMBVJkOEhudATmfo7c6PtZvDfC0WT+CcigVfAJKqcmq/RSR0RdVCwIT6GM3ksYZacrQC1x5 vpC/oNTCMRsqzSc60DsoB4ytD32cjK5rFNrR4n5d6/5FzSzApSaKXH+60EfZDa9tm408XfrU7+e WbihKL/NU0VLwCD7KVOpNNFmvvJEfz884gARl2Ebi1Gk7VMKPEdq/WZpl21xj1JTR8Q8maLc42/ cTdEGB2LhC/441QqqUr0PV8ly301tJPy+SY5T1ohUu8KJX+u
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
 drivers/crypto/atmel-aes.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 55b5f577b01c..d1d93e897892 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2648,7 +2648,7 @@ static int atmel_aes_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int atmel_aes_remove(struct platform_device *pdev)
+static void atmel_aes_remove(struct platform_device *pdev)
 {
 	struct atmel_aes_dev *aes_dd;
 
@@ -2667,13 +2667,11 @@ static int atmel_aes_remove(struct platform_device *pdev)
 	atmel_aes_buff_cleanup(aes_dd);
 
 	clk_unprepare(aes_dd->iclk);
-
-	return 0;
 }
 
 static struct platform_driver atmel_aes_driver = {
 	.probe		= atmel_aes_probe,
-	.remove		= atmel_aes_remove,
+	.remove_new	= atmel_aes_remove,
 	.driver		= {
 		.name	= "atmel_aes",
 		.of_match_table = atmel_aes_dt_ids,
-- 
2.42.0

