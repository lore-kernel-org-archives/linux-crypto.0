Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F47CC7EE23
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 15:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjB0Ppk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 10:45:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjB0Ppg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 10:45:36 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A821EBFC
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 07:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677512694; x=1709048694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=dpji1hPCEECUgxr6ginGVHTPigaWZJFIuLfNEtrxjUo=;
  b=SR/5LCrEwa31AMlJaI2SdaMgJ7ktSn3phSDEQ0+r8BTHdx0Clwl+dQyq
   HWX7oQx752H1RuxJBtTx5LncZybZV2ovB9I6irFRppuryfOfQbylAWb4h
   blPQ0Q4beGwFURr6XzduVbFPV//JKmlMVrsvAOqI7TUkqREQkZTTWiF5N
   GzeLBRy/bfZgOhCRgz1XytUHWdpMDMduFmvDJ0Y1S6IJihZT0BuQ/ss0y
   eGiCd9z+ZAG0XP7SF+L9ec/xE5FLXS9SyktNhfn4immtwbIuidzvsuWqJ
   XKk/ZGDFvHXICPukCHHPC1X4gk0L5JsIg2jQCwLBc/dfMHfGp+0ochdKe
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="336166221"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="336166221"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 07:44:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919392268"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="919392268"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 07:44:18 -0800
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH 3/5] crypto: qat - replace state machine calls
Date:   Mon, 27 Feb 2023 15:55:43 -0500
Message-Id: <20230227205545.5796-4-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20230227205545.5796-1-shashank.gupta@intel.com>
References: <20230227205545.5796-1-shashank.gupta@intel.com>
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The device state machine functions are unsafe and interdependent on each
other. To perform a state transition, these shall be called in a
specific order:
  * device up:   adf_dev_init() -> adf_dev_start()
  * device down: adf_dev_stop() -> adf_dev_shutdown()

Replace all the state machine functions used in the QAT driver with the
safe wrappers adf_dev_up() and adf_dev_down().

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c       | 17 +++--------------
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 17 +++--------------
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 13 +++----------
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 17 +++--------------
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 13 +++----------
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 27 +++++++++------------------
 drivers/crypto/qat/qat_common/adf_sriov.c   | 10 ++--------
 drivers/crypto/qat/qat_common/adf_vf_isr.c  |  3 +--
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 17 +++--------------
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 13 +++----------
 10 files changed, 33 insertions(+), 114 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index f7fdb435a70e..6f862b56c51c 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -411,15 +411,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = hw_data->dev_config(accel_dev);
-	if (ret)
-		goto out_err_disable_aer;
-
-	ret = adf_dev_init(accel_dev);
-	if (ret)
-		goto out_err_dev_shutdown;
-
-	ret = adf_dev_start(accel_dev);
+	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
 
@@ -430,9 +422,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_stop(accel_dev);
-out_err_dev_shutdown:
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 out_err_disable_aer:
 	adf_disable_aer(accel_dev);
 out_err:
@@ -448,8 +438,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
 }
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
index 1f4fbf4562b2..4c00c4933805 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_drv.c
@@ -201,24 +201,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = hw_data->dev_config(accel_dev);
-	if (ret)
-		goto out_err_disable_aer;
-
-	ret = adf_dev_init(accel_dev);
-	if (ret)
-		goto out_err_dev_shutdown;
-
-	ret = adf_dev_start(accel_dev);
+	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
 
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_stop(accel_dev);
-out_err_dev_shutdown:
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 out_err_disable_aer:
 	adf_disable_aer(accel_dev);
 out_err_free_reg:
@@ -239,8 +229,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index cf4ef83e186f..e8cc10f64134 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -173,20 +173,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
-	ret = adf_dev_init(accel_dev);
-	if (ret)
-		goto out_err_dev_shutdown;
-
-	ret = adf_dev_start(accel_dev);
+	ret = adf_dev_up(accel_dev, false);
 	if (ret)
 		goto out_err_dev_stop;
 
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_stop(accel_dev);
-out_err_dev_shutdown:
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -206,8 +200,7 @@ static void adf_remove(struct pci_dev *pdev)
 		return;
 	}
 	adf_flush_vf_wq(accel_dev);
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
diff --git a/drivers/crypto/qat/qat_c62x/adf_drv.c b/drivers/crypto/qat/qat_c62x/adf_drv.c
index 4ccaf298250c..fcb2f5b8e053 100644
--- a/drivers/crypto/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62x/adf_drv.c
@@ -201,24 +201,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = hw_data->dev_config(accel_dev);
-	if (ret)
-		goto out_err_disable_aer;
-
-	ret = adf_dev_init(accel_dev);
-	if (ret)
-		goto out_err_dev_shutdown;
-
-	ret = adf_dev_start(accel_dev);
+	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
 
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_stop(accel_dev);
-out_err_dev_shutdown:
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 out_err_disable_aer:
 	adf_disable_aer(accel_dev);
 out_err_free_reg:
