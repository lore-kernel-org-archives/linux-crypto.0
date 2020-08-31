Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679B8C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 14:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 355F42083E
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 14:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHaOB3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 10:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbgHaOBW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 10:01:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82352C061573
        for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2020 07:01:01 -0700 (PDT)
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkMc-0002VA-FZ; Mon, 31 Aug 2020 16:00:50 +0200
Received: from mfe by dude02.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kCkMW-0000cm-SZ; Mon, 31 Aug 2020 16:00:44 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     martin@kaiser.cx, prasannatsmkumar@gmail.com, linux-imx@nxp.com,
        festevam@gmail.com, herbert@gondor.apana.org.au, mpm@selenic.com,
        Anson.Huang@nxp.com, horia.geanta@nxp.com, arnd@arndb.de,
        ceggers@arri.de
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de
Subject: [PATCH] hwrng: imx-rngc - add quality to use it as kernel entropy pool
Date:   Mon, 31 Aug 2020 16:00:42 +0200
Message-Id: <20200831140042.2049-1-m.felsch@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-crypto@vger.kernel.org
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RM describes the RNGB as follow:
8<----------------------------------------------------------------
The RNGB uses the True Random Number Generator (TRNG) and a
Pseudo-Random Number Generator (PRNG) to achieve a true randomness and
cryptographic strength.
8<----------------------------------------------------------------

The RNGB has 3 operation modes: self-test, seed-generation and the final
'random number generation' mode. Before we can retrieve random numbers
from the RNGB we need to generate the seed pool:
8<----------------------------------------------------------------
During the seed generation, the RNGB adds the entropy generated in the
TRNG to the 256-bit XKEY register. The PRNG algorithm executes 20.000
entropy samples from the TRNG to create an initial seed for the random
number generation.
8<----------------------------------------------------------------

The RNGB can generate 2^20 words (1 word == 4 byte) of 'random' data
after the seed pool was initialized. The pool needs to be reseeded if
more words are required. The reseeding is done automatically since
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
-- 
2.20.1

