Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0681F463C;
	Wed, 26 Mar 2025 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004920; cv=none; b=F1nt6gKP4hAx59x7B0yqoUz5NY7ZXXAx11qfcrfCX8lqisg2+1akWNki1f/QKaY8/ohMmFOVVKb8GA3c3TWxIesnC37eLrlG6yjGHQ+gl64Yx/a0qVts0UGCHAd9GzmjtiRQhL0WAy0tUwJfOW6nC3gmrPh2+4Ha0RThdNNRbJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004920; c=relaxed/simple;
	bh=QurFjRZCv2GrztKeXNUsyNxUzz0eOgFMneJ6h2Ttw1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2FxmLBULqmIX/E6WxWUZXysflkNGDOF9TSxUMC7YFl65KswjN9UKz/Beql2GrEr/jHCFUDvDVXz/dqkl/WlYKams8vBLWkCwzdPuIVpx5dCBBIgcbOjx7UILGqiQVZ/1Ed5I1uWqqmQ3EHr4HJqLAGLnBmsemE4ilIfZ9a5bbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QWCerAUb; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QWCerAUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004919; x=1774540919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QurFjRZCv2GrztKeXNUsyNxUzz0eOgFMneJ6h2Ttw1o=;
  b=QWCerAUbsjotbzyTVfsZmhdY6eaGfQLMhY5/Pw2OzMztJnnyyXopMxJT
   lg/rG4JdwaqJ26tmfx/iJ+Yagbpd/In4d/zgLzZ1NCnpiNib6r5oo5a4N
   pt8RCyBOQxrhVUm0XeFGOR/0p6oXTmMZs66xGo7ZYLa8DGyUB65K7Xfbx
   f5U2+BU4fUtTKG8IfkFll9suVju9paOTxR1soL/1rwY4h8V2rwTfX9cj7
   4DJLs8LuobbRSbpzBNk0Kg34etgwRoZk66hZm+lk/I+50A/Rz9abqMnIw
   rvZOm6WXp3Y2EB20xcr7CMl9VfvmR9FGSVn7yhaAW2dgxvQ/E9JNNnQUk
   g==;
X-CSE-ConnectionGUID: geElCuyVT4WoVTNVJt98TQ==
X-CSE-MsgGUID: OQ5vPv4hRZaoGP28Bo6VNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823924"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823924"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:57 -0700
X-CSE-ConnectionGUID: rGJy8HmQTvOp1VQL7mvKSQ==
X-CSE-MsgGUID: klKu7p60RfaC4KywTfrC7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928600"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:55 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	stable@vger.kernel.org,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 8/8] crypto: qat - add shutdown handler to qat_c3xxx
Date: Wed, 26 Mar 2025 15:59:53 +0000
Message-ID: <20250326160116.102699-10-giovanni.cabiddu@intel.com>
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
    c3xxx 0000:3f:00.0: qat_hal_clr_reset error
    c3xxx 0000:3f:00.0: Failed to init the AEs
    c3xxx 0000:3f:00.0: Failed to initialise Acceleration Engine
    c3xxx 0000:3f:00.0: Resetting device qat_dev0
    c3xxx 0000:3f:00.0: probe with driver c3xxx failed with error -14

Implement the shutdown() handler that hooks into the reboot notifier
list. This brings down the QAT device and ensures it is shut down
properly.

Cc: <stable@vger.kernel.org>
Fixes: 890c55f4dc0e ("crypto: qat - add support for c3xxx accel type")
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index 260f34d0d541..bceb5dd8b148 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
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
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX) },
 	{ }
@@ -220,6 +227,7 @@ static struct pci_driver adf_driver = {
 	.name = ADF_C3XXX_DEVICE_NAME,
 	.probe = adf_probe,
 	.remove = adf_remove,
+	.shutdown = adf_shutdown,
 	.sriov_configure = adf_sriov_configure,
 	.err_handler = &adf_err_handler,
 };
-- 
2.48.1

