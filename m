Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5519CE7A8B
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Sep 2023 10:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjIWKIe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Sep 2023 06:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjIWKIc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Sep 2023 06:08:32 -0400
Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [IPv6:2a0a:edc0:2:b01:1d::104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB2419A
        for <linux-crypto@vger.kernel.org>; Sat, 23 Sep 2023 03:08:26 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYe-0001jY-NX; Sat, 23 Sep 2023 12:08:16 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYb-008Nf8-M0; Sat, 23 Sep 2023 12:08:13 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1qjzYb-0047zX-BV; Sat, 23 Sep 2023 12:08:13 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy <declan.murphy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 0/2] crypto: CMake crypto_engine_exit() return void
Date:   Sat, 23 Sep 2023 12:08:04 +0200
Message-Id: <20230923100806.1762943-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1399; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=x5PLxSHA+m2jkhlSm4ESnoxzgmeg6OjRFF3lNc//2MQ=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBlDrkAJh+sYucriZEyM/taDzvCyahrfCAKf9mjR btYAK2AAVeJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZQ65AAAKCRCPgPtYfRL+ TuvWB/9+UG7FV3iZqEKXJsgEodddxhjlm0kPiStD9ImJ0bmMDcEauwBHs0NllWuWjx7fj4gEz30 581PuIkb5e2Q9qpzexiA4qJtYONx9q5855/j6jNIVrEnnRemwjEBcXEX09XdN8G8ojoWvyMXgk3 Xk30KAROGAUSS6iTXM1JQUYlZQnoo/wNECQ1n8pgbZMHbdDm9fn/GaWV/q8iU1vnjFnC4NfCP4I lbDb9KL438CDBfasqSrQ+bjHfTJOyMEZoSUtFVuXp676YMFB1U52MzWXI6Hix3HvYKMcNwzBuvY CQEkfd0gUtWJaCQtzUNH+LMl8XUEraOCziOI53Bx1b1SjIOg
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

all but one crypto driver ignore the return code of
crypto_engine_exit(). This is ok as this function is called in
situations (remove callback, or error path of probe) where errors cannot
be handled anyhow. This series adapts the only driver that doesn't
ignore the error code (and removes the bogous try to handle it) and then
changes crypto_engine_exit() to return void to prevent similar silly
tries in the future.

Note however there is still something to fix: If crypto_engine_stop()
fails in crypto_engine_exit() the kworker stays around but *engine will
be freed. So if something triggers the worker afterwards, this results
in an oops (or memory corruption if the freed memory is reused already).
This needs adaptions in the core, specific device drivers are unaffected
by this, so changing crypto_engine_exit() to return void is a step in
the right direction for this fix, too.

Best regards
Uwe

Uwe Kleine-König (2):
  crypto: keembay - Don't pass errors to the caller in .remove()
  crypto: Make crypto_engine_exit() return void

 crypto/crypto_engine.c                              |  8 ++------
 drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 11 +++--------
 include/crypto/engine.h                             |  2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

base-commit: 940fcc189c51032dd0282cbee4497542c982ac59
-- 
2.40.1

