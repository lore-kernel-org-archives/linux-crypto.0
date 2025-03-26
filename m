Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B641F4E49;
	Wed, 26 Mar 2025 16:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004915; cv=none; b=r6WFIZGaEblfnMtY3l84W+QrlkqOJKdEiuF7/gSBvYIg0s4a5gupGm2KQQGJg/3KDQY0Thb3KO3/VYDgpjfldaxUoUmqweu8T1n3PkADKfZeKRkX5D9CEq2Fwumbwb/ikLELKPcOFtGGDpg7ZYcMt2Wm9KnOLwi15USQwofYJ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004915; c=relaxed/simple;
	bh=Mj/VTbe66eASpSeZ3Hz/jkyeHZMhBS+kttR++8h91Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9gGM6NvcNk67Yv6EfjR78yJ4EJ3uvJW5udSklkjVc3GjFlpor1I9n14udIOcXXTPC3dWC+MZ3npUih7jpIA1/CTNneIR1giQJZy+7kqccOtn+On77fnQJ9zpJeTy+qcrseVg8QuYsx6top9rpjs9awplLM6xSzV4HofZaEvGAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXqm6kFa; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXqm6kFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004914; x=1774540914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mj/VTbe66eASpSeZ3Hz/jkyeHZMhBS+kttR++8h91Lo=;
  b=HXqm6kFab8GoNbEK5XgYgnbS5ZktV5kE7NdCnWPzX2JIuaJSglTWqCPX
   CfbghuWtt6WK5ZTYvVfpH8Wt4+T7kDBCE3K7JpC64TKEuZiJf11QzI6Xk
   bUPO14izgGpg0mhyAilzg6xh30nAGNOIVZIpmsUFgI6kc+mdWuzUwMJsG
   2KJxKEt+ifyxEHMK/a96Y1TosfKDLA+WVxskviE0mOIIxR9RRmQqofXEs
   LePjHMzfSP12uyIklJgTmww7Kilmr9wPh9g2mvLbYP0S8nzcogmiLTi9q
   fHtUn9ate0SicO5WyVt111AEAdLxpXV+68ths0lIQyvB8q4urML3qLueO
   w==;
X-CSE-ConnectionGUID: Zx0fzYMPTKeYPsAGMqmThA==
X-CSE-MsgGUID: YqNDcqN8QJ2Mde0J+aHoWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823906"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823906"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:53 -0700
X-CSE-ConnectionGUID: 81M9C0C8TuqBMEk2MJvAQA==
X-CSE-MsgGUID: bdaozIS7Q2GE7NoqU+M/fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928591"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:51 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6/8] crypto: qat - add shutdown handler to qat_c62x
Date: Wed, 26 Mar 2025 15:59:51 +0000
Message-ID: <20250326160116.102699-8-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
References: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

During a warm reset via kexec, the system bypasses the driver removal
sequence, meaning that the remove() callback is not invoked.
If a QAT device is not shutdown properly, the device driver will fail to
load in a newly rebooted kernel.

This might result in output like the following after the kexec reboot:

    QAT: AE0 is inactive!!
    QAT: failed to get device out of reset
    c6xx 0000:3f:00.0: qat_hal_clr_reset error
    c6xx 0000:3f:00.0: Failed to init the AEs
    c6xx 0000:3f:00.0: Failed to initialise Acceleration Engine
    c6xx 0000:3f:00.0: Resetting device qat_dev0
    c6xx 0000:3f:00.0: probe with driver c6xx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: a6dabee6c8ba ("crypto: qat - add support for c62x accel type")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index 0bac717e88d9..23ccb72b6ea2 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -209,6 +209,13 @@ static void adf_remove(struct pci_dev *pdev)
 	kfree(accel_dev);
 }
 
+static void adf_shutdown(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	adf_dev_down(accel_dev);
+}
+
 static const struct pci_device_id adf_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X) },
 	{ }
@@ -220,6 +227,7 @@ static struct pci_driver adf_driver = {
 	.name = ADF_C62X_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };
-- 
2.48.1

