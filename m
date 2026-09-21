Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA8E353A73;
	Mon, 21 Sep 2026 05:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789967767; cv=none; b=PbzR/gDfKObJ6F38/NSSPfGj5Br8O28Hvz8xX6oy8LJrUYQXlflnOgh9FOsY+XkZ+HgIfMjb2mHMqjVD7bdBhR2+hpn/Cib93cz0BCqoQ5/wd8yH2AnxqrI5BrTfFlOD7/vWMzUqyyxypf3mfLIP6OBupoBa3ZGeUyIhkPVrdAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789967767; c=relaxed/simple;
	bh=QSGclspbdogYLNXd2D/CGLmcjTmFgs8Ctczq1o/lxCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN4v3KswfrNA+AhfDiqjyjDtroG5MN5Tu2vUx/HFFFrcUhYIFvYm+k7epuKmsTfUhS5jHovhMwVyV0sl9RhVkV5eOQwlPA1oUQRldNSJEOH2QfNkkAoP4WN5R+GtKafDIKcbsLI9VraImrCoXt9U2klcdvC+wXTa2LEngCTMOPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P7l4EyBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P7l4EyBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986741F0089B;
	Mon, 21 Sep 2026 05:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789967764;
	bh=fcL/+D9vU7MNcdq0qTxGI6yjDteWwVjrF1tAzNkzGWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7l4EyBCuYa26EerE8ZpkxwLraZtPIt3oIip9jfGw/C6iMPifu36hmD1ZWVtDV+7l
	 XvbfzLBZpRw19V/zitmPV9xvaEQUmPSVwWi6IUF/7w5bRQN2KYEtHCycd45bkmFZpA
	 DYcYvCbc08FPBgVF3Y4/CJhklroVKAcciqIAgDRg37bI5ZNRi7iJgqVUTqhWip+MFO
	 OdhAxZGoSKot0M8YoPiu0uVvanWqFabS8O17Ueu/LI8aaM+uDmQmVgvDKbnUw0ZaF3
	 3KScqEdD7RiHV94XAVdcxY9oNfZSJzdVPfDDHiSWVjNbSHiuQo2vTjOm0Q0CJwP477
	 +t0SwP2m6w5+g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	linux-riscv@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 04/20] lib/crypto: x86/aes-ecb: Add AES-NI optimization
Date: Sun, 20 Sep 2026 22:08:50 -0700
Message-ID: <20260921050910.296144-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921050910.296144-1-ebiggers@kernel.org>
References: <20260921050910.296144-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Optimize the crypto library's AES-ECB support with AES-NI, making its
performance be at least at parity with the "ecb-aes-aesni" skcipher
algorithm that it will supersede.

The new assembly functions are written from scratch to fit well into the
crypto library.  However, they are functionally very similar to the
functions in arch/x86/crypto/aesni-intel_asm.S that they will supersede
and are intended to provide parity with those -- including supporting
32-bit mode, having the inner loops do 4 AES blocks per iteration, etc.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/aes.c               |  2 +-
 lib/crypto/x86/aes-aesni.S | 54 ++++++++++++++++++++++++++++++++++++++
 lib/crypto/x86/aes.h       | 33 +++++++++++++++++++++++
 3 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/crypto/aes.c b/crypto/aes.c
index e6ba3899d868..5a97dc812e8b 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -610,7 +610,7 @@ static struct skcipher_alg skcipher_algs[] = {
 	{
 		.base.cra_name = "ecb(aes)",
 		.base.cra_driver_name = "ecb-aes-lib",
-		.base.cra_priority = 110,
+		.base.cra_priority = IS_ENABLED(CONFIG_X86) ? 300 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_key),
 		.base.cra_module = THIS_MODULE,
diff --git a/lib/crypto/x86/aes-aesni.S b/lib/crypto/x86/aes-aesni.S
index 90a3765d35b8..fdb2917deb59 100644
--- a/lib/crypto/x86/aes-aesni.S
+++ b/lib/crypto/x86/aes-aesni.S
@@ -348,3 +348,57 @@ SYM_FUNC_END(aes_encrypt_aesni)
 SYM_FUNC_START(aes_decrypt_aesni)
 	_aes_crypt_aesni	0
 SYM_FUNC_END(aes_decrypt_aesni)
+
+.macro	_ecb_crypt	enc
+	// Arguments
+	.set	DST,		ARG0
+	.set	SRC,		ARG1
+	.set	NBLOCKS,	ARG2
+	.set	NBLOCKS32,	ARG2_32	// Used for improved code density
+	.set	KEY,		ARG3
+
+	// Other local variables
+	.set	RNDKEY_PTR,	ARG4	// Temporary register for _do_aes
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
+	.set	AESDATA0,	%xmm0
+	.set	AESDATA1,	%xmm1
+	.set	AESDATA2,	%xmm2
+	.set	AESDATA3,	%xmm3
+	.set	RNDKEY,		%xmm4	// Temporary register for _do_aes
+	_prologue	uses_arg3=2, uses_arg4=1
+
+	sub		$4, NBLOCKS
+	jl		.Lecb_loop4_done\@
+.p2align 5
+.Lecb_loop4\@:
+	_do_aes_ecb	\enc, 0,1,2,3
+	add		$64, DST
+	add		$64, SRC
+	sub		$4, NBLOCKS
+	jge		.Lecb_loop4\@
+.Lecb_loop4_done\@:
+	add		$4, NBLOCKS32
+	jz		.Lecb_done\@
+
+.Lecb_loop1\@:
+	_do_aes_ecb	\enc, 0
+	add		$16, DST
+	add		$16, SRC
+	dec		NBLOCKS32
+	jnz		.Lecb_loop1\@
+
+.Lecb_done\@:
+	_epilogue
+.endm
+
+// void aes_ecb_encrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+//			      const struct aes_enckey *key);
+SYM_FUNC_START(aes_ecb_encrypt_aesni)
+	_ecb_crypt	1
+SYM_FUNC_END(aes_ecb_encrypt_aesni)
+
+// void aes_ecb_decrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+//			      const struct aes_key *key);
+SYM_FUNC_START(aes_ecb_decrypt_aesni)
+	_ecb_crypt	0
+SYM_FUNC_END(aes_ecb_decrypt_aesni)
diff --git a/lib/crypto/x86/aes.h b/lib/crypto/x86/aes.h
index 06146fef06be..9ad4a84f0378 100644
--- a/lib/crypto/x86/aes.h
+++ b/lib/crypto/x86/aes.h
@@ -81,6 +81,39 @@ static void aes_decrypt_arch(const struct aes_key *key,
 	}
 }
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_ECB)
+void aes_ecb_encrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+			   const struct aes_enckey *key);
+void aes_ecb_decrypt_aesni(u8 *dst, const u8 *src, long nblocks,
+			   const struct aes_key *key);
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_ecb_encrypt_arch aes_ecb_encrypt_arch
+static bool aes_ecb_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_enckey *key)
+{
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+	kernel_fpu_begin();
+	aes_ecb_encrypt_aesni(dst, src, len / AES_BLOCK_SIZE, key);
+	kernel_fpu_end();
+	return true;
+}
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+#define aes_ecb_decrypt_arch aes_ecb_decrypt_arch
+static bool aes_ecb_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 const struct aes_key *key)
+{
+	if (!static_branch_likely(&have_aesni) || unlikely(!irq_fpu_usable()))
+		return false;
+	kernel_fpu_begin();
+	aes_ecb_decrypt_aesni(dst, src, len / AES_BLOCK_SIZE, key);
+	kernel_fpu_end();
+	return true;
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_ECB */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
-- 
2.55.0

