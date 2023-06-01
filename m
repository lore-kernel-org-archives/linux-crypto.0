Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B847AC7EE2A
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 10:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjFAKLn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjFAKK7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 06:10:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845E510F4
        for <linux-crypto@vger.kernel.org>; Thu,  1 Jun 2023 03:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685614208; x=1717150208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7FIHFgZKhj1IkE7mppc5mZj6JFQvCI6imZ5p/+6FriI=;
  b=m91iqh6FJq5hnRs7BOyTX9w5OuBObj9Q8r0WfpUxYPYYIwuepSd+WhMO
   oWsfH1L7+QS0sCqwzoAW781QcQIfyrvqWdTyUi+SKEVlovZS3LUu10LeI
   ZE+G0Audf5ymeX5wWFmT+8eNrxEuJOxgpYRcBDeoZitqnS7kMkQpxPROZ
   dgbm0NA6QDL7J5yFcynjXhmQEjO0qG/7WoehHkk9mFvyXj9ggeNlvVYrm
   abe5+jpQudHvT8kSGNtFqJouFrLjzxaBuf5/+IPZrtFmQxiO8fpzl+EPD
   /9SXLQ/6SfmmXR5pdpkNJmnCtCal9BPJUlJy9Jsf925Jg5h4WhkNPi3nc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="358791277"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="358791277"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 03:10:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="1037435177"
X-IronPort-AV: E=Sophos;i="6.00,209,1681196400"; 
   d="scan'208";a="1037435177"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga005.fm.intel.com with ESMTP; 01 Jun 2023 03:10:06 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>,
        Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/2] crypto: qat - unmap buffer before free for DH
Date:   Thu,  1 Jun 2023 11:09:59 +0100
Message-Id: <20230601101000.18293-2-giovanni.cabiddu@intel.com>
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

The callback function for DH frees the memory allocated for the
destination buffer before unmapping it.
This sequence is wrong.

Change the cleanup sequence to unmap the buffer before freeing it.

Fixes: 029aa4624a7f ("crypto: qat - remove dma_free_coherent() for DH")
Signed-off-by: Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>
Co-developed-by: Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>
Signed-off-by: Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_common/qat_asym_algs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
index 935a7e012946..8806242469a0 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_asym_algs.c
@@ -170,15 +170,14 @@ static void qat_dh_cb(struct icp_qat_fw_pke_resp *resp)
 	}
 
 	areq->dst_len = req->ctx.dh->p_size;
+	dma_unmap_single(dev, req->out.dh.r, req->ctx.dh->p_size,
+			 DMA_FROM_DEVICE);
 	if (req->dst_align) {
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
 		kfree_sensitive(req->dst_align);
 	}
 
-	dma_unmap_single(dev, req->out.dh.r, req->ctx.dh->p_size,
-			 DMA_FROM_DEVICE);
-
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_dh_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
-- 
2.40.1

