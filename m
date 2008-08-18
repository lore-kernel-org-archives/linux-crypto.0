From: Christian Hohnstaedt <christian@hohnstaedt.de>
Subject: [PATCH] crypto: fix larval lookup
Date: Mon, 18 Aug 2008 09:02:04 +0200
Message-ID: <20080818070204.GL22567@mail3.prorata.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3.prorata.de ([62.145.31.200]:42526 "EHLO mail3.prorata.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbYHRHCI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Aug 2008 03:02:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


crypto_alg_mod_lookup() runs in a timeout (60s) for unknown algos.

crypto_larval_error() doesn't find the larval and thus doesn't
finish crypto_larval_wait, because
the larval->mask has the CRYPTO_ALG_TESTED bit set, while
crypto_alg_lookup() is called without that bit in the mask
and the mask comparison in __crypto_alg_lookup fails.

Since larvals itself never get tested, it seems ok to 
reset that bit.

Signed-off-by: Christian Hohnstaedt <chohnstaedt@innominate.com>
---
 crypto/api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index cd232d4..0a4012e 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -118,7 +118,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 	if (!larval)
 		return ERR_PTR(-ENOMEM);
 
-	larval->mask = mask;
+	larval->mask = mask & ~CRYPTO_ALG_TESTED;
 	larval->alg.cra_flags = CRYPTO_ALG_LARVAL | type;
 	larval->alg.cra_priority = -1;
 	larval->alg.cra_destroy = crypto_larval_destroy;
-- 
1.5.6.3

