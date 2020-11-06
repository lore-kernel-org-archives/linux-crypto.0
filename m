Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D52C2D0A3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A924F206B2
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgKFL2h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:28:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:59365 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbgKFL2e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:28:34 -0500
IronPort-SDR: Jc3KFpSw5r/PRl+IL9a9cWhRjtRUPl+nCAqI9NCD5Vamu21G3DLPJRqGYQJytue1kUfqeflGoz
 vqTRvpH4ITiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698277"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698277"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:28:33 -0800
IronPort-SDR: rO8cBRcWIoXSve9fLSNOU5EbRE3UYLXSEm9Qt0kRBGiH2pOaVBDfDRki74Vp9RbqMCpaEeX8z6
 cCRNI/ifxHMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779150"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:28:32 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>
Subject: [PATCH 00/32] crypto: qat - rework firmware loader in preparation for qat_4xxx
Date:   Fri,  6 Nov 2020 19:27:38 +0800
Message-Id: <20201106112810.2566-1-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rework firmware loader in QAT driver in preparation for the support of the qat_4xxx driver.

Patch #1 add support for the mof format in the firmware loader
Patches from #2 to #7 introduce some general fixes
Patches from #8 to #30 rework and refactor the firmware loader to support the new features added by the next generation of QAT devices (QAT GEN4)
Patch #31 introduces the firmware loader changes to support QAT GEN4 devices

Giovanni Cabiddu (1):
  crypto: qat - support for mof format in fw loader

Jack Xu (31):
  crypto: qat - loader: fix status check in qat_hal_put_rel_rd_xfer()
  crypto: qat - loader: fix CSR access
  crypto: qat - loader: fix error message
  crypto: qat - loader: remove unnecessary parenthesis
  crypto: qat - loader: introduce additional parenthesis
  crypto: qat - loader: rename qat_uclo_del_uof_obj()
  crypto: qat - loader: add support for relative FW ucode loading
  crypto: qat - loader: change type for ctx_mask
  crypto: qat - loader: change micro word data mask
  crypto: qat - loader: refactor AE start
  crypto: qat - loader: remove global CSRs helpers
  crypto: qat - loader: move defines to header files
  crypto: qat - loader: refactor qat_uclo_set_ae_mode()
  crypto: qat - loader: refactor long expressions
  crypto: qat - loader: introduce chip info structure
  crypto: qat - loader: replace check based on DID
  crypto: qat - loader: add next neighbor to chip_info
  crypto: qat - loader: add support for lm2 and lm3
  crypto: qat - loader: add local memory size to chip info
  crypto: qat - loader: add reset CSR and mask to chip info
  crypto: qat - loader: add clock enable CSR to chip info
  crypto: qat - loader: add wake up event to chip info
  crypto: qat - loader: add misc control CSR to chip info
  crypto: qat - loader: add check for null pointer
  crypto: qat - loader: use ae_mask
  crypto: qat - loader: add CSS3K support
  crypto: qat - loader: add FCU CSRs to chip info
  crypto: qat - loader: allow to target specific AEs
  crypto: qat - loader: add support for shared ustore
  crypto: qat - loader: add support for broadcasting mode
  crypto: qat - loader: add gen4 firmware loader

 .../crypto/qat/qat_common/adf_accel_devices.h |   2 +
 .../crypto/qat/qat_common/adf_accel_engine.c  |  13 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  19 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h |  26 +-
 drivers/crypto/qat/qat_common/icp_qat_hal.h   |  63 +-
 drivers/crypto/qat/qat_common/icp_qat_uclo.h  | 132 +++-
 drivers/crypto/qat/qat_common/qat_hal.c       | 400 +++++++---
 drivers/crypto/qat/qat_common/qat_uclo.c      | 737 ++++++++++++++----
 8 files changed, 1097 insertions(+), 295 deletions(-)

-- 
2.25.4

