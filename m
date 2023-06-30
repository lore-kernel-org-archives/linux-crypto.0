Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABFF6EB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 17:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229476AbjF3RUU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 13:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjF3RUT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 13:20:19 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E2D3A87
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jun 2023 10:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688145618; x=1719681618;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XTZPnJjdnjXw8FHJZXlEOmJsQjEUds0KqC5D3/sYiKM=;
  b=fy2X9TKC2kfwNzCgsodD6ettLTM8Wea1CXUCuXWWPEdxblLrYyNb84ZV
   Z9h7P8D4dROYY/YDxJKP4dlwxIyw8BLki8nzOqvoctDZBe6jrWBrJNlxW
   G8+L1nAa2jUfQctVt3+UY3M7mwyVptqSCfElDduE/f3ZGQ4ILxd6wtvKy
   +YDLmnr7xNiRLXCoJlMEi3M8DWgwXmBqkN3y7f4x0XteyxjsEWNG8iZNh
   gej8cNF4yrWGNwkFpod3NPdtcoSYPZXRHco57u+xFgi0bV4AqSxWsfIBV
   TRUOEXYmZIRcP8PHhZBxygB7KiINbX2RaVBWuyV7izQlQXFLWes7Rp9BN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="359922819"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="359922819"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 10:20:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="721038628"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="721038628"
Received: from r031s002_zp31l10c01.gv.intel.com (HELO localhost.localdomain) ([10.219.171.29])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2023 10:20:17 -0700
From:   Damian Muszynski <damian.muszynski@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v4 0/5] crypto: qat - add heartbeat feature
Date:   Fri, 30 Jun 2023 19:03:53 +0200
Message-Id: <20230630170356.177654-1-damian.muszynski@intel.com>
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

The first patch adds timestamp synchronization to the firmware.
The second patch removes historical and never used HB definitions.
Patch no. 3 is implementing the hardware clock frequency measuring
interface.
The fourth introduces the main heartbeat implementation with the debugfs
interface.
The last patch implements an algorithm that allows the code to detect
which version of heartbeat API is used at the currently loaded firmware.

Changes since v3:
- improved comment in measure_clock() as suggested by Andy Shevchenko
- changed release date and version for 6.6 in interface documentation

Changes since v2:
- fixed build error on a few of architectures - reduced unnecessary
  64bit division.

Changes since v1:
- fixed build errors on a few of architectures - replaced macro
  DIV_ROUND_CLOSEST with DIV_ROUND_CLOSEST_ULL
- included prerequisite patch "add internal timer for qat 4xxx" which initially
  was sent separately as this patchset was still in development.
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
 .../crypto/intel/qat/qat_common/adf_clock.c   | 131 +++++++
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
 30 files changed, 1147 insertions(+), 16 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_clock.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_timer.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_heartbeat_dbgfs.h


base-commit: 67b9bc0df80cfa241fe7a9c2b857c3e3efde982a
-- 
2.40.1

