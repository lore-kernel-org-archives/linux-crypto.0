Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6BEC433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 07:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E98960F48
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 07:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhITHpo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 03:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233958AbhITHpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 03:45:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C6FC061760
        for <linux-crypto@vger.kernel.org>; Mon, 20 Sep 2021 00:44:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mSDyH-0005Z1-3J; Mon, 20 Sep 2021 09:44:13 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mSDyB-0006I1-Up; Mon, 20 Sep 2021 09:44:07 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mSDyB-0003GO-Te; Mon, 20 Sep 2021 09:44:07 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH v2] hwrng: meson - Improve error handling for core clock
Date:   Mon, 20 Sep 2021 09:44:05 +0200
Message-Id: <20210920074405.252477-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=9tz2phqeN+3GzCEXz8gh5AQWNocdSF32iWo28yTN+xs=; m=cX96ziEeAkJuDb6P9w+CtfXmQzh9pdqI3yrnaxyU0x0=; p=suObcorQD7ed5z2ooAXD8XsNDOU1xSrXgnghM0cQMIo=; g=768da396a3457f83adc357a91eec69259edb1cd1
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFIOx8ACgkQwfwUeK3K7AnlGAf+KXe TSs5rrw7D8qxHbKDoi1ko2oXWIpazMMa4tZAhN3jY5JRqeFAwFkVljJALT8c03j5ylsbOgv+pQdxZ o5/MJqVr+wRetKulUJcDKc9JIzac8aA0dN0FTlF7/ZCBEnICh+BhtP4MXWD8OiyVAsS6L8y077DIb rNXmQFKLJ8j7ckNB39vsRia44FnL9omWskX93xZduLrcvJtOoPOGNtma6s1pZtP1J4RQHiRlP2Kau VShxiWEpxgDHeL9MpsP1PdN2kfEFXqYWusn8qAcII2gsZZV+hXIzbPlFXaCDJoBtd0WbO5bsDTno9 P0NRaxJxuQ8AeQ/EOK3wiPS140RKoEQ==
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
Hello,

compared to (implicit) v1
(https://lore.kernel.org/r/20210914142428.57099-1-u.kleine-koenig@pengutronix.de)
this used dev_err_probe() as suggested by Martin Blumenstingl.

v1 got a "Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>", I didn't add
that because of the above change.

(Hmm, my setup is broken, the b4 patch signature was done before I added this
message. I wonder if this will break the signature ...)

Best regards
Uwe

 drivers/char/hw_random/meson-rng.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
index e446236e81f2..8bb30282ca46 100644
--- a/drivers/char/hw_random/meson-rng.c
+++ b/drivers/char/hw_random/meson-rng.c
@@ -54,9 +54,10 @@ static int meson_rng_probe(struct platform_device *pdev)
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	data->core_clk = devm_clk_get(dev, "core");
+	data->core_clk = devm_clk_get_optional(dev, "core");
 	if (IS_ERR(data->core_clk))
-		data->core_clk = NULL;
+		return dev_err_probe(dev, PTR_ERR(data->core_clk),
+				     "Failed to get core clock\n");
 
 	if (data->core_clk) {
 		ret = clk_prepare_enable(data->core_clk);

base-commit: 7d2a07b769330c34b4deabeed939325c77a7ec2f
-- 
2.30.2

