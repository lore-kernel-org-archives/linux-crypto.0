Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44C1CD6E63
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Oct 2023 12:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjJKMgE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 08:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjJKMgD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 08:36:03 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FAAC91
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 05:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697027761; x=1728563761;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m17LJAMyehFHIPf3/6Mgus+HYyeus7wd+kt7HUS2AXs=;
  b=aQAgSvCePr2pVRp0fktj4ftIK7efmMK0FhMCTQOpyLlGXN54mdDiCSX/
   dIU5jgRDKOEnjsl+Tk+nizT3dcZxxhTvNUFo/G8EbQy8fUdogY55ycLts
   4r1UsW5WmWE8Kyq10gGyVbx6yImJdxS8OQrmY/dp8DVm5PfwzQolJNl2o
   cfnMRc/t4Mgg2PsUCNCzaRLTHDzZDskjb9xguFnGUria77Rmivmdb755e
   KoSLmJhbTZygyJIBSG06dRZQY791alyagb79FKidTYYbqrGP3ZE0Tqaws
   fqTLqQUQ5vCdBgGuDdlnASrQZddntDLnS1H7YuTJ/yvq0eDOBgQv13p0D
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="374992807"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="374992807"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2023 05:36:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10860"; a="870124619"
X-IronPort-AV: E=Sophos;i="6.03,216,1694761200"; 
   d="scan'208";a="870124619"
Received: from r031s002_zp31l10c01.deacluster.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga002.fm.intel.com with ESMTP; 11 Oct 2023 05:35:59 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH 00/11] crypto: qat - add rate limiting feature to qat_4xxx
Date:   Wed, 11 Oct 2023 14:14:58 +0200
Message-ID: <20231011121934.45255-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set introduces the rate limiting feature to the Intel QAT accelerator.
The Rate Limiting allows control of the rate of the requests that can be
submitted on a ring pair (RP). This allows sharing a QAT device among
multiple users while ensuring a guaranteed throughput.

The first six commits address minor reworks and additions necessary
for the feature's implementation.
The subsequent patch introduces a mechanism for retrieving firmware
feature capabilities.
Patch nr 8 implements the core of the rate limiting.
The final three commits add the required sysfs interface
for configuring this newly introduced feature.

Ciunas Bennett (3):
  crypto: qat - add rate limiting sysfs interface
  crypto: qat - add rp2svc sysfs attribute
  crypto: qat - add num_rps sysfs attribute

Damian Muszynski (4):
  units: Add BYTES_PER_*BIT
  crypto: qat - add bits.h to icp_qat_hw.h
  crypto: qat - add retrieval of fw capabilities
  crypto: qat - add rate limiting feature to qat_4xxx

Giovanni Cabiddu (4):
  crypto: qat - refactor fw config related functions
  crypto: qat - use masks for AE groups
  crypto: qat - fix ring to service map for QAT GEN4
  crypto: qat - move admin api

 Documentation/ABI/testing/sysfs-driver-qat    |   46 +
 Documentation/ABI/testing/sysfs-driver-qat_rl |  227 ++++
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  190 ++-
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   13 +-
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |    1 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |    1 +
 drivers/crypto/intel/qat/qat_common/Makefile  |    3 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   11 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |   73 +
 .../crypto/intel/qat/qat_common/adf_admin.h   |   27 +
 .../crypto/intel/qat/qat_common/adf_clock.c   |    1 +
 .../intel/qat/qat_common/adf_cnv_dbgfs.c      |    1 +
 .../intel/qat/qat_common/adf_common_drv.h     |   10 -
 .../intel/qat/qat_common/adf_fw_counters.c    |    1 +
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |    7 +
 .../crypto/intel/qat/qat_common/adf_gen4_pm.c |    1 +
 .../qat/qat_common/adf_gen4_pm_debugfs.c      |    1 +
 .../intel/qat/qat_common/adf_gen4_timer.c     |    1 +
 .../intel/qat/qat_common/adf_heartbeat.c      |    1 +
 .../qat/qat_common/adf_heartbeat_dbgfs.c      |    1 +
 .../crypto/intel/qat/qat_common/adf_init.c    |   12 +
 drivers/crypto/intel/qat/qat_common/adf_rl.c  | 1186 +++++++++++++++++
 drivers/crypto/intel/qat/qat_common/adf_rl.h  |  176 +++
 .../intel/qat/qat_common/adf_rl_admin.c       |   98 ++
 .../intel/qat/qat_common/adf_rl_admin.h       |   18 +
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |   80 ++
 .../intel/qat/qat_common/adf_sysfs_rl.c       |  451 +++++++
 .../intel/qat/qat_common/adf_sysfs_rl.h       |   11 +
 .../qat/qat_common/icp_qat_fw_init_admin.h    |   41 +
 .../crypto/intel/qat/qat_common/icp_qat_hw.h  |    2 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |    1 +
 include/linux/units.h                         |    4 +
 32 files changed, 2624 insertions(+), 73 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_rl
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_admin.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl_admin.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_rl_admin.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_rl.h

-- 
2.41.0

