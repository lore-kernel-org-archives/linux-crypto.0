From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH RFC 04/11] crypto: caam: mark the hardware descriptor as cache
 line aligned
Date: Mon, 07 Dec 2015 19:12:15 +0000
Message-ID: <E1a61Cp-0007mY-IJ@rmk-PC.arm.linux.org.uk>
References: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60516 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbbLGTMV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 14:12:21 -0500
In-Reply-To: <20151207191134.GV8644@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark the hardware descriptor as being cache line aligned; on DMA
incoherent architectures, the hardware descriptor should sit in a
separate cache line from the CPU accessed data to avoid polluting
the caches.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index cf557e1291b3..0a9665140d26 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -604,7 +604,7 @@ struct ahash_edesc {
 	int src_nents;
 	int sec4_sg_bytes;
 	struct sec4_sg_entry *sec4_sg;
-	u32 hw_desc[DESC_JOB_IO_LEN / sizeof(u32)];
+	u32 hw_desc[DESC_JOB_IO_LEN / sizeof(u32)] ____cacheline_aligned;
 };
 
 static inline void ahash_unmap(struct device *dev,
-- 
2.1.0
