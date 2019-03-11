Return-Path: <SRS0=66xG=RO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49BAC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Mar 2019 11:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BEAA20657
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Mar 2019 11:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfCKLFL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Mar 2019 07:05:11 -0400
Received: from magratgarlick.emantor.de ([78.46.208.201]:40532 "EHLO
        margratgarlick.emantor.de" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725839AbfCKLFL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Mar 2019 07:05:11 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2019 07:05:10 EDT
Received: by margratgarlick.emantor.de (Postfix, from userid 114)
        id 16B3FCD31F; Mon, 11 Mar 2019 11:59:05 +0100 (CET)
Received: from localhost (unknown [IPv6:2001:67c:670:202:7ba8:5e41:1591:d723])
        by margratgarlick.emantor.de (Postfix) with ESMTPSA id 7A98FCCB32;
        Mon, 11 Mar 2019 11:59:02 +0100 (CET)
From:   Rouven Czerwinski <r.czerwinski@pengutronix.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel@pengutronix.de,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Deepak Saxena <dsaxena@plexity.net>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: omap - Set default quality
Date:   Mon, 11 Mar 2019 11:58:57 +0100
Message-Id: <20190311105857.30792-1-r.czerwinski@pengutronix.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Newer combinations of the glibc, kernel and openssh can result in long initial
startup times on OMAP devices:

[    6.671425] systemd-rc-once[102]: Creating ED25519 key; this may take some time ...
[  142.652491] systemd-rc-once[102]: Creating ED25519 key; done.

due to the blocking getrandom(2) system call:

[  142.610335] random: crng init done

Set the quality level for the omap hwrng driver allowing the kernel to use the
hwrng as an entropy source at boot.

Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
---
 drivers/char/hw_random/omap-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index b65ff6962899..e9b6ac61fb7f 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -443,6 +443,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	priv->rng.read = omap_rng_do_read;
 	priv->rng.init = omap_rng_init;
 	priv->rng.cleanup = omap_rng_cleanup;
+	priv->rng.quality = 900;
 
 	priv->rng.priv = (unsigned long)priv;
 	platform_set_drvdata(pdev, priv);
-- 
2.21.0

