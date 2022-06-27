Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1C0C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 08:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiF0IhD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 04:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiF0IhC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 04:37:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9FE62D7
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 01:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656319021; x=1687855021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=71QXNitUJf8VGQSG8HobloIOpiD0NWxSgI8d4UZNpjI=;
  b=nm/5UBuzFEZtUsZ0zqEDz95qT+Uar/BwCOxoGjXdR7p3EggeCaZ465ZN
   PLJA3PcY49xAU75wqRC3hbU2BWgMEEpHWnqv0OQrrpb1tJHtL2Z5JDzq1
   JRn5dWijt8uWG5rvpseN0l9wgBtDifnyshws4JUjEA2Y00hM5o9PHxLHc
   OobPDxceT1TvN0r9Kfmpjs4egxNhX89kImc6DTKxnDd/d5Yu9VhJ7EhEY
   0h/i13Dn8BFnsU9PHqpwDiyfF/ncHIoKniC27Pna0fk3zKlm7wsNiEpZg
   pi8JK3KbZF1mH6vGKyFuXJXYliw89YkJKGP7jusjsk4II35M2nEcWi4c2
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10390"; a="282488913"
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="282488913"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 01:37:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="657595503"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga004.fm.intel.com with ESMTP; 27 Jun 2022 01:36:58 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 0/4] crypto: qat - enable configuration for 4xxx
Date:   Mon, 27 Jun 2022 09:36:48 +0100
Message-Id: <20220627083652.880303-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

qat_4xxx devices can be configured to allow either crypto or compression
operations. By default, devices are configured statically according
to following rule:
- odd numbered devices assigned to compression services
- even numbered devices assigned to crypto services

This set exposes two attributes in sysfs that allow to report and change
the state and the configuration of a QAT 4xxx device.
The first, /sys/bus/pci/devices/<BDF>/qat/state, allows to bring a
device down in order to change the configuration, and bring it up again.
The second, /sys/bus/pci/devices/<BDF>/qat/cfg_services, allows to
inspect the current configuration of a device (i.e. crypto or
compression) and change it.

    # cat /sys/bus/pci/devices/<BDF>/qat/state
    up
    # cat /sys/bus/pci/devices/<BDF>/qat/cfg_services
    sym;asym
    # echo down > /sys/bus/pci/devices/<BDF>/qat/state
    # echo dc > /sys/bus/pci/devices/<BDF>/qat/cfg_services
    # echo up > /sys/bus/pci/devices/<BDF>/qat/state
    # cat /sys/bus/pci/devices/<BDF>/qat/state
    dc

Changes from v1:
 - Updated target kernel version in documentation (from 5.19 to 5.20).
 - Fixed commit message in patch #1 and updated documentation in patch
   #4 after review from Vladis Dronov.

Giovanni Cabiddu (4):
  crypto: qat - expose device state through sysfs for 4xxx
  crypto: qat - change behaviour of adf_cfg_add_key_value_param()
  crypto: qat - relocate and rename adf_sriov_prepare_restart()
  crypto: qat - expose device config through sysfs for 4xxx

 Documentation/ABI/testing/sysfs-driver-qat    |  61 ++++++
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   1 +
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   1 +
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |   6 +-
 drivers/crypto/qat/qat_common/Makefile        |   1 +
 .../crypto/qat/qat_common/adf_accel_devices.h |   1 +
 drivers/crypto/qat/qat_common/adf_cfg.c       |  41 +++-
 .../crypto/qat/qat_common/adf_common_drv.h    |   3 +
 drivers/crypto/qat/qat_common/adf_init.c      |  26 +++
 drivers/crypto/qat/qat_common/adf_sriov.c     |  28 +--
 drivers/crypto/qat/qat_common/adf_sysfs.c     | 191 ++++++++++++++++++
 11 files changed, 331 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-qat
 create mode 100644 drivers/crypto/qat/qat_common/adf_sysfs.c

-- 
2.36.1

