Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52F2ECAAA1
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Sep 2022 10:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIIKuM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Sep 2022 06:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiIIKth (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Sep 2022 06:49:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8F411829
        for <linux-crypto@vger.kernel.org>; Fri,  9 Sep 2022 03:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662720572; x=1694256572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x5prW2ah25tO5V4phLQ9GuxORIJy7HrpayGmzP3LVVs=;
  b=QHofpKkp+a/8a07/n4j9o/lbbMYE2bBkIouQiOE4sdqSHJXKIDc6zDkR
   NHZe3iuCzWaAmjmfTYopRF7sYhBH5L5XDXeQExoz8QO8GVUjdld+Hn9sX
   6jJ+Qglw1Z6Fy1PZXA5mQfsLF0LR3xl86NSitRzdzrdFsZ2YtRz40Vy87
   fiHvNHNij8r+l5/JxacEgM+8L18+ooe8fntjSrVxTiFLVebtCU6nrnZqR
   KVN4z9jyM7ABWhccnI9colj/FH9BTm913KbdS+RvC9GSnRGef0dxAF3qc
   WxeUXLuYdd5gziXnNQoBDsuxlqBeJwi0wssZLwPE8nNZ0wqVjIdHHlS+i
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="295031012"
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="295031012"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2022 03:49:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,303,1654585200"; 
   d="scan'208";a="677115260"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by fmsmga008.fm.intel.com with ESMTP; 09 Sep 2022 03:49:29 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Vlad Dronov <vdronov@redhat.com>,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Adam Guerin <adam.guerin@intel.com>
Subject: [PATCH 3/3] crypto: qat - use reference to structure in dma_map_single()
Date:   Fri,  9 Sep 2022 11:49:14 +0100
Message-Id: <20220909104914.3351-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220909104914.3351-1-giovanni.cabiddu@intel.com>
References: <20220909104914.3351-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Damian Muszynski <damian.muszynski@intel.com>

When mapping the input and output parameters, the implementations of RSA
and DH pass to the function dma_map_single() a pointer to the first
member of the structure they want to map instead of a pointer to the
actual structure.
This results in set of warnings reported by the static analyser Smatch:

    drivers/crypto/qat/qat_common/qat_asym_algs.c:335 qat_dh_compute_value() error: dma_map_single_attrs() '&qat_req->in.dh.in.b' too small (8 vs 64)
    drivers/crypto/qat/qat_common/qat_asym_algs.c:341 qat_dh_compute_value() error: dma_map_single_attrs() '&qat_req->out.dh.r' too small (8 vs 64)
    drivers/crypto/qat/qat_common/qat_asym_algs.c:732 qat_rsa_enc() error: dma_map_single_attrs() '&qat_req->in.rsa.enc.m' too small (8 vs 64)
    drivers/crypto/qat/qat_common/qat_asym_algs.c:738 qat_rsa_enc() error: dma_map_single_attrs() '&qat_req->out.rsa.enc.c' too small (8 vs 64)
    drivers/crypto/qat/qat_common/qat_asym_algs.c:878 qat_rsa_dec() error: dma_map_single_attrs() '&qat_req->in.rsa.dec.c' too small (8 vs 64)
    drivers/crypto/qat/qat_common/qat_asym_algs.c:884 qat_rsa_dec() error: dma_map_single_attrs() '&qat_req->out.rsa.dec.m' too small (8 vs 64)

Where the address of the first element of a structure is used as an
input for the function dma_map_single(), replace it with the address of
the structure. This fix does not introduce any functional change as the
addresses are the same.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Adam Guerin <adam.guerin@intel.com>
---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 85b0f30712e1..94a26702aeae 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -332,13 +332,13 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	qat_req->in.dh.in_tab[n_input_params] = 0;
 	qat_req->out.dh.out_tab[1] = 0;
 	/* Mapping in.in.b or in.in_g2.xa is the same */
-	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dh.in.b,
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dh,
 					 sizeof(struct qat_dh_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
-	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dh.r,
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dh,
 					  sizeof(struct qat_dh_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
@@ -729,13 +729,13 @@ static int qat_rsa_enc(struct akcipher_request *req)
 
 	qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
-	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
-	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.enc.c,
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa,
 					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
@@ -875,13 +875,13 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	else
 		qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
-	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.dec.c,
+	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa,
 					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
-	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.dec.m,
+	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa,
 					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
-- 
2.37.1

