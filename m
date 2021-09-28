Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EC0C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C22F5610E6
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Sep 2021 11:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240336AbhI1Lqa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Sep 2021 07:46:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:37909 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231202AbhI1Lqa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Sep 2021 07:46:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288339029"
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="288339029"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2021 04:44:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,329,1624345200"; 
   d="scan'208";a="562224599"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 28 Sep 2021 04:44:49 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 00/12] crypto: qat - PFVF fixes and refactoring
Date:   Tue, 28 Sep 2021 12:44:28 +0100
Message-Id: <20210928114440.355368-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set includes few fixes and refactors in the QAT driver, mainly
related to the PFVF communication mechanism.

Here is a summary of the changes:
* Patches #1 and #2 fix a bug in the PFVF protocol related to collision
  detection;
* Patch #3 optimizes the PFVF protocol protocol by removing an unnecessary
  timeout;
* Patch #4 makes the VF to PF interrupt related logic device specific;
* Patches #5 and #6 remove duplicated logic across devices and homegrown
  logic;
* Patches #7 to #12 are just refactoring of the PFVF code in preparation
  for updates to the protocol.

Giovanni Cabiddu (3):
  crypto: qat - detect PFVF collision after ACK
  crypto: qat - disregard spurious PFVF interrupts
  crypto: qat - use hweight for bit counting

Marco Chiappero (9):
  crypto: qat - remove unnecessary collision prevention step in PFVF
  crypto: qat - fix handling of VF to PF interrupts
  crypto: qat - remove duplicated logic across GEN2 drivers
  crypto: qat - make pfvf send message direction agnostic
  crypto: qat - move pfvf collision detection values
  crypto: qat - rename pfvf collision constants
  crypto: qat - add VF and PF wrappers to common send function
  crypto: qat - extract send and wait from adf_vf2pf_request_version()
  crypto: qat - share adf_enable_pf2vf_comms() from adf_pf2vf_msg.c

 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   4 +-
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  89 +------
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |  13 +-
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  87 +------
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |  12 -
 .../crypto/qat/qat_common/adf_accel_devices.h |   5 +
 .../crypto/qat/qat_common/adf_common_drv.h    |   9 +-
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  98 ++++++++
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  |  27 ++
 drivers/crypto/qat/qat_common/adf_isr.c       |  20 +-
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 238 ++++++++++--------
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.h |   9 -
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c |   4 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c    |   6 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 123 ++++-----
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |  14 +-
 16 files changed, 361 insertions(+), 397 deletions(-)

-- 
2.31.1

