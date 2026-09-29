Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADED3B83F9;
	Tue, 29 Sep 2026 21:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.189.121.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790716359; cv=none; b=XFCq3bNabLqX+VJWoTbz0NobxI4we0cNMgaQrOrUtLvivOc5H2KlPbK2fDV2c5Qn32zfnoO0d/jKCJetMNG2Y4qD9a8BW3YV8ehOkrrsqw+dO6Gp8oBDNhHFbWYHOzrlHGSBpj1bk6au4AY7IHwlnVclTlQ9GnLY97rEVK65o6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790716359; c=relaxed/simple;
	bh=qmkq2jrzBa7FErUE58lKcVXjb99HTKuaMCom9YNHfSc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A05hkf0w6SeWWvzlrW9E9l81ZRR06wijQmE3nLLR1EG/JXF+2cDk8mNxtYQYFj7fpJZcz56TSi0qF321/RGmAMr72zECZ8XZAX+1Z9vinn8ZMtiZkGp7hydsZlsw7i2MtFlwAYqpXFNsdzLIXGOw9Ypw2jV8e/uU91T66dkn8wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no; spf=pass smtp.mailfrom=itx.no; dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b=jYG74vOv; arc=none smtp.client-ip=91.189.121.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=itx.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=itx.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=itx.no header.i=@itx.no header.b="jYG74vOv"
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1790716354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FVlHNq9H8anSiXiv8AFbp3vNlS/CKb+xmPhdx1yfTH8=;
	b=jYG74vOvJQinyRKaCmcJrrQ98jB/WwvyPIzqSWbrVMlZmtnS13cLxtk7y96zXrMvVoexlC
	IKPrtqqUZwu1ctwUplHLhxT1Z4uTEgxwfexHIbhkFqIRCfru0n/KTqIZsogITTRqeyZNAJ
	Aa/gXsuMsJosDwbUDlO3gMM8m7nhEQQ=
