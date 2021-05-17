Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD74BC43461
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F6E6121F
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbhEQIRK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 04:17:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:28960 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235586AbhEQIRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 04:17:08 -0400
IronPort-SDR: HCTp1SW+HDj/SRTGV0xq7Cq2p9YUyi6TXf5kfeHwF/kEHbS6CR/9EvH5sZ6lkRADtIbTRpH7rs
 7cAe79dIyoHQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="285940865"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="285940865"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:15:52 -0700
IronPort-SDR: QXA/6GKv5SloB2RionPCFt/4TaudVuzATRcKTPiQlUzZJtL5Y69OLmSLOmp0O49h604eXpxvFh
 AIkg127gl42g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="410729292"
Received: from qat-server-296.sh.intel.com ([10.67.117.159])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2021 01:15:50 -0700
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/5] crypto: qat - report an error if MMP file size is too large
Date:   Mon, 17 May 2021 05:13:14 -0400
Message-Id: <20210517091316.69630-4-jack.xu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517091316.69630-1-jack.xu@intel.com>
References: <20210517091316.69630-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Change the return status to error if MMP file size is too large so the
driver load fails early if a large MMP firmware is loaded.

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Zhehui Xiang <zhehui.xiang@intel.com>
Signed-off-by: Zhehui Xiang <zhehui.xiang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 8adf25769128..ed1343bb36ac 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1552,10 +1552,8 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 		qat_uclo_ummap_auth_fw(handle, &desc);
 	} else {
 		if (handle->chip_info->mmp_sram_size < mem_size) {
-			dev_dbg(&handle->pci_dev->dev,
-				"QAT MMP fw not loaded for device 0x%x",
-				handle->pci_dev->device);
-			return status;
+			pr_err("QAT: MMP size is too large: 0x%x\n", mem_size);
+			return -EFBIG;
 		}
 		qat_uclo_wr_sram_by_words(handle, 0, addr_ptr, mem_size);
 	}
-- 
2.31.1

