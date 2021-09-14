Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB7DC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 14:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86B256109E
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Sep 2021 14:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhINO0K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Sep 2021 10:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbhINO0J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Sep 2021 10:26:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66519C061574
        for <linux-crypto@vger.kernel.org>; Tue, 14 Sep 2021 07:24:52 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mQ9Me-0005tr-P1; Tue, 14 Sep 2021 16:24:48 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mQ9MQ-0006Yy-LX; Tue, 14 Sep 2021 16:24:34 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mQ9MQ-0007OM-Jj; Tue, 14 Sep 2021 16:24:34 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, kernel@pengutronix.de
Subject: [PATCH] hwrng: meson - Improve error handling for core clock
Date:   Tue, 14 Sep 2021 16:24:28 +0200
Message-Id: <20210914142428.57099-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=9tz2phqeN+3GzCEXz8gh5AQWNocdSF32iWo28yTN+xs=; m=cX96ziEeAkJuDb6P9w+CtfXmQzh9pdqI3yrnaxyU0x0=; p=aUBlnzWgqmE/spp/etZnspgE0aeuWMQfhI4MUcyEZ7k=; g=b60f7d99182caa434b62de00dd624961cea91849
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFAsJQACgkQwfwUeK3K7AlrTQf8CZp M/xfs12DybnVzDWGfGTbDxvXLsNJ7yMwTHa6A/aUq8y5vEEQd8J1WN+DD18dQpQueEq1BOFg6qkfq 4BL/ETsC4954HMsYibwrFQIBA0pYpJbPuq6iaFJ97g31M4WJmgDv/IouXp9b2EFvcLLan1M6l1UuY LKjJsRPqMPWYmJCADVziMOdCVn+54tH7YPCHTLOMdqHWlzuS+YBwbZGHC1Ve8lwnCFhVtILp1hxt9 PMvFEgEeE0hL73EuJmZzaUb5Ru049iTsgR6ben139Qd7igImWSITtUoRkwbBQMtJgpcQZkQYThM7I M17hZa2EKgpE9YHCQpew2ugSuhi2GsA==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

-ENOENT (ie. "there is no clock") is fine to ignore for an optional
clock, other values are not supposed to be ignored and should be
escalated to the caller (e.g. -EPROBE_DEFER). Ignore -ENOENT by using
devm_clk_get_optional().

While touching this code also add an error message for the fatal errors.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/char/hw_random/meson-rng.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index e446236e81f2..9f3e2eb8011d 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -54,9 +54,15 @@ static int meson_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	data->core_clk = devm_clk_get(dev, "core");
-	if (IS_ERR(data->core_clk))
-		data->core_clk = NULL;
+	data->core_clk = devm_clk_get_optional(dev, "core");
+	if (IS_ERR(data->core_clk)) {
+		ret = PTR_ERR(data->core_clk);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "Failed to get core clock: %pe\n",
+				data->core_clk);
+
+		return ret;
+	}
 
 	if (data->core_clk) {
 		ret = clk_prepare_enable(data->core_clk);
-- 
2.30.2

