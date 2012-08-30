From: David Miller <davem@davemloft.net>
Subject: [PATCH 1/5] sparc64: Move AES driver over to a methods based
 implementation.
Date: Thu, 30 Aug 2012 11:46:13 -0400 (EDT)
Message-ID: <20120830.114613.2269457435066229953.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Instead of testing and branching off of the key size on every
encrypt/decrypt call, use method ops assigned at key set time.

Reverse the order of float registers used for decryption to make
future changes easier.

Align all assembler routines on a 32-byte boundary.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/crypto/aes_asm.S  |  879 ++++++++++++++++++++++++++++--------------
 arch/sparc/crypto/aes_glue.c |  186 ++++++---
 2 files changed, 728 insertions(+), 337 deletions(-)

diff --git a/arch/sparc/crypto/aes_asm.S b/arch/sparc/crypto/aes_asm.S
index f656dc7..50faae0 100644
--- a/arch/sparc/crypto/aes_asm.S
+++ b/arch/sparc/crypto/aes_asm.S
@@ -44,8 +44,8 @@
 	.word	0x85b02307;
 #define MOVXTOD_O0_F0		\
 	.word	0x81b02308;
-#define MOVXTOD_O1_F2		\
-	.word	0x85b02309;
+#define MOVXTOD_O5_F2		\
+	.word	0x85b0230d;
 
 #define ENCRYPT_TWO_ROUNDS(KEY_BASE, I0, I1, T0, T1) \
 	AES_EROUND01(KEY_BASE +  0, I0, I1, T0) \
@@ -86,45 +86,46 @@
 	ENCRYPT_TWO_ROUNDS(KEY_BASE + 40, I0, I1, T0, T1) \
 	ENCRYPT_TWO_ROUNDS_LAST(KEY_BASE + 48, I0, I1, T0, T1)
 
-#define DECRYPT_TWO_ROUNDS(KEY_TOP, I0, I1, T0, T1) \
-	AES_DROUND23(KEY_TOP -  2, I0, I1, T1) \
-	AES_DROUND01(KEY_TOP -  4, I0, I1, T0) \
-	AES_DROUND23(KEY_TOP -  6, T0, T1, I1) \
-	AES_DROUND01(KEY_TOP -  8, T0, T1, I0)
+#define DECRYPT_TWO_ROUNDS(KEY_BASE, I0, I1, T0, T1) \
+	AES_DROUND23(KEY_BASE +  0, I0, I1, T1) \
+	AES_DROUND01(KEY_BASE +  2, I0, I1, T0) \
+	AES_DROUND23(KEY_BASE +  4, T0, T1, I1) \
+	AES_DROUND01(KEY_BASE +  6, T0, T1, I0)
 
-#define DECRYPT_TWO_ROUNDS_LAST(KEY_TOP, I0, I1, T0, T1) \
-	AES_DROUND23(KEY_TOP -  2, I0, I1, T1) \
-	AES_DROUND01(KEY_TOP -  4, I0, I1, T0) \
-	AES_DROUND23_L(KEY_TOP -  6, T0, T1, I1) \
-	AES_DROUND01_L(KEY_TOP -  8, T0, T1, I0)
+#define DECRYPT_TWO_ROUNDS_LAST(KEY_BASE, I0, I1, T0, T1) \
+	AES_DROUND23(KEY_BASE +  0, I0, I1, T1) \
+	AES_DROUND01(KEY_BASE +  2, I0, I1, T0) \
+	AES_DROUND23_L(KEY_BASE +  4, T0, T1, I1) \
+	AES_DROUND01_L(KEY_BASE +  6, T0, T1, I0)
 
 	/* 10 rounds */
-#define DECRYPT_128(KEY_TOP, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP -  0, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP -  8, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 16, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 24, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS_LAST(KEY_TOP - 32, I0, I1, T0, T1)
+#define DECRYPT_128(KEY_BASE, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE +  8, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 16, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS_LAST(KEY_BASE + 32, I0, I1, T0, T1)
 
 	/* 12 rounds */
-#define DECRYPT_192(KEY_TOP, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP -  0, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP -  8, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 16, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 24, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 32, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS_LAST(KEY_TOP - 40, I0, I1, T0, T1)
+#define DECRYPT_192(KEY_BASE, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE +  8, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 16, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 32, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS_LAST(KEY_BASE + 40, I0, I1, T0, T1)
 
 	/* 14 rounds */
-#define DECRYPT_256(KEY_TOP, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP -  0, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP -  8, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 16, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 24, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 32, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS(KEY_TOP - 40, I0, I1, T0, T1) \
-	DECRYPT_TWO_ROUNDS_LAST(KEY_TOP - 48, I0, I1, T0, T1)
-
+#define DECRYPT_256(KEY_BASE, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE +  0, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE +  8, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 16, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 24, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 32, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS(KEY_BASE + 40, I0, I1, T0, T1) \
+	DECRYPT_TWO_ROUNDS_LAST(KEY_BASE + 48, I0, I1, T0, T1)
+
+	.align	32
 ENTRY(aes_sparc64_key_expand)
 	/* %o0=input_key, %o1=output_key, %o2=key_len */
 	VISEntry
@@ -314,34 +315,63 @@ ENTRY(aes_sparc64_key_expand)
 	 VISExit
 ENDPROC(aes_sparc64_key_expand)
 
-ENTRY(aes_sparc64_encrypt)
-	/* %o0=key, %o1=input, %o2=output, %o3=key_len */
+	.align		32
+ENTRY(aes_sparc64_encrypt_128)
+	/* %o0=key, %o1=input, %o2=output */
 	VISEntry
 	ld		[%o1 + 0x00], %f4
 	ld		[%o1 + 0x04], %f5
 	ld		[%o1 + 0x08], %f6
 	ld		[%o1 + 0x0c], %f7
-
 	ldd		[%o0 + 0x00], %f8
 	ldd		[%o0 + 0x08], %f10
-	cmp		%o3, 24
+	ldd		[%o0 + 0x10], %f12
+	ldd		[%o0 + 0x18], %f14
+	ldd		[%o0 + 0x20], %f16
+	ldd		[%o0 + 0x28], %f18
+	ldd		[%o0 + 0x30], %f20
+	ldd		[%o0 + 0x38], %f22
+	ldd		[%o0 + 0x40], %f24
+	ldd		[%o0 + 0x48], %f26
+	ldd		[%o0 + 0x50], %f28
+	ldd		[%o0 + 0x58], %f30
+	ldd		[%o0 + 0x60], %f32
+	ldd		[%o0 + 0x68], %f34
+	ldd		[%o0 + 0x70], %f36
+	ldd		[%o0 + 0x78], %f38
+	ldd		[%o0 + 0x80], %f40
+	ldd		[%o0 + 0x88], %f42
+	ldd		[%o0 + 0x90], %f44
+	ldd		[%o0 + 0x98], %f46
+	ldd		[%o0 + 0xa0], %f48
+	ldd		[%o0 + 0xa8], %f50
 	fxor		%f8, %f4, %f4
