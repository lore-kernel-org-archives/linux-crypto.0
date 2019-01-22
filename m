Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273CCC282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B4C217D4
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548170078;
	bh=svdj2mFEmqwog0Nb1hRlIR6GVZQhgx6zqxWH7cI3Rs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UwNykaA7e/7sRzLpOiMqNZvePiDSLKcZjBJ/ZFm4wXGlekGSE5y397MwamTys9A90
	 9V8gQf0CmhLBYcaDvkL4zkOVoE1Kglkfu+QmvmANZSnUxw5kA9qI4Dpdr6W8xv4VnJ
	 +U4ni1hhYMqXdmaHNDcdlgrtwDwA9rXI8Vh9ElNY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfAVPOh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:14:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbfAVPOh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 10:14:37 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7935720879;
        Tue, 22 Jan 2019 15:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548170076;
        bh=svdj2mFEmqwog0Nb1hRlIR6GVZQhgx6zqxWH7cI3Rs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMoP1jMXuLiIc28RsmwO1AFsYqw+ppUJ0t89GsDdNLvLLltL/kWFiPt78HelCqU3G
         RgKzxKVV/qMJo/8gGQpBR8jZ76HaCiY2l+8NmqUFEeVLUpCugBX4Pib0z60ong1EjI
         skKtdfoznMxqOpW0TufCbePH225qqUVFK7j5U3Ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Conor McLoughlin <conor.mcloughlin@intel.com>,
        Waiman Long <longman@redhat.com>, qat-linux@intel.com
Subject: [PATCH 1/7] crypto: qat: no need to check return value of debugfs_create functions
Date:   Tue, 22 Jan 2019 16:14:16 +0100
Message-Id: <20190122151422.14204-2-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190122151422.14204-1-gregkh@linuxfoundation.org>
References: <20190122151422.14204-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Conor McLoughlin <conor.mcloughlin@intel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: qat-linux@intel.com
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/qat/qat_c3xxx/adf_drv.c            |  5 -----
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c          |  5 -----
 drivers/crypto/qat/qat_c62x/adf_drv.c             |  5 -----
 drivers/crypto/qat/qat_c62xvf/adf_drv.c           |  5 -----
 drivers/crypto/qat/qat_common/adf_cfg.c           |  7 -------
 drivers/crypto/qat/qat_common/adf_transport.c     |  6 ------
 .../crypto/qat/qat_common/adf_transport_debug.c   | 15 ---------------
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |  5 -----
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c       |  5 -----
 9 files changed, 58 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 763c2166ee0e..d937cc7248a5 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -193,11 +193,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 PCI_FUNC(pdev->devfn));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-	if (!accel_dev->debugfs_dir) {
-		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
-		ret = -EINVAL;
-		goto out_err;
-	}
 
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index 613c7d5644ce..1dc5ac859f7b 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -177,11 +177,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 PCI_FUNC(pdev->devfn));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-	if (!accel_dev->debugfs_dir) {
-		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
-		ret = -EINVAL;
-		goto out_err;
-	}
 
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 9cb832963357..2bc06c89d2fe 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -193,11 +193,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 PCI_FUNC(pdev->devfn));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-	if (!accel_dev->debugfs_dir) {
-		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
-		ret = -EINVAL;
-		goto out_err;
-	}
 
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 278452b8ef81..a68358b31292 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -177,11 +177,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 PCI_FUNC(pdev->devfn));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-	if (!accel_dev->debugfs_dir) {
-		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
-		ret = -EINVAL;
-		goto out_err;
-	}
 
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index d0879790561f..5c7fdb0fc53d 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -141,13 +141,6 @@ int adf_cfg_dev_add(struct adf_accel_dev *accel_dev)
 						  accel_dev->debugfs_dir,
 						  dev_cfg_data,
 						  &qat_dev_cfg_fops);
-	if (!dev_cfg_data->debug) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to create qat cfg debugfs entry.\n");
-		kfree(dev_cfg_data);
-		accel_dev->cfg = NULL;
-		return -EFAULT;
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(adf_cfg_dev_add);
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 57d2622728a5..ac658ce46836 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -486,12 +486,6 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 	/* accel_dev->debugfs_dir should always be non-NULL here */
 	etr_data->debug = debugfs_create_dir("transport",
 					     accel_dev->debugfs_dir);
-	if (!etr_data->debug) {
-		dev_err(&GET_DEV(accel_dev),
-			"Unable to create transport debugfs entry\n");
-		ret = -ENOENT;
-		goto err_bank_debug;
-	}
 
 	for (i = 0; i < num_banks; i++) {
 		ret = adf_init_bank(accel_dev, &etr_data->banks[i], i,
diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index 52340b9bb387..e794e9d97b2c 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -163,11 +163,6 @@ int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 	ring_debug->debug = debugfs_create_file(entry_name, S_IRUSR,
 						ring->bank->bank_debug_dir,
 						ring, &adf_ring_debug_fops);
-	if (!ring_debug->debug) {
-		pr_err("QAT: Failed to create ring debug entry.\n");
-		kfree(ring_debug);
-		return -EFAULT;
-	}
 	ring->ring_debug = ring_debug;
 	return 0;
 }
@@ -271,19 +266,9 @@ int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
 
 	snprintf(name, sizeof(name), "bank_%02d", bank->bank_number);
 	bank->bank_debug_dir = debugfs_create_dir(name, parent);
-	if (!bank->bank_debug_dir) {
-		pr_err("QAT: Failed to create bank debug dir.\n");
-		return -EFAULT;
-	}
-
 	bank->bank_debug_cfg = debugfs_create_file("config", S_IRUSR,
 						   bank->bank_debug_dir, bank,
 						   &adf_bank_debug_fops);
-	if (!bank->bank_debug_cfg) {
-		pr_err("QAT: Failed to create bank debug entry.\n");
-		debugfs_remove(bank->bank_debug_dir);
-		return -EFAULT;
-	}
 	return 0;
 }
 
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 3a9708ef4ce2..b11bf8c0e683 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -193,11 +193,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 PCI_FUNC(pdev->devfn));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-	if (!accel_dev->debugfs_dir) {
-		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
-		ret = -EINVAL;
-		goto out_err;
-	}
 
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 3da0f951cb59..1b762eefc6c1 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -177,11 +177,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 PCI_FUNC(pdev->devfn));
 
 	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-	if (!accel_dev->debugfs_dir) {
-		dev_err(&pdev->dev, "Could not create debugfs dir %s\n", name);
-		ret = -EINVAL;
-		goto out_err;
-	}
 
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
-- 
2.20.1

