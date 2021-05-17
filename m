Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B48C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059FB611EE
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:16:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbhEQIR2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 04:17:28 -0400
Received: from mga05.intel.com ([192.55.52.43]:28960 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235599AbhEQIRL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 04:17:11 -0400
IronPort-SDR: 98kv+UMpapn4qREoNlaEIg3UfSXuRysBY1SFtpsAE5L+ZHVQQlzFXBNNLmhDik6ERZ5Ma5VcGk
 wJwI6mdo4NMA==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="285940872"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="285940872"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:15:55 -0700
IronPort-SDR: cHFRWiGZVNnnqyzalUR2Xtoe8JZZdd7b1aNPe+AYhegi5+V6BhlHaQr+U2pvQvFHvo4/vyZo/4
 VHehoqUYqG0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="410729309"
Received: from qat-server-296.sh.intel.com ([10.67.117.159])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2021 01:15:54 -0700
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 5/5] crypto: qat - remove unused macro in FW loader
Date:   Mon, 17 May 2021 05:13:16 -0400
Message-Id: <20210517091316.69630-6-jack.xu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517091316.69630-1-jack.xu@intel.com>
References: <20210517091316.69630-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove the unused macro ICP_DH895XCC_PESRAM_BAR_SIZE in the firmware
loader.

This is to fix the following warning when compiling the driver using the
clang compiler with CC=clang W=2:

    drivers/crypto/qat/qat_common/qat_uclo.c:345:9: warning: macro is not used [-Wunused-macros]

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Zhehui Xiang <zhehui.xiang@intel.com>
Signed-off-by: Zhehui Xiang <zhehui.xiang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index ed1343bb36ac..2026cc6be8f0 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -342,7 +342,6 @@ static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
 	return 0;
 }
 
-#define ICP_DH895XCC_PESRAM_BAR_SIZE 0x80000
 static int qat_uclo_init_ae_memory(struct icp_qat_fw_loader_handle *handle,
 				   struct icp_qat_uof_initmem *init_mem)
 {
-- 
2.31.1

