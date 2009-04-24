From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [RFC] [PATCH v2 4/4] esp: Use pcrypt if it is selected as software
	crypto accelerator
Date: Fri, 24 Apr 2009 12:29:26 +0200
Message-ID: <20090424102926.GF12680@secunet.com>
References: <20090424102451.GB12680@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:42629 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbZDXK1W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Apr 2009 06:27:22 -0400
Content-Disposition: inline
In-Reply-To: <20090424102451.GB12680@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a function that sets up the format string for
authenc algorithms. If pcrypt is coosen as accelerator,
the format string is set up to use pcrypt. If no accelerator
is choosen, the default format string is set up.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4.c |   40 ++++++++++++++++++++++++++++++++++++----
 net/ipv6/esp6.c |   40 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 18bb383..bff5609 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -467,6 +467,40 @@ error:
 	return err;
 }
 
+static int esp_authenc_name(struct xfrm_state *x, char *authenc_name)
+{
+	struct xfrm_accl *accl = x->accl;
+	int err = 0;
+
+	if (!accl) {
+		if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME,
+			     "authenc(%s,%s)",
+			     x->aalg ? x->aalg->alg_name : "digest_null",
+			     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
+			err = -ENAMETOOLONG;
+
+		goto out;
+	}
+
+	/* Set aead as the default accl type if type is unspecified */
+	if (!accl->type)
+		accl->type |= XFRM_ACCL_AEAD;
+
+	if (!strcmp(accl->name, "pcrypt") && (accl->type & XFRM_ACCL_AEAD)) {
+		if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME,
+			     "pcrypt(authenc(%s,eseqiv(%s)))",
+			     x->aalg ? x->aalg->alg_name : "digest_null",
+			     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
+			err = -ENAMETOOLONG;
+
+		goto out;
+	}
+
+	err = -EINVAL;
+out:
+	return err;
+}
+
 static int esp_init_authenc(struct xfrm_state *x)
 {
 	struct esp_data *esp = x->data;
@@ -483,10 +517,8 @@ static int esp_init_authenc(struct xfrm_state *x)
 	if (x->ealg == NULL)
 		goto error;
 
-	err = -ENAMETOOLONG;
-	if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME, "authenc(%s,%s)",
-		     x->aalg ? x->aalg->alg_name : "digest_null",
-		     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
+	err = esp_authenc_name(x, authenc_name);
+	if (err)
 		goto error;
 
 	aead = crypto_alloc_aead(authenc_name, 0, 0);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index c2f2501..ac5ab90 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -410,6 +410,40 @@ error:
 	return err;
 }
 
+static int esp_authenc_name(struct xfrm_state *x, char *authenc_name)
+{
+	struct xfrm_accl *accl = x->accl;
+	int err = 0;
+
+	if (!accl) {
+		if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME,
+			     "authenc(%s,%s)",
+			     x->aalg ? x->aalg->alg_name : "digest_null",
+			     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
+			err = -ENAMETOOLONG;
+
+		goto out;
+	}
+
+	/* Set aead as the default accl type if type is unspecified */
+	if (!accl->type)
+		accl->type |= XFRM_ACCL_AEAD;
+
+	if (!strcmp(accl->name, "pcrypt") && (accl->type & XFRM_ACCL_AEAD)) {
+		if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME,
+			     "pcrypt(authenc(%s,eseqiv(%s)))",
+			     x->aalg ? x->aalg->alg_name : "digest_null",
+			     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
+			err = -ENAMETOOLONG;
+
+		goto out;
+	}
+
+	err = -EINVAL;
+out:
+	return err;
+}
+
 static int esp_init_authenc(struct xfrm_state *x)
 {
 	struct esp_data *esp = x->data;
@@ -426,10 +460,8 @@ static int esp_init_authenc(struct xfrm_state *x)
 	if (x->ealg == NULL)
 		goto error;
 
-	err = -ENAMETOOLONG;
-	if (snprintf(authenc_name, CRYPTO_MAX_ALG_NAME, "authenc(%s,%s)",
-		     x->aalg ? x->aalg->alg_name : "digest_null",
-		     x->ealg->alg_name) >= CRYPTO_MAX_ALG_NAME)
+	err = esp_authenc_name(x, authenc_name);
+	if (err)
 		goto error;
 
 	aead = crypto_alloc_aead(authenc_name, 0, 0);
-- 
1.5.4.2

