Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298882147E6
	for <linux-crypto@vger.kernel.org>; Tue, 17 Jun 2025 10:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750157562; cv=none; b=E+QbxLY/x0rFrHsNea0KV7cSmBfkHygm5R8ibxgKSbMPtEvmZV8atSOH6R+/p0mLGtLIv1yQWrxuGmlIhPQ4TrtGyIflQlAqFXUl8MN/vnKVnvzf48ewBIGFMKid1hDPevVSJxYRtfR2OVMRMk1HNVG20AnDQItESSPtnMaFWls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750157562; c=relaxed/simple;
	bh=KQwSUaQybMD6lY9YaZ1O8Z2vfX3lxr6RXAESXQXfSgo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kScoZwYPz7SGmI2aKgp23c+w2jroeCAX/MPhCsHFCevYJcX1Y+3mRB4KVQRoY1SkHwiwtwfTO/lwki8rzQFOhss6zm0/YQGpqa0alalbw9aSHzBDRV89vcFVbi7YlbxVjYCvoyZVSsK2lDsHdyoPRhEgBvO5NUiI0Hx0Ek7k2sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PaZuVLKS; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PaZuVLKS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750157561; x=1781693561;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KQwSUaQybMD6lY9YaZ1O8Z2vfX3lxr6RXAESXQXfSgo=;
  b=PaZuVLKS3CFEmvz0v5bkXgItNNfd1wl/Uf61ZXS1CnQbxBJ/Dk2PTtY7
   s9qHegLqU8aH6wnuzgGsL/MrlCYEi7isSMfc/Ibs/y3dC32fITuy0/iyS
   CxAscDO3SzremgHWqIkvgLa11yZgJDcDaDLWBP2Z7yVsHBI1OkI6pknbC
   tfTeaT4w5LZ84tkpyPAzSy5klFIEf64a7/ciQnFs36lUgLYq+oVShMabp
   t20XH3CJHmjmVrKrIzIWTpMWJRoL1R1fLFZa4HT01D2mWJeR/2pibC+Nf
   kfuwp0MDn4+CSi9Y040glSHqD8+5F/tEqNPoQNaQRLHfd8UQl270Elzec
   Q==;
X-CSE-ConnectionGUID: D3oIjXwfRBu2gTLiABNRmw==
X-CSE-MsgGUID: bKsMx/T/QU+4Cp+jPvvbFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="63683684"
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="63683684"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 03:52:40 -0700
X-CSE-ConnectionGUID: FfOi5jufT8CEDaDudXOlNQ==
X-CSE-MsgGUID: 807skD6xRX+T6Bx4Hzb8DA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="148656962"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa007.fm.intel.com with ESMTP; 17 Jun 2025 03:52:39 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] crypto: qat - remove duplicate masking for GEN6 devices
Date: Tue, 17 Jun 2025 11:52:32 +0100
Message-Id: <20250617105232.979689-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ICP_ACCEL_CAPABILITIES_CIPHER capability is masked out redundantly
for QAT GEN6 devices.

Remove it to avoid code duplication.

This does not introduce any functional change.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
index 48a29a102dd0..cc8554c65d0b 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_6xxx_hw_data.c
@@ -629,7 +629,6 @@ static u32 get_accel_cap(struct adf_accel_dev *accel_dev)
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_CHACHA_POLY;
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_AESGCM_SPC;
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_AES_V2;
-		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_CIPHER;
 	}
 	if (fusectl1 & ICP_ACCEL_GEN6_MASK_AUTH_SLICE) {
 		capabilities_sym &= ~ICP_ACCEL_CAPABILITIES_AUTHENTICATION;

base-commit: 1a81ee21c0d32b37b76e754a0a6350b3e5833cd8
-- 
2.40.1

