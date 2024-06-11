Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F492033E;
	Tue, 11 Jun 2024 21:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718141754; cv=none; b=rOJ7sCrU/gshsyx/joxzrQiOED3zZWz2DhrSmFfhGnNwriiZJCq3BLN+JKSG2//PAH3QBHabOvVtrXpxS6A3hF1I+J6IkIs0L8qrmgp391q3DO66Use8MRH9J8O2E4Ub+zF5edPyVtrsXXOwqwblR1iAzTELmMTO0LnQ9Kr5M34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718141754; c=relaxed/simple;
	bh=8sFiYFure9LC+4hAjl7uzK8RKxuzNzH/pES5CKqmOBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i+F6kHUDA5gvfVT2PFhhHIbYUFpPs29SnP4HJSrdJfE/iRTEASb9BSxF73xS/QaxiCDFjRojgEx1YH5AJrOoWsgIo/ysh4f5BcAQ6wi3GtZLvLrz7IrQJ6cAa2JLRJyiWMuZ3258AREAHG4MyeB3aHZw0tNQNwX7hU9y4NiJuK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fB7p7QF8; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fB7p7QF8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718141751; x=1749677751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8sFiYFure9LC+4hAjl7uzK8RKxuzNzH/pES5CKqmOBE=;
  b=fB7p7QF8PeGIL+bDHYHgqEOcM96yB6dRPBTUllY3U2Sk5ypEtUUsx6el
   aEC3Eo/E3XnWz63gypUC6Um/qSmaH3l/v1ap7iGFzXC+MICm5RQ743N1E
   LhpIseUq0QuqZozsIzOTOf3KXb8g4yYK/4IITRgiqfzt6RLg56TPaPM8m
   /loNXALoJoRnnmqiK0EKwua+OwfwgxiuyMLYCZE76XGjUm+NkPRlxaYpi
   zrs1mDeS/nbBosWhE+fxq7X8Djd1nNDYdOf0XsnM1Z/YCXV1zI5/mOAqH
   DhWUW/xc0uyXohPxBZUYnVzfcuhKL4uwZOnN/m6AS/KSSLu3kciMeoTGe
   w==;
X-CSE-ConnectionGUID: mJedvilySCyAby7vw1aQsg==
X-CSE-MsgGUID: OGlxYsYcTn+bPMaaV5Ji1w==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="32418467"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="32418467"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 14:35:51 -0700
X-CSE-ConnectionGUID: 1VpnPkpQSSKsn6K7Z56bNA==
X-CSE-MsgGUID: uVPU533pTSql/W+NoGzzIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="62744491"
Received: from cbae1-mobl.amr.corp.intel.com (HELO cbae1-mobl.intel.com) ([10.124.132.58])
  by fmviesa002.fm.intel.com with ESMTP; 11 Jun 2024 14:35:49 -0700
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: ebiggers@kernel.org,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	bernie.keany@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH v9b 14/14] crypto: x86/aes-kl - Implement the AES-XTS algorithm
Date: Tue, 11 Jun 2024 14:35:48 -0700
Message-Id: <20240611213548.253079-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531053718.GF6505@sol.localdomain>
References: <20240531053718.GF6505@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Eric,

I really appreciate your review. Keeping track of about 800 lines of
code, including assembly lines, in a single patch is demanding. I hope
this version meets your expectations.

The overall diff can be found here:
  https://github.com/intel-staging/keylocker/compare/f8420d4e27fc..57472d9b3f8e

Thanks,
Chang

---
Key Locker is a CPU feature to reduce key exfiltration opportunities.
It converts the AES key into an encoded form, called 'key handle', to
reduce the exposure of private key material in memory.

This key conversion along with all subsequent data transformations, is
provided by new AES instructions ('AES-KL'). AES-KL is analogous to
that of AES-NI as maintains a similar programming interface.

Support the XTS mode as the primary use case is dm-crypt. The support has
some details worth mentioning, which differentiate itself from AES-NI,
that users may need to be aware of:

== Key Handle Restriction ==

The AES-KL instruction set supports selecting key usage restrictions at
key handle creation time. Restrict all key handles created by the kernel
to kernel mode use only.

Although the AES-KL instructions themselves are executable in userspace,
this restriction enforces the mode consistency in its operation.

If the key handle is created in userspace but referenced in the kernel,
then encrypt() and decrypt() functions will return -EINVAL.

=== AES-NI Dependency for AES Compliance ===

Key Locker is not AES compliant as it lacks 192-bit key support. However,
per the expectations of Linux crypto-cipher implementations, the software
cipher implementation must support all the AES-compliant key sizes.

The AES-KL cipher implementation achieves this constraint by logging a
warning and falling back to AES-NI. In other words, the 192-bit key-size
limitation is documented but not enforced.

== Wrapping Key Restore Failure Handling ==

In the event of hardware failure, the wrapping key is lost from deep
sleep states. Then, the wrapping key turns to zero which is an unusable
state.

The x86 core provides valid_keylocker() to indicate the failure.
Subsequent setkey() as well as encode()/decode() can check it and return
-ENODEV if failed. This allows an error code to be returned instead of
encountering abrupt exceptions.

== Userspace Exposition ==

