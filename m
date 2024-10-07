Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B22171A7
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264298; cv=none; b=lffOSZUlB0XTPUpVtL9qnVVCr2GhS7K1b1YnLeEozPQ+towYSEpTYca6qkH3n4Q2fqWY73UuVysQejcljE5tWqbwvxouieBU05Q/FNk4iiyYLCzDNDQzORH46mrbRSUZ4U8jWm/kFhAyIQveaO8t5rvxuDACfubOXXeiXr8a0hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264298; c=relaxed/simple;
	bh=etMS4ksedaC5t40wm3xvIHtyMMS1+QhxCXZeiCycsME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aso+2nvBANHboC0ME942BSuOIFV+pzJOETz6mQBVFRm+9IHGUnizvuJD/T8aBxcIwBl36/c8rG2lUN0zy39emd0JYyEDN5k3G4uRa0NzHolNfK7JXYEL2wf0JOw3iou3Yr/C+x7qajr3DBL3XIAuHBGuySgl6CXxRjm0iIt1FRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTK5Oci8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTK5Oci8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9792C4CEC5;
	Mon,  7 Oct 2024 01:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264298;
	bh=etMS4ksedaC5t40wm3xvIHtyMMS1+QhxCXZeiCycsME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eTK5Oci8VBRytUcq5Di68aFacGeiZsnqGWBDG7wbqPGpTxk8EhnlNHAh4UqwrdXGw
	 jARd2JGbkvQ1C1pzpuQnmuudjcZndEvBardFR+431M5hLjuuGYDGzZVvI575mD/r3H
	 iYMsK4zFNytjYGmdHJDp86oD0D0TJvclZw0SG247wH97j0BflrtuF7RDNqhPd3vpOk
	 Op1LkS1gGE7c0rt58oiozQKJ4yItfJ0yPfNnhGZdets0QSM7QuLqiJpKfcegb/65hd
	 AE6CIRsXnQF89VdtbP8FlTcVoDu+4TslXPXMOSMpwEn8yb8IttZdLE8NeG3c7YhJfB
	 pFDPmoPwVlEWA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 08/10] crypto: x86/aegis128 - take advantage of block-aligned len
Date: Sun,  6 Oct 2024 18:24:28 -0700
Message-ID: <20241007012430.163606-9-ebiggers@kernel.org>
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

Update a caller of aegis128_aesni_ad() to round down the length to a
block boundary.  After that, aegis128_aesni_ad(), aegis128_aesni_enc(),
and aegis128_aesni_dec() are only passed whole blocks.  Update the
assembly code to take advantage of that, which eliminates some unneeded
instructions.  For aegis128_aesni_enc() and aegis128_aesni_dec(), the
length is also always nonzero, so stop checking for zero length.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-asm.S  | 37 +++++++++++----------------
 arch/x86/crypto/aegis128-aesni-glue.c |  4 +--
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis128-aesni-asm.S
index b5c7abc9a0d4..583e4515e1f1 100644
--- a/arch/x86/crypto/aegis128-aesni-asm.S
+++ b/arch/x86/crypto/aegis128-aesni-asm.S
@@ -188,19 +188,21 @@ SYM_FUNC_START(aegis128_aesni_init)
 SYM_FUNC_END(aegis128_aesni_init)
 
 /*
  * void aegis128_aesni_ad(struct aegis_state *state, const u8 *data,
  *			  unsigned int len);
+ *
+ * len must be a multiple of 16.
  */
 SYM_FUNC_START(aegis128_aesni_ad)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set LEN, %edx
 	FRAME_BEGIN
 
-	cmp $0x10, LEN
-	jb .Lad_out
+	test LEN, LEN
+	jz .Lad_out
 
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
@@ -211,40 +213,35 @@ SYM_FUNC_START(aegis128_aesni_ad)
 .Lad_loop:
 	movdqu 0x00(SRC), MSG
 	aegis128_update
 	pxor MSG, STATE4
 	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_1
+	jz .Lad_out_1
 
 	movdqu 0x10(SRC), MSG
 	aegis128_update
 	pxor MSG, STATE3
 	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_2
+	jz .Lad_out_2
 
 	movdqu 0x20(SRC), MSG
 	aegis128_update
 	pxor MSG, STATE2
 	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_3
+	jz .Lad_out_3
 
 	movdqu 0x30(SRC), MSG
 	aegis128_update
 	pxor MSG, STATE1
 	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_4
+	jz .Lad_out_4
 
 	movdqu 0x40(SRC), MSG
 	aegis128_update
 	pxor MSG, STATE0
 	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lad_out_0
+	jz .Lad_out_0
 
 	add $0x50, SRC
 	jmp .Lad_loop
 
 	/* store the state: */
@@ -310,28 +307,26 @@ SYM_FUNC_END(aegis128_aesni_ad)
 
 	aegis128_update
 	pxor MSG, \s4
 
 	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Lenc_out_\i
+	jz .Lenc_out_\i
 .endm
 
 /*
  * void aegis128_aesni_enc(struct aegis_state *state, const u8 *src, u8 *dst,
  *			   unsigned int len);
+ *
+ * len must be nonzero and a multiple of 16.
  */
 SYM_FUNC_START(aegis128_aesni_enc)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
 	.set LEN, %ecx
 	FRAME_BEGIN
 
-	cmp $0x10, LEN
-	jb .Lenc_out
-
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
@@ -457,28 +452,26 @@ SYM_FUNC_END(aegis128_aesni_enc_tail)
 
 	aegis128_update
 	pxor MSG, \s4
 
 	sub $0x10, LEN
-	cmp $0x10, LEN
-	jl .Ldec_out_\i
+	jz .Ldec_out_\i
 .endm
 
 /*
  * void aegis128_aesni_dec(struct aegis_state *state, const u8 *src, u8 *dst,
  *			   unsigned int len);
+ *
+ * len must be nonzero and a multiple of 16.
  */
 SYM_FUNC_START(aegis128_aesni_dec)
 	.set STATEP, %rdi
 	.set SRC, %rsi
 	.set DST, %rdx
 	.set LEN, %ecx
 	FRAME_BEGIN
 
-	cmp $0x10, LEN
-	jb .Ldec_out
-
 	/* load the state: */
 	movdqu 0x00(STATEP), STATE0
 	movdqu 0x10(STATEP), STATE1
 	movdqu 0x20(STATEP), STATE2
 	movdqu 0x30(STATEP), STATE3
diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 739d92c85790..32a42a7dcd3b 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -85,12 +85,12 @@ static void crypto_aegis128_aesni_process_ad(
 				pos = 0;
 				left -= fill;
 				src += fill;
 			}
 
-			aegis128_aesni_ad(state, src, left);
-
+			aegis128_aesni_ad(state, src,
+					  left & ~(AEGIS128_BLOCK_SIZE - 1));
 			src += left & ~(AEGIS128_BLOCK_SIZE - 1);
 			left &= AEGIS128_BLOCK_SIZE - 1;
 		}
 
 		memcpy(buf.bytes + pos, src, left);
-- 
2.46.2

