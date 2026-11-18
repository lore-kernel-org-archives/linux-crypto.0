Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975055;
	b=y6VL+hPTPvfnIZUPD9QAKzgeYZKPfF44hbtRbV1D1TLMESmSYf8+nqwOhOacJPPo00Vc
	 r0MdjbAaDD/U/+B7D80m5axsNXroUm6+mI2vGVZaq/GneG4VW0KzuO3wD06ukKBYGZGHs
	 y6zqYsLQZf8l081SsIO9DjZwIVY4LQ7CLqNuS05JzwDunZ7aEBd/zjOkoojzH0PWrrGYS
	 Z5tc5eSnsHK6DgLtsLgaAsSdRf/gYCUdstpDjZ4qMsEa3EkENiDF36RdKuUyalCiuqfIq
	 MD9wcS2k+SAZbVrwG+q4O4QVHZeh0gaaC5/RT78IZvW8JXO/21Ua3YHgZ4jITHR+uog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=47jzv0ATKRCCrIJSSIjRGr9bVLiPeUQSD8NKQQor1Rc=;
	b=SuHPcOA1sZR40h+AG35TIBVUCqob3CU2IoxpS3Qy0oRPVwDqRG3DjmLb1t0ECdHG9UHO
	 XFgPt7k6k+xd0YfGojn4C/fDozM4o0EzMYdVeYWnf8Wh2CQrjM2m50fTkjf050/mAbZHI
	 sAL0EkPkLnqz2R+G4K3qcmUid7nlh1t+MarURXnwiDKp9tMiZIIcAth0gknhfZmfl5oTn
	 GQ2xCkiVnAgYpC2CgxwDXETZKyzHYuxe5NOAnsl53prIgc8nnom73xNEX5FVWPWkKYGlJ
	 CZEGc5z9ZZqH8W8P9eM0cu/jSXT95H4Hl735We1+Kx1Ks5/pOtB/JOivZiucv85fO8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gCJG1k7a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31827606A333;
	Wed, 18 Nov 2026 04:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gCJG1k7a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B591F000C8;
	Wed, 18 Nov 2026 04:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794975055;
	bh=47jzv0ATKRCCrIJSSIjRGr9bVLiPeUQSD8NKQQor1Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gCJG1k7aBAmyo8jMQvTFSUeNTFVe6De3+JSItBbtYZZjO3Qiu98CtcYUwkJEGscOR
	 mMR4IVzU52kzCpnhxvgelIFFfDpwEuNjSVf4AWUs+vpj3MgGsTcKbB/MQREQHkttbQ
	 d0VoZdfhuWaP+WnvgGwBNiehIlhDMr/nNcO2z0zOEIcGiWPQ8HxxxlAXcHrdsjF0zd
	 b1Q+VVdg4wxJIRRUQIojlLq0kBlmwNJl9TNJjmKxAgDB/8DnDQuU4tGb7MxqecRTdk
	 a6rzMbu6v+vwPlXjJ/xFQD0WClMZW4LZNZ6r3mJ1I7NRViDYj65JHFR+1HKvGFFrkm
	 dSuqpi0nuDYyw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	sparclinux@vger.kernel.org,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Stian Halseth <stian@itx.no>,
	Magnus Lindholm <linmag7@gmail.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/4] lib/crypto: sparc/aes: Add and use round key load helper
Date: Tue, 17 Nov 2026 20:10:30 -0800
Message-ID: <20261118041033.50014-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261118041033.50014-1-ebiggers@kernel.org>
References: <20261118041033.50014-1-ebiggers@kernel.org>
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

In preparation for migrating more SPARC-optimized AES modes into libaes,
add a helper function aes_sparc64_load_round_keys() that loads either
the encryption or decryption round keys.

Make aes_xts_crypt_sparc64() call it.  (The AES-192 support is not used
yet, but the other modes will use it.)

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/sparc/aes.h | 44 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/lib/crypto/sparc/aes.h b/lib/crypto/sparc/aes.h
index e1a060cf49539..8b8ab0820bb3e 100644
--- a/lib/crypto/sparc/aes.h
+++ b/lib/crypto/sparc/aes.h
@@ -133,6 +133,29 @@ static void aes_decrypt_arch(const struct aes_key *key,
 	}
 }
 
+static __always_inline void aes_sparc64_load_round_keys(aes_encrypt_arg key_arg,
+							bool enc)
+{
+	const struct aes_enckey *key = key_arg.enc_key;
+	const u64 *rk = key->k.sparc_rndkeys;
+
+	if (enc) {
+		if (key->len == AES_KEYSIZE_128)
+			aes_sparc64_load_encrypt_keys_128(rk);
+		else if (key->len == AES_KEYSIZE_192)
+			aes_sparc64_load_encrypt_keys_192(rk);
+		else
+			aes_sparc64_load_encrypt_keys_256(rk);
+	} else {
+		if (key->len == AES_KEYSIZE_128)
+			aes_sparc64_load_decrypt_keys_128(rk);
+		else if (key->len == AES_KEYSIZE_192)
+			aes_sparc64_load_decrypt_keys_192(rk);
+		else
+			aes_sparc64_load_decrypt_keys_256(rk);
+	}
+}
+
 #if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
 void aes_sparc64_xts_encrypt_128(const u64 *key, const u64 *input, u64 *output,
 				 size_t len, u64 tweak[2]);
@@ -167,22 +190,17 @@ aes_xts_crypt_sparc64(u8 *dst, const u8 *src, size_t len,
 	else
 		aes_encrypt_arch(&key->tweak_key, (u8 *)t, tweak);
 
-	if (k->len == AES_KEYSIZE_128) {
-		if (enc) {
-			aes_sparc64_load_encrypt_keys_128(rk);
+	aes_sparc64_load_round_keys(k, enc);
+	if (enc) {
+		if (k->len == AES_KEYSIZE_128)
 			aes_sparc64_xts_encrypt_128(rk, in, out, len, t);
-		} else {
-			aes_sparc64_load_decrypt_keys_128(rk);
-			aes_sparc64_xts_decrypt_128(rk_end, in, out, len, t);
-		}
-	} else {
-		if (enc) {
-			aes_sparc64_load_encrypt_keys_256(rk);
+		else
 			aes_sparc64_xts_encrypt_256(rk, in, out, len, t);
-		} else {
-			aes_sparc64_load_decrypt_keys_256(rk);
+	} else {
+		if (k->len == AES_KEYSIZE_128)
+			aes_sparc64_xts_decrypt_128(rk_end, in, out, len, t);
+		else
 			aes_sparc64_xts_decrypt_256(rk_end, in, out, len, t);
-		}
 	}
 	fprs_write(0);
 
-- 
2.56.1

