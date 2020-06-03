Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0417BC433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 17:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D575D20679
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 17:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgFCRfJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 13:35:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:31625 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgFCRfI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 13:35:08 -0400
IronPort-SDR: zAvgIcLuQQyics2/sMKXpYWyY21M2uCnn0UeRtR4eNcQ0NDORKcb++XGyb+O+KAvIGOQiko4Y4
 JSZDmaHzDO9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 10:34:08 -0700
IronPort-SDR: ocfEx5ucgu1UHI09iSP1UbIykZ0W2ang5MPAbRfOzbIKM7LMX7KLSxWx9TBpKFMPd7FaEJrRJd
 xbJKNt/+7SbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,468,1583222400"; 
   d="scan'208";a="304445556"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga002.fm.intel.com with ESMTP; 03 Jun 2020 10:34:06 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/3] Replace user types and remove packed
Date:   Wed,  3 Jun 2020 18:33:43 +0100
Message-Id: <20200603173346.96967-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove user types across qat code base and replace packed attribute in
etr ring struct which causes a split lock.

These changes are on top of "crypto: qat - fix parameter check in aead
encryption" (https://patchwork.kernel.org/patch/11574001/)

Giovanni Cabiddu (1):
  crypto: qat - remove packed attribute in etr structs

Wojciech Ziemba (2):
  crypto: qat - replace user types with kernel u types
  crypto: qat - replace user types with kernel ABI __u types

 .../crypto/qat/qat_common/adf_accel_devices.h |  54 +++---
 .../crypto/qat/qat_common/adf_accel_engine.c  |   4 +-
 drivers/crypto/qat/qat_common/adf_aer.c       |   2 +-
 .../crypto/qat/qat_common/adf_cfg_common.h    |  24 +--
 drivers/crypto/qat/qat_common/adf_cfg_user.h  |  10 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  12 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c   |   4 +-
 drivers/crypto/qat/qat_common/adf_dev_mgr.c   |   8 +-
 drivers/crypto/qat/qat_common/adf_transport.c |  62 +++----
 drivers/crypto/qat/qat_common/adf_transport.h |   4 +-
 .../qat_common/adf_transport_access_macros.h  |   6 +-
 .../qat/qat_common/adf_transport_internal.h   |  27 ++-
 drivers/crypto/qat/qat_common/icp_qat_fw.h    |  58 +++----
 .../qat/qat_common/icp_qat_fw_init_admin.h    |  46 ++---
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h | 158 +++++++++---------
 .../crypto/qat/qat_common/icp_qat_fw_pke.h    |  52 +++---
 drivers/crypto/qat/qat_common/icp_qat_hw.h    |  16 +-
 drivers/crypto/qat/qat_common/icp_qat_uclo.h  |   6 +-
 drivers/crypto/qat/qat_common/qat_algs.c      |  54 +++---
 drivers/crypto/qat/qat_common/qat_asym_algs.c |  12 +-
 drivers/crypto/qat/qat_common/qat_hal.c       |  40 ++---
 drivers/crypto/qat/qat_common/qat_uclo.c      |  20 +--
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  26 +--
 23 files changed, 352 insertions(+), 353 deletions(-)

-- 
2.26.2

