Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE35C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345836AbiDGQxH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbiDGQxG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F80B11A37
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350265; x=1680886265;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QuSbmBOxftIzhrg6RL3xjzoQkGIYcJhHuUAh7qbXrFs=;
  b=hn4JdtsskaTMQb9GzKvkE7b753I88T3yn4Lw1K157IpNkni6q55/CBHl
   GIBH53t5EuIQn+piylqInslroCYkuq80nFIdBaRTQMQQUlBnr4nhfDMdg
   5k1H66li4e1kNlW2f03C5dD0IkYrUIsS7HC6EWz/mvsLGHZyrwRmXpOzb
   d9quj+y+wNxzXSjC+a4ypdQia/nj+69/5Rpcsa/GqZ8LeEDyi4/38UHDr
   wGiXiSGVArzWyI5voVbcubjj/c6d7qO6LfPQ60OFuHwVAbEudq3LHYcLn
   cctW/GCkGGwZcUcMumRBrliPZOHASYWLt4F+YmLISgkiAgU9UTly+bHMt
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241311992"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241311992"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898263"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:02 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 00/16] crypto: qat - misc fixes
Date:   Thu,  7 Apr 2022 17:54:39 +0100
Message-Id: <20220407165455.256777-1-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set contains a collection of fixes for DH895XCC (the first two
patches), PFVF (most of the set) and a few more.

Patches one and two correct the lack of necessary flags to indicate the
presence of specific HW capabilities, which could result in VFs unable
to work correctly.

The third patch fixes some ring interrupts silently enabled even when
VFs are active, while the fourth one is just a style fix.

Patches from five to eleven are minor PFVF fixes, while patch twelve
addresses a bigger problem which caused lost PFVF messages due to
unhandled interrupts during bursts of PFVF messages from multiple VFs.
This was usually noticeable when restarting many VMs/VFs at the same
time. The remainder of the set is a refactoring resulting from the
previous fix, but split into multiple commits to ease the review.

Changes from v1:

- Addition of patches #3, #4, #6, #7, #8, #9, #10 and #11.

Giovanni Cabiddu (3):
  crypto: qat - set CIPHER capability for DH895XCC
  crypto: qat - set COMPRESSION capability for DH895XCC
  crypto: qat - remove unused PFVF stubs

Marco Chiappero (12):
  crypto: qat - fix ETR sources enabled by default on GEN2 devices
  crypto: qat - remove unneeded braces
  crypto: qat - remove unnecessary tests to detect PFVF support
  crypto: qat - add missing restarting event notification in VFs
  crypto: qat - test PFVF registers for spurious interrupts on GEN4
  crypto: qat - fix wording and formatting in code comment
  crypto: qat - fix off-by-one error in PFVF debug print
  crypto: qat - rework the VF2PF interrupt handling logic
  crypto: qat - leverage the GEN2 VF mask definiton
  crypto: qat - replace disable_vf2pf_interrupts()
  crypto: qat - use u32 variables in all GEN4 pfvf_ops
  crypto: qat - remove line wrapping for pfvf_ops functions

Wojciech Ziemba (1):
  crypto: qat - add check for invalid PFVF protocol version 0

 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  15 +--
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.h  |   4 -
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  15 +--
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.h    |   4 -
 .../crypto/qat/qat_common/adf_accel_devices.h |   4 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  18 +--
 .../crypto/qat/qat_common/adf_gen2_hw_data.c  |  13 ++
 .../crypto/qat/qat_common/adf_gen2_hw_data.h  |   6 +
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c |  78 ++++++-----
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c |  61 ++++++---
 drivers/crypto/qat/qat_common/adf_isr.c       |  21 ++-
 drivers/crypto/qat/qat_common/adf_pfvf_msg.h  |   4 +-
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c |   6 +-
 drivers/crypto/qat/qat_common/adf_sriov.c     |  13 +-
 drivers/crypto/qat/qat_common/adf_vf_isr.c    |   1 +
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 126 ++++++++++--------
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.h   |   4 -
 17 files changed, 206 insertions(+), 187 deletions(-)


base-commit: 25d8a743a4810228f9b391f6face4777b28bae7b
-- 
2.34.1

