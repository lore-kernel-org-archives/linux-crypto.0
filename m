Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F5DEC00140
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Aug 2022 18:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbiHRSBl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Aug 2022 14:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239225AbiHRSBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Aug 2022 14:01:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B484621A
        for <linux-crypto@vger.kernel.org>; Thu, 18 Aug 2022 11:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660845699; x=1692381699;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dt1CVOrCoGLXfC/yX21PR0BoBJtQ3lUotxHE0OdISrM=;
  b=dULVF8hGP55td1FK/9WVII9UKi3AD0b6W/c+qXWwICgEQA8Tm3UF9RX0
   z059EB4FaoNnnfwEvvOolhYUu2Zr09wT9F/r5rwP25TKsK3FqHKry8DuA
   gPxiD325Luzjr/sdOZ83mkeh5OH0KNjp0YK3WAIrUeAqArJ+9Av2Ip77F
   LjZvjnUinuFE2h5TUpzrIp0LrmazQrFfYBeHRib63lthXHU4cVV/Iqgdu
   UHVsy4Z1/lDuggC7vL7XRaRL1A4VCMivPppI08YwlpETZM1dV/9bXrB3t
   iJPN+GmyczViDW7OcJ6vtBaiQJjkfQfcTeLWFh17Qt4UVD+eDr3sG3z4R
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="294109406"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="294109406"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 11:01:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="607919456"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2022 11:01:37 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 0/9] crypto: qat - enable compression deflate algorithm
Date:   Thu, 18 Aug 2022 19:01:11 +0100
Message-Id: <20220818180120.63452-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set enables the offload of the compression deflate algorithm to QAT
accelerators through the acomp API.

The first part of the set (patches 1 to 7) reworks and refactors logic
that is specific to the crypto service in order to be used by the
compression service.
In particular, the first 5 patches rework the buffer list logic, which
is used to map, unmap and convert scatterlists into the format that the
QAT firmware can understand. These relocate the bufferlist logic to a
separate file, change the interfaces so that the logic is service agnostic
(not tied to compression or crypto) and extend the interface to allow an
additional pre-allocated buffer for each destination scatter list which
will be used to avoid premature overflows reported by the compression
hardware.
Patch 6 relocates the function qat_algs_alloc_flags() from a crypto
specific header to qat_bl.h.
Patch 7 moves and renames the configuration function for GEN2,
qat_crypto_dev_config(), to a new file, adf_gen2_config.h, which
contains the configuration logic for both crypto and compression
instances for QAT GEN2 devices.

The last 2 patches in the set introduce all the infrastructure required
to enable the compression service in the QAT driver and expose it through
the acomp APIs.
In particular, patch 8 introduces the logic related to the creation
and handling of compression instances and their configuration.
In addition, it adds the back-end for qat_deflate to plug into acomp,
including the logic to build descriptors for the newly added GEN2 compression
firmware APIs.
This was all kept in a single patch to avoid introducing unused logic in
the QAT driver in previous patches.

Patch 9, extends the compression logic to support to QAT GEN4 devices.

All new files in this set are marked as dual license. This is since
portions of the QAT code are shared with QAT projects which are released
under compatible licenses. Occasionally changes are brought back to the
shared codebase used by those projects.

Giovanni Cabiddu (9):
  crypto: qat - relocate bufferlist logic
  crypto: qat - change bufferlist logic interface
  crypto: qat - generalize crypto request buffers
  crypto: qat - extend buffer list interface
  crypto: qat - relocate backlog related structures
  crypto: qat - relocate qat_algs_alloc_flags()
  crypto: qat - rename and relocate GEN2 config function
  crypto: qat - expose deflate through acomp api for QAT GEN2
  crypto: qat - enable deflate for QAT GEN4

 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   4 +-
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.h    |   2 +-
 drivers/crypto/qat/qat_4xxx/adf_drv.c         | 145 ++++++-
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |   4 +
 drivers/crypto/qat/qat_c3xxx/adf_drv.c        |   2 +-
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   4 +
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |   4 +
 drivers/crypto/qat/qat_c62x/adf_drv.c         |   2 +-
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |   4 +
 drivers/crypto/qat/qat_common/Makefile        |   8 +-
 .../crypto/qat/qat_common/adf_accel_devices.h |  14 +
 .../crypto/qat/qat_common/adf_cfg_strings.h   |   1 +
 .../crypto/qat/qat_common/adf_common_drv.h    |   9 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c   |   6 +
 .../crypto/qat/qat_common/adf_gen2_config.c   | 206 +++++++++
 .../crypto/qat/qat_common/adf_gen2_config.h   |  10 +
 drivers/crypto/qat/qat_common/adf_gen2_dc.c   |  70 +++
 drivers/crypto/qat/qat_common/adf_gen2_dc.h   |  10 +
 drivers/crypto/qat/qat_common/adf_gen4_dc.c   |  83 ++++
 drivers/crypto/qat/qat_common/adf_gen4_dc.h   |  10 +
 drivers/crypto/qat/qat_common/adf_init.c      |  11 +
 drivers/crypto/qat/qat_common/adf_sriov.c     |   4 +
 drivers/crypto/qat/qat_common/icp_qat_fw.h    |  24 ++
 .../crypto/qat/qat_common/icp_qat_fw_comp.h   | 404 ++++++++++++++++++
 drivers/crypto/qat/qat_common/icp_qat_hw.h    |  66 +++
 .../qat/qat_common/icp_qat_hw_20_comp.h       | 164 +++++++
 .../qat/qat_common/icp_qat_hw_20_comp_defs.h  | 300 +++++++++++++
 drivers/crypto/qat/qat_common/qat_algs.c      | 202 +--------
 drivers/crypto/qat/qat_common/qat_algs_send.h |  16 +-
 drivers/crypto/qat/qat_common/qat_bl.c        | 214 ++++++++++
 drivers/crypto/qat/qat_common/qat_bl.h        |  61 +++
 drivers/crypto/qat/qat_common/qat_comp_algs.c | 267 ++++++++++++
 drivers/crypto/qat/qat_common/qat_comp_req.h  | 113 +++++
 .../crypto/qat/qat_common/qat_compression.c   | 297 +++++++++++++
 .../crypto/qat/qat_common/qat_compression.h   |  37 ++
 drivers/crypto/qat/qat_common/qat_crypto.c    | 120 +-----
 drivers/crypto/qat/qat_common/qat_crypto.h    |  55 +--
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   4 +
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c     |   2 +-
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   4 +
 40 files changed, 2585 insertions(+), 378 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_config.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_config.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_dc.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen2_dc.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_dc.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_gen4_dc.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_comp.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp_defs.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_bl.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_bl.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_comp_algs.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_comp_req.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_compression.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_compression.h

-- 
2.37.1

