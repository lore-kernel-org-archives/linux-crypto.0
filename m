Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793749914;
	b=jt1f6CY/2WItCOkIbyoODgDkf1uyo4SWFqofEFwq0rT6sEQI5hWQnpaL/3tC0kMOG2Um
	 mUwqeCyBbZOIgKY7qlTS506i4UWtDbeAJ8TlkpP3OGzgSQan1thT/qhxRtE/u9dUWpo0N
	 Hzy2gjJfgatae3+EAYNJzD586I6Gt8aIV6mvV6Pqj7ewVuZPh9nQJyHJOo1oQfOz/9xY6
	 Neti0qAAKv2jCucHtm2D8kqwuAZYJmlUEqAgZf1kCMvo1h3zb5SCAOHY4nghrYYSEKTBC
	 4OcF/Ucx5H6axZwU2PfGHalmjGcvjKZUoCyxkafV6qjrsLyolvAVbwb/2/kHVnuzBzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793749914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H62nGeqBioa3v7gfOeF4p5YGbyTj5fm09cKeH9d3nqs=;
	b=iFBdsA/aDUBs5HguupthSgsjKGkOfev/fZaZsnj6hit/0A8hY/5BmQEaJeiPdLnPZEHI
	 8/b/aMNZBah008+DKtk+MePo9cCPowN9Y0FKRiL91/556eD/5zVwuFffkuS8kMSMSrP/C
	 4mkBGgjM7qycba/Hum5nKuiCvDHCOA5qfKOWt+lTVDvzg1GD2HosfLUiw9/ZX5Gu4z7kT
	 X0qJa695Cp1kpxhfvah2bJc0lMgPhAGbYAJSmGEzxOL9LcBnevAqvtOpeOFEYcN9uY0sh
	 mXKjFLl6qpVTCwraq45h6qSqf0riePolir4UqMA5/WrZxxC/vFkIVq8QVXEBCAKuDtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=foHvWAzh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EA9606A328
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=foHvWAzh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552041F00A02;
	Tue,  3 Nov 2026 23:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793749913;
	bh=H62nGeqBioa3v7gfOeF4p5YGbyTj5fm09cKeH9d3nqs=;
	h=From:To:Cc:Subject:Date;
	b=foHvWAzhV+INGITsrJsvRKmMKsb6TWYw7atrDlJ1HZkQfk6R4g+KMf+W4abDHX56j
	 pRJInWwQHNzdV+eJa2g+xBWOsjhQFbBDn/fJSTH52WVDYd5DMKrwg6n25or+RIcFEu
	 pf7UOAVXNIsICXT5985pGB536BuYDWSfLdBEMep+Qcjkpk3JqVcWAl2Lj0bxazXkZt
	 FpGz06sfo2BPBKk13Q/IjSWVTQrcrXWCHcguQCu24+yeD4saSIEZsEYSx0N3liQtIQ
	 CMZ2i2LWFQDfCaMWBtYmw0q3BSsGsDMrhl+omcTe1bGQqxuWKF8krBZ6CKrekUlYJZ
	 dVuKmZ2VOkn1A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Use bzhi to simplify mask generation
Date: Tue,  3 Nov 2026 15:50:27 -0800
Message-ID: <20261103235027.63382-1-ebiggers@kernel.org>
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

When XOR'ing the bytes from a partial register at the end, use the bzhi
instruction (from BMI2) to generate the needed mask a bit more
efficiently.  All real processors with AVX-512 also have BMI2, so we
might as well make use of it.  This follows the example of the AVX-512
optimized AES-GCM code which already does this.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha-avx512-x86_64.S | 30 +++++++++++----------------
 lib/crypto/x86/chacha.h               |  3 ++-
 2 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx512-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
index 92babb1d3844..422479631d5b 100644
--- a/lib/crypto/x86/chacha-avx512-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -189,15 +189,13 @@ SYM_FUNC_START(chacha_2block_xor_avx512vl)
 
 .Lxorpart2:
 	# xor remaining bytes from partial register into output
-	mov		%rcx,%rax
+	mov		%rcx,%r9
+	and		$~0xf,%r9
 	and		$0xf,%rcx
 	jz		.Ldone2
-	mov		%rax,%r9
-	and		$~0xf,%r9
 
-	mov		$1,%rax
-	shld		%cl,%rax,%rax
-	sub		$1,%rax
+	mov		$-1,%rax
+	bzhi		%rcx,%rax,%rax
 	kmovq		%rax,%k1
 
 	vmovdqu8	(%rdx,%r9),%xmm1{%k1}{z}
@@ -455,15 +453,13 @@ SYM_FUNC_START(chacha_4block_xor_avx512vl)
 
 .Lxorpart4:
 	# xor remaining bytes from partial register into output
-	mov		%rcx,%rax
+	mov		%rcx,%r9
+	and		$~0xf,%r9
 	and		$0xf,%rcx
 	jz		.Ldone4
-	mov		%rax,%r9
-	and		$~0xf,%r9
 
-	mov		$1,%rax
-	shld		%cl,%rax,%rax
-	sub		$1,%rax
+	mov		$-1,%rax
+	bzhi		%rcx,%rax,%rax
 	kmovq		%rax,%k1
 
 	vmovdqu8	(%rdx,%r9),%xmm1{%k1}{z}
@@ -977,15 +973,13 @@ SYM_FUNC_END(chacha_4block_xor_avx512vl)
 
 .Lxorpart\@:
 	# xor remaining bytes from partial register into output
-	mov		%rcx,%rax
+	mov		%rcx,%r9
+	and		$~(VL - 1),%r9
 	and		$(VL - 1),%rcx
 	jz		.Ldone\@
-	mov		%rax,%r9
-	and		$~(VL - 1),%r9
 
-	mov		$1,%rax
-	shld		%cl,%rax,%rax
-	sub		$1,%rax
+	mov		$-1,%rax
+	bzhi		%rcx,%rax,%rax
 	kmovq		%rax,%k1
 
 	vmovdqu8	(%rdx,%r9),V1{%k1}{z}
diff --git a/lib/crypto/x86/chacha.h b/lib/crypto/x86/chacha.h
index fdf01b07742e..ed39b3fdda84 100644
--- a/lib/crypto/x86/chacha.h
+++ b/lib/crypto/x86/chacha.h
@@ -191,7 +191,8 @@ static void chacha_mod_init_arch(void)
 		static_branch_enable(&chacha_use_avx2);
 
 		if (boot_cpu_has(X86_FEATURE_AVX512VL) &&
-		    boot_cpu_has(X86_FEATURE_AVX512BW)) { /* kmovq */
+		    boot_cpu_has(X86_FEATURE_AVX512BW) &&
+		    boot_cpu_has(X86_FEATURE_BMI2)) {
 			static_branch_enable(&chacha_use_avx512vl);
 
 			if (!boot_cpu_has(X86_FEATURE_PREFER_YMM))

base-commit: 9fbbbaefd5f95551da18426c200cf41e1b4255a1
-- 
2.56.0

