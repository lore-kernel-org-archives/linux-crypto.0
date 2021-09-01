Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6831BC432BE
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48FC161027
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345760AbhIARvN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Sep 2021 13:51:13 -0400
Received: from mga06.intel.com ([134.134.136.31]:24802 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347065AbhIARuT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Sep 2021 13:50:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="279832870"
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="279832870"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 10:49:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="499021970"
Received: from silpixa00400294.ir.intel.com ([10.237.222.100])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2021 10:49:19 -0700
From:   Wojciech Ziemba <wojciech.ziemba@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 0/4] crypto: qat - replace deprecated MSI API
Date:   Wed,  1 Sep 2021 18:36:04 +0100
Message-Id: <20210901173608.16777-1-wojciech.ziemba@intel.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This set of patches replaces deprecated MSI API.
It also fixes handling of freeing IRQs in case of failure of probing of
modules by tracking which IRQs were allocated.

Maksim Lukoshkov (1):
  crypto: qat - free irqs only if allocated

Wojciech Ziemba (3):
  crypto: qat - replace deprecated MSI API
  crypto: qat - remove unmatched CPU affinity to cluster IRQ
  crypto: qat - free irq in case of failure

 .../crypto/qat/qat_common/adf_accel_devices.h |  11 +-
 drivers/crypto/qat/qat_common/adf_isr.c       | 170 +++++++++---------
 drivers/crypto/qat/qat_common/adf_vf_isr.c    |  24 ++-
 3 files changed, 101 insertions(+), 104 deletions(-)

-- 
2.29.2

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

