Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E9210E0
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jan 2025 11:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738323306; cv=none; b=JLdixDH3Mmoz4cfpF++wgVDbS1U7/eVShnFE2EjvMilQZBBc7ht/8Xot0K93BLc+v8ZkrijFZPFmMX9BxG5ECPnIo3jNQrvej0TNgzGKjzwRskwT49UfCkhZaJkUvrObgy1bl6qDRcIJo2P3A7OOYHiPduIZxZXIoFHjtWzEFp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738323306; c=relaxed/simple;
	bh=9+C38kpUlKBffKn869BxJWa21kRIB/Ljy+iQrrB3cA8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lyixVTnG1LmblCUNm14Qy7sqg3HzbgI4UB6cK06iWUfDM2u4c5Wbb7oVeUWQM8Yys/BfRCtCdFaHMlLGrvzJwHoTnESdsJscAZzUGh79YPlWH+9c5wqsySwFkEdPTFZt2Rk7gMtVhiVfyMECXKwFtdND1W3DR0PM6UJ01SNdnE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=al1/jdfN; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="al1/jdfN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738323304; x=1769859304;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9+C38kpUlKBffKn869BxJWa21kRIB/Ljy+iQrrB3cA8=;
  b=al1/jdfNGqNReIRPeRmbPmQpi32H9WnzwDVtVkyTI3KGTH4xpVAjPRt7
   V2733CCCoQgrIszBfuiQqpO/9XF5Ht17FRg6GdIqUe5d59Soh28SbLI1s
   fLt53AASsKEK/MVMPYz8pyElwjyNAJoiMk/VavA5eNrROgb6NePjMsIaX
   r4l0Y6tZpR9k9MKJJDcy5Gs6yTm8s8NQlADSdObJhj4+dRSdVMXVsbCbD
   VuOupIHBnNj4dAdwzO+i+Cmbt96aD2sF9ZQX54FqQobxnaGprGAKpiUIc
   6/9nJSi1vo3AeLIFcNpVR98ujJjwSAePM0LfERNryfXmVV36Q21D2VY1h
   w==;
X-CSE-ConnectionGUID: BQ+6uPIoQs6M4rjGugmayg==
X-CSE-MsgGUID: 7hXo8uN9SEqWL/k4f2mJnw==
X-IronPort-AV: E=McAfee;i="6700,10204,11331"; a="39029257"
X-IronPort-AV: E=Sophos;i="6.13,248,1732608000"; 
   d="scan'208";a="39029257"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2025 03:35:04 -0800
X-CSE-ConnectionGUID: gq4JD6yLRaOi9DNul4drdw==
X-CSE-MsgGUID: Yazedq1gRqSUIWYsglO5vw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="146794797"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa001.jf.intel.com with ESMTP; 31 Jan 2025 03:35:01 -0800
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [RESEND] crypto: qat - set command ids as reserved
Date: Fri, 31 Jan 2025 11:34:54 +0000
Message-Id: <20250131113454.3269995-1-suman.kumar.chakraborty@intel.com>
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
Fixed headline of commit message

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

