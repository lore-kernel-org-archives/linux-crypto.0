From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - fix build warning when DEBUG_FS not
 configured
Date: Sun, 5 Jun 2011 16:42:54 -0500
Message-ID: <20110605164254.b9ede635.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:44571
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039Ab1FEVnT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 5 Jun 2011 17:43:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

drivers/crypto/caam/ctrl.c: In function 'caam_probe':
drivers/crypto/caam/ctrl.c:55:23: warning: unused variable 'perfmon'

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 9009713..fc2d9ed 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -52,9 +52,11 @@ static int caam_probe(struct platform_device *pdev)
 	struct caam_ctrl __iomem *ctrl;
 	struct caam_full __iomem *topregs;
 	struct caam_drv_private *ctrlpriv;
-	struct caam_perfmon *perfmon;
 	struct caam_deco **deco;
 	u32 deconum;
+#ifdef CONFIG_DEBUG_FS
+	struct caam_perfmon *perfmon;
+#endif
 
 	ctrlpriv = kzalloc(sizeof(struct caam_drv_private), GFP_KERNEL);
 	if (!ctrlpriv)
-- 
1.7.5.4
