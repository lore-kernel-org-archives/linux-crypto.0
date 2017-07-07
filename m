From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 10/13] crypto: caam - remove unused sg_to_sec4_sg_len()
Date: Fri, 7 Jul 2017 16:05:20 +0300
Message-ID: <20170707130523.32427-11-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0066.outbound.protection.outlook.com ([104.47.38.66]:49312
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751893AbdGGNGF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:06:05 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sg_to_sec4_sg_len() is no longer used since
commit 479bcc7c5b9e ("crypto: caam - Convert authenc to new AEAD interface")

Its functionality has been superseded by the usage of sg_nents_for_len()
returning the number of S/G entries corresponding to the provided length.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/sg_sw_sec4.h | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/crypto/caam/sg_sw_sec4.h b/drivers/crypto/caam/sg_sw_sec4.h
index c6adad09c972..2f6bf162bb6c 100644
--- a/drivers/crypto/caam/sg_sw_sec4.h
+++ b/drivers/crypto/caam/sg_sw_sec4.h
@@ -58,18 +58,3 @@ static inline void sg_to_sec4_sg_last(struct scatterlist *sg, int sg_count,
 	sec4_sg_ptr = sg_to_sec4_sg(sg, sg_count, sec4_sg_ptr, offset);
 	sec4_sg_ptr->len |= cpu_to_caam32(SEC4_SG_LEN_FIN);
 }
-
-static inline struct sec4_sg_entry *sg_to_sec4_sg_len(
-	struct scatterlist *sg, unsigned int total,
-	struct sec4_sg_entry *sec4_sg_ptr)
-{
-	do {
-		unsigned int len = min(sg_dma_len(sg), total);
-
-		dma_to_sec4_sg_one(sec4_sg_ptr, sg_dma_address(sg), len, 0);
-		sec4_sg_ptr++;
-		sg = sg_next(sg);
-		total -= len;
-	} while (total);
-	return sec4_sg_ptr - 1;
-}
-- 
2.12.0.264.gd6db3f216544