-	bl		2f
-	 fxor		%f10, %f6, %f6
+	fxor		%f10, %f6, %f6
+	ENCRYPT_128(12, 4, 6, 0, 2)
+	st		%f4, [%o2 + 0x00]
+	st		%f5, [%o2 + 0x04]
+	st		%f6, [%o2 + 0x08]
+	st		%f7, [%o2 + 0x0c]
+	retl
+	 VISExit
+ENDPROC(aes_sparc64_encrypt_128)
 
-	be		1f
-	 ldd		[%o0 + 0x10], %f8
+	.align		32
+ENTRY(aes_sparc64_encrypt_192)
+	/* %o0=key, %o1=input, %o2=output */
+	VISEntry
+	ld		[%o1 + 0x00], %f4
+	ld		[%o1 + 0x04], %f5
+	ld		[%o1 + 0x08], %f6
+	ld		[%o1 + 0x0c], %f7
 
-	ldd		[%o0 + 0x18], %f10
-	ldd		[%o0 + 0x20], %f12
-	ldd		[%o0 + 0x28], %f14
-	add		%o0, 0x20, %o0
+	ldd		[%o0 + 0x00], %f8
+	ldd		[%o0 + 0x08], %f10
 
-	ENCRYPT_TWO_ROUNDS(8, 4, 6, 0, 2)
+	fxor		%f8, %f4, %f4
+	fxor		%f10, %f6, %f6
 
 	ldd		[%o0 + 0x10], %f8
-
-1:
 	ldd		[%o0 + 0x18], %f10
 	ldd		[%o0 + 0x20], %f12
 	ldd		[%o0 + 0x28], %f14
@@ -349,7 +379,6 @@ ENTRY(aes_sparc64_encrypt)
 
 	ENCRYPT_TWO_ROUNDS(8, 4, 6, 0, 2)
 
-2:
 	ldd		[%o0 + 0x10], %f12
 	ldd		[%o0 + 0x18], %f14
 	ldd		[%o0 + 0x20], %f16
@@ -381,66 +410,63 @@ ENTRY(aes_sparc64_encrypt)
 
 	retl
 	 VISExit
-ENDPROC(aes_sparc64_encrypt)
+ENDPROC(aes_sparc64_encrypt_192)
 
-ENTRY(aes_sparc64_decrypt)
-	/* %o0=key, %o1=input, %o2=output, %o3=key_len, %o4=exp_key_len */
+	.align		32
+ENTRY(aes_sparc64_encrypt_256)
+	/* %o0=key, %o1=input, %o2=output */
 	VISEntry
 	ld		[%o1 + 0x00], %f4
-	add		%o0, %o4, %o0
 	ld		[%o1 + 0x04], %f5
 	ld		[%o1 + 0x08], %f6
 	ld		[%o1 + 0x0c], %f7
-	
-	ldd		[%o0 - 0x08], %f8
-	ldd		[%o0 - 0x10], %f10
 
-	cmp		%o3, 24
-	fxor		%f10, %f4, %f4
-	bl		2f
-	 fxor		%f8, %f6, %f6
+	ldd		[%o0 + 0x00], %f8
+	ldd		[%o0 + 0x08], %f10
 
-	be		1f
-	 ldd		[%o0 - 0x30], %f8
+	fxor		%f8, %f4, %f4
+	fxor		%f10, %f6, %f6
 
-	ldd		[%o0 - 0x28], %f10
-	ldd		[%o0 - 0x20], %f12
-	ldd		[%o0 - 0x18], %f14
-	sub		%o0, 0x20, %o0
+	ldd		[%o0 + 0x10], %f8
 
-	DECRYPT_TWO_ROUNDS(16, 4, 6, 0, 2)
+	ldd		[%o0 + 0x18], %f10
+	ldd		[%o0 + 0x20], %f12
+	ldd		[%o0 + 0x28], %f14
+	add		%o0, 0x20, %o0
 
-	ldd		[%o0 - 0x30], %f8
-1:
-	ldd		[%o0 - 0x28], %f10
-	ldd		[%o0 - 0x20], %f12
-	ldd		[%o0 - 0x18], %f14
-	sub		%o0, 0x20, %o0
+	ENCRYPT_TWO_ROUNDS(8, 4, 6, 0, 2)
 
-	DECRYPT_TWO_ROUNDS(16, 4, 6, 0, 2)
-2:
-	ldd		[%o0 - 0xb0], %f12
-	ldd		[%o0 - 0xa8], %f14
-	ldd		[%o0 - 0xa0], %f16
-	ldd		[%o0 - 0x98], %f18
-	ldd		[%o0 - 0x90], %f20
-	ldd		[%o0 - 0x88], %f22
-	ldd		[%o0 - 0x80], %f24
-	ldd		[%o0 - 0x78], %f26
-	ldd		[%o0 - 0x70], %f28
-	ldd		[%o0 - 0x68], %f30
-	ldd		[%o0 - 0x60], %f32
-	ldd		[%o0 - 0x58], %f34
-	ldd		[%o0 - 0x50], %f36
-	ldd		[%o0 - 0x48], %f38
-	ldd		[%o0 - 0x40], %f40
-	ldd		[%o0 - 0x38], %f42
-	ldd		[%o0 - 0x30], %f44
-	ldd		[%o0 - 0x28], %f46
-	ldd		[%o0 - 0x20], %f48
-	ldd		[%o0 - 0x18], %f50
-
-	DECRYPT_128(52, 4, 6, 0, 2)
+	ldd		[%o0 + 0x10], %f8
+
+	ldd		[%o0 + 0x18], %f10
+	ldd		[%o0 + 0x20], %f12
+	ldd		[%o0 + 0x28], %f14
+	add		%o0, 0x20, %o0
+
+	ENCRYPT_TWO_ROUNDS(8, 4, 6, 0, 2)
+
+	ldd		[%o0 + 0x10], %f12
+	ldd		[%o0 + 0x18], %f14
+	ldd		[%o0 + 0x20], %f16
+	ldd		[%o0 + 0x28], %f18
+	ldd		[%o0 + 0x30], %f20
+	ldd		[%o0 + 0x38], %f22
+	ldd		[%o0 + 0x40], %f24
+	ldd		[%o0 + 0x48], %f26
+	ldd		[%o0 + 0x50], %f28
+	ldd		[%o0 + 0x58], %f30
+	ldd		[%o0 + 0x60], %f32
+	ldd		[%o0 + 0x68], %f34
+	ldd		[%o0 + 0x70], %f36
+	ldd		[%o0 + 0x78], %f38
+	ldd		[%o0 + 0x80], %f40
+	ldd		[%o0 + 0x88], %f42
+	ldd		[%o0 + 0x90], %f44
+	ldd		[%o0 + 0x98], %f46
+	ldd		[%o0 + 0xa0], %f48
+	ldd		[%o0 + 0xa8], %f50
+
+	ENCRYPT_128(12, 4, 6, 0, 2)
 
 	st		%f4, [%o2 + 0x00]
 	st		%f5, [%o2 + 0x04]
