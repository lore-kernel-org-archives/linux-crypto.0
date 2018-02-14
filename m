From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/2] crypto: omap: Improve a size determination in three
 functions
Date: Wed, 14 Feb 2018 16:26:36 +0100
Message-ID: <0a45e47f-5ed0-5dd6-7545-adc8df2d7972@users.sourceforge.net>
References: <28780631-d093-a581-8690-3868f8fa327e@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Joel Fernandes <joelf@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <28780631-d093-a581-8690-3868f8fa327e@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 14 Feb 2018 16:12:05 +0100

Replace the specification of data structures by pointer dereferences
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/crypto/omap-aes.c  | 3 +--
 drivers/crypto/omap-des.c  | 3 +--
 drivers/crypto/omap-sham.c | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index a2bac3b869b6..82282a5e9b3f 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1032,14 +1032,13 @@ static int omap_aes_get_res_pdev(struct omap_aes_dev *dd,
 static int omap_aes_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct omap_aes_dev *dd;
 	struct crypto_alg *algp;
 	struct aead_alg *aalg;
 	struct resource res;
 	int err = -ENOMEM, i, j, irq = -1;
 	u32 reg;
+	struct omap_aes_dev *dd = devm_kzalloc(dev, sizeof(*dd), GFP_KERNEL);
 
-	dd = devm_kzalloc(dev, sizeof(struct omap_aes_dev), GFP_KERNEL);
 	if (!dd)
 		goto err_data;
 
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index f4199be783a9..09833709fbed 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -957,13 +957,12 @@ static int omap_des_get_pdev(struct omap_des_dev *dd,
 static int omap_des_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct omap_des_dev *dd;
 	struct crypto_alg *algp;
 	struct resource *res;
 	int err = -ENOMEM, i, j, irq = -1;
 	u32 reg;
+	struct omap_des_dev *dd = devm_kzalloc(dev, sizeof(*dd), GFP_KERNEL);
 
-	dd = devm_kzalloc(dev, sizeof(struct omap_des_dev), GFP_KERNEL);
 	if (!dd)
 		goto err_data;
 
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 7aa4eb50ebc9..ffa3ac3bde55 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2015,14 +2015,13 @@ static int omap_sham_get_res_pdev(struct omap_sham_dev *dd,
 
 static int omap_sham_probe(struct platform_device *pdev)
 {
-	struct omap_sham_dev *dd;
 	struct device *dev = &pdev->dev;
 	struct resource res;
 	dma_cap_mask_t mask;
 	int err, i, j;
 	u32 rev;
+	struct omap_sham_dev *dd = devm_kzalloc(dev, sizeof(*dd), GFP_KERNEL);
 
-	dd = devm_kzalloc(dev, sizeof(struct omap_sham_dev), GFP_KERNEL);
 	if (dd == NULL) {
 		err = -ENOMEM;
 		goto data_err;
-- 
2.16.1
