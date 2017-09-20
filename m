From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH] crypto: omap: use of_device_get_match_data
Date: Wed, 20 Sep 2017 20:42:48 +0200
Message-ID: <20170920184248.21027-1-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34587 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751361AbdITSpA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Sep 2017 14:45:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The usage of of_device_get_match_data reduce the code size a bit.
Furthermore, it prevents an improbable dereference when
of_match_device() return NULL.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 drivers/crypto/omap-aes.c  | 7 ++-----
 drivers/crypto/omap-des.c  | 7 ++-----
 drivers/crypto/omap-sham.c | 7 ++-----
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 1f3686a1ebfa..fbec0a2e76dd 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -975,11 +975,10 @@ static int omap_aes_get_res_of(struct omap_aes_dev *dd,
 		struct device *dev, struct resource *res)
 {
 	struct device_node *node = dev->of_node;
-	const struct of_device_id *match;
 	int err = 0;
 
-	match = of_match_device(of_match_ptr(omap_aes_of_match), dev);
-	if (!match) {
+	dd->pdata = of_device_get_match_data(dev);
+	if (!dd->pdata) {
 		dev_err(dev, "no compatible OF match\n");
 		err = -EINVAL;
 		goto err;
@@ -992,8 +991,6 @@ static int omap_aes_get_res_of(struct omap_aes_dev *dd,
 		goto err;
 	}
 
-	dd->pdata = match->data;
-
 err:
 	return err;
 }
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index d37c9506c36c..ebc5c0f11f03 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -928,16 +928,13 @@ MODULE_DEVICE_TABLE(of, omap_des_of_match);
 static int omap_des_get_of(struct omap_des_dev *dd,
 		struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 
-	match = of_match_device(of_match_ptr(omap_des_of_match), &pdev->dev);
-	if (!match) {
+	dd->pdata = of_device_get_match_data(&pdev->dev);
+	if (!dd->pdata) {
 		dev_err(&pdev->dev, "no compatible OF match\n");
 		return -EINVAL;
 	}
 
-	dd->pdata = match->data;
-
 	return 0;
 }
 #else
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index c40ac30ec002..86b89ace836f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1944,11 +1944,10 @@ static int omap_sham_get_res_of(struct omap_sham_dev *dd,
 		struct device *dev, struct resource *res)
 {
 	struct device_node *node = dev->of_node;
-	const struct of_device_id *match;
 	int err = 0;
 
-	match = of_match_device(of_match_ptr(omap_sham_of_match), dev);
-	if (!match) {
+	dd->pdata = of_device_get_match_data(dev);
+	if (!dd->pdata) {
 		dev_err(dev, "no compatible OF match\n");
 		err = -EINVAL;
 		goto err;
@@ -1968,8 +1967,6 @@ static int omap_sham_get_res_of(struct omap_sham_dev *dd,
 		goto err;
 	}
 
-	dd->pdata = match->data;
-
 err:
 	return err;
 }
-- 
2.13.5
