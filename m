Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BC34C433FE
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345841AbiDGQxX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345849AbiDGQxN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:13 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF14382332
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350272; x=1680886272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=58saA/o1EdZ3a1m4vHbQDfSobGluPWIU6nJJlJKRTNQ=;
  b=H5uDo5M764MhFAvHKfSD7qWf7NqWNGF/A2r+x/B/z7tdS3wjOw882tv1
   AsUmAaHrigI3G+hq5ga8gpw6LeSc2IrRMlQfE3vYxUoROt6l/XUaT+l/i
   ST4+5gvarn8i8UfvjYlxY1isZqWTu2IYQ2fJY3FLq2FS2+yx/jtQRnOaB
   k7wB4WhHQL/WSVloNmgaD0vVpcLW8dB8vBFqogDSBukRzajtqfiaXOsdk
   N/N5YKHQkmJEvnlKWRYAPLfjAUGFOlTm1RwnHlDx88a5qD+7yKX3X9cXS
   TmznSaZKaIQM1ZMwi+6+UdgCrtNYC7WDEKOthmc3neLSDZK5KmnIN9r4j
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312047"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312047"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898351"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:11 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 06/16] crypto: qat - remove unnecessary tests to detect PFVF support
Date:   Thu,  7 Apr 2022 17:54:45 +0100
Message-Id: <20220407165455.256777-7-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Previously, the GEN4 host driver supported SR-IOV but had no working
implementation of the PFVF protocol to communicate with VF drivers.
Since all the host drivers for QAT devices now support both SR-IOV and
PFVF, remove the old and unnecessary checks to test PFVF support.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_sriov.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 81f484cbad3d..71d75f65b504 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -74,8 +74,7 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 		hw_data->configure_iov_threads(accel_dev, true);
 
 	/* Enable VF to PF interrupts for all VFs */
-	if (hw_data->pfvf_ops.get_pf2vf_offset)
-		adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
+	adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
 
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
@@ -104,14 +103,11 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	if (!accel_dev->pf.vf_info)
 		return;
 
-	if (hw_data->pfvf_ops.get_pf2vf_offset)
-		adf_pf2vf_notify_restarting(accel_dev);
-
+	adf_pf2vf_notify_restarting(accel_dev);
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Disable VF to PF interrupts */
-	if (hw_data->pfvf_ops.get_pf2vf_offset)
-		adf_disable_vf2pf_interrupts(accel_dev, GENMASK(31, 0));
+	adf_disable_vf2pf_interrupts(accel_dev, GENMASK(31, 0));
 
 	/* Clear Valid bits in AE Thread to PCIe Function Mapping */
 	if (hw_data->configure_iov_threads)
-- 
2.34.1

