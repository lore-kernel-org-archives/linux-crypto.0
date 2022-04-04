Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75C2C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Apr 2022 14:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349018AbiDDOgo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Apr 2022 10:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241508AbiDDOgm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Apr 2022 10:36:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151C8120B9
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 07:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649082887; x=1680618887;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z+hMswjv5+YdlF7qPTqTVspbOeJZPEQyjAUdWq0ZysA=;
  b=PHS02eUpb2NGbtbnmHpcnJRglAXdm0oSYPvRi8XwR1K/iiQO7z9RaFeJ
   N3xl52wYq4ZQ38ncYagG3hLFkzpBsEEEEEh/7qAD4LQEC/4Y9TCzBi6M3
   GpOm26fXQkU5um6lpryxIoVJGnEQzrlL5mFVvvtK68VQGX00WW8H4f50M
   tNarLoHJCbbqhUcANnuVwAVUJSlgMMGoe7rBM1UMRauzht+VZkG/V94RT
   zP7xya6QEKumkw2e090bg76woJST0/ZLay37Diol6/5nSVWDpTlI1AUE+
   hvG2ThD1vfQtFM6vGl6xeiUWrHGf/4wSPYZqZxIbNlot+CzMipQ7Ql17J
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="260704458"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="260704458"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 07:34:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="657521384"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga004.jf.intel.com with ESMTP; 04 Apr 2022 07:34:44 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH 0/8] crypto: qat - misc fixes
Date:   Mon,  4 Apr 2022 15:38:21 +0100
Message-Id: <20220404143829.147404-1-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set contains a collection of fixes for DH895XCC (the first two
patches) and PFVF (the rest of the set).

Patches one and two correct the lack of necessary flags to indicate the
presence of specific HW capabilities, which could result in VFs unable
to work correctly.

The third patch removes redundant PFVF code, while the fourth one
addresses a problem which caused lost PFVF messages due to unhandled
interrupts during bursts of PFVF messages from multiple VFs. This was
usually noticeable when restarting many VMs/VFs at the same time.

The remainder of the set is a refactoring resulting from the previous
fix, but to ease the review.

Giovanni Cabiddu (3):
  crypto: qat - set CIPHER capability for DH895XCC
  crypto: qat - set COMPRESSION capability for DH895XCC
  crypto: qat - remove unused PFVF stubs

Marco Chiappero (5):
  crypto: qat - rework the VF2PF interrupt handling logic
  crypto: qat - leverage the GEN2 VF mask definiton
  crypto: qat - replace disable_vf2pf_interrupts()
  crypto: qat - use u32 variables in all GEN4 pfvf_ops
  crypto: qat - remove line wrapping for pfvf_ops functions

 .../crypto/qat/qat_common/adf_accel_devices.h |   4 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  18 +--
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c |  78 ++++++++-----
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c |  55 ++++++---
 drivers/crypto/qat/qat_common/adf_isr.c       |  21 ++--
 drivers/crypto/qat/qat_common/adf_sriov.c     |   2 +-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 110 +++++++++++-------
 7 files changed, 168 insertions(+), 120 deletions(-)


base-commit: d6de7d2f20455c0239fbcc3e79e929ba068b6740
-- 
2.34.1

