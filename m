From: Marcus Meissner <meissner@suse.de>
Subject: [PATCH] crypto: testmgr: mark more algorithms as FIPS compliant
Date: Fri,  5 Feb 2016 14:23:33 +0100
Message-ID: <1454678613-28937-1-git-send-email-meissner@suse.de>
Cc: Marcus Meissner <meissner@suse.de>
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	smueller@chronox.de
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some more authenc() wrapped algorithms are FIPS compliant, tag
them as such.

Signed-off-by: Marcus Meissner <meissner@suse.de>
---
 crypto/testmgr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ff6a799..b0cbad8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2132,6 +2132,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(des3_ede))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2181,6 +2182,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha224),cbc(des3_ede))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2194,6 +2196,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2220,6 +2223,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(des3_ede))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2250,6 +2254,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha384),cbc(des3_ede))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2266,6 +2271,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(aes))",
+		.fips_allowed = 1,
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
@@ -2293,6 +2299,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "authenc(hmac(sha512),cbc(des3_ede))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
-- 
2.1.4
