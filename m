Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA6B6C47089
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36FE613DC
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 19:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbhE0TPM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 15:15:12 -0400
Received: from mga06.intel.com ([134.134.136.31]:7517 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234233AbhE0TPK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 15:15:10 -0400
IronPort-SDR: 428cgcBRgiDYxl95VxLGGSHZzifVsdXd39YUrd8ndYFLvw3um8qMD/TwDN8z8B5NkRrC/Lmf2R
 pW200t4H9wNA==
X-IronPort-AV: E=McAfee;i="6200,9189,9997"; a="264012481"
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="264012481"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2021 12:13:36 -0700
IronPort-SDR: AStsKQxDE+V9LO3sI227vyeHoHn+DK0VPIG6Y6K3HuNibeaevJsMx5fkJh7ZKZW40cbutbCRuc
 hfnnVue+Nr+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,228,1616482800"; 
   d="scan'208";a="480717815"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 27 May 2021 12:13:35 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 10/10] crypto: qat - fix reuse of completion variable
Date:   Thu, 27 May 2021 20:12:51 +0100
Message-Id: <20210527191251.6317-11-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210527191251.6317-1-marco.chiappero@intel.com>
References: <20210527191251.6317-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use reinit_completion() to set to a clean state a completion variable,
used to coordinate the VF to PF request-response flow, before every
new VF request.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index e29f5f1dc806..d42461cb611f 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -316,6 +316,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPAT_THIS_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPAT_THIS_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
-- 
2.26.2

