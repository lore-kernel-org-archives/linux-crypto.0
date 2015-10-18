From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 15/18] crypto: marvell: rearrange handling for hw finished
 hashes
Date: Sun, 18 Oct 2015 17:24:42 +0100
Message-ID: <E1ZnqlG-0005XX-Ae@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45288 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQY4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:24:56 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rearrange the last request handling for hardware finished hashes
by moving the generation of the fragment operation into this path.
This results in a simplified sequence to handle this case, and
allows us to move the software padded case further down into the
function.  Add comments describing these parts.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index b8ed0478031a..d2265beaaa6b 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -529,32 +529,45 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
 	struct mv_cesa_op_ctx *op;
 	int ret;
 
-	if (frag_len) {
+	/*
+	 * If the transfer is smaller than our maximum length, and we have
+	 * some data outstanding, we can ask the engine to finish the hash.
+	 */
+	if (creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX && frag_len) {
 		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len,
 					  flags);
 		if (IS_ERR(op))
 			return op;
-	} else {
-		op = NULL;
-	}
-
-	if (op && creq->len <= CESA_SA_DESC_MAC_SRC_TOTAL_LEN_MAX) {
-		u32 frag = CESA_SA_DESC_CFG_NOT_FRAG;
-
-		if (!mv_cesa_mac_op_is_first_frag(op))
-			frag = CESA_SA_DESC_CFG_LAST_FRAG;
 
-		mv_cesa_update_op_cfg(op, frag, CESA_SA_DESC_CFG_FRAG_MSK);
+		mv_cesa_set_mac_op_total_len(op, creq->len);
+		mv_cesa_update_op_cfg(op, mv_cesa_mac_op_is_first_frag(op) ?
+						CESA_SA_DESC_CFG_NOT_FRAG :
+						CESA_SA_DESC_CFG_LAST_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
 
 		return op;
 	}
 
+	/*
+	 * The request is longer than the engine can handle, or we have
+	 * no data outstanding. Manually generate the padding, adding it
+	 * as a "mid" fragment.
+	 */
 	ret = mv_cesa_ahash_dma_alloc_padding(ahashdreq, flags);
 	if (ret)
 		return ERR_PTR(ret);
 
 	trailerlen = mv_cesa_ahash_pad_req(creq, ahashdreq->padding);
 
+	if (frag_len) {
+		op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, frag_len,
+					  flags);
+		if (IS_ERR(op))
+			return op;
+	} else {
+		op = NULL;
+	}
+
 	if (op) {
 		len = min(CESA_SA_SRAM_PAYLOAD_SIZE - dma_iter->base.op_len,
 			  trailerlen);
-- 
2.1.0
