From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 3/7] crypto: marvell: turn mv_cesa_ahash_init() into a function returning void
Date: Tue,  9 Aug 2016 11:03:16 +0200
Message-ID: <1470733400-23621-4-git-send-email-romain.perier@free-electrons.com>
References: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39673 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752150AbcHIJDi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:03:38 -0400
In-Reply-To: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

The mv_cesa_ahash_init() function always returns 0, and the return
value is anyway never checked. Turn it into a function returning void.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 0d7f5f9..7291664 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -374,7 +374,7 @@ static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
 	.complete = mv_cesa_ahash_complete,
 };
 
-static int mv_cesa_ahash_init(struct ahash_request *req,
+static void mv_cesa_ahash_init(struct ahash_request *req,
 			      struct mv_cesa_op_ctx *tmpl, bool algo_le)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
@@ -390,8 +390,6 @@ static int mv_cesa_ahash_init(struct ahash_request *req,
 	creq->op_tmpl = *tmpl;
 	creq->len = 0;
 	creq->algo_le = algo_le;
-
-	return 0;
 }
 
 static inline int mv_cesa_ahash_cra_init(struct crypto_tfm *tfm)
-- 
2.8.1
