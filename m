Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC5CFC001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376524AbjJTH50 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376512AbjJTH45 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:57 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA91810C4
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:45 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-0003Fk-50; Fri, 20 Oct 2023 09:56:33 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMx-002yU5-5J; Fri, 20 Oct 2023 09:56:31 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMw-002OI8-Rp; Fri, 20 Oct 2023 09:56:30 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        kernel@pengutronix.de
Subject: [PATCH 01/42] crypto: sun4i-ss - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:23 +0200
Message-ID: <20231020075521.2121571-45-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1967; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=nKuAGPRd9IDUbakhgUR3zbuRL2Z/mtNzL+fNYFvWL9k=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJrlbN4nED8DFSFDKbmQXmsN+TM2rd5sYfHK WeADCwuNFmJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyawAKCRCPgPtYfRL+ TmmmB/9jC9OJ+rT8evX3EHMDJpBwLkmbXx6vbWLHsN0wI4ujr01XuAPKgrsxG09TJvDL7RYhplc 2VxahrX9osG1xEz69gqjU7a5osP2kMW5SrWBWSSRvKB+YtS22IYtY2aQQ9/pjAJbbB1KImf8h8N zON3DmYGo5lK/Yy6L4bPTzFR3PHGoyRDBCKwVEUr4yRYEpWk3G/FwYb9rvIEwuD+8ldfGwTwsFU 6LDiVFajjzfYOvJHRT90/gXAoptvTr16+FmVqofraAd6mScuZOp9GRNgkFmzqEYLKjsKmrhTDeo CJLmt6LC1DpEbGGf/T78qZ+dPgBJ+9yL0ct+p6Py66YTkFBv
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
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 3bcfcfc37084..ba80878e2df5 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -509,7 +509,7 @@ static int sun4i_ss_probe(struct platform_device *pdev)
 	return err;
 }
 
-static int sun4i_ss_remove(struct platform_device *pdev)
+static void sun4i_ss_remove(struct platform_device *pdev)
 {
 	int i;
 	struct sun4i_ss_ctx *ss = platform_get_drvdata(pdev);
@@ -529,7 +529,6 @@ static int sun4i_ss_remove(struct platform_device *pdev)
 	}
 
 	sun4i_ss_pm_exit(ss);
-	return 0;
 }
 
 static const struct of_device_id a20ss_crypto_of_match_table[] = {
@@ -545,7 +544,7 @@ MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
 
 static struct platform_driver sun4i_ss_driver = {
 	.probe          = sun4i_ss_probe,
-	.remove         = sun4i_ss_remove,
+	.remove_new     = sun4i_ss_remove,
 	.driver         = {
 		.name           = "sun4i-ss",
 		.pm		= &sun4i_ss_pm_ops,
-- 
2.42.0

