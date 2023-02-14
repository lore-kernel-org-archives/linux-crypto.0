Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E942FC61DA4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 16:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjBNQ3B (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 11:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBNQ3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 11:29:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BFB2310C
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 08:28:55 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAk-0007T3-Cd; Tue, 14 Feb 2023 17:28:50 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAh-004v9c-Ha; Tue, 14 Feb 2023 17:28:48 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAh-003WdU-NX; Tue, 14 Feb 2023 17:28:47 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 3/3] hwrng: xgene - Improve error reporting for problems during .remove()
Date:   Tue, 14 Feb 2023 17:28:29 +0100
Message-Id: <20230214162829.113148-4-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
References: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=925; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=PjWIM9Lsfu0YcMuZQ80fU/9ZSI4Cgm2a0fAuurNww64=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBj67aoPdLglbDwvfB0j1NW8FNdARIZNu9oKc9OK K1va6QnrKCJATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY+u2qAAKCRDB/BR4rcrs CfCwB/0S0mf2y5bKJasCwpjE7zxf0zFzFBpeu+U45r5ktuU7Q6eJqnXkp2r6wK7a5BNJs9UlCCX IR05iptRZQxV/xfkDUC18srDCID9f+dXetPoo0JNX7LMnrdDM+HLni4TsH+IKc7QcJKDgQcI99M uowQ5/XJmdZGSy+tauHlGn08BLW7k99Och4Snsnat4sVe9wL/wd+8g9vmYt604glyvj+ZtJIHxD 1UztRK7Y1hp1HU/WOXgUwCQLcRo0gt4oBbRSi9lkFwtXuSOelObAhG/C0e9cweArja2XZ7quWU9 1iuBcwH6WfkPV398hgH4ytPkU4B0atdUVNguV4QeH/FACUCQ
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Returning an error value in a platform driver's remove callback results in
a generic error message being emitted by the driver core, but otherwise it
doesn't make a difference. The device goes away anyhow.

As the driver already emits a better error message than the core, suppress
the generic error message by returning zero unconditionally.
---
 drivers/char/hw_random/xgene-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/xgene-rng.c b/drivers/char/hw_random/xgene-rng.c
index 31662614a48f..c67d3185b5b6 100644
--- a/drivers/char/hw_random/xgene-rng.c
+++ b/drivers/char/hw_random/xgene-rng.c
@@ -366,7 +366,7 @@ static int xgene_rng_remove(struct platform_device *pdev)
 	if (rc)
 		dev_err(&pdev->dev, "RNG init wakeup failed error %d\n", rc);
 
-	return rc;
+	return 0;
 }
 
 static const struct of_device_id xgene_rng_of_match[] = {
-- 
2.39.1

