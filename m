From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 04/11] crypto: caam: mark the hardware descriptor as cache
 line aligned
Date: Mon, 08 Aug 2016 18:04:47 +0100
Message-ID: <E1bWnyp-0002Vf-MD@rmk-PC.armlinux.org.uk>
References: <20160808170400.GC1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Fabio Estevam <fabio.estevam@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57482 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbcHHREw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:04:52 -0400
In-Reply-To: <20160808170400.GC1041@n2100.armlinux.org.uk>
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
index ce9c1bc23795..e9c52cbf9a41 100644
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
