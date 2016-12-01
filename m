From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH] crypto: marvell - Don't copy hash operation twice into the SRAM
Date: Thu,  1 Dec 2016 17:21:57 +0100
Message-ID: <20161201162157.14563-1-romain.perier@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:35710 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbcLAQWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2016 11:22:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

No need to copy the template of an hash operation twice into the SRAM
from the step function.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 2a92605..fbbcbf8 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -172,9 +172,6 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	for (i = 0; i < digsize / 4; i++)
 		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
 
-	mv_cesa_adjust_op(engine, &creq->op_tmpl);
-	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
-
 	if (creq->cache_ptr)
 		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
 			    creq->cache, creq->cache_ptr);
-- 
2.9.3
