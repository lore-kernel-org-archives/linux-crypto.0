Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B8B1798F
	for <linux-crypto@vger.kernel.org>; Wed,  3 Jan 2024 04:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FYiEjZkR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704254995; x=1735790995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l+0js2eiBMGuCsCzbcGTxvEZHnyTkXnZRvp4Y7XTpiw=;
  b=FYiEjZkRqzlJ/WXKIzyZ1VK7KEv58rn4u1TksYwq/qBjKODJdJ9DDRY6
   bQ1qQN5nrcnbGfFp5SXlczTMhiGbIlwV/GtPXLifxqtgFeksQZeULqHuW
   b93gmQmyDkIK+SqQGLXOGeLU7Ea04NVVy87JabeyV9daTaX6sSSyK78+J
   IAhWshD8HjZ5N5/HkY3jnzCUAgeCBX3joEvaS9i1gfNEGj45nfNQCTsGg
   YBWtQDpkghOVGnlXKae67soiVkNvt7KdxnfydLrCIWOjGAY28D2P7RpJf
   8I2/PJgEtfVd9QUgMWOsXE2eHUwgB9ARY7jO5gRh69KSiFKsTfZ4+tz2K
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="3725565"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="3725565"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10941"; a="1111241975"
X-IronPort-AV: E=Sophos;i="6.04,326,1695711600"; 
   d="scan'208";a="1111241975"
Received: from myep-mobl1.png.intel.com ([10.107.5.97])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2024 20:09:52 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>
Subject: [PATCH 9/9] crypto: qat - improve aer error reset handling
Date: Wed,  3 Jan 2024 12:07:22 +0800
Message-Id: <20240103040722.14467-10-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240103040722.14467-1-mun.chun.yep@intel.com>
References: <20240103040722.14467-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Disable worker threads and clear pci bus master in aer error handler.

This is to avoid new requests to be processed and allow dummy responses
generation for in-flight requests in user space before resetting a device.

Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index b3d4b6b99c65..df0ff0caf419 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -28,6 +28,14 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	if (accel_dev->hw_device->exit_arb) {
+		dev_info(&pdev->dev, "Disabling arbitration\n");
+		accel_dev->hw_device->exit_arb(accel_dev);
+	}
+	adf_error_notifier(accel_dev);
+	adf_pf2vf_notify_fatal_error(accel_dev);
+	pci_clear_master(pdev);
+
 	if (state == pci_channel_io_perm_failure) {
 		dev_err(&pdev->dev, "Can't recover from device error\n");
 		return PCI_ERS_RESULT_DISCONNECT;
@@ -111,9 +119,18 @@ static void adf_device_reset_worker(struct work_struct *work)
 		  container_of(work, struct adf_reset_dev_data, reset_work);
 	struct adf_accel_dev *accel_dev = reset_data->accel_dev;
 	unsigned long wait_jiffies = msecs_to_jiffies(10000);
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 	struct adf_sriov_dev_data sriov_data;
 
 	adf_dev_restarting_notify(accel_dev);
+
+	/*
+	 * re-enable device to support pf/vf comms as it would be disabled
+	 * in the detect function of aer driver
+	 */
+	if (!pdev->is_busmaster)
+		pci_set_master(pdev);
+
 	if (adf_dev_restart(accel_dev)) {
 		/* The device hanged and we can't restart it so stop here */
 		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
-- 
2.34.1

