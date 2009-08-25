From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: ansi_cprng - Fix module initialization
Date: Tue, 25 Aug 2009 10:14:16 +0200
Message-ID: <20090825081416.GC14755@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:56234 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695AbZHYIL0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Aug 2009 04:11:26 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Return the value we got from crypto_register_alg() instead of
returning 0 in any case.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/ansi_cprng.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 5357ba7..3aa6e38 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -408,17 +408,10 @@ static struct crypto_alg rng_alg = {
 /* Module initalization */
 static int __init prng_mod_init(void)
 {
-	int ret = 0;
-
 	if (fips_enabled)
 		rng_alg.cra_priority += 200;
 
-	ret = crypto_register_alg(&rng_alg);
