From: Tudor Ambarus <tudor.ambarus@freescale.com>
Subject: [PATCH v2] crypto: caam - fix output sequence contiguity check
Date: Fri, 24 Oct 2014 18:13:37 +0300
Message-ID: <1414163617-26342-1-git-send-email-tudor.ambarus@freescale.com>
References: <1414072483-4118-1-git-send-email-tudor.ambarus@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0119.outbound.protection.outlook.com ([65.55.169.119]:8855
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756407AbaJXPOX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 11:14:23 -0400
In-Reply-To: <1414072483-4118-1-git-send-email-tudor.ambarus@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the assumption that output sequence is not contiguous
when input sequence is not contiguous and in-place encryption is done.
Output sequence does not need to be contiguous with associated data.

Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>
---
Substitute 'caam: caamalg' with 'crypto: caam' in commit message.

 drivers/crypto/caam/caamalg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index c17154c..36434d9 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -2185,7 +2185,8 @@ static struct aead_edesc *aead_giv_edesc_alloc(struct aead_givcrypt_request
 		assoc_nents = assoc_nents ? : 1;
 		src_nents = src_nents ? : 1;
 		sec4_sg_len += assoc_nents + 1 + src_nents;
-		if (likely(req->src == req->dst))
+		if (req->src == req->dst &&
+		    (src_nents || iv_dma + ivsize != sg_dma_address(req->src)))
 			contig &= ~GIV_DST_CONTIG;
 	}
 
-- 
1.8.3.1
