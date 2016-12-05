From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH v2 2/2] crypto: marvell - Don't corrupt state of an STD req for re-stepped ahash
Date: Mon,  5 Dec 2016 09:56:39 +0100
Message-ID: <20161205085639.21034-3-romain.perier@free-electrons.com>
References: <20161205085639.21034-1-romain.perier@free-electrons.com>
Cc: linux-crypto@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        stable@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Ofer Heifetz <oferh@marvell.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42763 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbcLEI5F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 03:57:05 -0500
In-Reply-To: <20161205085639.21034-1-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

mv_cesa_hash_std_step() copies the creq->state into the SRAM at each
step, but this is only required on the first one. By doing that, we
overwrite the engine state, and get erroneous results when the crypto
request is split in several chunks to fit in the internal SRAM.

This commit changes the function to copy the state only on the first
step.

Fixes: commit 2786cee8e50b ("crypto: marvell - Move SRAM I/O op...")
Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
Cc: <stable@vger.kernel.org>
---
 drivers/crypto/marvell/hash.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index fbbcbf8..317cf02 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -168,9 +168,11 @@ static void mv_cesa_ahash_std_step(struct ahash_request *req)
 	mv_cesa_adjust_op(engine, &creq->op_tmpl);
 	memcpy_toio(engine->sram, &creq->op_tmpl, sizeof(creq->op_tmpl));
 
-	digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
-	for (i = 0; i < digsize / 4; i++)
-		writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
+	if (!sreq->offset) {
+		digsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
+		for (i = 0; i < digsize / 4; i++)
+			writel_relaxed(creq->state[i], engine->regs + CESA_IVDIG(i));
+	}
 
 	if (creq->cache_ptr)
 		memcpy_toio(engine->sram + CESA_SA_DATA_SRAM_OFFSET,
-- 
2.9.3
