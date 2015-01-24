From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 1/3] SHA256 for PPC/SPE - assembler
Date: Sat, 24 Jan 2015 22:10:58 +0100
Message-ID: <2a07aea3-d90b-4701-bff6-6f826920b075@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="----=_NextPartTM-000-291a1a04-7703-4b1f-b043-3326c962a20e"
Cc: linuxppc-dev@lists.ozlabs.org
To: <linux-crypto@vger.kernel.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-291a1a04-7703-4b1f-b043-3326c962a20e
Content-Type: text/plain

[PATCH v1 1/3] SHA256 for PPC/SPE - assembler

This is the assembler code for SHA256 implementation with
the SIMD SPE instruction set. Although being only a 32 bit
architecture GPRs are extended to 64 bit presenting two
32 bit values. With the extended instruction set we can
operate on them in parallel. That helps reducing the time
to calculate W16-W64.

For increasing performance even more the assembler function
can compute hashes for more than one 64 byte input block. To 
avoid information leakage it clears the upper 32 bits of 
GPRS after the calculation.

The code is endian independant.

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/sha256-spe-asm.S b/arch/powerpc/crypto/sha256-spe-asm.S
new file mode 100644
index 0000000..fb385e1
--- /dev/null
+++ b/arch/powerpc/crypto/sha256-spe-asm.S
@@ -0,0 +1,312 @@
+/*
+ * Fast SHA-256 implementation for SPE instruction set (PPC)
+ *
+ * This code makes use of the SPE SIMD instruction set as defined in
+ * cache.freescale.com/files/32bit/doc/ref_manual/SPEPIM.pdf
+ * Implementation is based on optimization guide notes from
+ * http://cache.freescale.com/files/32bit/doc/app_note/AN2665.pdf
+ *
+ * Copyright (c) 2015 Markus Stockhausen <stockhausen@collogia.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <asm/ppc_asm.h>
+#include <asm/asm-offsets.h>
+
+#define rHP	r22	/* pointer to hash values in memory		*/
+#define rKP	r23	/* pointer to round constants			*/
+#define rWP	r24	/* pointer to input data			*/
+
+#define rW0	r3	/* 16 words in 8 registers			*/
+#define rW1	r4
+#define rW2	r5
+#define rW3	r6
+#define rW4	r7
+#define rW5	r8
+#define rW6	r9
+#define rW7	r10
+
+#define rH0	r14	/* 8 hash values in 8 registers			*/
+#define rH1	r15
+#define rH2	r16
+#define rH3	r17
+#define rH4	r18
+#define rH5	r19
+#define rH6	r20
+#define	rH7	r21
+
+#define rT0	r0	/* 64 bit temporaries 				*/
+#define rT1	r11
+#define rT2	r12	/* 32 bit temporaries				*/
+#define rT3	r25
+
+#define CMP_KN_LOOP
+#define CMP_KC_LOOP \
+	cmpwi		rT1,0;
+
+#define INITIALIZE \
+	PPC_STLU r1,-INT_FRAME_SIZE(r1); \
+	SAVE_8GPRS(14, r1);		/* push registers onto stack	*/ \
+	SAVE_4GPRS(22, r1)
+
+#define FINALIZE \
+	REST_2GPRS(14, r1);		/* pop registers from stack	*/ \
+	evxor		rT0,rT0,rT0;	/* clear sensitive data		*/ \
+	REST_GPR(16, r1);						   \
+	evxor		rT1,rT1,rT1;					   \
+	REST_GPR(17, r1);						   \
+	evxor		rW0,rW0,rW0;					   \
+	REST_GPR(18, r1);						   \
+	evxor		rW1,rW1,rW1;					   \
+	REST_GPR(19, r1);						   \
+	evxor		rW2,rW2,rW2;					   \
+	REST_GPR(20, r1);						   \
+	evxor		rW3,rW3,rW3;					   \
+	REST_GPR(21, r1);						   \
+	evxor		rW4,rW4,rW4;					   \
+	REST_GPR(22, r1);						   \
+	evxor		rW5,rW5,rW5;					   \
+	REST_GPR(23, r1);						   \
+	evxor		rW6,rW6,rW6;					   \
+	REST_GPR(24, r1);						   \
+	evxor		rW7,rW7,rW7;					   \
+	REST_GPR(25, r1);						   \
+	addi		r1,r1,INT_FRAME_SIZE;
+
+#ifdef __BIG_ENDIAN__
+#define LOAD_DATA(reg, off, ptr) \
+	lwz		reg,off(ptr);	/* load data			*/
+#define NEXT_BLOCK \
+	addi		rWP,rWP,64;	/* increment per block		*/
+#else
+#define LOAD_DATA(reg, off, ptr) \
+	lwbrx		reg,0,ptr; 	/* load data			*/ \
+	addi		ptr,ptr,4;	/* increment per word		*/
+#define NEXT_BLOCK			/* nothing to do		*/
+#endif
+
+#define R_LOAD_W(a, b, c, d, e, f, g, h, w, off) \
+	LOAD_DATA(w,off,rWP)		/* 1: W				*/ \
+	rotrwi		rT0,e,6;	/* 1: S1 = e rotr 6		*/ \
+	rotrwi		rT1,e,11;	/* 1: S1' = e rotr 11		*/ \
+	rotrwi		rT2,e,25;	/* 1: S1" = e rotr 25		*/ \
+	xor		rT0,rT0,rT1;	/* 1: S1 = S1 xor S1'		*/ \
+	and		rT3,e,f;	/* 1: ch = e and f		*/ \
+	xor		rT0,rT0,rT2;	/* 1: S1 = S1 xor S1"		*/ \
+	andc		rT1,g,e;	/* 1: ch' = ~e and g		*/ \
+	lwz		rT2,off(rKP);	/* 1: K				*/ \
+	xor		rT3,rT3,rT1;	/* 1: ch = ch xor ch'		*/ \
+	add		h,h,rT0;	/* 1: temp1 = h + S1		*/ \
+	add		rT3,rT3,w;	/* 1: temp1' = ch + w		*/ \
+	rotrwi		rT0,a,2;	/* 1: S0 = a rotr 2		*/ \
+	add		h,h,rT3;	/* 1: temp1 = temp1 + temp1'	*/ \
+	rotrwi		rT1,a,13;	/* 1: S0' = a rotr 13		*/ \
+	add		h,h,rT2;	/* 1: temp1 = temp1 + K		*/ \
+	rotrwi		rT3,a,22;	/* 1: S0" = a rotr 22		*/ \
+	xor		rT0,rT0,rT1;	/* 1: S0 = S0 xor S0'		*/ \
+	add		d,d,h;		/* 1: d = d + temp1		*/ \
+	xor		rT3,rT0,rT3;	/* 1: S0 = S0 xor S0"		*/ \
+	evmergelo	w,w,w;		/*    shift W			*/ \
+	or		rT2,a,b;	/* 1: maj = a or b		*/ \
+	and		rT1,a,b;	/* 1: maj' = a and b		*/ \
+	and		rT2,rT2,c;	/* 1: maj = maj and c		*/ \
+	LOAD_DATA(w,off+4,rWP)		/* 2: W				*/ \
+	or		rT2,rT1,rT2;	/* 1: maj = maj or maj'		*/ \
+	rotrwi		rT0,d,6;	/* 2: S1 = e rotr 6		*/ \
+	add		rT3,rT3,rT2;	/* 1: temp2 = S0 + maj		*/ \
+	rotrwi		rT1,d,11;	/* 2: S1' = e rotr 11		*/ \
+	add		h,h,rT3;	/* 1: h = temp1 + temp2		*/ \
+	rotrwi		rT2,d,25;	/* 2: S1" = e rotr 25		*/ \
+	xor		rT0,rT0,rT1;	/* 2: S1 = S1 xor S1'		*/ \
+	and		rT3,d,e;	/* 2: ch = e and f		*/ \
+	xor		rT0,rT0,rT2;	/* 2: S1 = S1 xor S1"		*/ \
+	andc		rT1,f,d;	/* 2: ch' = ~e and g		*/ \
+	lwz		rT2,off+4(rKP);	/* 2: K				*/ \
+	xor		rT3,rT3,rT1;	/* 2: ch = ch xor ch'		*/ \
+	add		g,g,rT0;	/* 2: temp1 = h + S1		*/ \
+	add		rT3,rT3,w;	/* 2: temp1' = ch + w		*/ \
+	rotrwi		rT0,h,2;	/* 2: S0 = a rotr 2		*/ \
+	add		g,g,rT3;	/* 2: temp1 = temp1 + temp1'	*/ \
+	rotrwi		rT1,h,13;	/* 2: S0' = a rotr 13		*/ \
+	add		g,g,rT2;	/* 2: temp1 = temp1 + K		*/ \
+	rotrwi		rT3,h,22;	/* 2: S0" = a rotr 22		*/ \
+	xor		rT0,rT0,rT1;	/* 2: S0 = S0 xor S0'		*/ \
+	or		rT2,h,a;	/* 2: maj = a or b		*/ \
+	xor		rT3,rT0,rT3;	/* 2: S0 = S0 xor S0"		*/ \
+	and		rT1,h,a;	/* 2: maj' = a and b		*/ \
+	and		rT2,rT2,b;	/* 2: maj = maj and c		*/ \
+	add		c,c,g;		/* 2: d = d + temp1		*/ \
+	or		rT2,rT1,rT2;	/* 2: maj = maj or maj'		*/ \
+	add		rT3,rT3,rT2;	/* 2: temp2 = S0 + maj		*/ \
+	add		g,g,rT3		/* 2: h = temp1 + temp2		*/
+
+#define R_CALC_W(a, b, c, d, e, f, g, h, w0, w1, w4, w5, w7, k, off) \
+	rotrwi		rT2,e,6;	/* 1: S1 = e rotr 6		*/ \
+	evmergelohi	rT0,w0,w1;	/*    w[-15]			*/ \
+	rotrwi		rT3,e,11;	/* 1: S1' = e rotr 11		*/ \
+	evsrwiu		rT1,rT0,3;	/*    s0 = w[-15] >> 3		*/ \
+	xor		rT2,rT2,rT3;	/* 1: S1 = S1 xor S1'		*/ \
+	evrlwi		rT0,rT0,25;	/*    s0' = w[-15] rotr	7	*/ \
+	rotrwi		rT3,e,25;	/* 1: S1' = e rotr 25		*/ \
+	evxor		rT1,rT1,rT0;	/*    s0 = s0 xor s0'		*/ \
+	xor		rT2,rT2,rT3;	/* 1: S1 = S1 xor S1'		*/ \
+	evrlwi		rT0,rT0,21;	/*    s0' = w[-15] rotr 18	*/ \
+	add		h,h,rT2;	/* 1: temp1 = h + S1		*/ \
+	evxor		rT0,rT0,rT1;	/*    s0 = s0 xor s0'		*/ \
+	and		rT2,e,f;	/* 1: ch = e and f		*/ \
+	evaddw		w0,w0,rT0;	/*    w = w[-16] + s0		*/ \
+	andc		rT3,g,e;	/* 1: ch' = ~e and g		*/ \
+	evsrwiu		rT0,w7,10;	/*    s1 = w[-2] >> 10		*/ \
+	xor		rT2,rT2,rT3;	/* 1: ch = ch xor ch'		*/ \
+	evrlwi		rT1,w7,15;	/*    s1' = w[-2] rotr 17	*/ \
+	add		h,h,rT2;	/* 1: temp1 = temp1 + ch	*/ \
+	evxor		rT0,rT0,rT1;	/*    s1 = s1 xor s1'		*/ \
+	rotrwi		rT2,a,2;	/* 1: S0 = a rotr 2		*/ \
+	evrlwi		rT1,w7,13;	/*    s1' = w[-2] rotr 19	*/ \
+	rotrwi		rT3,a,13;	/* 1: S0' = a rotr 13		*/ \
+	evxor		rT0,rT0,rT1;	/*    s1 = s1 xor s1'		*/ \
+	xor		rT2,rT2,rT3;	/* 1: S0 = S0 xor S0'		*/ \
+	evldw		rT1,off(rKP);	/*    k				*/ \
+	rotrwi		rT3,a,22;	/* 1: S0' = a rotr 22		*/ \
+	evaddw		w0,w0,rT0;	/*    w = w + s1		*/ \
+	xor		rT2,rT2,rT3;	/* 1: S0 = S0 xor S0'		*/ \
+	evmergelohi	rT0,w4,w5;	/*    w[-7]			*/ \
+	and		rT3,a,b;	/* 1: maj = a and b		*/ \
+	evaddw		w0,w0,rT0;	/*    w = w + w[-7]		*/ \
+	CMP_K##k##_LOOP							   \
+	add		rT2,rT2,rT3;	/* 1: temp2 = S0 + maj		*/ \
+	evaddw		rT1,rT1,w0;	/*    wk = w + k		*/ \
+	xor		rT3,a,b;	/* 1: maj = a xor b		*/ \
+	evmergehi	rT0,rT1,rT1;	/*    wk1/wk2			*/ \
+	and		rT3,rT3,c;	/* 1: maj = maj and c		*/ \
+	add		h,h,rT0;	/* 1: temp1 = temp1 + wk	*/ \
+	add		rT2,rT2,rT3;	/* 1: temp2 = temp2 + maj	*/ \
+	add		g,g,rT1;	/* 2: temp1 = temp1 + wk	*/ \
+	add		d,d,h;		/* 1: d = d + temp1		*/ \
+	rotrwi		rT0,d,6;	/* 2: S1 = e rotr 6		*/ \
+	add		h,h,rT2;	/* 1: h = temp1 + temp2		*/ \
+	rotrwi		rT1,d,11;	/* 2: S1' = e rotr 11		*/ \
+	rotrwi		rT2,d,25;	/* 2: S" = e rotr 25		*/ \
+	xor		rT0,rT0,rT1;	/* 2: S1 = S1 xor S1'		*/ \
+	and		rT3,d,e;	/* 2: ch = e and f		*/ \
+	xor		rT0,rT0,rT2;	/* 2: S1 = S1 xor S1"		*/ \
+	andc		rT1,f,d;	/* 2: ch' = ~e and g		*/ \
+	add		g,g,rT0;	/* 2: temp1 = h + S1		*/ \
+	xor		rT3,rT3,rT1;	/* 2: ch = ch xor ch'		*/ \
+	rotrwi		rT0,h,2;	/* 2: S0 = a rotr 2		*/ \
+	add		g,g,rT3;	/* 2: temp1 = temp1 + ch	*/ \
+	rotrwi		rT1,h,13;	/* 2: S0' = a rotr 13		*/ \
+	rotrwi		rT3,h,22;	/* 2: S0" = a rotr 22		*/ \
+	xor		rT0,rT0,rT1;	/* 2: S0 = S0 xor S0'		*/ \
+	or		rT2,h,a;	/* 2: maj = a or b		*/ \
+	and		rT1,h,a;	/* 2: maj' = a and b		*/ \
+	and		rT2,rT2,b;	/* 2: maj = maj and c		*/ \
+	xor		rT3,rT0,rT3;	/* 2: S0 = S0 xor S0"		*/ \
+	or		rT2,rT1,rT2;	/* 2: maj = maj or maj'		*/ \
+	add		c,c,g;		/* 2: d = d + temp1		*/ \
+	add		rT3,rT3,rT2;	/* 2: temp2 = S0 + maj		*/ \
+	add		g,g,rT3		/* 2: h = temp1 + temp2		*/
+
+_GLOBAL(ppc_spe_sha256_transform)
+	INITIALIZE
+
+	mr		rHP,r3
+	lwz		rH0,0(rHP)
+	mr		rWP,r4
+	lwz		rH1,4(rHP)
+	mtctr		r5
+	lwz		rH2,8(rHP)
+	lwz		rH3,12(rHP)
+	lwz		rH4,16(rHP)
+	lwz		rH5,20(rHP)
+	lwz		rH6,24(rHP)
+	lwz		rH7,28(rHP)
+
+ppc_spe_sha256_main:
+	lis		rKP,PPC_SPE_SHA256_K@ha
+	addi		rKP,rKP,PPC_SPE_SHA256_K@l
+
+	R_LOAD_W(rH0, rH1, rH2, rH3, rH4, rH5, rH6, rH7, rW0, 0)
+	R_LOAD_W(rH6, rH7, rH0, rH1, rH2, rH3, rH4, rH5, rW1, 8)
+	R_LOAD_W(rH4, rH5, rH6, rH7, rH0, rH1, rH2, rH3, rW2, 16)
+	R_LOAD_W(rH2, rH3, rH4, rH5, rH6, rH7, rH0, rH1, rW3, 24)
+	R_LOAD_W(rH0, rH1, rH2, rH3, rH4, rH5, rH6, rH7, rW4, 32)
+	R_LOAD_W(rH6, rH7, rH0, rH1, rH2, rH3, rH4, rH5, rW5, 40)
+	R_LOAD_W(rH4, rH5, rH6, rH7, rH0, rH1, rH2, rH3, rW6, 48)
+	R_LOAD_W(rH2, rH3, rH4, rH5, rH6, rH7, rH0, rH1, rW7, 56)
+ppc_spe_sha256_16_rounds:
+	addi		rKP,rKP,64
+	R_CALC_W(rH0, rH1, rH2, rH3, rH4, rH5, rH6, rH7,
+		 rW0, rW1, rW4, rW5, rW7, N, 0)
+	R_CALC_W(rH6, rH7, rH0, rH1, rH2, rH3, rH4, rH5,
+		 rW1, rW2, rW5, rW6, rW0, N, 8)
+	R_CALC_W(rH4, rH5, rH6, rH7, rH0, rH1, rH2, rH3,
+		 rW2, rW3, rW6, rW7, rW1, N, 16)
+	R_CALC_W(rH2, rH3, rH4, rH5, rH6, rH7, rH0, rH1,
+		 rW3, rW4, rW7, rW0, rW2, N, 24)
+	R_CALC_W(rH0, rH1, rH2, rH3, rH4, rH5, rH6, rH7,
+		 rW4, rW5, rW0, rW1, rW3, N, 32)
+	R_CALC_W(rH6, rH7, rH0, rH1, rH2, rH3, rH4, rH5,
+		 rW5, rW6, rW1, rW2, rW4, N, 40)
+	R_CALC_W(rH4, rH5, rH6, rH7, rH0, rH1, rH2, rH3,
+		 rW6, rW7, rW2, rW3, rW5, N, 48)
+	R_CALC_W(rH2, rH3, rH4, rH5, rH6, rH7, rH0, rH1,
+		 rW7, rW0, rW3, rW4, rW6, C, 56)
+	bt		gt,ppc_spe_sha256_16_rounds
+
+	lwz		rW0,0(rHP)
+	NEXT_BLOCK
+	lwz		rW1,4(rHP)
+	lwz		rW2,8(rHP)
+	lwz		rW3,12(rHP)
+	lwz		rW4,16(rHP)
+	lwz		rW5,20(rHP)
+	lwz		rW6,24(rHP)
+	lwz		rW7,28(rHP)
+
+	add		rH0,rH0,rW0
+	stw		rH0,0(rHP)
+	add		rH1,rH1,rW1
+	stw		rH1,4(rHP)
+	add		rH2,rH2,rW2
+	stw		rH2,8(rHP)
+	add		rH3,rH3,rW3
+	stw		rH3,12(rHP)
+	add		rH4,rH4,rW4
+	stw		rH4,16(rHP)
+	add		rH5,rH5,rW5
+	stw		rH5,20(rHP)
+	add		rH6,rH6,rW6
+	stw		rH6,24(rHP)
+	add		rH7,rH7,rW7
+	stw		rH7,28(rHP)
+
+	bdnz		ppc_spe_sha256_main
+
+	FINALIZE
+	blr
+
+.data
+.align 5
+PPC_SPE_SHA256_K:
+	.long 0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
+	.long 0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
+	.long 0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
+	.long 0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
+	.long 0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
+	.long 0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
+	.long 0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
+	.long 0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
+	.long 0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
+	.long 0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
+	.long 0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
+	.long 0xd192e819,0xd6990624,0xf40e3585,0x106aa070
+	.long 0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
+	.long 0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
+	.long 0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
+	.long 0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2

------=_NextPartTM-000-291a1a04-7703-4b1f-b043-3326c962a20e
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-291a1a04-7703-4b1f-b043-3326c962a20e
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXhwcGMt
ZGV2IG1haWxpbmcgbGlzdApMaW51eHBwYy1kZXZAbGlzdHMub3psYWJzLm9yZwpodHRwczovL2xp
c3RzLm96bGFicy5vcmcvbGlzdGluZm8vbGludXhwcGMtZGV2

------=_NextPartTM-000-291a1a04-7703-4b1f-b043-3326c962a20e--
