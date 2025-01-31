Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC575139E
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jan 2025 03:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738295084; cv=none; b=tw9RfZmVYAq2V0wQxOSBStKik5/6kGoM3iiUHmJuRf50yTCcAZW93+Y2uUPglILx/1nrZCzKGAVcuXSjgumuNqANigMLTQlIK55CpPiSgE7/RPymfY+hU21ABw1Y87ctJTTi5WsuIo+irkUZ0d5WvnBYmCUinJZ2inzD9rnddao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738295084; c=relaxed/simple;
	bh=S7oN8BmI04GSydhRvjFuw3knWDRzzoss8MYPGuQk/vA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HYde6J50PESRlyocGBE6ZIx8nzOyjWr1ywuRVEiA2TDJSuvukXWR+yL7ml2esAYKV3KplyKEj2s5YHCy+3UjHJGliInX8k2SOXy/ezmxq8XtsPUn/a16Incmzg9ybOYWG5FVcyvbe+vUm7asj9eSb4MrJEXUiTYZw5VxvNJ9Z9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZTX94kBA; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZTX94kBA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738295083; x=1769831083;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S7oN8BmI04GSydhRvjFuw3knWDRzzoss8MYPGuQk/vA=;
  b=ZTX94kBAWIDiNs5VDa7OfUUqN9LHWhO9Oo4whg1CVTDxCOND6GdHib5Y
   CnAmG8h+b6gOeTUfZm9FDyFG2NqVnoJ5NlKel6q9qcoOYic2YGyoc3ZKa
   Y659xlh8FBhPMzPjBjMAo8bH8eYVvJcCKF8wmwlLnMQE6blI2RN4Wm9YG
   zRM8btazrzHMw+JpLS/n1I7661XXJ9/t6K7p4v5PRKFuptGWx+VBCyCep
   zBhANynhGHKhxlvG8Hfd2uKzRvzk/+h1uTjFh2qcQSPWwYwdqQTlXnNfO
   +02jzBCqVrOX8Bdc6DTm6gGbbGadL7go6wsin+dT5r+WSm7FAyo7TUSX1
   w==;
X-CSE-ConnectionGUID: J7YgZ6A3Qv+2Nz3DHPME+w==
X-CSE-MsgGUID: imwIJBCLQHyDtumEpH42OA==
X-IronPort-AV: E=McAfee;i="6700,10204,11331"; a="42517108"
X-IronPort-AV: E=Sophos;i="6.13,247,1732608000"; 
   d="scan'208";a="42517108"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2025 19:44:42 -0800
X-CSE-ConnectionGUID: Mt7pDPIUQcO/YIw6L/rSaQ==
X-CSE-MsgGUID: uuG7iGhqT8mnb8o7f6WVrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="140405957"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by fmviesa001.fm.intel.com with ESMTP; 30 Jan 2025 19:44:41 -0800
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH] crypto:qat - set command ids as reserved
Date: Fri, 31 Jan 2025 03:44:08 +0000
Message-Id: <20250131034408.3249624-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The XP10 algorithm is not supported by any QAT device.
Remove the definition of bit 7 (ICP_QAT_FW_COMP_20_CMD_XP10_COMPRESS)
and bit 8 (ICP_QAT_FW_COMP_20_CMD_XP10_DECOMPRESS) in the firmware
command id enum and rename them as reserved.
Those bits shall not be used in future.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
index a03d43fef2b3..04f645957e28 100644
--- a/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
+++ b/drivers/crypto/intel/qat/qat_common/icp_qat_fw_comp.h
@@ -16,8 +16,8 @@ enum icp_qat_fw_comp_20_cmd_id {
 	ICP_QAT_FW_COMP_20_CMD_LZ4_DECOMPRESS = 4,
 	ICP_QAT_FW_COMP_20_CMD_LZ4S_COMPRESS = 5,
 	ICP_QAT_FW_COMP_20_CMD_LZ4S_DECOMPRESS = 6,
-	ICP_QAT_FW_COMP_20_CMD_XP10_COMPRESS = 7,
-	ICP_QAT_FW_COMP_20_CMD_XP10_DECOMPRESS = 8,
+	ICP_QAT_FW_COMP_20_CMD_RESERVED_7 = 7,
+	ICP_QAT_FW_COMP_20_CMD_RESERVED_8 = 8,
 	ICP_QAT_FW_COMP_20_CMD_RESERVED_9 = 9,
 	ICP_QAT_FW_COMP_23_CMD_ZSTD_COMPRESS = 10,
 	ICP_QAT_FW_COMP_23_CMD_ZSTD_DECOMPRESS = 11,

base-commit: 5351b54115393d1f741a83ed4c6657fb238f65c2
-- 
2.40.1

