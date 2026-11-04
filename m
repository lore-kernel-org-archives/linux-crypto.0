Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793780215;
	b=Pby3RjaEMqJ9F9hteeZOKAzW2I8XrsK+OorW1N0LAGRlz2MwCrKXT9b1eQjdaNTWezfN
	 AjVjoLRR+xqj8ktNe8nXnfWFiqy+eg7HfbYhl/DKQzYpgw7dIKCKvKdlcteyzZjzwtC3q
	 38jsdTuHYwBXxSL3cnx457gx2/qg+uQvbJ4esVRwf/8YyFyB3WgNHdcw6UOkjh634HzR6
	 xDkyH8kiqjFmIMibEd/xVOj+5PW4HmTKbWRjosaX3jcL1sYhEjFyAs07qiRDuRTvSN2BP
	 eQwnAAStn4KQhrV/KGemmupE/PrjwkFPSfeQjEW2u3j972QdJeTT4o+/Lr0oRApFXcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793780215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=erne1a0hVCs/XxevhXKcPIoKuYzF/UZTcGO+i4IQ5LI=;
	b=FBn/WAosMKyD4nFCR0ld4u8rVu5wEDf8LqHoYGgVrTPQiFZmFFFCer9/eVgS0BP+fTQL
	 fu/anGnUi3W7ZF6EFZILHBJCSRe4hcSIfif5XrKnJBT27RiHmShmOsFhNuUqjZTKoHeJX
	 6FmRqRwlp/6lHgEfRQ6cRb4ZLO7FmLUedlfwdum6T8qv362y93mGCdqRZ3LGPJtw5x4NF
	 0ZQF4wSxgJIAuFeEsR1pGrnWHBio6zQX80w8R9iK5rFZoYLnwMKtTWOUGbrQg+NS3KHJl
	 NXkA9CFA8EsIxm92IXm509O5q+fWnSY8lTs/TuxAssLVs05zs4ZWCEhPmO+yiypud/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VX5ETX9C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3B2606A326
	for <linux-crypto@vger.kernel.org>; Wed,  4 Nov 2026 08:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VX5ETX9C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111A31F00919;
	Wed,  4 Nov 2026 08:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793780215;
	bh=erne1a0hVCs/XxevhXKcPIoKuYzF/UZTcGO+i4IQ5LI=;
	h=From:To:Cc:Subject:Date;
	b=VX5ETX9C1c1rP0t4l9zXGAAIOBFB9XzMYS44ReRQLX3eJ9hXYV0bdVBOCyqLLoQLf
	 rotqU3tubkGl2pGsxLIfNKuMe3DOijmCdnFAU40hNcrR9FmniheDgJO7U9Xl7vsMU0
	 T3Z4RxXgI3UDWyaLPGmsuYLVCJ5ZeuIhRXUyp3jMkPn8vWS8oeTKb6pq88I7zcBtWE
	 NZfynp7OylU59EJv6vS9ri1FcJO8oSIMCfl/XBC/DRqAvM8PvjPV/rp0ITLwEGhUFt
	 zzC3R69IQ8jGoeWMvR7lQenJun6bWM+RcurOzMkSpdEMcVjIzX5Co40K+tUFYCAd8r
	 mQBTUCYvr0fNg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Simplify chacha_dosimd()
Date: Wed,  4 Nov 2026 00:16:04 -0800
Message-ID: <20261104081604.302414-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

- Use if-else statements to make the logic clearer, eliminate excessive
  not-taken branches for certain lengths (e.g., 16-block aligned
  lengths), and consolidate a lot of the counter increments.

- Eliminate the unnecessary chacha_advance() function.
  DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE) is just as good.
  The min() clamp did nothing.

- Don't pass a length greater than N blocks to the assembly functions
  that process N blocks.  They all accepted it and just processed the
  first N blocks anyway, but there's no need to rely on that.

The behavior is unchanged for every length.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha.h | 128 +++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 74 deletions(-)

diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index ed39b3fdda84..57d644f89431 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -48,101 +48,81 @@ static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx2);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512vl);
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(chacha_use_avx512);
 
