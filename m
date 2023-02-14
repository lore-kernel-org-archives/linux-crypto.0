Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB322C64EC7
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Feb 2023 16:29:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjBNQ3D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Feb 2023 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBNQ3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2023 11:29:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6098B5267
        for <linux-crypto@vger.kernel.org>; Tue, 14 Feb 2023 08:28:55 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAk-0007Sz-CZ; Tue, 14 Feb 2023 17:28:50 +0100
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAg-004v9S-Nk; Tue, 14 Feb 2023 17:28:47 +0100
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1pRyAh-003WdL-6y; Tue, 14 Feb 2023 17:28:47 +0100
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Olivia Mackall <olivia@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 0/3] hwrng: xgene - Some improvements
Date:   Tue, 14 Feb 2023 17:28:26 +0100
Message-Id: <20230214162829.113148-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1183; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=jqEIff8w3k0ZcRKWhSOulDiyvWB2AY261fNt2CbIKHE=; b=owEBbQGS/pANAwAKAcH8FHityuwJAcsmYgBj67ad3WoUecds/U/Oudy7z5f0EFGDRpntOTNv5 jTfmZl6bt6JATMEAAEKAB0WIQR+cioWkBis/z50pAvB/BR4rcrsCQUCY+u2nQAKCRDB/BR4rcrs CeE3B/9IhkmdLi+iP19ZgtadbVkRZjR2+hu6jUPuprarJZTwTv14M5sZG3O6K15C61TcjDLojX6 dXEdg5bZvGcrM24/i2BotZ2WPtsnNDocXc1W4qSrOMEvR45UMq85Sbjl3dUC9R+CRBF1qoEnuAj P2Re9O+tEAG0CmZTmumZNUd9ttaMhlqYwNTTt6gRWPhw0pF3x4TwhSMU/oOpi82+2L2mzFxFF9T FlicDvuCOf6USIQIAxPbK83zypKo0buhK2x5XHbtMaYi+pkxk2xaomBnFkbrwdeW7dgbEOWh2NH kkCGQxVPUkeDttUXtUGRx4045r0wYqEkZk58HOwQFh0T1gCw
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

while working on the quest to make struct platform_driver::remove() return void
I stumbled over the xgene-rng driver because it didn't return 0 in .remove().

Looking at it I found two other patch opportunities, here is the result.

I think the driver has some more problems:

 - device_init_wakeup() is only called after devm_hwrng_register(). After the
   latter returns the respective callbacks can be called. Is the device already
   in the right state before device_init_wakeup(..., 1)?

 - Similar problem on .remove(): device_init_wakeup(..., 0) is called before
   hwrng_unregister() happens.

 - If there are two (or more) devices of that type, .probe() for the 2nd overwrites
   xgene_rng_func.priv of the first one.

Best regards
Uwe

Uwe Kleine-König (3):
  hwrng: xgene - Simplify using dev_err_probe()
  hwrng: xgene - Simplify using devm_clk_get_optional_enabled()
  hwrng: xgene - Improve error reporting for problems during .remove()

 drivers/char/hw_random/xgene-rng.c | 44 ++++++++----------------------
 1 file changed, 11 insertions(+), 33 deletions(-)

base-commit: e05dec85e78317f251eddd27e0357b2253d9dfc4
-- 
2.39.1

