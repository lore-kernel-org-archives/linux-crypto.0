Return-Path: <SRS0=wJ3R=TO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D6EC04AB4
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 17:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D9C02084A
	for <linux-crypto@archiver.kernel.org>; Tue, 14 May 2019 17:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfENRN0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 May 2019 13:13:26 -0400
Received: from inva021.nxp.com ([92.121.34.21]:49802 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfENRNZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 May 2019 13:13:25 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 32C76200017;
        Tue, 14 May 2019 19:13:24 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 264A120014B;
        Tue, 14 May 2019 19:13:24 +0200 (CEST)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C7A6D2061C;
        Tue, 14 May 2019 19:13:23 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - fix typo in i.MX6 devices list for errata
Date:   Tue, 14 May 2019 20:13:09 +0300
Message-Id: <1557853989-29075-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a typo in the list of i.MX6 devices affected by an
issue wherein AXI bus transactions may not occur in
the correct order.

Fixes: 33d69455e402 ("crypto: caam - limit AXI pipeline to a depth of
1")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index e2ba3d2..fec39c3 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -469,7 +469,7 @@ static int caam_get_era(struct caam_ctrl __iomem *ctrl)
 }
 
 /*
- * ERRATA: imx6 devices (imx6D, imx6Q, imx6DL, imx6S, imx6DP and imx6DQ)
+ * ERRATA: imx6 devices (imx6D, imx6Q, imx6DL, imx6S, imx6DP and imx6QP)
  * have an issue wherein AXI bus transactions may not occur in the correct
  * order. This isn't a problem running single descriptors, but can be if
  * running multiple concurrent descriptors. Reworking the driver to throttle
-- 
2.1.0

