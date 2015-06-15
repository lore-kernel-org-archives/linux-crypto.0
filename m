From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 11/11] crypto: caam - fix RNG buffer cache alignment
Date: Mon, 15 Jun 2015 16:52:59 -0700
Message-ID: <1434412379-11623-12-git-send-email-vicki.milhoan@freescale.com>
References: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:12000
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbbFOXxO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 19:53:14 -0400
In-Reply-To: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steve Cornelius <steve.cornelius@freescale.com>

The hwrng output buffers (2) are cast inside of a a struct (caam_rng_ctx)
allocated in one DMA-tagged region. While the kernel's heap allocator
should place the overall struct on a cacheline aligned boundary, the 2
buffers contained within may not necessarily align. Consenquently, the ends
of unaligned buffers may not fully flush, and if so, stale data will be left
behind, resulting in small repeating patterns.

This fix aligns the buffers inside the struct.

Note that not all of the data inside caam_rng_ctx necessarily needs to be
DMA-tagged, only the buffers themselves require this. However, a fix would
incur the expense of error-handling bloat in the case of allocation failure.

Signed-off-by: Steve Cornelius <steve.cornelius@freescale.com>
Signed-off-by: Victoria Milhoan <vicki.milhoan@freescale.com>
---
 drivers/crypto/caam/caamrng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index a8c4af9..dbec737 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -56,7 +56,7 @@
 
 /* Buffer, its dma address and lock */
 struct buf_data {
-	u8 buf[RN_BUF_SIZE];
+	u8 buf[RN_BUF_SIZE] ____cacheline_aligned;
 	dma_addr_t addr;
 	struct completion filled;
 	u32 hw_desc[DESC_JOB_O_LEN];
-- 
2.1.4
