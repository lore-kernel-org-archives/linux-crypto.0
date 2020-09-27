Return-Path: <SRS0=daZt=DE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66CDC4346E
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Sep 2020 20:02:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92DFE22207
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Sep 2020 20:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgI0UCZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Sep 2020 16:02:25 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:14476
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbgI0UCY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Sep 2020 16:02:24 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2020 16:02:23 EDT
X-IronPort-AV: E=Sophos;i="5.77,311,1596492000"; 
   d="scan'208";a="360169490"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/AES256-SHA256; 27 Sep 2020 21:55:12 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Matt Mackall <mpm@selenic.com>
Cc:     =?UTF-8?q?Valdis=20Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] hwrng: stm32 - use semicolons rather than commas to separate statements
Date:   Sun, 27 Sep 2020 21:12:14 +0200
Message-Id: <1601233948-11629-5-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr>
References: <1601233948-11629-1-git-send-email-Julia.Lawall@inria.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace commas with semicolons.  What is done is essentially described by
the following Coccinelle semantic patch (http://coccinelle.lip6.fr/):

// <smpl>
@@ expression e1,e2; @@
e1
-,
+;
e2
... when any
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/char/hw_random/stm32-rng.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index 38324c2ddda1..bc22178f83e8 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -145,12 +145,12 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 
 	dev_set_drvdata(dev, priv);
 
-	priv->rng.name = dev_driver_string(dev),
+	priv->rng.name = dev_driver_string(dev);
 #ifndef CONFIG_PM
-	priv->rng.init = stm32_rng_init,
-	priv->rng.cleanup = stm32_rng_cleanup,
+	priv->rng.init = stm32_rng_init;
+	priv->rng.cleanup = stm32_rng_cleanup;
 #endif
-	priv->rng.read = stm32_rng_read,
+	priv->rng.read = stm32_rng_read;
 	priv->rng.priv = (unsigned long) dev;
 	priv->rng.quality = 900;
 

