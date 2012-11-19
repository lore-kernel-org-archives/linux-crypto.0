From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 053/493] crypto: remove use of __devexit_p
Date: Mon, 19 Nov 2012 13:20:02 -0500
Message-ID: <1353349642-3677-53-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-geode@lists.infradead.org,
 "David S. Miller" <davem@davemloft.net>
To: gregkh@linuxfoundation.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

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
 drivers/crypto/caam/ctrl.c        | 2 +-
 drivers/crypto/geode-aes.c        | 2 +-
 drivers/crypto/hifn_795x.c        | 2 +-
 drivers/crypto/mv_cesa.c          | 2 +-
 drivers/crypto/n2_core.c          | 4 ++--
 drivers/crypto/picoxcell_crypto.c | 2 +-
 drivers/crypto/tegra-aes.c        | 2 +-
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 8061336..3cfa548 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1185,7 +1185,7 @@ static int __devexit atmel_aes_remove(struct platform_device *pdev)
 
 static struct platform_driver atmel_aes_driver = {
 	.probe		= atmel_aes_probe,
-	.remove		= __devexit_p(atmel_aes_remove),
+	.remove		= atmel_aes_remove,
 	.driver		= {
 		.name	= "atmel_aes",
 		.owner	= THIS_MODULE,
diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index bcdf55f..4fb07609 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1093,7 +1093,7 @@ static int __devexit atmel_sha_remove(struct platform_device *pdev)
 
 static struct platform_driver atmel_sha_driver = {
 	.probe		= atmel_sha_probe,
-	.remove		= __devexit_p(atmel_sha_remove),
+	.remove		= atmel_sha_remove,
 	.driver		= {
 		.name	= "atmel_sha",
 		.owner	= THIS_MODULE,
diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index 7495f98..530474f 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -1195,7 +1195,7 @@ static int __devexit atmel_tdes_remove(struct platform_device *pdev)
 
 static struct platform_driver atmel_tdes_driver = {
 	.probe		= atmel_tdes_probe,
-	.remove		= __devexit_p(atmel_tdes_remove),
+	.remove		= atmel_tdes_remove,
 	.driver		= {
 		.name	= "atmel_tdes",
 		.owner	= THIS_MODULE,
diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
index 5398580..eecaae2 100644
--- a/drivers/crypto/bfin_crc.c
+++ b/drivers/crypto/bfin_crc.c
@@ -731,7 +731,7 @@ static int __devexit bfin_crypto_crc_remove(struct platform_device *pdev)
 
 static struct platform_driver bfin_crypto_crc_driver = {
 	.probe     = bfin_crypto_crc_probe,
-	.remove    = __devexit_p(bfin_crypto_crc_remove),
+	.remove    = bfin_crypto_crc_remove,
 	.suspend   = bfin_crypto_crc_suspend,
 	.resume    = bfin_crypto_crc_resume,
 	.driver    = {
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index bf20dd8..1c56f63 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -420,7 +420,7 @@ static struct platform_driver caam_driver = {
 		.of_match_table = caam_match,
 	},
 	.probe       = caam_probe,
-	.remove      = __devexit_p(caam_remove),
+	.remove      = caam_remove,
 };
 
 module_platform_driver(caam_driver);
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 51f196d..3217baf 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -582,7 +582,7 @@ static struct pci_driver geode_aes_driver = {
 	.name = "Geode LX AES",
 	.id_table = geode_aes_tbl,
 	.probe = geode_aes_probe,
-	.remove = __devexit_p(geode_aes_remove)
+	.remove = geode_aes_remove
 };
 
 module_pci_driver(geode_aes_driver);
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index fda3296..4c2f467 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2740,7 +2740,7 @@ static struct pci_driver hifn_pci_driver = {
 	.name     = "hifn795x",
 	.id_table = hifn_pci_tbl,
 	.probe    = hifn_probe,
-	.remove   = __devexit_p(hifn_remove),
+	.remove   = hifn_remove,
 };
 
 static int __init hifn_init(void)
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 24ccae4..ce6290e 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -1184,7 +1184,7 @@ MODULE_DEVICE_TABLE(of, mv_cesa_of_match_table);
 
 static struct platform_driver marvell_crypto = {
 	.probe		= mv_probe,
-	.remove		= __devexit_p(mv_remove),
+	.remove		= mv_remove,
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= "mv_crypto",
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index aab2574..2741ef5 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -2217,7 +2217,7 @@ static struct platform_driver n2_crypto_driver = {
 		.of_match_table	=	n2_crypto_match,
 	},
 	.probe		=	n2_crypto_probe,
-	.remove		=	__devexit_p(n2_crypto_remove),
+	.remove		=	n2_crypto_remove,
 };
 
 static struct of_device_id n2_mau_match[] = {
@@ -2245,7 +2245,7 @@ static struct platform_driver n2_mau_driver = {
 		.of_match_table	=	n2_mau_match,
 	},
 	.probe		=	n2_mau_probe,
-	.remove		=	__devexit_p(n2_mau_remove),
+	.remove		=	n2_mau_remove,
 };
 
 static int __init n2_init(void)
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index c983f86..a279f93 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -1868,7 +1868,7 @@ static const struct platform_device_id spacc_id_table[] = {
 
 static struct platform_driver spacc_driver = {
 	.probe		= spacc_probe,
-	.remove		= __devexit_p(spacc_remove),
+	.remove		= spacc_remove,
 	.driver		= {
 		.name	= "picochip,spacc",
 #ifdef CONFIG_PM
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index eb32fd8..75f8a55 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -1082,7 +1082,7 @@ static struct of_device_id tegra_aes_of_match[] __devinitdata = {
 
 static struct platform_driver tegra_aes_driver = {
 	.probe  = tegra_aes_probe,
-	.remove = __devexit_p(tegra_aes_remove),
+	.remove = tegra_aes_remove,
 	.driver = {
 		.name   = "tegra-aes",
 		.owner  = THIS_MODULE,
-- 
1.8.0
