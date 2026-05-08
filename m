Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDED526A1AF;
	Fri,  8 May 2026 02:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778207813; cv=none; b=TNw8oZzh+md0FR3CCBGPGPGTEZYwhNFDfCO8r/JP9SULaqgfTXdLIxuz9nsUtHPaIG8dvdvQW0dcnrqOF6V4PKZ0RoMt62LWVHbJXxCXZCp4QvnxGfdx4sOLEoijatkEydBL++gEWKu+xY3POONq1LMURONzrpHsT7FdpIjl9s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778207813; c=relaxed/simple;
	bh=1cr3uwDCOLe2xAzmh05qeoQ9WTC8kgnA7SfASHugnZo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oQwvya82B0S0fsz7kVlelAosJvZekfikyyfdvxVETktiEmUqS/kreFuy2BTgARSA0YypCFMT7838WCBmzhDR9c1kYjyJ0jI2r7oxylkEtyZQaE8nbL7sqqu7uRxnjqvNbAe75fSCB9GHyepSzv6NXuJrtOo4FuRkC2QFzxsr9L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=MY8CLf3C; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="MY8CLf3C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=lF
	7Yb+cpLPx9xSLiXZvacb2sR9rjLv9VLJIsXkcXyDM=; b=MY8CLf3C847vzjHn+S
	SDjgH5JwV/RYgWEynApgpgRSf1jyFkDeXBxOKMVPMCuQxhKt+Qmw3KrbUNLSdhXc
	MOmQ+9ITjK28opkxYfXIh7grSilzNBOJA2lr4eamvRSOdFSTKmMeWMbCrhlvA+wZ
	L9/iGerFZKpK/b35OTGRXL/Gk=
Received: from wmy.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDH6qIATP1p20ZACw--.1139S2;
	Fri, 08 May 2026 10:35:53 +0800 (CST)
From: w15303746062@163.com
To: giovanni.cabiddu@intel.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: thorsten.blum@linux.dev,
	kees@kernel.org,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>
Subject: [PATCH] crypto: qat - fix Use-After-Free in adf_ctl_ioctl_dev_start()
Date: Fri,  8 May 2026 10:35:42 +0800
Message-Id: <20260508023542.256299-1-w15303746062@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDH6qIATP1p20ZACw--.1139S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAF1DKFW8urWrKrWftF1UZFb_yoWrZw13pr
	W8WayrtryDtrsruryjkrWru3WF9wn2v343CFyxGw1Ikw4UXFyrC34YgFyUGr1rCFWkuFyD
	XF4DZa129ryUJrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UlLv_UUUUU=
X-CM-SenderInfo: jzrvjiatxuliiws6il2tof0z/xtbC4wnu0mn9TAmJjgAA3A

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

A severe Use-After-Free (UAF) vulnerability, which KASAN detects as a
slab-out-of-bounds access, was identified in the QAT driver's ioctl path.

When handling commands like IOCTL_START_ACCEL_DEV, various functions
retrieve the acceleration device using adf_devmgr_get_dev_by_id().
Currently, this lookup function iterates over the accel_table under
the table_lock. However, once the target device is found, the lock is
dropped and a bare pointer is returned without bumping the device's
reference count.

This creates a critical race condition. If a concurrent thread removes
the device (e.g., via device stop operations or PCIe hotplug) by calling
adf_devmgr_rm_dev(), the device is removed from the list and its memory
is subsequently freed. When the original ioctl thread resumes and attempts
to acquire accel_dev->state_lock inside adf_dev_up(), it triggers a
KASAN panic.

Fix this by acquiring the reference count inside adf_devmgr_get_dev_by_id()
via adf_dev_get() while the table_lock is still held. If adf_dev_get()
fails (e.g., the module is unloading), we safely break the loop and treat
the device as not found. All callers of adf_devmgr_get_dev_by_id() are then
updated to properly release the reference using adf_dev_put() when done.

Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
---
 .../crypto/intel/qat/qat_common/adf_ctl_drv.c  | 16 ++++++++++++++++
 .../crypto/intel/qat/qat_common/adf_dev_mgr.c  | 18 +++++++++++++++---
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
index c2e6f0cb7480..0519cc02e634 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -201,6 +201,10 @@ static int adf_ctl_ioctl_dev_config(struct file *fp, unsigned int cmd,
 	}
 	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
 out:
+	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
+	if (accel_dev)
+		adf_dev_put(accel_dev);
+
 	kfree(ctl_data);
 	return ret;
 }
@@ -278,6 +282,10 @@ static int adf_ctl_ioctl_dev_stop(struct file *fp, unsigned int cmd,
 	adf_ctl_stop_devices(ctl_data->device_id);
 
 out:
+	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
+	if (accel_dev)
+		adf_dev_put(accel_dev);
+
 	kfree(ctl_data);
 	return ret;
 }
@@ -310,6 +318,10 @@ static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
 		adf_dev_down(accel_dev);
 	}
 out:
+	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
+	if (accel_dev)
+		adf_dev_put(accel_dev);
+
 	kfree(ctl_data);
 	return ret;
 }
@@ -360,8 +372,12 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
 	if (copy_to_user((void __user *)arg, &dev_info,
 			 sizeof(struct adf_dev_status_info))) {
 		dev_err(&GET_DEV(accel_dev), "failed to copy status.\n");
+		adf_dev_put(accel_dev);
 		return -EFAULT;
 	}
+	/* Release the reference acquired by adf_devmgr_get_dev_by_id() */
+	adf_dev_put(accel_dev);
+
 	return 0;
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index e050de16ab5d..5e9313d8bacf 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -320,8 +320,14 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id)
 		struct adf_accel_dev *ptr =
 				list_entry(itr, struct adf_accel_dev, list);
 		if (ptr->accel_id == id) {
-			mutex_unlock(&table_lock);
-			return ptr;
+			/* Increment refcount to prevent UAF during removal.
+			 * If adf_dev_get() fails, the module is unloading.
+			 */
+			if (adf_dev_get(ptr) == 0) {
+				mutex_unlock(&table_lock);
+				return ptr;
+			}
+			break;
 		}
 	}
 unlock:
@@ -331,11 +337,17 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(u32 id)
 
 int adf_devmgr_verify_id(u32 id)
 {
+	struct adf_accel_dev *accel_dev;
+
 	if (id == ADF_CFG_ALL_DEVICES)
 		return 0;
 
-	if (adf_devmgr_get_dev_by_id(id))
+	accel_dev = adf_devmgr_get_dev_by_id(id);
+	if (accel_dev) {
+		/* Release the reference immediately as we only verify existence */
+		adf_dev_put(accel_dev);
 		return 0;
+	}
 
 	return -ENODEV;
 }
-- 
2.34.1

