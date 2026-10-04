Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76FE3B8412;
	Sun,  4 Oct 2026 19:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791142119; cv=none; b=bN3T+ZH8Ec6IHiNIZFyPM6in+20MEOLLU0VMbjegyNwaC+NYyjLeZXJm+Klii1zF0E6ckE78kdWlZVaMLMmX8o7exub3+vF6VvqxjYQERNvi70993c9EU6m7g3H+UhFomPQJfQFPEAUeu8BcKMsWIWGewzvixdu0glINKgqXsIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791142119; c=relaxed/simple;
	bh=WOzFYMQgBn6NuD7qPJBAx8BNr2WHhTvIzt1d9VnzpMM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZwhY6NyMKXe2niD0+RqzwK+SZ1Lcd0xd52myCQIatyZ+lIAjqLR0FjnbmZmuPd5llDCz1tWRMmGolDEoQ84DVVnH/GMHb6zfvTF+v8sL/yZ0kbhxmprLWDLwKinHyU2iCIyRUzJDETWjqo/myM2Iu5AGrV5srwrkqG3NZK2pRM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=epomakwP; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="epomakwP"
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1791142115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=S/2mHRq1YnKSq5qIVNC8TG033cW6gYZpUgcQ1SmyEXo=;
	b=epomakwPsfrTUIYKZkGy06w4X6Fc0P0QKMOXhrBfB87XB5QRzTBcI4Xzy0MymvoBzI0Hmf
	mZMqXOz80H9ai8rSsaLsCklbiMFnrQ4nggSM98gBH5b/0J2cv52q29pIP7DwbVRboPc6jU
	xhevna5IL4lN2aob+jKG7bq5FtAZX+Q=
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>
Subject: [PATCH v3] lib/crypto: sparc/aes-xts: Add optimization using the AES opcodes
Date: Sun,  4 Oct 2026 21:28:12 +0200
Message-ID: <20261004192812.4145406-1-stian@itx.no>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement aes_xts_encrypt_arch() and aes_xts_decrypt_arch() with the AES
opcodes, for AES-128 and AES-256, two blocks per iteration. AES-192,
which IEEE 1619 does not specify, and data that is not 8-byte aligned
are left to the generic code.

The tweak is kept as little-endian words, so that multiplying it by x is
a 128-bit shift done with addcc and the VIS3 addxc. A little-endian
store and an ordinary load through a stack slot give it in the byte
order of the data, and the slot is cleared on return. The routines open
a register window, as %g4-%g6 belong to the kernel.

With that, xts-aes-lib no longer has to be kept off SPARC. Register it
there again, with the priority x86 and RISC-V use, so that it also
outranks an xts(ecb-aes-sparc64) instance (priority 300).

On a T7-1 (M7), MiB/s unless noted:

                               xts(ecb-aes-sparc64)  xts-aes-lib
  AF_ALG, 64 KiB, AES-128                     415         1092
  AF_ALG, 64 KiB, AES-256                     390          936
  dm-crypt on brd, AES-256:
    sequential read                          1399         2559
    sequential write                         1472         3480
    4 KiB write latency, QD1 (us)            40.6         32.7

dm-crypt now matches aes-cbc-essiv on the same ramdisk.

On a T4-1, AF_ALG AES-256 goes from 238 to 544 MiB/s, and AES-128
from 252 to 616.

Tested with CONFIG_CRYPTO_SELFTESTS_FULL, and against OpenSSL over
random keys, tweaks and lengths, on both machines.

Link: https://github.com/sparclinux/issues/issues/106
Signed-off-by: Stian Halseth <stian@itx.no>
---
v3:
- One macro for the four XTS routines, as in the RISC-V and x86 code
  (Eric). The object file is the same as with v2.

