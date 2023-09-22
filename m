Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5986CD4F49
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Sep 2023 10:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjIVKR2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Sep 2023 06:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjIVKR1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2023 06:17:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F9AA9
        for <linux-crypto@vger.kernel.org>; Fri, 22 Sep 2023 03:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695377842; x=1726913842;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aabOafxh+Pvf7hLFIk9FqnUmoMtKuKZwBUhCi+27FXk=;
  b=kF1dIlQNOGbNAHczW37/C/XDId1OVqKsXOwCb2zI30wBTgNZe1jgo+vJ
   Xb+vUUTio5JaoLejGS08DBRkVpTBL8vVl1CddriqWlCxkh/ECGquJjHfI
   vWc7/kJXHwjlcgOfcTf80Ajunm7VHIzYg5JDCaF0pWNZFs9m6zFagdfH4
   P12O7AgLfF+nw3v6W16qa/e15Z2c1RdK0wO6wyx2nSe4tV8YKygFNT6Rq
   S0MurDtpFoggQVwmNRHkHpHUfIl7bHNhvxq+GrN5ywPKwt1Yk/eiUktqE
   RwFNs1BAS10Vds49EG5uh/LB9ioYx/E3vWt8SCwY8yrgplofZPUIDmIMm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="371115835"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="371115835"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 03:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="871199296"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="871199296"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orsmga004.jf.intel.com with ESMTP; 22 Sep 2023 03:17:21 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: [PATCH v5 0/2] Add debugfs pm_status for qat driver
Date:   Fri, 22 Sep 2023 12:15:25 +0200
Message-ID: <20230922101541.19408-1-lucas.segarra.fernandez@intel.com>
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
 .../crypto/intel/qat/qat_common/adf_admin.c   |  26 ++
 .../intel/qat/qat_common/adf_common_drv.h     |   1 +
 .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   3 +
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c |  26 +-
 .../crypto/intel/qat/qat_common/adf_gen4_pm.h |  50 +++-
 .../qat/qat_common/adf_gen4_pm_debugfs.c      | 255 ++++++++++++++++++
 .../intel/qat/qat_common/adf_pm_dbgfs.c       |  46 ++++
 .../intel/qat/qat_common/adf_pm_dbgfs.h       |  12 +
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  35 +++
 12 files changed, 472 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.h


base-commit: 6216da1fca75fb3077e51707792be78cb008900f
-- 
2.41.0

