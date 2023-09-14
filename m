Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66305EEAA50
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 15:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbjINPE0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 11:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjINPEZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 11:04:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74884A8
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 08:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694703861; x=1726239861;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d3b+C/s+RnudP39Pmx4QBFz10hc7w8wC3jmwFuFaDvE=;
  b=VIaO/4zlE1ODUa6XK1Eh8Ss5bG+5hDIdfT05tw8MvYXYLaeTHPGb4KA1
   CYT66dXcZmTahU7RARnBcwtkYkJInqlTBrzYksOo8hj8HEY5wsW8Q0vf1
   iBXxFFuf4D85RZbeNJqf+bA5wcNnt3yL/7L1fYpki4V0ihOqYq/xKuCwh
   EffEHTGYK89mSpJwpQ6ChIGuNHUehwJx+LEyutPrFheqLKsDd6g7NtoRY
   9wBUNu7DBTuP7zL1kfiAW9YM/wVXnBIWSzyjyDZU8dDaAfRKCH9OFx2/7
   qJXUqmwGHxGKHhm8hyNu8lk3R+BwMrt9Rmen/NlZNmYYbto22XhKKqpit
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="381679542"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="381679542"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 07:34:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="810089372"
X-IronPort-AV: E=Sophos;i="6.02,146,1688454000"; 
   d="scan'208";a="810089372"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga008.fm.intel.com with ESMTP; 14 Sep 2023 07:34:52 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 0/2] enable dc chaining service
Date:   Thu, 14 Sep 2023 15:14:11 +0100
Message-Id: <20230914141413.466155-1-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set adds a new configuration option for QAT GEN4 devices allowing the
device to now be configured for chained compression operations in userspace.
Refactoring data structures relating to device configuration to avoid
duplication.

Adam Guerin (1):
  crypto: qat - enable dc chaining service

Giovanni Cabiddu (1):
  crypto: qat - consolidate services structure

 Documentation/ABI/testing/sysfs-driver-qat    |  2 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 56 ++++++++++---------
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 34 ++---------
 .../crypto/intel/qat/qat_common/adf_admin.c   | 39 +++++++++++--
 .../intel/qat/qat_common/adf_cfg_services.h   | 34 +++++++++++
 .../intel/qat/qat_common/adf_cfg_strings.h    |  1 +
 .../crypto/intel/qat/qat_common/adf_sysfs.c   | 17 +-----
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  1 +
 8 files changed, 113 insertions(+), 71 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_cfg_services.h


base-commit: ed12943d6c00be183e876059089792b94f9d3790
-- 
2.40.1

