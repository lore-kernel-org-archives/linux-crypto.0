Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74346221297
	for <linux-crypto@vger.kernel.org>; Wed,  4 Jun 2025 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749025430; cv=none; b=BOWmOSvozZTcZC/GleLV9bYNgVpn64bCCUxMO1TdNHcudoXvFcwjSAlcR6UQkMCqkIJCkIL2/gFYhZJYX2sTj1CbArxKhSOsdUnXFiD4Iq/Kte2lpvYaDusax4yNmtkv96d4XjrllY0aOQc93xWYFL56bq5uoRX2qSSVIKFsjEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749025430; c=relaxed/simple;
	bh=fsh5kwk5M9nOIoO2MCh2Rgy6KH+yiVXmFG61Zbp3aBQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iy/8LzGFHEZracy0Y7TMjuhXuGJbBUoRt1JL4s3gTYi1TWerOBshdg55N/7Ms7zPT2gWqHUTRG+nLixRbVyh5L69QCJ8sNrm4DBWtq4458/gEFd/r9VMeZxh9e3t5/Qw5/tXs7GFBWGIHEyJx36bzSwG45FwE+E5iA4z/hPphSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=none smtp.mailfrom=ecsmtp.ir.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a0K0c1tH; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ecsmtp.ir.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a0K0c1tH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749025428; x=1780561428;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fsh5kwk5M9nOIoO2MCh2Rgy6KH+yiVXmFG61Zbp3aBQ=;
  b=a0K0c1tHZ2mIOqhENLa+5iFmURXKwkdsaUKZb1KtM0H19B0KwNFgrJGu
   oye9TsopmFxvaURAjFzx85sm5fnEh7abSM1n4vFrfICpHKDX4KrUYYCYV
   TM601pRwW46gzcXsqNpFE3sm3hh0ONuGP8FEIe2NEk5lXm3CM906PqS68
   hm9pm1LxeF10/j774i4EY9mZ1QXvNZMVzqQFa4kr84R3/Hbju/3lvIP09
   YRTiSHprc1C6NMP+XA11iUkIvq6xRainWx2OFSRIgVFCR48Tx58C27vdj
   4RKhemJJdHBSVM1MD3w+L23f4TmeFvqj0ja1OFwJ9hwL0x7BG7qs39zT9
   A==;
X-CSE-ConnectionGUID: B2HIItwiR5+9v0uSrX2ocg==
X-CSE-MsgGUID: l0g0gWskQiurwgTAr0czXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50336247"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="50336247"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 01:23:48 -0700
X-CSE-ConnectionGUID: 7lKC3IzGSKCYUGUuaokfEQ==
X-CSE-MsgGUID: 9yNZw09XTeSlZTr4oOMfvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="168287429"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmviesa002.fm.intel.com with ESMTP; 04 Jun 2025 01:23:46 -0700
Received: from sivswdev10.ir.intel.com (sivswdev10.ir.intel.com [10.237.217.4])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 6D95532EB3;
	Wed,  4 Jun 2025 09:23:45 +0100 (IST)
Received: by sivswdev10.ir.intel.com (Postfix, from userid 11379147)
	id 3CADD18001CF; Wed,  4 Jun 2025 09:23:45 +0100 (IST)
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - allow enabling VFs in the absence of IOMMU
Date: Wed,  4 Jun 2025 09:23:43 +0100
Message-Id: <20250604082343.26819-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
introduced an unnecessary change that prevented enabling SR-IOV when
IOMMU is disabled. In certain scenarios, it is desirable to enable
SR-IOV even in the absence of IOMMU. Thus, restoring the previous
functionality to allow VFs to be enumerated in the absence of IOMMU.

Fixes: ca88a2bdd4dd ("crypto: qat - allow disabling SR-IOV VFs")
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_sriov.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index c75d0b6cb0ad..31d1ef0cb1f5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -155,7 +155,6 @@ static int adf_do_enable_sriov(struct adf_accel_dev *accel_dev)
 	if (!device_iommu_mapped(&GET_DEV(accel_dev))) {
 		dev_warn(&GET_DEV(accel_dev),
 			 "IOMMU should be enabled for SR-IOV to work correctly\n");
-		return -EINVAL;
 	}
 
 	if (adf_dev_started(accel_dev)) {
-- 
2.49.0

