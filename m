From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [RFC/Patch] fix typo on algorithm comparison
Date: Mon, 1 Oct 2007 22:28:59 +0200
Message-ID: <20071001202859.GB15421@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56379 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751866AbXJAU3A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Oct 2007 16:29:00 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The compare code which looks for identical driver compares "driver name"
with "algorithm name" instead of "driver name" with "driver name".

Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
--- 

Herbert, it looks like a typo to me. I'm not sure.

--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -153,7 +153,7 @@ static int __crypto_register_alg(struct 
 			struct crypto_larval *larval = (void *)q;
 
 			if (strcmp(alg->cra_name, q->cra_name) &&
-			    strcmp(alg->cra_driver_name, q->cra_name))
+			    strcmp(alg->cra_driver_name, q->cra_driver_name))
 				continue;
 
 			if (larval->adult)
