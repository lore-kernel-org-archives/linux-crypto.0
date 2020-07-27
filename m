Return-Path: <SRS0=C5/f=BG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733C2C433E5
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 12:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4912C2074F
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 12:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgG0Mw3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jul 2020 08:52:29 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:36655 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbgG0Mw3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jul 2020 08:52:29 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4BFfpc4w6hz9w5h;
        Mon, 27 Jul 2020 14:52:24 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4BFfnb69cVz2xbN;
        Mon, 27 Jul 2020 14:51:31 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.121) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 27 Jul
 2020 14:49:43 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Fabio Estevam <festevam@gmail.com>
CC:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        Martin Kaiser <martin@kaiser.cx>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH] hwrng: imx-rngc - setup default RNG quality
Date:   Mon, 27 Jul 2020 14:45:53 +0200
Message-ID: <20200727124552.4336-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CAOMZO5ASnj7SpjjAEpWjRK-vMpFFKU00=rxKeBtaMSKE9pkX1g@mail.gmail.com>
References: <CAOMZO5ASnj7SpjjAEpWjRK-vMpFFKU00=rxKeBtaMSKE9pkX1g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.121]
X-RMX-ID: 20200727-145137-4BFfnb69cVz2xbN-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When hw_random device's quality is non-zero, it will automatically fill
the kernel's entropy pool at boot.  For this purpose, one conservative
quality value is being picked up as the default value.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/char/hw_random/imx-rngc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index f9c5ddd0276b..a62ff78bd7ea 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -285,6 +285,7 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	rngc->rng.init = imx_rngc_init;
 	rngc->rng.read = imx_rngc_read;
 	rngc->rng.cleanup = imx_rngc_cleanup;
+	rngc->rng.quality = 900;
 
 	rngc->dev = &pdev->dev;
 	platform_set_drvdata(pdev, rngc);
-- 
On Mon, Jul 27, 2020 Fabian Estevam wrote:
> Horia has already sent a patch series that adds imx6ull rngb support:
> https://lkml.org/lkml/2020/7/23/173

That happens when patches are sent upstream one year after writing....

Can you please add the third patch of the series?

regards

Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

