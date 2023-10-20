Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377E3CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376574AbjJTH5R (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376481AbjJTH44 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:56:56 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFCCD79
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:44 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN3-0003Qd-Ku; Fri, 20 Oct 2023 09:56:37 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002yVf-Ql; Fri, 20 Oct 2023 09:56:36 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN2-002OJt-HX; Fri, 20 Oct 2023 09:56:36 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH 27/42] crypto: mxs-dcp - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:49 +0200
Message-ID: <20231020075521.2121571-71-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1804; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=euiLVQrUUXCOfCIx3yamKs26fh4H9DHuPQAvDF0cDww=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjKIe9EuOxceKf3mTup3FOp9F3FwD/STwHdKC 1EDcX4AGOKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyiAAKCRCPgPtYfRL+ TmlzB/9gJk8y36NTUUzciGQPyj+/VCpLmi3nzzIl19e67hqbo90JYWcPtCzq9TxmCeAScyxK4kf LdsQBigCwEZVhsXa8vvsEIx2xLgPETYULvGjOPNgi8WzWhSZGtmLOo763fFy3FN3hkyhe/j+6WC TphMd7yrn005uCqT2FS37/C/KgGZZ/kBLCoUGoqoOBIWg772TQJvx+93CAGIPB4izPv48O4AzZv e3zoXQTxlRe3aIGF2131M2u4nSj+Sxe/UgwO1PwEilQHGU6vRPFmzJh4yJIKVwMz2w3A8D8Srkh ji/RmtKSVRs3kg9TMFtYb7PlbK7EFJlq9rzXLTkh2lSy5Tvj
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
 drivers/crypto/mxs-dcp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index f6b7bce0e656..d41efddbc772 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -1131,7 +1131,7 @@ static int mxs_dcp_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int mxs_dcp_remove(struct platform_device *pdev)
+static void mxs_dcp_remove(struct platform_device *pdev)
 {
 	struct dcp *sdcp = platform_get_drvdata(pdev);
 
@@ -1150,8 +1150,6 @@ static int mxs_dcp_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 
 	global_sdcp = NULL;
-
-	return 0;
 }
 
 static const struct of_device_id mxs_dcp_dt_ids[] = {
@@ -1164,7 +1162,7 @@ MODULE_DEVICE_TABLE(of, mxs_dcp_dt_ids);
 
 static struct platform_driver mxs_dcp_driver = {
 	.probe	= mxs_dcp_probe,
-	.remove	= mxs_dcp_remove,
+	.remove_new = mxs_dcp_remove,
 	.driver	= {
 		.name		= "mxs-dcp",
 		.of_match_table	= mxs_dcp_dt_ids,
-- 
2.42.0

