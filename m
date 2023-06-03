Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C41C77B73
	for <linux-crypto@archiver.kernel.org>; Sat,  3 Jun 2023 08:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbjFCI3A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 3 Jun 2023 04:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbjFCI26 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Jun 2023 04:28:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BAFA6
        for <linux-crypto@vger.kernel.org>; Sat,  3 Jun 2023 01:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685780937; x=1717316937;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mL7bZYU/BbamhYr6BhJw0FZup+b+Qt86qS9b1u0oEd8=;
  b=U7/UlvK14kI8bcnVZyL43mLBmere2oSJNM8woMiPo7qMnppDo0Hu6GB9
   rf9TtmicD92ReGRCMBrCBQ0/8eM7oeHmRqRWj3EUMTecR9nIPSPbxQ7vN
   hJAy8fM1noeHm80TCScJKC+W94lXJ9fSaHMjMk+aWSqkg4Fr//fy7wLMD
   NemyGeT4wle6NtxgqzQ8EeOxHQhOME2sUP+2NjqvaMAY785UXDJsprpeR
   mwhaeQ6PxfxtKyducLq/gv5E7N/iY+AJlz/NBynlRRYQ/dubxwMuuHoTR
   CNpbyohI4RNPLgXCrRbY/nPDcFEfZHpLWZ1YpIgQXHssnvySDeYCKTa0X
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="353541060"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="353541060"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2023 01:28:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="708100433"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="708100433"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by orsmga002.jf.intel.com with ESMTP; 03 Jun 2023 01:28:55 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        damian.muszynski@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] crypto: qat - add missing function declaration in adf_dbgfs.h
Date:   Sat,  3 Jun 2023 09:28:53 +0100
Message-Id: <20230603082853.44631-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_dbgfs_exit() was improperly named causing the build to
fail when CONFIG_DEBUG_FS=n.

Rename adf_dbgfs_cleanup() as adf_dbgfs_exit().

This fixes the following build error:
      CC [M]  drivers/crypto/intel/qat/qat_c62x/adf_drv.o
    drivers/crypto/intel/qat/qat_c62x/adf_drv.c: In function ‘adf_cleanup_accel’:
    drivers/crypto/intel/qat/qat_c62x/adf_drv.c:69:9: error: implicit declaration of function ‘adf_dbgfs_exit’; did you mean ‘adf_dbgfs_init’? [-Werror=implicit-function-declaration]
       69 |         adf_dbgfs_exit(accel_dev);
          |         ^~~~~~~~~~~~~~
          |         adf_dbgfs_init
    cc1: all warnings being treated as errors
    make[2]: *** [scripts/Makefile.build:252: drivers/crypto/intel/qat/qat_c62x/adf_drv.o] Error 1
    make[1]: *** [scripts/Makefile.build:494: drivers/crypto/intel/qat/qat_c62x] Error 2
    make: *** [Makefile:2026: drivers/crypto/intel/qat] Error 2

Fixes: 9260db6640a6 ("crypto: qat - move dbgfs init to separate file")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306030654.5t4qkyN1-lkp@intel.com/
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/adf_dbgfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.h b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.h
index 1d64ad1a0037..e0cb2c2a2ed0 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.h
@@ -22,7 +22,7 @@ static inline void adf_dbgfs_rm(struct adf_accel_dev *accel_dev)
 {
 }
 
-static inline void adf_dbgfs_cleanup(struct adf_accel_dev *accel_dev)
+static inline void adf_dbgfs_exit(struct adf_accel_dev *accel_dev)
 {
 }
 #endif
-- 
2.40.1