To: Eric Biggers <ebiggers@kernel.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>
Subject: [PATCH] lib/crypto: sparc/aes-xts: Add optimization using the AES opcodes
Date: Tue, 29 Sep 2026 23:12:18 +0200
Message-ID: <20260929211218.4194135-1-stian@itx.no>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 94efa0c9fb36 ("crypto: aes - Add XTS support using
library"), xts(aes) on sparc64 is xts-aes-lib.  sparc64 has no
aes_xts_*_arch(), so that goes block by block through aes_encrypt(),
where 7.2 got the xts template over ecb-aes-sparc64.  On a SPARC M7,
AES-256-XTS through AF_ALG fell from 390 to 144 MiB/s.

Implement aes_xts_encrypt_arch() and aes_xts_decrypt_arch() with the AES
opcodes, for AES-128 and AES-256, two blocks per iteration.  AES-192,
which IEEE 1619 does not specify, and data that is not 8-byte aligned
are left to the generic code.

The tweak is kept as little-endian words, so that multiplying it by x is
a 128-bit shift done with addcc and the VIS3 addxc.  A little-endian
store and an ordinary load through a stack slot give it in the byte
order of the data, and the slot is cleared on return.  The routines open
a register window, as %g4-%g6 belong to the kernel.

On a T7-1 (M7), MiB/s unless noted:

                               xts(ecb-aes-sparc64)  before  after
  AF_ALG, 64 KiB, AES-128                     415      149   1092
  AF_ALG, 64 KiB, AES-256                     390      144    936
  dm-crypt on brd, AES-256:
    sequential read                          1399     1217   2559
    sequential write                         1472     1591   3480
    4 KiB write latency, QD1 (us)            40.6     60.1   32.7

dm-crypt now matches aes-cbc-essiv on the same ramdisk.  On a T4-1,
AES-256 goes from 238 MiB/s with the template to 544, and AES-128
from 252 to 616.

Tested with CONFIG_CRYPTO_SELFTESTS_FULL, and against OpenSSL over
random keys, tweaks and lengths, on both machines.

Fixes: 94efa0c9fb36 ("crypto: aes - Add XTS support using library")
Closes: https://github.com/sparclinux/issues/issues/106
Signed-off-by: Stian Halseth <stian@itx.no>
---

Notes:
    This fixes a regression from 7.3-rc1, so I would like it to go into
    7.3 if possible.  It applies to libcrypto-fixes, v7.3-rc5 and
    libcrypto-next, and on top of the x86/riscv migration series.
    
    xts-aes-lib keeps priority 110.  Nothing else registers xts(aes) on
    sparc64, so it is what dm-crypt gets.  An xts(ecb-aes-sparc64) instance,
    if something asks for one by name, still outranks it until the sparc64
    ECB code moves into the library.
    
    Tested on 7.3-rc5 on a T7-1 and a T4-1: CONFIG_CRYPTO_SELFTESTS_FULL;
    200 random messages per key size against OpenSSL, both directions;
    AES-192 and ciphertext stealing against xts(ecb-aes-sparc64); misaligned
    source and destination through AF_ALG.

 arch/sparc/include/asm/opcodes.h |   6 +
 lib/crypto/sparc/aes.h           |  75 +++++++
 lib/crypto/sparc/aes_asm.S       | 340 +++++++++++++++++++++++++++++++
 3 files changed, 421 insertions(+)

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
index f291174a72a1d..640e2ff8716b0 100644
--- a/lib/crypto/sparc/aes_asm.S
+++ b/lib/crypto/sparc/aes_asm.S
@@ -2,6 +2,7 @@
 #include <linux/linkage.h>
 #include <asm/opcodes.h>
 #include <asm/visasm.h>
+#include <asm/asi.h>
 
 #define ENCRYPT_TWO_ROUNDS(KEY_BASE, I0, I1, T0, T1) \
 	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
@@ -1541,3 +1542,342 @@ ENTRY(aes_sparc64_ctr_crypt_256)
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
+	.align		32
+ENTRY(aes_sparc64_xts_encrypt_128)
+	/* %i0=key, %i1=input, %i2=output, %i3=len, %i4=tweak */
+	save		%sp, -192, %sp
+	mov		8, %l7
+	add		%sp, 2047 + 176, %l6
+	ldxa		[%i4] ASI_PL, %l0
+	ldxa		[%i4 + %l7] ASI_PL, %l1
+	ldx		[%i0 + 0x00], %g1
+	subcc		%i3, 0x10, %i3
+	be,pn		%xcc, 10f
+	 ldx		[%i0 + 0x08], %g2
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
+	ENCRYPT_128_2(8, 0, 2, 4, 6, 56, 58, 60, 62)
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
+10:	XTS_TWEAK_BE(%g3, %g7)
+	XTS_DOUBLE
+	ldx		[%i1 + 0x00], %o5
+	xor		%o5, %g3, %o5
+	xor		%o5, %g1, %o5
+	MOVXTOD_O5_F0
+	ldx		[%i1 + 0x08], %o5
+	xor		%o5, %g7, %o5
+	xor		%o5, %g2, %o5
+	MOVXTOD_O5_F2
+	ENCRYPT_128(8, 0, 2, 4, 6)
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
+ENDPROC(aes_sparc64_xts_encrypt_128)
+
+	.align		32
+ENTRY(aes_sparc64_xts_encrypt_256)
+	/* %i0=key, %i1=input, %i2=output, %i3=len, %i4=tweak */
+	save		%sp, -192, %sp
+	mov		%i0, %o0
+	mov		8, %l7
+	add		%sp, 2047 + 176, %l6
+	ldxa		[%i4] ASI_PL, %l0
+	ldxa		[%i4 + %l7] ASI_PL, %l1
+	ldx		[%i0 + 0x00], %g1
+	subcc		%i3, 0x10, %i3
+	be,pn		%xcc, 10f
+	 ldx		[%i0 + 0x08], %g2
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
+	ENCRYPT_256_2(8, 0, 2, 4, 6)
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
+10:	ldd		[%o0 + 0xd0], %f56
+	ldd		[%o0 + 0xd8], %f58
+	ldd		[%o0 + 0xe0], %f60
+	ldd		[%o0 + 0xe8], %f62
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
+	ENCRYPT_256(8, 0, 2, 4, 6)
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
+ENDPROC(aes_sparc64_xts_encrypt_256)
+
+	.align		32
+ENTRY(aes_sparc64_xts_decrypt_128)
+	/* %i0=&key[key_len], %i1=input, %i2=output, %i3=len, %i4=tweak */
+	save		%sp, -192, %sp
+	mov		8, %l7
+	add		%sp, 2047 + 176, %l6
+	ldxa		[%i4] ASI_PL, %l0
+	ldxa		[%i4 + %l7] ASI_PL, %l1
+	ldx		[%i0 - 0x10], %g1
+	subcc		%i3, 0x10, %i3
+	be,pn		%xcc, 10f
+	 ldx		[%i0 - 0x08], %g2
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
+	DECRYPT_128_2(8, 0, 2, 4, 6, 56, 58, 60, 62)
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
+10:	XTS_TWEAK_BE(%g3, %g7)
+	XTS_DOUBLE
+	ldx		[%i1 + 0x00], %o5
+	xor		%o5, %g3, %o5
+	xor		%o5, %g1, %o5
+	MOVXTOD_O5_F0
+	ldx		[%i1 + 0x08], %o5
+	xor		%o5, %g7, %o5
+	xor		%o5, %g2, %o5
+	MOVXTOD_O5_F2
+	DECRYPT_128(8, 0, 2, 4, 6)
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
+ENDPROC(aes_sparc64_xts_decrypt_128)
+
+	.align		32
+ENTRY(aes_sparc64_xts_decrypt_256)
+	/* %i0=&key[key_len], %i1=input, %i2=output, %i3=len, %i4=tweak */
+	save		%sp, -192, %sp
+	sub		%i0, 0xf0, %o0
+	mov		8, %l7
+	add		%sp, 2047 + 176, %l6
+	ldxa		[%i4] ASI_PL, %l0
+	ldxa		[%i4 + %l7] ASI_PL, %l1
+	ldx		[%i0 - 0x10], %g1
+	subcc		%i3, 0x10, %i3
+	be,pn		%xcc, 10f
+	 ldx		[%i0 - 0x08], %g2
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
+	DECRYPT_256_2(8, 0, 2, 4, 6)
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
+10:	ldd		[%o0 + 0x18], %f56
+	ldd		[%o0 + 0x10], %f58
+	ldd		[%o0 + 0x08], %f60
+	ldd		[%o0 + 0x00], %f62
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
+	DECRYPT_256(8, 0, 2, 4, 6)
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
+ENDPROC(aes_sparc64_xts_decrypt_256)
+#endif /* CONFIG_CRYPTO_LIB_AES_XTS */

base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.43.0

