Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7438EB64D8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 13:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjFTNXl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 09:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232949AbjFTNX0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 09:23:26 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA1295
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 06:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687267366; x=1718803366;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DBsshj8zPD0RwuetRjgBSSybmP0r0tlHF5tXEimYHm4=;
  b=RtQtm0UtKhFTBO7acLFl/avddaP4N+g/2GPnCiHoCmnXcUgAZtXvOfGS
   kysa19m1JILdPOE2JkXH6NZ4H2CY6vBTiwmUGLquchC4/uiXTc5/Y+u81
   25GL6sA2u3sdq0Y6rr1eMkE8qP+WPBWhHm0gZzQVCcCv2igOgl9E0hvsN
   uqAzzlsJr546BXwZlsaO0TOFZWSiSOasSDojnbQQk/aDuc97FMoYRcYx1
   pilwu5ynCB1z5nfZ2celDbouzaq5OaygG9himVpuRcmZTWFZGqHpKbC8s
   BpHSRcId2kGfa7woMq3YgJR4J87QYQoPyWLLmSxIa+QJIv7L86sXFfGVm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="446229721"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="446229721"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 06:22:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10747"; a="743785377"
X-IronPort-AV: E=Sophos;i="6.00,257,1681196400"; 
   d="scan'208";a="743785377"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by orsmga008.jf.intel.com with ESMTP; 20 Jun 2023 06:22:08 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/5] crypto: qat - add heartbeat feature
Date:   Tue, 20 Jun 2023 15:08:18 +0200
Message-Id: <20230620130823.27004-1-damian.muszynski@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set introduces support for the QAT heartbeat feature. It allows
detection whenever device firmware or acceleration unit will hang.
We're adding this feature to allow our clients having a tool with
they could verify if all of the Quick Assist hardware resources are
healthy and operational.

QAT device firmware periodically writes counters to a specified physical
memory location. A pair of counters per thread is incremented at
the start and end of the main processing loop within the firmware.
Checking for Heartbeat consists of checking the validity of the pair
of counter values for each thread. Stagnant counters indicate
a firmware hang.

The first patch adds timestamp synchronization with the firmware.
The second patch removes historical and never used HB definitions.
Patch no. 3 is implementing the hardware clock frequency measuring
interface.
The fourth introduces the main heartbeat implementation with the debugfs
interface.
The last patch implements an algorithm that allows the code to detect
which version of heartbeat API is used at the currently loaded firmware.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Changes since v1:
- fixed build errors on a few of architectures - replaced macro
  DIV_ROUND_CLOSEST with DIV_ROUND_CLOSEST_ULL
- included prerequisite patch "add internal timer for qat 4xxx" which initially
  was sent separately as this patchset was still in developement.
  - timer patch reworked to use delayed work as suggested by Herbert Xu

Damian Muszynski (5):
  crypto: qat - add internal timer for qat 4xxx
  crypto: qat - drop obsolete heartbeat interface
  crypto: qat - add measure clock frequency
  crypto: qat - add heartbeat feature
  crypto: qat - add heartbeat counters check

 Documentation/ABI/testing/debugfs-driver-qat  |  51 +++
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |  14 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   4 +
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |   3 +
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  28 ++
 .../intel/qat/qat_c3xxx/adf_c3xxx_hw_data.h   |   7 +
 .../intel/qat/qat_c62x/adf_c62x_hw_data.c     |  28 ++
 .../intel/qat/qat_c62x/adf_c62x_hw_data.h     |   7 +
 drivers/crypto/intel/qat/qat_common/Makefile  |   4 +
 .../intel/qat/qat_common/adf_accel_devices.h  |  13 +
 .../crypto/intel/qat/qat_common/adf_admin.c   |  43 +++
 .../intel/qat/qat_common/adf_cfg_strings.h    |   2 +
 .../crypto/intel/qat/qat_common/adf_clock.c   | 127 +++++++
 .../crypto/intel/qat/qat_common/adf_clock.h   |  14 +
 .../intel/qat/qat_common/adf_common_drv.h     |   5 +
 .../crypto/intel/qat/qat_common/adf_dbgfs.c   |   9 +-
 .../intel/qat/qat_common/adf_gen2_config.c    |   7 +
 .../intel/qat/qat_common/adf_gen2_hw_data.h   |   3 +
 .../intel/qat/qat_common/adf_gen4_hw_data.h   |   3 +
 .../intel/qat/qat_common/adf_gen4_timer.c     |  70 ++++
 .../intel/qat/qat_common/adf_gen4_timer.h     |  21 ++
 .../intel/qat/qat_common/adf_heartbeat.c      | 336 ++++++++++++++++++
 .../intel/qat/qat_common/adf_heartbeat.h      |  79 ++++
 .../qat/qat_common/adf_heartbeat_dbgfs.c      | 194 ++++++++++
 .../qat/qat_common/adf_heartbeat_dbgfs.h      |  12 +
 .../crypto/intel/qat/qat_common/adf_init.c    |  28 ++
 drivers/crypto/intel/qat/qat_common/adf_isr.c |   6 +
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  23 +-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  13 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |   5 +
 30 files changed, 1143 insertions(+), 16 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.h

-- 
2.40.1