Keylocker implementations have measurable performance penalties.
Therefore, keep the current default remains the same.

However, with a slow storage device, storage bandwidth is the bottleneck,
even if disk encryption is enabled by AES-KL. Thus, it is up to the end
user to decide whether to use AES-KL. User can select it by the name
'xts-aes-aeskl' shown in /proc/crypto.

== 64-bit Only ==

Support 64-bit only, as the 32-bit kernel is being deprecated.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
Changes from the previous posting (Eric):
* Assembly Code
  - Improve function argument descriptions.
  - Simplify the AES processing macro.
  - Rename some symbols.
* Glue Code:
  - Do not use function pointer variables; direct calls.
  - Define a union for the two 'ctx' structures.
  - Clarify a few code spots with comments.
  - Adjust some variable and struct names.
* Kconfig
  - Separate out the Kconfig.assembler change.
---
 arch/x86/crypto/Kconfig            |  18 ++
 arch/x86/crypto/Makefile           |   3 +
 arch/x86/crypto/aeskl-xts-x86_64.S | 337 ++++++++++++++++++++++++
 arch/x86/crypto/aeskl_glue.c       | 409 +++++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c |  13 +-
 arch/x86/crypto/aesni-xts.h        |  15 ++
 6 files changed, 790 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/crypto/aeskl-xts-x86_64.S
 create mode 100644 arch/x86/crypto/aeskl_glue.c
 create mode 100644 arch/x86/crypto/aesni-xts.h

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index c9e59589a1ce..c45d8f48f24e 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -29,6 +29,24 @@ config CRYPTO_AES_NI_INTEL
 	  Architecture: x86 (32-bit and 64-bit) using:
 	  - AES-NI (AES new instructions)
 
+config CRYPTO_AES_KL
+	tristate "Ciphers: AES, modes: XTS (AES-KL)"
+	depends on X86 && 64BIT
+	depends on AS_KEYLOCKER
+	select CRYPTO_AES_NI_INTEL
+	select CRYPTO_SIMD
+	select X86_KEYLOCKER
+
+	help
+	  Block cipher: AES cipher algorithms
+	  Length-preserving ciphers: AES with XTS
+
+	  Architecture: x86 (64-bit) using:
+	  - AES-KL (AES Key Locker)
+	  - AES-NI for a 192-bit key
+
+	  See Documentation/arch/x86/keylocker.rst for more details.
+
 config CRYPTO_BLOWFISH_X86_64
 	tristate "Ciphers: Blowfish, modes: ECB, CBC"
 	depends on X86 && 64BIT
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 9c5ce5613738..c46fd2d9dd16 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -51,6 +51,9 @@ aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o
 aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o \
 	aes_ctrby8_avx-x86_64.o aes-xts-avx-x86_64.o
 
+obj-$(CONFIG_CRYPTO_AES_KL) += aeskl-x86_64.o
+aeskl-x86_64-y := aeskl-xts-x86_64.o aeskl_glue.o
+
 obj-$(CONFIG_CRYPTO_SHA1_SSSE3) += sha1-ssse3.o
 sha1-ssse3-y := sha1_avx2_x86_64_asm.o sha1_ssse3_asm.o sha1_ssse3_glue.o
 sha1-ssse3-$(CONFIG_AS_SHA1_NI) += sha1_ni_asm.o
