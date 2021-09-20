Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FDEC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 08:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE96660E76
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Sep 2021 08:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235365AbhITIIT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Sep 2021 04:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbhITIIO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Sep 2021 04:08:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4662FC061574
        for <linux-crypto@vger.kernel.org>; Mon, 20 Sep 2021 01:06:48 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mSEK0-00082D-9J; Mon, 20 Sep 2021 10:06:40 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mSEJw-0006KY-SZ; Mon, 20 Sep 2021 10:06:36 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mSEJw-0003M4-Ra; Mon, 20 Sep 2021 10:06:36 +0200
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-embedded@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     kernel@pengutronix.de
Subject: [PATCH] MAINTAINERS: Remove Matt Mackall as his identity is obsolete
Date:   Mon, 20 Sep 2021 10:06:35 +0200
Message-Id: <20210920080635.253826-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Patch-Hashes: v=1; h=sha256; i=JmFmbOHCaUQX0Fi64F4JOj20/z+ShGf7acD7NrWNdig=; m=DZ9cF2kSq++C4+4iiqrtTzNtuaQQfEiGGvXFXH0Rd5A=; p=kH9k+kSpxGng/RA/4mRvCsfsXcxRp6M02E54V1lUC/o=; g=9317de317163ef7cc5405692d019b7d79b2ea3a0
X-Patch-Sig: m=pgp; i=u.kleine-koenig@pengutronix.de; s=0x0D2511F322BFAB1C1580266BE2DCDD9132669BD6; b=iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFIQQUACgkQwfwUeK3K7AlpzggAnuq /7ZWl1VP12eITlz2e/NXE6vUKBQvs8gLohpytjs3jlbVUSLvVkdYAlCeVRy7LPBEFwu9YjVBTt/a6 1uKXf2AmgDvwBNc7NvsHxh0VUaZ3aMuxH4B4H7An8qzMDDEA2w0qW7acWONHA7rOXx7wWK4nUwxsL a68TPNrxw2LDxCoR0TsE7bhij/4soszFol9vomb3EME4XxoHx6ncz0AOWjx2rGddtCZOUL0+D0NZm RRRgV7X3jxF087Onx+wzywUhNhYPUaxY7MYuz71an4deVslS2BkbIrcHgBmC7cXZHjF1eQW3/k7HK krg/ovRz5iDyMyFkJQ9dcNDfx1Tz7fQ==
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The mails I sent to Matt on September 14 and 20 both were refused by the
MTA responsible for selenic.com (i.e. waste.org) with:

	554 5.7.1 <mpm@selenic.com>: Recipient address rejected: This identity is obsolete

Also the most recent commit that involved him (ignoring "Cc: Matt
Mackall <mpm@selenic.com>" footers) is commit 330e0a01d54c (MAINTAINERS:
Theodore Ts'o is taking over the random driver) where he was removed
from the entry for random number drivers in 2012.

So drop him completely from the list of maintainers.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d7b4f32875a9..805630c67a1f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6812,7 +6812,6 @@ F:	drivers/media/usb/em28xx/
 
 EMBEDDED LINUX
 M:	Paul Gortmaker <paul.gortmaker@windriver.com>
-M:	Matt Mackall <mpm@selenic.com>
 M:	David Woodhouse <dwmw2@infradead.org>
 L:	linux-embedded@vger.kernel.org
 S:	Maintained
@@ -8157,7 +8156,6 @@ F:	include/trace/events/hwmon*.h
 K:	(devm_)?hwmon_device_(un)?register(|_with_groups|_with_info)
 
 HARDWARE RANDOM NUMBER GENERATOR CORE
-M:	Matt Mackall <mpm@selenic.com>
 M:	Herbert Xu <herbert@gondor.apana.org.au>
 L:	linux-crypto@vger.kernel.org
 S:	Odd fixes
-- 
2.30.2