-static size_t chacha_advance(size_t len, size_t maxblocks)
-{
-	len = min(len, maxblocks * CHACHA_BLOCK_SIZE);
-	return round_up(len, CHACHA_BLOCK_SIZE) / CHACHA_BLOCK_SIZE;
-}
-
 static void chacha_dosimd(struct chacha_state *state, u8 *dst, const u8 *src,
 			  size_t bytes, int nrounds)
 {
-	if (static_branch_likely(&chacha_use_avx512)) {
-		while (bytes >= CHACHA_BLOCK_SIZE * 16) {
-			chacha_16block_xor_avx512(state, dst, src, bytes,
-						  nrounds);
-			bytes -= CHACHA_BLOCK_SIZE * 16;
-			src += CHACHA_BLOCK_SIZE * 16;
-			dst += CHACHA_BLOCK_SIZE * 16;
-			state->x[12] += 16;
-		}
-		if (bytes > CHACHA_BLOCK_SIZE * 8) {
-			chacha_16block_xor_avx512(state, dst, src, bytes,
-						  nrounds);
-			state->x[12] += chacha_advance(bytes, 16);
-			return;
-		}
-	}
-
 	if (static_branch_likely(&chacha_use_avx512vl)) {
-		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
-			chacha_8block_xor_avx512vl(state, dst, src, bytes,
-						   nrounds);
-			bytes -= CHACHA_BLOCK_SIZE * 8;
-			src += CHACHA_BLOCK_SIZE * 8;
-			dst += CHACHA_BLOCK_SIZE * 8;
-			state->x[12] += 8;
+		if (static_branch_likely(&chacha_use_avx512)) {
+			while (bytes >= CHACHA_BLOCK_SIZE * 16) {
+				chacha_16block_xor_avx512(
+					state, dst, src, CHACHA_BLOCK_SIZE * 16,
+					nrounds);
+				bytes -= CHACHA_BLOCK_SIZE * 16;
+				src += CHACHA_BLOCK_SIZE * 16;
+				dst += CHACHA_BLOCK_SIZE * 16;
+				state->x[12] += 16;
+			}
+			if (bytes > CHACHA_BLOCK_SIZE * 8) {
+				chacha_16block_xor_avx512(state, dst, src,
+							  bytes, nrounds);
+				state->x[12] +=
+					DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
+				return;
+			}
+		} else {
+			while (bytes >= CHACHA_BLOCK_SIZE * 8) {
+				chacha_8block_xor_avx512vl(
+					state, dst, src, CHACHA_BLOCK_SIZE * 8,
+					nrounds);
+				bytes -= CHACHA_BLOCK_SIZE * 8;
+				src += CHACHA_BLOCK_SIZE * 8;
+				dst += CHACHA_BLOCK_SIZE * 8;
+				state->x[12] += 8;
+			}
 		}
-		if (bytes > CHACHA_BLOCK_SIZE * 4) {
+		if (bytes > CHACHA_BLOCK_SIZE * 4)
 			chacha_8block_xor_avx512vl(state, dst, src, bytes,
 						   nrounds);
-			state->x[12] += chacha_advance(bytes, 8);
-			return;
-		}
-		if (bytes > CHACHA_BLOCK_SIZE * 2) {
+		else if (bytes > CHACHA_BLOCK_SIZE * 2)
 			chacha_4block_xor_avx512vl(state, dst, src, bytes,
 						   nrounds);
-			state->x[12] += chacha_advance(bytes, 4);
-			return;
-		}
-		if (bytes) {
+		else if (bytes)
 			chacha_2block_xor_avx512vl(state, dst, src, bytes,
 						   nrounds);
-			state->x[12] += chacha_advance(bytes, 2);
-			return;
-		}
-	}
-
-	if (static_branch_likely(&chacha_use_avx2)) {
+		state->x[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
+	} else if (static_branch_likely(&chacha_use_avx2)) {
 		while (bytes >= CHACHA_BLOCK_SIZE * 8) {
-			chacha_8block_xor_avx2(state, dst, src, bytes, nrounds);
+			chacha_8block_xor_avx2(state, dst, src,
+					       CHACHA_BLOCK_SIZE * 8, nrounds);
 			bytes -= CHACHA_BLOCK_SIZE * 8;
 			src += CHACHA_BLOCK_SIZE * 8;
 			dst += CHACHA_BLOCK_SIZE * 8;
 			state->x[12] += 8;
 		}
-		if (bytes > CHACHA_BLOCK_SIZE * 4) {
+		if (bytes > CHACHA_BLOCK_SIZE * 4)
 			chacha_8block_xor_avx2(state, dst, src, bytes, nrounds);
-			state->x[12] += chacha_advance(bytes, 8);
-			return;
-		}
-		if (bytes > CHACHA_BLOCK_SIZE * 2) {
+		else if (bytes > CHACHA_BLOCK_SIZE * 2)
 			chacha_4block_xor_avx2(state, dst, src, bytes, nrounds);
-			state->x[12] += chacha_advance(bytes, 4);
-			return;
-		}
-		if (bytes > CHACHA_BLOCK_SIZE) {
+		else if (bytes > CHACHA_BLOCK_SIZE)
 			chacha_2block_xor_avx2(state, dst, src, bytes, nrounds);
-			state->x[12] += chacha_advance(bytes, 2);
-			return;
+		else if (bytes)
+			chacha_block_xor_ssse3(state, dst, src, bytes, nrounds);
+		state->x[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
+	} else {
+		while (bytes >= CHACHA_BLOCK_SIZE * 4) {
+			chacha_4block_xor_ssse3(state, dst, src,
+						CHACHA_BLOCK_SIZE * 4, nrounds);
+			bytes -= CHACHA_BLOCK_SIZE * 4;
+			src += CHACHA_BLOCK_SIZE * 4;
+			dst += CHACHA_BLOCK_SIZE * 4;
+			state->x[12] += 4;
 		}
-	}
-
-	while (bytes >= CHACHA_BLOCK_SIZE * 4) {
-		chacha_4block_xor_ssse3(state, dst, src, bytes, nrounds);
-		bytes -= CHACHA_BLOCK_SIZE * 4;
-		src += CHACHA_BLOCK_SIZE * 4;
-		dst += CHACHA_BLOCK_SIZE * 4;
-		state->x[12] += 4;
-	}
-	if (bytes > CHACHA_BLOCK_SIZE) {
-		chacha_4block_xor_ssse3(state, dst, src, bytes, nrounds);
-		state->x[12] += chacha_advance(bytes, 4);
-		return;
-	}
-	if (bytes) {
-		chacha_block_xor_ssse3(state, dst, src, bytes, nrounds);
-		state->x[12]++;
+		if (bytes > CHACHA_BLOCK_SIZE)
+			chacha_4block_xor_ssse3(state, dst, src, bytes,
+						nrounds);
+		else if (bytes)
+			chacha_block_xor_ssse3(state, dst, src, bytes, nrounds);
+		state->x[12] += DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE);
 	}
 }
 

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
prerequisite-patch-id: 890b33260038bff2e3adfe7867af5919666677fc
prerequisite-patch-id: 36cadf8c358a9778d745637c00368df82a93ce0d
prerequisite-patch-id: b9ef92f4abcdfe8946d645db12187f6293a46381
prerequisite-patch-id: 85904a5ef5aa8a48c311b2e87ed4d2403bd9e351
-- 
2.56.0

