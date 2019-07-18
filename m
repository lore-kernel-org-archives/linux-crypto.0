Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56496C76195
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEAEA21849
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 14:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390897AbfGROqM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 10:46:12 -0400
Received: from inva020.nxp.com ([92.121.34.13]:49556 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390691AbfGROpm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 10:45:42 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E8F5C1A0006;
        Thu, 18 Jul 2019 16:45:40 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DD3A01A035C;
        Thu, 18 Jul 2019 16:45:40 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 87BC4205C7;
        Thu, 18 Jul 2019 16:45:40 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 11/14] crypto: caam - free resources in case caam_rng registration failed
Date:   Thu, 18 Jul 2019 17:45:21 +0300
Message-Id: <1563461124-24641-12-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
References: <1563461124-24641-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Check the return value of the hardware registration for caam_rng and free
resources in case of failure.

Fixes: 6e4e603a9 ("crypto: caam - Dynamic memory allocation for caam_rng_ctx object")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamrng.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 561bcb5..54c32d5 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -333,7 +333,10 @@ int caam_rng_init(struct device *ctrldev)
 		goto free_rng_ctx;
 
 	dev_info(dev, "registering rng-caam\n");
-	return hwrng_register(&caam_rng);
+
+	err = hwrng_register(&caam_rng);
+	if (!err)
+		return err;
 
 free_rng_ctx:
 	kfree(rng_ctx);
-- 
2.1.0

