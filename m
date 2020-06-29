Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9813C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA6D820720
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730291AbgF2TTR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:19:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59760 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbgF2TTO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:19:14 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jpolo-0003wI-SS; Mon, 29 Jun 2020 18:04:05 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Jun 2020 18:04:04 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 29 Jun 2020 18:04:04 +1000
Subject: [PATCH 6/7] hwrng: pic32 - Fix W=1 unused variable warning
References: <20200629080316.GA11246@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1jpolo-0003wI-SS@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes an unused variable warning when this driver is
built-in with CONFIG_OF=n.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/pic32-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/pic32-rng.c b/drivers/char/hw_random/pic32-rng.c
index 81080cb2294e7..e8210c1715cfd 100644
--- a/drivers/char/hw_random/pic32-rng.c
+++ b/drivers/char/hw_random/pic32-rng.c
@@ -119,7 +119,7 @@ static int pic32_rng_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id pic32_rng_of_match[] = {
+static const struct of_device_id pic32_rng_of_match[] __maybe_unused = {
 	{ .compatible	= "microchip,pic32mzda-rng", },
 	{ /* sentinel */ }
 };
