Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2C74266B2
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 12:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785502121; cv=none; b=DSJW6yzapAM/JV+XELrXDz1HJloikGPVh7prEo/TYqnTGEDe+LUOt37Qd3KS3J862v6kUPATWLmNXqS7d5cKR4lzV0ala38HBruGJoYZPuFB95RFEMPZy36uoqIMIu8RAXO3EVHag2AAQCK8WpRsX4vK33gxY0mbtHfGjV4RuKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785502121; c=relaxed/simple;
	bh=DdKD9xgabybRHqTF6OrBSbDCyXHVERQ3qI/UtZYkdPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bb2C4RYg7LKN83nw+p1kqK7gdfXxPIE6teZR3SM3IDWHhfZY6omTGn4z+gZ0MnWUwFXbYjkGKJofimvRPf8yTupb9HPFw3wEoG50B39WaC3tW7N1v3xcFFAvevqonuqETmSEvvranGaAQHtItdwrHIhTtOSS9+bryfKlwE+Y+yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=er3+iztu; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="er3+iztu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785502119; x=1817038119;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DdKD9xgabybRHqTF6OrBSbDCyXHVERQ3qI/UtZYkdPk=;
  b=er3+iztuonnJDkOxAoFL4PZcKMsxNv6oQP787DIidIbRc8Yvgj0vUOcX
   5MYaEs3BSmOVVd8NEUVKlkROgkJgjTvS11+borP9jONc66kq6bG08p3x+
   A9707lc3dXBuwBqP6/pZXULYJVBeFdiwEq6PmagbifnmOCJuJ3rzmSCvF
   fXCdTHfppNx8m+0r8xDPN11+9lFwyE2CTysIPZAlXj5ReRLNzQ1wMsV6W
   dQYecXOkzmSZrsG2mAhYoxptT15vhcxbLmXxe6n4Za+WPkU8EMUScfDb6
   3eeQVNjMWKq+Ly2rzcDNVS7G5lAsSaPM5Lhd7ITWpf4F91Iq8PRlorlHl
   A==;
X-CSE-ConnectionGUID: zNit0h7vR7iEWZfJ4k9F7A==
X-CSE-MsgGUID: KR2kER3VRkanOlUfkhnRoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11860"; a="86205739"
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="86205739"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2026 05:48:38 -0700
X-CSE-ConnectionGUID: y3TbV2DMS4+hyhaD41OjUQ==
X-CSE-MsgGUID: G1JKg4ptSCWrn7makU5xOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,196,1779174000"; 
   d="scan'208";a="264382532"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa004.jf.intel.com with ESMTP; 31 Jul 2026 05:48:37 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: linux-drivers-review@eclists.intel.com,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Subject: [PATCH] crypto: qat - remove dead ADF_HEX code
Date: Fri, 31 Jul 2026 13:48:32 +0100
Message-ID: <20260731124832.159453-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The ADF_HEX value type is defined in the adf_cfg_val_type enum and
handled in adf_cfg_add_key_value_param(), but no caller in the tree
uses it.

Remove the unused ADF_HEX enum value and its dead handling code.

Fixes: d8cba25d2c68 ("crypto: qat - Intel(R) QAT driver framework")
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Svyatoslav Pankratov <svyatoslav.pankratov@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_cfg.c        | 3 ---
 drivers/crypto/intel/qat/qat_common/adf_cfg_common.h | 1 -
 2 files changed, 4 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index d97ee1000045..b88febf53a19 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -292,9 +292,6 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 			 "%ld", (*((long *)val)));
 	} else if (type == ADF_STR) {
 		strscpy(key_val->val, (char *)val);
-	} else if (type == ADF_HEX) {
-		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
-			 "0x%lx", (unsigned long)val);
 	} else {
 		dev_err(&GET_DEV(accel_dev), "Unknown type given.\n");
 		kfree(key_val);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
index d63f4dcccbb5..5922d018f5b9 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_common.h
@@ -28,7 +28,6 @@ enum adf_cfg_service_type {
 
 enum adf_cfg_val_type {
 	ADF_DEC,
-	ADF_HEX,
 	ADF_STR
 };
 
-- 
2.50.1

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

