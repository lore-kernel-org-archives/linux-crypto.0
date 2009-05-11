From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH 1/2 v2] crypto: mark algs allowed in fips mode
Date: Mon, 11 May 2009 09:52:43 -0400
Message-ID: <200905110952.44273.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Neil Horman <nhorman@tuxdriver.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbZEKNz5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2009 09:55:57 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Set the fips_allowed flag in testmgr.c's alg_test_descs[] for algs
that are allowed to be used when in fips mode.

One caveat: des isn't actually allowed anymore, but des (and thus also
ecb(des)) has to be permitted, because disallowing them results in
des3_ede being unable to properly register (see des module init func).

Also, crc32 isn't technically on the fips approved list, but I think
it gets used in various places that necessitate it being allowed.

This list is based on
http://csrc.nist.gov/groups/STM/cavp/index.html

Important note: allowed/approved here does NOT mean "validated", just
that its an alg that *could* be validated.

Resending with properly updated patch v2 tag.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 crypto/testmgr.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f4cc178..51bae62 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -94,6 +94,7 @@ struct alg_test_desc {
 	const char *alg;
 	int (*test)(const struct alg_test_desc *desc, const char *driver,
 		    u32 type, u32 mask);
+	int fips_allowed;	/* set if alg is allowed in fips mode */
 
 	union {
 		struct aead_test_suite aead;
@@ -1432,6 +1433,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
+		.fips_allowed = 1,
 		.suite = {
 			.cprng = {
 				.vecs = ansi_cprng_aes_tv_template,
@@ -1441,6 +1443,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "cbc(aes)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1516,6 +1519,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "cbc(des3_ede)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1546,6 +1550,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ccm(aes)",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -1561,6 +1566,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "crc32c",
 		.test = alg_test_crc32c,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = crc32c_tv_template,
@@ -1570,6 +1576,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ctr(aes)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1615,6 +1622,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(aes)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1720,6 +1728,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(des)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1735,6 +1744,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "ecb(des3_ede)",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -1870,6 +1880,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "gcm(aes)",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -1912,6 +1923,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "hmac(sha1)",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = hmac_sha1_tv_template,
@@ -1921,6 +1933,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "hmac(sha224)",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = hmac_sha224_tv_template,
@@ -1930,6 +1943,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "hmac(sha256)",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = hmac_sha256_tv_template,
@@ -1939,6 +1953,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "hmac(sha384)",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = hmac_sha384_tv_template,
@@ -1948,6 +1963,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "hmac(sha512)",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = hmac_sha512_tv_template,
@@ -2029,6 +2045,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "rfc3686(ctr(aes))",
 		.test = alg_test_skcipher,
+		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
 				.enc = {
@@ -2044,6 +2061,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "rfc4309(ccm(aes))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = {
@@ -2106,6 +2124,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "sha1",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = sha1_tv_template,
@@ -2115,6 +2134,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "sha224",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = sha224_tv_template,
@@ -2124,6 +2144,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "sha256",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = sha256_tv_template,
@@ -2133,6 +2154,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "sha384",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = sha384_tv_template,
@@ -2142,6 +2164,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "sha512",
 		.test = alg_test_hash,
+		.fips_allowed = 1,
 		.suite = {
 			.hash = {
 				.vecs = sha512_tv_template,


-- 
Jarod Wilson
jarod@redhat.com

