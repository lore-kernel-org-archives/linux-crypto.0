Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E32F7A73B
	for <linux-crypto@vger.kernel.org>; Fri,  2 Feb 2024 10:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706871325; cv=none; b=qgxJ7T2zVr/v7FOAHUnDCHBeAT7VekNvhlOerIzYTa0ATBXVNXvL84e64UFKRFQ12oeKaTM/1wMg2rywJda9dCOzT26QtRdBmrdODkJgonzLStQVZhykcUeCKh8yMlMZzhbfdPYoacDtfM09VmZyRy4quNKwwLuOXSTQrRSROB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706871325; c=relaxed/simple;
	bh=iK5Dg+kPYmmsKf18NNwrJk+3HijZcLRbaN0Q5bzl8yE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FKA17EqMlXlolKZ09Q6qwaxvNGT2bJ+JWYJ+xn/LBlu0MYxVtHGTsRYaymEDYsfYxOszVxFNCfVegNCVxowC+bk7xmiw2at+tFN7JLjygEco9UpqSSu0N6yMlXERqAXAq2l+K7vAKRxyrF8yMZ7F+pGVNGQPUhveSeT8Z3AF7Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hULeksqM; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hULeksqM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706871324; x=1738407324;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iK5Dg+kPYmmsKf18NNwrJk+3HijZcLRbaN0Q5bzl8yE=;
  b=hULeksqMGaNkEhPJpEeBVHsQd6Q2bcLkDi7qdxOHenIAajES6xfN6hRx
   X6DQY8hxMX93twv5sk0eBZJF0NNLwRI4g4rwCVWYK/x2UWUhHmwGr6OJN
   1VPlh3Q8OE5EeJJWig5kx9Ajw7eldVLsJ6mlViSgy8a50SagH/99/45+8
   I9IZa3CPXAyxOsp+PD1rBNccrWVW8Z+kdnkiprz9IAEzG5ZiguZuC0NZ0
   Siyrv8uoYtMjt+FGEc6hscSwFNmxdMv/TaqqiDYadkzsvRndkRgsyDENw
   dIbiNyJlnSbWCKag/9lkxyhMHZabARKHdr6sGzZo+WxnigIZBwMaWkdLL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="10787396"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="10787396"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="53658"
Received: from myep-mobl1.png.intel.com ([10.107.10.166])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2024 02:55:22 -0800
From: Mun Chun Yep <mun.chun.yep@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Mun Chun Yep <mun.chun.yep@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>,
	Markas Rapoportas <markas.rapoportas@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 9/9] crypto: qat - improve aer error reset handling
Date: Fri,  2 Feb 2024 18:53:24 +0800
Message-Id: <20240202105324.50391-10-mun.chun.yep@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240202105324.50391-1-mun.chun.yep@intel.com>
References: <20240202105324.50391-1-mun.chun.yep@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rework the AER reset and recovery flow to take into account root port
integrated devices that gets reset between the error detected and the
slot reset callbacks.

In adf_error_detected() the devices is gracefully shut down. The worker
threads are disabled, the error conditions are notified to listeners and
through PFVF comms and finally the device is reset as part of
adf_dev_down().

In adf_slot_reset(), the device is brought up again. If SRIOV VFs were
enabled before reset, these are re-enabled and VFs are notified of
restarting through PFVF comms.

Signed-off-by: Mun Chun Yep <mun.chun.yep@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Markas Rapoportas <markas.rapoportas@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index b3d4b6b99c65..3597e7605a14 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -33,6 +33,19 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+	if (accel_dev->hw_device->exit_arb) {
+		dev_dbg(&pdev->dev, "Disabling arbitration\n");
+		accel_dev->hw_device->exit_arb(accel_dev);
+	}
+	adf_error_notifier(accel_dev);
+	adf_pf2vf_notify_fatal_error(accel_dev);
+	adf_dev_restarting_notify(accel_dev);
+	adf_pf2vf_notify_restarting(accel_dev);
+	adf_pf2vf_wait_for_restarting_complete(accel_dev);
+	pci_clear_master(pdev);
+	adf_dev_down(accel_dev, false);
+
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
@@ -180,14 +193,25 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 {
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+	int res = 0;
 
 	if (!accel_dev) {
 		pr_err("QAT: Can't find acceleration device\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
-	if (adf_dev_aer_schedule_reset(accel_dev, ADF_DEV_RESET_SYNC))
+
+	if (!pdev->is_busmaster)
+		pci_set_master(pdev);
+	pci_restore_state(pdev);
+	pci_save_state(pdev);
+	res = adf_dev_up(accel_dev, false);
+	if (res && res != -EALREADY)
 		return PCI_ERS_RESULT_DISCONNECT;
 
+	adf_reenable_sriov(accel_dev);
+	adf_pf2vf_notify_restarted(accel_dev);
+	adf_dev_restarted_notify(accel_dev);
+	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
-- 
2.34.1

