Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652BCC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 309E220FC3
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 20:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387830AbgJLUjt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Oct 2020 16:39:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:34024 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387832AbgJLUjs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Oct 2020 16:39:48 -0400
IronPort-SDR: ZoNgFawHvz1k5nUXQDj3d7lXTICwG18PUJ0niECKfHZoY5cg5Z5PfeMCDXlH5K5zL8wph9SZgF
 3CdIaXwXOpyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="165913177"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="165913177"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 13:39:47 -0700
IronPort-SDR: Gqc2kek6egE+CeJwe2giYf9sWg+J27VKniKjYqjba9lvjQsKMmtBZH4jzpBvA7qW2UKdBkSz8E
 ul8lyFnK6pJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="299328256"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga007.fm.intel.com with ESMTP; 12 Oct 2020 13:39:45 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 24/31] crypto: qat - call functions in adf_sriov if available
Date:   Mon, 12 Oct 2020 21:38:40 +0100
Message-Id: <20201012203847.340030-25-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
References: <20201012203847.340030-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Call the function configure_iov_threads(), adf_enable_vf2pf_interrupts()
and adf_pf2vf_notify_restarting() only if present in the struct
adf_hw_device_data of the device.
This is to allow for QAT drivers that do not implement those functions.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/qat/qat_common/adf_sriov.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 9a0f6db83106..d887640355d4 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -62,10 +62,12 @@ static int adf_enable_sriov(struct adf_accel_dev *accel_dev)
 	}
 
 	/* Set Valid bits in AE Thread to PCIe Function Mapping */
-	hw_data->configure_iov_threads(accel_dev, true);
+	if (hw_data->configure_iov_threads)
+		hw_data->configure_iov_threads(accel_dev, true);
 
 	/* Enable VF to PF interrupts for all VFs */
-	adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
+	if (hw_data->get_pf2vf_offset)
+		adf_enable_vf2pf_interrupts(accel_dev, BIT_ULL(totalvfs) - 1);
 
 	/*
 	 * Due to the hardware design, when SR-IOV and the ring arbiter
@@ -94,15 +96,18 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	if (!accel_dev->pf.vf_info)
 		return;
 
-	adf_pf2vf_notify_restarting(accel_dev);
+	if (hw_data->get_pf2vf_offset)
+		adf_pf2vf_notify_restarting(accel_dev);
 
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Disable VF to PF interrupts */
-	adf_disable_vf2pf_interrupts(accel_dev, GENMASK(31, 0));
+	if (hw_data->get_pf2vf_offset)
+		adf_disable_vf2pf_interrupts(accel_dev, GENMASK(31, 0));
 
 	/* Clear Valid bits in AE Thread to PCIe Function Mapping */
-	hw_data->configure_iov_threads(accel_dev, false);
+	if (hw_data->configure_iov_threads)
+		hw_data->configure_iov_threads(accel_dev, false);
 
 	for (i = 0, vf = accel_dev->pf.vf_info; i < totalvfs; i++, vf++) {
 		tasklet_disable(&vf->vf2pf_bh_tasklet);
-- 
2.26.2

