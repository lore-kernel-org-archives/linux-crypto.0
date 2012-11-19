From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 303/493] crypto: remove use of __devinitdata
Date: Mon, 19 Nov 2012 13:24:12 -0500
Message-ID: <1353349642-3677-303-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41458 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab2KSSeY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 13:34:24 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinitdata is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: linux-crypto@vger.kernel.org 
---
 drivers/crypto/n2_core.c   | 2 +-
 drivers/crypto/nx/nx.c     | 2 +-
 drivers/crypto/tegra-aes.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index ca62eab..10e1033 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -34,7 +34,7 @@
 #define DRV_MODULE_VERSION	"0.2"
 #define DRV_MODULE_RELDATE	"July 28, 2011"
 
-static char version[] __devinitdata =
+static char version[] =
 	DRV_MODULE_NAME ".c:v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index 6302c93..e19228e 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -689,7 +689,7 @@ static void __exit nx_fini(void)
 	vio_unregister_driver(&nx_driver.viodriver);
 }
 
-static struct vio_device_id nx_crypto_driver_ids[] __devinitdata = {
+static struct vio_device_id nx_crypto_driver_ids[] = {
 	{ "ibm,sym-encryption-v1", "ibm,sym-encryption" },
 	{ "", "" }
 };
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 75f8a55..40eed65 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -1074,7 +1074,7 @@ static int __devexit tegra_aes_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id tegra_aes_of_match[] __devinitdata = {
+static struct of_device_id tegra_aes_of_match[] = {
 	{ .compatible = "nvidia,tegra20-aes", },
 	{ .compatible = "nvidia,tegra30-aes", },
 	{ },
-- 
1.8.0
