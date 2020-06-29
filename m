Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A52C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7730E20720
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgF2TTV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:19:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59760 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbgF2TTU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:19:20 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jpolf-0003vi-MZ; Mon, 29 Jun 2020 18:03:56 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Jun 2020 18:03:55 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 29 Jun 2020 18:03:55 +1000
Subject: [PATCH 2/7] hwrng: omap - Fix W=1 unused variable warning
References: <20200629080316.GA11246@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1jpolf-0003vi-MZ@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes an unused variable warning when this driver is
built-in with CONFIG_OF=n.  While we're at it this patch also
expands the compiler coverage when CONFIG_OF is off by removing
all the CONFIG_OF ifdefs.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/omap-rng.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 7290c603fcb8e..5cc5fc5049682 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/hw_random.h>
 #include <linux/delay.h>
+#include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
@@ -243,7 +244,6 @@ static struct omap_rng_pdata omap2_rng_pdata = {
 	.cleanup	= omap2_rng_cleanup,
 };
 
-#if defined(CONFIG_OF)
 static inline u32 omap4_rng_data_present(struct omap_rng_dev *priv)
 {
 	return omap_rng_read(priv, RNG_STATUS_REG) & RNG_REG_STATUS_RDY;
@@ -358,7 +358,7 @@ static struct omap_rng_pdata eip76_rng_pdata = {
 	.cleanup	= omap4_rng_cleanup,
 };
 
-static const struct of_device_id omap_rng_of_match[] = {
+static const struct of_device_id omap_rng_of_match[] __maybe_unused = {
 		{
 			.compatible	= "ti,omap2-rng",
 			.data		= &omap2_rng_pdata,
@@ -418,13 +418,6 @@ static int of_get_omap_rng_device_details(struct omap_rng_dev *priv,
 	}
 	return 0;
 }
-#else
-static int of_get_omap_rng_device_details(struct omap_rng_dev *omap_rng,
-					  struct platform_device *pdev)
-{
-	return -EINVAL;
-}
-#endif
 
 static int get_omap_rng_device_details(struct omap_rng_dev *omap_rng)
 {
