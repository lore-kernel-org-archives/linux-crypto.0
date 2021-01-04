Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E9FC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FDFD224F4
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbhADRW5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:22:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:43986 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbhADRW5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 12:22:57 -0500
IronPort-SDR: JalIRO9FI+5WdJHrd8dh/fCYEaXmqPMzHr6Orz5/qCJfrJT79agk2UFTTdT7W7eDfYqWCQRuJs
 ipwMLHf3puQA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177135628"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="177135628"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 09:22:05 -0800
IronPort-SDR: 0kjoMjHkpm+s4RNdyqJHDmHphSB3S8Jf360ViQukJ3k0lDCRr8ksI7vAWKEWmFvLHYu8wDoLTC
 5gQM52ENJAAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="345962818"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2021 09:22:04 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/3] crypto: qat - fix potential spectre issue
Date:   Mon,  4 Jan 2021 17:21:57 +0000
Message-Id: <20210104172159.15489-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
References: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Adam Guerin <adam.guerin@intel.com>

Sanitize ring_num value coming from configuration (and potentially
from user space) before it is used as index in the banks array.

This issue was detected by smatch:

    drivers/crypto/qat/qat_common/adf_transport.c:233 adf_create_ring() warn: potential spectre issue 'bank->rings' [r] (local cap)

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 5a7030acdc33..888c1e047295 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/delay.h>
+#include <linux/nospec.h>
 #include "adf_accel_devices.h"
 #include "adf_transport_internal.h"
 #include "adf_transport_access_macros.h"
@@ -246,6 +247,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		return -EFAULT;
 	}
 
+	ring_num = array_index_nospec(ring_num, num_rings_per_bank);
 	bank = &transport_data->banks[bank_num];
 	if (adf_reserve_ring(bank, ring_num)) {
 		dev_err(&GET_DEV(accel_dev), "Ring %d, %s already exists.\n",
-- 
2.29.2

