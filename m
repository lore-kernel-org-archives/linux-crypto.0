From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 16/18] crypto: marvell: rearrange handling for sw padded
 hashes
Date: Sun, 18 Oct 2015 17:24:47 +0100
Message-ID: <E1ZnqlL-0005Xf-FB@rmk-PC.arm.linux.org.uk>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45295 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQZB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:25:01 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rearrange the last request handling for hashes which require software
padding.

We prepare the padding to be appended, and then append as much of the
padding to any existing data that's already queued up, adding an
operation block and launching the operation.

Any remainder is then appended as a separate operation.

This ensures that the hardware only ever sees multiples of the hash
block size to be operated on for software padded hashes, thus ensuring
that the engine always indicates that it has finished the calculation.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 44 ++++++++++++++++++-------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index d2265beaaa6b..da541e59cc1d 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -559,38 +559,30 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
 
 	trailerlen = mv_cesa_ahash_pad_req(creq, ahashdreq->padding);
 
-	if (frag_len) {
-		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len,
-					  flags);
-		if (IS_ERR(op))
-			return op;
-	} else {
-		op = NULL;
-	}
-
-	if (op) {
-		len = min(CESA_SA_SRAM_PAYLOAD_SIZE - dma_iter->base.op_len,
-			  trailerlen);
-		if (len) {
-			ret = mv_cesa_dma_add_data_transfer(chain,
+	len = min(CESA_SA_SRAM_PAYLOAD_SIZE - frag_len, trailerlen);
+	if (len) {
+		ret = mv_cesa_dma_add_data_transfer(chain,
 						CESA_SA_DATA_SRAM_OFFSET +
-						dma_iter->base.op_len,
+						frag_len,
 						ahashdreq->padding_dma,
 						len, CESA_TDMA_DST_IN_SRAM,
 						flags);
-			if (ret)
-				return ERR_PTR(ret);
+		if (ret)
+			return ERR_PTR(ret);
 
-			mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
-					      CESA_SA_DESC_CFG_FRAG_MSK);
-			mv_cesa_set_mac_op_frag_len(op,
-					dma_iter->base.op_len + len);
-			padoff += len;
-		}
-	}
+		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len + len,
+					  flags);
+		if (IS_ERR(op))
+			return op;
 
-	if (padoff >= trailerlen)
-		return op;
+		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
+		if (len == trailerlen)
+			return op;
+
+		padoff += len;
+	}
 
 	if (!mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
 		mv_cesa_update_op_cfg(&creq->op_tmpl,
-- 
2.1.0
