Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69F47CA0ECB
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Sep 2023 21:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353841AbjIKVvC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbjIKKVI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2023 06:21:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FBF1AB
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 03:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694427664; x=1725963664;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n8wGxZcmekuam0JKzoclvPpBUQS2/bzCrgVumMImKN8=;
  b=JjVNXY2WYPFv4fNEOJR5xQqGkOEnmHoo31jbvDqolurzzvxsEcc4XPpu
   vEgtksv14BrMPNUGl8V1s7y2F1MJFPnLS6Km8CQov63ItX+ljAoNhFH1k
   0O3Qq6l70aTnW7/OCcB1awZFl87+ZEFXglY92DMcdPpea6oUvb2AWHrFe
   O9iDZw+Dfy2RY95LbEh97emOZ02ZWvs4htLZRzIrppCjWSrYImFystz3e
   3s0pBy/vDP+V4OZru01+izj09BioJm25SjqiGYFRg2/quV3FMDBjREumC
   xEErIN5gfkN1WHaAbRPQKKgx5Pc1tA2r1VQiNktodJ2GjKR5pQ694dJs/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="409013495"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="409013495"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 03:21:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10829"; a="772533446"
X-IronPort-AV: E=Sophos;i="6.02,243,1688454000"; 
   d="scan'208";a="772533446"
Received: from r007s007_zp31l10c01.deacluster.intel.com (HELO fedora.deacluster.intel.com) ([10.219.171.169])
  by orsmga008.jf.intel.com with ESMTP; 11 Sep 2023 03:21:03 -0700
From:   Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>
Subject: [PATCH v4 0/2] Add debugfs pm_status for qat driver
Date:   Mon, 11 Sep 2023 12:19:37 +0200
Message-ID: <20230911101939.86140-1-lucas.segarra.fernandez@intel.com>
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

