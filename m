From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/3] crypto: caam - add backward compatible string sec4.0
Date: Fri, 13 Jul 2012 17:49:21 -0500
Message-ID: <20120713174921.4cc549f090987a312ba25d31@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:20286
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103Ab2GMWvW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jul 2012 18:51:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Shengzhou Liu <Shengzhou.Liu@freescale.com>

In some device trees of previous version, there were string "fsl,sec4.0".
To be backward compatible with device trees, we first check "fsl,sec-v4.0",
if it fails, then check for "fsl,sec4.0".

Signed-off-by: Shengzhou Liu <Shengzhou.Liu@freescale.com>

extended to include new hash and rng code, which was omitted from
the previous version of this patch during a rebase of the SDK
version.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 14 ++++++++++----
 drivers/crypto/caam/caamrng.c  |  7 +++++--
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 895aaf2..dca3c19 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1736,8 +1736,11 @@ static void __exit caam_algapi_hash_exit(void)
 	struct caam_hash_alg *t_alg, *n;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node)
-		return;
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return;
+	}
 
 	pdev = of_find_device_by_node(dev_node);
 	if (!pdev)
@@ -1812,8 +1815,11 @@ static int __init caam_algapi_hash_init(void)
 	int i = 0, err = 0;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node)
-		return -ENODEV;
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
 
 	pdev = of_find_device_by_node(dev_node);
 	if (!pdev)
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e2bfe16..ccedb54 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -284,8 +284,11 @@ static int __init caam_rng_init(void)
 	struct caam_drv_private *priv;
 
 	dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec-v4.0");
-	if (!dev_node)
-		return -ENODEV;
+	if (!dev_node) {
+		dev_node = of_find_compatible_node(NULL, NULL, "fsl,sec4.0");
+		if (!dev_node)
+			return -ENODEV;
+	}
 
 	pdev = of_find_device_by_node(dev_node);
 	if (!pdev)
-- 
1.7.11.2
