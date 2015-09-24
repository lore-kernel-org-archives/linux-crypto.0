From: John Haxby <john.haxby@oracle.com>
Subject: [PATCHv2 1/1] Disable fips-allowed for authenc() and des() ciphers
Date: Thu, 24 Sep 2015 18:24:35 +0100
Message-ID: <1443115475-27398-2-git-send-email-john.haxby@oracle.com>
References: <1443115475-27398-1-git-send-email-john.haxby@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	John Haxby <john.haxby@oracle.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ukc1-proxy-mwg04-o.oracle.com ([144.24.20.229]:18650 "EHLO
	sheep.uk.oracle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754904AbbIXRZT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 13:25:19 -0400
In-Reply-To: <1443115475-27398-1-git-send-email-john.haxby@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

No authenc() ciphers are FIPS approved, nor is ecb(des).
After the end of 2015, ansi_cprng will also be non-approved.

Signed-off-by: John Haxby <john.haxby@oracle.com>
---
 crypto/testmgr.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fa18753..523c9b9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2080,7 +2080,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(md5),ecb(cipher_null))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2096,7 +2095,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(aes))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2110,7 +2108,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2124,7 +2121,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2138,7 +2134,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),ecb(cipher_null))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2158,7 +2153,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2172,7 +2166,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2186,7 +2179,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2200,7 +2192,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2214,7 +2205,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2228,7 +2218,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2242,7 +2231,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2256,7 +2244,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(aes))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2270,7 +2257,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2284,7 +2270,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des3_ede))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -3011,7 +2996,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(des)",
 		.test = alg_test_skcipher,
-		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
-- 
2.4.3
