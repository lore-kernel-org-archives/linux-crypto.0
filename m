Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795845284;
	b=dUfxuo8wQMU1FVc7Pu+NeeiEwdFIQ0EKTTHOLo1d347DQd+aSmXsBq7PZCwfx5ydA1Yp
	 6NSFWZdBd4mey5LW+fTsPe4BdnpRWZqFIJz5TK5zvP5X9lshyrB4qfyHm792Nu3qhjpjA
	 whOkDHBW4xeTE0X2BaRi10KOlbQ9h0V2Qhfsh0uCrySKTbdLWyWErZV24RwhQYoiHeQbL
	 iexD8HvUzXDNsJGdnrFutIu6jRJ29kTKigSzbTfICRRLDe8vZkSMW+zQkCT42FIdRtdlW
	 Q5EdBMZtXbIoak0/Wy5frzyItB2+Fu813LiRKO8Cj0wuMrDtU72oHmYUg4gGoSPUK1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795845284;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=k9hyQlz7QKllm/FLrW3PvzuomC4Hv1dQAnHOylFtZe8=;
	b=shvtNi14rwQpIgj+lepyNS4uJKzOBwdnopTuwLCWOwR9FXyCukKXa5NpTWIVLRRariwd
	 F2Ujx4aGG5kLQ36EhdBLX1D3o6mC85pYpBGQLECAGYOeE6ZqPt3W18hTcH18ERPBU5zIK
	 Kahj7qdRgQ9EQ+fC3qSEq4+hbRDXAMXYWqPMvIF7L82a0kE4jGZfPNO6yBxOC328YfEAN
	 eC9HuerBYk7VCnp280tUf4Rxqb7op5WmfyF7P60iN03o9yv8i+Hba34fOxUftOWI6nS/4
	 xaBjjXZ6K3fQgjHom3e23OZWVHrh0OTybWkLSePWs28IAlzlfkoI0FJKondOvA6Eytw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bhkMau43;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0808606A31C;
	Sat, 28 Nov 2026 05:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bhkMau43
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795845283;
	b=T6XfIx4SqrZyMfIgvrpHezTcBUcqUCHxbQeraOrRPpWqJW3p9GqafdXFlncXaRrv+EJi
	 G0hbrtTb8v0a4x0Wy554ixxLsGaWGrHFVE/UaTlqpe4tA7yeptjfamY7rz/CKUo82hJXH
	 4qoMbHifetpvky58xwclnc8CMq/YnLgOK47wQ+guwP38Vk9IjgzHFNZ/i9NiLzLW+NZ30
	 hiFYoQt5kwzzayOfrRYL/xy9OiCnY2OLHy1M0a30ZG2wh5xyAhtAEqA6VlcBfcbBzWpCs
	 9liOr399SZ/XCgcW5OKTcNv89qfBj0PCX+kINSpXM29+Yq9tb5/JUlmOYOXO9yGw1aw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795845283;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=k9hyQlz7QKllm/FLrW3PvzuomC4Hv1dQAnHOylFtZe8=;
	b=prygffPSx330ViXw0BV/MusW4K03NYyQJ3nZU3LoiNWeamBK4eQjrCXLA4ZaOtrhe4Ob
	 lgcPfmWoX2Wn0cIN3+8OToYjDuXMBurLeYLAZ9bSkTsrYwjx25cNmDIVm5BeWzpwp1Aho
	 Txhjes2J4maXBB1rehpwxALVZ7ePXERw9Ad+UFVN4Zhuyh07LT5ZekyKTUDUfDP5zCEB1
	 cNxOxgPYK92UiZyca3eSkBgYyIKBrDmKkInKrAtiHrtB9KhjI47VzBDXzNHqJ9+f5WJu0
	 DQU03BtejB2jVdcqnBmhSUf0xo9lrFy34xVk9mDOWwDyJDbTvxJfQC7byvnT1TwBsuw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 033391F00893;
	Sat, 28 Nov 2026 05:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795845283;
	bh=k9hyQlz7QKllm/FLrW3PvzuomC4Hv1dQAnHOylFtZe8=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=bhkMau43tSgdYJI6gt/xQYzSiO+i4rbCOGxkVK1kzxeHJ6AGse+Yb4UUFG1SSvdDO
	 7qZyYYJX31ozxRrmcACds5LSMUy4x1pL+V2YrggRZTA2kyMDyB0AMyw8ch55euCvm4
	 E8hAguoCpR/HmEh+/7NG/eLjZbxkPDuLZ/uY3WlWZhbmTglnvZGLg/t3IsMi/ymZP5
	 iPd4rswIXUihjxHVZsP/xyDFAjsrshP7zphle9jrd6S4e4MaQdalYfMZjt6jpT7Cip
	 XLdWvHaPq77Z4GZUKBJjOtV3+3dPwBl/S3u7svhR8hHI1/Nxj2s+eWe54B4BJSdXrg
	 6ehaQRjIdqKLQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 88CCC4DFD5;
	Sat, 28 Nov 2026 05:54:35 +0000 (UTC)
