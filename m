Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD90C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 830A960F9E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhKJUzM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 15:55:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:55750 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232583AbhKJUzM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 15:55:12 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232610919"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="232610919"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:52:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="642662928"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2021 12:52:21 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 00/24] crypto: qat - PFVF refactoring
Date:   Wed, 10 Nov 2021 20:51:53 +0000
Message-Id: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set includes fixes to the PFVF logic but also refactoring in
preparation for updates to the protocol and support for QAT GEN4
devices.

The main changes introduced by this set are:
* A fix for a bug introduced in the previous PFVF set related to an
  undetected timeout;
* The refactoring and rework of the PFVF message handling logic which
  includes changes to the ACK behaviour;
* The introduction of adf_pfvf_gen2.c which includes logic common
  to QAT GEN 2 devices;
* The introduction of the pfvf_ops structure to isolate PFVF related
  code inside the adf_hw_device_data structure and facilitate the
  introduction of PFVF for QAT GEN4;
* The reorganization of the PFVF code structure so that message logic
  is separated from low level communication primitives and the protocol.

Giovanni Cabiddu (6):
  crypto: qat - fix undetected PFVF timeout in ACK loop
  crypto: qat - move vf2pf interrupt helpers
  crypto: qat - change PFVF ACK behaviour
  crypto: qat - re-enable interrupts for legacy PFVF messages
  crypto: qat - relocate PFVF disabled function
  crypto: qat - abstract PFVF receive logic

Marco Chiappero (18):
  crypto: qat - refactor PF top half for PFVF
  crypto: qat - move VF message handler to adf_vf2pf_msg.c
  crypto: qat - move interrupt code out of the PFVF handler
  crypto: qat - split PFVF message decoding from handling
  crypto: qat - handle retries due to collisions in adf_iov_putmsg()
  crypto: qat - relocate PFVF PF related logic
  crypto: qat - relocate PFVF VF related logic
  crypto: qat - add pfvf_ops
  crypto: qat - differentiate between pf2vf and vf2pf offset
  crypto: qat - abstract PFVF send function
  crypto: qat - reorganize PFVF code
  crypto: qat - reorganize PFVF protocol definitions
  crypto: qat - use enums for PFVF protocol codes
  crypto: qat - pass the PF2VF responses back to the callers
  crypto: qat - refactor pfvf version request messages
  crypto: qat - do not rely on min version
  crypto: qat - fix VF IDs in PFVF log messages
  crypto: qat - improve logging of PFVF messages

 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |  11 +-
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  11 +-
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |  14 +-
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h     |   1 -
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c      |   2 +-
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  11 +-
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |  14 +-
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.h       |   1 -
 drivers/crypto/qat/qat_c62xvf/adf_drv.c       |   2 +-
 drivers/crypto/qat/qat_common/Makefile        |   6 +-
 .../crypto/qat/qat_common/adf_accel_devices.h |  25 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  30 +-
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  48 --
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  |  13 -
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 225 ++++++++++
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.h |  33 ++
 .../crypto/qat/qat_common/adf_gen4_hw_data.c  |   7 +
 drivers/crypto/qat/qat_common/adf_init.c      |   2 +-
 drivers/crypto/qat/qat_common/adf_isr.c       | 123 ++++--
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 416 ------------------
 .../{adf_pf2vf_msg.h => adf_pfvf_msg.h}       |  68 +--
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.c   |  21 +
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.h   |  10 +
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c | 145 ++++++
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.h |  13 +
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.c   |  97 ++++
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.h   |  21 +
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c | 134 ++++++
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.h |  14 +
 drivers/crypto/qat/qat_common/adf_sriov.c     |  20 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c |  48 --
 drivers/crypto/qat/qat_common/adf_vf_isr.c    |  92 ++--
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |  14 +-
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |  14 +-
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.h   |   1 -
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c   |   2 +-
 36 files changed, 938 insertions(+), 771 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
 delete mode 100644 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
 rename drivers/crypto/qat/qat_common/{adf_pf2vf_msg.h => adf_pfvf_msg.h} (81%)
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.h
 delete mode 100644 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c

-- 
2.33.1

