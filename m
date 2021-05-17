Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD86C433ED
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE82D60C3D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhEQIRJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 04:17:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:28960 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232431AbhEQIRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 04:17:08 -0400
IronPort-SDR: yhkNk8jeJDeOltUx/oYZ39MT0f6sPrq5X8eQHOP27fbkEgskspzL9uuAGMjLd/Po+S0/Iga7sy
 jhSKLpyH/rMQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="285940855"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="285940855"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:15:46 -0700
IronPort-SDR: 0UXwi1eT8c1tjUG5J1Z1ejVpMfuBiWWRYwOVJGAacFb2TuNLAsm4VImoFtPvcoKtkP6iEKx5Iq
 sB09aC486bZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="410729258"
Received: from qat-server-296.sh.intel.com ([10.67.117.159])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2021 01:15:45 -0700
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>
Subject: [PATCH 0/5] crypto: qat - fix firmware loader
Date:   Mon, 17 May 2021 05:13:11 -0400
Message-Id: <20210517091316.69630-1-jack.xu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchset is to fix some issues in the QAT firmware loader:
* Patches #1 to #3, check the MMP binary size and return error if too large
* Patch #4 fixes a problem detected by clang static
* Patch #5 fixes a compiling warnings when building with clang


Jack Xu (5):
  crypto: qat - return error when failing to map FW
  crypto: qat - check MMP size before writing to the SRAM
  crypto: qat - report an error if MMP file size is too large
  crypto: qat - check return code of qat_hal_rd_rel_reg()
  crypto: qat - remove unused macro in FW loader

 .../qat/qat_common/icp_qat_fw_loader_handle.h      |  2 +-
 drivers/crypto/qat/qat_common/qat_hal.c            | 14 +++++++++-----
 drivers/crypto/qat/qat_common/qat_uclo.c           | 12 +++++-------
 3 files changed, 15 insertions(+), 13 deletions(-)

-- 
2.31.1

