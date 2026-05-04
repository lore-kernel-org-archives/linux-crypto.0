Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B719012D1F1;
	Mon,  4 May 2026 02:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777863174; cv=none; b=LA1uFT8IB9w/kaC9aXJS18Rzc+2rbXYXANj4ViVgNkxpUE00XUQ71uXq2mOx5ATC5FR17rW+naE4AjloLQQSGa7TvY2EQW587XwzJMrrKkcEy4NTnIq4bLfHcTjTEKA6CrguVf+79usmK/M5wmj7MAJLc/aqhdP5mi9uwJGzLeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777863174; c=relaxed/simple;
	bh=dhMUW/4dPGc7ZNK+x+vHTf1RFPd1mHnQyh5kmDAgevA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZKhQeMdT1xC2MRFPtxLmHVlzAdZnMQLU8+zuNzQcop5tMasfNWd6CTYgd0tilSDaermAB5dqiCbPTm4WrJ+e4BIyIVjN6bzbRnLmNIgO2PLFBdg9ksNKDb/apN/C5M7F+Z7rhudIvcSBNi8qe/BY0uDpN/Lxv3bqnfzZIDZoSLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fea8MkRd; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fea8MkRd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=HV
	mXrEqYABaL7NbZLSGM8MpsfNkjWapIsMc8tgbACx0=; b=fea8MkRdGmDZWaWkTe
	GUY12mS7pQSug5Wfpo4trcdvGgY42gnzJ+7H7mKJ8IV+a0z0U/XGm21KDrngw8eZ
	JHcqDzvdQ+/JUskKATS9pLQTEcCcPI+x3ZNXCtQjQgdATxZZ1mYUBT4bAoljcWf5
	TCQ89aRPp6Iz4nwrXV7c99bI0=
Received: from wmy.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgAX2S2qCfhplHaqCQ--.283S2;
	Mon, 04 May 2026 10:51:35 +0800 (CST)
From: w15303746062@163.com
To: giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: [PATCH] crypto: qat - fix use-after-free during concurrent device start and removal
Date: Mon,  4 May 2026 10:51:20 +0800
Message-Id: <20260504025120.98242-1-w15303746062@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgAX2S2qCfhplHaqCQ--.283S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFy3Cr1xKFWUCFW5AFW5Wrg_yoWrAr45pr
	s5Way5tryDtrsrGryqy3yrZa4Yv3Wvv34fC343Gwnakw43tFyrC34Yg34UXrZ5CFykCFyD
	ZF4j93y29ryUXrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jcuc_UUUUU=
X-CM-SenderInfo: jzrvjiatxuliiws6il2tof0z/xtbC4xgJ7Gn4CbjHUgAA3r

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

A Use-After-Free (UAF) vulnerability was identified in the QAT driver's ioctl path. When handling commands like IOCTL_START_ACCEL_DEV, `adf_ctl_ioctl_dev_start()` retrieves the acceleration device using `adf_devmgr_get_dev_by_id()`.

Previously, this lookup function iterated over the `accel_table` under the `table_lock`. However, once the target device was found, the lock was dropped and a bare pointer was returned without incrementing the device's reference count.

This creates a critical race condition. If a concurrent thread removes the device (e.g., via device stop operations or PCIe hotplug) by calling `adf_devmgr_rm_dev()`, the device is removed from the list and its memory is subsequently freed. When the original ioctl thread resumes and attempts to acquire `accel_dev->state_lock` inside `adf_dev_up()`, it triggers a KASAN slab-out-of-bounds panic.

Fix this by properly leveraging the existing `ref_count`. Increment the device's `ref_count` via `atomic_inc()` inside `adf_devmgr_get_dev_by_id()` while the `table_lock` is still held. All callers of `adf_devmgr_get_dev_by_id()` are then updated to safely release this reference using `atomic_dec(&accel_dev->ref_count)` once they are done interacting with the device.

Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
---
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c | 10 ++++++++++
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 12 ++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
index c2e6f0cb7480..4924b2bbb412 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -201,6 +201,9 @@ static int adf_ctl_ioctl_dev_config(struct file *fp, unsigned int cmd,
 	}
 	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
 out:
+	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
+	if (accel_dev)
+		atomic_dec(&accel_dev->ref_count);
 	kfree(ctl_data);
 	return ret;
 }
@@ -310,6 +313,9 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 		adf_dev_down(accel_dev);
 	}
 out:
+	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
+	if (accel_dev)
+		atomic_dec(&accel_dev->ref_count);
 	kfree(ctl_data);
 	return ret;
 }
@@ -360,8 +366,12 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
 	if (copy_to_user((void __user *)arg, &dev_info,
 			 sizeof(struct adf_dev_status_info))) {
 		dev_err(&GET_DEV(accel_dev), "failed to copy status.\n");
+		atomic_dec(&accel_dev->ref_count);
 		return -EFAULT;
 	}
+	
+	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
+	atomic_dec(&accel_dev->ref_count);
 	return 0;
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index e050de16ab5d..321bea3cefce 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -320,6 +320,8 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id)
 		struct adf_accel_dev *ptr =
 				list_entry(itr, struct adf_accel_dev, list);
 		if (ptr->accel_id == id) {
+			/* Increment ref_count to prevent UAF during concurrent removal */
+			atomic_inc(&ptr->ref_count);
 			mutex_unlock(&table_lock);
 			return ptr;
 		}
@@ -331,11 +333,17 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id)
 
 int adf_devmgr_verify_id(u32 id)
 {
+	struct adf_accel_dev *accel_dev;
+	
 	if (id == ADF_CFG_ALL_DEVICES)
 		return 0;
 
-	if (adf_devmgr_get_dev_by_id(id))
-		return 0;
+	accel_dev = adf_devmgr_get_dev_by_id(id);
+	if (accel_dev) {
+		/* Release the reference immediately as we only verify existence */
+		atomic_dec(&accel_dev->ref_count);
+ 		return 0;
+	}
 
 	return -ENODEV;
 }
-- 
2.34.1

