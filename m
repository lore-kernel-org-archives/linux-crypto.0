From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 09/18] crypto: marvell: always ensure mid-fragments after
 first-fragment
Date: Sun, 18 Oct 2015 17:24:11 +0100
Message-ID: <E1Znqkl-0005Ww-Kx@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45246 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQYZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:24:25 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If we add a template first-fragment operation, always update the
template to be a mid-fragment.  This ensures that mid-fragments
always follow on from a first fragment in every case.

This means we can move the first to mid-fragment update code out of
mv_cesa_ahash_dma_add_data().

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 8111e73ca848..f567243da005 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -491,6 +491,11 @@ mv_cesa_dma_add_frag(struct mv_cesa_tdma_chain *chain,
 	if (ret)
 		return ERR_PTR(ret);
 
+	if (mv_cesa_mac_op_is_first_frag(tmpl))
+		mv_cesa_update_op_cfg(tmpl,
+				      CESA_SA_DESC_CFG_MID_FRAG,
+				      CESA_SA_DESC_CFG_FRAG_MSK);
+
 	return op;
 }
 
@@ -529,7 +534,6 @@ mv_cesa_ahash_dma_add_data(struct mv_cesa_tdma_chain *chain,
 			   struct mv_cesa_ahash_req *creq,
 			   gfp_t flags)
 {
-	struct mv_cesa_op_ctx *op;
 	int ret;
 
 	/* Add input transfers */
@@ -538,17 +542,8 @@ mv_cesa_ahash_dma_add_data(struct mv_cesa_tdma_chain *chain,
 	if (ret)
 		return ERR_PTR(ret);
 
-	op = mv_cesa_dma_add_frag(chain, &creq->op_tmpl, dma_iter->base.op_len,
-				  flags);
-	if (IS_ERR(op))
-		return op;
-
-	if (mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
-		mv_cesa_update_op_cfg(&creq->op_tmpl,
-				      CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
-	return op;
+	return mv_cesa_dma_add_frag(chain, &creq->op_tmpl, dma_iter->base.op_len,
+				    flags);
 }
 
 static struct mv_cesa_op_ctx *
-- 
2.1.0
