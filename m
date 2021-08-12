Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB5BC4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B38A460560
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 08:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbhHLISq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 04:18:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:59623 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234086AbhHLISq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 04:18:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="215036119"
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="215036119"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 01:18:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,315,1620716400"; 
   d="scan'208";a="517348170"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Aug 2021 01:18:19 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        qat-linux@intel.com, u.kleine-koenig@pengutronix.de,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 0/4] crypto: qat - fixes and cleanups
Date:   Thu, 12 Aug 2021 09:18:12 +0100
Message-Id: <20210812081816.275405-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a rework of a set from Christophe JAILLET that implements a few
fixes and clean-ups in the QAT drivers with the addition of a related
patch.

This set removes the deprecated APIs pci_set_dma_mask() and
pci_set_consistent_dma_mask(), changes the DMA mask for QAT Gen2
devices, disables AER if an error occurs in the probe functions and
fixes a typo in the description of adf_disable_aer()

Changes from v1:
- Reworked patch #1 removing `else` related to 32 bits
- Reworked patch #1 to remove shadow return code
- Added patch to set DMA mask to 48 bits for QAT Gen2 devices

Christophe JAILLET (3):
  crypto: qat - simplify code and axe the use of a deprecated API
  crypto: qat - disable AER if an error occurs in probe functions
  crypto: qat - fix a typo in a comment

Giovanni Cabiddu (1):
  crypto: qat - set DMA mask to 48 bits for Gen2

 drivers/crypto/qat/qat_4xxx/adf_drv.c       | 14 ++++----------
 drivers/crypto/qat/qat_c3xxx/adf_drv.c      | 21 ++++++++-------------
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 15 ++++-----------
 drivers/crypto/qat/qat_c62x/adf_drv.c       | 21 ++++++++-------------
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 15 ++++-----------
 drivers/crypto/qat/qat_common/adf_aer.c     |  2 +-
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c   | 21 ++++++++-------------
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 15 ++++-----------
 8 files changed, 41 insertions(+), 83 deletions(-)

-- 
2.31.1

