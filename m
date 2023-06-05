Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B84C7EE24
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Jun 2023 21:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbjFEVGR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Jun 2023 17:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjFEVGQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Jun 2023 17:06:16 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1A8F2
        for <linux-crypto@vger.kernel.org>; Mon,  5 Jun 2023 14:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685999175; x=1717535175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IFmmJDSy3/38+20H3hgKK+gwXE4R2MaCQitjtlOY65I=;
  b=NPDj/xkUBkp5mL/+Qp2YcAtMeyB+Lm88ALmuH7Vq8J72mJzurch8vQyx
   WaUm1OhZ/Omf1dXfaRHBzlgORJArrlgGaBmWRuZxDY7IAtFmKB2YZ3A/u
   oqr8YP7RUNZq0o6wRC2H92YwVl42THu4PlH/r+1alPjy+e7xq3fg9pWPG
   d0/j9q1yTC+ugaQ6D1Ti4jKyTzP1y5YaEOrdHYXGpq8FKWIHwCTwm1k6D
   XqIpTh2S1xY9eaIyuZ+iUuXfZREfqh/or+fRnHThOa2GO+eCaVyaPfDJs
   FhX7rTo+fbt6PDDwa94iqrD1X27sO8ZEW/dKsBqSbuow7Rlrk6nrggQW2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422309619"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="422309619"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 14:06:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="778710826"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="778710826"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jun 2023 14:06:13 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Hareshx Sankar Raj <hareshx.sankar.raj@intel.com>,
        Bolemx Sivanagaleela <bolemx.sivanagaleela@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RESEND 1/2] crypto: qat - unmap buffer before free for DH
Date:   Mon,  5 Jun 2023 22:06:06 +0100
Message-Id: <20230605210607.7185-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230605210607.7185-1-giovanni.cabiddu@intel.com>
References: <20230605210607.7185-1-giovanni.cabiddu@intel.com>
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
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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

