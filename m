From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH 1/1] Disable fips-allowed for non-FIPS authenc ciphers
Date: Thu, 24 Sep 2015 17:02:03 +0100
Message-ID: <1443110523-23473-2-git-send-email-john.haxby@oracle.com>
References: <1443110523-23473-1-git-send-email-john.haxby@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	John Haxby <john.haxby@oracle.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ukc1-proxy-mwg04-o.oracle.com ([144.24.20.229]:44520 "EHLO
	sheep.uk.oracle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757199AbbIXQTb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 12:19:31 -0400
In-Reply-To: <1443110523-23473-1-git-send-email-john.haxby@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tests that contain non-FIPS ciphers and hashes cannot themselves be
.fips-allowed because they will necessarily fail.

Signed-off-by: John Haxby <john.haxby@oracle.com>
---
 crypto/testmgr.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index fa18753..68799dc 100644
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
@@ -2110,7 +2109,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2138,7 +2136,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),ecb(cipher_null))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2158,7 +2155,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2200,7 +2196,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2228,7 +2223,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2270,7 +2264,6 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des))",
 		.test = alg_test_aead,
-		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
-- 
2.4.3
