Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C2EEC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B08E20723
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 19:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbgF2TTW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:19:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:59760 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727102AbgF2TTW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 15:19:22 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jpold-0003vb-D4; Mon, 29 Jun 2020 18:03:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Jun 2020 18:03:53 +1000
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 29 Jun 2020 18:03:53 +1000
Subject: [PATCH 1/7] hwrng: npcm - Fix W=1 unused variable warning
References: <20200629080316.GA11246@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-Id: <E1jpold-0003vb-D4@fornost.hmeau.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes an unused variable warning when this driver is
built-in with CONFIG_OF=n.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/char/hw_random/npcm-rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/npcm-rng.c b/drivers/char/hw_random/npcm-rng.c
index 01d04404d8c04..5d0d13f891b70 100644
--- a/drivers/char/hw_random/npcm-rng.c
+++ b/drivers/char/hw_random/npcm-rng.c
@@ -161,7 +161,7 @@ static const struct dev_pm_ops npcm_rng_pm_ops = {
 				pm_runtime_force_resume)
 };
 
-static const struct of_device_id rng_dt_id[] = {
+static const struct of_device_id rng_dt_id[] __maybe_unused = {
 	{ .compatible = "nuvoton,npcm750-rng",  },
 	{},
 };
