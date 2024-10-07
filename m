Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BE8168C7
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264298; cv=none; b=PI9xx0ySvJrcUushmRVplfJuj69crsoa8Vb2UYTsVn/EtqCylyEwDKPwKYwghQ/cRV7/kDstxszki1vomKMj1oDqw6iG4gnmi1pMlI/cxruufa+EZgjfNkbjbdfki9OBbe4AUeoG/ceGlNrdYu7WQXCxmnFRrAwznkWGn9oV6g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264298; c=relaxed/simple;
	bh=gInMbYGUdgv9AowtvjI8ndZgLAUiybRpck554YHWjbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srTH1+geEkGgDw7DodwMc2tVYdkfRDB8VmadOL7wbYiejFlgH6RUAwL474hpoqEZ28JUlyL778opNZ8w9q2OKa6Kg0BNpIRMbm7Q1HQaNRnKgxkQqPypISP6L5Mz/8H651kcFLY7v0lsDGcSlA+RoX2aUoi5gFJrJOYhtIjEkTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ke7NYULm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ke7NYULm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A558C4CECF;
	Mon,  7 Oct 2024 01:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264298;
	bh=gInMbYGUdgv9AowtvjI8ndZgLAUiybRpck554YHWjbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ke7NYULmpi8xONzgyh3hrw04wQ06gkVa9k4pGfC05LA+b7KEXV/eR3rUjkQP7Kvfl
	 GLYyes23gW6eEqLHCi5NHCk1hiy0AeuFmAelLsA93Ykwiq3lC5QMAPl9HbYhtvSeG0
	 9mciIe/fAtIR3WsP5JSjwx0KoHJq70HAz0ePaO8G8UlljE5t4vxQgI+DvSeQfCooNo
	 VMjCmPDb5B5w64kpb80LrYO7IL5jGVRIyqB8ZZBg/NbzXoDa9glb3w8iU3TtPKW7cB
	 xOYfO5VzyvmLa29l8+jY7+87/a3b+M9pSKIWO4yB482DJnnW/KCldopR8ojTzpD0LW
	 dt9lR/32zMzYA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 09/10] crypto: x86/aegis128 - remove unneeded FRAME_BEGIN and FRAME_END
Date: Sun,  6 Oct 2024 18:24:29 -0700
Message-ID: <20241007012430.163606-10-ebiggers@kernel.org>
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

Stop using FRAME_BEGIN and FRAME_END in the AEGIS assembly functions,
since all these functions are now leaf functions.  This eliminates some
unnecessary instructions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S | 34 ----------------------------
 1 file changed, 34 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index 583e4515e1f1..e025c6bfadbd 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -6,11 +6,10 @@
  * Copyright (C) 2017-2018 Red Hat, Inc. All rights reserved.
  * Copyright 2024 Google LLC
  */
 
 #include <linux/linkage.h>
-#include <asm/frame.h>
 
 #define STATE0	%xmm0
 #define STATE1	%xmm1
 #define STATE2	%xmm2
 #define STATE3	%xmm3
@@ -144,11 +143,10 @@
  */
 SYM_FUNC_START(aegis128_aesni_init)
 	.set STATEP, %rdi
 	.set KEYP, %rsi
 	.set IVP, %rdx
-	FRAME_BEGIN
 
 	/* load IV: */
 	movdqu (IVP), T1
 
 	/* load key: */
@@ -180,12 +178,10 @@ SYM_FUNC_START(aegis128_aesni_init)
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-
-	FRAME_END
 	RET
 SYM_FUNC_END(aegis128_aesni_init)
 
 /*
  * void aegis128_aesni_ad(struct aegis_state *state, const u8 *data,
@@ -195,11 +191,10 @@ SYM_FUNC_END(aegis128_aesni_init)
  */
 SYM_FUNC_START(aegis128_aesni_ad)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set LEN, %edx
-	FRAME_BEGIN
 
 	test LEN, LEN
 	jz .Lad_out
 
 	/* load the state: */
@@ -249,51 +244,45 @@ SYM_FUNC_START(aegis128_aesni_ad)
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lad_out_1:
 	movdqu STATE4, 0x00(STATEP)
 	movdqu STATE0, 0x10(STATEP)
 	movdqu STATE1, 0x20(STATEP)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lad_out_2:
 	movdqu STATE3, 0x00(STATEP)
 	movdqu STATE4, 0x10(STATEP)
 	movdqu STATE0, 0x20(STATEP)
 	movdqu STATE1, 0x30(STATEP)
 	movdqu STATE2, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lad_out_3:
 	movdqu STATE2, 0x00(STATEP)
 	movdqu STATE3, 0x10(STATEP)
 	movdqu STATE4, 0x20(STATEP)
 	movdqu STATE0, 0x30(STATEP)
 	movdqu STATE1, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lad_out_4:
 	movdqu STATE1, 0x00(STATEP)
 	movdqu STATE2, 0x10(STATEP)
 	movdqu STATE3, 0x20(STATEP)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lad_out:
-	FRAME_END
 	RET
 SYM_FUNC_END(aegis128_aesni_ad)
 
 .macro encrypt_block s0 s1 s2 s3 s4 i
 	movdqu (\i * 0x10)(SRC), MSG
@@ -321,11 +310,10 @@ SYM_FUNC_END(aegis128_aesni_ad)
 SYM_FUNC_START(aegis128_aesni_enc)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
 	.set LEN, %ecx
