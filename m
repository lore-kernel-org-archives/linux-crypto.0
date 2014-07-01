From: Nitesh Narayan Lal <b44382@freescale.com>
Subject: [PATCH] crypto: caam - Enabling multiple caam debug support for C29x platform
Date: Tue, 1 Jul 2014 19:54:54 +0530
Message-ID: <1404224694-32543-1-git-send-email-b44382@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nitesh Narayan Lal <b44382@freescale.com>
To: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<r66431@freescale.com>, <b16394@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:35010
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751908AbaGAJcn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jul 2014 05:32:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In the current setup debug file system enables us to debug the operational
details for only one CAAM. This patch adds the support for debugging multiple
CAAM's.

Signed-off-by: Nitesh Narayan Lal <b44382@freescale.com>
Signed-off-by: Vakul Garg <b16394@freescale.com>
---
 drivers/crypto/caam/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1d8e003..c6e9d3b 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -588,7 +588,7 @@ static int caam_probe(struct platform_device *pdev)
 	 */
 	perfmon = (struct caam_perfmon __force *)&ctrl->perfmon;
 
-	ctrlpriv->dfs_root = debugfs_create_dir("caam", NULL);
+	ctrlpriv->dfs_root = debugfs_create_dir(dev_name(dev), NULL);
 	ctrlpriv->ctl = debugfs_create_dir("ctl", ctrlpriv->dfs_root);
 
 	/* Controller-level - performance monitor counters */
-- 
1.8.3.2
