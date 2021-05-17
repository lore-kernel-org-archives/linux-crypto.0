Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E8CC433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446B461248
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 08:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhEQIRJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 04:17:09 -0400
Received: from mga05.intel.com ([192.55.52.43]:28988 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235431AbhEQIRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 04:17:08 -0400
IronPort-SDR: po64+1vWc5nC1qU3q2Gt7L2Ex8Or/szHcrZ5O1uPNJJoLNWqOqB5XwNh+9R8QabEcvURIsRS69
 59gaJASN8ClA==
X-IronPort-AV: E=McAfee;i="6200,9189,9986"; a="285940859"
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="285940859"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2021 01:15:48 -0700
IronPort-SDR: sZseReBHY2ex9TzpV05vpEnGxV3r1ZKyakAPc22u4L+7AlMBwTXOi5FgvaMDCzOxYYgB0OSzS/
 tyKSy4fVLQQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,306,1613462400"; 
   d="scan'208";a="410729268"
Received: from qat-server-296.sh.intel.com ([10.67.117.159])
  by orsmga002.jf.intel.com with ESMTP; 17 May 2021 01:15:46 -0700
From:   Jack Xu <jack.xu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Jack Xu <jack.xu@intel.com>,
        Zhehui Xiang <zhehui.xiang@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/5] crypto: qat - return error when failing to map FW
Date:   Mon, 17 May 2021 05:13:12 -0400
Message-Id: <20210517091316.69630-2-jack.xu@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517091316.69630-1-jack.xu@intel.com>
References: <20210517091316.69630-1-jack.xu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Save the return value of qat_uclo_map_auth_fw() function so that the
function qat_uclo_wr_mimage() could return the correct value.
This way, the procedure of adf_gen2_ae_fw_load() function could stop
and exit properly by checking the return value of qat_uclo_wr_mimage().

Signed-off-by: Jack Xu <jack.xu@intel.com>
Co-developed-by: Zhehui Xiang <zhehui.xiang@intel.com>
Signed-off-by: Zhehui Xiang <zhehui.xiang@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_uclo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
index 1fb5fc852f6b..d2c2db58c93f 100644
--- a/drivers/crypto/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -1546,7 +1546,8 @@ int qat_uclo_wr_mimage(struct icp_qat_fw_loader_handle *handle,
 	int status = 0;
 
 	if (handle->chip_info->fw_auth) {
-		if (!qat_uclo_map_auth_fw(handle, addr_ptr, mem_size, &desc))
+		status = qat_uclo_map_auth_fw(handle, addr_ptr, mem_size, &desc);
+		if (!status)
 			status = qat_uclo_auth_fw(handle, desc);
 		qat_uclo_ummap_auth_fw(handle, &desc);
 	} else {
-- 
2.31.1

