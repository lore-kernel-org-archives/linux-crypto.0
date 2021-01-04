Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F39FC433DB
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C09D224F4
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbhADRXN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:23:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:43986 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbhADRXN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 12:23:13 -0500
IronPort-SDR: NQP54f73LBMCkErWOocRIfM5RmqRFQQv6/wTRPGJ7WvxKLW3NlqItPmBk8vXlD/kZMkRp8C3JR
 lTG+f+LV+Fdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177135640"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="177135640"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 09:22:08 -0800
IronPort-SDR: YN6Bai7b6J95oRWa0lzhQV7VN62yCDR45jJSiRVjoZUdb1EQ8qeQHcMNnUO++7/sPdB4JdjWUL
 db1xs0Zs0w6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="345962829"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by orsmga003.jf.intel.com with ESMTP; 04 Jan 2021 09:22:06 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Adam Guerin <adam.guerin@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/3] crypto: qat - reduce size of mapped region
Date:   Mon,  4 Jan 2021 17:21:59 +0000
Message-Id: <20210104172159.15489-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
References: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Adam Guerin <adam.guerin@intel.com>

Restrict size of field to what is required by the operation.

This issue was detected by smatch:

    drivers/crypto/qat/qat_common/qat_asym_algs.c:328 qat_dh_compute_value() error: dma_map_single_attrs() '&qat_req->in.dh.in.b' too small (8 vs 64)

Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 2c863d25327a..b0b78445418b 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -321,13 +321,13 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	qat_req->out.dh.out_tab[1] = 0;
 	/* Mapping in.in.b or in.in_g2.xa is the same */
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dh.in.b,
-					 sizeof(struct qat_dh_input_params),
+					 sizeof(qat_req->in.dh.in.b),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dh.r,
-					  sizeof(struct qat_dh_output_params),
+					  sizeof(qat_req->out.dh.r),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
@@ -716,13 +716,13 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
-					 sizeof(struct qat_rsa_input_params),
+					 sizeof(qat_req->in.rsa.enc.m),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.enc.c,
-					  sizeof(struct qat_rsa_output_params),
+					  sizeof(qat_req->out.rsa.enc.c),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
@@ -864,13 +864,13 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.dec.c,
-					 sizeof(struct qat_rsa_input_params),
+					 sizeof(qat_req->in.rsa.dec.c),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.dec.m,
-					  sizeof(struct qat_rsa_output_params),
+					  sizeof(qat_req->out.rsa.dec.m),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
-- 
2.29.2

