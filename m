From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3/6] crypto: marvell: use gfp_t for gfp flags
Date: Sun, 18 Oct 2015 18:31:10 +0100
Message-ID: <E1Znrna-00064H-IY@rmk-PC.arm.linux.org.uk>
References: <20151018173039.GA9737@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45473 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbbJRRbV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 13:31:21 -0400
In-Reply-To: <20151018173039.GA9737@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use gfp_t not u32 for the GFP flags.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/cesa.h | 6 ++----
 drivers/crypto/marvell/tdma.c | 5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index dbe4970d6c64..752131ae1ef2 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -798,10 +798,8 @@ int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
 				  dma_addr_t dst, dma_addr_t src, u32 size,
 				  u32 flags, gfp_t gfp_flags);
 
-int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain,
-				 u32 flags);
-
-int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, u32 flags);
+int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain, gfp_t flags);
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, gfp_t flags);
 
 int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 				 struct mv_cesa_dma_iter *dma_iter,
diff --git a/drivers/crypto/marvell/tdma.c b/drivers/crypto/marvell/tdma.c
index c8256f5916b0..2738e24bcc59 100644
--- a/drivers/crypto/marvell/tdma.c
+++ b/drivers/crypto/marvell/tdma.c
@@ -166,8 +166,7 @@ int mv_cesa_dma_add_data_transfer(struct mv_cesa_tdma_chain *chain,
 	return 0;
 }
 
-int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain,
-				 u32 flags)
+int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain, gfp_t flags)
 {
 	struct mv_cesa_tdma_desc *tdma;
 
@@ -178,7 +177,7 @@ int mv_cesa_dma_add_dummy_launch(struct mv_cesa_tdma_chain *chain,
 	return 0;
 }
 
-int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, u32 flags)
+int mv_cesa_dma_add_dummy_end(struct mv_cesa_tdma_chain *chain, gfp_t flags)
 {
 	struct mv_cesa_tdma_desc *tdma;
 
-- 
2.1.0
