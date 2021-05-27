Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCB1C4708B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC3EE6135F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhE0TPA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 15:15:00 -0400
Received: from mga06.intel.com ([134.134.136.31]:7489 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234663AbhE0TPA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 15:15:00 -0400
IronPort-SDR: mztzM/nHksrQ3PkPy3mrCRktqxxu2ftt9a3VRPoqM2becVjj7rWDk5UcvgghHX4yHQWKj1z87R
 lzMmEbyBnw8Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="264012434"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="264012434"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 12:13:27 -0700
IronPort-SDR: FhXT7Tq9vDsG1Ve/5/JOJWN6emh9lbUR7fWNIOWujwk8xuXxZTRtyHeaErZkTLMbTfQgbvlTrq
 NPh4KmMIpKxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480717749"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 12:13:25 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 03/10] crypto: qat - enable interrupts only after ISR allocation
Date:   Thu, 27 May 2021 20:12:44 +0100
Message-Id: <20210527191251.6317-4-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210527191251.6317-1-marco.chiappero@intel.com>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Enable device interrupts after the setup of the interrupt handlers.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 744c40351428..14e9f3b22c60 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -88,8 +88,6 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
-	hw_data->enable_ints(accel_dev);
-
 	if (adf_ae_init(accel_dev)) {
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to initialise Acceleration Engine\n");
@@ -110,6 +108,8 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	}
 	set_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
 
+	hw_data->enable_ints(accel_dev);
+
 	/*
 	 * Subservice initialisation is divided into two stages: init and start.
 	 * This is to facilitate any ordering dependencies between services
-- 
2.26.2

