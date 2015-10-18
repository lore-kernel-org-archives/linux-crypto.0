From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 17/18] crypto: marvell: fix first-fragment handling in
 mv_cesa_ahash_dma_last_req()
Date: Sun, 18 Oct 2015 17:24:52 +0100
Message-ID: <E1ZnqlQ-0005Xl-Ie@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45302 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbbJRQZG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:25:06 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When adding the software padding, this must be done using the first/mid
fragment mode, and any subsequent operation needs to be a mid-fragment.
Fix this.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index da541e59cc1d..34271e9eb3a5 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -575,20 +575,12 @@ mv_cesa_ahash_dma_last_req(struct mv_cesa_tdma_chain *chain,
 		if (IS_ERR(op))
 			return op;
 
-		mv_cesa_update_op_cfg(op, CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
 		if (len == trailerlen)
 			return op;
 
 		padoff += len;
 	}
 
-	if (!mv_cesa_mac_op_is_first_frag(&creq->op_tmpl))
-		mv_cesa_update_op_cfg(&creq->op_tmpl,
-				      CESA_SA_DESC_CFG_MID_FRAG,
-				      CESA_SA_DESC_CFG_FRAG_MSK);
-
 	ret = mv_cesa_dma_add_data_transfer(chain,
 					    CESA_SA_DATA_SRAM_OFFSET,
 					    ahashdreq->padding_dma +
-- 
2.1.0
