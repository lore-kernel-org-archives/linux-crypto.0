From: Tudor Ambarus <tudor.ambarus@freescale.com>
Subject: [PATCH] caam: caamalg - fix output sequence contiguity check
Date: Thu, 23 Oct 2014 16:54:43 +0300
Message-ID: <1414072483-4118-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:44717
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751879AbaJWNzZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Oct 2014 09:55:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the assumption that output sequence is not contiguous
when input sequence is not contiguous and in-place encryption is done.
Output sequence does not need to be contiguous with associated data.

Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a80ea85..922a3f5 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1530,7 +1530,8 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		assoc_nents = assoc_nents ? : 1;
 		src_nents = src_nents ? : 1;
 		sec4_sg_len += assoc_nents + 1 + src_nents;
-		if (likely(req->src == req->dst))
+		if (req->src == req->dst &&
+		    (src_nents || iv_dma + ivsize != sg_dma_address(req->src)))
 			contig &= ~GIV_DST_CONTIG;
 	}
 	sec4_sg_len += dst_nents;
-- 
1.8.3.1
