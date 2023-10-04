Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96FCEE7B5E5
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Oct 2023 10:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjJDKLM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Oct 2023 06:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbjJDKLL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Oct 2023 06:11:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B7C9E
        for <linux-crypto@vger.kernel.org>; Wed,  4 Oct 2023 03:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696414267; x=1727950267;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TnSWtFvkQ+kBkMbDAFytzzGauK9TbXx8TACpRKYYEJY=;
  b=VA61w5+KXohJEFcWw+pzNR2SCMvKOFybnfUxfwhG3G7ZDJGlj0LBu/NQ
   wrKtZXDTEpAQs8gCDv2diOCKVMB+o+UBmDs58UCeG/fzB+Zs91qb0Yr1I
   o75lME1KV7PH6vaRQOyPZZJFHQyw94MKLpQ4aUMGyIVGjnq9JfeCoXvtF
   K1sV/nrSpTseGzSP5vXJaq8MrvaXEPP+HH3lx0Qz2gzQ+OV4RVCDejoKh
   tH9vsr6q8FxGCCxfy8yq8Zb6DGJE1VLSSzPLfAEuZGcyfAqWkw/zlTrbj
   glZTtwssApHUaQ6x0m1FMcgemwPtatYmfQsz5pNwaEHKUDbD9dEjeP2Go
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="414036968"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="414036968"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 03:10:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10852"; a="894873086"
X-IronPort-AV: E=Sophos;i="6.03,199,1694761200"; 
   d="scan'208";a="894873086"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by fmsmga001.fm.intel.com with ESMTP; 04 Oct 2023 03:09:30 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: [PATCH v6 0/2] Add debugfs pm_status for qat driver
Date:   Wed,  4 Oct 2023 12:09:18 +0200
Message-ID: <20231004100920.33705-1-lucas.segarra.fernandez@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add debugfs pm_status.

Expose power management info by providing the "pm_status" file under
debugfs.

---
v5 -> v6:
- include kernel.h in adf_gen4_pm_debugfs.c
- fit to ~80 chars
- alphabetical order for intel_qat-$(CONFIG_DEBUG_FS) makefile target
---
v4 -> v5:
- use linux/kernel.h in C files
---
v3 -> v4:
- init variable `len` at adf_gen4_print_pm_status()
---
v2 -> v3:
- Move debugfs Power Management GEN4 specific logic to adf_gen4_pm_debugfs.c,
this fixes error building with CONFIG_DEBUG_FS=n
- increase doc's Date and KernelVersion
---
v1 -> v2:
- Add constant ICP_QAT_NUMBER_OF_PM_EVENTS, rather than ARRAY_SIZE_OF_FIELD()
---

Lucas Segarra Fernandez (2):
  crypto: qat - refactor included headers
  crypto: qat - add pm_status debugfs file

 Documentation/ABI/testing/debugfs-driver-qat  |   9 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  13 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  27 ++
 .../intel/qat/qat_common/adf_common_drv.h     |   1 +
 .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   3 +
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c |  26 +-
 .../crypto/intel/qat/qat_common/adf_gen4_pm.h |  50 +++-
 .../qat/qat_common/adf_gen4_pm_debugfs.c      | 265 ++++++++++++++++++
 .../intel/qat/qat_common/adf_pm_dbgfs.c       |  48 ++++
 .../intel/qat/qat_common/adf_pm_dbgfs.h       |  12 +
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  35 +++
 12 files changed, 485 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.h


base-commit: 7ae976c427d2d9a82164b32d19a54c07ac9bc6e2
-- 
2.41.0

