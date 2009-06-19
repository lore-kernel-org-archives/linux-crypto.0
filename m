From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] tcrypt: Test algorithms by name
Date: Fri, 19 Jun 2009 13:40:58 +0200
Message-ID: <20090619114058.GY20366@secunet.com>
References: <20090608070749.GR20366@secunet.com> <20090608071246.GW20366@secunet.com> <20090619105325.GA17647@gondor.apana.org.au> <20090619105627.GA17781@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mx.secunet.com ([213.68.205.161]:44772 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZFSLin (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 07:38:43 -0400
Content-Disposition: inline
In-Reply-To: <20090619105627.GA17781@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the 'alg' module parameter to be able to test an
algorithm by name. If the algorithm type is not ad-hoc
clear for a algorithm (e.g. pcrypt, cryptd) it is possilbe
to set the algorithm type with the 'type' module parameter.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/tcrypt.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index d59ba50..dfeec0c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -45,6 +45,8 @@
  */
 static unsigned int sec;
 
+static char *alg = NULL;
+static u32 type;
 static int mode;
 static char *tvmem[TVMEMSIZE];
 
@@ -885,6 +887,11 @@ static int do_test(int m)
 	return ret;
 }
 
+static int do_alg_test(const char *alg, u32 type)
+{
+	return crypto_has_alg(alg, type, CRYPTO_ALG_TYPE_MASK);
+}
+
 static int __init tcrypt_mod_init(void)
 {
 	int err = -ENOMEM;
@@ -896,7 +903,11 @@ static int __init tcrypt_mod_init(void)
 			goto err_free_tv;
 	}
 
-	err = do_test(mode);
+	if (alg)
+		err = do_alg_test(alg, type);
+	else
+		err = do_test(mode);
+
 	if (err) {
 		printk(KERN_ERR "tcrypt: one or more tests failed!\n");
 		goto err_free_tv;
@@ -928,6 +939,8 @@ static void __exit tcrypt_mod_fini(void) { }
 module_init(tcrypt_mod_init);
 module_exit(tcrypt_mod_fini);
 
+module_param(alg, charp, 0);
+module_param(type, uint, 0);
 module_param(mode, int, 0);
 module_param(sec, uint, 0);
 MODULE_PARM_DESC(sec, "Length in seconds of speed tests "
-- 
1.5.4.2

