From: maitesin <oscar.forner.martinez@gmail.com>
Subject: [PATCH] crypto: cleaning and refactoring in rsa.c
Date: Fri, 18 Mar 2016 20:39:51 +0000
Message-ID: <1458333591-28297-1-git-send-email-violador.de.segmentos@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	maitesin <violador.de.segmentos@gmail.com>,
	Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38190 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbcCRUoW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 16:44:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Removed several unused initializations of variables.
* Inlined couple of functions.
* rsa_check_key_length: changed to use only the switch statement.
* rsa_setkey: refactored the implementation to be closer to the other
functions in the file.

Signed-off-by: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
---
 crypto/rsa.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/crypto/rsa.c b/crypto/rsa.c
index 466003e..0832b38 100644
--- a/crypto/rsa.c
+++ b/crypto/rsa.c
@@ -80,8 +80,7 @@ static int rsa_enc(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI m, c = mpi_alloc(0);
-	int ret = 0;
-	int sign;
+	int ret, sign;
 
 	if (!c)
 		return -ENOMEM;
@@ -128,8 +127,7 @@ static int rsa_dec(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI c, m = mpi_alloc(0);
-	int ret = 0;
-	int sign;
+	int ret, sign;
 
 	if (!m)
 		return -ENOMEM;
@@ -176,8 +174,7 @@ static int rsa_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI m, s = mpi_alloc(0);
-	int ret = 0;
-	int sign;
+	int ret, sign;
 
 	if (!s)
 		return -ENOMEM;
@@ -224,8 +221,7 @@ static int rsa_verify(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	const struct rsa_key *pkey = rsa_get_key(tfm);
 	MPI s, m = mpi_alloc(0);
-	int ret = 0;
-	int sign;
+	int ret, sign;
 
 	if (!m)
 		return -ENOMEM;
@@ -277,25 +273,24 @@ static int rsa_check_key_length(unsigned int len)
 	case 3072:
 	case 4096:
 		return 0;
+	default:
+		return -EINVAL;
 	}
-
-	return -EINVAL;
 }
 
 static int rsa_setkey(struct crypto_akcipher *tfm, const void *key,
 		      unsigned int keylen)
 {
 	struct rsa_key *pkey = akcipher_tfm_ctx(tfm);
-	int ret;
+	int ret = rsa_parse_key(pkey, key, keylen);
 
-	ret = rsa_parse_key(pkey, key, keylen);
 	if (ret)
 		return ret;
 
-	if (rsa_check_key_length(mpi_get_size(pkey->n) << 3)) {
+	ret = rsa_check_key_length(mpi_get_size(pkey->n) << 3);
+	if (ret)
 		rsa_free_key(pkey);
-		ret = -EINVAL;
-	}
+
 	return ret;
 }
 
@@ -322,12 +317,12 @@ static struct akcipher_alg rsa = {
 	},
 };
 
-static int rsa_init(void)
+static inline int rsa_init(void)
 {
 	return crypto_register_akcipher(&rsa);
 }
 
-static void rsa_exit(void)
+static inline void rsa_exit(void)
 {
 	crypto_unregister_akcipher(&rsa);
 }
-- 
2.7.3
