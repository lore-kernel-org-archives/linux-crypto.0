Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C15C433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 12:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72A2D2067D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 12:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfHEMjR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 08:39:17 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58634 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726508AbfHEMjR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 08:39:17 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 4B27A1A03FC;
        Mon,  5 Aug 2019 14:39:15 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 36F691A0405;
        Mon,  5 Aug 2019 14:39:15 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E9D27203CC;
        Mon,  5 Aug 2019 14:39:14 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam/qi - execute library only on DPAA 1.x
Date:   Mon,  5 Aug 2019 15:39:00 +0300
Message-Id: <20190805123900.9981-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In the process of turning caam/qi into a library, the check of
MCFGR[QI] bit has been inadvertently dropped.
Fix the condition for DPAA 1.x QI detection, which should be:
MCFGR[QI] && !MCFGR[DPAA2]

An identical check is added in the library exit point, even though
currently it's not strictly required (list of registered algorithms
being empty).

While here, silence the library initialization abort - since jr.c
calls it unconditionally.

Fixes: 1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 32f0f8a72067..c25479d2efa4 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2474,6 +2474,10 @@ void caam_qi_algapi_exit(void)
 {
 	int i;
 
+	/* Make sure this runs only on (DPAA 1.x) QI */
+	if (!priv->qi_present || caam_dpaa2)
+		return 0;
+
 	for (i = 0; i < ARRAY_SIZE(driver_aeads); i++) {
 		struct caam_aead_alg *t_alg = driver_aeads + i;
 
@@ -2523,10 +2527,9 @@ int caam_qi_algapi_init(struct device *ctrldev)
 	unsigned int md_limit = SHA512_DIGEST_SIZE;
 	bool registered = false;
 
-	if (caam_dpaa2) {
-		dev_info(ctrldev, "caam/qi frontend driver not suitable for DPAA 2.x, aborting...\n");
-		return -ENODEV;
-	}
+	/* Make sure this runs only on (DPAA 1.x) QI */
+	if (!priv->qi_present || caam_dpaa2)
+		return 0;
 
 	/*
 	 * Register crypto algorithms the device supports.
-- 
2.17.1

