Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34321B812
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 03:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713237862; cv=none; b=A3JBk3taVCxT6FMzu+GL1pCu1/PqqguKAUhGrkF4s5VSjfrXuQb+vvL1P6guSPcT6G61DBoSECeW6BWLj+/I70loT+eETbEvxZJ/W+6/wNPceGoTyOStRUFE5xahVp3eT1Ki9rvWs9JnS1sE8YHMgHtlFlpJ19n/hc0VAYYCi3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713237862; c=relaxed/simple;
	bh=QHm/w1EL3nYHUY5c5c9webhE8BH0Of/iCj7Lci0WZWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGGchId5932+Ix47enXq0dmElX/lfuCSMKk/kcKjW3nm4s5d5mJiARrg9U9K50CEr512CbB5iTUzP/CGzhe+AcJ7CJh2iwjlltOSYPKNoMpJoM6v19D++Xfq8HoQ6ikJYIeXzlhgPGLLhLXnngq7Oi11jNfYk7zFkPMyU2giSbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=WrKRO6Vl; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="WrKRO6Vl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1713237858; bh=QHm/w1EL3nYHUY5c5c9webhE8BH0Of/iCj7Lci0WZWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WrKRO6VloRXvQAVXN2E8K2HjwAG871+i0w9aMTMyPQCFBjo81wS9xKGMRjsF1d114
	 AiBcNm90En5zHACB2FUcBQGQn3DM6C/2yaELqqSs+hgvaNKhfK2oBYMMcv93ox5Hcg
	 k3Uu0Iq+MbYzHWJwDzusdJXphNQjVbMlugKFJZ5Fd/7bgFuMC1htObRwJNxwo4beAo
	 5Is0Uwp4IR+RFpDYyqQsIjJUXsMiVO81bXCaSDiq5vJ8Wj/LHj+IPoGQQB8pO12UC3
	 XoJAVx6G8ZlUG2tUf2d2gVD3Y11F9hN2TLmGlmI95TQwIt4kLfSiYgNZmArN+iOMKT
	 QX6nxVVvKaN0g==
From: Joachim Vandersmissen <git@jvdsn.com>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Howells <dhowells@redhat.com>,
	Simo Sorce <simo@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH 2/2] certs: Guard RSA signature verification self-test
Date: Mon, 15 Apr 2024 22:23:47 -0500
Message-ID: <20240416032347.72663-2-git@jvdsn.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240416032347.72663-1-git@jvdsn.com>
References: <20240416032347.72663-1-git@jvdsn.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently it is possible to configure the kernel (albeit in a very
contrived manner) such that CRYPTO_RSA is not set, yet
FIPS_SIGNATURE_SELFTEST is set. This would cause a false kernel panic
when executing the RSA PKCS#7 self-test. Guard against this by
introducing a compile-time check.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
---
 crypto/asymmetric_keys/selftest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/crypto/asymmetric_keys/selftest.c b/crypto/asymmetric_keys/selftest.c
index 68620a9ab974..d2781d0b87d9 100644
--- a/crypto/asymmetric_keys/selftest.c
+++ b/crypto/asymmetric_keys/selftest.c
@@ -23,6 +23,7 @@ struct certs_test {
  * be loaded into a temporary keyring for the duration of the testing.
  */
 static const u8 certs_selftest_keys[] __initconst = {
+#if IS_ENABLED(CONFIG_CRYPTO_RSA)
 	/* 4096-bit RSA certificate */
 	"\x30\x82\x05\x55\x30\x82\x03\x3d\xa0\x03\x02\x01\x02\x02\x14\x73"
 	"\x98\xea\x98\x2d\xd0\x2e\xa8\xb1\xcf\x57\xc7\xf2\x97\xb3\xe6\x1a"
@@ -110,6 +111,7 @@ static const u8 certs_selftest_keys[] __initconst = {
 	"\xad\x5a\xf5\xb3\xdb\x69\x21\x04\xfd\xd3\x1c\xdf\x94\x9d\x56\xb0"
 	"\x0a\xd1\x95\x76\x8d\xec\x9e\xdd\x0b\x15\x97\x64\xad\xe5\xf2\x62"
 	"\x02\xfc\x9e\x5f\x56\x42\x39\x05\xb3"
+#endif
 #if IS_ENABLED(CONFIG_CRYPTO_ECDSA)
 	/* P-256 ECDSA certificate */
 	"\x30\x82\x01\xd4\x30\x82\x01\x7b\xa0\x03\x02\x01\x02\x02\x14\x2e"
@@ -228,7 +230,9 @@ static const u8 certs_selftest_ecdsa_pkcs7[] __initconst = {
  */
 #define TEST(data, pkcs7) { data, sizeof(data) - 1, pkcs7, sizeof(pkcs7) - 1 }
 static const struct certs_test certs_tests[] __initconst = {
+#if IS_ENABLED(CONFIG_CRYPTO_RSA)
 	TEST(certs_selftest_data, certs_selftest_rsa_pkcs7),
+#endif
 #if IS_ENABLED(CONFIG_CRYPTO_ECDSA)
 	TEST(certs_selftest_data, certs_selftest_ecdsa_pkcs7),
 #endif
-- 
2.44.0

