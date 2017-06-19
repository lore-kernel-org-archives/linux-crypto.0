From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/2] crypto: caam - fix gfp allocation flags (part I)
Date: Mon, 19 Jun 2017 11:44:45 +0300
Message-ID: <20170619084446.27967-1-horia.geanta@nxp.com>
References: <5215CFD1-A162-4668-A34C-1C29509DC27E@sigma-star.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>, <richard@sigma-star.at>,
        Radu Solea <radu.solea@nxp.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        David Gstir <david@sigma-star.at>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0061.outbound.protection.outlook.com ([104.47.37.61]:7654
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751166AbdFSIuP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 04:50:15 -0400
In-Reply-To: <5215CFD1-A162-4668-A34C-1C29509DC27E@sigma-star.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes in the SW cts (ciphertext stealing) code in
commit 0605c41cc53ca ("crypto: cts - Convert to skcipher")
revealed a problem in the CAAM driver:
when cts(cbc(aes)) is executed and cts runs in SW,
cbc(aes) is offloaded in CAAM; cts encrypts the last block
in atomic context and CAAM incorrectly decides to use GFP_KERNEL
for memory allocation.

Fix this by allowing GFP_KERNEL (sleeping) only when MAY_SLEEP flag is
set, i.e. remove MAY_BACKLOG flag.

We split the fix in two parts - first is sent to -stable, while the
second is not (since there is no known failure case).

Link: http://lkml.kernel.org/g/20170602122446.2427-1-david@sigma-star.at
Cc: <stable@vger.kernel.org> # 4.8+
Reported-by: David Gstir <david@sigma-star.at>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 398807d1b77e..4ecf92e3b404 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -1475,8 +1475,7 @@ static struct ablkcipher_edesc *ablkcipher_edesc_alloc(struct ablkcipher_request
 	struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
 	struct caam_ctx *ctx = crypto_ablkcipher_ctx(ablkcipher);
 	struct device *jrdev = ctx->jrdev;
-	gfp_t flags = (req->base.flags & (CRYPTO_TFM_REQ_MAY_BACKLOG |
-					  CRYPTO_TFM_REQ_MAY_SLEEP)) ?
+	gfp_t flags = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
 		       GFP_KERNEL : GFP_ATOMIC;
 	int src_nents, mapped_src_nents, dst_nents = 0, mapped_dst_nents = 0;
 	struct ablkcipher_edesc *edesc;
-- 
2.12.0.264.gd6db3f216544
