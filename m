From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 225/493] crypto: remove use of __devinit
Date: Mon, 19 Nov 2012 13:22:54 -0500
Message-ID: <1353349642-3677-225-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-geode@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41893 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab2KSSnE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Nov 2012 13:43:04 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au> 
Cc: "David S. Miller" <davem@davemloft.net> 
Cc: linux-crypto@vger.kernel.org 
Cc: linux-geode@lists.infradead.org 
Cc: linux-arm-kernel@lists.infradead.org 
---
 drivers/crypto/atmel-aes.c        |  2 +-
 drivers/crypto/atmel-sha.c        |  2 +-
 drivers/crypto/atmel-tdes.c       |  2 +-
 drivers/crypto/bfin_crc.c         |  2 +-
 drivers/crypto/geode-aes.c        |  2 +-
 drivers/crypto/hifn_795x.c        |  2 +-
 drivers/crypto/n2_core.c          | 26 +++++++++++++-------------
 drivers/crypto/nx/nx.c            |  2 +-
 drivers/crypto/omap-sham.c        |  2 +-
 drivers/crypto/picoxcell_crypto.c |  2 +-
 10 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 3cfa548..931d436 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1036,7 +1036,7 @@ err_aes_algs:
 	return err;
 }
 
-static int __devinit atmel_aes_probe(struct platform_device *pdev)
+static int atmel_aes_probe(struct platform_device *pdev)
 {
 	struct atmel_aes_dev *aes_dd;
 	struct aes_platform_data	*pdata;
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 4fb07609..17f8862 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -964,7 +964,7 @@ err_sha_algs:
 	return err;
 }
 
-static int __devinit atmel_sha_probe(struct platform_device *pdev)
+static int atmel_sha_probe(struct platform_device *pdev)
 {
 	struct atmel_sha_dev *sha_dd;
 	struct device *dev = &pdev->dev;
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 530474f..f4b9907 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1053,7 +1053,7 @@ err_tdes_algs:
 	return err;
 }
 
-static int __devinit atmel_tdes_probe(struct platform_device *pdev)
+static int atmel_tdes_probe(struct platform_device *pdev)
 {
 	struct atmel_tdes_dev *tdes_dd;
 	struct device *dev = &pdev->dev;
diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index eecaae2..904b646 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -586,7 +586,7 @@ static int bfin_crypto_crc_suspend(struct platform_device *pdev, pm_message_t st
  *	bfin_crypto_crc_probe - Initialize module
  *
  */
-static int __devinit bfin_crypto_crc_probe(struct platform_device *pdev)
+static int bfin_crypto_crc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 3217baf..f3793a2 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -513,7 +513,7 @@ geode_aes_remove(struct pci_dev *dev)
 }
 
 
-static int __devinit
+static int
 geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	int ret;
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 4c2f467..f909d99 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2561,7 +2561,7 @@ static void hifn_tasklet_callback(unsigned long data)
 		hifn_process_queue(dev);
 }
 
-static int __devinit hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	int err, i;
 	struct hifn_device *dev;
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 2741ef5..ca62eab 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1388,7 +1388,7 @@ static int n2_cipher_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int __devinit __n2_register_one_cipher(const struct n2_cipher_tmpl *tmpl)
+static int __n2_register_one_cipher(const struct n2_cipher_tmpl *tmpl)
 {
 	struct n2_cipher_alg *p = kzalloc(sizeof(*p), GFP_KERNEL);
 	struct crypto_alg *alg;
@@ -1424,7 +1424,7 @@ static int __devinit __n2_register_one_cipher(const struct n2_cipher_tmpl *tmpl)
 	return err;
 }
 
-static int __devinit __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
+static int __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
 {
 	struct n2_hmac_alg *p = kzalloc(sizeof(*p), GFP_KERNEL);
 	struct ahash_alg *ahash;
@@ -1462,7 +1462,7 @@ static int __devinit __n2_register_one_hmac(struct n2_ahash_alg *n2ahash)
 	return err;
 }
 
-static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
+static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 {
 	struct n2_ahash_alg *p = kzalloc(sizeof(*p), GFP_KERNEL);
 	struct hash_alg_common *halg;
@@ -1517,7 +1517,7 @@ static int __devinit __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 	return err;
 }
 