From: Wesley Atwell via B4 Relay <devnull+atwellwea.gmail.com@kernel.org>
Date: Fri, 27 Nov 2026 22:54:25 -0700
Subject: [PATCH] crypto: mldsa - report correct sizes for keyctl
 verification
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261127-mldsa-keyctl-sizing-v1-1-9ff5b4345cce@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/x3MUQ6CMAwA0Ks0/V4TNtHprmL8GKNAI0yyEqMQ7
 k70HeBtqFyEFQNsWPgtKq+MAawBTEPMPZO0GABd5S7WOk/T2GqkJ3/TMpLKKrmn2l+dr89d5U8
 3NIBz4U4+//X+MIBNVKamxJyG3zVFXbjgvh+G5AiGfgAAAA==
X-Change-ID: 20261127-mldsa-keyctl-sizing-4782745f0739
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: keyrings@vger.kernel.org, Ignat Korchagin <ignat@linux.win>, 
 linux-crypto@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>, 
 David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795845276; l=5264;
 i=atwellwea@gmail.com; s=20261127; h=from:subject:message-id;
 bh=gL5uvRWcy+UhykJUrDnQWcxJi/24PYvJiGeIvNoXXiI=;
 b=N4f3cOr95LqB3YnzdstBIM62Pm1jix+3fnK5e4DQwNFWYeU82FtNa+2gJdFEqujjPKvciAQCQ
 LrQSkDits5fACnw4TyE/NHJr/q+l3Jsui9P09KdcdPWKNWhv3m3IyIX
X-Developer-Key: i=atwellwea@gmail.com; a=ed25519;
 pk=Buny5Y3000rYoA3OYcxvjG5W3dpuSWh28lf8IVDjANo=
X-Endpoint-Received: by B4 Relay for atwellwea@gmail.com/20261127 with
 auth_id=1671
X-Original-From: Wesley Atwell <atwellwea@gmail.com>
Reply-To: atwellwea@gmail.com
Content-Transfer-Encoding: 7bit

From: Wesley Atwell <atwellwea@gmail.com>

A user can import an ML-DSA X.509 public certificate into a session
keyring and verify a detached signature with keyctl pkey_verify. Pure
ML-DSA verifies the raw message with hash=none. The ML-DSA key_size
callback returns the public-key length in bytes, although crypto_sig
requires key size in bits. The generic digest_size fallback then
divides that value by eight, so an ML-DSA-44 query reports a 1312-bit
key and a 164-byte maximum input. keyctl rejects longer valid messages
before calling the verifier.

In a Fedora keyutils guest, verification of a valid signature over a
164-byte message succeeded, while verification of valid signatures
over 165-byte and 1 KiB messages failed with -EINVAL. OpenSSL
verified all three signatures. This affects direct keyctl verification;
it does not establish a failure in module or PKCS#7 verification.

Keep public-key length checking in bytes and report crypto_sig key_size
in bits. In software_key_query(), report U16_MAX as the ML-DSA
max_data_size instead of deriving that raw-message limit from
crypto_sig_digestsize(). keyctl's max_data_size is a 16-bit field, and
pure ML-DSA verifies the full message rather than a fixed-size digest.
This allows keyctl to pass messages up to the largest size its query
interface can represent.

The post-fix keyutils guest verified 4 KiB inputs with all three
ML-DSA strengths, accepted 65535 bytes for ML-DSA-44, and rejected
65536 bytes at the keyctl interface boundary.

