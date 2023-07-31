Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C66C001DC
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Jul 2023 16:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjGaQzS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Jul 2023 12:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbjGaQzS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2023 12:55:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDFC1729
        for <linux-crypto@vger.kernel.org>; Mon, 31 Jul 2023 09:55:13 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAk-0006a0-1h; Mon, 31 Jul 2023 18:55:06 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAf-000AQS-O1; Mon, 31 Jul 2023 18:55:01 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qQWAe-009NYd-FU; Mon, 31 Jul 2023 18:55:00 +0200
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
Subject: [PATCH 0/3] stm32/hash - Convert to platform remove callback returning void
Date:   Mon, 31 Jul 2023 18:54:53 +0200
Message-Id: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=935; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=w0wihl2nAbFj+WMOmikfkuigtjpGlCwMYZnP0JawFc8=; b=owGbwMvMwMXY3/A7olbonx/jabUkhpTjzyNV31csM+zhm3Llpe/Vb8H3+9wq1i5ZtWXRYg+rD Cc9y4pnnYzGLAyMXAyyYoos9o1rMq2q5CI71/67DDOIlQlkCgMXpwBMZM4r9v/5vSYusl3/XBIb vH95dCREWbJ/XL1vmguXxZ1Ziux9c9zezVhq/lu0sa/Z8+AlDf5ZGatV6+TkS0WSbx7gyzw8x3X xXHnpkuDV93lM1qrXs37dFqAeFBe8+7yvyOG59xYcYtK4cvP6Uf7k9WyTp3MGcsgFByruuZ8hkB Wx220r1+NFHxUus2ppbmX7aPDoD8cGyZ3B3z6n/vO1/KBns2NOQL3qiVXr0/w2OFT1xF/65exfU HK1dmakJecX5YpIge86vvtnNPLfDOiYmmJUGCfcNn9RlrHkqbivjbvcDHgmWdjeWjwjTe5r4tVd zYk69tXFfL6ORWFsjvLu1b16LrIce8O1rzqurk7YJHoTAA==
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

this patch series converts the stm32-hash driver to use .remove_new. The
first patch is a fix that could be backported to stable, but it's not
very urgent. It's only problematic if such a device is unbound (which
happens rarely) and then clk_prepare_enable() fails. Up to you if you
want to tag it as stable material.

The overall goal is to reduce the number of drivers using the irritating
.remove() callback by one. See the commit log of the third patch for the
reasoning.

Best regards
Uwe

Uwe Kleine-König (3):
  crypto: stm32/hash - Properly handle pm_runtime_get failing
  crypto: stm32/hash - Drop if block with always false condition
  crypto: stm32/hash - Convert to platform remove callback returning
    void

 drivers/crypto/stm32/stm32-hash.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

base-commit: 3de0152bf26ff0c5083ef831ba7676fc4c92e63a
-- 
2.39.2
