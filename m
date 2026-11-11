Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436521;
	b=N6gKP+2V2Mefzm3d6Fofi94kVwhkWgxMwSEU+68tr28rr7xIR+CCNIZtBmQDAw2iv18p
	 gZn1DFbBTEnkKxXud2wJSnKl53bLQ1QM7swE8PrDBWOWNwpihX8P6ZP/Gq0Spu8LEEY+/
	 l63/GN0/7WhtGECuqkwGGkDOUnMbfbaCzF0oy1En5pZyPQjMG2kYnZweMnV1L6fx2rTmi
	 Yqtps9VjduG+Xkr8AJi97UBJpaAtRFTrTAbroSPh3a/0dhxlSbL9km+tPvjJubRBPlbu4
	 52AlAODJz5remp12R2w/ZggoP/qkUZHQLyF3O+fAgB+ge8qF7jvHKxNUvRCc5EfH7zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=POAeLGBJ2SCPjA/XHSnzvUyIJWWz8yLoqSCEHHqdbTo=;
	b=urgPBshJhYrjl2HwfNsxFK8U1MsHRHWPL/5HiHVqsJbqcew7L7ZHUXMHhE4PHijumX8/
	 H+zLY2/l84GYm0AlG8pjqUe5KYVsXW7Vn+Fombi1dmPRc0rI9Lds2hMxYqTclpoJA3RtC
	 Nksx/xsdsZmi3oO4n1fCrw/NQNw/AidoRtxZ46/6CWIozlFmEZ3QLTneodN4VTOqLwMAu
	 1jpQetRK0u6UWorF0VmK2Pgi2Usu+oKtYBOQV/HL+gm38ImVMHuf711RQyiauaC6KIPrd
	 WTnVIpEHkbmuwE6DXugIU597hTaSpBC+jgbwYSjSJo3jEdQOUM8Mtlh1Zf09nTex5Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lVR7L8YQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6503606A89B
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 22:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lVR7L8YQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246631F00A05;
	Wed, 11 Nov 2026 22:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794436521;
	bh=POAeLGBJ2SCPjA/XHSnzvUyIJWWz8yLoqSCEHHqdbTo=;
	h=From:To:Cc:Subject:Date;
	b=lVR7L8YQhC+9ua5FYdgQFCLAsUtOCXPYwayg36zVkhNbNedCk6Vope/BJe9QtouH9
	 9PZFKAItHoGWx3X9+CpBaPyJQoifL64RqKbPd9a5ucmJZjAesRvDAcpkCXN5Z0CXLP
	 gZTVNYHLl/LaLOUapr0CbbZkJWAyBSOuFBLSyzhTDjaA6UM9KxUVGRn2mrnnBbeN+Q
	 MXGBYGdWXUyJxJlY1FjmNdaKJdn6eHW7zBaqfH6WVdP4Pkq+v68zfkjksf/91tw5Tx
	 PAnzsLM0P/ms6YVRjtfUrRyxjC1vL5XzGRlTuUAh/xYC9V+qIFDPRbSc/nWZUFQfyn
	 /9PLrnxIyQPbg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/chacha: Drop redundant moves from AVX2 code
Date: Wed, 11 Nov 2026 14:34:55 -0800
Message-ID: <20261111223455.89467-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
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

