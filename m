Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6480C001DE
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jul 2023 16:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbjGaQzU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbjGaQzT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2023 12:55:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B6A1998
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jul 2023 09:55:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAk-0006a2-1i; Mon, 31 Jul 2023 18:55:06 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAf-000AQY-St; Mon, 31 Jul 2023 18:55:01 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAe-009NYj-T5; Mon, 31 Jul 2023 18:55:00 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH 2/3] crypto: stm32/hash - Drop if block with always false condition
Date:   Mon, 31 Jul 2023 18:54:55 +0200
Message-Id: <20230731165456.799784-3-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
References: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1139; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=ytR44w6YRN9/39C6QY8fX1uvrs6YC4VRP3jW0CSfK4E=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkx+dbulbrGasJLiVz+QSlpZN4aNuwRTOthCnUy sBwL75kSTuJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZMfnWwAKCRCPgPtYfRL+ TotlCACW/Am2SIw1H/thaOKdb64wke3z0Pp6zVWWJNvJGpJanowdIrFAMxrzcXg9pjiGhMhuzyZ vuKHdeoerW8Alwor3VD/eBFOXvN6w5UH1cc/FbbE3P9qP3H46vR3K+VrapKrrDn6HsN3O1QMDwO Ukc0d97RLSiQ0Im7gZFJIDh9ZjamnKdqEQPf5Kwy99Negw29L7hbfCveYP3d2SvzBoy9PU1YCRG RQtphDBAuo9oVEMn7St+5V+BB14XlB/d265qyMz88zrPy80y/lWkpWI57b3ELXJIny+dIKghWfP SjoWJLt5gQBEPZ2ybOqBa+9ihwtnEf3eDeakwmeLgxnqT9jB
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

stm32_hash_remove() is only called after stm32_hash_probe() succeeded. In
this case platform_set_drvdata() was called with a non-NULL data patameter.

The check for hdev being non-NULL can be dropped because hdev is never NULL
(or something bad like memory corruption happened and then the check
doesn't help any more either).

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/crypto/stm32/stm32-hash.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 75d281edae2a..b10243035584 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -2114,13 +2114,9 @@ static int stm32_hash_probe(struct platform_device *pdev)
 
 static int stm32_hash_remove(struct platform_device *pdev)
 {
-	struct stm32_hash_dev *hdev;
+	struct stm32_hash_dev *hdev = platform_get_drvdata(pdev);
 	int ret;
 
-	hdev = platform_get_drvdata(pdev);
-	if (!hdev)
-		return -ENODEV;
-
 	ret = pm_runtime_get_sync(hdev->dev);
 
 	stm32_hash_unregister_algs(hdev);
-- 
2.39.2

