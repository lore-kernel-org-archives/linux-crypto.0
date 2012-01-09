From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH] crypto: caam - fix gcc 4.6 warning
Date: Mon, 9 Jan 2012 10:27:40 -0600
Message-ID: <20120109102740.82e4ac0f8425930b6a34ac1c@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:54679
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932170Ab2AIQ3D (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Jan 2012 11:29:03 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

drivers/crypto/caam/ctrl.c: In function 'caam_probe':
drivers/crypto/caam/ctrl.c:49:6: warning: unused variable 'd' [-Wunused-variable]

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/ctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 8ae3ba2..c5f61c5 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -46,7 +46,7 @@ static int caam_remove(struct platform_device *pdev)
 /* Probe routine for CAAM top (controller) level */
 static int caam_probe(struct platform_device *pdev)
 {
-	int d, ring, rspec;
+	int ring, rspec;
 	struct device *dev;
 	struct device_node *nprop, *np;
 	struct caam_ctrl __iomem *ctrl;
-- 
1.7.8.3
