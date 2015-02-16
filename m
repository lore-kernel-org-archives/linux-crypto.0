From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v1 4/7] AES for PPC/SPE - key handling
Date: Mon, 16 Feb 2015 13:45:51 +0100
Message-ID: <0a2b6c85-837e-4f9c-aba9-4e68282b666f@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-7962aef7-61e8-4fc0-9e09-41d762298bf6"
Cc: <linuxppc-dev@lists.ozlabs.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:7420 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755274AbbBPMpy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Feb 2015 07:45:54 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a multi-part message in MIME format.

------=_NextPartTM-000-7962aef7-61e8-4fc0-9e09-41d762298bf6
Content-Type: text/plain

[PATCH v1 4/7] AES for PPC/SPE - key handling

Key generation for big endian core routines.

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>

diff --git a/arch/powerpc/crypto/aes-spe-keys.S b/arch/powerpc/crypto/aes-spe-keys.S
new file mode 100644
index 0000000..55b258c
--- /dev/null
+++ b/arch/powerpc/crypto/aes-spe-keys.S
@@ -0,0 +1,283 @@
+/*
+ * Key handling functions for PPC AES implementation
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
+
+#ifdef __BIG_ENDIAN__
+#define LOAD_KEY(d, s, off) \
+	lwz		d,off(s);
+#else
+#define LOAD_KEY(d, s, off) \
+	li		r0,off; \
+	lwbrx		d,s,r0;
+#endif
+
+#define INITIALIZE_KEY \
+	stwu		r1,-32(r1);	/* create stack frame		*/ \
+	stw		r14,8(r1);	/* save registers		*/ \
+	stw		r15,12(r1);					   \
+	stw		r16,16(r1);
+
+#define FINALIZE_KEY \
+	lwz		r14,8(r1);	/* restore registers		*/ \
+	lwz		r15,12(r1);					   \
+	lwz		r16,16(r1);					   \
+	xor		r5,r5,r5;	/* clear sensitive data		*/ \
+	xor		r6,r6,r6;					   \
+	xor		r7,r7,r7;					   \
+	xor		r8,r8,r8;					   \
+	xor		r9,r9,r9;					   \
+	xor		r10,r10,r10;					   \
+	xor		r11,r11,r11;					   \
+	xor		r12,r12,r12;					   \
+	addi		r1,r1,32;	/* cleanup stack		*/
+
+#define LS_BOX(r, t1, t2) \
+	lis		t2,PPC_AES_4K_ENCTAB@h;				   \
+	ori		t2,t2,PPC_AES_4K_ENCTAB@l;			   \
+	rlwimi		t2,r,4,20,27;					   \
+	lbz		t1,8(t2);					   \
+	rlwimi		r,t1,0,24,31;					   \
+	rlwimi		t2,r,28,20,27;					   \
+	lbz		t1,8(t2);					   \
+	rlwimi		r,t1,8,16,23;					   \
+	rlwimi		t2,r,20,20,27;					   \
+	lbz		t1,8(t2);					   \
+	rlwimi		r,t1,16,8,15;					   \
+	rlwimi		t2,r,12,20,27;					   \
+	lbz		t1,8(t2);					   \
+	rlwimi		r,t1,24,0,7;
+
+#define GF8_MUL(out, in, t1, t2) \
+	lis t1,0x8080;			/* multiplication in GF8	*/ \
+	ori t1,t1,0x8080; 						   \
+	and t1,t1,in; 							   \
+	srwi t1,t1,7; 							   \
+	mulli t1,t1,0x1b; 						   \
+	lis t2,0x7f7f; 							   \
+	ori t2,t2,0x7f7f; 						   \
+	and t2,t2,in; 							   \
+	slwi t2,t2,1; 							   \
+	xor out,t1,t2;
+
+/*
+ * ppc_expand_key_128(u32 *key_enc, const u8 *key)
+ *
+ * Expand 128 bit key into 176 bytes encryption key. It consists of
+ * key itself plus 10 rounds with 16 bytes each
+ *
+ */
+_GLOBAL(ppc_expand_key_128)
+	INITIALIZE_KEY
+	LOAD_KEY(r5,r4,0)
+	LOAD_KEY(r6,r4,4)
+	LOAD_KEY(r7,r4,8)
+	LOAD_KEY(r8,r4,12)
+	stw		r5,0(r3)	/* key[0..3] = input data       */
+	stw		r6,4(r3)
+	stw		r7,8(r3)
+	stw		r8,12(r3)
+	li		r16,10		/* 10 expansion rounds		*/
+	lis		r0,0x0100	/* RCO(1)			*/
+ppc_expand_128_loop:
+	addi		r3,r3,16
+	mr		r14,r8		/* apply LS_BOX to 4th temp	*/
+	rotlwi		r14,r14,8
+	LS_BOX(r14, r15, r4)
+	xor		r14,r14,r0
+	xor		r5,r5,r14	/* xor next 4 keys		*/
+	xor		r6,r6,r5
+	xor		r7,r7,r6
+	xor		r8,r8,r7
+	stw		r5,0(r3)	/* store next 4 keys		*/
+	stw		r6,4(r3)
+	stw		r7,8(r3)
+	stw		r8,12(r3)
+	GF8_MUL(r0, r0, r4, r14)	/* multiply RCO by 2 in GF	*/
+	subi		r16,r16,1
+	cmpwi		r16,0
+	bt		eq,ppc_expand_128_end
+	b		ppc_expand_128_loop
+ppc_expand_128_end:
+	FINALIZE_KEY
+	blr
+
+/*
+ * ppc_expand_key_192(u32 *key_enc, const u8 *key)
+ *
+ * Expand 192 bit key into 208 bytes encryption key. It consists of key
+ * itself plus 12 rounds with 16 bytes each
+ *
+ */
+_GLOBAL(ppc_expand_key_192)
+	INITIALIZE_KEY
+	LOAD_KEY(r5,r4,0)
+	LOAD_KEY(r6,r4,4)
+	LOAD_KEY(r7,r4,8)
+	LOAD_KEY(r8,r4,12)
+	LOAD_KEY(r9,r4,16)
+	LOAD_KEY(r10,r4,20)
+	stw		r5,0(r3)
+	stw		r6,4(r3)
+	stw		r7,8(r3)
+	stw		r8,12(r3)
+	stw		r9,16(r3)
+	stw		r10,20(r3)
+	li		r16,8		/* 8 expansion rounds		*/
+	lis		r0,0x0100	/* RCO(1)			*/
+ppc_expand_192_loop:
+	addi		r3,r3,24
+	mr		r14,r10		/* apply LS_BOX to 6th temp	*/
+	rotlwi		r14,r14,8
+	LS_BOX(r14, r15, r4)
+	xor		r14,r14,r0
+	xor		r5,r5,r14	/* xor next 6 keys		*/
+	xor		r6,r6,r5
+	xor		r7,r7,r6
+	xor		r8,r8,r7
+	xor		r9,r9,r8
+	xor		r10,r10,r9
+	stw		r5,0(r3)
+	stw		r6,4(r3)
+	stw		r7,8(r3)
+	stw		r8,12(r3)
+	subi		r16,r16,1
+	cmpwi		r16,0		/* last round early kick out	*/
+	bt		eq,ppc_expand_192_end
+	stw		r9,16(r3)
+	stw		r10,20(r3)
+	GF8_MUL(r0, r0, r4, r14)	/* multiply RCO GF8		*/
+	b		ppc_expand_192_loop
+ppc_expand_192_end:
+	FINALIZE_KEY
+	blr
+
+/*
+ * ppc_expand_key_256(u32 *key_enc, const u8 *key)
+ *
+ * Expand 256 bit key into 240 bytes encryption key. It consists of key
+ * itself plus 14 rounds with 16 bytes each
+ *
+ */
+_GLOBAL(ppc_expand_key_256)
+	INITIALIZE_KEY
+	LOAD_KEY(r5,r4,0)
+	LOAD_KEY(r6,r4,4)
+	LOAD_KEY(r7,r4,8)
+	LOAD_KEY(r8,r4,12)
+	LOAD_KEY(r9,r4,16)
+	LOAD_KEY(r10,r4,20)
+	LOAD_KEY(r11,r4,24)
+	LOAD_KEY(r12,r4,28)
+	stw		r5,0(r3)
+	stw		r6,4(r3)
+	stw		r7,8(r3)
+	stw		r8,12(r3)
+	stw		r9,16(r3)
+	stw		r10,20(r3)
+	stw		r11,24(r3)
+	stw		r12,28(r3)
+	li		r16,7		/* 7 expansion rounds		*/
+	lis		r0,0x0100	/* RCO(1)			*/
+ppc_expand_256_loop:
+	addi		r3,r3,32
+	mr		r14,r12		/* apply LS_BOX to 8th temp	*/
+	rotlwi		r14,r14,8
+	LS_BOX(r14, r15, r4)
+	xor		r14,r14,r0
+	xor		r5,r5,r14	/* xor 4 keys			*/
+	xor		r6,r6,r5
+	xor		r7,r7,r6
+	xor		r8,r8,r7
+	mr		r14,r8
+	LS_BOX(r14, r15, r4)		/* apply LS_BOX to 4th temp	*/
+	xor		r9,r9,r14	/* xor 4 keys			*/
+	xor		r10,r10,r9
+	xor		r11,r11,r10
+	xor		r12,r12,r11
+	stw		r5,0(r3)
+	stw		r6,4(r3)
+	stw		r7,8(r3)
+	stw		r8,12(r3)
+	subi		r16,r16,1
+	cmpwi		r16,0		/* last round early kick out	*/
+	bt		eq,ppc_expand_256_end
+	stw		r9,16(r3)
+	stw		r10,20(r3)
+	stw		r11,24(r3)
+	stw		r12,28(r3)
+	GF8_MUL(r0, r0, r4, r14)
+	b		ppc_expand_256_loop
+ppc_expand_256_end:
+	FINALIZE_KEY
+	blr
+
+/*
+ * ppc_generate_decrypt_key: derive decryption key from encryption key
+ * number of bytes to handle are calculated from length of key (16/24/32)
+ *
+ */
+_GLOBAL(ppc_generate_decrypt_key)
+	addi		r6,r5,24
+	slwi		r6,r6,2
+	lwzx		r7,r4,r6	/* first/last 4 words are same	*/
+	stw		r7,0(r3)
+	lwz		r7,0(r4)
+	stwx		r7,r3,r6
+	addi		r6,r6,4
+	lwzx		r7,r4,r6
+	stw		r7,4(r3)
+	lwz		r7,4(r4)
+	stwx		r7,r3,r6
+	addi		r6,r6,4
+	lwzx		r7,r4,r6
+	stw		r7,8(r3)
+	lwz		r7,8(r4)
+	stwx		r7,r3,r6
+	addi		r6,r6,4
+	lwzx		r7,r4,r6
+	stw		r7,12(r3)
+	lwz		r7,12(r4)
+	stwx		r7,r3,r6
+	addi		r3,r3,16
+	add		r4,r4,r6
+	subi		r4,r4,28
+	addi		r5,r5,20
+	srwi		r5,r5,2
+ppc_generate_decrypt_block:
+	li	r6,4
+	mtctr	r6
+ppc_generate_decrypt_word:
+	lwz		r6,0(r4)
+	GF8_MUL(r7, r6, r0, r7)
+	GF8_MUL(r8, r7, r0, r8)
+	GF8_MUL(r9, r8, r0, r9)
+	xor		r10,r9,r6
+	xor		r11,r7,r8
+	xor		r11,r11,r9
+	xor		r12,r7,r10
+	rotrwi		r12,r12,24
+	xor		r11,r11,r12
+	xor		r12,r8,r10
+	rotrwi		r12,r12,16
+	xor		r11,r11,r12
+	rotrwi		r12,r10,8
+	xor		r11,r11,r12
+	stw		r11,0(r3)
+	addi		r3,r3,4
+	addi		r4,r4,4
+	bdnz		ppc_generate_decrypt_word
+	subi		r4,r4,32
+	subi		r5,r5,1
+	cmpwi		r5,0
+	bt		gt,ppc_generate_decrypt_block
+	blr

------=_NextPartTM-000-7962aef7-61e8-4fc0-9e09-41d762298bf6
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

------=_NextPartTM-000-7962aef7-61e8-4fc0-9e09-41d762298bf6--
