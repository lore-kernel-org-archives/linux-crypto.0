From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 8/8] crypto: testmgr - Reenable authenc tests
Date: Thu, 30 Jul 2015 17:53:23 +0800
Message-ID: <E1ZKkWh-0004Ce-47@gondolin.me.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59944 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbbG3Jx0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 05:53:26 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZKkWh-0005if-90
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2015 19:53:23 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that all implementations of authenc have been converted we can
reenable the tests.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0b14f71..d0a42bd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2090,7 +2090,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha1),cbc(aes))-disabled",
+		.alg = "authenc(hmac(sha1),cbc(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2104,7 +2104,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha1),cbc(des))-disabled",
+		.alg = "authenc(hmac(sha1),cbc(des))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2118,7 +2118,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha1),cbc(des3_ede))-disabled",
+		.alg = "authenc(hmac(sha1),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2152,7 +2152,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha224),cbc(des))-disabled",
+		.alg = "authenc(hmac(sha224),cbc(des))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2166,7 +2166,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha224),cbc(des3_ede))-disabled",
+		.alg = "authenc(hmac(sha224),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2180,7 +2180,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha256),cbc(aes))-disabled",
+		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2194,7 +2194,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha256),cbc(des))-disabled",
+		.alg = "authenc(hmac(sha256),cbc(des))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2208,7 +2208,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha256),cbc(des3_ede))-disabled",
+		.alg = "authenc(hmac(sha256),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2222,7 +2222,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha384),cbc(des))-disabled",
+		.alg = "authenc(hmac(sha384),cbc(des))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2236,7 +2236,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha384),cbc(des3_ede))-disabled",
+		.alg = "authenc(hmac(sha384),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2250,7 +2250,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha512),cbc(aes))-disabled",
+		.alg = "authenc(hmac(sha512),cbc(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2264,7 +2264,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha512),cbc(des))-disabled",
+		.alg = "authenc(hmac(sha512),cbc(des))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
@@ -2278,7 +2278,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "authenc(hmac(sha512),cbc(des3_ede))-disabled",
+		.alg = "authenc(hmac(sha512),cbc(des3_ede))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
