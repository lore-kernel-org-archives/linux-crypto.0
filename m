Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A63F10A1C
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264297; cv=none; b=VjeCnQEP4LWFP4fUUgncK7WSFJd0RrKwWigpuTOILFjiWVVYWDyriUFCGLAc/6g4lg+zGhOWy1ttMlujBGjaR73DhAUG96je6EtU1oWve/GKQYnmr5Lf9LcsWFnO9/QxJC7R1ROv8gQas8Ovv30jCo8PKKPdenz5mtgEWA0sj4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264297; c=relaxed/simple;
	bh=UQ5z+M013V+7Q3EhUtmWmtTjR4pQo9By567fNgUaNWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oa1RqhrzhEp2HfLLhLq7TsHc3eV+5cVSlL1FLtzZlLcBAaOewm9SOCdlqnkyMJE5u+6Aq+3RPwdq125LCag1MoQTA883G1G3FUdVF2PI+IKxIzbAe2k7FWW36bT0vn1l0djKM+U7Tq3Ug0eqF/EkiRrN9+q8GF8LBYSrRjlPWuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QemuRG2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QemuRG2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ABFC4CECC;
	Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264296;
	bh=UQ5z+M013V+7Q3EhUtmWmtTjR4pQo9By567fNgUaNWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QemuRG2YytQL4/K99qiB8t11XgHEOcsxVxW2ChAdKqCzm5fi73imxP5CTIFC+V69r
	 2etbOEbuYaRQugmJbJo4WkQvBw+C+qKWNccXfb+AZJ9ol0IhMJ4rGj5OPKCFdwQ3lC
	 ZjyV02vPQ8camU769Jfs30EMFCt/FP4BFoQ4N9bU1vICCl+Lne6MI0UEEFv96QnRWY
	 M9x3tIY0nu5+6h7m6DixoRTARzFR88lZsJvVVoP5AE12tO3UzxkOPvk5Wuwf9lu1Wo
	 OSWuslswh0KIKab/GGfe3oelOiQnQQIS0tqM7F+6g/lAcaRoj1i3fOeXD3vV9wTfsd
	 810l+IDp04P5A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 04/10] crypto: x86/aegis128 - don't bother with special code for aligned data
Date: Sun,  6 Oct 2024 18:24:24 -0700
Message-ID: <20241007012430.163606-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241007012430.163606-1-ebiggers@kernel.org>
References: <20241007012430.163606-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove the AEGIS assembly code paths that were "optimized" to operate on
16-byte aligned data using movdqa, and instead just use the code paths
that use movdqu and can handle data with any alignment.

This does not reduce performance.  movdqa is basically a historical
artifact; on aligned data, movdqu and movdqa have had the same
performance since Intel Nehalem (2008) and AMD Bulldozer (2011).  And
code that requires AES-NI cannot run on CPUs older than those anyway.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 122 +++++----------------------
 1 file changed, 22 insertions(+), 100 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 1b57558548c7..5541aca2fd0d 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -243,56 +243,12 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
