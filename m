Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F3AC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 12:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16F28205C9
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 12:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfHEMuA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 08:50:00 -0400
Received: from inva020.nxp.com ([92.121.34.13]:42654 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726779AbfHEMuA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 08:50:00 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 843FB1A03FC;
        Mon,  5 Aug 2019 14:49:58 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 782421A03F7;
        Mon,  5 Aug 2019 14:49:58 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2C6FE203CC;
        Mon,  5 Aug 2019 14:49:58 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH v2] crypto: caam/qi - execute library only on DPAA 1.x
Date:   Mon,  5 Aug 2019 15:49:55 +0300
Message-Id: <20190805124955.11751-1-horia.geanta@nxp.com>
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

A check in the library exit point is currently not needed,
since the list of registered algorithms is empty.

While here, silence the library initialization abort - since jr.c
calls it unconditionally.

Fixes: 1b46c90c8e00 ("crypto: caam - convert top level drivers to libraries")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
v2: dropped check at library exit point

 drivers/crypto/caam/caamalg_qi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 32f0f8a72067..d470724bcddf 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -2523,10 +2523,9 @@ int caam_qi_algapi_init(struct device *ctrldev)
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

