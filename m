Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D09C4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F4F46104F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 20:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhHLUWF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 16:22:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:4133 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhHLUWE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 16:22:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="215473993"
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="215473993"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 13:21:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,316,1620716400"; 
   d="scan'208";a="517608543"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 13:21:37 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 00/20] crypto: qat - cumulative fixes
Date:   Thu, 12 Aug 2021 21:21:09 +0100
Message-Id: <20210812202129.18831-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a collection of various fixes and improvements, mostly related
to PFVF, from various authors.
A previous version of this set was already sent to this list a few weeks
ago. I didn't call this V2 since a number of patches were
added/removed to the set and the order of the patches changed.

Ahsan Atta (1):
  crypto: qat - flush vf workqueue at driver removal

Giovanni Cabiddu (7):
  crypto: qat - use proper type for vf_mask
  crypto: qat - do not ignore errors from enable_vf2pf_comms()
  crypto: qat - handle both source of interrupt in VF ISR
  crypto: qat - prevent spurious MSI interrupt in VF
  crypto: qat - move IO virtualization functions
  crypto: qat - do not export adf_iov_putmsg()
  crypto: qat - store vf.compatible flag

Kanchana Velusamy (1):
  crypto: qat - protect interrupt mask CSRs with a spinlock

Marco Chiappero (10):
  crypto: qat - remove empty sriov_configure()
  crypto: qat - enable interrupts only after ISR allocation
  crypto: qat - prevent spurious MSI interrupt in PF
  crypto: qat - rename compatibility version definition
  crypto: qat - fix reuse of completion variable
  crypto: qat - move pf2vf interrupt [en|dis]able to adf_vf_isr.c
  crypto: qat - fix naming for init/shutdown VF to PF notifications
  crypto: qat - complete all the init steps before service notification
  crypto: qat - fix naming of PF/VF enable functions
  crypto: qat - remove the unnecessary get_vintmsk_offset()

Svyatoslav Pankratov (1):
  crypto: qat - remove intermediate tasklet for vf2pf

 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  8 +-
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  | 19 ++---
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |  1 -
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     | 14 +---
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h     |  1 -
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |  1 +
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    | 19 ++---
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |  1 -
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       | 14 +---
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.h       |  1 -
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       |  1 +
 .../crypto/qat/qat_common/adf_accel_devices.h |  8 +-
 .../crypto/qat/qat_common/adf_common_drv.h    | 21 +++--
 drivers/crypto/qat/qat_common/adf_init.c      | 13 ++--
 drivers/crypto/qat/qat_common/adf_isr.c       | 42 ++++++----
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 78 +++++++++++--------
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h |  2 +-
 drivers/crypto/qat/qat_common/adf_sriov.c     |  8 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 12 +--
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 64 ++++++++++++++-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 19 ++---
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |  1 -
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   | 14 +---
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.h   |  1 -
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |  1 +
 25 files changed, 207 insertions(+), 157 deletions(-)

-- 
2.31.1

