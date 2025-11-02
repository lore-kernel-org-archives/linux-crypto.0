Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E78D1A83F8;
	Sun,  2 Nov 2025 01:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762048426; cv=none; b=GKR+2Mz5IOZhlif80xEasSVEMbJqDDWnGPhMhYbG87eF8u50wP4qsDXnTRwGDD+fXtaSrZgKKEglgGS7SOSoO9KjAufjEzwedBsH4XSmcA6c3ZyPzFxNg1z6WdXZy7SO+DGM1dVU35t489dQunlKaKctd3rgOB7JPTs5Gcsjl50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762048426; c=relaxed/simple;
	bh=OSoR+A52Jyhxie9Qg/dzo0L+8Bjra/GYLQkxY5sUJTY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZVIeBqegSnvBJkXbiuXPL+5Lu5zrUv8uwKK9Vv5jS6vJclzPkqK6Hy+I+GRm0gNLVu43pT1IAY5ygqa4A0YeWON2JBJsPPJYMJX6l/6xRKrQASdjmOgC4H+dQmvLX11c8BXnbfaeUtul4GGYYIdQ1Jwlz/kSlnfpNRsLeVQQy/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FwZwKZGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FwZwKZGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4210C4CEF1;
	Sun,  2 Nov 2025 01:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762048426;
	bh=OSoR+A52Jyhxie9Qg/dzo0L+8Bjra/GYLQkxY5sUJTY=;
	h=From:To:Cc:Subject:Date:From;
	b=FwZwKZGTxjH9D4Fl+dCylFMtvpFY25xdlzZG9lJYyIxkeo7wvXSOxkm1GCa6txet2
	 psOuJ/yLO8mFSODL4xDqMqooYFxNK7WmNwDrD67x4rGrUk0OuDXPTuovbTFt2DzBN3
	 TqhRyv7Uz1YDMZzVvWE4qqE/aQZAvSL864EjsjkEKvzk0/XT5ri+8mtYJS9coHSe4Y
	 mTScBIg/WDh/LS4av6xXb7NCSQna0iHxcz/+xRmfLYtVAhmul3qrESwASLa8vDpMfL
	 7/fsz+LmyMB58ViEFYrrSzKHL0CV1EkEn/MiWqU371O9VOazIb53DypWjrGIL4tKwp
	 ri+j9+eq6kEqg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: x86/aes-gcm-vaes-avx2 - initialize full %rax return register
Date: Sat,  1 Nov 2025 18:52:56 -0700
Message-ID: <20251102015256.171536-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update aes_gcm_dec_final_vaes_avx2() to be consistent with
aes_gcm_dec_final_aesni() and aes_gcm_dec_final_vaes_avx512() by
initializing the full %rax return register instead of just %al.
Technically this is unnecessary, since these functions return bool.  But
I think it's worth being extra careful with the result of the tag
comparison and also keeping the different implementations consistent.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 arch/x86/crypto/aes-gcm-vaes-avx2.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/aes-gcm-vaes-avx2.S b/arch/x86/crypto/aes-gcm-vaes-avx2.S
index d9754e683bde..93c9504a488f 100644
--- a/arch/x86/crypto/aes-gcm-vaes-avx2.S
+++ b/arch/x86/crypto/aes-gcm-vaes-avx2.S
@@ -1121,10 +1121,11 @@ SYM_FUNC_END(aes_gcm_aad_update_vaes_avx2)
 	vpxor		(%rax), GHASH_ACC, GHASH_ACC
 	vaesenclast	GHASH_ACC, %xmm0, %xmm0
 	lea		.Lselect_high_bytes_table(%rip), %rax
 	vmovdqu		(%rax, TAGLEN64), %xmm1
 	vpshufb		BSWAP_MASK, %xmm1, %xmm1 // select low bytes, not high
+	xor		%eax, %eax
 	vptest		%xmm1, %xmm0
 	sete		%al
 .endif
 	// No need for vzeroupper here, since only used xmm registers were used.
 	RET

base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9
-- 
2.51.2

