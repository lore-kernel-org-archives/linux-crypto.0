Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A696CF9D6;
	Fri, 11 Jul 2025 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752236893; cv=none; b=SeakbFB03Ox6ZGvm39KiyzjfwqbwbdBKFXdzNSu7ZNbg4DLI1vpzEdnMZtYMdvB1FhZo5ucEo8VZqxlSDfNSjusiXJSzHIIQnVDzSA4QqwwJtGrI9Sh3GnPgB1RrjORg01cb7ej2dZOQSg9K5lVTrwGPESRG0UdFf7ZLrsxnX64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752236893; c=relaxed/simple;
	bh=zaidj1cqmri96h3Ou5+kJ33yUWJ+9TE2bFH+MK/FBpM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i1TvMcyKTcL8bYhNB7PzXp+IRwBdFFmTL9FHVU+evx4d+glbzjEVwnVC/1btRvi45hJ9MgGuKw9+SDB2NQCY0yh1Z+luZ04vrg9Hnv+8Ttw3hJUi7ur0gSiDUEV9vqnlPRlQ5QUh3lSmTdFBx3Z+d8tgqldLBw1yM1cEfA2hxgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQH8XQyH; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQH8XQyH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752236892; x=1783772892;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zaidj1cqmri96h3Ou5+kJ33yUWJ+9TE2bFH+MK/FBpM=;
  b=lQH8XQyHqIjx354cz8Y8vlhyVyCnFDB+xMxifA8XqEAAD2px5RHPiKgc
   0q6wOulOJgesLmEZ9SkL7O34Qv+CrSFHCVWD9S/OX/kFYajHUejrBW09L
   XFWL0Gzf47i+Abalv38AiGiujseYLUwOVvU5b8lmlo5iZ/BjU2all/ESC
   saa6oZzfZRKoWgzWq8aGiok+xwawj3FawW+XoPC7cJ3zQhVkYgn1p31H7
   Ad+EbXbX++dMmACF/WrYXrc5LO8CjVu+8xUbzhnrULx3TMuJqcjlCPGWA
   rhchCAxDB5BfMuhFfDEgwln+yxWCfoWtQ5kITianOSSe7fdzFijX0XHCx
   A==;
X-CSE-ConnectionGUID: xenVQfEhRjuOo8OAO8UhIw==
X-CSE-MsgGUID: vqu8abo9SKSysURrYKq/Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54250712"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54250712"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 05:28:11 -0700
X-CSE-ConnectionGUID: JO6JALGURcKgzTVEen9e5Q==
X-CSE-MsgGUID: HiVSZSRcRZmRdc0myLt5oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="160657877"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa005.fm.intel.com with ESMTP; 11 Jul 2025 05:28:09 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - flush misc workqueue during device shutdown
Date: Fri, 11 Jul 2025 13:27:43 +0100
Message-ID: <20250711122753.9824-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Repeated loading and unloading of a device specific QAT driver, for
example qat_4xxx, in a tight loop can lead to a crash due to a
use-after-free scenario. This occurs when a power management (PM)
interrupt triggers just before the device-specific driver (e.g.,
qat_4xxx.ko) is unloaded, while the core driver (intel_qat.ko) remains
loaded.

Since the driver uses a shared workqueue (`qat_misc_wq`) across all
devices and owned by intel_qat.ko, a deferred routine from the
device-specific driver may still be pending in the queue. If this
routine executes after the driver is unloaded, it can dereference freed
memory, resulting in a page fault and kernel crash like the following:

    BUG: unable to handle page fault for address: ffa000002e50a01c
    #PF: supervisor read access in kernel mode
    RIP: 0010:pm_bh_handler+0x1d2/0x250 [intel_qat]
    Call Trace:
      pm_bh_handler+0x1d2/0x250 [intel_qat]
      process_one_work+0x171/0x340
      worker_thread+0x277/0x3a0
      kthread+0xf0/0x120
      ret_from_fork+0x2d/0x50

To prevent this, flush the misc workqueue during device shutdown to
ensure that all pending work items are completed before the driver is
unloaded.

Note: This approach may slightly increase shutdown latency if the
workqueue contains jobs from other devices, but it ensures correctness
and stability.

Fixes: e5745f34113b ("crypto: qat - enable power management for QAT GEN4")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_common_drv.h | 1 +
 drivers/crypto/intel/qat/qat_common/adf_init.c       | 1 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c        | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
index eaa6388a6678..7a022bd4ae07 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_common_drv.h
@@ -189,6 +189,7 @@ void adf_exit_misc_wq(void);
 bool adf_misc_wq_queue_work(struct work_struct *work);
 bool adf_misc_wq_queue_delayed_work(struct delayed_work *work,
 				    unsigned long delay);
+void adf_misc_wq_flush(void);
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index f189cce7d153..46491048e0bb 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -404,6 +404,7 @@ static void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 		hw_data->exit_admin_comms(accel_dev);
 
 	adf_cleanup_etr_data(accel_dev);
+	adf_misc_wq_flush();
 	adf_dev_restore(accel_dev);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_isr.c b/drivers/crypto/intel/qat/qat_common/adf_isr.c
index cae1aee5479a..12e565613661 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_isr.c
@@ -407,3 +407,8 @@ bool adf_misc_wq_queue_delayed_work(struct delayed_work *work,
 {
 	return queue_delayed_work(adf_misc_wq, work, delay);
 }
+
+void adf_misc_wq_flush(void)
+{
+	flush_workqueue(adf_misc_wq);
+}

base-commit: 9d21467fca15472efb701dad69abf685195845a4
-- 
2.50.0

