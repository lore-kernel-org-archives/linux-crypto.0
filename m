Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7ED48BD42;
	Wed, 13 May 2026 15:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685625; cv=none; b=CmzAsnW4qDJmmTAdAoh7boHjV9/NO5YWYovc2gIzCGsauWoOUVrMZm2vBVQxfPNnsF9+eSkJMHFDDGIlZg33JqhcVWd/5Uun8Fuz8dfIhdYD4HQDK/i02wTKpjHEldlLXrAwTcUxK4S11uGmZzz/PInUZQYfG0FgpC/Fumxt27w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685625; c=relaxed/simple;
	bh=Q6nex70dcnY0HfbinXTMpTi/fiqOknMGSQqY3TjcJ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INfVDenuHoFzI2nbRF6vxmyExeAp5GE7pzBO7nsxOiEO59LhT8xOY81bzz/FjnEjuFw996aeIbggAmJ1cVxlYHq9Op3lfcmttVUmMaJrt5Qm4K1FbKt2AZXwdZerefMKBgqZCzP3gZe+kFAz2Fu9OnqcWXEwav+z/Rib69w5fUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fiuoJB6u; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fiuoJB6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778685623; x=1810221623;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q6nex70dcnY0HfbinXTMpTi/fiqOknMGSQqY3TjcJ1k=;
  b=fiuoJB6uc63PKapCqWDvS5YQpvVVEJcG+BFmwfzs74+lmzt0aL6jHbKy
   n+3f0XAHPXJbBhp/2jShX0ObhhqELvlV7nKygAhvl184He3x+gZDdXugy
   OtKRmzkSwPwhmSq+UoMtBh9l3yE6bbFfRifeJwA5T61LnZ17uwlxQl42Z
   AGRoIYm7b+m3VdezKkHr7Rhx/VkoDWc25z+EgnYOK1wL7ZBB2LCMEX71p
   injK8h2KLdUjA9bbJDZ4uv2IL1+oGPvTIGo3jX7/H6W7xSxGK0ur7+vu2
   B6wrQPC4oSxX9b1BKlrFA5efxW294fm0TmLYiK/hrfiKBUA6/W9aB2guL
   A==;
X-CSE-ConnectionGUID: X3j3I1GcSaKA1b4CwpBRPg==
X-CSE-MsgGUID: bZhO+GddTBSv3c9XoHTuYA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83489521"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83489521"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:20:23 -0700
X-CSE-ConnectionGUID: wS6QLEr3TYGZEnj002J8yw==
X-CSE-MsgGUID: lCZ897FvTy2ICpafrrIe2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239931548"
Received: from zp3110c001s1504.deacluster.intel.com ([10.219.161.39])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 08:20:22 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 5/6] crypto: qat - factor out AER reset helpers
Date: Wed, 13 May 2026 17:16:58 +0200
Message-ID: <eb512c747dba60ce335e06da685ae82232d29ece.1778685152.git.ahsan.atta@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <cover.1778685152.git.ahsan.atta@intel.com>
References: <cover.1778685152.git.ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Move the shutdown and recovery sequences out of adf_error_detected()
and adf_slot_reset() into reset_prepare() and reset_done() helpers.

This makes the AER recovery path easier to follow and prepares the
common reset flow for reuse by additional PCI reset callbacks without
duplicating the logic.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 86 ++++++++++++-------
 1 file changed, 53 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 7255cac5aaa6..d29f70eb84b8 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -17,27 +17,18 @@ struct adf_fatal_error_data {
 static struct workqueue_struct *device_reset_wq;
 static struct workqueue_struct *device_sriov_wq;
 
-static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
-					   pci_channel_state_t state)
+static pci_ers_result_t reset_prepare(struct pci_dev *pdev)
 {
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
 
-	dev_info(&pdev->dev, "Acceleration driver hardware error detected.\n");
 	if (!accel_dev) {
 		dev_err(&pdev->dev, "Can't find acceleration device\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	if (state == pci_channel_io_perm_failure) {
-		dev_err(&pdev->dev, "Can't recover from device error\n");
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
-
 	if (!adf_dev_started(accel_dev))
 		return PCI_ERS_RESULT_CAN_RECOVER;
 
-	adf_error_notifier(accel_dev);
-	adf_pf2vf_notify_fatal_error(accel_dev);
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	if (accel_dev->hw_device->exit_arb) {
 		dev_dbg(&pdev->dev, "Disabling arbitration\n");
@@ -49,6 +40,57 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 	return PCI_ERS_RESULT_NEED_RESET;
 }
 
+static pci_ers_result_t reset_done(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+	int res;
+
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Can't find acceleration device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	if (!adf_devmgr_in_reset(accel_dev))
+		goto reset_complete;
+
+	pci_restore_state(pdev);
+	res = adf_dev_up(accel_dev, false);
+	if (res && res != -EALREADY)
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	adf_reenable_sriov(accel_dev);
+	adf_pf2vf_notify_restarted(accel_dev);
+	adf_dev_restarted_notify(accel_dev);
+	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+
+reset_complete:
+	dev_info(&pdev->dev, "Device reset completed successfully\n");
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
+					   pci_channel_state_t state)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	dev_info(&pdev->dev, "Acceleration driver hardware error detected.\n");
+	if (!accel_dev) {
+		dev_err(&pdev->dev, "Can't find acceleration device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	if (state == pci_channel_io_perm_failure) {
+		dev_err(&pdev->dev, "Can't recover from device error\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	adf_error_notifier(accel_dev);
+	adf_pf2vf_notify_fatal_error(accel_dev);
+
+	return reset_prepare(pdev);
+}
+
 /* reset dev data */
 struct adf_reset_dev_data {
 	int mode;
@@ -199,29 +241,7 @@ static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
 
 static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 {
-	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
-	int res = 0;
-
-	if (!accel_dev) {
-		pr_err("QAT: Can't find acceleration device\n");
-		return PCI_ERS_RESULT_DISCONNECT;
-	}
-
-	if (!adf_devmgr_in_reset(accel_dev))
-		goto reset_complete;
-
-	pci_restore_state(pdev);
-	res = adf_dev_up(accel_dev, false);
-	if (res && res != -EALREADY)
-		return PCI_ERS_RESULT_DISCONNECT;
-
-	adf_reenable_sriov(accel_dev);
-	adf_pf2vf_notify_restarted(accel_dev);
-	adf_dev_restarted_notify(accel_dev);
-	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
-
-reset_complete:
-	return PCI_ERS_RESULT_RECOVERED;
+	return reset_done(pdev);
 }
 
 static void adf_resume(struct pci_dev *pdev)
-- 
2.45.0

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