@@ -239,8 +229,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 0e642c94b929..37566309df94 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -173,20 +173,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
-	ret = adf_dev_init(accel_dev);
-	if (ret)
-		goto out_err_dev_shutdown;
-
-	ret = adf_dev_start(accel_dev);
+	ret = adf_dev_up(accel_dev, false);
 	if (ret)
 		goto out_err_dev_stop;
 
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_stop(accel_dev);
-out_err_dev_shutdown:
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -206,8 +200,7 @@ static void adf_remove(struct pci_dev *pdev)
 		return;
 	}
 	adf_flush_vf_wq(accel_dev);
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 9190532b27eb..b79ce4d0cc44 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -243,8 +243,7 @@ static void adf_ctl_stop_devices(u32 id)
 			if (!accel_dev->is_vf)
 				continue;
 
-			adf_dev_stop(accel_dev);
-			adf_dev_shutdown(accel_dev);
+			adf_dev_down(accel_dev, false);
 		}
 	}
 
@@ -253,8 +252,7 @@ static void adf_ctl_stop_devices(u32 id)
 			if (!adf_dev_started(accel_dev))
 				continue;
 
-			adf_dev_stop(accel_dev);
-			adf_dev_shutdown(accel_dev);
+			adf_dev_down(accel_dev, false);
 		}
 	}
 }
@@ -308,23 +306,16 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 	if (!accel_dev)
 		goto out;
 
-	if (!adf_dev_started(accel_dev)) {
-		dev_info(&GET_DEV(accel_dev),
-			 "Starting acceleration device qat_dev%d.\n",
-			 ctl_data->device_id);
-		ret = adf_dev_init(accel_dev);
-		if (!ret)
-			ret = adf_dev_start(accel_dev);
-	} else {
-		dev_info(&GET_DEV(accel_dev),
-			 "Acceleration device qat_dev%d already started.\n",
-			 ctl_data->device_id);
-	}
+	dev_info(&GET_DEV(accel_dev),
+		 "Starting acceleration device qat_dev%d.\n",
+		 ctl_data->device_id);
+
+	ret = adf_dev_up(accel_dev, false);
+
 	if (ret) {
 		dev_err(&GET_DEV(accel_dev), "Failed to start qat_dev%d\n",
 			ctl_data->device_id);
-		adf_dev_stop(accel_dev);
-		adf_dev_shutdown(accel_dev);
+		adf_dev_down(accel_dev, false);
 	}
 out:
 	kfree(ctl_data);
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index d85a90cc387b..f44025bb6f99 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -159,7 +159,7 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 			return -EBUSY;
 		}
 
-		ret = adf_dev_shutdown_cache_cfg(accel_dev);
+		ret = adf_dev_down(accel_dev, true);
 		if (ret)
 			return ret;
 	}
@@ -184,13 +184,7 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 	if (!accel_dev->pf.vf_info)
 		return -ENOMEM;
 
-	if (adf_dev_init(accel_dev)) {
-		dev_err(&GET_DEV(accel_dev), "Failed to init qat_dev%d\n",
-			accel_dev->accel_id);
-		return -EFAULT;
-	}
-
-	if (adf_dev_start(accel_dev)) {
+	if (adf_dev_up(accel_dev, false)) {
 		dev_err(&GET_DEV(accel_dev), "Failed to start qat_dev%d\n",
 			accel_dev->accel_id);
 		return -EFAULT;
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 8c95fcd8e64b..b05c3957a160 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -71,8 +71,7 @@ static void adf_dev_stop_async(struct work_struct *work)
 	struct adf_accel_dev *accel_dev = stop_data->accel_dev;
 
 	adf_dev_restarting_notify(accel_dev);
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 
 	/* Re-enable PF2VF interrupts */
 	adf_enable_pf2vf_interrupts(accel_dev);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index ebeb17b67fcd..4d27e4e43642 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -201,24 +201,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_disable_aer;
 	}
 
-	ret = hw_data->dev_config(accel_dev);
-	if (ret)
-		goto out_err_disable_aer;
-
-	ret = adf_dev_init(accel_dev);
-	if (ret)
-		goto out_err_dev_shutdown;
-
-	ret = adf_dev_start(accel_dev);
+	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
 
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_stop(accel_dev);
-out_err_dev_shutdown:
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 out_err_disable_aer:
 	adf_disable_aer(accel_dev);
 out_err_free_reg:
@@ -239,8 +229,7 @@ static void adf_remove(struct pci_dev *pdev)
 		pr_err("QAT: Driver removal failed\n");
 		return;
 	}
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 	adf_disable_aer(accel_dev);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index c1485e702b3e..96854a1cd87e 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -173,20 +173,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
-	ret = adf_dev_init(accel_dev);
-	if (ret)
-		goto out_err_dev_shutdown;
-
-	ret = adf_dev_start(accel_dev);
+	ret = adf_dev_up(accel_dev, false);
 	if (ret)
 		goto out_err_dev_stop;
 
 	return ret;
 
 out_err_dev_stop:
-	adf_dev_stop(accel_dev);
-out_err_dev_shutdown:
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 out_err_free_reg:
 	pci_release_regions(accel_pci_dev->pci_dev);
 out_err_disable:
@@ -206,8 +200,7 @@ static void adf_remove(struct pci_dev *pdev)
 		return;
 	}
 	adf_flush_vf_wq(accel_dev);
-	adf_dev_stop(accel_dev);
-	adf_dev_shutdown(accel_dev);
+	adf_dev_down(accel_dev, false);
 	adf_cleanup_accel(accel_dev);
 	adf_cleanup_pci_dev(accel_dev);
 	kfree(accel_dev);
-- 
2.16.4