The AVX2 optimized ChaCha code has many instances of moving one register
to another, then left-shifting the destination register with 'vpslld'.
This pattern likely was copied from the SSSE3 code, which uses 'pslld'.
However, like all the other AVX instructions, 'vpslld' has separate
source and destination registers.  Just utilize that instead.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/chacha-avx2-x86_64.S | 36 ++++++++++-------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/lib/crypto/x86/chacha-avx2-x86_64.S b/lib/crypto/x86/chacha-avx2-x86_64.S
index 18ae03e05074f..8aa3227f7302b 100644
--- a/lib/crypto/x86/chacha-avx2-x86_64.S
+++ b/lib/crypto/x86/chacha-avx2-x86_64.S
@@ -74,8 +74,7 @@ SYM_FUNC_START(chacha_1to2blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm6
-	vpslld		$12,%ymm6,%ymm6
+	vpslld		$12,%ymm1,%ymm6
 	vpsrld		$20,%ymm1,%ymm1
 	vpor		%ymm6,%ymm1,%ymm1
 
@@ -87,8 +86,7 @@ SYM_FUNC_START(chacha_1to2blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm7
-	vpslld		$7,%ymm7,%ymm7
+	vpslld		$7,%ymm1,%ymm7
 	vpsrld		$25,%ymm1,%ymm1
 	vpor		%ymm7,%ymm1,%ymm1
 
@@ -107,8 +105,7 @@ SYM_FUNC_START(chacha_1to2blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm6
-	vpslld		$12,%ymm6,%ymm6
+	vpslld		$12,%ymm1,%ymm6
 	vpsrld		$20,%ymm1,%ymm1
 	vpor		%ymm6,%ymm1,%ymm1
 
@@ -120,8 +117,7 @@ SYM_FUNC_START(chacha_1to2blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm7
-	vpslld		$7,%ymm7,%ymm7
+	vpslld		$7,%ymm1,%ymm7
 	vpsrld		$25,%ymm1,%ymm1
 	vpor		%ymm7,%ymm1,%ymm1
 
@@ -251,15 +247,13 @@ SYM_FUNC_START(chacha_2to4blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm10
-	vpslld		$12,%ymm10,%ymm10
+	vpslld		$12,%ymm1,%ymm10
 	vpsrld		$20,%ymm1,%ymm1
 	vpor		%ymm10,%ymm1,%ymm1
 
 	vpaddd		%ymm7,%ymm6,%ymm6
 	vpxor		%ymm6,%ymm5,%ymm5
-	vmovdqa		%ymm5,%ymm10
-	vpslld		$12,%ymm10,%ymm10
+	vpslld		$12,%ymm5,%ymm10
 	vpsrld		$20,%ymm5,%ymm5
 	vpor		%ymm10,%ymm5,%ymm5
 
@@ -275,15 +269,13 @@ SYM_FUNC_START(chacha_2to4blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm10
-	vpslld		$7,%ymm10,%ymm10
+	vpslld		$7,%ymm1,%ymm10
 	vpsrld		$25,%ymm1,%ymm1
 	vpor		%ymm10,%ymm1,%ymm1
 
 	vpaddd		%ymm7,%ymm6,%ymm6
 	vpxor		%ymm6,%ymm5,%ymm5
-	vmovdqa		%ymm5,%ymm10
-	vpslld		$7,%ymm10,%ymm10
+	vpslld		$7,%ymm5,%ymm10
 	vpsrld		$25,%ymm5,%ymm5
 	vpor		%ymm10,%ymm5,%ymm5
 
@@ -309,15 +301,13 @@ SYM_FUNC_START(chacha_2to4blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 12)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm10
-	vpslld		$12,%ymm10,%ymm10
+	vpslld		$12,%ymm1,%ymm10
 	vpsrld		$20,%ymm1,%ymm1
 	vpor		%ymm10,%ymm1,%ymm1
 
 	vpaddd		%ymm7,%ymm6,%ymm6
 	vpxor		%ymm6,%ymm5,%ymm5
-	vmovdqa		%ymm5,%ymm10
-	vpslld		$12,%ymm10,%ymm10
+	vpslld		$12,%ymm5,%ymm10
 	vpsrld		$20,%ymm5,%ymm5
 	vpor		%ymm10,%ymm5,%ymm5
 
@@ -333,15 +323,13 @@ SYM_FUNC_START(chacha_2to4blocks_avx2)
 	# x2 += x3, x1 = rotl32(x1 ^ x2, 7)
 	vpaddd		%ymm3,%ymm2,%ymm2
 	vpxor		%ymm2,%ymm1,%ymm1
-	vmovdqa		%ymm1,%ymm10
-	vpslld		$7,%ymm10,%ymm10
+	vpslld		$7,%ymm1,%ymm10
 	vpsrld		$25,%ymm1,%ymm1
 	vpor		%ymm10,%ymm1,%ymm1
 
 	vpaddd		%ymm7,%ymm6,%ymm6
 	vpxor		%ymm6,%ymm5,%ymm5
-	vmovdqa		%ymm5,%ymm10
-	vpslld		$7,%ymm10,%ymm10
+	vpslld		$7,%ymm5,%ymm10
 	vpsrld		$25,%ymm5,%ymm5
 	vpor		%ymm10,%ymm5,%ymm5
 

base-commit: 33b4f31b1aea3f62b61c892daefc0e6a77859032
-- 
2.56.1

