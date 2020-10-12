Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05138C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D238E20FC3
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730531AbgJLUjX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:33953 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgJLUjW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:22 -0400
IronPort-SDR: teJyB9BoabldI6rHLpEPIiQLo2NoSrE7pPqm/Fj4TrJ7mzoDKN+NMjijSd8JbaSP5RzWu519mA
 08IICZzuia5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913103"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913103"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:21 -0700
IronPort-SDR: WQDuRONGVPFGnwb3WORjLM8EIqbEg93TJvES/ros78480lh28dbMvxl7eRJ2JpFcZ0RlD65pAf
 61/+GHIPoLJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328168"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:20 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 10/31] crypto: qat - change admin sequence
Date:   Mon, 12 Oct 2020 21:38:26 +0100
Message-Id: <20201012203847.340030-11-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Call adf_set_fw_constants() before adf_init_ae().

This is required by QAT GEN4 devices, which expect that the
FW_CONSTANTS_CFG command is sent to the admin AEs before the FW_INIT_AE
command.

Swapping the order of the two commands (FW_INIT_AE and FW_CONSTANTS_CFG)
is allowed in QAT GEN2 devices as the firmware can handle those in any
order.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index 13a5e8659682..6d94746d266f 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -206,11 +206,11 @@ int adf_send_admin_init(struct adf_accel_dev *accel_dev)
 {
 	int ret;
 
-	ret = adf_init_ae(accel_dev);
+	ret = adf_set_fw_constants(accel_dev);
 	if (ret)
 		return ret;
 
-	return adf_set_fw_constants(accel_dev);
+	return adf_init_ae(accel_dev);
 }
 EXPORT_SYMBOL_GPL(adf_send_admin_init);
 
-- 
2.26.2

