Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 195D4C07E9C
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Jul 2021 06:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8F3A613B6
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Jul 2021 06:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhGKGQU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Jul 2021 02:16:20 -0400
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:30510 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhGKGQU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Jul 2021 02:16:20 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d42 with ME
        id TiDY2500721Fzsu03iDZm3; Sun, 11 Jul 2021 08:13:33 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 11 Jul 2021 08:13:33 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, tomaszx.kowalik@intel.com,
        marco.chiappero@intel.com, andriy.shevchenko@linux.intel.com,
        fiona.trahe@intel.com, wojciech.ziemba@intel.com,
        ztong0001@gmail.com, qat-linux@intel.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/3] crypto: qat - Disable AER if an error occurs in probe functions
Date:   Sun, 11 Jul 2021 08:13:31 +0200
Message-Id: <a19132d07a65dbef5e818f84b2bc971f26cc3805.1625983602.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1625983602.git.christophe.jaillet@wanadoo.fr>
References: <cover.1625983602.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

If an error occurs after a 'adf_enable_aer()' call, it must be undone by a
corresponding 'adf_disable_aer()' call, as already done in the remove
function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c    | 6 ++++--
 drivers/crypto/qat/qat_c62x/adf_drv.c     | 6 ++++--
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index cc4ed61478a8..aa5078177e5d 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -203,12 +203,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 	}
 
 	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 
 	ret = adf_dev_init(accel_dev);
 	if (ret)
@@ -224,6 +224,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_dev_stop(accel_dev);
 out_err_dev_shutdown:
 	adf_dev_shutdown(accel_dev);
+out_err_disable_aer:
+	adf_disable_aer(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 5e2fc0c1a759..54ab8291be73 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -203,12 +203,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 	}
 
 	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 
 	ret = adf_dev_init(accel_dev);
 	if (ret)
@@ -224,6 +224,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_dev_stop(accel_dev);
 out_err_dev_shutdown:
 	adf_dev_shutdown(accel_dev);
+out_err_disable_aer:
+	adf_disable_aer(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index d0bd18e65104..507663bc5d54 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -203,12 +203,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (pci_save_state(pdev)) {
 		dev_err(&pdev->dev, "Failed to save pci state\n");
 		ret = -ENOMEM;
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 	}
 
 	ret = qat_crypto_dev_config(accel_dev);
 	if (ret)
-		goto out_err_free_reg;
+		goto out_err_disable_aer;
 
 	ret = adf_dev_init(accel_dev);
 	if (ret)
@@ -224,6 +224,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	adf_dev_stop(accel_dev);
 out_err_dev_shutdown:
 	adf_dev_shutdown(accel_dev);
+out_err_disable_aer:
+	adf_disable_aer(accel_dev);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
-- 
2.30.2