-static int __devinit n2_register_algs(void)
+static int n2_register_algs(void)
 {
 	int i, err = 0;
 
@@ -1822,7 +1822,7 @@ static int spu_mdesc_scan(struct mdesc_handle *mdesc, struct platform_device *de
 	return err;
 }
 
-static int __devinit get_irq_props(struct mdesc_handle *mdesc, u64 node,
+static int get_irq_props(struct mdesc_handle *mdesc, u64 node,
 				   struct spu_mdesc_info *ip)
 {
 	const u64 *ino;
@@ -1851,7 +1851,7 @@ static int __devinit get_irq_props(struct mdesc_handle *mdesc, u64 node,
 	return 0;
 }
 
-static int __devinit grab_mdesc_irq_props(struct mdesc_handle *mdesc,
+static int grab_mdesc_irq_props(struct mdesc_handle *mdesc,
 					  struct platform_device *dev,
 					  struct spu_mdesc_info *ip,
 					  const char *node_name)
@@ -1883,7 +1883,7 @@ static int __devinit grab_mdesc_irq_props(struct mdesc_handle *mdesc,
 static unsigned long n2_spu_hvapi_major;
 static unsigned long n2_spu_hvapi_minor;
 
-static int __devinit n2_spu_hvapi_register(void)
+static int n2_spu_hvapi_register(void)
 {
 	int err;
 
@@ -1909,7 +1909,7 @@ static void n2_spu_hvapi_unregister(void)
 
 static int global_ref;
 
-static int __devinit grab_global_resources(void)
+static int grab_global_resources(void)
 {
 	int err = 0;
 
@@ -1973,7 +1973,7 @@ static void release_global_resources(void)
 	mutex_unlock(&spu_lock);
 }
 
-static struct n2_crypto * __devinit alloc_n2cp(void)
+static struct n2_crypto *alloc_n2cp(void)
 {
 	struct n2_crypto *np = kzalloc(sizeof(struct n2_crypto), GFP_KERNEL);
 
@@ -1993,7 +1993,7 @@ static void free_n2cp(struct n2_crypto *np)
 	kfree(np);
 }
 
-static void __devinit n2_spu_driver_version(void)
+static void n2_spu_driver_version(void)
 {
 	static int n2_spu_version_printed;
 
@@ -2001,7 +2001,7 @@ static void __devinit n2_spu_driver_version(void)
 		pr_info("%s", version);
 }
 
-static int __devinit n2_crypto_probe(struct platform_device *dev)
+static int n2_crypto_probe(struct platform_device *dev)
 {
 	struct mdesc_handle *mdesc;
 	const char *full_name;
@@ -2092,7 +2092,7 @@ static int __devexit n2_crypto_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct n2_mau * __devinit alloc_ncp(void)
+static struct n2_mau *alloc_ncp(void)
 {
 	struct n2_mau *mp = kzalloc(sizeof(struct n2_mau), GFP_KERNEL);
 
@@ -2112,7 +2112,7 @@ static void free_ncp(struct n2_mau *mp)
 	kfree(mp);
 }
 
-static int __devinit n2_mau_probe(struct platform_device *dev)
+static int n2_mau_probe(struct platform_device *dev)
 {
 	struct mdesc_handle *mdesc;
 	const char *full_name;
diff --git a/drivers/crypto/nx/nx.c b/drivers/crypto/nx/nx.c
index f7a8a16..6302c93 100644
--- a/drivers/crypto/nx/nx.c
+++ b/drivers/crypto/nx/nx.c
@@ -634,7 +634,7 @@ void nx_crypto_ctx_exit(struct crypto_tfm *tfm)
 	nx_ctx->out_sg = NULL;
 }
 
-static int __devinit nx_probe(struct vio_dev *viodev,
+static int nx_probe(struct vio_dev *viodev,
 			      const struct vio_device_id *id)
 {
 	dev_dbg(&viodev->dev, "driver probed: %s resource id: 0x%x\n",
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index d76fe06..fb037ff 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1137,7 +1137,7 @@ static void omap_sham_dma_cleanup(struct omap_sham_dev *dd)
 	}
 }
 
-static int __devinit omap_sham_probe(struct platform_device *pdev)
+static int omap_sham_probe(struct platform_device *pdev)
 {
 	struct omap_sham_dev *dd;
 	struct device *dev = &pdev->dev;
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index a279f93..6eb91e6 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1708,7 +1708,7 @@ static bool spacc_is_compatible(struct platform_device *pdev,
 	return false;
 }
 
-static int __devinit spacc_probe(struct platform_device *pdev)
+static int spacc_probe(struct platform_device *pdev)
 {
 	int i, err, ret = -EINVAL;
 	struct resource *mem, *irq;
-- 
1.8.0
