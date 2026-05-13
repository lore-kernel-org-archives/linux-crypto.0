Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3D13321B1;
	Wed, 13 May 2026 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685627; cv=none; b=qSKPWavUraJdAdKmbkAcrncxAB9yYnEHGa70WeSQPjE+rfzSRUDf4hcuntdJGNUXKrJMN0L7hdbJwtC9/izMzc0Oa1cFKw5XHePN2Fp5mXnGabsCuw+TIqPiJDEk7Fh4hgvVJjXpwRT/K0XhgY1+SZIr+ltbeIuKJRHU7R2C5yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685627; c=relaxed/simple;
	bh=wn/mjkuuLW+DWToBm1KYcumvzh96coldrZOHO3ezGmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W5mBSW/8TcQ74uG5lAMCg5i++m1AzxphDmi3xyWXsrbpElJp57IAzFCrId9GzKWHHDDo5KbRZbnb3eliAZIYzoGSFN+6sJGf5S9049YdXiOYjyTSQTtDUg5uNsjB4pLua6Lpc7Akmqj6FjJwEvCHP+Cggujj+HXUZ6O52fpC00A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fap7XRwG; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fap7XRwG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778685625; x=1810221625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wn/mjkuuLW+DWToBm1KYcumvzh96coldrZOHO3ezGmE=;
  b=Fap7XRwG5ljjdhLTcxGMFP+mCzap2MHJKZqeYlwO1/F++XAuO1Lwn3/5
   euLJZ+C3GMZtyxwGDhCl/n6Kr/YkTT3JIFwSpn+dkSuk+eu0AhAyXqoj3
   BwSfqAWKbDG3jRNFgXEnrSpcPeP3otQSdY9OoPiVF5lVP6L97ozKHVF92
   KmQKEBSRyd2N0dH1zLi0/EsXn2bIBc2bIUXZY6jn6RCyRZoaUH8/olFXE
   IJzlEDKwBu+tG39+PfPIPqUBfBqrdG6Rx54VizwIhmRTENPyjDf4yr+V6
   BMcbAJGqDMJcmdTxdB3xABfGBTQav7G0WXY7VPdOzQv+ynpy8SqJF4wVq
   g==;
X-CSE-ConnectionGUID: UfUs7f6CQvK1g+mkwNJ5MQ==
X-CSE-MsgGUID: URMamPSfTLaW10piGVFTDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83489532"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83489532"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:20:25 -0700
X-CSE-ConnectionGUID: /Sv31jP7SjaGJAof2d1bWQ==
X-CSE-MsgGUID: id/gk2/TS7SDUs/D/9GxeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239931574"
Received: from zp3110c001s1504.deacluster.intel.com ([10.219.161.39])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 08:20:24 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 6/6] crypto: qat - handle sysfs-triggered reset callbacks
Date: Wed, 13 May 2026 17:16:59 +0200
Message-ID: <b1229b6e45cb61aecd5df50cb99b4b8b16fb3126.1778685152.git.ahsan.atta@intel.com>
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

A reset requested through /sys/bus/pci/devices/.../reset invokes the
driver reset_prepare() and reset_done() callbacks. The QAT driver does
not implement those callbacks today, so the reset proceeds without
quiescing the device or bringing it back up afterward, which leaves
the device unusable.

Hook reset_prepare() and reset_done() into adf_err_handler so the
common shutdown and recovery flow also runs for reset. Skip device
quiesce if the device is already in a down state.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index d29f70eb84b8..af028488e660 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -250,10 +250,22 @@ static void adf_resume(struct pci_dev *pdev)
 	dev_info(&pdev->dev, "Device is up and running\n");
 }
 
+static void adf_reset_prepare(struct pci_dev *pdev)
+{
+	reset_prepare(pdev);
+}
+
+static void adf_reset_done(struct pci_dev *pdev)
+{
+	reset_done(pdev);
+}
+
 const struct pci_error_handlers adf_err_handler = {
 	.error_detected = adf_error_detected,
 	.slot_reset = adf_slot_reset,
 	.resume = adf_resume,
+	.reset_prepare = adf_reset_prepare,
+	.reset_done = adf_reset_done,
 };
 EXPORT_SYMBOL_GPL(adf_err_handler);
 
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