@@ -449,15 +475,231 @@ ENTRY(aes_sparc64_decrypt)
 
 	retl
 	 VISExit
-ENDPROC(aes_sparc64_decrypt)
+ENDPROC(aes_sparc64_encrypt_256)
 
-ENTRY(aes_sparc64_load_decrypt_keys)
+	.align		32
+ENTRY(aes_sparc64_decrypt_128)
+	/* %o0=key, %o1=input, %o2=output */
+	VISEntry
+	ld		[%o1 + 0x00], %f4
+	ld		[%o1 + 0x04], %f5
+	ld		[%o1 + 0x08], %f6
+	ld		[%o1 + 0x0c], %f7
+	ldd		[%o0 + 0xa0], %f8
+	ldd		[%o0 + 0xa8], %f10
+	ldd		[%o0 + 0x98], %f12
+	ldd		[%o0 + 0x90], %f14
+	ldd		[%o0 + 0x88], %f16
+	ldd		[%o0 + 0x80], %f18
+	ldd		[%o0 + 0x78], %f20
+	ldd		[%o0 + 0x70], %f22
+	ldd		[%o0 + 0x68], %f24
+	ldd		[%o0 + 0x60], %f26
+	ldd		[%o0 + 0x58], %f28
+	ldd		[%o0 + 0x50], %f30
+	ldd		[%o0 + 0x48], %f32
+	ldd		[%o0 + 0x40], %f34
+	ldd		[%o0 + 0x38], %f36
+	ldd		[%o0 + 0x30], %f38
+	ldd		[%o0 + 0x28], %f40
+	ldd		[%o0 + 0x20], %f42
+	ldd		[%o0 + 0x18], %f44
+	ldd		[%o0 + 0x10], %f46
+	ldd		[%o0 + 0x08], %f48
+	ldd		[%o0 + 0x00], %f50
+	fxor		%f8, %f4, %f4
+	fxor		%f10, %f6, %f6
+	DECRYPT_128(12, 4, 6, 0, 2)
+	st		%f4, [%o2 + 0x00]
+	st		%f5, [%o2 + 0x04]
+	st		%f6, [%o2 + 0x08]
+	st		%f7, [%o2 + 0x0c]
+	retl
+	 VISExit
+ENDPROC(aes_sparc64_decrypt_128)
+
+	.align		32
+ENTRY(aes_sparc64_decrypt_192)
+	/* %o0=key, %o1=input, %o2=output */
+	VISEntry
+	ld		[%o1 + 0x00], %f4
+	ld		[%o1 + 0x04], %f5
+	ld		[%o1 + 0x08], %f6
+	ld		[%o1 + 0x0c], %f7
+	ldd		[%o0 + 0xc0], %f8
+	ldd		[%o0 + 0xc8], %f10
+	ldd		[%o0 + 0xb8], %f12
+	ldd		[%o0 + 0xb0], %f14
+	ldd		[%o0 + 0xa8], %f16
+	ldd		[%o0 + 0xa0], %f18
+	fxor		%f8, %f4, %f4
+	fxor		%f10, %f6, %f6
+	ldd		[%o0 + 0x98], %f20
+	ldd		[%o0 + 0x90], %f22
+	ldd		[%o0 + 0x88], %f24
+	ldd		[%o0 + 0x80], %f26
+	DECRYPT_TWO_ROUNDS(12, 4, 6, 0, 2)
+	ldd		[%o0 + 0x78], %f28
+	ldd		[%o0 + 0x70], %f30
+	ldd		[%o0 + 0x68], %f32
+	ldd		[%o0 + 0x60], %f34
+	ldd		[%o0 + 0x58], %f36
+	ldd		[%o0 + 0x50], %f38
+	ldd		[%o0 + 0x48], %f40
+	ldd		[%o0 + 0x40], %f42
+	ldd		[%o0 + 0x38], %f44
+	ldd		[%o0 + 0x30], %f46
+	ldd		[%o0 + 0x28], %f48
+	ldd		[%o0 + 0x20], %f50
+	ldd		[%o0 + 0x18], %f52
+	ldd		[%o0 + 0x10], %f54
+	ldd		[%o0 + 0x08], %f56
+	ldd		[%o0 + 0x00], %f58
+	DECRYPT_128(20, 4, 6, 0, 2)
+	st		%f4, [%o2 + 0x00]
+	st		%f5, [%o2 + 0x04]
+	st		%f6, [%o2 + 0x08]
+	st		%f7, [%o2 + 0x0c]
+	retl
+	 VISExit
+ENDPROC(aes_sparc64_decrypt_192)
+
+	.align		32
+ENTRY(aes_sparc64_decrypt_256)
+	/* %o0=key, %o1=input, %o2=output */
+	VISEntry
+	ld		[%o1 + 0x00], %f4
+	ld		[%o1 + 0x04], %f5
+	ld		[%o1 + 0x08], %f6
+	ld		[%o1 + 0x0c], %f7
+	ldd		[%o0 + 0xe0], %f8
+	ldd		[%o0 + 0xe8], %f10
+	ldd		[%o0 + 0xd8], %f12
+	ldd		[%o0 + 0xd0], %f14
+	ldd		[%o0 + 0xc8], %f16
+	fxor		%f8, %f4, %f4
+	ldd		[%o0 + 0xc0], %f18
+	fxor		%f10, %f6, %f6
+	ldd		[%o0 + 0xb8], %f20
+	AES_DROUND23(12, 4, 6, 2)
+	ldd		[%o0 + 0xb0], %f22
+	AES_DROUND01(14, 4, 6, 0)
+	ldd		[%o0 + 0xa8], %f24
+	AES_DROUND23(16, 0, 2, 6)
+	ldd		[%o0 + 0xa0], %f26
+	AES_DROUND01(18, 0, 2, 4)
+	ldd		[%o0 + 0x98], %f12
+	AES_DROUND23(20, 4, 6, 2)
+	ldd		[%o0 + 0x90], %f14
+	AES_DROUND01(22, 4, 6, 0)
+	ldd		[%o0 + 0x88], %f16
+	AES_DROUND23(24, 0, 2, 6)
+	ldd		[%o0 + 0x80], %f18
+	AES_DROUND01(26, 0, 2, 4)
+	ldd		[%o0 + 0x78], %f20
+	AES_DROUND23(12, 4, 6, 2)
+	ldd		[%o0 + 0x70], %f22
+	AES_DROUND01(14, 4, 6, 0)
+	ldd		[%o0 + 0x68], %f24
+	AES_DROUND23(16, 0, 2, 6)
+	ldd		[%o0 + 0x60], %f26
+	AES_DROUND01(18, 0, 2, 4)
+	ldd		[%o0 + 0x58], %f28
+	AES_DROUND23(20, 4, 6, 2)
+	ldd		[%o0 + 0x50], %f30
+	AES_DROUND01(22, 4, 6, 0)
+	ldd		[%o0 + 0x48], %f32
+	AES_DROUND23(24, 0, 2, 6)
+	ldd		[%o0 + 0x40], %f34
+	AES_DROUND01(26, 0, 2, 4)
+	ldd		[%o0 + 0x38], %f36
+	AES_DROUND23(28, 4, 6, 2)
+	ldd		[%o0 + 0x30], %f38
+	AES_DROUND01(30, 4, 6, 0)
+	ldd		[%o0 + 0x28], %f40
+	AES_DROUND23(32, 0, 2, 6)
+	ldd		[%o0 + 0x20], %f42
+	AES_DROUND01(34, 0, 2, 4)
+	ldd		[%o0 + 0x18], %f44
+	AES_DROUND23(36, 4, 6, 2)
+	ldd		[%o0 + 0x10], %f46
+	AES_DROUND01(38, 4, 6, 0)
+	ldd		[%o0 + 0x08], %f48
+	AES_DROUND23(40, 0, 2, 6)
+	ldd		[%o0 + 0x00], %f50
+	AES_DROUND01(42, 0, 2, 4)
+	AES_DROUND23(44, 4, 6, 2)
+	AES_DROUND01(46, 4, 6, 0)
+	AES_DROUND23_L(48, 0, 2, 6)
+	AES_DROUND01_L(50, 0, 2, 4)
+	st		%f4, [%o2 + 0x00]
+	st		%f5, [%o2 + 0x04]
+	st		%f6, [%o2 + 0x08]
+	st		%f7, [%o2 + 0x0c]
+	retl
+	 VISExit
+ENDPROC(aes_sparc64_decrypt_256)
+
+	.align		32
+ENTRY(aes_sparc64_load_encrypt_keys_128)
 	/* %o0=key */