diff --git a/arch/x86/crypto/aeskl-xts-x86_64.S b/arch/x86/crypto/aeskl-xts-x86_64.S
new file mode 100644
index 000000000000..261d03789452
--- /dev/null
+++ b/arch/x86/crypto/aeskl-xts-x86_64.S
@@ -0,0 +1,337 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Implement AES algorithm using AES Key Locker instructions.
+ *
+ * Most code is primarily derived from aesni-intel_asm.S and
+ * stylistically aligned with aes-xts-avx-x86_64.S.
+ */
+
+#include <linux/linkage.h>
+#include <asm/errno.h>
+#include <asm/inst.h>
+
+.section .rodata
+.p2align 4
+.Lgf_poly:
+	/*
+	 * Represents the polynomial x^7 + x^2 + x + 1, where the low 64
+	 * bits are XOR'd into the tweak's low 64 bits when a carry
+	 * occurs from the high 64 bits.
+	 */
+	.quad	0x87, 1
+
+	/*
+	 * Table of constants for variable byte shifts and blending
+	 * during ciphertext stealing operations.
+	 */
+.Lcts_permute_table:
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07
+	.byte	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+	.byte	0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80
+
+.text
+
+.set	TWEAK_NEXT1,	%xmm8
+.set	TWEAK_NEXT2,	%xmm9
+.set	TWEAK_NEXT3,	%xmm10
+.set	TWEAK_NEXT4,	%xmm11
+.set	TWEAK_NEXT5,	%xmm12
+.set	TWEAK_NEXT6,	%xmm13
+.set	TWEAK_NEXT7,	%xmm14
+.set	GF_POLY,	%xmm15
+.set	TWEAK_TMP,	TWEAK_NEXT1
+.set	TWEAK_NEXT,	TWEAK_NEXT2
+.set	TMP,		%r10
+.set	KLEN,		%r9d
+
+/*
+ * void __aeskl_setkey(struct crypto_aes_ctx *handle, const u8 *key,
+ *		       unsigned int keylen)
+ */
+SYM_FUNC_START(__aeskl_setkey)
+	.set	HANDLE,	%rdi	/* Pointer to struct aeskl_ctx */
+	.set	KEY,	%rsi	/* Pointer to the original key */
+	.set	KEYLEN,	%edx	/* AES key length in bytes */
+	movl		KEYLEN, 480(HANDLE)
+	vmovdqu		(KEY), %xmm0
+	mov		$1, %eax
+	cmp		$16, %dl
+	je		.Lsetkey_128
+
+	vmovdqu		0x10(KEY), %xmm1
+	encodekey256	%eax, %eax
+	vmovdqu		%xmm3, 0x30(HANDLE)
+	jmp		.Lsetkey_end
+.Lsetkey_128:
+	encodekey128	%eax, %eax
+
+.Lsetkey_end:
+	vmovdqu		%xmm0, 0x00(HANDLE)
+	vmovdqu		%xmm1, 0x10(HANDLE)
+	vmovdqu		%xmm2, 0x20(HANDLE)
+	RET
+SYM_FUNC_END(__aeskl_setkey)
+
+.macro _aeskl		operation
+	cmp		$16, KLEN
+	je		.Laes_128\@
+.ifc \operation, dec
+	aesdec256kl	(HANDLE), %xmm0
+.else
+	aesenc256kl	(HANDLE), %xmm0
+.endif
+	jmp		.Laes_end\@
+.Laes_128\@:
+.ifc \operation, dec
+	aesdec128kl	(HANDLE), %xmm0
+.else
+	aesenc128kl	(HANDLE), %xmm0
+.endif
+.Laes_end\@:
+.endm
+
+.macro _aesklwide	operation
+	cmp		$16, KLEN
+	je		.Laesw_128\@
+.ifc \operation, dec
+	aesdecwide256kl	(HANDLE)
+.else
+	aesencwide256kl	(HANDLE)
+.endif
+	jmp		.Laesw_end\@
+.Laesw_128\@:
+.ifc \operation, dec
+	aesdecwide128kl	(HANDLE)
+.else
+	aesencwide128kl	(HANDLE)
+.endif
+.Laesw_end\@:
+.endm
+
+/* int __aeskl_enc(const void *handle, u8 *dst, const u8 *src) */
+SYM_FUNC_START(__aeskl_enc)
+	.set	HANDLE,	%rdi	/* Pointer to struct aeskl_ctx */
+	.set	DST,	%rsi	/* Pointer to next destination data */
+	.set	SRC,	%rdx	/* Pointer to next source data */
+	vmovdqu		(SRC), %xmm0
+	movl		480(HANDLE), KLEN
+
+	_aeskl		enc
+	jz		.Lerror
+	xor		%rax, %rax
+	vmovdqu		%xmm0, (DST)
+	RET
+.Lerror:
+	mov		$(-EINVAL), %eax
+	RET
+SYM_FUNC_END(__aeskl_enc)
+
+/*
+ * Calculate the next 128-bit XTS tweak by multiplying the polynomial 'x'
+ * with the current tweak stored in the register \src, and store the
+ * result in the \dst register.
+ */
+.macro _next_tweak	src, tmp, dst
+	vpshufd		$0x13, \src, \tmp
+	vpaddq		\src, \src, \dst
+	vpsrad		$31, \tmp, \tmp
+	vpand		GF_POLY, \tmp, \tmp
+	vpxor		\tmp, \dst, \dst
+.endm
+
+.macro _aeskl_xts_crypt operation
+	vmovdqa		.Lgf_poly(%rip), GF_POLY
+	vmovups		(TWEAK), TWEAK_NEXT
+	mov		480(HANDLE), KLEN
+
+.ifc \operation, dec
+	/*
+	 * During decryption, if the message length is not a multiple of
+	 * the AES block length, exclude the last complete block from the
+	 * decryption loop by subtracting 16 from LEN. This adjustment is
+	 * necessary because ciphertext stealing decryption uses the last
+	 * two tweaks in reverse order. Special handling is required for
+	 * the last complete block and any remaining partial block at the
+	 * end.
+	 */
+	test		$15, LEN
+	jz		.L8block_at_a_time\@
+	sub		$16, LEN
+.endif
+
+.L8block_at_a_time\@:
+	sub		$128, LEN
+	jl		.Lhandle_remainder\@
+
+	vpxor		(SRC), TWEAK_NEXT, %xmm0
+	vmovups		TWEAK_NEXT, (DST)
+
+	/*
+	 * Calculate and cache tweak values. Note that the tweak
+	 * computation cannot be interleaved with AES rounds here using
+	 * Key Locker instructions.
+	 */
+	_next_tweak	TWEAK_NEXT,  %xmm1, TWEAK_NEXT1
+	_next_tweak	TWEAK_NEXT1, %xmm1, TWEAK_NEXT2
+	_next_tweak	TWEAK_NEXT2, %xmm1, TWEAK_NEXT3
+	_next_tweak	TWEAK_NEXT3, %xmm1, TWEAK_NEXT4
+	_next_tweak	TWEAK_NEXT4, %xmm1, TWEAK_NEXT5
+	_next_tweak	TWEAK_NEXT5, %xmm1, TWEAK_NEXT6
+	_next_tweak	TWEAK_NEXT6, %xmm1, TWEAK_NEXT7
+
+	/* XOR each source block with its tweak. */
+	vpxor		0x10(SRC), TWEAK_NEXT1, %xmm1
+	vpxor		0x20(SRC), TWEAK_NEXT2, %xmm2
+	vpxor		0x30(SRC), TWEAK_NEXT3, %xmm3
+	vpxor		0x40(SRC), TWEAK_NEXT4, %xmm4
+	vpxor		0x50(SRC), TWEAK_NEXT5, %xmm5
+	vpxor		0x60(SRC), TWEAK_NEXT6, %xmm6
+	vpxor		0x70(SRC), TWEAK_NEXT7, %xmm7
+
+	/* Encrypt or decrypt 8 blocks per iteration. */
+	_aesklwide	\operation
+	jz		.Lerror\@
+
+	/* XOR tweaks again. */
+	vpxor		(DST), %xmm0, %xmm0
+	vpxor		TWEAK_NEXT1, %xmm1, %xmm1
+	vpxor		TWEAK_NEXT2, %xmm2, %xmm2
+	vpxor		TWEAK_NEXT3, %xmm3, %xmm3
+	vpxor		TWEAK_NEXT4, %xmm4, %xmm4
+	vpxor		TWEAK_NEXT5, %xmm5, %xmm5
+	vpxor		TWEAK_NEXT6, %xmm6, %xmm6
+	vpxor		TWEAK_NEXT7, %xmm7, %xmm7
+
+	/* Store destination blocks. */
+	vmovdqu		%xmm0, 0x00(DST)
+	vmovdqu		%xmm1, 0x10(DST)
+	vmovdqu		%xmm2, 0x20(DST)
+	vmovdqu		%xmm3, 0x30(DST)
+	vmovdqu		%xmm4, 0x40(DST)
+	vmovdqu		%xmm5, 0x50(DST)
+	vmovdqu		%xmm6, 0x60(DST)
+	vmovdqu		%xmm7, 0x70(DST)
+
+	_next_tweak	TWEAK_NEXT7, TWEAK_TMP, TWEAK_NEXT
+	add		$128, SRC
+	add		$128, DST
+	test		LEN, LEN
+	jz		.Lend\@
+	jmp		.L8block_at_a_time\@
+
+.Lhandle_remainder\@:
+	add		$128, LEN
+	jz		.Lend\@
+.ifc \operation, enc
+	vmovdqu		%xmm7, %xmm0
+.endif
+	sub		$16, LEN
+	jl		.Lcts\@
+
+	/* Encrypt or decrypt one block per iteration */
+.Lblock_at_a_time\@:
+	vpxor		(SRC), TWEAK_NEXT, %xmm0
+	_aeskl		\operation
+	jz		.Lerror\@
+	vpxor		TWEAK_NEXT, %xmm0, %xmm0
+	_next_tweak	TWEAK_NEXT, TWEAK_TMP, TWEAK_NEXT
+	test		LEN, LEN
+	jz		.Lout\@
+
+	add		$16, SRC
+	vmovdqu		%xmm0, (DST)
+	add		$16, DST
+	sub		$16, LEN
+	jge		.Lblock_at_a_time\@
+
+.Lcts\@:
+.ifc \operation, dec
+	/*
+	 * If decrypting, the last block was not decrypted because CTS
+	 * decryption uses the last two tweaks in reverse order. This is
+	 * done by advancing the tweak and decrypting the last block.
+	 */
+	_next_tweak	TWEAK_NEXT, TWEAK_TMP, %xmm4
+	vpxor		(SRC), %xmm4, %xmm0
+	_aeskl		\operation
+	jz		.Lerror\@
+	vpxor		%xmm4, %xmm0, %xmm0
+	add		$16, SRC
+.else
+	/*
+	 * If encrypting, the last block was already encrypted in %xmm0.
+	 * Prepare the CTS encryption by rewinding the pointer.
+	 */
+	sub		$16, DST
+.endif
+	lea		.Lcts_permute_table(%rip), TMP
+
+	/* Load the source partial block */
+	vmovdqu		(SRC, LEN, 1), %xmm3
+
+	/*
+	 * Shift the first LEN bytes of the encryption and decryption of
+	 * the last block to the end of a register, then store it to
+	 * DST+LEN.
+	 */
+	add		$16, LEN
+	vpshufb		(TMP, LEN, 1), %xmm0, %xmm2
+	vmovdqu		%xmm2, (DST, LEN, 1)
+
+	/* Shift the source partial block to the beginning */
+	sub		LEN, TMP
+	vmovdqu		32(TMP), %xmm2
+	vpshufb		%xmm2, %xmm3, %xmm3
+
+	/* Blend to generate the source partial block */
+	vpblendvb	%xmm2, %xmm0, %xmm3, %xmm3
+
+	/* Encrypt or decrypt again and store the last block. */
+	vpxor		TWEAK_NEXT, %xmm3, %xmm0
+	_aeskl		\operation
+	jz		.Lerror\@
+	vpxor		TWEAK_NEXT, %xmm0, %xmm0
+	vmovdqu		%xmm0, (DST)
+
+	xor		%rax, %rax
+	RET
+.Lout\@:
+	vmovdqu		%xmm0, (DST)
+.Lend\@:
+	vmovups		TWEAK_NEXT, (TWEAK)
+	xor		%rax, %rax
+	RET
+.Lerror\@:
+	mov		$(-EINVAL), %eax
+	RET
+.endm
+
+/*
+ * int __aeskl_xts_encrypt(const struct aeskl_ctx *handle, u8 *dst,
+ *			   const u8 *src, unsigned int len, u8 *tweak)
+ */
+SYM_FUNC_START(__aeskl_xts_encrypt)
+	.set	HANDLE,	%rdi	/* Pointer to struct aeskl_ctx */
+	.set	DST,	%rsi	/* Pointer to next destination data */
+	.set	SRC,	%rdx	/* Pointer to next source data */
+	.set	LEN,	%rcx	/* Remaining length in bytes */
+	.set	TWEAK,	%r8	/* Pointer to next tweak */
+	_aeskl_xts_crypt	enc
+SYM_FUNC_END(__aeskl_xts_encrypt)
+
+/*
+ * int __aeskl_xts_decrypt(const struct crypto_aes_ctx *handle, u8 *dst,
+ *			   const u8 *src, unsigned int len, u8 *tweak)
+ */
+SYM_FUNC_START(__aeskl_xts_decrypt)
+	.set	HANDLE,	%rdi	/* Pointer to struct aeskl_ctx */
+	.set	DST,	%rsi	/* Pointer to next destination data */
+	.set	SRC,	%rdx	/* Pointer to next source data */
+	.set	LEN,	%rcx	/* Remaining length in bytes */
+	.set	TWEAK,	%r8	/* Pointer to next tweak */
+	_aeskl_xts_crypt	dec
+SYM_FUNC_END(__aeskl_xts_decrypt)
+
diff --git a/arch/x86/crypto/aeskl_glue.c b/arch/x86/crypto/aeskl_glue.c
new file mode 100644
index 000000000000..51b8daf7e72a
--- /dev/null
+++ b/arch/x86/crypto/aeskl_glue.c
@@ -0,0 +1,409 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Support for AES Key Locker instructions. This file contains glue
+ * code and the real AES implementation is in aeskl-xts-x86_64.S.
+ *
+ * Most code is based on aesni-intel_glue.c
+ */
+
+#include <linux/err.h>
+#include <linux/types.h>
+#include <linux/module.h>
+
+#include <crypto/aes.h>
+#include <crypto/xts.h>
+#include <crypto/scatterwalk.h>
+#include <crypto/internal/simd.h>
+#include <crypto/internal/skcipher.h>
+
+#include <asm/fpu/api.h>
+#include <asm/keylocker.h>
+#include <asm/simd.h>
+
+#include "aesni-xts.h"
+
+#define AES_ALIGN		16
+#define AES_ALIGN_ATTR		__attribute__ ((__aligned__(AES_ALIGN)))
+#define AES_ALIGN_EXTRA		((AES_ALIGN - 1) & ~(CRYPTO_MINALIGN - 1))
+
+#define AESKL_AAD_SIZE		16
+#define AESKL_TAG_SIZE		16
+#define AESKL_CIPHERTEXT_MAX	AES_KEYSIZE_256
+
+/* The Key Locker handle is an encoded form of the AES key. */
+struct aeskl_handle {
+	u8 additional_authdata[AESKL_AAD_SIZE];
+	u8 integrity_tag[AESKL_TAG_SIZE];
+	u8 cipher_text[AESKL_CIPHERTEXT_MAX];
+};
+
+/*
+ * Key Locker does not support 192-bit key size. The driver needs to
+ * retrieve the key size in the first place. The offset of the
+ * 'key_length' field here must be compatible with struct
+ * crypto_aes_ctx.
+ */
+#define AESKL_CTX_RESERVED (sizeof(struct crypto_aes_ctx) \
+			    - sizeof(struct aeskl_handle) \
+			    - sizeof(u32))
+
+struct aeskl_ctx {
+	struct aeskl_handle handle;
+	u8 reserved[AESKL_CTX_RESERVED];
+	u32 key_length;
+};
+
+/*
+ * Unify the two context structures to represent the crypto context.
+ * Depending on the key size, either AES-KL or AES-NI will be used.
+ */
+union x86_aes_ctx {
+	struct aeskl_ctx      aeskl;
+	struct crypto_aes_ctx aesni;
+};
+
+struct xts_aes_ctx {
+	union x86_aes_ctx tweak_ctx AES_ALIGN_ATTR;
+	union x86_aes_ctx crypt_ctx AES_ALIGN_ATTR;
+};
+
+static inline struct xts_aes_ctx *xts_aes_ctx(struct crypto_skcipher *tfm)
+{
+	void *addr = crypto_skcipher_ctx(tfm);
+
+	if (crypto_tfm_ctx_alignment() >= AES_ALIGN)
+		return addr;
+
+	return PTR_ALIGN(addr, AES_ALIGN);
+}
+
+static inline u32 xts_keylen(struct skcipher_request *req)
+{
+	struct xts_aes_ctx *ctx = xts_aes_ctx(crypto_skcipher_reqtfm(req));
+
+	BUILD_BUG_ON(offsetof(struct crypto_aes_ctx, key_length) !=
+		     offsetof(struct aeskl_ctx, key_length));
+
+	return ctx->crypt_ctx.aeskl.key_length;
+}
+
+asmlinkage void __aeskl_setkey(struct aeskl_ctx *handle, const u8 *key, unsigned int keylen);
+
+asmlinkage int __aeskl_enc(const void *handle, u8 *dst, const u8 *src);
+
+asmlinkage int __aeskl_xts_encrypt(const struct aeskl_ctx *handle, u8 *dst, const u8 *src,
+				   unsigned int len, u8 *tweak);
+asmlinkage int __aeskl_xts_decrypt(const struct aeskl_ctx *handle, u8 *dst, const u8 *src,
+				   unsigned int len, u8 *tweak);
+
+/*
+ * If a hardware failure occurs, the wrapping key may be lost during
+ * sleep states. The state of the feature can be retrieved via
+ * valid_keylocker().
+ *
+ * Since disabling can occur preemptively, check for availability on
+ * every use along with kernel_fpu_begin().
+ */
+
+static int aeskl_setkey(struct aeskl_ctx *ctx, const u8 *in_key, unsigned int keylen)
+{
+	if (!crypto_simd_usable())
+		return -EBUSY;
+
+	kernel_fpu_begin();
+	if (!valid_keylocker()) {
+		kernel_fpu_end();
+		return -ENODEV;
+	}
+
+	__aeskl_setkey(ctx, in_key, keylen);
+	kernel_fpu_end();
+	return 0;
+}
+
+static int aeskl_xts_encrypt_iv(const struct aeskl_ctx *tweak_key,
+				u8 iv[AES_BLOCK_SIZE])
+{
+	if (!valid_keylocker())
+		return -ENODEV;
+
+	return __aeskl_enc(tweak_key, iv, iv);
+}
+
+static int aeskl_xts_encrypt(const struct aeskl_ctx *key,
+			     const u8 *src, u8 *dst, unsigned int len,
+			     u8 tweak[AES_BLOCK_SIZE])
+{
+	if (!valid_keylocker())
+		return -ENODEV;
+
+	return __aeskl_xts_encrypt(key, dst, src, len, tweak);
+}
+
+static int aeskl_xts_decrypt(const struct aeskl_ctx *key,
+			     const u8 *src, u8 *dst, unsigned int len,
+			     u8 tweak[AES_BLOCK_SIZE])
+{
+	if (!valid_keylocker())
+		return -ENODEV;
+
+	return __aeskl_xts_decrypt(key, dst, src, len, tweak);
+}
+
+/*
+ * The glue code in xts_crypt() and xts_crypt_slowpath() follows
+ * aesni-intel_glue.c. While this code is shareable, the key
+ * material format difference can cause more destructive code changes in
+ * the AES-NI side.
+ */
+
+enum xts_ops {
+	XTS_ENCRYPTION,
+	XTS_DECRYPTION
+};
+
+/* This handles cases where the source and/or destination span pages. */
+static noinline int xts_crypt_slowpath(struct skcipher_request *req, enum xts_ops ops)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct xts_aes_ctx *ctx = xts_aes_ctx(tfm);
+	int tail = req->cryptlen % AES_BLOCK_SIZE;
+	struct scatterlist sg_src[2], sg_dst[2];
+	struct skcipher_request subreq;
+	struct scatterlist *src, *dst;
+	struct skcipher_walk walk;
+	int err;
+
+	/*
+	 * If the message length isn't divisible by the AES block size, then
+	 * separate off the last full block and the partial block.  This ensures
+	 * that they are processed in the same call to the assembly function,
+	 * which is required for ciphertext stealing.
+	 */
+	if (tail) {
+		skcipher_request_set_tfm(&subreq, tfm);
+		skcipher_request_set_callback(&subreq,
+					      skcipher_request_flags(req),
+					      NULL, NULL);
+		skcipher_request_set_crypt(&subreq, req->src, req->dst,
+					   req->cryptlen - tail - AES_BLOCK_SIZE,
+					   req->iv);
+		req = &subreq;
+	}
+
+	err = skcipher_walk_virt(&walk, req, false);
+
+	while (walk.nbytes) {
+		kernel_fpu_begin();
+		if (ops == XTS_ENCRYPTION) {
+			err |= aeskl_xts_encrypt(&ctx->crypt_ctx.aeskl, walk.src.virt.addr,
+						 walk.dst.virt.addr,
+						 walk.nbytes & ~(AES_BLOCK_SIZE - 1), req->iv);
+		} else {
+			err |= aeskl_xts_decrypt(&ctx->crypt_ctx.aeskl, walk.src.virt.addr,
+						 walk.dst.virt.addr,
+						 walk.nbytes & ~(AES_BLOCK_SIZE - 1), req->iv);
+		}
+		kernel_fpu_end();
+		err |= skcipher_walk_done(&walk,
+					  walk.nbytes & (AES_BLOCK_SIZE - 1));
+	}
+
+	if (err || !tail)
+		return err;
+
+	/* Do ciphertext stealing with the last full block and partial block. */
+
+	dst = src = scatterwalk_ffwd(sg_src, req->src, req->cryptlen);
+	if (req->dst != req->src)
+		dst = scatterwalk_ffwd(sg_dst, req->dst, req->cryptlen);
+
+	skcipher_request_set_crypt(req, src, dst, AES_BLOCK_SIZE + tail,
+				   req->iv);
+
+	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
+
+	kernel_fpu_begin();
+	if (ops == XTS_ENCRYPTION) {
+		err = aeskl_xts_encrypt(&ctx->crypt_ctx.aeskl, walk.src.virt.addr,
+					walk.dst.virt.addr, walk.nbytes, req->iv);
+	} else {
+		err = aeskl_xts_decrypt(&ctx->crypt_ctx.aeskl, walk.src.virt.addr,
+					walk.dst.virt.addr, walk.nbytes, req->iv);
+	}
+	kernel_fpu_end();
+	if (err)
+		return err;
+
+	return skcipher_walk_done(&walk, 0);
+}
+
+/* __always_inline to avoid indirect call in fastpath */
+static __always_inline int xts_crypt(struct skcipher_request *req, enum xts_ops ops)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct xts_aes_ctx *ctx = xts_aes_ctx(tfm);
+	const unsigned int cryptlen = req->cryptlen;
+	struct scatterlist *src = req->src;
+	struct scatterlist *dst = req->dst;
+	int err;
+
+	if (unlikely(cryptlen < AES_BLOCK_SIZE))
+		return -EINVAL;
+
+	kernel_fpu_begin();
+	err = aeskl_xts_encrypt_iv(&ctx->tweak_ctx.aeskl, req->iv);
+	if (err)
+		goto out;
+
+	/*
+	 * In practice, virtually all XTS plaintexts and ciphertexts are either
+	 * 512 or 4096 bytes, aligned such that they don't span page boundaries.
+	 * To optimize the performance of these cases, and also any other case
+	 * where no page boundary is spanned, the below fast-path handles
+	 * single-page sources and destinations as efficiently as possible.
+	 */
+	if (likely(src->length >= cryptlen && dst->length >= cryptlen &&
+		   src->offset + cryptlen <= PAGE_SIZE &&
+		   dst->offset + cryptlen <= PAGE_SIZE)) {
+		struct page *src_page = sg_page(src);
+		struct page *dst_page = sg_page(dst);
+		void *src_virt = kmap_local_page(src_page) + src->offset;
+		void *dst_virt = kmap_local_page(dst_page) + dst->offset;
+
+		if (ops == XTS_ENCRYPTION) {
+			err = aeskl_xts_encrypt(&ctx->crypt_ctx.aeskl, src_virt,
+						dst_virt, cryptlen, req->iv);
+		} else {
+			err = aeskl_xts_decrypt(&ctx->crypt_ctx.aeskl, src_virt,
+						dst_virt, cryptlen, req->iv);
+		}
+		if (err)
+			goto out;
+		kunmap_local(dst_virt);
+		kunmap_local(src_virt);
+		kernel_fpu_end();
+		return 0;
+	}
+out:
+	kernel_fpu_end();
+	if (err)
+		return err;
+	return xts_crypt_slowpath(req, ops);
+}
+
+static int xts_setkey_aeskl(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
+{
+	struct xts_aes_ctx *ctx = xts_aes_ctx(tfm);
+	unsigned int aes_keylen;
+	int err;
+
+	err = xts_verify_key(tfm, key, keylen);
+	if (err)
+		return err;
+
+	aes_keylen = keylen / 2;
+	err = aes_check_keylen(aes_keylen);
+	if (err)
+		return err;
+
+	if (unlikely(aes_keylen == AES_KEYSIZE_192)) {
+		pr_warn_once("AES-KL does not support 192-bit key. Use AES-NI.\n");
+		return xts_setkey_aesni(tfm, key, keylen);
+	}
+
+	err = aeskl_setkey(&ctx->crypt_ctx.aeskl, key, aes_keylen);
+	if (err)
+		return err;
+
+	return aeskl_setkey(&ctx->tweak_ctx.aeskl, key + aes_keylen, aes_keylen);
+}
+
+static int xts_encrypt_aeskl(struct skcipher_request *req)
+{
+	if (unlikely(xts_keylen(req) == AES_KEYSIZE_192))
+		return xts_encrypt_aesni(req);
+
+	return xts_crypt(req, XTS_ENCRYPTION);
+}
+
+static int xts_decrypt_aeskl(struct skcipher_request *req)
+{
+	if (unlikely(xts_keylen(req) == AES_KEYSIZE_192))
+		return xts_decrypt_aesni(req);
+
+	return xts_crypt(req, XTS_DECRYPTION);
+}
+
+#define XTS_AES_CTX_SIZE (sizeof(struct xts_aes_ctx) + AES_ALIGN_EXTRA)
+
+/*
+ * The 'cra_priority' value is intentionally set lower than
+ * xts-aes-aesni.
+ */
+static struct skcipher_alg aeskl_skciphers[] = {
+	{
+		.base = {
+			.cra_name		= "__xts(aes)",
+			.cra_driver_name	= "__xts-aes-aeskl",
+			.cra_priority		= 200,
+			.cra_flags		= CRYPTO_ALG_INTERNAL,
+			.cra_blocksize		= AES_BLOCK_SIZE,
+			.cra_ctxsize		= XTS_AES_CTX_SIZE,
+			.cra_module		= THIS_MODULE,
+		},
+		.min_keysize	= 2 * AES_MIN_KEY_SIZE,
+		.max_keysize	= 2 * AES_MAX_KEY_SIZE,
+		.ivsize		= AES_BLOCK_SIZE,
+		.walksize	= 2 * AES_BLOCK_SIZE,
+		.setkey		= xts_setkey_aeskl,
+		.encrypt	= xts_encrypt_aeskl,
+		.decrypt	= xts_decrypt_aeskl,
+	}
+};
+
+static struct simd_skcipher_alg *aeskl_simd_skciphers[ARRAY_SIZE(aeskl_skciphers)];
+
+static int __init aeskl_init(void)
+{
+	u32 eax, ebx, ecx, edx;
+
+	if (!valid_keylocker())
+		return -ENODEV;
+
+	/*
+	 * For performance, use the Key Locker AES wide and AVX
+	 * instructions.
+	 */
+	cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
+	if (!(ebx & KEYLOCKER_CPUID_EBX_WIDE))
+		return -ENODEV;
+	if (!boot_cpu_has(X86_FEATURE_AVX))
+		return -ENODEV;
+
+	/*
+	 * AES-KL itself does not rely on AES-NI. But, AES-KL does not
+	 * support 192-bit keys. To ensure AES compliance, AES-KL falls
+	 * back to AES-NI.
+	 */
+	if (!boot_cpu_has(X86_FEATURE_AES))
+		return -ENODEV;
+
+	return simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+					      aeskl_simd_skciphers);
+}
+
+static void __exit aeskl_exit(void)
+{
+	simd_unregister_skciphers(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
+				  aeskl_simd_skciphers);
+}
+
+late_initcall(aeskl_init);
+module_exit(aeskl_exit);
+
+MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, AES Key Locker implementation");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CRYPTO("aes");
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index ef031655b2d3..49fb56efac56 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -35,7 +35,7 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/static_call.h>
-
+#include "aesni-xts.h"
 
 #define AESNI_ALIGN	16
 #define AESNI_ALIGN_ATTR __attribute__ ((__aligned__(AESNI_ALIGN)))
