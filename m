Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F14EDE99C
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 09:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbjINJ5P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 05:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237518AbjINJ5P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 05:57:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCE1EB
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 02:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694685431; x=1726221431;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l4UFqki804+CMonkcgu8e4qmRYXFHAhg7vqgIjJlcus=;
  b=lWRDtBOCId8I+VIp0m06nsmZnVIQyICt9oncjz8Wd+JzO3EIlkud/jAP
   dV3F+MjGSEh8/1zf1dX4A0CQrkdscMBMDthlot5lQjhuvWn+WNGd9eioc
   2b5/IpHODPTxI7OAp52yLx2rOgK1x19R7XrgunyFC8A6OFhbD5y+bo8PW
   mD+GoAYiFhCGYJGAC2xEjkzjtiJX4laGdNwa1oKiPXuZUAW/HFQuCemSt
   zfvKEvxz/0p7u/bZrerEOHAvR0VWVUqAGVjsE5VxzwFz9Dr2M+cFixILh
   ck4K0gKFs3G1mcRgLcg7sYxLa8mRTXlpyo+Wv8RhS6dPfotgFwaLlTRzb
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="465279147"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="465279147"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 02:57:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814619709"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="814619709"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga004.fm.intel.com with ESMTP; 14 Sep 2023 02:57:09 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/5] crypto: qat - state change fixes
Date:   Thu, 14 Sep 2023 10:55:44 +0100
Message-ID: <20230914095658.27166-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set combines a set of fixes in the QAT driver related to the core
state machines and the change in state that can be triggered through
sysfs.

Here is a summary of the changes:
* Patch #1 resolves a bug that prevents resources to be freed up.
* Patch #2 is a simple cleanup.
* Patch #3 fix the behaviour of the command `up` triggered through a
  write to  /sys/bus/pci/devices/<BDF>/qat/state.
* Patches #4 and #5 fix a corner case in the un-registration of
  algorithms in the state machines.

Giovanni Cabiddu (5):
  crypto: qat - fix state machines cleanup paths
  crypto: qat - do not shadow error code
  crypto: qat - ignore subsequent state up commands
  crypto: qat - fix unregistration of crypto algorithms
  crypto: qat - fix unregistration of compression algorithms

 .../intel/qat/qat_common/adf_common_drv.h       |  2 ++
 drivers/crypto/intel/qat/qat_common/adf_init.c  | 17 ++++++++---------
 drivers/crypto/intel/qat/qat_common/adf_sysfs.c | 15 ++++++++++++---
 3 files changed, 22 insertions(+), 12 deletions(-)


base-commit: be369945f2f612c40f771fe265db1ca658cdc0d1
-- 
2.41.0