-	ba,pt		%xcc, aes_sparc64_load_encrypt_keys
-	 sub		%o0, 0x10, %o0
-ENDPROC(aes_sparc64_load_decrypt_keys)
+	VISEntry
+	ldd		[%o0 + 0x10], %f8
+	ldd		[%o0 + 0x18], %f10
+	ldd		[%o0 + 0x20], %f12
+	ldd		[%o0 + 0x28], %f14
+	ldd		[%o0 + 0x30], %f16
+	ldd		[%o0 + 0x38], %f18
+	ldd		[%o0 + 0x40], %f20
+	ldd		[%o0 + 0x48], %f22
+	ldd		[%o0 + 0x50], %f24
+	ldd		[%o0 + 0x58], %f26
+	ldd		[%o0 + 0x60], %f28
+	ldd		[%o0 + 0x68], %f30
+	ldd		[%o0 + 0x70], %f32
+	ldd		[%o0 + 0x78], %f34
+	ldd		[%o0 + 0x80], %f36
+	ldd		[%o0 + 0x88], %f38
+	ldd		[%o0 + 0x90], %f40
+	ldd		[%o0 + 0x98], %f42
+	ldd		[%o0 + 0xa0], %f44
+	retl
+	 ldd		[%o0 + 0xa8], %f46
+ENDPROC(aes_sparc64_load_encrypt_keys_128)
 
-ENTRY(aes_sparc64_load_encrypt_keys)
+	.align		32
+ENTRY(aes_sparc64_load_encrypt_keys_192)
+	/* %o0=key */
+	VISEntry
+	ldd		[%o0 + 0x10], %f8
+	ldd		[%o0 + 0x18], %f10
+	ldd		[%o0 + 0x20], %f12
+	ldd		[%o0 + 0x28], %f14
+	ldd		[%o0 + 0x30], %f16
+	ldd		[%o0 + 0x38], %f18
+	ldd		[%o0 + 0x40], %f20
+	ldd		[%o0 + 0x48], %f22
+	ldd		[%o0 + 0x50], %f24
+	ldd		[%o0 + 0x58], %f26
+	ldd		[%o0 + 0x60], %f28
+	ldd		[%o0 + 0x68], %f30
+	ldd		[%o0 + 0x70], %f32
+	ldd		[%o0 + 0x78], %f34
+	ldd		[%o0 + 0x80], %f36
+	ldd		[%o0 + 0x88], %f38
+	ldd		[%o0 + 0x90], %f40
+	ldd		[%o0 + 0x98], %f42
+	ldd		[%o0 + 0xa0], %f44
+	ldd		[%o0 + 0xa8], %f46
+	ldd		[%o0 + 0xb0], %f48
+	ldd		[%o0 + 0xb8], %f50
+	ldd		[%o0 + 0xc0], %f52
+	retl
+	 ldd		[%o0 + 0xc8], %f54
+ENDPROC(aes_sparc64_load_encrypt_keys_192)
+
+	.align		32
+ENTRY(aes_sparc64_load_encrypt_keys_256)
 	/* %o0=key */
 	VISEntry
 	ldd		[%o0 + 0x10], %f8
@@ -489,171 +731,241 @@ ENTRY(aes_sparc64_load_encrypt_keys)
 	ldd		[%o0 + 0xe0], %f60
 	retl
 	 ldd		[%o0 + 0xe8], %f62
-ENDPROC(aes_sparc64_load_encrypt_keys)
+ENDPROC(aes_sparc64_load_encrypt_keys_256)
+
+	.align		32
+ENTRY(aes_sparc64_load_decrypt_keys_128)
+	/* %o0=key */
+	VISEntry
+	ldd		[%o0 + 0x98], %f8
+	ldd		[%o0 + 0x90], %f10
+	ldd		[%o0 + 0x88], %f12
+	ldd		[%o0 + 0x80], %f14
+	ldd		[%o0 + 0x78], %f16
+	ldd		[%o0 + 0x70], %f18
+	ldd		[%o0 + 0x68], %f20
+	ldd		[%o0 + 0x60], %f22
+	ldd		[%o0 + 0x58], %f24
+	ldd		[%o0 + 0x50], %f26
+	ldd		[%o0 + 0x48], %f28
+	ldd		[%o0 + 0x40], %f30
+	ldd		[%o0 + 0x38], %f32
+	ldd		[%o0 + 0x30], %f34
+	ldd		[%o0 + 0x28], %f36
+	ldd		[%o0 + 0x20], %f38
+	ldd		[%o0 + 0x18], %f40
+	ldd		[%o0 + 0x10], %f42
+	ldd		[%o0 + 0x08], %f44
+	retl
+	 ldd		[%o0 + 0x00], %f46
+ENDPROC(aes_sparc64_load_decrypt_keys_128)
 
