Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F9AC10F03
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2949721873
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388999AbfCVMMx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:12:53 -0400
Received: from inva021.nxp.com ([92.121.34.21]:44100 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389660AbfCVMMs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 08:12:48 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5A838200104;
        Fri, 22 Mar 2019 13:12:47 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4E2B420000C;
        Fri, 22 Mar 2019 13:12:47 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EF73A205F3;
        Fri, 22 Mar 2019 13:12:46 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - fix copy of next buffer for xcbc and cmac
Date:   Fri, 22 Mar 2019 14:12:30 +0200
Message-Id: <1553256750-1125-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix a side effect of adding xcbc support, when the next_buffer is not
copied.
The issue occurs, when there is stored from previous state a blocksize
buffer and received, a less than blocksize, from user. In this case, the
nents for req->src is 0, and the next_buffer is not copied.
An example is:
{
	.tap	= { 17, 15, 8 },
	.psize	= 40,
	.np	= 3,
	.ksize	= 16,
}

Cc: <stable@vger.kernel.org>
Fixes: 12b8567f6fa4 ("crypto: caam - add support for xcbc(aes)")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index d7483e4..cd03767 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -865,19 +865,18 @@ static int ahash_update_ctx(struct ahash_request *req)
 		if (ret)
 			goto unmap_ctx;
 
-		if (mapped_nents) {
+		if (mapped_nents)
 			sg_to_sec4_sg_last(req->src, mapped_nents,
 					   edesc->sec4_sg + sec4_sg_src_index,
 					   0);
-			if (*next_buflen)
-				scatterwalk_map_and_copy(next_buf, req->src,
-							 to_hash - *buflen,
-							 *next_buflen, 0);
-		} else {
+		else
 			sg_to_sec4_set_last(edesc->sec4_sg + sec4_sg_src_index -
 					    1);
-		}
 
+		if (*next_buflen)
+			scatterwalk_map_and_copy(next_buf, req->src,
+						 to_hash - *buflen,
+						 *next_buflen, 0);
 		desc = edesc->hw_desc;
 
 		edesc->sec4_sg_dma = dma_map_single(jrdev, edesc->sec4_sg,
-- 
2.1.0

