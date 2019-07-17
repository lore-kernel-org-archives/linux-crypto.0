Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D99FC76186
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 09:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D8B120818
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 09:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfGQJOH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 05:14:07 -0400
Received: from inva021.nxp.com ([92.121.34.21]:56192 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfGQJOG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 05:14:06 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B9973200360;
        Wed, 17 Jul 2019 11:14:05 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8360D2000A5;
        Wed, 17 Jul 2019 11:13:57 +0200 (CEST)
Received: from titan.ap.freescale.net (TITAN.ap.freescale.net [10.192.208.233])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 6008C402A4;
        Wed, 17 Jul 2019 17:13:47 +0800 (SGT)
From:   Anson.Huang@nxp.com
To:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        rfontana@redhat.com, allison@lohutok.net,
        kstewart@linuxfoundation.org, tglx@linutronix.de,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Linux-imx@nxp.com
Subject: [PATCH 2/2] char: hw_random: mxc-rnga: use devm_platform_ioremap_resource() to simplify code
Date:   Wed, 17 Jul 2019 17:04:38 +0800
Message-Id: <20190717090438.31522-2-Anson.Huang@nxp.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20190717090438.31522-1-Anson.Huang@nxp.com>
References: <20190717090438.31522-1-Anson.Huang@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

Use the new helper devm_platform_ioremap_resource() which wraps the
platform_get_resource() and devm_ioremap_resource() together, to
simplify the code.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
 drivers/char/hw_random/mxc-rnga.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/mxc-rnga.c b/drivers/char/hw_random/mxc-rnga.c
index ea2bf18..025083c 100644
--- a/drivers/char/hw_random/mxc-rnga.c
+++ b/drivers/char/hw_random/mxc-rnga.c
@@ -134,7 +134,6 @@ static void mxc_rnga_cleanup(struct hwrng *rng)
 static int __init mxc_rnga_probe(struct platform_device *pdev)
 {
 	int err;
-	struct resource *res;
 	struct mxc_rng *mxc_rng;
 
 	mxc_rng = devm_kzalloc(&pdev->dev, sizeof(*mxc_rng), GFP_KERNEL);
@@ -158,8 +157,7 @@ static int __init mxc_rnga_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	mxc_rng->mem = devm_ioremap_resource(&pdev->dev, res);
+	mxc_rng->mem = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(mxc_rng->mem)) {
 		err = PTR_ERR(mxc_rng->mem);
 		goto err_ioremap;
-- 
2.7.4

