Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3703AEE57F8
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Sep 2023 11:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbjIHLSA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Sep 2023 07:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbjIHLR6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2023 07:17:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD31BF6
        for <linux-crypto@vger.kernel.org>; Fri,  8 Sep 2023 04:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694171874; x=1725707874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5bIUcpbosUWLKc0n7GvOfvgYyl+2JL09JWwO2vynVhI=;
  b=R01nB9igepxXwmWrpE8JF5WmjZPo/CbQNAuJN6whwIcfxFAX9L/MowCZ
   vFrGkUO4RHFwRv9gVokIajKpEMuXhDmwCzlw2C3KH3jU89ylfUYVJvsZM
   7isw4K9N67SBaDe8K8dJfnAuPEy/zcQBOQ5OucKvVsvcwYpVg/57hS72b
   4knULDLtA8fS+mAY8PiYznKXIrUgMpqZ+AaI30kkQqJTR7LhGu/VwxLwd
   O7utdoZLM/W5wpblN7GUaAuQBHBnRwGFlRryR4g8ddwc702XcpLXAkA9k
   qR6ZHfnXc3Aht/3y7SA8s6VVWm3xlDaaJYox2+8Iq6lGSdkHfGw0BGtDO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="463998476"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="463998476"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2023 04:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10826"; a="777533212"
X-IronPort-AV: E=Sophos;i="6.02,236,1688454000"; 
   d="scan'208";a="777533212"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orsmga001.jf.intel.com with ESMTP; 08 Sep 2023 04:17:53 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: [PATCH v3 0/2] Add debugfs pm_status for qat driver
Date:   Fri,  8 Sep 2023 13:16:05 +0200
Message-ID: <20230908111625.64762-1-lucas.segarra.fernandez@intel.com>
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
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c |  27 +-
 .../crypto/intel/qat/qat_common/adf_gen4_pm.h |  50 +++-
 .../qat/qat_common/adf_gen4_pm_debugfs.c      | 255 ++++++++++++++++++
 .../intel/qat/qat_common/adf_pm_dbgfs.c       |  46 ++++
 .../intel/qat/qat_common/adf_pm_dbgfs.h       |  12 +
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  35 +++
 12 files changed, 473 insertions(+), 6 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_pm_dbgfs.h


base-commit: cf5974bfe9f69a06423f914f675ce3354ff8863c
-- 
2.41.0

