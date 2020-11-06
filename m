Return-Path: <SRS0=5ZxX=EM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68E5C55178
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6545C208FE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Nov 2020 11:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbgKFL3Q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Nov 2020 06:29:16 -0500
Received: from mga07.intel.com ([134.134.136.100]:59432 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgKFL3Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Nov 2020 06:29:16 -0500
IronPort-SDR: TQIuDCd5jh2NESTkrz+g2ruxWyJB6SvaxLjYY2Hb8txqy9yQYSwfECNPyGX/WNxF4+u83/ZByR
 KfVMWki5duyQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="233698338"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="233698338"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 03:29:16 -0800
IronPort-SDR: JvslKniYlm/ugDDU1R9M6BqcUkanIqvI00BlhH1X87vs2PsneNks0uZUmqTIqSL41I/T28gABl
 rnW2bRb8/x8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="529779360"
Received: from haps801-neoncity02.sh.intel.com ([10.67.114.160])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2020 03:29:14 -0800
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: [PATCH 25/32] crypto: qat - loader: add check for null pointer
Date:   Fri,  6 Nov 2020 19:28:03 +0800
Message-Id: <20201106112810.2566-26-jack.xu@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201106112810.2566-1-jack.xu@intel.com>
References: <20201106112810.2566-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add null pointer check when freeing the memory for firmware.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 28 ++++++++++++++----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 32c64a48926f..7b02c4e165c6 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1233,11 +1233,15 @@ static int qat_uclo_simg_alloc(struct icp_qat_fw_loader_handle *handle,
 static void qat_uclo_simg_free(struct icp_qat_fw_loader_handle *handle,
 			       struct icp_firml_dram_desc *dram_desc)
 {
-	dma_free_coherent(&handle->pci_dev->dev,
-			  (size_t)(dram_desc->dram_size),
-			  dram_desc->dram_base_addr_v,
-			  dram_desc->dram_bus_addr);
-	memset(dram_desc, 0, sizeof(*dram_desc));
+	if (handle && dram_desc && dram_desc->dram_base_addr_v) {
+		dma_free_coherent(&handle->pci_dev->dev,
+				  (size_t)(dram_desc->dram_size),
+				  dram_desc->dram_base_addr_v,
+				  dram_desc->dram_bus_addr);
+	}
+
+	if (dram_desc)
+		memset(dram_desc, 0, sizeof(*dram_desc));
 }
 
 static void qat_uclo_ummap_auth_fw(struct icp_qat_fw_loader_handle *handle,
@@ -1245,12 +1249,14 @@ static void qat_uclo_ummap_auth_fw(struct icp_qat_fw_loader_handle *handle,
 {
 	struct icp_firml_dram_desc dram_desc;
 
-	dram_desc.dram_base_addr_v = *desc;
-	dram_desc.dram_bus_addr = ((struct icp_qat_auth_chunk *)
-				   (*desc))->chunk_bus_addr;
-	dram_desc.dram_size = ((struct icp_qat_auth_chunk *)
-			       (*desc))->chunk_size;
-	qat_uclo_simg_free(handle, &dram_desc);
+	if (*desc) {
+		dram_desc.dram_base_addr_v = *desc;
+		dram_desc.dram_bus_addr = ((struct icp_qat_auth_chunk *)
+					   (*desc))->chunk_bus_addr;
+		dram_desc.dram_size = ((struct icp_qat_auth_chunk *)
+				       (*desc))->chunk_size;
+		qat_uclo_simg_free(handle, &dram_desc);
+	}
 }
 
 static int qat_uclo_map_auth_fw(struct icp_qat_fw_loader_handle *handle,
-- 
2.25.4

