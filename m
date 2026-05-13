Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D60D38CFE1;
	Wed, 13 May 2026 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685623; cv=none; b=GGcypSSHSQZdjdKWQGt8jzIuWweN8GYxunOWGIG4da/PpK5dhfdhv6ZN40RIE7h4veJUKBZTSJY/h2vY0gHmHZrGFgXvzIdHHK8dAi7zuYxha+RjgeAsTyZHS5Pl0OQzfcVcD9wiKH4Q2jpkgvGWZfmusvynQNa0+ItNI6+gNFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685623; c=relaxed/simple;
	bh=PbE46K+namgwJyfK7XMKjYSCSw78ZOSt1a7fS66Gk0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=immzW2COdDYG6d/g+ARgppaXpXxrG2/lrNtPRn7YZQjyU9oLRycR6Aujc2MafBiGJ6SrzSGs4I5np8DoZP4rdVlSTCbItn7Yq2HseqKNrts1B43Dyosx0Nn19c/P6VydAoS1ze3gQTSfPz0MA9ukuFXTAqvIS9vD7uDhRBnyV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LnLhiY0j; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LnLhiY0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778685622; x=1810221622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PbE46K+namgwJyfK7XMKjYSCSw78ZOSt1a7fS66Gk0A=;
  b=LnLhiY0jOxCErbiC1eny5z+ldgpa22UGZsRRKOEkeWRZUXkqBHhFBHoB
   4AAdv4rO0DAd4X/WRefoXbr2cczNcoQub4tTqE/nYlM55AtZfp8j1dGLr
   U42WcW9F3352RIs15dFKAX0syuFw0aHEHa9eBXJx2dadrQw9NckUn2g68
   5q+wTNKEUfLA/j0dZS+KR7t8BIxxVBRO0RFFTVQLUsgGtGrBf2rFtPusv
   aHJ1C22lvpTB5vZxAhm0QYwem221+m2obzv/McB5zUrkbX2OH5gSQJ6KV
   8Wuq89edsvpmBwS7SrKVb5UdQ5cFxbNtONTBC/bCAb99FCDDYBSG5pcKQ
   w==;
X-CSE-ConnectionGUID: bELfnpfoQImMDQGsOunRfw==
X-CSE-MsgGUID: 4s3GqZX4Q6qJ8pd6OWmXiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="83489508"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="83489508"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 08:20:21 -0700
X-CSE-ConnectionGUID: cHfDEfrtSwCX1GDTyTe8lA==
X-CSE-MsgGUID: 3PSAwaUqQlumOf1nvj+QGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="239931532"
Received: from zp3110c001s1504.deacluster.intel.com ([10.219.161.39])
  by fmviesa004.fm.intel.com with ESMTP; 13 May 2026 08:20:20 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	stable@vger.kernel.org,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 4/6] crypto: qat - skip restart for down devices
Date: Wed, 13 May 2026 17:16:57 +0200
Message-ID: <c8d79fda8835a20f6a507aa416b22182d8d0303d.1778685152.git.ahsan.atta@intel.com>
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

Skip the shutdown and restart flow when adf_slot_reset() is entered
for a device that is already down. In that case, leave
ADF_STATUS_RESTARTING clear and let adf_slot_reset() restore PCI
function state without calling adf_dev_up(), re-enabling SR-IOV, or
sending restarted notifications.

This is in preparation for adding reset_prepare() and reset_done()
callbacks in adf_aer.c.

Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 365637e40439..7255cac5aaa6 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -33,6 +33,9 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	if (!adf_dev_started(accel_dev))
+		return PCI_ERS_RESULT_CAN_RECOVER;
+
 	adf_error_notifier(accel_dev);
 	adf_pf2vf_notify_fatal_error(accel_dev);
 	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
@@ -204,6 +207,9 @@ static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
+	if (!adf_devmgr_in_reset(accel_dev))
+		goto reset_complete;
+
 	pci_restore_state(pdev);
 	res = adf_dev_up(accel_dev, false);
 	if (res && res != -EALREADY)
@@ -213,6 +219,8 @@ static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 	adf_pf2vf_notify_restarted(accel_dev);
 	adf_dev_restarted_notify(accel_dev);
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+
+reset_complete:
 	return PCI_ERS_RESULT_RECOVERED;
 }
 
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

