Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12ADC43217
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Nov 2022 13:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbiKDNJm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Nov 2022 09:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbiKDNJh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Nov 2022 09:09:37 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A12CDDA
        for <linux-crypto@vger.kernel.org>; Fri,  4 Nov 2022 06:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667567377; x=1699103377;
  h=from:to:cc:subject:date:message-id;
  bh=5KGbNjip6CSoJ7dX3Dg8Rm3VZdIfQ5hkyDOD7r6NK2k=;
  b=lKPUOQNZ4AB1hUACjjVnoHMYbmrNMpjtEwEqZ7mj6vv7rkAtXyCesGTZ
   zuGIp3rzDilQdBRRMTgCmK2fLOKq+e4vTbGWlpcbFfo8cAewMfuty9UeI
   Dk7MhhqiZNQ3CuX8mAzjSS3rC1DwMwXze4F/ovyJTgvJZ318tokyBs+1G
   tLYSMhFtaU3+KpR7dJgJyomSM0alcmejozk/UC/AgioYi7LnC1Oq7EMiV
   0oR2A/z+ltOtIX/V0X3B9iwc80SIglBjMz6OIKmmVeAE574o7M+YfKinC
   +AJsXD0SAXXaadsrJ20zrysxFDbKkk78zZ+QTgQq5Y307JAAut0DDcuF6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="311702477"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="311702477"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 06:09:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="760323132"
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="760323132"
Received: from linux-gr8q.igk.intel.com ([10.102.16.18])
  by orsmga004.jf.intel.com with ESMTP; 04 Nov 2022 06:07:55 -0700
From:   Shashank Gupta <shashank.gupta@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Shashank Gupta <shashank.gupta@intel.com>
Subject: [PATCH] crypto: qat - remove ADF_STATUS_PF_RUNNING flag from probe
Date:   Fri,  4 Nov 2022 13:21:07 -0400
Message-Id: <20221104172107.27599-1-shashank.gupta@intel.com>
X-Mailer: git-send-email 2.16.4
Organization: Intel Technology Poland sp. z o.o. - ul. Slowackiego 173, 80-298 Gdansk - KRS 101882 - NIP 957-07-52-316
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ADF_STATUS_PF_RUNNING bit is set after the successful initialization
of the communication between VF to PF in adf_vf2pf_notify_init().
So, it is not required to be set after the execution of the function
adf_dev_init().

Signed-off-by: Shashank Gupta <shashank.gupta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 2 --
 drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 2 --
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
index fa18d8009f53..cf4ef83e186f 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
@@ -177,8 +177,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_dev_shutdown;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
index 686ec752d0e9..0e642c94b929 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
@@ -177,8 +177,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_dev_shutdown;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
index 18756b2e1c91..c1485e702b3e 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
@@ -177,8 +177,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		goto out_err_dev_shutdown;
 
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-
 	ret = adf_dev_start(accel_dev);
 	if (ret)
 		goto out_err_dev_stop;
-- 
2.16.4

