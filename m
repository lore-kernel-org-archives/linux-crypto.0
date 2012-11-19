From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 397/493] crypto: remove use of __devexit
Date: Mon, 19 Nov 2012 13:25:46 -0500
Message-ID: <1353349642-3677-397-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-geode@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41487 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab2KSSew (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 13:34:52 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: linux-crypto@vger.kernel.org 
Cc: linux-geode@lists.infradead.org 
Cc: linux-arm-kernel@lists.infradead.org 
---
 drivers/crypto/atmel-aes.c        | 2 +-
 drivers/crypto/atmel-sha.c        | 2 +-
 drivers/crypto/atmel-tdes.c       | 2 +-
 drivers/crypto/bfin_crc.c         | 2 +-
 drivers/crypto/geode-aes.c        | 2 +-
 drivers/crypto/hifn_795x.c        | 2 +-
 drivers/crypto/n2_core.c          | 6 +++---
 drivers/crypto/nx/nx.c            | 2 +-
 drivers/crypto/omap-sham.c        | 2 +-
 drivers/crypto/picoxcell_crypto.c | 2 +-
 drivers/crypto/tegra-aes.c        | 2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 931d436..c9d9d5c 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1152,7 +1152,7 @@ aes_dd_err:
 	return err;
 }
 
-static int __devexit atmel_aes_remove(struct platform_device *pdev)
+static int atmel_aes_remove(struct platform_device *pdev)
 {
 	static struct atmel_aes_dev *aes_dd;
 
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 17f8862..4918e94 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1063,7 +1063,7 @@ sha_dd_err:
 	return err;
 }
 
-static int __devexit atmel_sha_remove(struct platform_device *pdev)
+static int atmel_sha_remove(struct platform_device *pdev)
 {
 	static struct atmel_sha_dev *sha_dd;
 
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index f4b9907..7c73fbb 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1162,7 +1162,7 @@ tdes_dd_err:
 	return err;
 }
 
-static int __devexit atmel_tdes_remove(struct platform_device *pdev)
+static int atmel_tdes_remove(struct platform_device *pdev)
 {
 	static struct atmel_tdes_dev *tdes_dd;
 
diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 904b646..a22f1a9 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -707,7 +707,7 @@ out_error_free_mem:
  *	bfin_crypto_crc_remove - Initialize module
  *
  */
-static int __devexit bfin_crypto_crc_remove(struct platform_device *pdev)
+static int bfin_crypto_crc_remove(struct platform_device *pdev)
 {
 	struct bfin_crypto_crc *crc = platform_get_drvdata(pdev);
 
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index f3793a2..6bde3ea 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -498,7 +498,7 @@ static struct crypto_alg geode_ecb_alg = {
 	}
 };
 
-static void __devexit
+static void
 geode_aes_remove(struct pci_dev *dev)
 {
 	crypto_unregister_alg(&geode_alg);
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index f909d99..ebf130e 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2696,7 +2696,7 @@ err_out_disable_pci_device:
 	return err;
 }
 
-static void __devexit hifn_remove(struct pci_dev *pdev)
+static void hifn_remove(struct pci_dev *pdev)
 {
 	int i;
 	struct hifn_device *dev;
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 10e1033..0c286fc 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1545,7 +1545,7 @@ out:
 	return err;
 }
 
-static void __devexit n2_unregister_algs(void)
+static void n2_unregister_algs(void)
 {
 	mutex_lock(&spu_lock);
 	if (!--algs_registered)
@@ -2077,7 +2077,7 @@ out_free_n2cp:
 	return err;
 }
 
-static int __devexit n2_crypto_remove(struct platform_device *dev)
+static int n2_crypto_remove(struct platform_device *dev)
 {
 	struct n2_crypto *np = dev_get_drvdata(&dev->dev);
 
@@ -2179,7 +2179,7 @@ out_free_ncp:
 	return err;
 }
 
-static int __devexit n2_mau_remove(struct platform_device *dev)
+static int n2_mau_remove(struct platform_device *dev)
 {
 	struct n2_mau *mp = dev_get_drvdata(&dev->dev);
 
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index e19228e..17afbf9 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -653,7 +653,7 @@ static int nx_probe(struct vio_dev *viodev,
 	return nx_register_algs();
 }
 
-static int __devexit nx_remove(struct vio_dev *viodev)
+static int nx_remove(struct vio_dev *viodev)
 {
 	dev_dbg(&viodev->dev, "entering nx_remove for UA 0x%x\n",
 		viodev->unit_address);
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index fb037ff..89fba10 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1250,7 +1250,7 @@ data_err:
 	return err;
 }
 
-static int __devexit omap_sham_remove(struct platform_device *pdev)
+static int omap_sham_remove(struct platform_device *pdev)
 {
 	static struct omap_sham_dev *dd;
 	int i;
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 6eb91e6..2096d46 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1841,7 +1841,7 @@ static int spacc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int __devexit spacc_remove(struct platform_device *pdev)
+static int spacc_remove(struct platform_device *pdev)
 {
 	struct spacc_alg *alg, *next;
 	struct spacc_engine *engine = platform_get_drvdata(pdev);
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 40eed65..85ea752 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -1047,7 +1047,7 @@ out:
 	return err;
 }
 
-static int __devexit tegra_aes_remove(struct platform_device *pdev)
+static int tegra_aes_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct tegra_aes_dev *dd = platform_get_drvdata(pdev);
-- 
1.8.0
