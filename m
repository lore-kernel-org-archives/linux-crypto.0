Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E35C19F5C
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 07:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376525AbjJTH52 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 03:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376522AbjJTH5D (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 03:57:03 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ECE10CB
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 00:56:46 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkN0-0003Iu-Iy; Fri, 20 Oct 2023 09:56:34 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002yUq-WF; Fri, 20 Oct 2023 09:56:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qtkMz-002OJ3-ND; Fri, 20 Oct 2023 09:56:33 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>, linux-crypto@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH 14/42] crypto: ccp/sp - Convert to platform remove callback returning void
Date:   Fri, 20 Oct 2023 09:55:36 +0200
Message-ID: <20231020075521.2121571-58-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
References: <20231020075521.2121571-44-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1836; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=ayTLlCQMdSbgn6KWLbeMyIN0n7ue0X/qH6AAgjCJYhw=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlMjJ6lDm4n7DEbQO3+piwGfVbcBzo0wfVIOPux 5A+K6wYVD+JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZTIyegAKCRCPgPtYfRL+ Ti6bB/sEthwblxvCnI4YseV4DMqxpzm4x+F9pcQjlVtV6lsHjYoUtG0BWXRsoQVbCShaASO52SF Lb774dxmCCXd4akQGqXyTD6PjMBcEM9urEVUBvXl5+xm7DaQwbKplGbUkVvgKJP7oxf1/hdpw8P WmLfIkjxsT+pdJgpm7+xJy/VabUVl3Y2kY0EV+8Qu/ALKmMxP2HhDpWc5us8rUIT5l2eZgx/YW3 0FZVivNZYgsL9mOGXDCkz11qAGk+N3dgm/xkvo+FdK/A8MgP0wXEn6vHnzfpl8TR2sQqwxaIZ9E Y4cSdY0nExL7GZnqe3uj6+TlMnbHIU8xujA1JWYYXMWCWuPm
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
 drivers/crypto/ccp/sp-platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
index 7d79a8744f9a..473301237760 100644
--- a/drivers/crypto/ccp/sp-platform.c
+++ b/drivers/crypto/ccp/sp-platform.c
@@ -180,7 +180,7 @@ static int sp_platform_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int sp_platform_remove(struct platform_device *pdev)
+static void sp_platform_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct sp_device *sp = dev_get_drvdata(dev);
@@ -188,8 +188,6 @@ static int sp_platform_remove(struct platform_device *pdev)
 	sp_destroy(sp);
 
 	dev_notice(dev, "disabled\n");
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -222,7 +220,7 @@ static struct platform_driver sp_platform_driver = {
 #endif
 	},
 	.probe = sp_platform_probe,
-	.remove = sp_platform_remove,
+	.remove_new = sp_platform_remove,
 #ifdef CONFIG_PM
 	.suspend = sp_platform_suspend,
 	.resume = sp_platform_resume,
-- 
2.42.0