-	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
@@ -349,51 +337,45 @@ SYM_FUNC_START(aegis128_aesni_enc)
 	movdqu STATE4, 0x00(STATEP)
 	movdqu STATE0, 0x10(STATEP)
 	movdqu STATE1, 0x20(STATEP)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lenc_out_1:
 	movdqu STATE3, 0x00(STATEP)
 	movdqu STATE4, 0x10(STATEP)
 	movdqu STATE0, 0x20(STATEP)
 	movdqu STATE1, 0x30(STATEP)
 	movdqu STATE2, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lenc_out_2:
 	movdqu STATE2, 0x00(STATEP)
 	movdqu STATE3, 0x10(STATEP)
 	movdqu STATE4, 0x20(STATEP)
 	movdqu STATE0, 0x30(STATEP)
 	movdqu STATE1, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lenc_out_3:
 	movdqu STATE1, 0x00(STATEP)
 	movdqu STATE2, 0x10(STATEP)
 	movdqu STATE3, 0x20(STATEP)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lenc_out_4:
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Lenc_out:
-	FRAME_END
 	RET
 SYM_FUNC_END(aegis128_aesni_enc)
 
 /*
  * void aegis128_aesni_enc_tail(struct aegis_state *state, const u8 *src,
@@ -402,11 +384,10 @@ SYM_FUNC_END(aegis128_aesni_enc)
 SYM_FUNC_START(aegis128_aesni_enc_tail)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
 	.set LEN, %ecx	/* {load,store}_partial rely on this being %ecx */
-	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
@@ -434,12 +415,10 @@ SYM_FUNC_START(aegis128_aesni_enc_tail)
 	movdqu STATE4, 0x00(STATEP)
 	movdqu STATE0, 0x10(STATEP)
 	movdqu STATE1, 0x20(STATEP)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
-
-	FRAME_END
 	RET
 SYM_FUNC_END(aegis128_aesni_enc_tail)
 
 .macro decrypt_block s0 s1 s2 s3 s4 i
 	movdqu (\i * 0x10)(SRC), MSG
@@ -466,11 +445,10 @@ SYM_FUNC_END(aegis128_aesni_enc_tail)
 SYM_FUNC_START(aegis128_aesni_dec)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
 	.set LEN, %ecx
-	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
@@ -494,51 +472,45 @@ SYM_FUNC_START(aegis128_aesni_dec)
 	movdqu STATE4, 0x00(STATEP)
 	movdqu STATE0, 0x10(STATEP)
 	movdqu STATE1, 0x20(STATEP)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Ldec_out_1:
 	movdqu STATE3, 0x00(STATEP)
 	movdqu STATE4, 0x10(STATEP)
 	movdqu STATE0, 0x20(STATEP)
 	movdqu STATE1, 0x30(STATEP)
 	movdqu STATE2, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Ldec_out_2:
 	movdqu STATE2, 0x00(STATEP)
 	movdqu STATE3, 0x10(STATEP)
 	movdqu STATE4, 0x20(STATEP)
 	movdqu STATE0, 0x30(STATEP)
 	movdqu STATE1, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Ldec_out_3:
 	movdqu STATE1, 0x00(STATEP)
 	movdqu STATE2, 0x10(STATEP)
 	movdqu STATE3, 0x20(STATEP)
 	movdqu STATE4, 0x30(STATEP)
 	movdqu STATE0, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Ldec_out_4:
 	movdqu STATE0, 0x00(STATEP)
 	movdqu STATE1, 0x10(STATEP)
 	movdqu STATE2, 0x20(STATEP)
 	movdqu STATE3, 0x30(STATEP)
 	movdqu STATE4, 0x40(STATEP)
-	FRAME_END
 	RET
 
 .Ldec_out:
-	FRAME_END
 	RET
 SYM_FUNC_END(aegis128_aesni_dec)
 
 /*
  * void aegis128_aesni_dec_tail(struct aegis_state *state, const u8 *src,
@@ -547,11 +519,10 @@ SYM_FUNC_END(aegis128_aesni_dec)
 SYM_FUNC_START(aegis128_aesni_dec_tail)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
 	.set LEN, %ecx	/* {load,store}_partial rely on this being %ecx */
-	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
@@ -584,12 +555,10 @@ SYM_FUNC_START(aegis128_aesni_dec_tail)
 	movdqu STATE4, 0x00(STATEP)
 	movdqu STATE0, 0x10(STATEP)
 	movdqu STATE1, 0x20(STATEP)
 	movdqu STATE2, 0x30(STATEP)
 	movdqu STATE3, 0x40(STATEP)
-
-	FRAME_END
 	RET
 SYM_FUNC_END(aegis128_aesni_dec_tail)
 
 /*
  * void aegis128_aesni_final(struct aegis_state *state,
@@ -599,11 +568,10 @@ SYM_FUNC_END(aegis128_aesni_dec_tail)
 SYM_FUNC_START(aegis128_aesni_final)
 	.set STATEP, %rdi
 	.set TAG_XOR, %rsi
 	.set ASSOCLEN, %edx
 	.set CRYPTLEN, %ecx
-	FRAME_BEGIN
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
@@ -634,9 +602,7 @@ SYM_FUNC_START(aegis128_aesni_final)
 	pxor STATE2, MSG
 	pxor STATE3, MSG
 	pxor STATE4, MSG
 
 	movdqu MSG, (TAG_XOR)
-
-	FRAME_END
 	RET
 SYM_FUNC_END(aegis128_aesni_final)
-- 
2.46.2

