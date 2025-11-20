Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876282D062F
	for <linux-crypto@vger.kernel.org>; Thu, 20 Nov 2025 11:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763638160; cv=none; b=KjFR2hhZ5kxaLlYJA8VBPh/IZioxYBrJwcIQqAaCYbIP/RZ1QGRmtR5odj7q6M4zaFrlSa33vaePtibqsbnPcy+NBbKv6Zm6bbqoCi4BC8UXfcSMsXaBy1vyMHGlVfuAmhsX4z8q1G3Ohm/Yi0WH7jb3W/T5KYfLhyxBfNqz4IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763638160; c=relaxed/simple;
	bh=H8KdxWI8tT/1G+hSIa6MgaJtJAdzJDCN/IudFGQi9Jk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SghKX29xLt5inuwdwsE1JYdZ6DavDbH9tuiOAKF05gv5qoaVjvsaWK6p8vwo0nqkc65JFGyupdzsXSWIAKDlSxh4i6dycwMNA8SyxIrzKwZzV8KEFnXbwU+r1tRcY/zYx5X5l3GxiwPfu3P7Roa1AVfJMkLHhkILOwMcLH6FUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=grIhoUlC; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="grIhoUlC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763638159; x=1795174159;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=H8KdxWI8tT/1G+hSIa6MgaJtJAdzJDCN/IudFGQi9Jk=;
  b=grIhoUlCYeD/UlMo0dUA1aTBctOR/1EEGAOUXlIkvXS430j1J8is/Oca
   GBNSsiH3/IiWXRei17LYz2Jx2sH43k9k/BVxmSw6+wsYpAoPzmyfYKzur
   xRpJU7gLZTDNa+XH4BXXs+lMnOZhU/8xVNz5nihhpErMFO9sEcOMEDlPw
   /v7onTSUeRmfU4j6dLdTz5kABZv2gtc8hrz0VhsEJ9fBCrjbTgHiHjOMd
   Nt/5PyLT1v7+bqcdMWsaAi4TcdgAeDm+CjZE93uFyWpaFvpaoeeRLTP8C
   l3jkHL3e0d9pmYykuNmhTfxRwYkixlqpnrOR0D889mIB3/zMd4kbO8Q/j
   A==;
X-CSE-ConnectionGUID: pD16HOomQA6RHzE8VF3LnQ==
X-CSE-MsgGUID: otY1aKxVTauQKK0fqXLILA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65597051"
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="65597051"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 03:29:18 -0800
X-CSE-ConnectionGUID: UNlAabVkQmm/F+PxgQeXzQ==
X-CSE-MsgGUID: axbtRYf5QYKKvcF/dCwK6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,317,1758610800"; 
   d="scan'208";a="191465366"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by orviesa008.jf.intel.com with ESMTP; 20 Nov 2025 03:29:16 -0800
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: [PATCH] crypto: qat - add bank state save and restore for qat_420xx
Date: Thu, 20 Nov 2025 16:30:19 +0000
Message-ID: <20251120163023.29288-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Register the functions required to save and restore the state of a ring
bank on the qat_420xx device.  Since this logic is shared across QAT
GEN4 devices, reuse the existing GEN4 implementation.

This functionality enables saving and restoring the state of a Virtual
Function (VF), which is required for supporting VM Live Migration.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 53fa91d577ed..35105213d40c 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -3,6 +3,7 @@
 #include <linux/iopoll.h>
 #include <adf_accel_devices.h>
 #include <adf_admin.h>
+#include <adf_bank_state.h>
 #include <adf_cfg.h>
 #include <adf_cfg_services.h>
 #include <adf_clock.h>
@@ -459,6 +460,8 @@ void adf_init_hw_data_420xx(struct adf_hw_device_data *hw_data, u32 dev_id)
 	hw_data->get_ring_to_svc_map = adf_gen4_get_ring_to_svc_map;
 	hw_data->disable_iov = adf_disable_sriov;
 	hw_data->ring_pair_reset = adf_gen4_ring_pair_reset;
+	hw_data->bank_state_save = adf_bank_state_save;
+	hw_data->bank_state_restore = adf_bank_state_restore;
 	hw_data->enable_pm = adf_gen4_enable_pm;
 	hw_data->handle_pm_interrupt = adf_gen4_handle_pm_interrupt;
 	hw_data->dev_config = adf_gen4_dev_config;

base-commit: 8faa5c4b47998c5930314a3bb8ee53534cfdc1ce
-- 
2.51.1

