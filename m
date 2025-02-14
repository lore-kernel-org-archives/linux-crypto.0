Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A44B26738A
	for <linux-crypto@vger.kernel.org>; Fri, 14 Feb 2025 16:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739551813; cv=none; b=cDjaCN1fGgMXc9nmORyZYsYKI6wlFDOx+SJf1i3CgZ+e1hK3K8CtVKTp5C0i2aFMk02WIxgzQH54NXmI65Dtub91GG+gFWFg5AhFCHfSscKUTnuwfnozj5g0ih/Hq/VzjLN0r3sMv7K/KtWmtcax9ip5mojdWd/KxO7tFshjLIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739551813; c=relaxed/simple;
	bh=uzmj2NVRZvwnVY1/2lOXGvul024R8s80bciCUiAVN80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWlzHkOdKdrJ2GT0WciE1JoWrBqB+TIF63aTxTIQNevWCwiw7Ri5lWkNL1A0EmRbU6TIeBERA4ZMznjnJ0xWBdhE3RossRudcpG1fqx7mfMDGl1DA07gFI+RhVerXXAYA40HHJByNGHcSk9i27cUHzq4EqXQ3AjtrJFlsi3D8MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mXr94S4r; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mXr94S4r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739551813; x=1771087813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uzmj2NVRZvwnVY1/2lOXGvul024R8s80bciCUiAVN80=;
  b=mXr94S4r1HH63MjG90AF5AE5DqiLosX5uLmexEub83eyNB1bJ4WjtuEk
   Ar451wnoME6IXoY+LufMjVDudMgXD5Ngr/K0aO58VM76fHUfnciaWW8iQ
   2Pea1OJnvoP7e/AdiZxRtrYLyMiX6w+Y0nG67h9uhuS3c2Kk4gJ+DPFxX
   kNup00duxRlc4WzV6PGv31OEQWNMyHm46pL/y4KtR7z+NXw6ZitvR426N
   zzhEXbVSaDwJfTuRNP0GJFI5jYuUSyHNAtcacQwLDTQUw0j/MKVFoVOKZ
   xFIB5MNkOKz8vqUoM8BnwfBv2zDRlg/bWtwJMlkMwc5TFWR/t3sUo4zCf
   Q==;
X-CSE-ConnectionGUID: 5v7zbac/TjiJtd8GG+b0KA==
X-CSE-MsgGUID: mg1uGVNyQPaaBhW85mJLqQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11345"; a="43959787"
X-IronPort-AV: E=Sophos;i="6.13,286,1732608000"; 
   d="scan'208";a="43959787"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2025 08:50:10 -0800
X-CSE-ConnectionGUID: DfeGXyu+TI+fMPhoFPT6/g==
X-CSE-MsgGUID: 8wtl2V7GTPKRbnRqZ9ZTzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118126353"
Received: from unknown (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.156])
  by fmviesa005.fm.intel.com with ESMTP; 14 Feb 2025 08:49:22 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] crypto: qat - do not export adf_cfg_services
Date: Fri, 14 Feb 2025 16:40:42 +0000
Message-ID: <20250214164855.64851-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214164855.64851-2-giovanni.cabiddu@intel.com>
References: <20250214164855.64851-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

The symbol `adf_cfg_services` is only used on the intel_qat module.
There is no need to export it.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg_services.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index 268052294468..d30d686447e2 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -20,7 +20,6 @@ const char *const adf_cfg_services[] = {
 	[SVC_DC_SYM] = ADF_CFG_DC_SYM,
 	[SVC_SYM_DC] = ADF_CFG_SYM_DC,
 };
-EXPORT_SYMBOL_GPL(adf_cfg_services);
 
 int adf_get_service_enabled(struct adf_accel_dev *accel_dev)
 {
-- 
2.48.1

