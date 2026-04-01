Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDA81C861D;
	Wed,  1 Apr 2026 00:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775004277; cv=none; b=S3+uiPMoA3omKR+g3TAdhxViOnEBL7aoLhOs6JMbqJUR3BUnjo/btv/207D2jtJI+jxql33mEJHfIyhDKJwd24Kbu1SvinxUgPLulpSebFGactpvwoJ789oMvpYLiHnzAz7jsA/Jd/XXRfZnQbFCjFwEBRSjcPXklPcuwFzcn1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775004277; c=relaxed/simple;
	bh=t9YRv1FqbSlnih+jiMm26EVjV/zSLNM1/2jxkIcSIjs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aYEUWNFg1EABT/LwFvurfoF/iU/ivoG3ShQmI7vVI91e1aVb/p1uPL396j2t61M1mMS836Hr8PNUBIQNC7fEGbwBztdqWWJnF6l7GmbCjMxAL8abM/Y0QkhmLH3e7lgzC2f8b7FEo369xOmxVdUav0+CIlg8n0bfP8Qn+nJsCmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ERvBGU2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ERvBGU2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4780C19423;
	Wed,  1 Apr 2026 00:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775004276;
	bh=t9YRv1FqbSlnih+jiMm26EVjV/zSLNM1/2jxkIcSIjs=;
	h=From:To:Cc:Subject:Date:From;
	b=ERvBGU2NLCwuIPnM0xNf5xHUWYs8lLiFAMvnctaKqOI4d8PhhNaRPsPUfjsX8dY2+
	 pI3SzoCS0DtOm/SZnfYT80dczPAyx85cS+P1AEngy2TZRxt1tTJZ1bP3rTb3gb6cy5
	 eiFrxPCurR5Q9X2DKq8/H4RAlZ3Q6NXLX6/DMmgZfrCX1/V8CagNPR+KVHF3ZLpPhE
	 RaLW1bNyKlUdt4+79UzYC5brz0OWpfXcUmOBOsBSQaj/woYgJ+VC95snOmqSz5zjA7
	 E5KEds5pKtTgw11l1jmpcKqAMbYgGjk1kxAWv1DhrE3BzUwBeZmxrhw5rQ5hf9FtlF
	 SoP9duTZWsnwg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crc: arm64: Assume a little-endian kernel
Date: Tue, 31 Mar 2026 17:44:31 -0700
Message-ID: <20260401004431.151432-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since support for big-endian arm64 kernels was removed, the CPU_LE()
macro now unconditionally emits the code it is passed, and the CPU_BE()
macro now unconditionally discards the code it is passed.

Simplify the assembly code in lib/crc/arm64/ accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting crc-next

 lib/crc/arm64/crc-t10dif-core.S | 56 ++++++++++++++++-----------------
 lib/crc/arm64/crc32-core.S      |  9 ++----
 2 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/lib/crc/arm64/crc-t10dif-core.S b/lib/crc/arm64/crc-t10dif-core.S
index 87dd6d46224d8..71388466825b9 100644
--- a/lib/crc/arm64/crc-t10dif-core.S
+++ b/lib/crc/arm64/crc-t10dif-core.S
@@ -179,17 +179,17 @@ SYM_FUNC_END(__pmull_p8_16x64)
 	.macro		fold_32_bytes, p, reg1, reg2
 	ldp		q11, q12, [buf], #0x20
 
 	pmull16x64_\p	fold_consts, \reg1, v8
 
-CPU_LE(	rev64		v11.16b, v11.16b		)
-CPU_LE(	rev64		v12.16b, v12.16b		)
+	rev64		v11.16b, v11.16b
+	rev64		v12.16b, v12.16b
 
 	pmull16x64_\p	fold_consts, \reg2, v9
 
