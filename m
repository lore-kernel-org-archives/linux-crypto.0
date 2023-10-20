Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40524CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 10:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376794AbjJTKfF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 06:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376746AbjJTKfE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 06:35:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F69A114
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 03:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697798103; x=1729334103;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LHn20pPbCuQYuTNlV/yWEo2J5qdC7rdX6OC7/TlX9Ts=;
  b=dNCsegei2ri+nnslZQWr+GHTVT7fgtDDBVdTrHCnmeCU6uDcgpCPyDP8
   eOR09EncBCr3I8E6YwrGBGaXuBeBRKPPtcV0tirOLoOZYvXOtwkzlXiNT
   fPWzT1jZMZpSi+P4uOJiahrJ8VLG4rAXt1Hf9jnW19OgEatVJLmsO1mOx
   fNJzgjYT9mpvhzdwG/cwiVDqwlIUw1ds3oXTO1u/3A5YjBzSK0xnpEkP4
   6koMxRrP0FddaRp6sCZQcknzNJzmx9cgWzP9QQBELUpSepUf8qfh3n/sz
   2SP00Rh6RCi0Ww1OCXjMCUbym+NgcJeCJenlaNPBiaxV0upoMpwM50VOa
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="383686698"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="383686698"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 03:35:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10868"; a="792369915"
X-IronPort-AV: E=Sophos;i="6.03,238,1694761200"; 
   d="scan'208";a="792369915"
Received: from fl31ca105gs0706.deacluster.intel.com (HELO fl31ca105gs0706..) ([10.45.133.167])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2023 03:35:01 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH 0/9] add ras error detection and reporting for GEN4 devices
Date:   Fri, 20 Oct 2023 11:32:44 +0100
Message-ID: <20231020103431.230671-1-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set introduces the required infrastructure to detect, report, and count errors in the QAT drivers and enables the reporting of errors in QAT GEN4 devices.
In particular, it enables the reporting of correctable, nonfatal, and fatal errors.
In addition, exposes the number of occurrences of each type of error through sysfs.

The first patch adds the common infrastructures for error reporting for all generations of QAT.
Patches from 2 to 5 and 7 enable the reporting of errors flagged through the register ERRSOUx for GEN4 devices.
ERRSOUx error reporting for GEN4 devices.
Patch 6 adds a helper to retrieve the base address of the aram bar.
Patch 8 introduces the ras counter interface for counting QAT-specific errors, and exposes such counters through sysfs.
Patch 9 adds logic to count correctable, nonfatal, and fatal errors for GEN4 devices.

Shashank Gupta (9):
  crypto: qat - add infrastructure for error reporting
  crypto: qat - add reporting of correctable errors for QAT GEN4
  crypto: qat - add reporting of errors from ERRSOU1 for QAT GEN4
  crypto: qat - add handling of errors from ERRSOU2 for QAT GEN4
  crypto: qat - add handling of compression related errors for QAT GEN4
  crypto: qat - add adf_get_aram_base() helper function
  crypto: qat - add handling of errors from ERRSOU3 for QAT GEN4
  crypto: qat - add error counters
  crypto: qat - count QAT GEN4 errors

 .../ABI/testing/sysfs-driver-qat_ras          |   42 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     |   13 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.h     |   17 +
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |    1 +
 drivers/crypto/intel/qat/qat_common/Makefile  |    2 +
 .../intel/qat/qat_common/adf_accel_devices.h  |   34 +
 .../intel/qat/qat_common/adf_common_drv.h     |   10 +
 .../intel/qat/qat_common/adf_gen4_ras.c       | 1566 +++++++++++++++++
 .../intel/qat/qat_common/adf_gen4_ras.h       |  825 +++++++++
 .../crypto/intel/qat/qat_common/adf_init.c    |    9 +
 drivers/crypto/intel/qat/qat_common/adf_isr.c |   18 +
 .../qat/qat_common/adf_sysfs_ras_counters.c   |  112 ++
 .../qat/qat_common/adf_sysfs_ras_counters.h   |   28 +
 13 files changed, 2677 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat_ras
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_gen4_ras.h
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.h

-- 
2.41.0