v2:
- Rebased on libcrypto-next, on top of 572af6872e52 ("crypto: aes - Fix
  undesired override of some optimized AES modes"), and register
  xts-aes-lib on SPARC again
- Give it the priority x86 and RISC-V use
- Drop Fixes:, Closes: -> Link:
- Commit message compares with the xts template only

QEMU does not have the SPARC crypto opcodes yet. That is being discussed
on qemu-devel [1] and tracked in sparclinux#77 [2].

[1] https://lists.gnu.org/archive/html/qemu-devel/2026-09/msg09494.html
[2] https://github.com/sparclinux/issues/issues/77

v2: https://lore.kernel.org/all/20261002072110.1221579-1-stian@itx.no/
v1: https://lore.kernel.org/all/20260929211218.4194135-1-stian@itx.no/

 arch/sparc/include/asm/opcodes.h |   6 ++
 crypto/aes.c                     |   9 +-
 lib/crypto/sparc/aes.h           |  75 ++++++++++++++
 lib/crypto/sparc/aes_asm.S       | 165 +++++++++++++++++++++++++++++++
 4 files changed, 248 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/include/asm/opcodes.h b/arch/sparc/include/asm/opcodes.h
index ebfda6eb49b26..f1cb1a26be8fc 100644
--- a/arch/sparc/include/asm/opcodes.h
+++ b/arch/sparc/include/asm/opcodes.h
@@ -96,5 +96,11 @@
 	.word	0xbbb02303;
 #define MOVXTOD_G7_F62		\
 	.word	0xbfb02307;
+#define MOVXTOD_L4_F56		\
+	.word	0xb3b02314;
+#define MOVXTOD_L5_F58		\
+	.word	0xb7b02315;
+#define ADDXC_L1_L1_L1		\
+	.word	0xa3b44231;
 
 #endif /* _SPARC_ASM_OPCODES_H */
diff --git a/crypto/aes.c b/crypto/aes.c
index 73f3aa856be4e..9508a975d8eaf 100644
--- a/crypto/aes.c
+++ b/crypto/aes.c
@@ -702,17 +702,12 @@ static struct skcipher_alg skcipher_algs[] = {
 		.decrypt = crypto_aes_xctr_crypt,
 	},
 #endif
-	/*
-	 * Don't register library-based "xts(aes)" on architectures where it
-	 * might block a "better" implementation from being instantiated via the
-	 * "xts" template.  This exclusion is temporary and will go away when
-	 * the library AES-XTS is optimized for SPARC.
-	 */
-#if IS_ENABLED(CONFIG_CRYPTO_XTS) && !IS_ENABLED(CONFIG_SPARC)
+#if IS_ENABLED(CONFIG_CRYPTO_XTS)
 	{
 		.base.cra_name = "xts(aes)",
 		.base.cra_driver_name = "xts-aes-lib",
 		.base.cra_priority = (IS_ENABLED(CONFIG_RISCV) ||
+				      IS_ENABLED(CONFIG_SPARC) ||
 				      IS_ENABLED(CONFIG_X86)) ? 500 : 110,
 		.base.cra_blocksize = AES_BLOCK_SIZE,
 		.base.cra_ctxsize = sizeof(struct aes_xts_key),
diff --git a/lib/crypto/sparc/aes.h b/lib/crypto/sparc/aes.h
index e354aa507ee07..e1a060cf49539 100644
--- a/lib/crypto/sparc/aes.h
+++ b/lib/crypto/sparc/aes.h
@@ -133,6 +133,81 @@ static void aes_decrypt_arch(const struct aes_key *key,
 	}
 }
 
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
+void aes_sparc64_xts_encrypt_128(const u64 *key, const u64 *input, u64 *output,
+				 size_t len, u64 tweak[2]);
+void aes_sparc64_xts_encrypt_256(const u64 *key, const u64 *input, u64 *output,
+				 size_t len, u64 tweak[2]);
+void aes_sparc64_xts_decrypt_128(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len, u64 tweak[2]);
+void aes_sparc64_xts_decrypt_256(const u64 *key_end, const u64 *input,
+				 u64 *output, size_t len, u64 tweak[2]);
+
+/* len is always a positive multiple of AES_BLOCK_SIZE here. */
+static __always_inline bool
+aes_xts_crypt_sparc64(u8 *dst, const u8 *src, size_t len,
+		      u8 tweak[AES_BLOCK_SIZE],
+		      const struct aes_xts_key *key, bool cont, bool enc)
+{
+	const struct aes_key *k = &key->main_key;
+	const u64 *rk = k->k.sparc_rndkeys;
+	const u64 *rk_end = rk + 2 * (k->nrounds + 1);
+	const u64 *in = (const u64 *)src;
+	u64 *out = (u64 *)dst;
+	u64 t[2];
+
+	/* The assembly code has no AES-192 and needs 8-byte aligned data. */
+	if (!static_branch_likely(&have_aes_opcodes) ||
+	    k->len == AES_KEYSIZE_192 ||
+	    !IS_ALIGNED((uintptr_t)dst | (uintptr_t)src, 8))
+		return false;
+
+	if (cont)
+		memcpy(t, tweak, sizeof(t));
+	else
+		aes_encrypt_arch(&key->tweak_key, (u8 *)t, tweak);
+
+	if (k->len == AES_KEYSIZE_128) {
+		if (enc) {
+			aes_sparc64_load_encrypt_keys_128(rk);
+			aes_sparc64_xts_encrypt_128(rk, in, out, len, t);
+		} else {
+			aes_sparc64_load_decrypt_keys_128(rk);
+			aes_sparc64_xts_decrypt_128(rk_end, in, out, len, t);
+		}
+	} else {
+		if (enc) {
+			aes_sparc64_load_encrypt_keys_256(rk);
+			aes_sparc64_xts_encrypt_256(rk, in, out, len, t);
+		} else {
+			aes_sparc64_load_decrypt_keys_256(rk);
+			aes_sparc64_xts_decrypt_256(rk_end, in, out, len, t);
+		}
+	}
+	fprs_write(0);
+
+	memcpy(tweak, t, sizeof(t));
+	memzero_explicit(t, sizeof(t));
+	return true;
+}
+
+#define aes_xts_encrypt_arch aes_xts_encrypt_arch
+static bool aes_xts_encrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return aes_xts_crypt_sparc64(dst, src, len, tweak, key, cont, true);
+}
+
+#define aes_xts_decrypt_arch aes_xts_decrypt_arch
+static bool aes_xts_decrypt_arch(u8 *dst, const u8 *src, size_t len,
+				 u8 tweak[AES_BLOCK_SIZE],
+				 const struct aes_xts_key *key, bool cont)
+{
+	return aes_xts_crypt_sparc64(dst, src, len, tweak, key, cont, false);
+}
+#endif /* CONFIG_CRYPTO_LIB_AES_XTS */
+
 #define aes_mod_init_arch aes_mod_init_arch
 static void aes_mod_init_arch(void)
 {
diff --git a/lib/crypto/sparc/aes_asm.S b/lib/crypto/sparc/aes_asm.S
index f291174a72a1d..fd90b129972fb 100644
--- a/lib/crypto/sparc/aes_asm.S
+++ b/lib/crypto/sparc/aes_asm.S
@@ -2,6 +2,7 @@
 #include <linux/linkage.h>
 #include <asm/opcodes.h>
 #include <asm/visasm.h>
+#include <asm/asi.h>
 
 #define ENCRYPT_TWO_ROUNDS(KEY_BASE, I0, I1, T0, T1) \
 	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
@@ -1541,3 +1542,167 @@ ENTRY(aes_sparc64_ctr_crypt_256)
 	retl
 	 stx		%g7, [%o4 + 0x08]
 ENDPROC(aes_sparc64_ctr_crypt_256)
+
+#if IS_ENABLED(CONFIG_CRYPTO_LIB_AES_XTS)
+	/* XTS.  The tweak is kept in %l0/%l1 as little-endian words, so that
+	 * multiplying it by x is a 128-bit shift.  XTS_TWEAK_BE stores it to
+	 * a stack slot little-endian and reloads it big-endian, the byte order
+	 * of the data.  The slot is cleared before returning.
+	 *
+	 * A register window is needed because %g4-%g6 belong to the kernel.
+	 * %l6 points at the slot and %l7 holds 8: an access with an immediate
+	 * ASI cannot also take an immediate offset.
+	 */
+
+#define XTS_DOUBLE							\
+	srax		%l1, 63, %l2;					\
+	and		%l2, 0x87, %l2;					\
+	addcc		%l0, %l0, %l0;					\
+	ADDXC_L1_L1_L1						\
+	xor		%l0, %l2, %l0;
+
+#define XTS_TWEAK_BE(A, B)						\
+	stxa		%l0, [%l6] ASI_PL;				\
+	stxa		%l1, [%l6 + %l7] ASI_PL;			\
+	ldx		[%l6 + 0x00], A;				\
+	ldx		[%l6 + 0x08], B;
+
+	/* %i0=key (encrypt) or &key[key_len] (decrypt), %i1=input,
+	 * %i2=output, %i3=len, %i4=tweak
+	 */
+.macro	__aes_xts_crypt	enc, keylen
+	save		%sp, -192, %sp
+.if \keylen == 256
+.if \enc
+	mov		%i0, %o0
+.else
+	sub		%i0, 0xf0, %o0
+.endif
+.endif
+	mov		8, %l7
+	add		%sp, 2047 + 176, %l6
+	ldxa		[%i4] ASI_PL, %l0
+	ldxa		[%i4 + %l7] ASI_PL, %l1
+.if \enc
+	ldx		[%i0 + 0x00], %g1
+	subcc		%i3, 0x10, %i3
+	be,pn		%xcc, 10f
+	 ldx		[%i0 + 0x08], %g2
+.else
+	ldx		[%i0 - 0x10], %g1
+	subcc		%i3, 0x10, %i3
+	be,pn		%xcc, 10f
+	 ldx		[%i0 - 0x08], %g2
+.endif
+1:	XTS_TWEAK_BE(%g3, %g7)
+	XTS_DOUBLE
+	XTS_TWEAK_BE(%l4, %l5)
+	XTS_DOUBLE
+	ldx		[%i1 + 0x00], %o5
+	xor		%o5, %g3, %o5
+	xor		%o5, %g1, %o5
+	MOVXTOD_O5_F0
+	ldx		[%i1 + 0x08], %o5
+	xor		%o5, %g7, %o5
+	xor		%o5, %g2, %o5
+	MOVXTOD_O5_F2
+	ldx		[%i1 + 0x10], %o5
+	xor		%o5, %l4, %o5
+	xor		%o5, %g1, %o5
+	MOVXTOD_O5_F4
+	ldx		[%i1 + 0x18], %o5
+	xor		%o5, %l5, %o5
+	xor		%o5, %g2, %o5
+	MOVXTOD_O5_F6
+.if \enc && \keylen == 128
+	ENCRYPT_128_2(8, 0, 2, 4, 6, 56, 58, 60, 62)
+.elseif \enc
+	ENCRYPT_256_2(8, 0, 2, 4, 6)
+.elseif \keylen == 128
+	DECRYPT_128_2(8, 0, 2, 4, 6, 56, 58, 60, 62)
+.else
+	DECRYPT_256_2(8, 0, 2, 4, 6)
+.endif
+	MOVXTOD_G3_F60
+	MOVXTOD_G7_F62
+	MOVXTOD_L4_F56
+	MOVXTOD_L5_F58
+	fxor		%f0, %f60, %f0
+	fxor		%f2, %f62, %f2
+	fxor		%f4, %f56, %f4
+	fxor		%f6, %f58, %f6
+	std		%f0, [%i2 + 0x00]
+	std		%f2, [%i2 + 0x08]
+	std		%f4, [%i2 + 0x10]
+	std		%f6, [%i2 + 0x18]
+	subcc		%i3, 0x20, %i3
+	add		%i1, 0x20, %i1
+	brgz		%i3, 1b
+	 add		%i2, 0x20, %i2
+	brlz,pt		%i3, 11f
+	 nop
+10:
+.if \enc && \keylen == 256
+	ldd		[%o0 + 0xd0], %f56
+	ldd		[%o0 + 0xd8], %f58
+	ldd		[%o0 + 0xe0], %f60
+	ldd		[%o0 + 0xe8], %f62
+.elseif \keylen == 256
+	ldd		[%o0 + 0x18], %f56
+	ldd		[%o0 + 0x10], %f58
+	ldd		[%o0 + 0x08], %f60
+	ldd		[%o0 + 0x00], %f62
+.endif
+	XTS_TWEAK_BE(%g3, %g7)
+	XTS_DOUBLE
+	ldx		[%i1 + 0x00], %o5
+	xor		%o5, %g3, %o5
+	xor		%o5, %g1, %o5
+	MOVXTOD_O5_F0
+	ldx		[%i1 + 0x08], %o5
+	xor		%o5, %g7, %o5
+	xor		%o5, %g2, %o5
+	MOVXTOD_O5_F2
+.if \enc && \keylen == 128
+	ENCRYPT_128(8, 0, 2, 4, 6)
+.elseif \enc
+	ENCRYPT_256(8, 0, 2, 4, 6)
+.elseif \keylen == 128
+	DECRYPT_128(8, 0, 2, 4, 6)
+.else
+	DECRYPT_256(8, 0, 2, 4, 6)
+.endif
+	MOVXTOD_G3_F4
+	MOVXTOD_G7_F6
+	fxor		%f0, %f4, %f0
+	fxor		%f2, %f6, %f2
+	std		%f0, [%i2 + 0x00]
+	std		%f2, [%i2 + 0x08]
+11:	stxa		%l0, [%i4] ASI_PL
+	stxa		%l1, [%i4 + %l7] ASI_PL
+	stx		%g0, [%l6 + 0x00]
+	stx		%g0, [%l6 + 0x08]
+	ret
+	 restore
+.endm
+
+	.align		32
+ENTRY(aes_sparc64_xts_encrypt_128)
+	__aes_xts_crypt	1, 128
+ENDPROC(aes_sparc64_xts_encrypt_128)
+
+	.align		32
+ENTRY(aes_sparc64_xts_encrypt_256)
+	__aes_xts_crypt	1, 256
+ENDPROC(aes_sparc64_xts_encrypt_256)
+
+	.align		32
+ENTRY(aes_sparc64_xts_decrypt_128)
+	__aes_xts_crypt	0, 128
+ENDPROC(aes_sparc64_xts_decrypt_128)
+
+	.align		32
+ENTRY(aes_sparc64_xts_decrypt_256)
+	__aes_xts_crypt	0, 256
+ENDPROC(aes_sparc64_xts_decrypt_256)
+#endif /* CONFIG_CRYPTO_LIB_AES_XTS */
-- 
2.43.0

