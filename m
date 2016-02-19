From: Marcus Meissner <meissner@suse.de>
Subject: [PATCH] crypto: allow rfc3686 aes-ctr variants in fips mode.
Date: Fri, 19 Feb 2016 13:34:28 +0100
Message-ID: <1455885268-15054-1-git-send-email-meissner@suse.de>
Cc: Marcus Meissner <meissner@suse.de>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	smueller@chronox.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52790 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbcBSMed (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Feb 2016 07:34:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

RFC 3686 CTR in various authenc methods.

rfc3686(ctr(aes)) is already marked fips compliant,
so these should be fine.

Signed-off-by: Marcus Meissner <meissner@suse.de>
---
 crypto/testmgr.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 190a290..5316d59 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2167,6 +2167,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "authenc(hmac(sha1),rfc3686(ctr(aes)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "authenc(hmac(sha224),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
@@ -2239,6 +2243,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "authenc(hmac(sha256),rfc3686(ctr(aes)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "authenc(hmac(sha384),cbc(des))",
 		.test = alg_test_aead,
 		.suite = {
@@ -2270,6 +2278,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "authenc(hmac(sha384),rfc3686(ctr(aes)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "authenc(hmac(sha512),cbc(aes))",
 		.fips_allowed = 1,
 		.test = alg_test_aead,
@@ -2315,6 +2327,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "authenc(hmac(sha512),rfc3686(ctr(aes)))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
-- 
2.1.4
