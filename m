Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6E1C7EE29
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 16:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjFIQs1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 12:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjFIQsY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 12:48:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D66A3A97
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 09:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686329295; x=1717865295;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qK7a3DbcgiiQ7PjndS7KGmptoCJ7ciyNS2Log1XeNYY=;
  b=PouNA8ES21p7We5GChgX0BaZRS3CvsBUCFA7eas+lzmFvVpZoGGpDmq5
   6IfiuRx10y52F0RcdGQfBruWgkK3M3zqlYSAujGTnd2LoYwTCiKta2vL+
   FheoG+wlx2Fnk0w3FA5dJboN0Sl1/2MxnHJ7Zo1S9u1crM78qUmpXVHl5
   +c3Ov+JutTBDSyFv+ZMYVoVas1+2uJmUVE1oN7+ioUiEFzFlmfw6M9Rf3
   Na/mwLcuMyfxBOFiPKsiWvFg5jpR9HjJ10u/KSKmUnqguxhAdqHfvAcqp
   /Qk/NueYtvzkRVPnAVi63Rmyh/f71mMXbTc3OzdYybcujLKOTUx6Ne5p5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="337999059"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="337999059"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:48:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957214139"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="957214139"
Received: from silpixa00400295.ir.intel.com ([10.237.213.194])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2023 09:48:13 -0700
From:   Adam Guerin <adam.guerin@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 0/4] crypto: qat - extend configuration for 4xxx
Date:   Fri,  9 Jun 2023 17:38:18 +0100
Message-Id: <20230609163821.6533-1-adam.guerin@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organisation: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare, Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set extends the configuration of the device to accept more
variations of the configurable services and the device is configured
correctly based on the configured service. Refactoring the FW config
logic to avoid duplication. Loading the correct FW based on the type and
configuration of the device also reporting the correct capabilities
for the configured service.

Adam Guerin (2):
  crypto: qat - move returns to default case
  crypto: qat - extend configuration for 4xxx

Giovanni Cabiddu (2):
  crypto: qat - make fw images name constant
  crypto: qat - refactor fw config logic for 4xxx

 Documentation/ABI/testing/sysfs-driver-qat    |  11 +
 .../intel/qat/qat_4xxx/adf_4xxx_hw_data.c     | 229 +++++++++++++-----
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |  33 +++
 .../intel/qat/qat_common/adf_accel_devices.h  |   2 +-
 .../intel/qat/qat_common/adf_accel_engine.c   |   2 +-
 .../intel/qat/qat_common/adf_cfg_strings.h    |   7 +
 .../intel/qat/qat_common/adf_common_drv.h     |   2 +-
 .../crypto/intel/qat/qat_common/adf_sysfs.c   |   7 +
 .../crypto/intel/qat/qat_common/qat_algs.c    |   1 -
 .../crypto/intel/qat/qat_common/qat_uclo.c    |   8 +-
 10 files changed, 231 insertions(+), 71 deletions(-)


base-commit: 6b5755b35497de5e8ed17772f7b0dd1bbe19cbee
-- 
2.40.1

