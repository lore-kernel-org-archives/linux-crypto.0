Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B060039FE5
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 03:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713237860; cv=none; b=pB8nFz2/CKJpqvrk2bEXV77lJ+b1pSQOOzrJeZ7qZ/7JTPmZQIYB6+25tQG929mKnomVo0wTQD+GoTqVDP9frszCo2SZAULbfBmWU9zml0fvDvx4Cqe9Oomx9rYP5ac7mjf1WQDP9I76QAKiKHT8QCcevbohhCCWH5fUS5ZFcLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713237860; c=relaxed/simple;
	bh=qWVvo7PVRxD1yUri4wu3v50S9dHE2zmDvKl+EnM9LQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=chGc5QawQfI6NfbOYLjtoucMPb6QYXsAIIe+Wyw3IjNb7+Pjj4vv5yjuFCEoVsY2OiMWu8FqBgKQQxViVlSC1HPeLivmVJSSqigzc0GOs20bEBofHncyeGCV8gNd4g8BRV/NHPfZIzVza+nVmgfDWWhfXAnw0ZqYQKpirit7Yek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=RPTZlV1P; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="RPTZlV1P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1713237856; bh=qWVvo7PVRxD1yUri4wu3v50S9dHE2zmDvKl+EnM9LQc=;
	h=From:To:Cc:Subject:Date;
	b=RPTZlV1PIXdrcefVUvs6215s79Sq24IUYYKohhoVMUjV8sZa7UKDIvT8DehYTZGty
	 wCc0wufiWGfF7RnAJ7WsvLoKASfQ8M446vGISN7WiS7U/l6QqrZnaMrdKy8rR/zpk8
	 vE4hCed6jDReBIuGMkKqsq8LCfPoqVfh0/G4Jz0Vrz80JZa2zVxkjK4zM7aSWa92I0
	 f9Fe99bfhtX0Kvy3/ZZaUIcJEBL8k+505KxVMQrll3Isdm2AdBYEz8HoVpBduELtg1
	 OH5A4K1EDKA1AEYjuSIe52o09YC95jE575fMWJ6g0tBKZOlHwQe6Ro1B3t4m7wQ71U
	 cv841Ia0AWGVw==
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH 1/2] certs: Add ECDSA signature verification self-test
Date: Mon, 15 Apr 2024 22:23:46 -0500
Message-ID: <20240416032347.72663-1-git@jvdsn.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c27b2d2012e1 ("crypto: testmgr - allow ecdsa-nist-p256 and -p384
in FIPS mode") enabled support for ECDSA in crypto/testmgr.c. The
PKCS#7 signature verification API builds upon the KCAPI primitives to
perform its high-level operations. Therefore, this change in testmgr.c
also allows ECDSA to be used by the PKCS#7 signature verification API
(in FIPS mode).

However, from a FIPS perspective, the PKCS#7 signature verification API
is a distinct "service" from the KCAPI primitives. This is because the
PKCS#7 API performs a "full" signature verification, which consists of
both hashing the data to be verified, and the public key operation.
On the other hand, the KCAPI primitive does not perform this hashing
step - it accepts pre-hashed data from the caller and only performs the
public key operation.

For this reason, the ECDSA self-tests in crypto/testmgr.c are not
sufficient to cover ECDSA signature verification offered by the PKCS#7
API. This is reflected by the self-test already present in this file
for RSA PKCS#1 v1.5 signature verification.

The solution is simply to add a second self-test here for ECDSA. P-256
with SHA-256 hashing was chosen as those parameters should remain
FIPS-approved for the foreseeable future, while keeping the performance
impact to a minimum. The ECDSA certificate and PKCS#7 signed data was
generated using OpenSSL. The existing input data was reused.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/asymmetric_keys/selftest.c | 66 +++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 4 deletions(-)

diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
index c50da7ef90ae..68620a9ab974 100644
--- a/crypto/asymmetric_keys/selftest.c
+++ b/crypto/asymmetric_keys/selftest.c
@@ -22,7 +22,8 @@ struct certs_test {
  * Set of X.509 certificates to provide public keys for the tests.  These will
  * be loaded into a temporary keyring for the duration of the testing.
  */
-static const __initconst u8 certs_selftest_keys[] = {
+static const u8 certs_selftest_keys[] __initconst = {
+	/* 4096-bit RSA certificate */
 	"\x30\x82\x05\x55\x30\x82\x03\x3d\xa0\x03\x02\x01\x02\x02\x14\x73"
 	"\x98\xea\x98\x2d\xd0\x2e\xa8\xb1\xcf\x57\xc7\xf2\x97\xb3\xe6\x1a"
 	"\xfc\x8c\x0a\x30\x0d\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x01\x0b"
@@ -109,12 +110,45 @@ static const __initconst u8 certs_selftest_keys[] = {
 	"\xad\x5a\xf5\xb3\xdb\x69\x21\x04\xfd\xd3\x1c\xdf\x94\x9d\x56\xb0"
 	"\x0a\xd1\x95\x76\x8d\xec\x9e\xdd\x0b\x15\x97\x64\xad\xe5\xf2\x62"
 	"\x02\xfc\x9e\x5f\x56\x42\x39\x05\xb3"
+#if IS_ENABLED(CONFIG_CRYPTO_ECDSA)
+	/* P-256 ECDSA certificate */
+	"\x30\x82\x01\xd4\x30\x82\x01\x7b\xa0\x03\x02\x01\x02\x02\x14\x2e"
+	"\xea\x64\x8d\x7f\x17\xe6\x2e\x9e\x58\x69\xc8\x87\xc6\x8e\x1b\xd0"
+	"\xf8\x6f\xde\x30\x0a\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x02\x30"
+	"\x3a\x31\x38\x30\x36\x06\x03\x55\x04\x03\x0c\x2f\x43\x65\x72\x74"
+	"\x69\x66\x69\x63\x61\x74\x65\x20\x76\x65\x72\x69\x66\x69\x63\x61"
+	"\x74\x69\x6f\x6e\x20\x45\x43\x44\x53\x41\x20\x73\x65\x6c\x66\x2d"
+	"\x74\x65\x73\x74\x69\x6e\x67\x20\x6b\x65\x79\x30\x20\x17\x0d\x32"
+	"\x34\x30\x34\x31\x33\x32\x32\x31\x36\x32\x36\x5a\x18\x0f\x32\x31"
+	"\x32\x34\x30\x33\x32\x30\x32\x32\x31\x36\x32\x36\x5a\x30\x3a\x31"
+	"\x38\x30\x36\x06\x03\x55\x04\x03\x0c\x2f\x43\x65\x72\x74\x69\x66"
+	"\x69\x63\x61\x74\x65\x20\x76\x65\x72\x69\x66\x69\x63\x61\x74\x69"
+	"\x6f\x6e\x20\x45\x43\x44\x53\x41\x20\x73\x65\x6c\x66\x2d\x74\x65"
+	"\x73\x74\x69\x6e\x67\x20\x6b\x65\x79\x30\x59\x30\x13\x06\x07\x2a"
+	"\x86\x48\xce\x3d\x02\x01\x06\x08\x2a\x86\x48\xce\x3d\x03\x01\x07"
+	"\x03\x42\x00\x04\x07\xe5\x6b\x51\xaf\xfc\x19\x41\x2c\x88\x92\x6b"
+	"\x77\x57\x71\x03\x9e\xe2\xfe\x6e\x6a\x71\x4e\xc7\x29\x9f\x90\xe1"
+	"\x77\x18\x9f\xc2\xe7\x0a\x82\xd0\x8a\xe1\x81\xa9\x71\x7c\x5a\x73"
+	"\xfb\x25\xb9\x5b\x1e\x24\x8c\x73\x9f\xf8\x38\xf8\x48\xb4\xad\x16"
+	"\x19\xc0\x22\xc6\xa3\x5d\x30\x5b\x30\x1d\x06\x03\x55\x1d\x0e\x04"
+	"\x16\x04\x14\x29\x00\xbc\xea\x1d\xeb\x7b\xc8\x47\x9a\x84\xa2\x3d"
+	"\x75\x8e\xfd\xfd\xd2\xb2\xd3\x30\x1f\x06\x03\x55\x1d\x23\x04\x18"
+	"\x30\x16\x80\x14\x29\x00\xbc\xea\x1d\xeb\x7b\xc8\x47\x9a\x84\xa2"
+	"\x3d\x75\x8e\xfd\xfd\xd2\xb2\xd3\x30\x0c\x06\x03\x55\x1d\x13\x01"
+	"\x01\xff\x04\x02\x30\x00\x30\x0b\x06\x03\x55\x1d\x0f\x04\x04\x03"
+	"\x02\x07\x80\x30\x0a\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x02\x03"
+	"\x47\x00\x30\x44\x02\x20\x1a\xd7\xac\x07\xc8\x97\x38\xf4\x89\x43"
+	"\x7e\xc7\x66\x6e\xa5\x00\x7c\x12\x1d\xb4\x09\x76\x0c\x99\x6b\x8c"
+	"\x26\x5d\xe9\x70\x5c\xb4\x02\x20\x73\xb7\xc7\x7a\x5a\xdb\x67\x0a"
+	"\x96\x42\x19\xcf\x4f\x67\x4f\x35\x6a\xee\x29\x25\xf2\x4f\xc8\x10"
+	"\x14\x9d\x79\x69\x1c\x7a\xd7\x5d"
+#endif
 };
 
 /*
  * Signed data and detached signature blobs that form the verification tests.
  */
-static const __initconst u8 certs_selftest_1_data[] = {
+static const u8 certs_selftest_data[] __initconst = {
 	"\x54\x68\x69\x73\x20\x69\x73\x20\x73\x6f\x6d\x65\x20\x74\x65\x73"
 	"\x74\x20\x64\x61\x74\x61\x20\x75\x73\x65\x64\x20\x66\x6f\x72\x20"
 	"\x73\x65\x6c\x66\x2d\x74\x65\x73\x74\x69\x6e\x67\x20\x63\x65\x72"
@@ -122,7 +156,8 @@ static const __initconst u8 certs_selftest_1_data[] = {
 	"\x61\x74\x69\x6f\x6e\x2e\x0a"
 };
 
-static const __initconst u8 certs_selftest_1_pkcs7[] = {
+static const u8 certs_selftest_rsa_pkcs7[] __initconst = {
+	/* 4096-bit RSA signature using PKCS#1 v1.5 padding with SHA-256 */
 	"\x30\x82\x02\xab\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x07\x02\xa0"
 	"\x82\x02\x9c\x30\x82\x02\x98\x02\x01\x01\x31\x0d\x30\x0b\x06\x09"
 	"\x60\x86\x48\x01\x65\x03\x04\x02\x01\x30\x0b\x06\x09\x2a\x86\x48"
@@ -168,12 +203,35 @@ static const __initconst u8 certs_selftest_1_pkcs7[] = {
 	"\x77\x55\x3c\x6f\x0c\x32\xd3\x8c\x44\x39\x71\x25\xfe\x96\xd2"
 };
 
+static const u8 certs_selftest_ecdsa_pkcs7[] __initconst = {
+	/* P-256 ECDSA signature using SHA-256 */
+	"\x30\x81\xf4\x06\x09\x2a\x86\x48\x86\xf7\x0d\x01\x07\x02\xa0\x81"
+	"\xe6\x30\x81\xe3\x02\x01\x01\x31\x0f\x30\x0d\x06\x09\x60\x86\x48"
+	"\x01\x65\x03\x04\x02\x01\x05\x00\x30\x0b\x06\x09\x2a\x86\x48\x86"
+	"\xf7\x0d\x01\x07\x01\x31\x81\xbf\x30\x81\xbc\x02\x01\x01\x30\x52"
+	"\x30\x3a\x31\x38\x30\x36\x06\x03\x55\x04\x03\x0c\x2f\x43\x65\x72"
+	"\x74\x69\x66\x69\x63\x61\x74\x65\x20\x76\x65\x72\x69\x66\x69\x63"
+	"\x61\x74\x69\x6f\x6e\x20\x45\x43\x44\x53\x41\x20\x73\x65\x6c\x66"
+	"\x2d\x74\x65\x73\x74\x69\x6e\x67\x20\x6b\x65\x79\x02\x14\x2e\xea"
+	"\x64\x8d\x7f\x17\xe6\x2e\x9e\x58\x69\xc8\x87\xc6\x8e\x1b\xd0\xf8"
+	"\x6f\xde\x30\x0d\x06\x09\x60\x86\x48\x01\x65\x03\x04\x02\x01\x05"
+	"\x00\x30\x0a\x06\x08\x2a\x86\x48\xce\x3d\x04\x03\x02\x04\x48\x30"
+	"\x46\x02\x21\x00\x86\xd1\xf4\x06\xb6\x49\x79\xf9\x09\x5f\x35\x1a"
+	"\x94\x7e\x0e\x1a\x12\x4d\xd9\xe6\x2a\x2d\xcf\x2d\x0a\xee\x88\x76"
+	"\xe0\x35\xf3\xeb\x02\x21\x00\xdf\x11\x8a\xab\x31\xf6\x3c\x1f\x32"
+	"\x43\x94\xe2\xb8\x35\xc9\xf3\x12\x4e\x9b\x31\x08\x10\x5d\x8d\xe2"
+	"\x43\x0a\x5f\xf5\xfd\xa2\xf1"
+};
+
 /*
  * List of tests to be run.
  */
 #define TEST(data, pkcs7) { data, sizeof(data) - 1, pkcs7, sizeof(pkcs7) - 1 }
 static const struct certs_test certs_tests[] __initconst = {
-	TEST(certs_selftest_1_data, certs_selftest_1_pkcs7),
+	TEST(certs_selftest_data, certs_selftest_rsa_pkcs7),
+#if IS_ENABLED(CONFIG_CRYPTO_ECDSA)
+	TEST(certs_selftest_data, certs_selftest_ecdsa_pkcs7),
+#endif
 };
 
 static int __init fips_signature_selftest(void)
-- 
2.44.0

