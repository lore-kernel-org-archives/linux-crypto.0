Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B92447ECC0;
	Wed, 13 May 2026 15:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685617; cv=none; b=nSd9P6rFz5n0GTq4ztO8U5Zmu9SFGjOvs3sjdx7xpbsxxfRhN/F5pbjeJApPPpelRRq2N0Wfo6+DccHQ/QoMSF4iQwtA149cZRe8wiCWQ32VgeSjDv/agjQ+Tl+mfrt32LFzFgtb0RJdRgWeH3H6wobkL2ZqLR9bhs9s4YQg0Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685617; c=relaxed/simple;
	bh=yqinmu94UbdkYQgRj9MCDz5c6c1I8xVwaZDzBAhNnUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8CVWcP6LA/+4Hjf1V45ZGdmluL5NDG0gZEAw1lNGbWUKlToyRKB9LBucoyjMA3PjTtSsPCo3z32Lny0+FFvJRoGTh/NfuIPE7/fNYU+oXHXVLKhv4Kj1MW9NtLWc4raqyJpjeHojKLx/2nWGh/mWuJlwiDSmEsIFlxXdH3F4z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bBsgLG4g; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bBsgLG4g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778685616; x=1810221616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yqinmu94UbdkYQgRj9MCDz5c6c1I8xVwaZDzBAhNnUk=;
  b=bBsgLG4gMITOQ9/TzSmcDUThiLnXJnvtdI86gIBBLQJwtBkEasyJ2wRe
   UmiGP9x1WAgM2pmdhSMreI1wZQPP+O6f/NuM4v9SEOf8sFgf+dlYoEAA4
   priA3AGQX2hgSKmkirakVFtsEQ1KvukQ9kWDvVlz8veGwAps8xwY7Pim+
   JbbikO8HTtzYr524WhI3cvxuD9r4s9Ru+RZEQZw9gu56ZjyHS8u4m5lQU
   Rr7nFjrxk5TfNBFR2Vx1/qx0zT1VeFvXWvXV2GNwLi/FEfn7ZSpIBu6un
   Mnc0HwoD2zYXTCPeVOpzQGnOHzHGRE/DZrUNg2OhWbV3o7q6UP6X8ZDI0
   Q==;
X-CSE-ConnectionGUID: 7QMWm1ocTCeocHihfaavAg==
X-CSE-MsgGUID: e1p91SKaSHqRe14WCFAWZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83489474"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83489474"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:20:16 -0700
X-CSE-ConnectionGUID: XIIdr664QbOaeJUMBPikrg==
X-CSE-MsgGUID: a4K4HBDxTfWRTIMTXunxAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239931484"
Received: from zp3110c001s1504.deacluster.intel.com ([10.219.161.39])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 08:20:15 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 2/6] crypto: qat - notify fatal error before AER reset preparation
Date: Wed, 13 May 2026 17:16:55 +0200
Message-ID: <cea1e040db261ea1a9d6a33d0715d356ac508597.1778685152.git.ahsan.atta@intel.com>
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

Send fatal error notifications to subsystems and VFs as soon as
AER error detection starts, before entering the reset preparation
shutdown sequence.

This reduces notification latency and ensures peers are informed
immediately on fatal detection, rather than after restart-state setup
and arbitration teardown.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index ed01fb9ad74e..9c6bfb9fef80 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -33,13 +33,13 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	adf_error_notifier(accel_dev);
+	adf_pf2vf_notify_fatal_error(accel_dev);
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 	if (accel_dev->hw_device->exit_arb) {
 		dev_dbg(&pdev->dev, "Disabling arbitration\n");
 		accel_dev->hw_device->exit_arb(accel_dev);
 	}
-	adf_error_notifier(accel_dev);
-	adf_pf2vf_notify_fatal_error(accel_dev);
 	adf_dev_restarting_notify(accel_dev);
 	pci_clear_master(pdev);
 	adf_dev_down(accel_dev);
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

