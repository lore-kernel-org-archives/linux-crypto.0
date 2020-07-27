Return-Path: <SRS0=C5/f=BG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82437C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 11:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D17520714
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 11:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgG0Lh2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jul 2020 07:37:28 -0400
Received: from mailout10.rmx.de ([94.199.88.75]:41102 "EHLO mailout10.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgG0Lh2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jul 2020 07:37:28 -0400
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout10.rmx.de (Postfix) with ESMTPS id 4BFcLs4pvGz311B;
        Mon, 27 Jul 2020 13:01:41 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4BFcKZ5qFvz2xFb;
        Mon, 27 Jul 2020 13:00:34 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.121) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Mon, 27 Jul
 2020 12:59:12 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>
CC:     Christian Eggers <ceggers@arri.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Anson Huang <Anson.Huang@nxp.com>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>
Subject: [PATCH 2/3] hwrng: imx-rngc - make clock optional
Date:   Mon, 27 Jul 2020 12:57:15 +0200
Message-ID: <20200727105718.26225-3-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727105718.26225-1-ceggers@arri.de>
References: <20200727105718.26225-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.121]
X-RMX-ID: 20200727-130034-4BFcKZ5qFvz2xFb-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On i.MX6 ULL the RNGB has no switchable clock.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/char/hw_random/imx-rngc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/imx-rngc.c b/drivers/char/hw_random/imx-rngc.c
index 9c47e431ce90..f9c5ddd0276b 100644
--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -245,7 +245,7 @@ static int imx_rngc_probe(struct platform_device *pdev)
 	if (IS_ERR(rngc->base))
 		return PTR_ERR(rngc->base);
 
-	rngc->clk = devm_clk_get(&pdev->dev, NULL);
+	rngc->clk = devm_clk_get_optional(&pdev->dev, NULL);
 	if (IS_ERR(rngc->clk)) {
 		dev_err(&pdev->dev, "Can not get rng_clk\n");
 		return PTR_ERR(rngc->clk);
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