@@ -864,8 +864,8 @@ static int helper_rfc4106_decrypt(struct aead_request *req)
 }
 #endif
 
-static int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
-			    unsigned int keylen)
+int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
+		     unsigned int keylen)
 {
 	struct aesni_xts_ctx *ctx = aes_xts_ctx(tfm);
 	int err;
@@ -884,6 +884,7 @@ static int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key,
 	/* second half of xts-key is for tweak */
 	return aes_set_key_common(&ctx->tweak_ctx, key + keylen, keylen);
 }
+EXPORT_SYMBOL_GPL(xts_setkey_aesni);
 
 typedef void (*xts_encrypt_iv_func)(const struct crypto_aes_ctx *tweak_key,
 				    u8 iv[AES_BLOCK_SIZE]);
@@ -1020,15 +1021,17 @@ static void aesni_xts_decrypt(const struct crypto_aes_ctx *key,
 	aesni_xts_dec(key, dst, src, len, tweak);
 }
 
-static int xts_encrypt_aesni(struct skcipher_request *req)
+int xts_encrypt_aesni(struct skcipher_request *req)
 {
 	return xts_crypt(req, aesni_xts_encrypt_iv, aesni_xts_encrypt);
 }
+EXPORT_SYMBOL_GPL(xts_encrypt_aesni);
 
-static int xts_decrypt_aesni(struct skcipher_request *req)
+int xts_decrypt_aesni(struct skcipher_request *req)
 {
 	return xts_crypt(req, aesni_xts_encrypt_iv, aesni_xts_decrypt);
 }
+EXPORT_SYMBOL_GPL(xts_decrypt_aesni);
 
 static struct crypto_alg aesni_cipher_alg = {
 	.cra_name		= "aes",
diff --git a/arch/x86/crypto/aesni-xts.h b/arch/x86/crypto/aesni-xts.h
new file mode 100644
index 000000000000..9833da2bd9d2
--- /dev/null
+++ b/arch/x86/crypto/aesni-xts.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _AESNI_XTS_H
+#define _AESNI_XTS_H
+
+/*
+ * These AES-NI functions are used by the AES-KL code as a fallback when
+ * a 192-bit key is provided. Key Locker does not support 192-bit keys.
+ */
+
+int xts_setkey_aesni(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen);
+int xts_encrypt_aesni(struct skcipher_request *req);
+int xts_decrypt_aesni(struct skcipher_request *req);
+
+#endif /* _AESNI_XTS_H */
-- 
2.34.1

