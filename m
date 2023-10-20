Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A254AC25B46
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376471AbjJTH5V (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376510AbjJTH45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A850310C0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-0003Oc-JE; Fri, 20 Oct 2023 09:56:37 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002yVc-Jk; Fri, 20 Oct 2023 09:56:36 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002OJo-AO; Fri, 20 Oct 2023 09:56:36 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 26/42] crypto: marvell/cesa - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:48 +0200
Message-ID: <20231020075521.2121571-70-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1922; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=6/mekkNftzwudJnDp+ayKGLUFukuF70iCc+RyTfGCl0=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKH35mmK2h6c1THNe+mOklYN8Fa9bAn2mWcV NkPQImQ4WuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyhwAKCRCPgPtYfRL+ TkLMB/9DybuzvkODxPD+8OYynFZIS065cMgS7OBEMR/pWgy4BJxEahhtgCBO7XFncrnq5vM+ES3 Q6UGA4XEH/IJst7ok7+YdXwOJHN91fbk5AUSeiZXK+EeaUvEWPvvR0/Pw36dQO32p77OnR15JGV QCni/bG27Zbu9S69/G3LP8LgFzmI62TbyvmQ9TE5FHin37a6Ta/LRAGn8m0rwy9bchruM02JvB+ pZr9OPcHc4371yUTTy6leKw7hDIEklkyNMtLZRYtsfooTkTGgl8YqOt2YbmgyYSJrUUNOsMUIBO H0Yb5hmufbkB0zx7nSUvZyZADxyg/FcD9flt4yRsADpQC/8b
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
 drivers/crypto/marvell/cesa/cesa.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index b61e35b932e5..5744df30c838 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -581,7 +581,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int mv_cesa_remove(struct platform_device *pdev)
+static void mv_cesa_remove(struct platform_device *pdev)
 {
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
 	int i;
@@ -594,8 +594,6 @@ static int mv_cesa_remove(struct platform_device *pdev)
 		mv_cesa_put_sram(pdev, i);
 		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
 	}
-
-	return 0;
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
@@ -606,7 +604,7 @@ MODULE_DEVICE_TABLE(platform, mv_cesa_plat_id_table);
 
 static struct platform_driver marvell_cesa = {
 	.probe		= mv_cesa_probe,
-	.remove		= mv_cesa_remove,
+	.remove_new	= mv_cesa_remove,
 	.id_table	= mv_cesa_plat_id_table,
 	.driver		= {
 		.name	= "marvell-cesa",
-- 
2.42.0