-CPU_LE(	ext		v11.16b, v11.16b, v11.16b, #8	)
-CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
+	ext		v11.16b, v11.16b, v11.16b, #8
+	ext		v12.16b, v12.16b, v12.16b, #8
 
 	eor		\reg1\().16b, \reg1\().16b, v8.16b
 	eor		\reg2\().16b, \reg2\().16b, v9.16b
 	eor		\reg1\().16b, \reg1\().16b, v11.16b
 	eor		\reg2\().16b, \reg2\().16b, v12.16b
@@ -218,26 +218,26 @@ CPU_LE(	ext		v12.16b, v12.16b, v12.16b, #8	)
 	ldp		q0, q1, [buf]
 	ldp		q2, q3, [buf, #0x20]
 	ldp		q4, q5, [buf, #0x40]
 	ldp		q6, q7, [buf, #0x60]
 	add		buf, buf, #0x80
-CPU_LE(	rev64		v0.16b, v0.16b			)
-CPU_LE(	rev64		v1.16b, v1.16b			)
-CPU_LE(	rev64		v2.16b, v2.16b			)
-CPU_LE(	rev64		v3.16b, v3.16b			)
-CPU_LE(	rev64		v4.16b, v4.16b			)
-CPU_LE(	rev64		v5.16b, v5.16b			)
-CPU_LE(	rev64		v6.16b, v6.16b			)
-CPU_LE(	rev64		v7.16b, v7.16b			)
-CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
-CPU_LE(	ext		v1.16b, v1.16b, v1.16b, #8	)
-CPU_LE(	ext		v2.16b, v2.16b, v2.16b, #8	)
-CPU_LE(	ext		v3.16b, v3.16b, v3.16b, #8	)
-CPU_LE(	ext		v4.16b, v4.16b, v4.16b, #8	)
-CPU_LE(	ext		v5.16b, v5.16b, v5.16b, #8	)
-CPU_LE(	ext		v6.16b, v6.16b, v6.16b, #8	)
-CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
+	rev64		v0.16b, v0.16b
+	rev64		v1.16b, v1.16b
+	rev64		v2.16b, v2.16b
+	rev64		v3.16b, v3.16b
+	rev64		v4.16b, v4.16b
+	rev64		v5.16b, v5.16b
+	rev64		v6.16b, v6.16b
+	rev64		v7.16b, v7.16b
+	ext		v0.16b, v0.16b, v0.16b, #8
+	ext		v1.16b, v1.16b, v1.16b, #8
+	ext		v2.16b, v2.16b, v2.16b, #8
+	ext		v3.16b, v3.16b, v3.16b, #8
+	ext		v4.16b, v4.16b, v4.16b, #8
+	ext		v5.16b, v5.16b, v5.16b, #8
+	ext		v6.16b, v6.16b, v6.16b, #8
+	ext		v7.16b, v7.16b, v7.16b, #8
 
 	// XOR the first 16 data *bits* with the initial CRC value.
 	movi		v8.16b, #0
 	mov		v8.h[7], init_crc
 	eor		v0.16b, v0.16b, v8.16b
@@ -286,12 +286,12 @@ CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
 	b.lt		.Lfold_16_bytes_loop_done_\@
 .Lfold_16_bytes_loop_\@:
 	pmull16x64_\p	fold_consts, v7, v8
 	eor		v7.16b, v7.16b, v8.16b
 	ldr		q0, [buf], #16
-CPU_LE(	rev64		v0.16b, v0.16b			)
-CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
+	rev64		v0.16b, v0.16b
+	ext		v0.16b, v0.16b, v0.16b, #8
 	eor		v7.16b, v7.16b, v0.16b
 	subs		len, len, #16
 	b.ge		.Lfold_16_bytes_loop_\@
 
 .Lfold_16_bytes_loop_done_\@:
@@ -308,12 +308,12 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 	// chunk of 16 bytes, then fold the first chunk into the second.
 
 	// v0 = last 16 original data bytes
 	add		buf, buf, len
 	ldr		q0, [buf, #-16]
-CPU_LE(	rev64		v0.16b, v0.16b			)
-CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
+	rev64		v0.16b, v0.16b
+	ext		v0.16b, v0.16b, v0.16b, #8
 
 	// v1 = high order part of second chunk: v7 left-shifted by 'len' bytes.
 	adr_l		x4, .Lbyteshift_table + 16
 	sub		x4, x4, len
 	ld1		{v2.16b}, [x4]
@@ -342,12 +342,12 @@ CPU_LE(	ext		v0.16b, v0.16b, v0.16b, #8	)
 
 	adr_l		fold_consts_ptr, .Lfold_across_16_bytes_consts
 
 	// Load the first 16 data bytes.
 	ldr		q7, [buf], #0x10
-CPU_LE(	rev64		v7.16b, v7.16b			)
-CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
+	rev64		v7.16b, v7.16b
+	ext		v7.16b, v7.16b, v7.16b, #8
 
 	// XOR the first 16 data *bits* with the initial CRC value.
 	movi		v0.16b, #0
 	mov		v0.h[7], init_crc
 	eor		v7.16b, v7.16b, v0.16b
@@ -380,12 +380,12 @@ SYM_FUNC_START(crc_t10dif_pmull_p8)
 	zip1		perm.16b, perm.16b, perm.16b
 	zip1		perm.16b, perm.16b, perm.16b
 
 	crc_t10dif_pmull p8
 
-CPU_LE(	rev64		v7.16b, v7.16b			)
-CPU_LE(	ext		v7.16b, v7.16b, v7.16b, #8	)
+	rev64		v7.16b, v7.16b
+	ext		v7.16b, v7.16b, v7.16b, #8
 	str		q7, [x3]
 
 	frame_pop
 	ret
 SYM_FUNC_END(crc_t10dif_pmull_p8)
diff --git a/lib/crc/arm64/crc32-core.S b/lib/crc/arm64/crc32-core.S
index 68825317460fc..49d02cc485b3e 100644
--- a/lib/crc/arm64/crc32-core.S
+++ b/lib/crc/arm64/crc32-core.S
@@ -27,28 +27,23 @@
 	rbit		\reg, \reg
 	lsr		\reg, \reg, #24
 	.endm
 
 	.macro		hwordle, reg
-CPU_BE(	rev16		\reg, \reg	)
 	.endm
 
 	.macro		hwordbe, reg
-CPU_LE(	rev		\reg, \reg	)
+	rev		\reg, \reg
 	rbit		\reg, \reg
-CPU_BE(	lsr		\reg, \reg, #16	)
 	.endm
 
 	.macro		le, regs:vararg
-	.irp		r, \regs
-CPU_BE(	rev		\r, \r		)
-	.endr
 	.endm
 
 	.macro		be, regs:vararg
 	.irp		r, \regs
-CPU_LE(	rev		\r, \r		)
+	rev		\r, \r
 	.endr
 	.irp		r, \regs
 	rbit		\r, \r
 	.endr
 	.endm

base-commit: 63432fd625372a0e79fb00a4009af204f4edc013
-- 
2.53.0

