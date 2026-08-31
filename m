Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CAE39021D;
	Mon, 31 Aug 2026 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788211124; cv=none; b=KdB4u689YbOxgOd4ebRss0k1bsCPiLrf6sr7rHuLAKuXSvuLcRqV3rexm0S5d9uE/UOaPOyuRsRwE8KqcFJD85ICkhDh9kfX3eK+f9gkxK91FOyZ+ap9awTXfgsGRoEZeWeZ8MpGTbCB51Dw+DV0n2ouBCvmrilvFNv0hEkuWc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788211124; c=relaxed/simple;
	bh=WqOYPtCXkA/0aIci2r50O1FvnD945EcokBplrXw6rDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dxtdlztKtp6V0RmOAGlQWbw94eqtkcFHLDB/vKHndnNNU7HCjisKwFpLScyDv6EAfWT9v5xvjv3p5/Ukk58+sRL4COyjxr0YdXCuEH3N7dV7RlBLyhKrNVhbYY82n4QluWAQ1fJGKo5/uzIuvR5/AXdqWDm4++2bMXRp4bZYnxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3U3sPTw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3U3sPTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897051F000E9;
	Mon, 31 Aug 2026 21:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788211122;
	bh=pEnkektR8IC0bwpCQJ4uDheZ7wh6hTNw4pR1yfRp+nY=;
	h=From:To:Cc:Subject:Date;
	b=U3U3sPTwh79A3dnIqc9cCNt9JpZE+vK+VOBwcgUHwHLESF+5cPw6OJ/Dt978Wodg4
	 bN3FkklV1zt7/pMwcx/dxrrPTFj/ng2uhdcLYpR275Q0qIBludMzCjujBS7hxjkOW3
	 JWjD6z+sX1pdCKhKzAOlEdJAzEVgbpavKWIR1EoXLZaa/n47V40uOXXApQbAVGrLFY
	 CV7amgTTS3hN5ASp5+YKDZx16HdekEC+kpuWguNrdLJzqNyP4s5+9EInhbusWyTJwc
	 tvkfHTBsLnyrrZDRlFvjO1gpO0aWzWiVoFs5DOWbRX0npL91PeToffKFl8cxT2q4dT
	 nXewcaJ7QVw1A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH RESEND] crypto: x86/aria - add missing vzeroupper in AVX-512 code
Date: Mon, 31 Aug 2026 14:18:12 -0700
Message-ID: <20260831211812.213262-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the AVX-512 optimized ARIA code uses ZMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: c970d42001f2 ("crypto: x86/aria - implement aria-avx512")
Cc: stable@vger.kernel.org
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This didn't get picked up by the x86 maintainers yet.  Herbert, can you
take this through the crypto tree?

 arch/x86/crypto/aria-gfni-avx512-asm_64.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/crypto/aria-gfni-avx512-asm_64.S b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
index 860887e5d02e..ca83eb126e06 100644
--- a/arch/x86/crypto/aria-gfni-avx512-asm_64.S
+++ b/arch/x86/crypto/aria-gfni-avx512-asm_64.S
@@ -800,6 +800,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_encrypt_64way)
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_encrypt_64way)
@@ -825,6 +826,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_decrypt_64way)
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_decrypt_64way)
@@ -966,6 +968,7 @@ SYM_TYPED_FUNC_START(aria_gfni_avx512_ctr_crypt_64way)
 		     %zmm9, %zmm8, %zmm11, %zmm10, %zmm12, %zmm13, %zmm14,
 		     %zmm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_gfni_avx512_ctr_crypt_64way)

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
prerequisite-patch-id: 464c5d2854c73d88ca57d9d6811ae20d6a66c2aa
-- 
2.55.0

