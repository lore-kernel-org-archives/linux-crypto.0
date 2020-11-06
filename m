Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22E7C5517A
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86305206C1
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgKFL3E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:04 -0500
Received: from mga07.intel.com ([134.134.136.100]:59373 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgKFL3D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:03 -0500
IronPort-SDR: jahPWWvVZNHad18AUSyML31BpfW8v6h0Bm2J9erzaTX4vJoRQLx57YLTbv87xL+udS4Y/EGira
 pH3uIUhkTKnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698317"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698317"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:02 -0800
IronPort-SDR: xMbbwEHTmzr59baTbRelc5sezgirnescOw9ZPLSoM8v3ftGmwWvSXDHLYQdy4Mgjkz0kSBsF0/
 J756Ks3AJUAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779302"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:01 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 17/32] crypto: qat - loader: replace check based on DID
Date:   Fri,  6 Nov 2020 19:27:55 +0800
Message-Id: <20201106112810.2566-18-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Modify condition in qat_uclo_wr_mimage() to use a capability of the
device (sram_visible), rather than the device ID, so the check is not
specific to devices of the same type.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 1533981baf3a..5774916497bd 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1410,9 +1410,11 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 			status = qat_uclo_auth_fw(handle, desc);
 		qat_uclo_ummap_auth_fw(handle, &desc);
 	} else {
-		if (handle->pci_dev->device == PCI_DEVICE_ID_INTEL_QAT_C3XXX) {
-			pr_err("QAT: C3XXX doesn't support unsigned MMP\n");
-			return -EINVAL;
+		if (!handle->chip_info->sram_visible) {
+			dev_dbg(&handle->pci_dev->dev,
+				"QAT MMP fw not loaded for device 0x%x",
+				handle->pci_dev->device);
+			return status;
 		}
 		qat_uclo_wr_sram_by_words(handle, 0, addr_ptr, mem_size);
 	}
-- 
2.25.4

