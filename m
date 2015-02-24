From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 1/3] SHA1 for PPC/SPE - assembler
Date: Tue, 24 Feb 2015 20:36:40 +0100
Message-ID: <ce3e5ff2-5904-4e1c-bfa9-e37c9682f961@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-0c7862a4-e091-4120-b630-7c9562281c10"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:19758 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752960AbbBXTgm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2015 14:36:42 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-0c7862a4-e091-4120-b630-7c9562281c10
Content-Type: text/plain

[PATCH v1 1/3] SHA1 for PPC/SPE - assembler

This is the assembler code for SHA1 implementation with
the SIMD SPE instruction set. With the enhanced instruction 
set we can operate on 2 32 bit words in parallel. That helps 
reducing the time to calculate W16-W79. For increasing 
performance even more the assembler function can compute 
hashes for more than one 64 byte input block. 

The state of the used SPE registers is preserved via the 
stack so we can run from interrupt context. There might 
be the case that we interrupt ourselves and push sensitive 
data from another context onto our stack. Clear this area
in the stack afterwards to avoid information leakage.

The code is endian independant.

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/sha1-spe-asm.S b/arch/powerpc/sha1-spe-asm.S
new file mode 100644
index 0000000..fcb6cf0
--- /dev/null
+++ b/arch/powerpc/sha1-spe-asm.S
@@ -0,0 +1,299 @@
+/*
+ * Fast SHA-1 implementation for SPE instruction set (PPC)
+ *
+ * This code makes use of the SPE SIMD instruction set as defined in
+ * http://cache.freescale.com/files/32bit/doc/ref_manual/SPEPIM.pdf
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
+#define rHP	r3	/* pointer to hash value			*/
+#define rWP	r4	/* pointer to input				*/
+#define rKP	r5	/* pointer to constants				*/
+
+#define rW0	r14	/* 64 bit round words				*/
+#define rW1	r15
+#define rW2	r16
+#define rW3	r17
+#define rW4	r18
+#define rW5	r19
+#define rW6	r20
+#define rW7	r21
+
+#define rH0	r6	/* 32 bit hash values 				*/
+#define rH1	r7
+#define rH2	r8
+#define rH3	r9
+#define rH4	r10
+
+#define rT0	r22	/* 64 bit temporary				*/
+#define rT1	r0	/* 32 bit temporaries				*/
+#define rT2	r11
+#define rT3	r12
+
+#define rK	r23	/* 64 bit constant in volatile register		*/
+
+#define LOAD_K01
+
+#define LOAD_K11 \
+	evlwwsplat	rK,0(rKP);
+
+#define LOAD_K21 \
+	evlwwsplat	rK,4(rKP);
+
+#define LOAD_K31 \
+	evlwwsplat	rK,8(rKP);
+
+#define LOAD_K41 \
+	evlwwsplat	rK,12(rKP);
+
+#define INITIALIZE \
+	stwu		r1,-128(r1);	/* create stack frame		*/ \
+	evstdw		r14,8(r1);	/* We must save non volatile	*/ \
+	evstdw		r15,16(r1);	/* registers. Take the chance	*/ \
+	evstdw		r16,24(r1);	/* and save the SPE part too	*/ \
+	evstdw		r17,32(r1);					   \
+	evstdw		r18,40(r1);					   \
+	evstdw		r19,48(r1);					   \
+	evstdw		r20,56(r1);					   \
+	evstdw		r21,64(r1);					   \
+	evstdw		r22,72(r1);					   \
+	evstdw		r23,80(r1);
+
+
+#define FINALIZE \
+	evldw		r14,8(r1);	/* restore SPE registers	*/ \
+	evldw		r15,16(r1);					   \
+	evldw		r16,24(r1);					   \
+	evldw		r17,32(r1);					   \
+	evldw		r18,40(r1);					   \
+	evldw		r19,48(r1);					   \
+	evldw		r20,56(r1);					   \
+	evldw		r21,64(r1);					   \
+	evldw		r22,72(r1);					   \
+	evldw		r23,80(r1);					   \
+	xor		r0,r0,r0;					   \
+	stw		r0,8(r1);	/* Delete sensitive data	*/ \
+	stw		r0,16(r1);	/* that we might have pushed	*/ \
+	stw		r0,24(r1);	/* from other context that runs	*/ \
+	stw		r0,32(r1);	/* the same code. Assume that	*/ \
+	stw		r0,40(r1);	/* the lower part of the GPRs	*/ \
+	stw		r0,48(r1);	/* were already overwritten on	*/ \
+	stw		r0,56(r1);	/* the way down to here		*/ \
+	stw		r0,64(r1);					   \
+	stw		r0,72(r1);					   \
+	stw		r0,80(r1);					   \
+	addi		r1,r1,128;	/* cleanup stack frame		*/
+
+#ifdef __BIG_ENDIAN__
+#define LOAD_DATA(reg, off) \
+	lwz		reg,off(rWP);	/* load data			*/
+#define NEXT_BLOCK \
+	addi		rWP,rWP,64;	/* increment per block		*/
+#else
+#define LOAD_DATA(reg, off) \
+	lwbrx		reg,0,rWP;	/* load data			*/ \
+	addi		rWP,rWP,4;	/* increment per word		*/
+#define NEXT_BLOCK			/* nothing to do		*/
+#endif
+
+#define	R_00_15(a, b, c, d, e, w0, w1, k, off) \
+	LOAD_DATA(w0, off)		/* 1: W				*/ \
+	and		rT2,b,c;	/* 1: F' = B and C 		*/ \
+	LOAD_K##k##1							   \
+	andc		rT1,d,b;	/* 1: F" = ~B and D 		*/ \
+	rotrwi		rT0,a,27;	/* 1: A' = A rotl 5		*/ \
+	or		rT2,rT2,rT1;	/* 1: F = F' or F"		*/ \
+	add		e,e,rT0;	/* 1: E = E + A'		*/ \
+	rotrwi		b,b,2;		/* 1: B = B rotl 30		*/ \
+	add		e,e,w0;		/* 1: E = E + W			*/ \
+	LOAD_DATA(w1, off+4)		/* 2: W				*/ \
+	add		e,e,rT2;	/* 1: E = E + F			*/ \
+	and		rT1,a,b;	/* 2: F' = B and C 		*/ \
+	add		e,e,rK;		/* 1: E = E + K			*/ \
+	andc		rT2,c,a;	/* 2: F" = ~B and D 		*/ \
+	add		d,d,rK;		/* 2: E = E + K			*/ \
+	or		rT2,rT2,rT1;	/* 2: F = F' or F"		*/ \
+	rotrwi		rT0,e,27;	/* 2: A' = A rotl 5		*/ \
+	add		d,d,w1;		/* 2: E = E + W			*/ \
+	rotrwi		a,a,2;		/* 2: B = B rotl 30		*/ \
+	add		d,d,rT0;	/* 2: E = E + A'		*/ \
+	evmergelo	w1,w1,w0;	/*    mix W[0]/W[1]		*/ \
+	add		d,d,rT2		/* 2: E = E + F			*/
+
+#define R_16_19(a, b, c, d, e, w0, w1, w4, w6, w7, k) \
+	and		rT2,b,c;	/* 1: F' = B and C 		*/ \
+	evmergelohi	rT0,w7,w6;	/*    W[-3]			*/ \
+	andc		rT1,d,b;	/* 1: F" = ~B and D 		*/ \
+	evxor		w0,w0,rT0;	/*    W = W[-16] xor W[-3]	*/ \
+	or		rT1,rT1,rT2;	/* 1: F = F' or F"		*/ \
+	evxor		w0,w0,w4;	/*    W = W xor W[-8]		*/ \
+	add		e,e,rT1;	/* 1: E = E + F			*/ \
+	evxor		w0,w0,w1;	/*    W = W xor W[-14]		*/ \
+	rotrwi		rT2,a,27;	/* 1: A' = A rotl 5		*/ \
+	evrlwi		w0,w0,1;	/*    W = W rotl 1		*/ \
+	add		e,e,rT2;	/* 1: E = E + A'		*/ \
+	evaddw		rT0,w0,rK;	/*    WK = W + K		*/ \
+	rotrwi		b,b,2;		/* 1: B = B rotl 30		*/ \
+	LOAD_K##k##1							   \
+	evmergehi	rT1,rT1,rT0;	/*    WK1/WK2			*/ \
+	add		e,e,rT0;	/* 1: E = E + WK		*/ \
+	add		d,d,rT1;	/* 2: E = E + WK		*/ \
+	and		rT2,a,b;	/* 2: F' = B and C 		*/ \
+	andc		rT1,c,a;	/* 2: F" = ~B and D 		*/ \
+	rotrwi		rT0,e,27;	/* 2: A' = A rotl 5		*/ \
+	or		rT1,rT1,rT2;	/* 2: F = F' or F"		*/ \
+	add		d,d,rT0;	/* 2: E = E + A'		*/ \
+	rotrwi		a,a,2;		/* 2: B = B rotl 30		*/ \
+	add		d,d,rT1		/* 2: E = E + F			*/
+
+#define R_20_39(a, b, c, d, e, w0, w1, w4, w6, w7, k) \
+	evmergelohi	rT0,w7,w6;	/*    W[-3]			*/ \
+	xor		rT2,b,c;	/* 1: F' = B xor C		*/ \
+	evxor		w0,w0,rT0;	/*    W = W[-16] xor W[-3]	*/ \
+	xor		rT2,rT2,d;	/* 1: F = F' xor D		*/ \
+	evxor		w0,w0,w4;	/*    W = W xor W[-8]		*/ \
+	add		e,e,rT2;	/* 1: E = E + F			*/ \
+	evxor		w0,w0,w1;	/*    W = W xor W[-14]		*/ \
+	rotrwi		rT2,a,27;	/* 1: A' = A rotl 5		*/ \
+	evrlwi		w0,w0,1;	/*    W = W rotl 1		*/ \
+	add		e,e,rT2;	/* 1: E = E + A'		*/ \
+	evaddw		rT0,w0,rK;	/*    WK = W + K		*/ \
+	rotrwi		b,b,2;		/* 1: B = B rotl 30		*/ \
+	LOAD_K##k##1							   \
+	evmergehi	rT1,rT1,rT0;	/*    WK1/WK2			*/ \
+	add		e,e,rT0;	/* 1: E = E + WK		*/ \
+	xor		rT2,a,b;	/* 2: F' = B xor C		*/ \
+	add		d,d,rT1;	/* 2: E = E + WK		*/ \
+	xor		rT2,rT2,c;	/* 2: F = F' xor D		*/ \
+	rotrwi		rT0,e,27;	/* 2: A' = A rotl 5		*/ \
+	add		d,d,rT2;	/* 2: E = E + F			*/ \
+	rotrwi		a,a,2;		/* 2: B = B rotl 30		*/ \
+	add		d,d,rT0		/* 2: E = E + A'		*/
+
+#define R_40_59(a, b, c, d, e, w0, w1, w4, w6, w7, k) \
+	and		rT2,b,c;	/* 1: F' = B and C		*/ \
+	evmergelohi	rT0,w7,w6;	/*    W[-3]			*/ \
+	or		rT1,b,c;	/* 1: F" = B or C		*/ \
+	evxor		w0,w0,rT0;	/*    W = W[-16] xor W[-3]	*/ \
+	and		rT1,d,rT1;	/* 1: F" = F" and D		*/ \
+	evxor		w0,w0,w4;	/*    W = W xor W[-8]		*/ \
+	or		rT2,rT2,rT1;	/* 1: F = F' or F"		*/ \
+	evxor		w0,w0,w1;	/*    W = W xor W[-14]		*/ \
+	add		e,e,rT2;	/* 1: E = E + F			*/ \
+	evrlwi		w0,w0,1;	/*    W = W rotl 1		*/ \
+	rotrwi		rT2,a,27;	/* 1: A' = A rotl 5		*/ \
+	evaddw		rT0,w0,rK;	/*    WK = W + K		*/ \
+	add		e,e,rT2;	/* 1: E = E + A'		*/ \
+	LOAD_K##k##1							   \
+	evmergehi	rT1,rT1,rT0;	/*    WK1/WK2			*/ \
+	rotrwi		b,b,2;		/* 1: B = B rotl 30		*/ \
+	add		e,e,rT0;	/* 1: E = E + WK		*/ \
+	and		rT2,a,b;	/* 2: F' = B and C		*/ \
+	or		rT0,a,b;	/* 2: F" = B or C		*/ \
+	add		d,d,rT1;	/* 2: E = E + WK		*/ \
+	and		rT0,c,rT0;	/* 2: F" = F" and D		*/ \
+	rotrwi		a,a,2;		/* 2: B = B rotl 30		*/ \
+	or		rT2,rT2,rT0;	/* 2: F = F' or F"		*/ \
+	rotrwi		rT0,e,27;	/* 2: A' = A rotl 5		*/ \
+	add		d,d,rT2;	/* 2: E = E + F			*/ \
+	add		d,d,rT0		/* 2: E = E + A'		*/
+
+#define R_60_79(a, b, c, d, e, w0, w1, w4, w6, w7, k) \
+	R_20_39(a, b, c, d, e, w0, w1, w4, w6, w7, k)
+
+_GLOBAL(ppc_spe_sha1_transform)
+	INITIALIZE
+
+	lwz		rH0,0(rHP)
+	lwz		rH1,4(rHP)
+	mtctr		r5
+	lwz		rH2,8(rHP)
+	lis		rKP,PPC_SPE_SHA1_K@h
+	lwz		rH3,12(rHP)
+	ori		rKP,rKP,PPC_SPE_SHA1_K@l
+	lwz		rH4,16(rHP)
+
+ppc_spe_sha1_main:
+	R_00_15(rH0, rH1, rH2, rH3, rH4, rW1, rW0, 1, 0)
+	R_00_15(rH3, rH4, rH0, rH1, rH2, rW2, rW1, 0, 8)
+	R_00_15(rH1, rH2, rH3, rH4, rH0, rW3, rW2, 0, 16)
+	R_00_15(rH4, rH0, rH1, rH2, rH3, rW4, rW3, 0, 24)
+	R_00_15(rH2, rH3, rH4, rH0, rH1, rW5, rW4, 0, 32)
+	R_00_15(rH0, rH1, rH2, rH3, rH4, rW6, rW5, 0, 40)
+	R_00_15(rH3, rH4, rH0, rH1, rH2, rT3, rW6, 0, 48)
+	R_00_15(rH1, rH2, rH3, rH4, rH0, rT3, rW7, 0, 56)
+
+	R_16_19(rH4, rH0, rH1, rH2, rH3, rW0, rW1, rW4, rW6, rW7, 0)
+	R_16_19(rH2, rH3, rH4, rH0, rH1, rW1, rW2, rW5, rW7, rW0, 2)
+
+	R_20_39(rH0, rH1, rH2, rH3, rH4, rW2, rW3, rW6, rW0, rW1, 0)
+	R_20_39(rH3, rH4, rH0, rH1, rH2, rW3, rW4, rW7, rW1, rW2, 0)
+	R_20_39(rH1, rH2, rH3, rH4, rH0, rW4, rW5, rW0, rW2, rW3, 0)
+	R_20_39(rH4, rH0, rH1, rH2, rH3, rW5, rW6, rW1, rW3, rW4, 0)
+	R_20_39(rH2, rH3, rH4, rH0, rH1, rW6, rW7, rW2, rW4, rW5, 0)
+	R_20_39(rH0, rH1, rH2, rH3, rH4, rW7, rW0, rW3, rW5, rW6, 0)
+	R_20_39(rH3, rH4, rH0, rH1, rH2, rW0, rW1, rW4, rW6, rW7, 0)
+	R_20_39(rH1, rH2, rH3, rH4, rH0, rW1, rW2, rW5, rW7, rW0, 0)
+	R_20_39(rH4, rH0, rH1, rH2, rH3, rW2, rW3, rW6, rW0, rW1, 0)
+	R_20_39(rH2, rH3, rH4, rH0, rH1, rW3, rW4, rW7, rW1, rW2, 3)
+
+	R_40_59(rH0, rH1, rH2, rH3, rH4, rW4, rW5, rW0, rW2, rW3, 0)
+	R_40_59(rH3, rH4, rH0, rH1, rH2, rW5, rW6, rW1, rW3, rW4, 0)
+	R_40_59(rH1, rH2, rH3, rH4, rH0, rW6, rW7, rW2, rW4, rW5, 0)
+	R_40_59(rH4, rH0, rH1, rH2, rH3, rW7, rW0, rW3, rW5, rW6, 0)
+	R_40_59(rH2, rH3, rH4, rH0, rH1, rW0, rW1, rW4, rW6, rW7, 0)
+	R_40_59(rH0, rH1, rH2, rH3, rH4, rW1, rW2, rW5, rW7, rW0, 0)
+	R_40_59(rH3, rH4, rH0, rH1, rH2, rW2, rW3, rW6, rW0, rW1, 0)
+	R_40_59(rH1, rH2, rH3, rH4, rH0, rW3, rW4, rW7, rW1, rW2, 0)
+	R_40_59(rH4, rH0, rH1, rH2, rH3, rW4, rW5, rW0, rW2, rW3, 0)
+	R_40_59(rH2, rH3, rH4, rH0, rH1, rW5, rW6, rW1, rW3, rW4, 4)
+
+	R_60_79(rH0, rH1, rH2, rH3, rH4, rW6, rW7, rW2, rW4, rW5, 0)
+	R_60_79(rH3, rH4, rH0, rH1, rH2, rW7, rW0, rW3, rW5, rW6, 0)
+	R_60_79(rH1, rH2, rH3, rH4, rH0, rW0, rW1, rW4, rW6, rW7, 0)
+	R_60_79(rH4, rH0, rH1, rH2, rH3, rW1, rW2, rW5, rW7, rW0, 0)
+	R_60_79(rH2, rH3, rH4, rH0, rH1, rW2, rW3, rW6, rW0, rW1, 0)
+	R_60_79(rH0, rH1, rH2, rH3, rH4, rW3, rW4, rW7, rW1, rW2, 0)
+	R_60_79(rH3, rH4, rH0, rH1, rH2, rW4, rW5, rW0, rW2, rW3, 0)
+	lwz		rT3,0(rHP)
+	R_60_79(rH1, rH2, rH3, rH4, rH0, rW5, rW6, rW1, rW3, rW4, 0)
+	lwz		rW1,4(rHP)
+	R_60_79(rH4, rH0, rH1, rH2, rH3, rW6, rW7, rW2, rW4, rW5, 0)
+	lwz		rW2,8(rHP)
+	R_60_79(rH2, rH3, rH4, rH0, rH1, rW7, rW0, rW3, rW5, rW6, 0)
+	lwz		rW3,12(rHP)
+	NEXT_BLOCK
+	lwz		rW4,16(rHP)
+
+	add		rH0,rH0,rT3
+	stw		rH0,0(rHP)
+	add		rH1,rH1,rW1
+	stw		rH1,4(rHP)
+	add		rH2,rH2,rW2
+	stw		rH2,8(rHP)
+	add		rH3,rH3,rW3
+	stw		rH3,12(rHP)
+	add		rH4,rH4,rW4
+	stw		rH4,16(rHP)
+
+	bdnz		ppc_spe_sha1_main
+
+	FINALIZE
+	blr
+
+.data
+.align 4
+PPC_SPE_SHA1_K:
+	.long 0x5A827999,0x6ED9EBA1,0x8F1BBCDC,0xCA62C1D6

------=_NextPartTM-000-0c7862a4-e091-4120-b630-7c9562281c10
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

------=_NextPartTM-000-0c7862a4-e091-4120-b630-7c9562281c10--
