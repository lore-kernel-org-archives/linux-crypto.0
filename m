Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8B7C04AAA
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 14:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A9452075E
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 14:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfECORw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 10:17:52 -0400
Received: from inva020.nxp.com ([92.121.34.13]:56414 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbfECORw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 10:17:52 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9C9471A03BA;
        Fri,  3 May 2019 16:17:49 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 905651A03AC;
        Fri,  3 May 2019 16:17:49 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 2407C205F4;
        Fri,  3 May 2019 16:17:49 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Marcin Niestroj <m.niestroj@grinn-global.com>,
        linux-crypto@vger.kernel.org, NXP Linux Team <linux-imx@nxp.com>
Subject: [PATCH v2 1/7] crypto: caam - avoid S/G table fetching for AEAD zero-length output
Date:   Fri,  3 May 2019 17:17:37 +0300
Message-Id: <20190503141743.27129-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503141743.27129-1-horia.geanta@nxp.com>
References: <20190503141743.27129-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When enabling IOMMU support, the following issue becomes visible
in the AEAD zero-length case.

Even though the output sequence length is set to zero, the crypto engine
tries to prefetch 4 S/G table entries (since SGF bit is set
in SEQ OUT PTR command - which is either generated in SW in case of
caam/jr or in HW in case of caam/qi, caam/qi2).
The DMA read operation will trigger an IOMMU fault since the address in
the SEQ OUT PTR is "dummy" (set to zero / not obtained via DMA API
mapping).

1. In case of caam/jr, avoid the IOMMU fault by clearing the SGF bit
in SEQ OUT PTR command.

2. In case of caam/qi - setting address, bpid, length to zero for output
entry in the compound frame has a special meaning (cf. CAAM RM):
"Output frame = Unspecified, Input address = Y. A unspecified frame is
indicated by an unused SGT entry (an entry in which the Address, Length,
and BPID fields are all zero). SEC obtains output buffers from BMan as
prescribed by the preheader."

Since no output buffers are needed, modify the preheader by setting
(ABS = 1, ADDBUF = 0):
-"ABS = 1 means obtain the number of buffers in ADDBUF (0 or 1) from
the pool POOL ID"
-ADDBUF: "If ABS is set, ADD BUF specifies whether to allocate
a buffer or not"

3. In case of caam/qi2, since engine:
-does not support FLE[FMT]=2'b11 ("unused" entry) mentioned in DPAA2 RM
-requires output entry to be present, even if not used
the solution chosen is to leave output frame list entry zeroized.

Fixes: 763069ba49d3 ("crypto: caam - handle zero-length AEAD output")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c     | 1 +
 drivers/crypto/caam/caamalg_qi.c  | 2 +-
 drivers/crypto/caam/caamalg_qi2.c | 9 +++++++++
 drivers/crypto/caam/qi.c          | 3 +++
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 3e23d4b2cce2..e8f8be396796 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1105,6 +1105,7 @@ static void init_aead_job(struct aead_request *req,
 	if (unlikely(req->src != req->dst)) {
 		if (!edesc->mapped_dst_nents) {
 			dst_dma = 0;
+			out_options = 0;
 		} else if (edesc->mapped_dst_nents == 1) {
 			dst_dma = sg_dma_address(req->dst);
 			out_options = 0;
diff --git a/drivers/crypto/caam/caamalg_qi.c b/drivers/crypto/caam/caamalg_qi.c
index 70af211d2d01..992c498879a4 100644
--- a/drivers/crypto/caam/caamalg_qi.c
+++ b/drivers/crypto/caam/caamalg_qi.c
@@ -1108,7 +1108,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			dma_to_qm_sg_one_ext(&fd_sgt[0], qm_sg_dma +
 					     (1 + !!ivsize) * sizeof(*sg_table),
 					     out_len, 0);
-	} else if (mapped_dst_nents == 1) {
+	} else if (mapped_dst_nents <= 1) {
 		dma_to_qm_sg_one(&fd_sgt[0], sg_dma_address(req->dst), out_len,
 				 0);
 	} else {
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 33a4df6b81de..627cf0fd37f1 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -558,6 +558,14 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 			dpaa2_fl_set_addr(out_fle, qm_sg_dma +
 					  (1 + !!ivsize) * sizeof(*sg_table));
 		}
+	} else if (!mapped_dst_nents) {
+		/*
+		 * crypto engine requires the output entry to be present when
+		 * "frame list" FD is used.
+		 * Since engine does not support FMT=2'b11 (unused entry type),
+		 * leaving out_fle zeroized is the best option.
+		 */
+		goto skip_out_fle;
 	} else if (mapped_dst_nents == 1) {
 		dpaa2_fl_set_format(out_fle, dpaa2_fl_single);
 		dpaa2_fl_set_addr(out_fle, sg_dma_address(req->dst));
@@ -569,6 +577,7 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	dpaa2_fl_set_len(out_fle, out_len);
 
+skip_out_fle:
 	return edesc;
 }
 
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 9f08f84cca59..2d9b0485141f 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -18,6 +18,7 @@
 #include "desc_constr.h"
 
 #define PREHDR_RSLS_SHIFT	31
+#define PREHDR_ABS		BIT(25)
 
 /*
  * Use a reasonable backlog of frames (per CPU) as congestion threshold,
@@ -346,6 +347,7 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u32 *sh_desc)
 	 */
 	drv_ctx->prehdr[0] = cpu_to_caam32((1 << PREHDR_RSLS_SHIFT) |
 					   num_words);
+	drv_ctx->prehdr[1] = cpu_to_caam32(PREHDR_ABS);
 	memcpy(drv_ctx->sh_desc, sh_desc, desc_bytes(sh_desc));
 	dma_sync_single_for_device(qidev, drv_ctx->context_a,
 				   sizeof(drv_ctx->sh_desc) +
@@ -401,6 +403,7 @@ struct caam_drv_ctx *caam_drv_ctx_init(struct device *qidev,
 	 */
 	drv_ctx->prehdr[0] = cpu_to_caam32((1 << PREHDR_RSLS_SHIFT) |
 					   num_words);
+	drv_ctx->prehdr[1] = cpu_to_caam32(PREHDR_ABS);
 	memcpy(drv_ctx->sh_desc, sh_desc, desc_bytes(sh_desc));
 	size = sizeof(drv_ctx->prehdr) + sizeof(drv_ctx->sh_desc);
 	hwdesc = dma_map_single(qidev, drv_ctx->prehdr, size,
-- 
2.17.1

