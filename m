Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 653D2C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FF7622B3F
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 07:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgG1Hss (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 03:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727871AbgG1Hsq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 03:48:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57A4C061794
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 00:48:46 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1k0KLV-0008OF-BB; Tue, 28 Jul 2020 09:48:21 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1k0KLR-0005bP-Ru; Tue, 28 Jul 2020 09:48:17 +0200
Date:   Tue, 28 Jul 2020 09:48:17 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Fabio Estevam <festevam@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] hwrng: imx-rngc - setup default RNG quality
Message-ID: <20200728074817.hlevn7ex2hckdbvi@pengutronix.de>
References: <CAOMZO5ASnj7SpjjAEpWjRK-vMpFFKU00=rxKeBtaMSKE9pkX1g@mail.gmail.com>
 <20200727124552.4336-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727124552.4336-1-ceggers@arri.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:39:33 up 255 days, 22:58, 251 users,  load average: 0.09, 0.04,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christian,

On 20-07-27 14:45, Christian Eggers wrote:
> When hw_random device's quality is non-zero, it will automatically fill
> the kernel's entropy pool at boot.  For this purpose, one conservative
> quality value is being picked up as the default value.

IMHO your value is not conservative enough and the commit message should
explain why we should use 900. Unfortunately I had not enough time to
send my patch addressing this. However please check my commit message
why 900 is not good:

8<------------------------------------------------------------------------
From 9f047eee5e4ce8353c9b764a47e7f584b2013347 Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Thu, 7 May 2020 12:01:28 +0200
Subject: [PATCH] hwrng: imx-rngc - add quality to use it as kernel entropy
 pool

The RM describes the RNGB as follow:
8<----------------------------------------------------------------
The RNGB uses the True Random Number Generator (TRNG) and a
Pseudo-Random Number Generator (PRNG) to achieve a true randomness and
cryptographic strength.
8<----------------------------------------------------------------

The RNGB has 3 operation modes: self-test, seed-generation and the final
'random number generation' mode. Befor we can retrieve random numbers
from the RNGB we need to generate the seed pool:
8<----------------------------------------------------------------
During the seed generation, the RNGB adds the entropy generated in the
TRNG to the 256-bit XKEY register. The PRNG algorithm executes 20.000
entropy samples from the TRNG to create an initial seed for the random
number generation.
8<----------------------------------------------------------------

The RNGB can generate 2^20 words (4byte) of 'random' data after the
seed pool was initialized. The pool needs to be reseeded if more words
are required. The reseeding is done automatically since
commit 3acd9ea9331c ("hwrng: imx-rngc - use automatic seeding").

We can't retrieve the TRNG values directly so we need a other way to get
the quality level. We know that the PRNG uses 20.000 entropy samples
from the TRNG to generate 2^20 words (1MiB) and the quality level is
defined as (in bits of entropy per 1024 bits of input). So the quality
level can be calculated by:

   20.000 * 1024
   ------------- = ~ 19.5
        2^20

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/char/hw_random/imx-rngc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 9c47e431ce90..61c844baf26e 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -285,6 +285,7 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	rngc->rng.init = imx_rngc_init;
 	rngc->rng.read = imx_rngc_read;
 	rngc->rng.cleanup = imx_rngc_cleanup;
+	rngc->rng.quality = 19;
 
 	rngc->dev = &pdev->dev;
 	platform_set_drvdata(pdev, rngc);
