Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46CA5C169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20BA320869
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 13:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfBHNvT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:51:19 -0500
Received: from inva020.nxp.com ([92.121.34.13]:53824 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfBHNvT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 08:51:19 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1BB5C1A0279;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0F53D1A0274;
        Fri,  8 Feb 2019 14:51:16 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id A737620138;
        Fri,  8 Feb 2019 14:51:15 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH 1/4] crypto: caam - use mapped_{src,dst}_nents for job descriptor
Date:   Fri,  8 Feb 2019 15:50:07 +0200
Message-Id: <1549633810-10380-2-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The mapped_{src,dst}_nents _returned_ from the dma_map_sg call (which
could be less than src/dst_nents) have to be used to generate the aead,
skcipher job descriptors.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a9ff2e1..6a52115 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -802,6 +802,8 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
  * aead_edesc - s/w-extended aead descriptor
  * @src_nents: number of segments in input s/w scatterlist
  * @dst_nents: number of segments in output s/w scatterlist
+ * @mapped_src_nents: number of segments in input h/w link table
+ * @mapped_dst_nents: number of segments in output h/w link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg_dma: bus physical mapped address of h/w link table
  * @sec4_sg: pointer to h/w link table
@@ -810,6 +812,8 @@ static int xts_skcipher_setkey(struct crypto_skcipher *skcipher, const u8 *key,
 struct aead_edesc {
 	int src_nents;
 	int dst_nents;
+	int mapped_src_nents;
+	int mapped_dst_nents;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
 	struct sec4_sg_entry *sec4_sg;
@@ -820,6 +824,8 @@ struct aead_edesc {
  * skcipher_edesc - s/w-extended skcipher descriptor
  * @src_nents: number of segments in input s/w scatterlist
  * @dst_nents: number of segments in output s/w scatterlist
+ * @mapped_src_nents: number of segments in input h/w link table
+ * @mapped_dst_nents: number of segments in output h/w link table
  * @iv_dma: dma address of iv for checking continuity and link table
  * @sec4_sg_bytes: length of dma mapped sec4_sg space
  * @sec4_sg_dma: bus physical mapped address of h/w link table
@@ -830,6 +836,8 @@ struct aead_edesc {
 struct skcipher_edesc {
 	int src_nents;
 	int dst_nents;
+	int mapped_src_nents;
+	int mapped_dst_nents;
 	dma_addr_t iv_dma;
 	int sec4_sg_bytes;
 	dma_addr_t sec4_sg_dma;
@@ -1024,11 +1032,12 @@ static void init_aead_job(struct aead_request *req,
 	init_job_desc_shared(desc, ptr, len, HDR_SHARE_DEFER | HDR_REVERSE);
 
 	if (all_contig) {
-		src_dma = edesc->src_nents ? sg_dma_address(req->src) : 0;
+		src_dma = edesc->mapped_src_nents ? sg_dma_address(req->src) :
+						    0;
 		in_options = 0;
 	} else {
 		src_dma = edesc->sec4_sg_dma;
-		sec4_sg_index += edesc->src_nents;
+		sec4_sg_index += edesc->mapped_src_nents;
 		in_options = LDST_SGF;
 	}
 
@@ -1039,9 +1048,9 @@ static void init_aead_job(struct aead_request *req,
 	out_options = in_options;
 
 	if (unlikely(req->src != req->dst)) {
-		if (!edesc->dst_nents) {
+		if (!edesc->mapped_dst_nents) {
 			dst_dma = 0;
-		} else if (edesc->dst_nents == 1) {
+		} else if (edesc->mapped_dst_nents == 1) {
 			dst_dma = sg_dma_address(req->dst);
 			out_options = 0;
 		} else {
@@ -1214,11 +1223,11 @@ static void init_skcipher_job(struct skcipher_request *req,
 		dst_dma = edesc->sec4_sg_dma + sizeof(struct sec4_sg_entry);
 		out_options = LDST_SGF;
 	} else {
-		if (edesc->dst_nents == 1) {
+		if (edesc->mapped_dst_nents == 1) {
 			dst_dma = sg_dma_address(req->dst);
 		} else {
-			dst_dma = edesc->sec4_sg_dma + (edesc->src_nents + 1) *
-				  sizeof(struct sec4_sg_entry);
+			dst_dma = edesc->sec4_sg_dma + (edesc->mapped_src_nents
+				  + 1) * sizeof(struct sec4_sg_entry);
 			out_options = LDST_SGF;
 		}
 	}
@@ -1324,6 +1333,8 @@ static struct aead_edesc *aead_edesc_alloc(struct aead_request *req,
 
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
+	edesc->mapped_src_nents = mapped_src_nents;
+	edesc->mapped_dst_nents = mapped_dst_nents;
 	edesc->sec4_sg = (void *)edesc + sizeof(struct aead_edesc) +
 			 desc_bytes;
 	*all_contig_ptr = !(mapped_src_nents > 1);
@@ -1661,6 +1672,8 @@ static struct skcipher_edesc *skcipher_edesc_alloc(struct skcipher_request *req,
 
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
+	edesc->mapped_src_nents = mapped_src_nents;
+	edesc->mapped_dst_nents = mapped_dst_nents;
 	edesc->sec4_sg_bytes = sec4_sg_bytes;
 	edesc->sec4_sg = (struct sec4_sg_entry *)((u8 *)edesc->hw_desc +
 						  desc_bytes);
-- 
2.1.0

