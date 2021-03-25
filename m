Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8156C433C1
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Mar 2021 08:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB69B61A23
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Mar 2021 08:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYIec (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Mar 2021 04:34:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:14194 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhCYIe1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Mar 2021 04:34:27 -0400
IronPort-SDR: NhmSZ/rpfmsjlaG7Ybl0zgXV2fIMLHhSWyOr3EFSpHEe85okrC7hssojcw+fa2fvx25W3xWBW8
 l2u5Uxcq5Adw==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="170861340"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="170861340"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 01:34:26 -0700
IronPort-SDR: +AtR+efb7w5frcaq4thFalw5Tgbb5cQu6cNrmBMrw4TvpU3xAWhwNfKAkn8i8juW/toCa7hIJ+
 GpXbh0YsndMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="608425586"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2021 01:34:25 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH] crypto: qat - fix error path in adf_isr_resource_alloc()
Date:   Thu, 25 Mar 2021 08:34:18 +0000
Message-Id: <20210325083418.153771-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function adf_isr_resource_alloc() is not unwinding correctly in case
of error.
This patch fixes the error paths and propagate the errors to the caller.

Fixes: 7afa232e76ce ("crypto: qat - Intel(R) QAT DH895xcc accelerator")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
---
 drivers/crypto/qat/qat_common/adf_isr.c | 29 ++++++++++++++++++-------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index c45853463530..e3ad5587be49 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -291,19 +291,32 @@ int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 
 	ret = adf_isr_alloc_msix_entry_table(accel_dev);
 	if (ret)
-		return ret;
-	if (adf_enable_msix(accel_dev))
 		goto err_out;
 
-	if (adf_setup_bh(accel_dev))
-		goto err_out;
+	ret = adf_enable_msix(accel_dev);
+	if (ret)
+		goto err_free_msix_table;
 
-	if (adf_request_irqs(accel_dev))
-		goto err_out;
+	ret = adf_setup_bh(accel_dev);
+	if (ret)
+		goto err_disable_msix;
+
+	ret = adf_request_irqs(accel_dev);
+	if (ret)
+		goto err_cleanup_bh;
 
 	return 0;
+
+err_cleanup_bh:
+	adf_cleanup_bh(accel_dev);
+
+err_disable_msix:
+	adf_disable_msix(&accel_dev->accel_pci_dev);
+
+err_free_msix_table:
+	adf_isr_free_msix_entry_table(accel_dev);
+
 err_out:
-	adf_isr_resource_free(accel_dev);
-	return -EFAULT;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(adf_isr_resource_alloc);
-- 
2.30.2

