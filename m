Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793252843;
	b=1vSN+Eh53WddKbPC46A/GdlX+uQoYhtBO3FK63zZKauS7VvfB/n8wnecvOE3w2xu0J3z
	 TMPooVlwVsYEtUGzH2wsle8eEO5CBvMn9UP2ICwRtkWb/5gRgcweMyvZPfJKRbv7iA6zn
	 8jNA+/RhCa1RtY9vm/PGmEOB+OhZ36mfgmNnttTWz+ezXLOvZqq0zesO1nhHz1WN8hs4/
	 P6qIhDikOaextobsosMjeIqdgQf+/AivpIXmAS2o6l9DNuoBi+qAlQs1NRILXdHp7PdqG
	 /6MkgUlC0gAINYYxUa3RWU4Y1WjRzWPkf/FpHh9fY7/eIoDalzr9aFGyiqGl2Us2LyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793252843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=enHNja8LWU6ryknZLbB/SYUqM8vtV9A3/FhEIsZt/7Y=;
	b=rqcdCylBZbJoFyhxTE2YQDFznafV1k8HCPqvUEsqzbk9Vn0akMXRKUgzdmRjrlqOuKoe
	 MNkcWqIRVmMFKNu2oTLyR1YAER/xc+nliOp3X3ggfsmmv9tW8m7gFXqVR+UdEHienOhza
	 rJkGiyDEkiqYzHxyaLPilhsP65yI7sTZu2wa6AQyawWdbv+0c6+w7ztd/Tdr13QUG7j6x
	 6+cK8kwpyQKRtZOu4WfOZIKfO61Ll+cSH8rRrF7oCMXFnKudxPu7s3iyC2QZNL1uYifUW
	 BhS7iWx4ArM+lhlEIrXBbbXUUEdCIMsm+s2VuedTrbhxSVsDQ0iXxfHPGaWzaLhqx4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YhNfQHf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94B8606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 05:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YhNfQHf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7DF1F031E0;
	Thu, 29 Oct 2026 05:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793252842;
	bh=enHNja8LWU6ryknZLbB/SYUqM8vtV9A3/FhEIsZt/7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YhNfQHf9xvBt+TicB3Z+mraqsWScYNEl4Fd+ztLp3XSXn8YEikMSO5ZPVY9HTWdAD
	 y7d2gemLCmjN2scEg7itg1ExA0gGNMWi9dxCnW3BmKvM1YpaaTk+lJIDwbcpUGgkt0
	 6nVL38+oPyKTbq11FuoSMKvrHJrf11wUsl5kGspRRMW631ABfmWoTj9kv5uoWAGPIN
	 bglFUo/SnpD5P3U7BmVN9YbMRRfPohIp+pGLZ6gmb+/jNOyv27OjVDovdn5Hpc8NGg
	 5MOEefrAylptFam9fQe/QUQtG4+EZBjwf4X+Q7DC6MXgLNAD8/l7YrcaENBHGy1u/D
	 Oqb3YtCesKXbg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] lib/crypto: mldsa: Explicitly check that 'alg' is a valid value
Date: Wed, 28 Oct 2026 22:45:33 -0700
Message-ID: <20261029054534.68481-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029054534.68481-1-ebiggers@kernel.org>
References: <20261029054534.68481-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

C doesn't guarantee at the language level that an enum actually has one
of the declared values.

For robustness, make mldsa_verify() handle invalid values of 'alg'.

No effect on current callers, who always pass a valid value for 'alg'.
(Except for the KUnit test case that this commit adds.)

Fixes: 64edccea594c ("lib/crypto: Add ML-DSA verification support")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/mldsa.h         |  1 +
 lib/crypto/mldsa.c             | 10 ++++++++--
 lib/crypto/tests/mldsa_kunit.c |  9 +++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/crypto/mldsa.h b/include/crypto/mldsa.h
index 3ef2676787c9e..e0754879e7452 100644
--- a/include/crypto/mldsa.h
+++ b/include/crypto/mldsa.h
@@ -48,6 +48,7 @@ enum mldsa_alg {
  * Return:
  * * 0 if the signature is valid
  * * -EBADMSG if the signature and/or public key is malformed
+ * * -EINVAL if @alg is not a valid value
  * * -EKEYREJECTED if the signature is invalid but otherwise well-formed
  * * -ENOMEM if out of memory so the validity of the signature is unknown
  */
diff --git a/lib/crypto/mldsa.c b/lib/crypto/mldsa.c
index 68a1b432315b1..80e0e63b418a7 100644
--- a/lib/crypto/mldsa.c
+++ b/lib/crypto/mldsa.c
@@ -528,8 +528,8 @@ static size_t encode_w1(u8 out[MAX_W1_ENCODED_LEN],
 int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 		 const u8 *msg, size_t msg_len, const u8 *pk, size_t pk_len)
 {
-	const struct mldsa_parameter_set *params = &mldsa_parameter_sets[alg];
-	const int k = params->k, l = params->l;
+	const struct mldsa_parameter_set *params;
+	int k, l;
 	/* For now this just does pure ML-DSA with an empty context string. */
 	static const u8 msg_prefix[2] = { /* dom_sep= */ 0, /* ctx_len= */ 0 };
 	const u8 *ctilde; /* The signer's commitment hash */
@@ -537,6 +537,12 @@ int mldsa_verify(enum mldsa_alg alg, const u8 *sig, size_t sig_len,
 	u8 *h; /* The signer's hint vector, length k * N */
 	size_t w1_enc_len;
 
+	if (alg != MLDSA44 && alg != MLDSA65 && alg != MLDSA87)
+		return -EINVAL;
+	params = &mldsa_parameter_sets[alg];
+	k = params->k;
+	l = params->l;
+
 	/* Validate the public key and signature lengths. */
 	if (pk_len != params->pk_len || sig_len != params->sig_len)
 		return -EBADMSG;
diff --git a/lib/crypto/tests/mldsa_kunit.c b/lib/crypto/tests/mldsa_kunit.c
index ec64e10c97f25..d0ee704a36944 100644
--- a/lib/crypto/tests/mldsa_kunit.c
+++ b/lib/crypto/tests/mldsa_kunit.c
@@ -372,6 +372,14 @@ static void test_mldsa_use_hint(struct kunit *test)
 	}
 }
 
+static void test_mldsa_invalid_alg(struct kunit *test)
+{
+	KUNIT_ASSERT_EQ(test, -EINVAL,
+			mldsa_verify(MLDSA44 - 1, NULL, 0, NULL, 0, NULL, 0));
+	KUNIT_ASSERT_EQ(test, -EINVAL,
+			mldsa_verify(MLDSA87 + 1, NULL, 0, NULL, 0, NULL, 0));
+}
+
 static void benchmark_mldsa(struct kunit *test,
 			    const struct mldsa_testvector *tv)
 {
@@ -414,6 +422,7 @@ static struct kunit_case mldsa_kunit_cases[] = {
 	KUNIT_CASE(test_mldsa65),
 	KUNIT_CASE(test_mldsa87),
 	KUNIT_CASE(test_mldsa_use_hint),
+	KUNIT_CASE(test_mldsa_invalid_alg),
 	KUNIT_CASE(benchmark_mldsa44),
 	KUNIT_CASE(benchmark_mldsa65),
 	KUNIT_CASE(benchmark_mldsa87),
-- 
2.56.0