-ENTRY(aes_sparc64_ecb_encrypt)
-	/* %o0=key, %o1=input, %o2=output, %o3=key_len, %o4=len */
+	.align		32
+ENTRY(aes_sparc64_load_decrypt_keys_192)
+	/* %o0=key */
+	VISEntry
+	ldd		[%o0 + 0xb8], %f8
+	ldd		[%o0 + 0xb0], %f10
+	ldd		[%o0 + 0xa8], %f12
+	ldd		[%o0 + 0xa0], %f14
+	ldd		[%o0 + 0x98], %f16
+	ldd		[%o0 + 0x90], %f18
+	ldd		[%o0 + 0x88], %f20
+	ldd		[%o0 + 0x80], %f22
+	ldd		[%o0 + 0x78], %f24
+	ldd		[%o0 + 0x70], %f26
+	ldd		[%o0 + 0x68], %f28
+	ldd		[%o0 + 0x60], %f30
+	ldd		[%o0 + 0x58], %f32
+	ldd		[%o0 + 0x50], %f34
+	ldd		[%o0 + 0x48], %f36
+	ldd		[%o0 + 0x40], %f38
+	ldd		[%o0 + 0x38], %f40
+	ldd		[%o0 + 0x30], %f42
+	ldd		[%o0 + 0x28], %f44
+	ldd		[%o0 + 0x20], %f46
+	ldd		[%o0 + 0x18], %f48
+	ldd		[%o0 + 0x10], %f50
+	ldd		[%o0 + 0x08], %f52
+	retl
+	 ldd		[%o0 + 0x00], %f54
+ENDPROC(aes_sparc64_load_decrypt_keys_192)
+
+	.align		32
+ENTRY(aes_sparc64_load_decrypt_keys_256)
+	/* %o0=key */
+	VISEntry
+	ldd		[%o0 + 0xd8], %f8
+	ldd		[%o0 + 0xd0], %f10
+	ldd		[%o0 + 0xc8], %f12
+	ldd		[%o0 + 0xc0], %f14
+	ldd		[%o0 + 0xb8], %f16
+	ldd		[%o0 + 0xb0], %f18
+	ldd		[%o0 + 0xa8], %f20
+	ldd		[%o0 + 0xa0], %f22
+	ldd		[%o0 + 0x98], %f24
+	ldd		[%o0 + 0x90], %f26
+	ldd		[%o0 + 0x88], %f28
+	ldd		[%o0 + 0x80], %f30
+	ldd		[%o0 + 0x78], %f32
+	ldd		[%o0 + 0x70], %f34
+	ldd		[%o0 + 0x68], %f36
+	ldd		[%o0 + 0x60], %f38
+	ldd		[%o0 + 0x58], %f40
+	ldd		[%o0 + 0x50], %f42
+	ldd		[%o0 + 0x48], %f44
+	ldd		[%o0 + 0x40], %f46
+	ldd		[%o0 + 0x38], %f48
+	ldd		[%o0 + 0x30], %f50
+	ldd		[%o0 + 0x28], %f52
+	ldd		[%o0 + 0x20], %f54
+	ldd		[%o0 + 0x18], %f56
+	ldd		[%o0 + 0x10], %f58
+	ldd		[%o0 + 0x08], %f60
+	retl
+	 ldd		[%o0 + 0x00], %f62
+ENDPROC(aes_sparc64_load_decrypt_keys_256)
+
+	.align		32
+ENTRY(aes_sparc64_ecb_encrypt_128)
+	/* %o0=key, %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 + 0x00], %g1
 	ldx		[%o0 + 0x08], %g2
-	cmp		%o3, 24
-	bl		2f
-	 nop
-	be		1f
-	 nop
-
-0:
-	/* 256-bit key */
-	ldx		[%o1 + 0x00], %g3
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	ENCRYPT_256(8, 4, 6, 0, 2)
-
+	ENCRYPT_128(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 0b
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
 	retl
 	 nop
+ENDPROC(aes_sparc64_ecb_encrypt_128)
 
-1:
-	/* 192-bit key */
-	ldx		[%o1 + 0x00], %g3
+	.align		32
+ENTRY(aes_sparc64_ecb_encrypt_192)
+	/* %o0=key, %o1=input, %o2=output, %o3=len */
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
 	ENCRYPT_192(8, 4, 6, 0, 2)
-
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
+	subcc		%o3, 0x10, %o3
 	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
 	retl
 	 nop
+ENDPROC(aes_sparc64_ecb_encrypt_192)
 
-2:
-	/* 128-bit key */
-	ldx		[%o1 + 0x00], %g3
+	.align		32
+ENTRY(aes_sparc64_ecb_encrypt_256)
+	/* %o0=key, %o1=input, %o2=output, %o3=len */
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	ENCRYPT_128(8, 4, 6, 0, 2)
-
+	ENCRYPT_256(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 2b
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
 	retl
 	 nop
-ENDPROC(aes_sparc64_ecb_encrypt)
+ENDPROC(aes_sparc64_ecb_encrypt_256)
 
-ENTRY(aes_sparc64_ecb_decrypt)
-	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=key_len, %o4=len, %o5=iv */
+	.align		32
+ENTRY(aes_sparc64_ecb_decrypt_128)
+	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
 	ldx		[%o0 - 0x10], %g1
 	ldx		[%o0 - 0x08], %g2
-	cmp		%o3, 24
-	bl		2f
-	 nop
-	be		1f
-	 nop
-
-0:
-	/* 256-bit key */
-	ldx		[%o1 + 0x00], %g3
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	DECRYPT_256(64, 4, 6, 0, 2)
-
+	DECRYPT_128(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 0b
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
 	retl
 	 nop
+ENDPROC(aes_sparc64_ecb_decrypt_128)
 
-1:
-	/* 192-bit key */
-	ldx		[%o1 + 0x00], %g3
+	.align		32
+ENTRY(aes_sparc64_ecb_decrypt_192)
+	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
+	ldx		[%o0 - 0x10], %g1
+	ldx		[%o0 - 0x08], %g2
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	DECRYPT_192(56, 4, 6, 0, 2)
-
+	DECRYPT_192(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
+	subcc		%o3, 0x10, %o3
 	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
 	retl
 	 nop
+ENDPROC(aes_sparc64_ecb_decrypt_192)
 
-2:
-	/* 128-bit key */
-	ldx		[%o1 + 0x00], %g3
+	.align		32
+ENTRY(aes_sparc64_ecb_decrypt_256)
+	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len */
+	ldx		[%o0 - 0x10], %g1
+	ldx		[%o0 - 0x08], %g2
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	DECRYPT_128(48, 4, 6, 0, 2)
-
+	DECRYPT_256(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 2b
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
 	retl
 	 nop
-ENDPROC(aes_sparc64_ecb_decrypt)
+ENDPROC(aes_sparc64_ecb_decrypt_256)
 
-ENTRY(aes_sparc64_cbc_encrypt)
-	/* %o0=key, %o1=input, %o2=output, %o3=key_len, %o4=len */
-	ldd		[%o5 + 0x00], %f4
-	ldd		[%o5 + 0x08], %f6
+	.align		32
+ENTRY(aes_sparc64_cbc_encrypt_128)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldd		[%o4 + 0x00], %f4
+	ldd		[%o4 + 0x08], %f6
 	ldx		[%o0 + 0x00], %g1
 	ldx		[%o0 + 0x08], %g2
-	cmp		%o3, 24
-	bl		2f
-	 nop
-	be		1f
-	 nop
-
-0:
-	/* 256-bit key */
-	ldx		[%o1 + 0x00], %g3
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
@@ -662,24 +974,26 @@ ENTRY(aes_sparc64_cbc_encrypt)
 	MOVXTOD_G7_F2
 	fxor		%f4, %f0, %f4
 	fxor		%f6, %f2, %f6
-
-	ENCRYPT_256(8, 4, 6, 0, 2)
-
+	ENCRYPT_128(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 0b
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
-	std		%f4, [%o5 + 0x00]
-	std		%f6, [%o5 + 0x08]
-
+	std		%f4, [%o4 + 0x00]
+	std		%f6, [%o4 + 0x08]
 	retl
 	 nop
+ENDPROC(aes_sparc64_cbc_encrypt_128)
 
-1:
-	/* 192-bit key */
-	ldx		[%o1 + 0x00], %g3
+	.align		32
+ENTRY(aes_sparc64_cbc_encrypt_192)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldd		[%o4 + 0x00], %f4
+	ldd		[%o4 + 0x08], %f6
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
@@ -688,24 +1002,26 @@ ENTRY(aes_sparc64_cbc_encrypt)
 	MOVXTOD_G7_F2
 	fxor		%f4, %f0, %f4
 	fxor		%f6, %f2, %f6
-
 	ENCRYPT_192(8, 4, 6, 0, 2)
-
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
+	subcc		%o3, 0x10, %o3
 	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
-	std		%f4, [%o5 + 0x00]
-	std		%f6, [%o5 + 0x08]
-
+	std		%f4, [%o4 + 0x00]
+	std		%f6, [%o4 + 0x08]
 	retl
 	 nop
+ENDPROC(aes_sparc64_cbc_encrypt_192)
 
-2:
-	/* 128-bit key */
-	ldx		[%o1 + 0x00], %g3
+	.align		32
+ENTRY(aes_sparc64_cbc_encrypt_256)
+	/* %o0=key, %o1=input, %o2=output, %o3=len, %o4=IV */
+	ldd		[%o4 + 0x00], %f4
+	ldd		[%o4 + 0x08], %f6
+	ldx		[%o0 + 0x00], %g1
+	ldx		[%o0 + 0x08], %g2
+1:	ldx		[%o1 + 0x00], %g3
 	ldx		[%o1 + 0x08], %g7
 	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
@@ -714,123 +1030,110 @@ ENTRY(aes_sparc64_cbc_encrypt)
 	MOVXTOD_G7_F2
 	fxor		%f4, %f0, %f4
 	fxor		%f6, %f2, %f6
-
-	ENCRYPT_128(8, 4, 6, 0, 2)
-
+	ENCRYPT_256(8, 4, 6, 0, 2)
 	std		%f4, [%o2 + 0x00]
 	std		%f6, [%o2 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 2b
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
 	 add		%o2, 0x10, %o2
-
-	std		%f4, [%o5 + 0x00]
-	std		%f6, [%o5 + 0x08]
-
+	std		%f4, [%o4 + 0x00]
+	std		%f6, [%o4 + 0x08]
 	retl
 	 nop
-ENDPROC(aes_sparc64_cbc_encrypt)
+ENDPROC(aes_sparc64_cbc_encrypt_256)
 
-ENTRY(aes_sparc64_cbc_decrypt)
-	/* %o0=&key[key_len], %o1=key_len, %o2=input, %o3=output, %o4=len, %o5=iv */
+	.align		32
+ENTRY(aes_sparc64_cbc_decrypt_128)
+	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len, %o4=iv */
 	ldx		[%o0 - 0x10], %g1
 	ldx		[%o0 - 0x08], %g2
-	cmp		%o1, 24
-	ldx		[%o5 + 0x00], %o0
-	bl		2f
-	 ldx		[%o5 + 0x08], %o1
-	be		1f
-	 nop
-
-0:
-	/* 256-bit key */
-	ldx		[%o2 + 0x00], %g3
-	ldx		[%o2 + 0x08], %g7
-	add		%o2, 0x10, %o2
+	ldx		[%o4 + 0x00], %o0
+	ldx		[%o4 + 0x08], %o5
+1:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	DECRYPT_256(64, 4, 6, 0, 2)
-
+	DECRYPT_128(8, 4, 6, 0, 2)
 	MOVXTOD_O0_F0
-	MOVXTOD_O1_F2
+	MOVXTOD_O5_F2
 	xor		%g1, %g3, %o0
-	xor		%g2, %g7, %o1
+	xor		%g2, %g7, %o5
 	fxor		%f4, %f0, %f4
 	fxor		%f6, %f2, %f6
-
-	std		%f4, [%o3 + 0x00]
-	std		%f6, [%o3 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 0b
-	 add		%o3, 0x10, %o3
-
-	stx		%o0, [%o5 + 0x00]
-	stx		%o1, [%o5 + 0x08]
-
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+	stx		%o0, [%o4 + 0x00]
+	stx		%o5, [%o4 + 0x08]
 	retl
 	 nop
+ENDPROC(aes_sparc64_cbc_decrypt_128)
 
-1:
-	/* 192-bit key */
-	ldx		[%o2 + 0x00], %g3
-	ldx		[%o2 + 0x08], %g7
-	add		%o2, 0x10, %o2
+	.align		32
+ENTRY(aes_sparc64_cbc_decrypt_192)
+	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len, %o4=iv */
+	ldx		[%o0 - 0x10], %g1
+	ldx		[%o0 - 0x08], %g2
+	ldx		[%o4 + 0x00], %o0
+	ldx		[%o4 + 0x08], %o5
+1:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	DECRYPT_192(56, 4, 6, 0, 2)
-
+	DECRYPT_192(8, 4, 6, 0, 2)
 	MOVXTOD_O0_F0
-	MOVXTOD_O1_F2
+	MOVXTOD_O5_F2
 	xor		%g1, %g3, %o0
-	xor		%g2, %g7, %o1
+	xor		%g2, %g7, %o5
 	fxor		%f4, %f0, %f4
 	fxor		%f6, %f2, %f6
-
-	std		%f4, [%o3 + 0x00]
-	std		%f6, [%o3 + 0x08]
-	subcc		%o4, 0x10, %o4
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o3, 0x10, %o3
 	bne,pt		%xcc, 1b
-	 add		%o3, 0x10, %o3
-
-	stx		%o0, [%o5 + 0x00]
-	stx		%o1, [%o5 + 0x08]
-
+	 add		%o2, 0x10, %o2
+	stx		%o0, [%o4 + 0x00]
+	stx		%o5, [%o4 + 0x08]
 	retl
 	 nop
+ENDPROC(aes_sparc64_cbc_decrypt_192)
 
-2:
-	/* 128-bit key */
-	ldx		[%o2 + 0x00], %g3
-	ldx		[%o2 + 0x08], %g7
-	add		%o2, 0x10, %o2
+	.align		32
+ENTRY(aes_sparc64_cbc_decrypt_256)
+	/* %o0=&key[key_len], %o1=input, %o2=output, %o3=len, %o4=iv */
+	ldx		[%o0 - 0x10], %g1
+	ldx		[%o0 - 0x08], %g2
+	ldx		[%o4 + 0x00], %o0
+	ldx		[%o4 + 0x08], %o5
+1:	ldx		[%o1 + 0x00], %g3
+	ldx		[%o1 + 0x08], %g7
+	add		%o1, 0x10, %o1
 	xor		%g1, %g3, %g3
 	xor		%g2, %g7, %g7
 	MOVXTOD_G3_F4
 	MOVXTOD_G7_F6
-
-	DECRYPT_128(48, 4, 6, 0, 2)
-
+	DECRYPT_256(8, 4, 6, 0, 2)
 	MOVXTOD_O0_F0
-	MOVXTOD_O1_F2
+	MOVXTOD_O5_F2
 	xor		%g1, %g3, %o0
-	xor		%g2, %g7, %o1
+	xor		%g2, %g7, %o5
 	fxor		%f4, %f0, %f4
 	fxor		%f6, %f2, %f6
-
-	std		%f4, [%o3 + 0x00]
-	std		%f6, [%o3 + 0x08]
-	subcc		%o4, 0x10, %o4
-	bne,pt		%xcc, 2b
-	 add		%o3, 0x10, %o3
-
-	stx		%o0, [%o5 + 0x00]
-	stx		%o1, [%o5 + 0x08]
-
+	std		%f4, [%o2 + 0x00]
+	std		%f6, [%o2 + 0x08]
+	subcc		%o3, 0x10, %o3
+	bne,pt		%xcc, 1b
+	 add		%o2, 0x10, %o2
+	stx		%o0, [%o4 + 0x00]
+	stx		%o5, [%o4 + 0x08]
 	retl
 	 nop
-ENDPROC(aes_sparc64_cbc_decrypt)
+ENDPROC(aes_sparc64_cbc_decrypt_256)
diff --git a/arch/sparc/crypto/aes_glue.c b/arch/sparc/crypto/aes_glue.c
index a87c5fa..0b1de0b 100644
--- a/arch/sparc/crypto/aes_glue.c
+++ b/arch/sparc/crypto/aes_glue.c
@@ -26,12 +26,121 @@
 #include <asm/pstate.h>
 #include <asm/elf.h>
 
+struct aes_ops {
+	void (*encrypt)(const u64 *key, const u32 *input, u32 *output);
+	void (*decrypt)(const u64 *key, const u32 *input, u32 *output);
+	void (*load_encrypt_keys)(const u64 *key);
+	void (*load_decrypt_keys)(const u64 *key);
+	void (*ecb_encrypt)(const u64 *key, const u64 *input, u64 *output,
+			    unsigned int len);
+	void (*ecb_decrypt)(const u64 *key, const u64 *input, u64 *output,
+			    unsigned int len);
+	void (*cbc_encrypt)(const u64 *key, const u64 *input, u64 *output,
+			    unsigned int len, u64 *iv);
+	void (*cbc_decrypt)(const u64 *key, const u64 *input, u64 *output,
+			    unsigned int len, u64 *iv);
+};
+
 struct crypto_sparc64_aes_ctx {
+	struct aes_ops *ops;
 	u64 key[AES_MAX_KEYLENGTH / sizeof(u64)];
 	u32 key_length;
 	u32 expanded_key_length;
 };
 
+extern void aes_sparc64_encrypt_128(const u64 *key, const u32 *input,
+				    u32 *output);
+extern void aes_sparc64_encrypt_192(const u64 *key, const u32 *input,
+				    u32 *output);
+extern void aes_sparc64_encrypt_256(const u64 *key, const u32 *input,
+				    u32 *output);
+
+extern void aes_sparc64_decrypt_128(const u64 *key, const u32 *input,
+				    u32 *output);
+extern void aes_sparc64_decrypt_192(const u64 *key, const u32 *input,
+				    u32 *output);
+extern void aes_sparc64_decrypt_256(const u64 *key, const u32 *input,
+				    u32 *output);
+
+extern void aes_sparc64_load_encrypt_keys_128(const u64 *key);
+extern void aes_sparc64_load_encrypt_keys_192(const u64 *key);
+extern void aes_sparc64_load_encrypt_keys_256(const u64 *key);
+
+extern void aes_sparc64_load_decrypt_keys_128(const u64 *key);
+extern void aes_sparc64_load_decrypt_keys_192(const u64 *key);
+extern void aes_sparc64_load_decrypt_keys_256(const u64 *key);
+
+extern void aes_sparc64_ecb_encrypt_128(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len);
+extern void aes_sparc64_ecb_encrypt_192(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len);
+extern void aes_sparc64_ecb_encrypt_256(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len);
+
+extern void aes_sparc64_ecb_decrypt_128(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len);
+extern void aes_sparc64_ecb_decrypt_192(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len);
+extern void aes_sparc64_ecb_decrypt_256(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len);
+
+extern void aes_sparc64_cbc_encrypt_128(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len,
+					u64 *iv);
+
+extern void aes_sparc64_cbc_encrypt_192(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len,
+					u64 *iv);
+
+extern void aes_sparc64_cbc_encrypt_256(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len,
+					u64 *iv);
+
+extern void aes_sparc64_cbc_decrypt_128(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len,
+					u64 *iv);
+
+extern void aes_sparc64_cbc_decrypt_192(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len,
+					u64 *iv);
+
+extern void aes_sparc64_cbc_decrypt_256(const u64 *key, const u64 *input,
+					u64 *output, unsigned int len,
+					u64 *iv);
+
+struct aes_ops aes128_ops = {
+	.encrypt		= aes_sparc64_encrypt_128,
+	.decrypt		= aes_sparc64_decrypt_128,
+	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_128,
+	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_128,
+	.ecb_encrypt		= aes_sparc64_ecb_encrypt_128,
+	.ecb_decrypt		= aes_sparc64_ecb_decrypt_128,
+	.cbc_encrypt		= aes_sparc64_cbc_encrypt_128,
+	.cbc_decrypt		= aes_sparc64_cbc_decrypt_128,
+};
+
+struct aes_ops aes192_ops = {
+	.encrypt		= aes_sparc64_encrypt_192,
+	.decrypt		= aes_sparc64_decrypt_192,
+	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_192,
+	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_192,
+	.ecb_encrypt		= aes_sparc64_ecb_encrypt_192,
+	.ecb_decrypt		= aes_sparc64_ecb_decrypt_192,
+	.cbc_encrypt		= aes_sparc64_cbc_encrypt_192,
+	.cbc_decrypt		= aes_sparc64_cbc_decrypt_192,
+};
+
+struct aes_ops aes256_ops = {
+	.encrypt		= aes_sparc64_encrypt_256,
+	.decrypt		= aes_sparc64_decrypt_256,
+	.load_encrypt_keys	= aes_sparc64_load_encrypt_keys_256,
+	.load_decrypt_keys	= aes_sparc64_load_decrypt_keys_256,
+	.ecb_encrypt		= aes_sparc64_ecb_encrypt_256,
+	.ecb_decrypt		= aes_sparc64_ecb_decrypt_256,
+	.cbc_encrypt		= aes_sparc64_cbc_encrypt_256,
+	.cbc_decrypt		= aes_sparc64_cbc_decrypt_256,
+};
+
 extern void aes_sparc64_key_expand(const u32 *in_key, u64 *output_key,
 				   unsigned int key_len);
 
@@ -44,14 +153,17 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	switch (key_len) {
 	case AES_KEYSIZE_128:
 		ctx->expanded_key_length = 0xb0;
+		ctx->ops = &aes128_ops;
 		break;
 
 	case AES_KEYSIZE_192:
 		ctx->expanded_key_length = 0xd0;
+		ctx->ops = &aes192_ops;
 		break;
 
 	case AES_KEYSIZE_256:
 		ctx->expanded_key_length = 0xf0;
+		ctx->ops = &aes256_ops;
 		break;
 
 	default:
@@ -65,38 +177,22 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	return 0;
 }
 
-extern void aes_sparc64_encrypt(const u64 *key, const u32 *input,
-				u32 *output, unsigned int key_len);
-
 static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	aes_sparc64_encrypt(&ctx->key[0], (const u32 *) src,
-			    (u32 *) dst, ctx->key_length);
+	ctx->ops->encrypt(&ctx->key[0], (const u32 *) src, (u32 *) dst);
 }
 
-extern void aes_sparc64_decrypt(const u64 *key, const u32 *input,
-				u32 *output, unsigned int key_len,
-				unsigned int expanded_key_len);
-
 static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 {
 	struct crypto_sparc64_aes_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	aes_sparc64_decrypt(&ctx->key[0], (const u32 *) src,
-			    (u32 *) dst, ctx->key_length,
-			    ctx->expanded_key_length);
+	ctx->ops->decrypt(&ctx->key[0], (const u32 *) src, (u32 *) dst);
 }
 
-extern void aes_sparc64_load_encrypt_keys(u64 *key);
-extern void aes_sparc64_load_decrypt_keys(u64 *key);
-
 #define AES_BLOCK_MASK	(~(AES_BLOCK_SIZE-1))
 
-extern void aes_sparc64_ecb_encrypt(u64 *key, const u32 *input, u32 *output,
-				    unsigned int key_len, unsigned int len);
-
 static int ecb_encrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -108,15 +204,15 @@ static int ecb_encrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
-	aes_sparc64_load_encrypt_keys(&ctx->key[0]);
+	ctx->ops->load_encrypt_keys(&ctx->key[0]);
 	while ((nbytes = walk.nbytes)) {
 		unsigned int block_len = nbytes & AES_BLOCK_MASK;
 
 		if (likely(block_len)) {
-			aes_sparc64_ecb_encrypt(&ctx->key[0],
-						(const u32 *)walk.src.virt.addr,
-						(u32 *) walk.dst.virt.addr,
-						ctx->key_length, block_len);
+			ctx->ops->ecb_encrypt(&ctx->key[0],
+					      (const u64 *)walk.src.virt.addr,
+					      (u64 *) walk.dst.virt.addr,
+					      block_len);
 		}
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
@@ -125,9 +221,6 @@ static int ecb_encrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-extern void aes_sparc64_ecb_decrypt(u64 *ekey, const u32 *input, u32 *output,
-				    unsigned int key_len, unsigned int len);
-
 static int ecb_decrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -140,14 +233,16 @@ static int ecb_decrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
-	aes_sparc64_load_decrypt_keys(&ctx->key[0]);
+	ctx->ops->load_decrypt_keys(&ctx->key[0]);
 	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
 	while ((nbytes = walk.nbytes)) {
 		unsigned int block_len = nbytes & AES_BLOCK_MASK;
 
-		aes_sparc64_ecb_decrypt(key_end, (const u32 *) walk.src.virt.addr,
-					(u32 *) walk.dst.virt.addr, ctx->key_length,
-					block_len);
+		if (likely(block_len)) {
+			ctx->ops->ecb_decrypt(key_end,
+					      (const u64 *) walk.src.virt.addr,
+					      (u64 *) walk.dst.virt.addr, block_len);
+		}
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
@@ -156,10 +251,6 @@ static int ecb_decrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-extern void aes_sparc64_cbc_encrypt(u64 *key, const u32 *input, u32 *output,
-				    unsigned int key_len, unsigned int len,
-				    u64 *iv);
-
 static int cbc_encrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -171,16 +262,15 @@ static int cbc_encrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
-	aes_sparc64_load_encrypt_keys(&ctx->key[0]);
+	ctx->ops->load_encrypt_keys(&ctx->key[0]);
 	while ((nbytes = walk.nbytes)) {
 		unsigned int block_len = nbytes & AES_BLOCK_MASK;
 
 		if (likely(block_len)) {
-			aes_sparc64_cbc_encrypt(&ctx->key[0],
-						(const u32 *)walk.src.virt.addr,
-						(u32 *) walk.dst.virt.addr,
-						ctx->key_length, block_len,
-						(u64 *) walk.iv);
+			ctx->ops->cbc_encrypt(&ctx->key[0],
+					      (const u64 *)walk.src.virt.addr,
+					      (u64 *) walk.dst.virt.addr,
+					      block_len, (u64 *) walk.iv);
 		}
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
@@ -189,10 +279,6 @@ static int cbc_encrypt(struct blkcipher_desc *desc,
 	return err;
 }
 
-extern void aes_sparc64_cbc_decrypt(u64 *ekey, unsigned int key_len,
-				    const u32 *input, u32 *output,
-				    unsigned int len, u64 *iv);
-
 static int cbc_decrypt(struct blkcipher_desc *desc,
 		       struct scatterlist *dst, struct scatterlist *src,
 		       unsigned int nbytes)
@@ -205,15 +291,17 @@ static int cbc_decrypt(struct blkcipher_desc *desc,
 	blkcipher_walk_init(&walk, dst, src, nbytes);
 	err = blkcipher_walk_virt(desc, &walk);
 
-	aes_sparc64_load_decrypt_keys(&ctx->key[0]);
+	ctx->ops->load_decrypt_keys(&ctx->key[0]);
 	key_end = &ctx->key[ctx->expanded_key_length / sizeof(u64)];
 	while ((nbytes = walk.nbytes)) {
 		unsigned int block_len = nbytes & AES_BLOCK_MASK;
 
-		aes_sparc64_cbc_decrypt(key_end, ctx->key_length,
-					(const u32 *) walk.src.virt.addr,
-					(u32 *) walk.dst.virt.addr,
-					block_len, (u64 *) walk.iv);
+		if (likely(block_len)) {
+			ctx->ops->cbc_decrypt(key_end,
+					      (const u64 *) walk.src.virt.addr,
+					      (u64 *) walk.dst.virt.addr,
+					      block_len, (u64 *) walk.iv);
+		}
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
-- 
1.7.10.4

