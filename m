From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] crypto: allow aesni-intel and ghash_clmulni-intel in fips mode
Date: Fri, 29 Jun 2012 22:08:09 +0200
Message-ID: <1341000489-12691-1-git-send-email-mbroz@redhat.com>
Cc: herbert@gondor.hengli.com.au, Milan Broz <mbroz@redhat.com>,
	Paul Wouters <pwouters@redhat.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab2F2UI1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jun 2012 16:08:27 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch 863b557a88f8c033f7419fabafef4712a5055f85 added NULL entries
for intel accelerated drivers but did not marked these fips allowed.
This cause panic if running tests with fips=1.

For ghash, fips_allowed flag was added in patch
18c0ebd2d8194cce4b3f67e2903fa01bea892cbc.

Without patch, "modprobe tcrypt" fails with
  alg: skcipher: Failed to load transform for cbc-aes-aesni: -2
  cbc-aes-aesni: cbc(aes) alg self test failed in fips mode!
  (panic)

Also add missing cryptd(__driver-cbc-aes-aesni) and
cryptd(__driver-gcm-aes-aesni) test to complement
null tests above, otherwise system complains with
  alg: No test for __cbc-aes-aesni (cryptd(__driver-cbc-aes-aesni))
  alg: No test for __gcm-aes-aesni (cryptd(__driver-gcm-aes-aesni))

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Paul Wouters <pwouters@redhat.com>
---
 crypto/testmgr.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6c32f69..cdccbfd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1551,6 +1551,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "__driver-cbc-aes-aesni",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1581,6 +1582,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "__driver-ecb-aes-aesni",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1611,6 +1613,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "__ghash-pclmulqdqni",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = NULL,
@@ -1776,8 +1779,25 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-cbc-aes-aesni)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "cryptd(__driver-ecb-aes-aesni)",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1806,8 +1826,25 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cryptd(__driver-gcm-aes-aesni)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+		.suite = {
+			.cipher = {
+				.enc = {
+					.vecs = NULL,
+					.count = 0
+				},
+				.dec = {
+					.vecs = NULL,
+					.count = 0
+				}
+			}
+		}
+	}, {
 		.alg = "cryptd(__ghash-pclmulqdqni)",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = NULL,
@@ -1923,6 +1960,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(__aes-aesni)",
 		.test = alg_test_null,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
-- 
1.7.10
