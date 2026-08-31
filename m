Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04539CCEA;
	Mon, 31 Aug 2026 21:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788211076; cv=none; b=uAP+WAmaExWihy7KRgtmzpDn3+bvBZSNr2yyWrtyK0XQX3eD2vwnyMHoeRL6C49EyOjONbqNCgxRRQPcg9ScXKYMADL0CqSx+vm2qtLtDey0kbcqmUjCleU5FJ6Gzna+ioj2DDnl+GmblL62fkfQEH0ElgIqd2rJw+Llxj4LLiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788211076; c=relaxed/simple;
	bh=zc1ZB4Hpekx9HFJsMQhjz/b14GIKVPGeOFNw2Fatrag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ti+muzdzwr8KazmKHhEGTSrRDsstDufx6AoKKug70QJMO/YeYRXif123R0yTtvIJddjFfK0YJZhzEee7ag7rSGQrzuZzHdHu3FLyVHvY5aMPaGFNOmEz/4N66iGpg5ZGIVjtzumQn/esDlmMEJyaazy3DSnQ3Oq86ot+E2+hn78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MRYTapZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MRYTapZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF0E1F000E9;
	Mon, 31 Aug 2026 21:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788211075;
	bh=lEdAzNMEidFaVUCCGgBhm6gTJVizpyNa5DX/iJryt3g=;
	h=From:To:Cc:Subject:Date;
	b=MRYTapZgqOT8b2ElWZK0X4Jjztd+DcSGogYRQQzfjJz3kj43gvS8H0XfmqsvwHJjl
	 jFAXMPqHSC1xEEf0zP9WYJsGoLtFYs4zSqk4A7T8ER3qOe/TS/mBFtPFyUuS5vluNh
	 J2DjSldBJJQs4Gc4MkjsK7ej4pLDN1CYhj3ZBRf6opAKueDKjkWHRFe+Yxe2nDAF4p
	 bp/Zm9ViD66kVHbugTe93CVfVWU3naiQeoHiPvL9wqf+cv9jqg3ug9iUZ/A2JVxpAK
	 Oi1Kd1yD4s0sOKB5Gersw1SXNxiwVtvVTxusD3tMze2cQDoGi6AQPS+EYeSrZno7Lw
	 z3N3Nt5ehtmpQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH RESEND] crypto: x86/aria - add missing vzeroupper in AVX2 code
Date: Mon, 31 Aug 2026 14:17:15 -0700
Message-ID: <20260831211715.213121-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the AVX2 optimized ARIA code uses YMM registers, execute
vzeroupper before returning from it.  This is needed to avoid degrading
the performance of any later SSE code that may happen to be executed.

Fixes: 37d8d3ae7a58 ("crypto: x86/aria - implement aria-avx2")
Cc: stable@vger.kernel.org
Cc: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This didn't get picked up by the x86 maintainers yet.  Herbert, can you
take this through the crypto tree?

 arch/x86/crypto/aria-aesni-avx2-asm_64.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/crypto/aria-aesni-avx2-asm_64.S b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
index ed53d4f46bd7..fda8cb8a99a8 100644
--- a/arch/x86/crypto/aria-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
@@ -982,6 +982,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_encrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_encrypt_32way)
@@ -1007,6 +1008,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_decrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_decrypt_32way)
@@ -1209,6 +1211,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_ctr_crypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_ctr_crypt_32way)
@@ -1359,6 +1362,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_encrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_encrypt_32way)
@@ -1384,6 +1388,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_decrypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %rax);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_decrypt_32way)
@@ -1428,6 +1433,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_ctr_crypt_32way)
 		     %ymm8, %ymm9, %ymm10, %ymm11, %ymm12, %ymm13, %ymm14,
 		     %ymm15, %r10);
 
+	vzeroupper;
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_ctr_crypt_32way)

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.55.0

