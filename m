Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B87C47089
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62011613AB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhE0TO5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 15:14:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:7489 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234233AbhE0TO5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 15:14:57 -0400
IronPort-SDR: C+RFNCoEvIYRavXjuJOyMCgKBSb21O9it1oKQ9m1RDEbF/U+tkMEzqWp2XzBOkx2qhYDV2/YqU
 4GmLDJkrLLgg==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="264012419"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="264012419"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 12:13:23 -0700
IronPort-SDR: GmEgZkV6Wi/LY+/ne2I3fOQpEXIDNUCIAG1gG6ZIk3ITp3W7ljzI7VX3zcC+mtfifbUxQKew7e
 u5bvv56DoxMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480717730"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 12:13:22 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 00/10] crypto: qat - misc fixes 
Date:   Thu, 27 May 2021 20:12:41 +0100
Message-Id: <20210527191251.6317-1-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set is a collection of various fixes, mostly related to the PF/VF
protocol.

Giovanni Cabiddu (4):
  crypto: qat - use proper type for vf_mask
  crypto: qat - do not ignore errors from enable_vf2pf_comms()
  crypto: qat - handle both source of interrupt in VF ISR
  crypto: qat - prevent spurious MSI interrupt in VF

Marco Chiappero (5):
  crypto: qat - remove empty sriov_configure()
  crypto: qat - enable interrupts only after ISR allocation
  crypto: qat - prevent spurious MSI interrupt in PF
  crypto: qat - rename compatibility version definition
  crypto: qat - fix reuse of completion variable

Svyatoslav Pankratov (1):
  crypto: qat - remove intermediate tasklet for vf2pf

 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  2 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |  2 +
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  2 +-
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |  2 +
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |  2 +-
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  2 +-
 drivers/crypto/qat/qat_c62x/adf_drv.c         |  2 +
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |  2 +-
 .../crypto/qat/qat_common/adf_accel_devices.h |  3 --
 .../crypto/qat/qat_common/adf_common_drv.h    |  6 +--
 drivers/crypto/qat/qat_common/adf_init.c      |  9 ++--
 drivers/crypto/qat/qat_common/adf_isr.c       | 42 +++++++++++++------
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 20 +++++----
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h |  2 +-
 drivers/crypto/qat/qat_common/adf_sriov.c     |  8 +---
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 16 +++++--
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |  2 +
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |  2 +-
 19 files changed, 75 insertions(+), 53 deletions(-)

-- 
2.26.2

