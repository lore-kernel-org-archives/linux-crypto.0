Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1960CD4F33
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Sep 2023 09:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjIVJEw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Sep 2023 05:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbjIVJEv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2023 05:04:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1DC99
        for <linux-crypto@vger.kernel.org>; Fri, 22 Sep 2023 02:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695373486; x=1726909486;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uq4TESfpb6urfJZuOSfsDo4lbV+51STmm9qW26MIHoY=;
  b=lgGyGklq/IsUnU7FBNqhdKZwMV5Uteh6VzurD3Op7fUISz21N8VQAZbc
   or6Vtd6WgUKYet4gcBS+rqjTMIX/Oc5GpB3JUfAxOsIXCN5abQEzRxS3n
   KHI1F68nl8XUVNCqg/sripPFNJZnfRghzmug4BXyvkuEdr+TkMCG3Mqzz
   r7fyXkfVCFTjDqaEckDlboEH+/P7tRBIcWi4XFEhIQqlD0+INcc4OEIKC
   pNtnLvXO7k3bmVS834gmv27GbadelObAjU1ZA8hXNGheAqpNo/ddmE60S
   KgxXdXUx5OPE1nD8IRYCG4n9DfzaZuXzx7m7R1dpi5iWe+P9P5mZIdLxh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="444882338"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="444882338"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 02:04:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10840"; a="862870871"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="862870871"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.216])
  by fmsmga002.fm.intel.com with ESMTP; 22 Sep 2023 02:04:42 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Damian Muszynski <damian.muszynski@intel.com>
Subject: [PATCH] crypto: qat - increase size of buffers
Date:   Fri, 22 Sep 2023 10:03:47 +0100
Message-ID: <20230922090439.30120-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Increase the size of the buffers used for composing the names used for
the transport debugfs entries and the vector name to avoid a potential
truncation.

This resolves the following errors when compiling the driver with W=1
and KCFLAGS=-Werror on GCC 12.3.1:

    drivers/crypto/intel/qat/qat_common/adf_transport_debug.c: In function ‘adf_ring_debugfs_add’:
    drivers/crypto/intel/qat/qat_common/adf_transport_debug.c:100:60: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
    drivers/crypto/intel/qat/qat_common/adf_isr.c: In function ‘adf_isr_resource_alloc’:
    drivers/crypto/intel/qat/qat_common/adf_isr.c:197:47: error: ‘%d’ directive output may be truncated writing between 1 and 11 bytes into a region of size between 0 and 5 [-Werror=format-truncation=]

Fixes: a672a9dc872e ("crypto: qat - Intel(R) QAT transport code")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Damian Muszynski <damian.muszynski@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_accel_devices.h   | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_transport_debug.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
index e57abde66f4f..1e84ff309ed3 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_accel_devices.h
@@ -29,7 +29,7 @@
 #define ADF_PCI_MAX_BARS 3
 #define ADF_DEVICE_NAME_LENGTH 32
 #define ADF_ETR_MAX_RINGS_PER_BANK 16
-#define ADF_MAX_MSIX_VECTOR_NAME 16
+#define ADF_MAX_MSIX_VECTOR_NAME 48
 #define ADF_DEVICE_NAME_PREFIX "qat_"
 
 enum adf_accel_capabilities {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
index 08bca1c506c0..e2dd568b87b5 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
@@ -90,7 +90,7 @@ DEFINE_SEQ_ATTRIBUTE(adf_ring_debug);
 int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 {
 	struct adf_etr_ring_debug_entry *ring_debug;
-	char entry_name[8];
+	char entry_name[16];
 
 	ring_debug = kzalloc(sizeof(*ring_debug), GFP_KERNEL);
 	if (!ring_debug)
@@ -192,7 +192,7 @@ int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
 {
 	struct adf_accel_dev *accel_dev = bank->accel_dev;
 	struct dentry *parent = accel_dev->transport->debug;
-	char name[8];
+	char name[16];
 
 	snprintf(name, sizeof(name), "bank_%02d", bank->bank_number);
 	bank->bank_debug_dir = debugfs_create_dir(name, parent);

base-commit: edcadf3e2fec2d0512a61273e130a53fc19c501a
-- 
2.41.0

