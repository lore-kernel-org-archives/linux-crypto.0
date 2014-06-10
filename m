From: chandramouli narayanan <mouli@linux.intel.com>
Subject: [PATCH v5 1/1] crypto: AES CTR x86_64 "by8" AVX optimization
Date: Tue, 10 Jun 2014 09:22:47 -0700
Message-ID: <1402417367.2363.10.camel@pegasus.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Adrian Hoban <adrian.hoban@intel.com>,
	James Guilford <james.guilford@intel.com>,
	"Tadeusz Struk,Huang Ying" <ying.huang@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	Mathias Krause <minipli@googlemail.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20206 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaFJQWT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jun 2014 12:22:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch introduces "by8" AES CTR mode AVX optimization inspired by
Intel Optimized IPSEC Cryptograhpic library. For additional information,
please see:
http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=22972

The functions aes_ctr_enc_128_avx_by8(), aes_ctr_enc_192_avx_by8() and
aes_ctr_enc_256_avx_by8() are adapted from
Intel Optimized IPSEC Cryptographic library. When both AES and AVX features
are enabled in a platform, the glue code in AESNI module overrieds the
existing "by4" CTR mode en/decryption with the "by8"
AES CTR mode en/decryption.

On a Haswell desktop, with turbo disabled and all cpus running
at maximum frequency, the "by8" CTR mode optimization
shows better performance results across data & key sizes
as measured by tcrypt.

The average performance improvement of the "by8" version over the "by4"
version is as follows:

For 128 bit key and data sizes >= 256 bytes, there is a 10-16% improvement.
For 192 bit key and data sizes >= 256 bytes, there is a 20-22% improvement.
For 256 bit key and data sizes >= 256 bytes, there is a 20-25% improvement.

A typical run of tcrypt with AES CTR mode encryption of the "by4" and "by8"
optimization shows the following results:

tcrypt with "by4" AES CTR mode encryption optimization on a Haswell Desktop:
---------------------------------------------------------------------------

testing speed of __ctr-aes-aesni encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 343 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 336 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 491 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1130 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 7309 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 346 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 361 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 543 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 1321 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 9649 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 369 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 366 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 595 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1531 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 10522 cycles (8192 bytes)

testing speed of __ctr-aes-aesni decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 336 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 350 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 487 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1129 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 7287 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 350 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 359 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 635 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 1324 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 9595 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 364 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 377 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 604 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1527 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 10549 cycles (8192 bytes)

tcrypt with "by8" AES CTR mode encryption optimization on a Haswell Desktop:
---------------------------------------------------------------------------

testing speed of __ctr-aes-aesni encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 340 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 330 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 450 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1043 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 6597 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 339 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 352 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 539 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 1153 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 8458 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 353 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 360 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 512 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1277 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 8745 cycles (8192 bytes)

testing speed of __ctr-aes-aesni decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 348 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 335 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 451 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1030 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 6611 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 354 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 346 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 488 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 1154 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 8390 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 357 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 362 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 515 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1284 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 8681 cycles (8192 bytes)

crypto: Incorporate feed back to AES CTR mode optimization patch

Specifically, the following:
a) alignment around main loop in aes_ctrby8_avx_x86_64.S
b) .rodata around data constants used in the assembely code.
c) the use of CONFIG_AVX in the glue code.
d) fix up white space.
e) informational message for "by8" AES CTR mode optimization
f) "by8" AES CTR mode optimization can be simply enabled
if the platform supports both AES and AVX features. The
optimization works superbly on Sandybridge as well.

Testing on Haswell shows no performance change since the last.

Testing on Sandybridge shows that the "by8" AES CTR mode optimization
greatly improves performance.

tcrypt log with "by4" AES CTR mode optimization on Sandybridge
--------------------------------------------------------------

testing speed of __ctr-aes-aesni encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 383 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 408 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 707 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1864 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 12813 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 395 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 432 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 780 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 2132 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 15765 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 416 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 438 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 842 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 2383 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 16945 cycles (8192 bytes)

