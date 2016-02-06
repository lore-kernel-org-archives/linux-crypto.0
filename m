From: Marcus Meissner <meissner@suse.de>
Subject: [PATCH] crypto: mark authenticated ctr(aes) also as FIPS able
Date: Sat,  6 Feb 2016 11:53:07 +0100
Message-ID: <1454755987-17941-1-git-send-email-meissner@suse.de>
Cc: Marcus Meissner <meissner@suse.de>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55333 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbcBFKxL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2016 05:53:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

(2nd try that adds missing , to build.)

Signed-off-by: Marcus Meissner <meissner@suse.de>
---
 crypto/testmgr.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ae8c57fd..7d66cf8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2143,6 +2143,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "authenc(hmac(sha1),ctr(aes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "authenc(hmac(sha1),ecb(cipher_null))",
 		.test = alg_test_aead,
 		.suite = {
@@ -2227,6 +2231,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "authenc(hmac(sha256),ctr(aes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "authenc(hmac(sha384),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
@@ -2253,6 +2261,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "authenc(hmac(sha384),ctr(aes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "authenc(hmac(sha512),cbc(aes))",
 		.test = alg_test_aead,
 		.suite = {
@@ -2292,6 +2304,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "authenc(hmac(sha512),ctr(aes))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
-- 
2.1.4
