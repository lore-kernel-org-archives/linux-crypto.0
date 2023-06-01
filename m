Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8C3C77B7E
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 10:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjFAKMS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbjFAKLM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 06:11:12 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B93A10FF
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 03:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685614210; x=1717150210;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=doZIg1eYy80ZoloO/1MxKEKosOxwnwuL9eiwma8GATk=;
  b=MwZK25MP1aXxRZ1CgRPZDaPu+CI2MTROdWh6oNtaOm0bxbfKeskbQUoc
   npyIewifZc7FNri6awf8XflXDgb00KusChrFJay8HLaDKXFWi7hI7XC+v
   lPlCmqB2bdevy6dmGsABNZhuJ7l4JwLDXqnx3ySovkbzuxypl0txnuy2c
   YI5EmVuXPTp0Sy/sLgQd++oNb78aq1CAwDWlxnVUwc1PB6XAKpQsqY3PP
   bkEnCb2tscYA4EEH5ccALHN78kIenYy1c1hVk4f2wvhJtFPpEBUu18N6P
   7bTeKdmaJjFWfZydqBKxdEaf+Pk1C7YSbmDr/SSNg+CmetQWRM9Rub2vJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="358791279"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="358791279"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 03:10:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="1037435186"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="1037435186"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jun 2023 03:10:08 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>,
        Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/2] crypto: qat - unmap buffers before free for RSA
Date:   Thu,  1 Jun 2023 11:10:00 +0100
Message-Id: <20230601101000.18293-3-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601101000.18293-1-giovanni.cabiddu@intel.com>
References: <20230601101000.18293-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>

The callback function for RSA frees the memory allocated for the source
and destination buffers before unmapping them.
This sequence is wrong.

Change the cleanup sequence to unmap the buffers before freeing them.

Fixes: 3dfaf0071ed7 ("crypto: qat - remove dma_free_coherent() for RSA")
Signed-off-by: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
Co-developed-by: Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>
Signed-off-by: Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 8806242469a0..4128200a9032 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -520,12 +520,14 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
-	kfree_sensitive(req->src_align);
-
 	dma_unmap_single(dev, req->in.rsa.enc.m, req->ctx.rsa->key_sz,
 			 DMA_TO_DEVICE);
 
+	kfree_sensitive(req->src_align);
+
 	areq->dst_len = req->ctx.rsa->key_sz;
+	dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
+			 DMA_FROM_DEVICE);
 	if (req->dst_align) {
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
@@ -533,9 +535,6 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 		kfree_sensitive(req->dst_align);
 	}
 
-	dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
-			 DMA_FROM_DEVICE);
-
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_rsa_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
-- 
2.40.1