testing speed of __ctr-aes-aesni decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 389 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 409 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 704 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1865 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 12783 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 409 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 434 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 792 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 2151 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 15804 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 421 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 444 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 840 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 2394 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 16928 cycles (8192 bytes)

tcrypt log with "by8" AES CTR mode optimization on Sandybridge
--------------------------------------------------------------

testing speed of __ctr-aes-aesni encryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 383 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 401 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 522 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1136 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 7046 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 394 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 418 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 559 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 1263 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 9072 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 408 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 428 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 595 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1385 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 9224 cycles (8192 bytes)

testing speed of __ctr-aes-aesni decryption
test 0 (128 bit key, 16 byte blocks): 1 operation in 390 cycles (16 bytes)
test 1 (128 bit key, 64 byte blocks): 1 operation in 402 cycles (64 bytes)
test 2 (128 bit key, 256 byte blocks): 1 operation in 530 cycles (256 bytes)
test 3 (128 bit key, 1024 byte blocks): 1 operation in 1135 cycles (1024 bytes)
test 4 (128 bit key, 8192 byte blocks): 1 operation in 7079 cycles (8192 bytes)
test 5 (192 bit key, 16 byte blocks): 1 operation in 414 cycles (16 bytes)
test 6 (192 bit key, 64 byte blocks): 1 operation in 417 cycles (64 bytes)
test 7 (192 bit key, 256 byte blocks): 1 operation in 572 cycles (256 bytes)
test 8 (192 bit key, 1024 byte blocks): 1 operation in 1312 cycles (1024 bytes)
test 9 (192 bit key, 8192 byte blocks): 1 operation in 9073 cycles (8192 bytes)
test 10 (256 bit key, 16 byte blocks): 1 operation in 415 cycles (16 bytes)
test 11 (256 bit key, 64 byte blocks): 1 operation in 454 cycles (64 bytes)
test 12 (256 bit key, 256 byte blocks): 1 operation in 598 cycles (256 bytes)
test 13 (256 bit key, 1024 byte blocks): 1 operation in 1407 cycles (1024 bytes)
test 14 (256 bit key, 8192 byte blocks): 1 operation in 9288 cycles (8192 bytes)

crypto: Fix redundant checks

a) Fix the redundant check for cpu_has_aes
b) Fix the key length check when invoking the CTR mode "by8"
encryptor/decryptor.

crypto: fix typo in AES ctr mode transform

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
---
 arch/x86/crypto/Makefile                |   2 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 546 ++++++++++++++++++++++++++++++++
 arch/x86/crypto/aesni-intel_glue.c      |  40 ++-
 3 files changed, 585 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/crypto/aes_ctrby8_avx-x86_64.S

diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 61d6e28..f6fe1e2 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -76,7 +76,7 @@ ifeq ($(avx2_supported),yes)
 endif
 
 aesni-intel-y := aesni-intel_asm.o aesni-intel_glue.o fpu.o
-aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o
+aesni-intel-$(CONFIG_64BIT) += aesni-intel_avx-x86_64.o aes_ctrby8_avx-x86_64.o
 ghash-clmulni-intel-y := ghash-clmulni-intel_asm.o ghash-clmulni-intel_glue.o
 sha1-ssse3-y := sha1_ssse3_asm.o sha1_ssse3_glue.o
 ifeq ($(avx2_supported),yes)
diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
new file mode 100644
index 0000000..f091f12
--- /dev/null
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -0,0 +1,546 @@
+/*
+ *	Implement AES CTR mode by8 optimization with AVX instructions. (x86_64)
+ *
+ * This is AES128/192/256 CTR mode optimization implementation. It requires
+ * the support of Intel(R) AESNI and AVX instructions.
+ *
+ * This work was inspired by the AES CTR mode optimization published
+ * in Intel Optimized IPSEC Cryptograhpic library.
+ * Additional information on it can be found at:
+ *    http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=22972
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * James Guilford <james.guilford@intel.com>
+ * Sean Gulley <sean.m.gulley@intel.com>
+ * Chandramouli Narayanan <mouli@linux.intel.com>
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * Redistributions of source code must retain the above copyright
+ * notice, this list of conditions and the following disclaimer.
+ * Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in
+ * the documentation and/or other materials provided with the
+ * distribution.
+ * Neither the name of Intel Corporation nor the names of its
+ * contributors may be used to endorse or promote products derived
+ * from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ */
+
+#include <linux/linkage.h>
+#include <asm/inst.h>
+
+#define CONCAT(a,b)	a##b
+#define VMOVDQ		vmovdqu
+
+#define xdata0		%xmm0
+#define xdata1		%xmm1
+#define xdata2		%xmm2
+#define xdata3		%xmm3
+#define xdata4		%xmm4
+#define xdata5		%xmm5
+#define xdata6		%xmm6
+#define xdata7		%xmm7
+#define xcounter	%xmm8
+#define xbyteswap	%xmm9
+#define xkey0		%xmm10
+#define xkey3		%xmm11
+#define xkey6		%xmm12
+#define xkey9		%xmm13
+#define xkey4		%xmm11
+#define xkey8		%xmm12
+#define xkey12		%xmm13
+#define xkeyA		%xmm14
+#define xkeyB		%xmm15
+
+#define p_in		%rdi
+#define p_iv		%rsi
+#define p_keys		%rdx
+#define p_out		%rcx
+#define num_bytes	%r8
+
+#define tmp		%r10
+#define	DDQ(i)		CONCAT(ddq_add_,i)
+#define	XMM(i)		CONCAT(%xmm, i)
+#define	DDQ_DATA	0
+#define	XDATA		1
+#define KEY_128		1
+#define KEY_192		2
+#define KEY_256		3
+
+.section .rodata
+.align 16
+
+byteswap_const:
+	.octa 0x000102030405060708090A0B0C0D0E0F
+ddq_add_1:
+	.octa 0x00000000000000000000000000000001
+ddq_add_2:
+	.octa 0x00000000000000000000000000000002
+ddq_add_3:
+	.octa 0x00000000000000000000000000000003
+ddq_add_4:
+	.octa 0x00000000000000000000000000000004
+ddq_add_5:
+	.octa 0x00000000000000000000000000000005
+ddq_add_6:
+	.octa 0x00000000000000000000000000000006
+ddq_add_7:
+	.octa 0x00000000000000000000000000000007
+ddq_add_8:
+	.octa 0x00000000000000000000000000000008
+
+.text
+
+/* generate a unique variable for ddq_add_x */
+
+.macro setddq n
+	var_ddq_add = DDQ(\n)
+.endm
+
+/* generate a unique variable for xmm register */
+.macro setxdata n
+	var_xdata = XMM(\n)
+.endm
+
+/* club the numeric 'id' to the symbol 'name' */
+
+.macro club name, id
+.altmacro
+	.if \name == DDQ_DATA
+		setddq %\id
+	.elseif \name == XDATA
+		setxdata %\id
+	.endif
+.noaltmacro
+.endm
+
+/*
+ * do_aes num_in_par load_keys key_len
+ * This increments p_in, but not p_out
+ */
+.macro do_aes b, k, key_len
+	.set by, \b
+	.set load_keys, \k
+	.set klen, \key_len
+
+	.if (load_keys)
+		vmovdqa	0*16(p_keys), xkey0
+	.endif
+
+	vpshufb	xbyteswap, xcounter, xdata0
+
+	.set i, 1
+	.rept (by - 1)
+		club DDQ_DATA, i
+		club XDATA, i
+		vpaddd	var_ddq_add(%rip), xcounter, var_xdata
+		vpshufb	xbyteswap, var_xdata, var_xdata
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	1*16(p_keys), xkeyA
+
+	vpxor	xkey0, xdata0, xdata0
+	club DDQ_DATA, by
+	vpaddd	var_ddq_add(%rip), xcounter, xcounter
+
+	.set i, 1
+	.rept (by - 1)
+		club XDATA, i
+		vpxor	xkey0, var_xdata, var_xdata
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	2*16(p_keys), xkeyB
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 1 */
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		.if (load_keys)
+			vmovdqa	3*16(p_keys), xkeyA
+		.endif
+	.else
+		vmovdqa	3*16(p_keys), xkeyA
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyB, var_xdata, var_xdata		/* key 2 */
+		.set i, (i +1)
+	.endr
+
+	add	$(16*by), p_in
+
+	.if (klen == KEY_128)
+		vmovdqa	4*16(p_keys), xkey4
+	.else
+		.if (load_keys)
+			vmovdqa	4*16(p_keys), xkey4
+		.endif
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 3 */
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	5*16(p_keys), xkeyA
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkey4, var_xdata, var_xdata		/* key 4 */
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		.if (load_keys)
+			vmovdqa	6*16(p_keys), xkeyB
+		.endif
+	.else
+		vmovdqa	6*16(p_keys), xkeyB
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 5 */
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	7*16(p_keys), xkeyA
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyB, var_xdata, var_xdata		/* key 6 */
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		vmovdqa	8*16(p_keys), xkey8
+	.else
+		.if (load_keys)
+			vmovdqa	8*16(p_keys), xkey8
+		.endif
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 7 */
+		.set i, (i +1)
+	.endr
+
+	.if (klen == KEY_128)
+		.if (load_keys)
+			vmovdqa	9*16(p_keys), xkeyA
+		.endif
+	.else
+		vmovdqa	9*16(p_keys), xkeyA
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkey8, var_xdata, var_xdata		/* key 8 */
+		.set i, (i +1)
+	.endr
+
+	vmovdqa	10*16(p_keys), xkeyB
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		vaesenc	xkeyA, var_xdata, var_xdata		/* key 9 */
+		.set i, (i +1)
+	.endr
+
+	.if (klen != KEY_128)
+		vmovdqa	11*16(p_keys), xkeyA
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		/* key 10 */
+		.if (klen == KEY_128)
+			vaesenclast	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.endif
+		.set i, (i +1)
+	.endr
+
+	.if (klen != KEY_128)
+		.if (load_keys)
+			vmovdqa	12*16(p_keys), xkey12
+		.endif
+
+		.set i, 0
+		.rept by
+			club XDATA, i
+			vaesenc	xkeyA, var_xdata, var_xdata	/* key 11 */
+			.set i, (i +1)
+		.endr
+
+		.if (klen == KEY_256)
+			vmovdqa	13*16(p_keys), xkeyA
+		.endif
+
+		.set i, 0
+		.rept by
+			club XDATA, i
+			.if (klen == KEY_256)
+				/* key 12 */
+				vaesenc	xkey12, var_xdata, var_xdata
+			.else
+				vaesenclast xkey12, var_xdata, var_xdata
+			.endif
+			.set i, (i +1)
+		.endr
+
+		.if (klen == KEY_256)
+			vmovdqa	14*16(p_keys), xkeyB
+
+			.set i, 0
+			.rept by
+				club XDATA, i
+				/* key 13 */
+				vaesenc	xkeyA, var_xdata, var_xdata
+				.set i, (i +1)
+			.endr
+
+			.set i, 0
+			.rept by
+				club XDATA, i
+				/* key 14 */
+				vaesenclast	xkeyB, var_xdata, var_xdata
+				.set i, (i +1)
+			.endr
+		.endif
+	.endif
+
+	.set i, 0
+	.rept (by / 2)
+		.set j, (i+1)
+		VMOVDQ	(i*16 - 16*by)(p_in), xkeyA
+		VMOVDQ	(j*16 - 16*by)(p_in), xkeyB
+		club XDATA, i
+		vpxor	xkeyA, var_xdata, var_xdata
+		club XDATA, j
+		vpxor	xkeyB, var_xdata, var_xdata
+		.set i, (i+2)
+	.endr
+
+	.if (i < by)
+		VMOVDQ	(i*16 - 16*by)(p_in), xkeyA
+		club XDATA, i
+		vpxor	xkeyA, var_xdata, var_xdata
+	.endif
+
+	.set i, 0
+	.rept by
+		club XDATA, i
+		VMOVDQ	var_xdata, i*16(p_out)
+		.set i, (i+1)
+	.endr
+.endm
+
+.macro do_aes_load val, key_len
+	do_aes \val, 1, \key_len
+.endm
+
+.macro do_aes_noload val, key_len
+	do_aes \val, 0, \key_len
+.endm
+
+/* main body of aes ctr load */
+
+.macro do_aes_ctrmain key_len
+
+	cmp	$16, num_bytes
+	jb	.Ldo_return2\key_len
+
+	vmovdqa	byteswap_const(%rip), xbyteswap
+	vmovdqu	(p_iv), xcounter
+	vpshufb	xbyteswap, xcounter, xcounter
+
+	mov	num_bytes, tmp
+	and	$(7*16), tmp
+	jz	.Lmult_of_8_blks\key_len
+
+	/* 1 <= tmp <= 7 */
+	cmp	$(4*16), tmp
+	jg	.Lgt4\key_len
+	je	.Leq4\key_len
+
+.Llt4\key_len:
+	cmp	$(2*16), tmp
+	jg	.Leq3\key_len
+	je	.Leq2\key_len
+
+.Leq1\key_len:
+	do_aes_load	1, \key_len
+	add	$(1*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq2\key_len:
+	do_aes_load	2, \key_len
+	add	$(2*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+
+.Leq3\key_len:
+	do_aes_load	3, \key_len
+	add	$(3*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq4\key_len:
+	do_aes_load	4, \key_len
+	add	$(4*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Lgt4\key_len:
+	cmp	$(6*16), tmp
+	jg	.Leq7\key_len
+	je	.Leq6\key_len
+
+.Leq5\key_len:
+	do_aes_load	5, \key_len
+	add	$(5*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq6\key_len:
+	do_aes_load	6, \key_len
+	add	$(6*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Leq7\key_len:
+	do_aes_load	7, \key_len
+	add	$(7*16), p_out
+	and	$(~7*16), num_bytes
+	jz	.Ldo_return2\key_len
+	jmp	.Lmain_loop2\key_len
+
+.Lmult_of_8_blks\key_len:
+	.if (\key_len != KEY_128)
+		vmovdqa	0*16(p_keys), xkey0
+		vmovdqa	4*16(p_keys), xkey4
+		vmovdqa	8*16(p_keys), xkey8
+		vmovdqa	12*16(p_keys), xkey12
+	.else
+		vmovdqa	0*16(p_keys), xkey0
+		vmovdqa	3*16(p_keys), xkey4
+		vmovdqa	6*16(p_keys), xkey8
+		vmovdqa	9*16(p_keys), xkey12
+	.endif
+.align 16
+.Lmain_loop2\key_len:
+	/* num_bytes is a multiple of 8 and >0 */
+	do_aes_noload	8, \key_len
+	add	$(8*16), p_out
+	sub	$(8*16), num_bytes
+	jne	.Lmain_loop2\key_len
+
+.Ldo_return2\key_len:
+	/* return updated IV */
+	vpshufb	xbyteswap, xcounter, xcounter
+	vmovdqu	xcounter, (p_iv)
+	ret
+.endm
+
+/*
+ * routine to do AES128 CTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_ctr_enc_128_avx_by8(void *in, void *iv, void *keys, void *out,
+ *			unsigned int num_bytes)
+ */
+ENTRY(aes_ctr_enc_128_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_128
+
+ENDPROC(aes_ctr_enc_128_avx_by8)
+
+/*
+ * routine to do AES192 CTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_ctr_enc_192_avx_by8(void *in, void *iv, void *keys, void *out,
+ *			unsigned int num_bytes)
+ */
+ENTRY(aes_ctr_enc_192_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_192
+
+ENDPROC(aes_ctr_enc_192_avx_by8)
+
+/*
+ * routine to do AES256 CTR enc/decrypt "by8"
+ * XMM registers are clobbered.
+ * Saving/restoring must be done at a higher level
+ * aes_ctr_enc_256_avx_by8(void *in, void *iv, void *keys, void *out,
+ *			unsigned int num_bytes)
+ */
+ENTRY(aes_ctr_enc_256_avx_by8)
+	/* call the aes main loop */
+	do_aes_ctrmain KEY_256
+
+ENDPROC(aes_ctr_enc_256_avx_by8)
diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 948ad0e..888950f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -105,6 +105,9 @@ void crypto_fpu_exit(void);
 #define AVX_GEN4_OPTSIZE 4096
 
 #ifdef CONFIG_X86_64
+
+static void (*aesni_ctr_enc_tfm)(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv);
 asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
@@ -155,6 +158,12 @@ asmlinkage void aesni_gcm_dec(void *ctx, u8 *out,
 

 #ifdef CONFIG_AS_AVX
+asmlinkage void aes_ctr_enc_128_avx_by8(const u8 *in, u8 *iv,
+		void *keys, u8 *out, unsigned int num_bytes);
+asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
+		void *keys, u8 *out, unsigned int num_bytes);
+asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, u8 *iv,
+		void *keys, u8 *out, unsigned int num_bytes);
 /*
  * asmlinkage void aesni_gcm_precomp_avx_gen2()
  * gcm_data *my_ctx_data, context data
@@ -472,6 +481,25 @@ static void ctr_crypt_final(struct crypto_aes_ctx *ctx,
 	crypto_inc(ctrblk, AES_BLOCK_SIZE);
 }
 
+#ifdef CONFIG_AS_AVX
+static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
+			      const u8 *in, unsigned int len, u8 *iv)
+{
+	/*
+	 * based on key length, override with the by8 version
+	 * of ctr mode encryption/decryption for improved performance
+	 * aes_set_key_common() ensures that key length is one of
+	 * {128,192,256}
+	 */
+	if (ctx->key_length == AES_KEYSIZE_128)
+		aes_ctr_enc_128_avx_by8(in, iv, (void *)ctx, out, len);
+	else if (ctx->key_length == AES_KEYSIZE_192)
+		aes_ctr_enc_192_avx_by8(in, iv, (void *)ctx, out, len);
+	else
+		aes_ctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len);
+}
+#endif
+
 static int ctr_crypt(struct blkcipher_desc *desc,
 		     struct scatterlist *dst, struct scatterlist *src,
 		     unsigned int nbytes)
@@ -486,8 +514,8 @@ static int ctr_crypt(struct blkcipher_desc *desc,
 
 	kernel_fpu_begin();
 	while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
-		aesni_ctr_enc(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			      nbytes & AES_BLOCK_MASK, walk.iv);
+		aesni_ctr_enc_tfm(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+				  nbytes & AES_BLOCK_MASK, walk.iv);
 		nbytes &= AES_BLOCK_SIZE - 1;
 		err = blkcipher_walk_done(desc, &walk, nbytes);
 	}
@@ -1493,6 +1521,14 @@ static int __init aesni_init(void)
 		aesni_gcm_enc_tfm = aesni_gcm_enc;
 		aesni_gcm_dec_tfm = aesni_gcm_dec;
 	}
+	aesni_ctr_enc_tfm = aesni_ctr_enc;
+#ifdef CONFIG_AS_AVX
+	if (cpu_has_avx) {
+		/* optimize performance of ctr mode encryption transform */
+		aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
+		pr_info("AES CTR mode by8 optimization enabled\n");
+	}
+#endif
 #endif
 
 	err = crypto_fpu_init();
-- 
1.8.2.1
