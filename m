Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874651F463C;
	Wed, 26 Mar 2025 16:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004908; cv=none; b=DBVlA4VbDtQfe5oLEAiogwnyENbvIm5HqTkLPqymmXBFhp3IW4z6R5B7PQts1TCbMXA2FbNaM5HH8RM8nLvNijpHR8wUiC5jQOPX9iIjR5LkcPJhklWLQU5K26N4bKidnhVR3N4xuOmhfrvDbx3wACm0k0bvIS3A2THscF/mExk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004908; c=relaxed/simple;
	bh=ae2T/3dzG5CLlJUyV0wbM2VVjM+75FqgogkpMameZMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYoz3oyjkjGhBuW7GYeyisNkCPjQjyuHFtFyTC/BTNzfPy1RbZqriLAIrkYVaCmTsjXvRQVekRO35yGF+1aiyS6N2upL7Q/eQsK5XrXTAIAGmCkhbOsKW0ejphH5UpL/Xi0O7aw4PwB+6WgJsI3a1Dhus4RFrvEHDd3Fsxbi4+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IKsYc/G9; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IKsYc/G9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004907; x=1774540907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ae2T/3dzG5CLlJUyV0wbM2VVjM+75FqgogkpMameZMM=;
  b=IKsYc/G9VKw8YBQFO9hTVokDLVYUuHeFx7T19bvs3vUKoPgKTtGEr1Kx
   ICMZo8h893PT6VLYAfHTdt5u/s01FaqGU6IKmd5TglyxabKoYtah/8m+X
   o0sDfX2gsoJEJjsgnXYRAxh29Hp/lkNTDGbAjmHGFwyF/Dnlph69KpUBS
   /kQVv3MNXW7JqrciQjgpjAWfhcRYgMz7Y18eu9WFaEfqYkRyPKRdSXYga
   CJJSWDs28rUHLJOr5rql7BLC+PepufS4qri7/r5e87TBB7d8BpVpzcXrO
   qCjC4SP5SMGX6T7M2b0eZ9df3VuUVrpt/XFdpZIH72D0HlB4PqnC3PrI/
   Q==;
X-CSE-ConnectionGUID: DtAVP+KhSFmrFE90nT+8fA==
X-CSE-MsgGUID: FnmF8J11T5mWh/hzqeY74Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823876"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823876"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:46 -0700
X-CSE-ConnectionGUID: BhVnVSUNSryP1/Yr8AM90g==
X-CSE-MsgGUID: n9hobIxQTTiRTsnaHwwQsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928567"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:44 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/8] crypto: qat - add shutdown handler to qat_420xx
Date: Wed, 26 Mar 2025 15:59:47 +0000
Message-ID: <20250326160116.102699-4-giovanni.cabiddu@intel.com>
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

    420xx 0000:01:00.0: Failed to power up the device
    420xx 0000:01:00.0: Failed to initialize device
    420xx 0000:01:00.0: Resetting device qat_dev0
    420xx 0000:01:00.0: probe with driver 420xx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index 8084aa0f7f41..b4731f02deb8 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -186,11 +186,19 @@ static void adf_remove(struct pci_dev *pdev)
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
 	.name = ADF_420XX_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };
-- 
2.48.1

