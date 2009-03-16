From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH 4/4] esp: add the pcrypt hooks to esp
Date: Mon, 16 Mar 2009 12:55:26 +0100
Message-ID: <20090316115526.GR13998@secunet.com>
References: <20090316114940.GN13998@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:52281 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbZCPLxl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2009 07:53:41 -0400
Content-Disposition: inline
In-Reply-To: <20090316114940.GN13998@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the pcrypt hooks to esp to be able to use pcrypt-ed IPsec.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4.c |    5 +++--
 net/ipv6/esp6.c |    5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 18bb383..9f72d94 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -1,5 +1,6 @@
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
+#include <crypto/pcrypt.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <net/ip.h>
@@ -447,7 +448,7 @@ static int esp_init_aead(struct xfrm_state *x)
 	struct crypto_aead *aead;
 	int err;
 
-	aead = crypto_alloc_aead(x->aead->alg_name, 0, 0);
+	aead = crypto_alloc_aead_tfm(x->aead->alg_name, 0, 0);
 	err = PTR_ERR(aead);
 	if (IS_ERR(aead))
 		goto error;
@@ -489,7 +490,7 @@ static int esp_init_authenc(struct xfrm_state *x)
 		     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
 		goto error;
 
-	aead = crypto_alloc_aead(authenc_name, 0, 0);
+	aead = crypto_alloc_aead_tfm(authenc_name, 0, 0);
 	err = PTR_ERR(aead);
 	if (IS_ERR(aead))
 		goto error;
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index c2f2501..eede728 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -26,6 +26,7 @@
 
 #include <crypto/aead.h>
 #include <crypto/authenc.h>
+#include <crypto/pcrypt.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <net/ip.h>
@@ -390,7 +391,7 @@ static int esp_init_aead(struct xfrm_state *x)
 	struct crypto_aead *aead;
 	int err;
 
-	aead = crypto_alloc_aead(x->aead->alg_name, 0, 0);
+	aead = crypto_alloc_aead_tfm(x->aead->alg_name, 0, 0);
 	err = PTR_ERR(aead);
 	if (IS_ERR(aead))
 		goto error;
@@ -432,7 +433,7 @@ static int esp_init_authenc(struct xfrm_state *x)
 		     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
 		goto error;
 
-	aead = crypto_alloc_aead(authenc_name, 0, 0);
+	aead = crypto_alloc_aead_tfm(authenc_name, 0, 0);
 	err = PTR_ERR(aead);
 	if (IS_ERR(aead))
 		goto error;
-- 
1.5.4.2

