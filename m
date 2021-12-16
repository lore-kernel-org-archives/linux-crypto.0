Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 193EDC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhLPJLL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:11 -0500
Received: from mga12.intel.com ([192.55.52.136]:9653 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhLPJLL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645870; x=1671181870;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=No3SDEFW+K4wyoYIhTFWfB2sg0Tzbv1tJ7674MTr2mY=;
  b=WHgCcpgmaRTaCaiC9XU5Fpv875knHczUOXWMVyUgthtt8RM5pLGQN8Ws
   EmyOcQMTArbhmnb6KHY0XKglj33YIHi2I5skhFx7KUzaD6u1QEo8DLRjt
   jTwO1OMiyQizIGkNrcC2KmkaodJtx30l+xx1WkeTgqCUR8ht8ixqnC9TZ
   Y+d7gMwFMqH52t8VsEXOD89jXpTR3iKBaxbkzotwFU7yr1fODcyx781on
   viFRpq3ghKfbfEpcL+s5OtDvwB9luJMHSgaPbKSVCt9hLCZyUnidxKWmb
   CM8An4JzgvK9xoxx0eSE9PyDCJxWcrvuLCUrH6xq6Q0asqWaoiQKADiGz
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458326"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458326"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968392"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:08 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com
Subject: [PATCH 00/24] crypto: qat - PFVF updates and improved GEN4 support
Date:   Thu, 16 Dec 2021 09:13:10 +0000
Message-Id: <20211216091334.402420-1-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set mainly revolves around PFVF and support for compression on GEN4
devices.

Along with misc quality improvements to the PFVF code, it includes the
following major changes:
* Improved detection of HW capabilities for both GEN2 and GEN4 devices
* PFVF protocol updates, up to version 4, which include Block Messages
  and Fast ACK
* PFVF support for the GEN4 host driver
* Support for enabling and reporting the compression service on GEN4
  devices
* Support for Ring Pair reset by VFs on GEN4 devices
* The refactoring of PFVF code to allow for the introduction of GEN4
  support

Giovanni Cabiddu (5):
  crypto: qat - get compression extended capabilities
  crypto: qat - set CIPHER capability for QAT GEN2
  crypto: qat - set COMPRESSION capability for QAT GEN2
  crypto: qat - extend crypto capability detection for 4xxx
  crypto: qat - allow detection of dc capabilities for 4xxx

Marco Chiappero (18):
  crypto: qat - support the reset of ring pairs on PF
  crypto: qat - add the adf_get_pmisc_base() helper function
  crypto: qat - make PFVF message construction direction agnostic
  crypto: qat - make PFVF send and receive direction agnostic
  crypto: qat - set PFVF_MSGORIGIN just before sending
  crypto: qat - abstract PFVF messages with struct pfvf_message
  crypto: qat - leverage bitfield.h utils for PFVF messages
  crypto: qat - leverage read_poll_timeout in PFVF send
  crypto: qat - improve the ACK timings in PFVF send
  crypto: qat - store the PFVF protocol version of the endpoints
  crypto: qat - store the ring-to-service mapping
  crypto: qat - introduce support for PFVF block messages
  crypto: qat - exchange device capabilities over PFVF
  crypto: qat - support fast ACKs in the PFVF protocol
  crypto: qat - exchange ring-to-service mappings over PFVF
  crypto: qat - config VFs based on ring-to-svc mapping
  crypto: qat - add PFVF support to the GEN4 host driver
  crypto: qat - add PFVF support to enable the reset of ring pairs

Tomasz Kowalik (1):
  crypto: qat - add support for compression for 4xxx

 drivers/crypto/qat/Kconfig                    |   1 +
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    | 145 ++++++--
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   2 +
 drivers/crypto/qat/qat_4xxx/adf_drv.c         |  33 ++
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |   1 +
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   1 +
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |   4 -
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |   1 +
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |   1 +
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       |   4 -
 drivers/crypto/qat/qat_common/Makefile        |   4 +-
 .../crypto/qat/qat_common/adf_accel_devices.h |  28 +-
 .../crypto/qat/qat_common/adf_accel_engine.c  |   8 +-
 drivers/crypto/qat/qat_common/adf_admin.c     |  47 ++-
 drivers/crypto/qat/qat_common/adf_cfg.c       |   1 +
 .../crypto/qat/qat_common/adf_cfg_common.h    |  13 +
 .../crypto/qat/qat_common/adf_cfg_strings.h   |   3 +
 .../crypto/qat/qat_common/adf_common_drv.h    |  12 +
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  57 ++--
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  |   9 +
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 316 +++++++++++++-----
 .../crypto/qat/qat_common/adf_gen4_hw_data.c  |  62 +++-
 .../crypto/qat/qat_common/adf_gen4_hw_data.h  |  17 +
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 148 ++++++++
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.h |  17 +
 drivers/crypto/qat/qat_common/adf_init.c      |   9 +-
 drivers/crypto/qat/qat_common/adf_isr.c       |  28 +-
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h  | 202 +++++++++--
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.c   |  35 +-
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.h   |   8 +
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 262 +++++++++++++--
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.h |   2 +-
 .../crypto/qat/qat_common/adf_pfvf_utils.c    |  65 ++++
 .../crypto/qat/qat_common/adf_pfvf_utils.h    |  31 ++
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.c   |  98 +++++-
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.h   |   2 +
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c | 284 ++++++++++++++--
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.h |   7 +-
 drivers/crypto/qat/qat_common/adf_sriov.c     |  39 ++-
 drivers/crypto/qat/qat_common/adf_vf_isr.c    |  14 +-
 .../qat/qat_common/icp_qat_fw_init_admin.h    |   4 +-
 drivers/crypto/qat/qat_common/icp_qat_hw.h    |  13 +-
 drivers/crypto/qat/qat_common/qat_crypto.c    |  25 ++
 drivers/crypto/qat/qat_common/qat_hal.c       |  41 +--
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   3 +
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   1 +
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |   4 -
 47 files changed, 1776 insertions(+), 336 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_pfvf.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_utils.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_utils.h

-- 
2.31.1