OpenAI Codex identified the key-size unit mismatch during source
review, prepared the keyutils/QEMU reproducer, generated the signed
fixtures, and proposed the two-file change. The unmodified and changed
kernels were tested with Fedora keyctl as UID 65534 using signatures
independently verified by OpenSSL.

Fixes: d3b6dd90e23e ("crypto: Add ML-DSA crypto_sig support")
Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
---
 crypto/asymmetric_keys/public_key.c | 18 ++++++++++++++----
 crypto/mldsa.c                      |  9 +++++++--
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index d71747d93..03f4593c9 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -15,6 +15,7 @@
 #include <linux/asn1.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
@@ -58,6 +59,13 @@ static void public_key_destroy(void *payload0, void *payload3)
 	public_key_signature_free(payload3);
 }
 
+static bool public_key_is_mldsa(const struct public_key *pkey)
+{
+	return strcmp(pkey->pkey_algo, "mldsa44") == 0 ||
+	       strcmp(pkey->pkey_algo, "mldsa65") == 0 ||
+	       strcmp(pkey->pkey_algo, "mldsa87") == 0;
+}
+
 /*
  * Given a public_key, and an encoding and hash_algo to be used for signing
  * and/or verification with that key, determine the name of the corresponding
@@ -142,9 +150,7 @@ software_key_determine_akcipher(const struct public_key *pkey,
 		if (strcmp(hash_algo, "streebog256") != 0 &&
 		    strcmp(hash_algo, "streebog512") != 0)
 			return -EINVAL;
-	} else if (strcmp(pkey->pkey_algo, "mldsa44") == 0 ||
-		   strcmp(pkey->pkey_algo, "mldsa65") == 0 ||
-		   strcmp(pkey->pkey_algo, "mldsa87") == 0) {
+	} else if (public_key_is_mldsa(pkey)) {
 		if (strcmp(encoding, "raw") != 0)
 			return -EINVAL;
 		if (!hash_algo)
@@ -217,7 +223,11 @@ static int software_key_query(const struct kernel_pkey_params *params,
 		len = crypto_sig_keysize(sig);
 		info->key_size = len;
 		info->max_sig_size = crypto_sig_maxsize(sig);
-		info->max_data_size = crypto_sig_digestsize(sig);
+		/* Pure ML-DSA verifies raw messages, not fixed-size digests. */
+		if (public_key_is_mldsa(pkey))
+			info->max_data_size = U16_MAX;
+		else
+			info->max_data_size = crypto_sig_digestsize(sig);
 
 		info->supported_ops = KEYCTL_SUPPORTS_VERIFY;
 		if (pkey->key_is_private)
diff --git a/crypto/mldsa.c b/crypto/mldsa.c
index d8de082cc..4753940d4 100644
--- a/crypto/mldsa.c
+++ b/crypto/mldsa.c
@@ -36,7 +36,7 @@ static int crypto_mldsa_verify(struct crypto_sig *tfm,
 			    ctx->pk, ctx->pk_len);
 }
 
-static unsigned int crypto_mldsa_key_size(struct crypto_sig *tfm)
+static unsigned int crypto_mldsa_public_key_len(struct crypto_sig *tfm)
 {
 	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
 
@@ -53,11 +53,16 @@ static unsigned int crypto_mldsa_key_size(struct crypto_sig *tfm)
 	}
 }
 
+static unsigned int crypto_mldsa_key_size(struct crypto_sig *tfm)
+{
+	return crypto_mldsa_public_key_len(tfm) * BITS_PER_BYTE;
+}
+
 static int crypto_mldsa_set_pub_key(struct crypto_sig *tfm,
 				    const void *key, unsigned int keylen)
 {
 	struct crypto_mldsa_ctx *ctx = crypto_sig_ctx(tfm);
-	unsigned int expected_len = crypto_mldsa_key_size(tfm);
+	unsigned int expected_len = crypto_mldsa_public_key_len(tfm);
 
 	if (keylen != expected_len)
 		return -EINVAL;

---
base-commit: 9fb9278d13dca54ce7ecd3254c7df8839e59f03d
change-id: 20261127-mldsa-keyctl-sizing-4782745f0739

Best regards,
-- 
Wesley Atwell <atwellwea@gmail.com>


