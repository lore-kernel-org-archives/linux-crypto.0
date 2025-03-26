Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224DE18787A;
	Wed, 26 Mar 2025 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004906; cv=none; b=R4imIm9ldtP/7OGAyqsNHy/RsoqRf68Nd9hWZ0wcsruunhzx+HqxA0C+dV0bG+Gxr/8arFlsEtetUgubffCsRB/T4zYclBuTvfTbvXXH9nFcq3E3B4hKolFmL+12tnPM5kH+YBqVd7GnuKyOuvE2RvN26BlQ32GNGv3EjKMCrco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004906; c=relaxed/simple;
	bh=bdWjwa5u3HTrtNyZty3mgIxOEecazwdacNFDIQUoG5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBWlFsNZG+Z+gKP0TAKrjFSJ634YO7LCIjQd3ss3hXClWJ3cNcS6TieZ5zPz8cEEZrpMmWx0273cqC5Mepogn4TVu5Pv4yqvPV3g/K2h2fTAimSIonuf9IevJQd37GIghuR7riDTTQFcgwXwFicLRDez6Nb0HFcD33diYeNNphU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NNtziHu3; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NNtziHu3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004905; x=1774540905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bdWjwa5u3HTrtNyZty3mgIxOEecazwdacNFDIQUoG5s=;
  b=NNtziHu32yEdPFBLxfNPDyImvk/O+R/LvmlX4yV34OYUI7HsFYIM/pXc
   jlkNU+PuCVS5by25cEv8LM1YSG+u69m0zSj5VD1+rs1aDJe6AM0q9Tsgf
   OwOaU3p3MQhKXX25G3ZTt7QbbZR3k0K/vAwz1+vRAMf3JYNJ/C7AjxfYX
   j5SLEFUxHDKoFHYV5rqkpzySY+4JY4OkHcsvxUmwjXG93bseXEZYZxp8G
   IywPQbWijTPLjDkUBqGX32Yn+RHf8KYaxutURNExYlrlr0LfcugUW7A+y
   EJh8ds6RubmgJZZvhspttjZUPyKCOm4z5Osw/rcMg5TPAPGIvHT3g9F9S
   Q==;
X-CSE-ConnectionGUID: 7/A1/lYtQC6/4bdZ8OhehQ==
X-CSE-MsgGUID: GLW28MaETSG7uXGoX+uORA==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823868"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823868"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:44 -0700
X-CSE-ConnectionGUID: mzYASLVeRbm0/5jO0F4KLQ==
X-CSE-MsgGUID: hIBASr0pQeymAsf7lCSIiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928558"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:42 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Randy Wright <rwright@hpe.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/8] crypto: qat - add shutdown handler to qat_4xxx
Date: Wed, 26 Mar 2025 15:59:46 +0000
Message-ID: <20250326160116.102699-3-giovanni.cabiddu@intel.com>
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

    4xxx 0000:01:00.0: Failed to power up the device
    4xxx 0000:01:00.0: Failed to initialize device
    4xxx 0000:01:00.0: Resetting device qat_dev0
    4xxx 0000:01:00.0: probe with driver 4xxx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: 8c8268166e83 ("crypto: qat - add qat_4xxx driver")
Link: https://lore.kernel.org/all/Z-DGQrhRj9niR9iZ@gondor.apana.org.au/
Reported-by: Randy Wright <rwright@hpe.com>
Closes: https://issues.redhat.com/browse/RHEL-84366
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 5537a9991e4e..1ac415ef3c31 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -188,11 +188,19 @@ static void adf_remove(struct pci_dev *pdev)
 	adf_cleanup_accel(accel_dev);
 }
 
+static void adf_shutdown(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	adf_dev_down(accel_dev);
+}
+
 static struct pci_driver adf_driver = {
 	.id_table = adf_pci_tbl,
 	.name = ADF_4XXX_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };
-- 
2.48.1

