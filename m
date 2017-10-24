From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH] crypto: caam/qi - abort algorithm setup on DPAA2 parts
Date: Tue, 24 Oct 2017 09:27:31 +0300
Message-ID: <20171024062731.28070-2-horia.geanta@nxp.com>
References: <20171024062731.28070-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0046.outbound.protection.outlook.com ([104.47.38.46]:56331
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751711AbdJXG2N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Oct 2017 02:28:13 -0400
In-Reply-To: <20171024062731.28070-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

caam/qi frontend (i.e. caamalg_qi) mustn't be used in case it runs on a
DPAA2 part (this could happen when using a multiplatform kernel).

Fixes: 297b9cebd2fc ("crypto: caam/jr - add support for DPAA2 parts")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
If this patch won't make it into v4.14 (likely the case),
eventually it should be sent to -stable.

 drivers/crypto/caam/caamalg_qi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 2eefc4a26bc2..f9f08fce4356 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -7,7 +7,7 @@
  */
 
 #include "compat.h"
-
+#include "ctrl.h"
 #include "regs.h"
 #include "intern.h"
 #include "desc_constr.h"
@@ -2312,6 +2312,11 @@ static int __init caam_qi_algapi_init(void)
 	if (!priv || !priv->qi_present)
 		return -ENODEV;
 
+	if (caam_dpaa2) {
+		dev_info(ctrldev, "caam/qi frontend driver not suitable for DPAA 2.x, aborting...\n");
+		return -ENODEV;
+	}
+
 	INIT_LIST_HEAD(&alg_list);
 
 	/*
-- 
2.12.0.264.gd6db3f216544
