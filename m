Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD131FF60B
	for <linux-crypto@vger.kernel.org>; Fri, 14 Mar 2025 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741958088; cv=none; b=BSrhmSmheleeLranvWb9wPG3RqV2ZeyB+m1xtGYMEeDFp4FxU/yWAcTZlXhL2l8YOENylIue0clA1s0pqABWeTI2E019hwhPVh9fsT4/K2mZEbE6CujzvDXW40TJmvOw2hCGsOnntcweEBaqPfi78orfc3s40B2LTQ4hF5wV9Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741958088; c=relaxed/simple;
	bh=AiZJqKGmtsSxWeBu6WeQ8tIy1L8WELQ+SQHbEF1C7OM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QOwWQNW0+bNBk8ZL9ExIRXnXNcOri5YkNkdlvFChG2yY3hkBDn2YmfVFaTNlIKXQCAebtntyt4Yn30CsCWxkAw5W2eRkMaRzHre4aKttVv1IxOG0hmdkmAHZDcmw8hGSCCEtMcIWO+BkGtbp7wAk9uFf1JOXbDritiyeLKXLxfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kc2BS10X; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kc2BS10X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741958087; x=1773494087;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AiZJqKGmtsSxWeBu6WeQ8tIy1L8WELQ+SQHbEF1C7OM=;
  b=Kc2BS10XV0005dAEoB6lygOBtTl4NKo9sy66rcAiAeSPIeUcckNHhOrh
   8mT1XDnxzdoorauWAd0hbG8hN18b24v4xd4sJoGaFhP+eFRD+RNOakerT
   LSG9vKyzZomLDb0ZfnFr4JNPysWrbtCBKBh/6KgrZKMRAWXu5ygFhRqGp
   AZ0MMm3a7v605Ysw4DynunBTAfK2jD8vevE/A+uppLda/QelmZlMPr/2k
   hq/zzeZ6qG7UQI0iVL2M+TR9f+xinMotPGPk068/p4UyN3eRQynO6bZ8c
   Q5oKEhJ8c2Wzzhd41C//7VVfmIIYFIvEJUtOOF0JAYL/j9i6fcc/M53Cc
   A==;
X-CSE-ConnectionGUID: EsCTQbwPRsyuwh5/5QaGrw==
X-CSE-MsgGUID: bw/pQQgjRtyb5Xe3nGgFrQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11373"; a="68475407"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="68475407"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 06:14:46 -0700
X-CSE-ConnectionGUID: LJTI0c/OSz68DyrN5saN7Q==
X-CSE-MsgGUID: rf2glO6wQCmZeeVfVvSQBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="144462634"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa002.fm.intel.com with ESMTP; 14 Mar 2025 06:14:44 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Bairavi Alagappan <bairavix.alagappan@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - set parity error mask for qat_420xx
Date: Fri, 14 Mar 2025 13:14:29 +0000
Message-ID: <20250314131442.16391-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

From: Bairavi Alagappan <bairavix.alagappan@intel.com>

The field parerr_wat_wcp_mask in the structure adf_dev_err_mask enables
the detection and reporting of parity errors for the wireless cipher and
wireless authentication accelerators.

Set the parerr_wat_wcp_mask field, which was inadvertently omitted
during the initial enablement of the qat_420xx driver, to ensure that
parity errors are enabled for those accelerators.

In addition, fix the string used to report such errors that was
inadvertently set to "ath_cph" (authentication and cipher).

Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Bairavi Alagappan <bairavix.alagappan@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 1 +
 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 98f3c1210666..4feeef83f7a3 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -411,6 +411,7 @@ static void adf_gen4_set_err_mask(struct adf_dev_err_mask *dev_err_mask)
 	dev_err_mask->parerr_cpr_xlt_mask = ADF_420XX_PARITYERRORMASK_CPR_XLT_MASK;
 	dev_err_mask->parerr_dcpr_ucs_mask = ADF_420XX_PARITYERRORMASK_DCPR_UCS_MASK;
 	dev_err_mask->parerr_pke_mask = ADF_420XX_PARITYERRORMASK_PKE_MASK;
+	dev_err_mask->parerr_wat_wcp_mask = ADF_420XX_PARITYERRORMASK_WAT_WCP_MASK;
 	dev_err_mask->ssmfeatren_mask = ADF_420XX_SSMFEATREN_MASK;
 }
 
diff --git a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
index 2dd3772bf58a..bf0ea09faa65 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
@@ -695,7 +695,7 @@ static bool adf_handle_slice_hang_error(struct adf_accel_dev *accel_dev,
 	if (err_mask->parerr_wat_wcp_mask)
 		adf_poll_slicehang_csr(accel_dev, csr,
 				       ADF_GEN4_SLICEHANGSTATUS_WAT_WCP,
-				       "ath_cph");
+				       "wat_wcp");
 
 	return false;
 }

base-commit: 7aac1d007e7aaf234a787511601169dffa432c59
-- 
2.48.1