-	mov SRC, %r8
-	and $0xF, %r8
-	jnz .Lad_u_loop
-
-.align 8
-.Lad_a_loop:
-	movdqa 0x00(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE4
-	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_1
-
-	movdqa 0x10(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE3
-	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_2
-
-	movdqa 0x20(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE2
-	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_3
-
-	movdqa 0x30(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE1
-	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_4
-
-	movdqa 0x40(SRC), MSG
-	aegis128_update
-	pxor MSG, STATE0
-	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_0
-
-	add $0x50, SRC
-	jmp .Lad_a_loop
-
 .align 8
-.Lad_u_loop:
+.Lad_loop:
 	movdqu 0x00(SRC), MSG
 	aegis128_update
 	pxor MSG, STATE4
 	sub $0x10, LEN
 	cmp $0x10, LEN
@@ -325,11 +281,11 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 	sub $0x10, LEN
 	cmp $0x10, LEN
 	jl .Lad_out_0
 
 	add $0x50, SRC
-	jmp .Lad_u_loop
+	jmp .Lad_loop
 
 	/* store the state: */
 .Lad_out_0:
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
@@ -378,19 +334,19 @@ SYM_FUNC_START(crypto_aegis128_aesni_ad)
 .Lad_out:
 	FRAME_END
 	RET
 SYM_FUNC_END(crypto_aegis128_aesni_ad)
 
-.macro encrypt_block a s0 s1 s2 s3 s4 i
-	movdq\a (\i * 0x10)(SRC), MSG
+.macro encrypt_block s0 s1 s2 s3 s4 i
+	movdqu (\i * 0x10)(SRC), MSG
 	movdqa MSG, T0
 	pxor \s1, T0
 	pxor \s4, T0
 	movdqa \s2, T1
 	pand \s3, T1
 	pxor T1, T0
-	movdq\a T0, (\i * 0x10)(DST)
+	movdqu T0, (\i * 0x10)(DST)
 
 	aegis128_update
 	pxor MSG, \s4
 
 	sub $0x10, LEN
@@ -413,38 +369,21 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc)
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
-	mov  SRC,  %r8
-	or   DST,  %r8
-	and $0xF, %r8
-	jnz .Lenc_u_loop
-
 .align 8
-.Lenc_a_loop:
-	encrypt_block a STATE0 STATE1 STATE2 STATE3 STATE4 0
-	encrypt_block a STATE4 STATE0 STATE1 STATE2 STATE3 1
-	encrypt_block a STATE3 STATE4 STATE0 STATE1 STATE2 2
-	encrypt_block a STATE2 STATE3 STATE4 STATE0 STATE1 3
-	encrypt_block a STATE1 STATE2 STATE3 STATE4 STATE0 4
+.Lenc_loop:
+	encrypt_block STATE0 STATE1 STATE2 STATE3 STATE4 0
+	encrypt_block STATE4 STATE0 STATE1 STATE2 STATE3 1
+	encrypt_block STATE3 STATE4 STATE0 STATE1 STATE2 2
+	encrypt_block STATE2 STATE3 STATE4 STATE0 STATE1 3
+	encrypt_block STATE1 STATE2 STATE3 STATE4 STATE0 4
 
 	add $0x50, SRC
 	add $0x50, DST
-	jmp .Lenc_a_loop
-
-.align 8
-.Lenc_u_loop:
-	encrypt_block u STATE0 STATE1 STATE2 STATE3 STATE4 0
-	encrypt_block u STATE4 STATE0 STATE1 STATE2 STATE3 1
-	encrypt_block u STATE3 STATE4 STATE0 STATE1 STATE2 2
-	encrypt_block u STATE2 STATE3 STATE4 STATE0 STATE1 3
-	encrypt_block u STATE1 STATE2 STATE3 STATE4 STATE0 4
-
-	add $0x50, SRC
-	add $0x50, DST
-	jmp .Lenc_u_loop
+	jmp .Lenc_loop
 
 	/* store the state: */
 .Lenc_out_0:
 	movdqu STATE4, 0x00(STATEP)
 	movdqu STATE0, 0x10(STATEP)
@@ -533,18 +472,18 @@ SYM_FUNC_START(crypto_aegis128_aesni_enc_tail)
 
 	FRAME_END
 	RET
 SYM_FUNC_END(crypto_aegis128_aesni_enc_tail)
 
-.macro decrypt_block a s0 s1 s2 s3 s4 i
-	movdq\a (\i * 0x10)(SRC), MSG
+.macro decrypt_block s0 s1 s2 s3 s4 i
+	movdqu (\i * 0x10)(SRC), MSG
 	pxor \s1, MSG
 	pxor \s4, MSG
 	movdqa \s2, T1
 	pand \s3, T1
 	pxor T1, MSG
-	movdq\a MSG, (\i * 0x10)(DST)
+	movdqu MSG, (\i * 0x10)(DST)
 
 	aegis128_update
 	pxor MSG, \s4
 
 	sub $0x10, LEN
@@ -567,38 +506,21 @@ SYM_FUNC_START(crypto_aegis128_aesni_dec)
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
 	movdqu 0x40(STATEP), STATE4
 
-	mov  SRC, %r8
-	or   DST, %r8
-	and $0xF, %r8
-	jnz .Ldec_u_loop
-
-.align 8
-.Ldec_a_loop:
-	decrypt_block a STATE0 STATE1 STATE2 STATE3 STATE4 0
-	decrypt_block a STATE4 STATE0 STATE1 STATE2 STATE3 1
-	decrypt_block a STATE3 STATE4 STATE0 STATE1 STATE2 2
-	decrypt_block a STATE2 STATE3 STATE4 STATE0 STATE1 3
-	decrypt_block a STATE1 STATE2 STATE3 STATE4 STATE0 4
-
-	add $0x50, SRC
-	add $0x50, DST
-	jmp .Ldec_a_loop
-
 .align 8
-.Ldec_u_loop:
-	decrypt_block u STATE0 STATE1 STATE2 STATE3 STATE4 0
-	decrypt_block u STATE4 STATE0 STATE1 STATE2 STATE3 1
-	decrypt_block u STATE3 STATE4 STATE0 STATE1 STATE2 2
-	decrypt_block u STATE2 STATE3 STATE4 STATE0 STATE1 3
-	decrypt_block u STATE1 STATE2 STATE3 STATE4 STATE0 4
+.Ldec_loop:
+	decrypt_block STATE0 STATE1 STATE2 STATE3 STATE4 0
+	decrypt_block STATE4 STATE0 STATE1 STATE2 STATE3 1
+	decrypt_block STATE3 STATE4 STATE0 STATE1 STATE2 2
+	decrypt_block STATE2 STATE3 STATE4 STATE0 STATE1 3
+	decrypt_block STATE1 STATE2 STATE3 STATE4 STATE0 4
 
 	add $0x50, SRC
 	add $0x50, DST
-	jmp .Ldec_u_loop
+	jmp .Ldec_loop
 
 	/* store the state: */
 .Ldec_out_0:
 	movdqu STATE4, 0x00(STATEP)
 	movdqu STATE0, 0x10(STATEP)
-- 
2.46.2

