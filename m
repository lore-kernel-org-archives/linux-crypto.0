Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4D7C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 15:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80914206C3
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 15:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JINrEEQx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgGIPJg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 11:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGIPJg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 11:09:36 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B8FC08C5CE;
        Thu,  9 Jul 2020 08:09:35 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id z17so2097871edr.9;
        Thu, 09 Jul 2020 08:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjxRDHNPBZwu4XYavTKqK3sP8cHKrOhS/WhFB6zARuU=;
        b=JINrEEQxMBnHYbJN1Iiteko5xtP2cGhbZuQfaVvameFjLmEqC8JBq4SDZa+ix3WfI+
         dZh7jcWGD+E1PlH1G6b6Wn4dZp98WTlrn1aU4MwcMx1BPKBfUmSNWPPaArgmgZVdTRta
         U/Xi5CmDIncwvkpf89Inrfn50zeC3xlOoWwGkeYAMf1Wsfif0dw2jbriVRk2v+/w4jZs
         9141l8d0B1vtjjWnw8+KpaQk+aqCKpkXimtT87fafWJAhLZF9hgw/1Vl2f/k7MbzFLnG
         SpmM5fUtHbHrbvipIMooonkTZIb7U7fRvFXI6Ao5sVSCsO6Du0Ml0dKnMmrwXVWOkOp3
         SvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kjxRDHNPBZwu4XYavTKqK3sP8cHKrOhS/WhFB6zARuU=;
        b=LFgkdGFDzStsQ6KxijxkCD907gWoccxi+pXikBUrJxoWa+kpCNJeccUu6xrFTsDKCU
         cqCI9faB2RHO5VE3zjS2GowaBSrLVeLpsLa3NJ/p0hDM8c43gEG2hpygirzYpxfgZkwy
         f9qNXTBbvV7a27CPJW90dP+v4j3aCwyOM9PyLVfhigt864x670QdXI6I5NwQVKTyzDxA
         QeR3K8bzBvf+E4N7kBva2l4idTTW+2fLlsUIUWhVlPXVH8euFb3rB/bRpudLyQTxcKkk
         ar6E6n2JPDSkikTHPREXCaf7LbAZJxOerX2hJt3aqtbujgw4JWiiJWBRWOcA8mLucUZ3
         1x0w==
X-Gm-Message-State: AOAM532s0jAgwri8mNBqwbclaZV9u3TGGwsDrpzxz7PDKDPlRYTM0vRh
        GxIM/+oeblUhVgKYvngk3c1pk3i8uQg=
X-Google-Smtp-Source: ABdhPJzunwP+tanXNO6iTGbcgFP8l6eWAeDJ80nU0fdArnAl0HlZcNo9Sb4BHiOYHXmSFT06fMwqdQ==
X-Received: by 2002:aa7:d8c2:: with SMTP id k2mr71196842eds.346.1594307373704;
        Thu, 09 Jul 2020 08:09:33 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id e22sm1982546ejd.36.2020.07.09.08.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 08:09:32 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] crypto/x86: Remove include/asm/inst.h
Date:   Thu,  9 Jul 2020 17:08:57 +0200
Message-Id: <20200709150857.4304-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Current minimum required version of binutils is 2.23,
which supports PSHUFB, PCLMULQDQ, PEXTRD, AESKEYGENASSIST,
AESIMC, AESENC, AESENCLAST, AESDEC, AESDECLAST and MOVQ
instruction mnemonics.

Substitute macros from include/asm/inst.h with a proper
instruction mnemonics in various assmbly files from
x86/crypto directory, and remove now unneeded file.

The patch was tested by calculating and comparing sha256sum
hashes of stripped object files before and after the patch,
to be sure that executable code didn't change.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S   |   1 -
 arch/x86/crypto/aesni-intel_asm.S         | 733 +++++++++++-----------
 arch/x86/crypto/aesni-intel_avx-x86_64.S  |   1 -
 arch/x86/crypto/crc32-pclmul_asm.S        |  47 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S |   5 +-
 arch/x86/crypto/ghash-clmulni-intel_asm.S |  17 +-
 arch/x86/include/asm/inst.h               | 311 ---------
 7 files changed, 399 insertions(+), 716 deletions(-)
 delete mode 100644 arch/x86/include/asm/inst.h

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index ec437db1fa54..1b8ed607f06c 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -63,7 +63,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/inst.h>
 
 #define VMOVDQ		vmovdqu
 
diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 54e7d15dbd0d..50b40b67272a 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -26,7 +26,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/inst.h>
 #include <asm/frame.h>
 #include <asm/nospec-branch.h>
 
@@ -201,7 +200,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	mov	\SUBKEY, %r12
 	movdqu	(%r12), \TMP3
 	movdqa	SHUF_MASK(%rip), \TMP2
-	PSHUFB_XMM \TMP2, \TMP3
+	pshufb	\TMP2, \TMP3
 
 	# precompute HashKey<<1 mod poly from the HashKey (required for GHASH)
 
@@ -263,7 +262,7 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
 	movdqu %xmm0, OrigIV(%arg2) # ctx_data.orig_IV = iv
 
 	movdqa  SHUF_MASK(%rip), %xmm2
-	PSHUFB_XMM %xmm2, %xmm0
+	pshufb %xmm2, %xmm0
 	movdqu %xmm0, CurCount(%arg2) # ctx_data.current_counter = iv
 
 	PRECOMPUTE \SUBKEY, %xmm1, %xmm2, %xmm3, %xmm4, %xmm5, %xmm6, %xmm7,
@@ -347,7 +346,7 @@ _zero_cipher_left_\@:
 	paddd ONE(%rip), %xmm0                # INCR CNT to get Yn
 	movdqu %xmm0, CurCount(%arg2)
 	movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10, %xmm0
+	pshufb %xmm10, %xmm0
 
 	ENCRYPT_SINGLE_BLOCK	%xmm0, %xmm1        # Encrypt(K, Yn)
 	movdqu %xmm0, PBlockEncKey(%arg2)
@@ -377,7 +376,7 @@ _large_enough_update_\@:
 	# get the appropriate shuffle mask
 	movdqu	(%r12), %xmm2
 	# shift right 16-r13 bytes
-	PSHUFB_XMM  %xmm2, %xmm1
+	pshufb  %xmm2, %xmm1
 
 _data_read_\@:
 	lea ALL_F+16(%rip), %r12
@@ -393,12 +392,12 @@ _data_read_\@:
 .ifc \operation, dec
 	pand    %xmm1, %xmm2
 	movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10 ,%xmm2
+	pshufb %xmm10 ,%xmm2
 
 	pxor %xmm2, %xmm8
 .else
 	movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10,%xmm0
+	pshufb %xmm10,%xmm0
 
 	pxor	%xmm0, %xmm8
 .endif
@@ -408,17 +407,17 @@ _data_read_\@:
 	# GHASH computation for the last <16 byte block
 	movdqa SHUF_MASK(%rip), %xmm10
 	# shuffle xmm0 back to output as ciphertext
-	PSHUFB_XMM %xmm10, %xmm0
+	pshufb %xmm10, %xmm0
 .endif
 
 	# Output %r13 bytes
-	MOVQ_R64_XMM %xmm0, %rax
+	movq %xmm0, %rax
 	cmp $8, %r13
 	jle _less_than_8_bytes_left_\@
 	mov %rax, (%arg3 , %r11, 1)
 	add $8, %r11
 	psrldq $8, %xmm0
-	MOVQ_R64_XMM %xmm0, %rax
+	movq %xmm0, %rax
 	sub $8, %r13
 _less_than_8_bytes_left_\@:
 	mov %al,  (%arg3, %r11, 1)
@@ -449,7 +448,7 @@ _partial_done\@:
 	movd	%r12d, %xmm15		  # len(A) in %xmm15
 	mov InLen(%arg2), %r12
 	shl     $3, %r12                  # len(C) in bits (*128)
-	MOVQ_R64_XMM    %r12, %xmm1
+	movq    %r12, %xmm1
 
 	pslldq	$8, %xmm15		  # %xmm15 = len(A)||0x0000000000000000
 	pxor	%xmm1, %xmm15		  # %xmm15 = len(A)||len(C)
@@ -457,7 +456,7 @@ _partial_done\@:
 	GHASH_MUL	%xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
 	# final GHASH computation
 	movdqa SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM %xmm10, %xmm8
+	pshufb %xmm10, %xmm8
 
 	movdqu OrigIV(%arg2), %xmm0       # %xmm0 = Y0
 	ENCRYPT_SINGLE_BLOCK	%xmm0,  %xmm1	  # E(K, Y0)
@@ -470,7 +469,7 @@ _return_T_\@:
 	cmp	$8, %r11
 	jl	_T_4_\@
 _T_8_\@:
-	MOVQ_R64_XMM	%xmm0, %rax
+	movq	%xmm0, %rax
 	mov	%rax, (%r10)
 	add	$8, %r10
 	sub	$8, %r11
@@ -518,9 +517,9 @@ _return_T_done_\@:
 	pshufd	  $78, \HK, \TMP3
 	pxor	  \GH, \TMP2            # TMP2 = a1+a0
 	pxor	  \HK, \TMP3            # TMP3 = b1+b0
-	PCLMULQDQ 0x11, \HK, \TMP1     # TMP1 = a1*b1
-	PCLMULQDQ 0x00, \HK, \GH       # GH = a0*b0
-	PCLMULQDQ 0x00, \TMP3, \TMP2   # TMP2 = (a0+a1)*(b1+b0)
+	pclmulqdq $0x11, \HK, \TMP1     # TMP1 = a1*b1
+	pclmulqdq $0x00, \HK, \GH       # GH = a0*b0
+	pclmulqdq $0x00, \TMP3, \TMP2   # TMP2 = (a0+a1)*(b1+b0)
 	pxor	  \GH, \TMP2
 	pxor	  \TMP1, \TMP2          # TMP2 = (a0*b0)+(a1*b0)
 	movdqa	  \TMP2, \TMP3
@@ -570,7 +569,7 @@ _return_T_done_\@:
         cmp $8, \DLEN
         jl _read_lt8_\@
         mov (\DPTR), %rax
-        MOVQ_R64_XMM %rax, \XMMDst
+        movq %rax, \XMMDst
         sub $8, \DLEN
         jz _done_read_partial_block_\@
 	xor %eax, %eax
@@ -579,7 +578,7 @@ _read_next_byte_\@:
         mov 7(\DPTR, \DLEN, 1), %al
         dec \DLEN
         jnz _read_next_byte_\@
-        MOVQ_R64_XMM %rax, \XMM1
+        movq %rax, \XMM1
 	pslldq $8, \XMM1
         por \XMM1, \XMMDst
 	jmp _done_read_partial_block_\@
@@ -590,7 +589,7 @@ _read_next_byte_lt8_\@:
         mov -1(\DPTR, \DLEN, 1), %al
         dec \DLEN
         jnz _read_next_byte_lt8_\@
-        MOVQ_R64_XMM %rax, \XMMDst
+        movq %rax, \XMMDst
 _done_read_partial_block_\@:
 .endm
 
@@ -608,7 +607,7 @@ _done_read_partial_block_\@:
 	jl	   _get_AAD_rest\@
 _get_AAD_blocks\@:
 	movdqu	   (%r10), \TMP7
-	PSHUFB_XMM   %xmm14, \TMP7 # byte-reflect the AAD data
+	pshufb	   %xmm14, \TMP7 # byte-reflect the AAD data
 	pxor	   \TMP7, \TMP6
 	GHASH_MUL  \TMP6, \HASHKEY, \TMP1, \TMP2, \TMP3, \TMP4, \TMP5
 	add	   $16, %r10
@@ -624,7 +623,7 @@ _get_AAD_rest\@:
 	je	   _get_AAD_done\@
 
 	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, \TMP7
-	PSHUFB_XMM   %xmm14, \TMP7 # byte-reflect the AAD data
+	pshufb	   %xmm14, \TMP7 # byte-reflect the AAD data
 	pxor	   \TMP6, \TMP7
 	GHASH_MUL  \TMP7, \HASHKEY, \TMP1, \TMP2, \TMP3, \TMP4, \TMP5
 	movdqu \TMP7, \TMP6
@@ -667,7 +666,7 @@ _data_read_\@:				# Finished reading in data
 	# r16-r13 is the number of bytes in plaintext mod 16)
 	add	%r13, %r12
 	movdqu	(%r12), %xmm2		# get the appropriate shuffle mask
-	PSHUFB_XMM %xmm2, %xmm9		# shift right r13 bytes
+	pshufb	%xmm2, %xmm9		# shift right r13 bytes
 
 .ifc \operation, dec
 	movdqa	%xmm1, %xmm3
@@ -689,8 +688,8 @@ _no_extra_mask_1_\@:
 
 	pand	%xmm1, %xmm3
 	movdqa	SHUF_MASK(%rip), %xmm10
-	PSHUFB_XMM	%xmm10, %xmm3
-	PSHUFB_XMM	%xmm2, %xmm3
+	pshufb	%xmm10, %xmm3
+	pshufb	%xmm2, %xmm3
 	pxor	%xmm3, \AAD_HASH
 
 	cmp	$0, %r10
@@ -724,8 +723,8 @@ _no_extra_mask_2_\@:
 	pand	%xmm1, %xmm9
 
 	movdqa	SHUF_MASK(%rip), %xmm1
-	PSHUFB_XMM %xmm1, %xmm9
-	PSHUFB_XMM %xmm2, %xmm9
+	pshufb	%xmm1, %xmm9
+	pshufb	%xmm2, %xmm9
 	pxor	%xmm9, \AAD_HASH
 
 	cmp	$0, %r10
@@ -744,8 +743,8 @@ _encode_done_\@:
 
 	movdqa	SHUF_MASK(%rip), %xmm10
 	# shuffle xmm9 back to output as ciphertext
-	PSHUFB_XMM	%xmm10, %xmm9
-	PSHUFB_XMM	%xmm2, %xmm9
+	pshufb	%xmm10, %xmm9
+	pshufb	%xmm2, %xmm9
 .endif
 	# output encrypted Bytes
 	cmp	$0, %r10
@@ -759,14 +758,14 @@ _partial_fill_\@:
 	mov	\PLAIN_CYPH_LEN, %r13
 _count_set_\@:
 	movdqa	%xmm9, %xmm0
-	MOVQ_R64_XMM	%xmm0, %rax
+	movq	%xmm0, %rax
 	cmp	$8, %r13
 	jle	_less_than_8_bytes_left_\@
 
 	mov	%rax, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
 	add	$8, \DATA_OFFSET
 	psrldq	$8, %xmm0
-	MOVQ_R64_XMM	%xmm0, %rax
+	movq	%xmm0, %rax
 	sub	$8, %r13
 _less_than_8_bytes_left_\@:
 	movb	%al, (\CYPH_PLAIN_OUT, \DATA_OFFSET, 1)
@@ -810,7 +809,7 @@ _partial_block_done_\@:
 .else
 	MOVADQ		\XMM0, %xmm\index
 .endif
-	PSHUFB_XMM	%xmm14, %xmm\index      # perform a 16 byte swap
+	pshufb	%xmm14, %xmm\index      # perform a 16 byte swap
 	pxor		\TMP2, %xmm\index
 .endr
 	lea	0x10(%arg1),%r10
@@ -821,7 +820,7 @@ _partial_block_done_\@:
 aes_loop_initial_\@:
 	MOVADQ	(%r10),\TMP1
 .irpc	index, \i_seq
-	AESENC	\TMP1, %xmm\index
+	aesenc	\TMP1, %xmm\index
 .endr
 	add	$16,%r10
 	sub	$1,%eax
@@ -829,7 +828,7 @@ aes_loop_initial_\@:
 
 	MOVADQ	(%r10), \TMP1
 .irpc index, \i_seq
-	AESENCLAST \TMP1, %xmm\index         # Last Round
+	aesenclast \TMP1, %xmm\index         # Last Round
 .endr
 .irpc index, \i_seq
 	movdqu	   (%arg4 , %r11, 1), \TMP1
@@ -841,7 +840,7 @@ aes_loop_initial_\@:
 .ifc \operation, dec
 	movdqa     \TMP1, %xmm\index
 .endif
-	PSHUFB_XMM	   %xmm14, %xmm\index
+	pshufb	   %xmm14, %xmm\index
 
 		# prepare plaintext/ciphertext for GHASH computation
 .endr
@@ -876,19 +875,19 @@ aes_loop_initial_\@:
 	MOVADQ	   ONE(%RIP),\TMP1
 	paddd	   \TMP1, \XMM0              # INCR Y0
 	MOVADQ	   \XMM0, \XMM1
-	PSHUFB_XMM  %xmm14, \XMM1        # perform a 16 byte swap
+	pshufb  %xmm14, \XMM1        # perform a 16 byte swap
 
 	paddd	   \TMP1, \XMM0              # INCR Y0
 	MOVADQ	   \XMM0, \XMM2
-	PSHUFB_XMM  %xmm14, \XMM2        # perform a 16 byte swap
+	pshufb  %xmm14, \XMM2        # perform a 16 byte swap
 
 	paddd	   \TMP1, \XMM0              # INCR Y0
 	MOVADQ	   \XMM0, \XMM3
-	PSHUFB_XMM %xmm14, \XMM3        # perform a 16 byte swap
+	pshufb %xmm14, \XMM3        # perform a 16 byte swap
 
 	paddd	   \TMP1, \XMM0              # INCR Y0
 	MOVADQ	   \XMM0, \XMM4
-	PSHUFB_XMM %xmm14, \XMM4        # perform a 16 byte swap
+	pshufb %xmm14, \XMM4        # perform a 16 byte swap
 
 	MOVADQ	   0(%arg1),\TMP1
 	pxor	   \TMP1, \XMM1
@@ -897,17 +896,17 @@ aes_loop_initial_\@:
 	pxor	   \TMP1, \XMM4
 .irpc index, 1234 # do 4 rounds
 	movaps 0x10*\index(%arg1), \TMP1
-	AESENC	   \TMP1, \XMM1
-	AESENC	   \TMP1, \XMM2
-	AESENC	   \TMP1, \XMM3
-	AESENC	   \TMP1, \XMM4
+	aesenc	   \TMP1, \XMM1
+	aesenc	   \TMP1, \XMM2
+	aesenc	   \TMP1, \XMM3
+	aesenc	   \TMP1, \XMM4
 .endr
 .irpc index, 56789 # do next 5 rounds
 	movaps 0x10*\index(%arg1), \TMP1
-	AESENC	   \TMP1, \XMM1
-	AESENC	   \TMP1, \XMM2
-	AESENC	   \TMP1, \XMM3
-	AESENC	   \TMP1, \XMM4
+	aesenc	   \TMP1, \XMM1
+	aesenc	   \TMP1, \XMM2
+	aesenc	   \TMP1, \XMM3
+	aesenc	   \TMP1, \XMM4
 .endr
 	lea	   0xa0(%arg1),%r10
 	mov	   keysize,%eax
@@ -918,7 +917,7 @@ aes_loop_initial_\@:
 aes_loop_pre_\@:
 	MOVADQ	   (%r10),\TMP2
 .irpc	index, 1234
-	AESENC	   \TMP2, %xmm\index
+	aesenc	   \TMP2, %xmm\index
 .endr
 	add	   $16,%r10
 	sub	   $1,%eax
@@ -926,10 +925,10 @@ aes_loop_pre_\@:
 
 aes_loop_pre_done\@:
 	MOVADQ	   (%r10), \TMP2
-	AESENCLAST \TMP2, \XMM1
-	AESENCLAST \TMP2, \XMM2
-	AESENCLAST \TMP2, \XMM3
-	AESENCLAST \TMP2, \XMM4
+	aesenclast \TMP2, \XMM1
+	aesenclast \TMP2, \XMM2
+	aesenclast \TMP2, \XMM3
+	aesenclast \TMP2, \XMM4
 	movdqu	   16*0(%arg4 , %r11 , 1), \TMP1
 	pxor	   \TMP1, \XMM1
 .ifc \operation, dec
@@ -961,12 +960,12 @@ aes_loop_pre_done\@:
 .endif
 
 	add	   $64, %r11
-	PSHUFB_XMM %xmm14, \XMM1 # perform a 16 byte swap
+	pshufb %xmm14, \XMM1 # perform a 16 byte swap
 	pxor	   \XMMDst, \XMM1
 # combine GHASHed value with the corresponding ciphertext
-	PSHUFB_XMM %xmm14, \XMM2 # perform a 16 byte swap
-	PSHUFB_XMM %xmm14, \XMM3 # perform a 16 byte swap
-	PSHUFB_XMM %xmm14, \XMM4 # perform a 16 byte swap
+	pshufb %xmm14, \XMM2 # perform a 16 byte swap
+	pshufb %xmm14, \XMM3 # perform a 16 byte swap
+	pshufb %xmm14, \XMM4 # perform a 16 byte swap
 
 _initial_blocks_done\@:
 
@@ -994,7 +993,7 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	pxor	  \XMM5, \TMP6
 	paddd     ONE(%rip), \XMM0		# INCR CNT
 	movdqu	  HashKey_4(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP4           # TMP4 = a1*b1
+	pclmulqdq $0x11, \TMP5, \TMP4           # TMP4 = a1*b1
 	movdqa    \XMM0, \XMM1
 	paddd     ONE(%rip), \XMM0		# INCR CNT
 	movdqa    \XMM0, \XMM2
@@ -1002,51 +1001,51 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	movdqa    \XMM0, \XMM3
 	paddd     ONE(%rip), \XMM0		# INCR CNT
 	movdqa    \XMM0, \XMM4
-	PSHUFB_XMM %xmm15, \XMM1	# perform a 16 byte swap
-	PCLMULQDQ 0x00, \TMP5, \XMM5           # XMM5 = a0*b0
-	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
+	pshufb %xmm15, \XMM1	# perform a 16 byte swap
+	pclmulqdq $0x00, \TMP5, \XMM5           # XMM5 = a0*b0
+	pshufb %xmm15, \XMM2	# perform a 16 byte swap
+	pshufb %xmm15, \XMM3	# perform a 16 byte swap
+	pshufb %xmm15, \XMM4	# perform a 16 byte swap
 
 	pxor	  (%arg1), \XMM1
 	pxor	  (%arg1), \XMM2
 	pxor	  (%arg1), \XMM3
 	pxor	  (%arg1), \XMM4
 	movdqu	  HashKey_4_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP6           # TMP6 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP6       # TMP6 = (a1+a0)*(b1+b0)
 	movaps 0x10(%arg1), \TMP1
-	AESENC	  \TMP1, \XMM1              # Round 1
-	AESENC	  \TMP1, \XMM2
-	AESENC	  \TMP1, \XMM3
-	AESENC	  \TMP1, \XMM4
+	aesenc	  \TMP1, \XMM1              # Round 1
+	aesenc	  \TMP1, \XMM2
+	aesenc	  \TMP1, \XMM3
+	aesenc	  \TMP1, \XMM4
 	movaps 0x20(%arg1), \TMP1
-	AESENC	  \TMP1, \XMM1              # Round 2
-	AESENC	  \TMP1, \XMM2
-	AESENC	  \TMP1, \XMM3
-	AESENC	  \TMP1, \XMM4
+	aesenc	  \TMP1, \XMM1              # Round 2
+	aesenc	  \TMP1, \XMM2
+	aesenc	  \TMP1, \XMM3
+	aesenc	  \TMP1, \XMM4
 	movdqa	  \XMM6, \TMP1
 	pshufd	  $78, \XMM6, \TMP2
 	pxor	  \XMM6, \TMP2
 	movdqu	  HashKey_3(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP1           # TMP1 = a1 * b1
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1 * b1
 	movaps 0x30(%arg1), \TMP3
-	AESENC    \TMP3, \XMM1              # Round 3
-	AESENC    \TMP3, \XMM2
-	AESENC    \TMP3, \XMM3
-	AESENC    \TMP3, \XMM4
-	PCLMULQDQ 0x00, \TMP5, \XMM6           # XMM6 = a0*b0
+	aesenc    \TMP3, \XMM1              # Round 3
+	aesenc    \TMP3, \XMM2
+	aesenc    \TMP3, \XMM3
+	aesenc    \TMP3, \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM6       # XMM6 = a0*b0
 	movaps 0x40(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1              # Round 4
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 4
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	movdqu	  HashKey_3_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	movaps 0x50(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1              # Round 5
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 5
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	pxor	  \TMP1, \TMP4
 # accumulate the results in TMP4:XMM5, TMP6 holds the middle part
 	pxor	  \XMM6, \XMM5
@@ -1058,25 +1057,25 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 
         # Multiply TMP5 * HashKey using karatsuba
 
-	PCLMULQDQ 0x11, \TMP5, \TMP1           # TMP1 = a1*b1
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1*b1
 	movaps 0x60(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1              # Round 6
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
-	PCLMULQDQ 0x00, \TMP5, \XMM7           # XMM7 = a0*b0
+	aesenc	  \TMP3, \XMM1              # Round 6
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM7       # XMM7 = a0*b0
 	movaps 0x70(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1             # Round 7
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 7
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	movdqu	  HashKey_2_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	movaps 0x80(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1             # Round 8
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 8
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	pxor	  \TMP1, \TMP4
 # accumulate the results in TMP4:XMM5, TMP6 holds the middle part
 	pxor	  \XMM7, \XMM5
@@ -1089,13 +1088,13 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	pshufd	  $78, \XMM8, \TMP2
 	pxor	  \XMM8, \TMP2
 	movdqu	  HashKey(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP1          # TMP1 = a1*b1
+	pclmulqdq $0x11, \TMP5, \TMP1      # TMP1 = a1*b1
 	movaps 0x90(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1            # Round 9
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
-	PCLMULQDQ 0x00, \TMP5, \XMM8          # XMM8 = a0*b0
+	aesenc	  \TMP3, \XMM1             # Round 9
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM8      # XMM8 = a0*b0
 	lea	  0xa0(%arg1),%r10
 	mov	  keysize,%eax
 	shr	  $2,%eax			# 128->4, 192->6, 256->8
@@ -1105,7 +1104,7 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 aes_loop_par_enc\@:
 	MOVADQ	  (%r10),\TMP3
 .irpc	index, 1234
-	AESENC	  \TMP3, %xmm\index
+	aesenc	  \TMP3, %xmm\index
 .endr
 	add	  $16,%r10
 	sub	  $1,%eax
@@ -1113,12 +1112,12 @@ aes_loop_par_enc\@:
 
 aes_loop_par_enc_done\@:
 	MOVADQ	  (%r10), \TMP3
-	AESENCLAST \TMP3, \XMM1           # Round 10
-	AESENCLAST \TMP3, \XMM2
-	AESENCLAST \TMP3, \XMM3
-	AESENCLAST \TMP3, \XMM4
+	aesenclast \TMP3, \XMM1           # Round 10
+	aesenclast \TMP3, \XMM2
+	aesenclast \TMP3, \XMM3
+	aesenclast \TMP3, \XMM4
 	movdqu    HashKey_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
 	movdqu	  (%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM1                 # Ciphertext/Plaintext XOR EK
 	movdqu	  16(%arg4,%r11,1), \TMP3
@@ -1131,10 +1130,10 @@ aes_loop_par_enc_done\@:
         movdqu    \XMM2, 16(%arg3,%r11,1)      # Write to the ciphertext buffer
         movdqu    \XMM3, 32(%arg3,%r11,1)      # Write to the ciphertext buffer
         movdqu    \XMM4, 48(%arg3,%r11,1)      # Write to the ciphertext buffer
-	PSHUFB_XMM %xmm15, \XMM1        # perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
+	pshufb %xmm15, \XMM1        # perform a 16 byte swap
+	pshufb %xmm15, \XMM2	# perform a 16 byte swap
+	pshufb %xmm15, \XMM3	# perform a 16 byte swap
+	pshufb %xmm15, \XMM4	# perform a 16 byte swap
 
 	pxor	  \TMP4, \TMP1
 	pxor	  \XMM8, \XMM5
@@ -1202,7 +1201,7 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	pxor	  \XMM5, \TMP6
 	paddd     ONE(%rip), \XMM0		# INCR CNT
 	movdqu	  HashKey_4(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP4           # TMP4 = a1*b1
+	pclmulqdq $0x11, \TMP5, \TMP4           # TMP4 = a1*b1
 	movdqa    \XMM0, \XMM1
 	paddd     ONE(%rip), \XMM0		# INCR CNT
 	movdqa    \XMM0, \XMM2
@@ -1210,51 +1209,51 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	movdqa    \XMM0, \XMM3
 	paddd     ONE(%rip), \XMM0		# INCR CNT
 	movdqa    \XMM0, \XMM4
-	PSHUFB_XMM %xmm15, \XMM1	# perform a 16 byte swap
-	PCLMULQDQ 0x00, \TMP5, \XMM5           # XMM5 = a0*b0
-	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
+	pshufb %xmm15, \XMM1	# perform a 16 byte swap
+	pclmulqdq $0x00, \TMP5, \XMM5           # XMM5 = a0*b0
+	pshufb %xmm15, \XMM2	# perform a 16 byte swap
+	pshufb %xmm15, \XMM3	# perform a 16 byte swap
+	pshufb %xmm15, \XMM4	# perform a 16 byte swap
 
 	pxor	  (%arg1), \XMM1
 	pxor	  (%arg1), \XMM2
 	pxor	  (%arg1), \XMM3
 	pxor	  (%arg1), \XMM4
 	movdqu	  HashKey_4_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP6           # TMP6 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP6       # TMP6 = (a1+a0)*(b1+b0)
 	movaps 0x10(%arg1), \TMP1
-	AESENC	  \TMP1, \XMM1              # Round 1
-	AESENC	  \TMP1, \XMM2
-	AESENC	  \TMP1, \XMM3
-	AESENC	  \TMP1, \XMM4
+	aesenc	  \TMP1, \XMM1              # Round 1
+	aesenc	  \TMP1, \XMM2
+	aesenc	  \TMP1, \XMM3
+	aesenc	  \TMP1, \XMM4
 	movaps 0x20(%arg1), \TMP1
-	AESENC	  \TMP1, \XMM1              # Round 2
-	AESENC	  \TMP1, \XMM2
-	AESENC	  \TMP1, \XMM3
-	AESENC	  \TMP1, \XMM4
+	aesenc	  \TMP1, \XMM1              # Round 2
+	aesenc	  \TMP1, \XMM2
+	aesenc	  \TMP1, \XMM3
+	aesenc	  \TMP1, \XMM4
 	movdqa	  \XMM6, \TMP1
 	pshufd	  $78, \XMM6, \TMP2
 	pxor	  \XMM6, \TMP2
 	movdqu	  HashKey_3(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP1           # TMP1 = a1 * b1
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1 * b1
 	movaps 0x30(%arg1), \TMP3
-	AESENC    \TMP3, \XMM1              # Round 3
-	AESENC    \TMP3, \XMM2
-	AESENC    \TMP3, \XMM3
-	AESENC    \TMP3, \XMM4
-	PCLMULQDQ 0x00, \TMP5, \XMM6           # XMM6 = a0*b0
+	aesenc    \TMP3, \XMM1              # Round 3
+	aesenc    \TMP3, \XMM2
+	aesenc    \TMP3, \XMM3
+	aesenc    \TMP3, \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM6       # XMM6 = a0*b0
 	movaps 0x40(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1              # Round 4
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 4
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	movdqu	  HashKey_3_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	movaps 0x50(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1              # Round 5
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 5
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	pxor	  \TMP1, \TMP4
 # accumulate the results in TMP4:XMM5, TMP6 holds the middle part
 	pxor	  \XMM6, \XMM5
@@ -1266,25 +1265,25 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 
         # Multiply TMP5 * HashKey using karatsuba
 
-	PCLMULQDQ 0x11, \TMP5, \TMP1           # TMP1 = a1*b1
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1*b1
 	movaps 0x60(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1              # Round 6
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
-	PCLMULQDQ 0x00, \TMP5, \XMM7           # XMM7 = a0*b0
+	aesenc	  \TMP3, \XMM1              # Round 6
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM7       # XMM7 = a0*b0
 	movaps 0x70(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1             # Round 7
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 7
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	movdqu	  HashKey_2_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP2           # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	movaps 0x80(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1             # Round 8
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
+	aesenc	  \TMP3, \XMM1              # Round 8
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
 	pxor	  \TMP1, \TMP4
 # accumulate the results in TMP4:XMM5, TMP6 holds the middle part
 	pxor	  \XMM7, \XMM5
@@ -1297,13 +1296,13 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 	pshufd	  $78, \XMM8, \TMP2
 	pxor	  \XMM8, \TMP2
 	movdqu	  HashKey(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP1          # TMP1 = a1*b1
+	pclmulqdq $0x11, \TMP5, \TMP1      # TMP1 = a1*b1
 	movaps 0x90(%arg1), \TMP3
-	AESENC	  \TMP3, \XMM1            # Round 9
-	AESENC	  \TMP3, \XMM2
-	AESENC	  \TMP3, \XMM3
-	AESENC	  \TMP3, \XMM4
-	PCLMULQDQ 0x00, \TMP5, \XMM8          # XMM8 = a0*b0
+	aesenc	  \TMP3, \XMM1             # Round 9
+	aesenc	  \TMP3, \XMM2
+	aesenc	  \TMP3, \XMM3
+	aesenc	  \TMP3, \XMM4
+	pclmulqdq $0x00, \TMP5, \XMM8      # XMM8 = a0*b0
 	lea	  0xa0(%arg1),%r10
 	mov	  keysize,%eax
 	shr	  $2,%eax		        # 128->4, 192->6, 256->8
@@ -1313,7 +1312,7 @@ TMP6 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 operation
 aes_loop_par_dec\@:
 	MOVADQ	  (%r10),\TMP3
 .irpc	index, 1234
-	AESENC	  \TMP3, %xmm\index
+	aesenc	  \TMP3, %xmm\index
 .endr
 	add	  $16,%r10
 	sub	  $1,%eax
@@ -1321,12 +1320,12 @@ aes_loop_par_dec\@:
 
 aes_loop_par_dec_done\@:
 	MOVADQ	  (%r10), \TMP3
-	AESENCLAST \TMP3, \XMM1           # last round
-	AESENCLAST \TMP3, \XMM2
-	AESENCLAST \TMP3, \XMM3
-	AESENCLAST \TMP3, \XMM4
+	aesenclast \TMP3, \XMM1           # last round
+	aesenclast \TMP3, \XMM2
+	aesenclast \TMP3, \XMM3
+	aesenclast \TMP3, \XMM4
 	movdqu    HashKey_k(%arg2), \TMP5
-	PCLMULQDQ 0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP5, \TMP2          # TMP2 = (a1+a0)*(b1+b0)
 	movdqu	  (%arg4,%r11,1), \TMP3
 	pxor	  \TMP3, \XMM1                 # Ciphertext/Plaintext XOR EK
 	movdqu	  \XMM1, (%arg3,%r11,1)        # Write to plaintext buffer
@@ -1343,10 +1342,10 @@ aes_loop_par_dec_done\@:
 	pxor	  \TMP3, \XMM4                 # Ciphertext/Plaintext XOR EK
 	movdqu	  \XMM4, 48(%arg3,%r11,1)      # Write to plaintext buffer
 	movdqa    \TMP3, \XMM4
-	PSHUFB_XMM %xmm15, \XMM1        # perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM2	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM3	# perform a 16 byte swap
-	PSHUFB_XMM %xmm15, \XMM4	# perform a 16 byte swap
+	pshufb %xmm15, \XMM1        # perform a 16 byte swap
+	pshufb %xmm15, \XMM2	# perform a 16 byte swap
+	pshufb %xmm15, \XMM3	# perform a 16 byte swap
+	pshufb %xmm15, \XMM4	# perform a 16 byte swap
 
 	pxor	  \TMP4, \TMP1
 	pxor	  \XMM8, \XMM5
@@ -1402,10 +1401,10 @@ TMP7 XMM1 XMM2 XMM3 XMM4 XMMDst
 	pshufd	  $78, \XMM1, \TMP2
 	pxor	  \XMM1, \TMP2
 	movdqu	  HashKey_4(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP6       # TMP6 = a1*b1
-	PCLMULQDQ 0x00, \TMP5, \XMM1       # XMM1 = a0*b0
+	pclmulqdq $0x11, \TMP5, \TMP6       # TMP6 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM1       # XMM1 = a0*b0
 	movdqu	  HashKey_4_k(%arg2), \TMP4
-	PCLMULQDQ 0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	movdqa	  \XMM1, \XMMDst
 	movdqa	  \TMP2, \XMM1              # result in TMP6, XMMDst, XMM1
 
@@ -1415,10 +1414,10 @@ TMP7 XMM1 XMM2 XMM3 XMM4 XMMDst
 	pshufd	  $78, \XMM2, \TMP2
 	pxor	  \XMM2, \TMP2
 	movdqu	  HashKey_3(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP1       # TMP1 = a1*b1
-	PCLMULQDQ 0x00, \TMP5, \XMM2       # XMM2 = a0*b0
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM2       # XMM2 = a0*b0
 	movdqu	  HashKey_3_k(%arg2), \TMP4
-	PCLMULQDQ 0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	pxor	  \TMP1, \TMP6
 	pxor	  \XMM2, \XMMDst
 	pxor	  \TMP2, \XMM1
@@ -1430,10 +1429,10 @@ TMP7 XMM1 XMM2 XMM3 XMM4 XMMDst
 	pshufd	  $78, \XMM3, \TMP2
 	pxor	  \XMM3, \TMP2
 	movdqu	  HashKey_2(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP1       # TMP1 = a1*b1
-	PCLMULQDQ 0x00, \TMP5, \XMM3       # XMM3 = a0*b0
+	pclmulqdq $0x11, \TMP5, \TMP1       # TMP1 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM3       # XMM3 = a0*b0
 	movdqu	  HashKey_2_k(%arg2), \TMP4
-	PCLMULQDQ 0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	pxor	  \TMP1, \TMP6
 	pxor	  \XMM3, \XMMDst
 	pxor	  \TMP2, \XMM1   # results accumulated in TMP6, XMMDst, XMM1
@@ -1443,10 +1442,10 @@ TMP7 XMM1 XMM2 XMM3 XMM4 XMMDst
 	pshufd	  $78, \XMM4, \TMP2
 	pxor	  \XMM4, \TMP2
 	movdqu	  HashKey(%arg2), \TMP5
-	PCLMULQDQ 0x11, \TMP5, \TMP1	    # TMP1 = a1*b1
-	PCLMULQDQ 0x00, \TMP5, \XMM4       # XMM4 = a0*b0
+	pclmulqdq $0x11, \TMP5, \TMP1	    # TMP1 = a1*b1
+	pclmulqdq $0x00, \TMP5, \XMM4       # XMM4 = a0*b0
 	movdqu	  HashKey_k(%arg2), \TMP4
-	PCLMULQDQ 0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
+	pclmulqdq $0x00, \TMP4, \TMP2       # TMP2 = (a1+a0)*(b1+b0)
 	pxor	  \TMP1, \TMP6
 	pxor	  \XMM4, \XMMDst
 	pxor	  \XMM1, \TMP2
@@ -1504,13 +1503,13 @@ TMP7 XMM1 XMM2 XMM3 XMM4 XMMDst
 
 _esb_loop_\@:
 	MOVADQ		(%r10),\TMP1
-	AESENC		\TMP1,\XMM0
+	aesenc		\TMP1,\XMM0
 	add		$16,%r10
 	sub		$1,%eax
 	jnz		_esb_loop_\@
 
 	MOVADQ		(%r10),\TMP1
-	AESENCLAST	\TMP1,\XMM0
+	aesenclast	\TMP1,\XMM0
 .endm
 /*****************************************************************************
 * void aesni_gcm_dec(void *aes_ctx,    // AES Key schedule. Starts on a 16 byte boundary.
@@ -1849,72 +1848,72 @@ SYM_FUNC_START(aesni_set_key)
 	movups 0x10(UKEYP), %xmm2	# other user key
 	movaps %xmm2, (TKEYP)
 	add $0x10, TKEYP
-	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
+	aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
 	call _key_expansion_256a
-	AESKEYGENASSIST 0x1 %xmm0 %xmm1
+	aeskeygenassist $0x1, %xmm0, %xmm1
 	call _key_expansion_256b
-	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
+	aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
 	call _key_expansion_256a
-	AESKEYGENASSIST 0x2 %xmm0 %xmm1
+	aeskeygenassist $0x2, %xmm0, %xmm1
 	call _key_expansion_256b
-	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
+	aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
 	call _key_expansion_256a
-	AESKEYGENASSIST 0x4 %xmm0 %xmm1
+	aeskeygenassist $0x4, %xmm0, %xmm1
 	call _key_expansion_256b
-	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
+	aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
 	call _key_expansion_256a
-	AESKEYGENASSIST 0x8 %xmm0 %xmm1
+	aeskeygenassist $0x8, %xmm0, %xmm1
 	call _key_expansion_256b
-	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
+	aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
 	call _key_expansion_256a
-	AESKEYGENASSIST 0x10 %xmm0 %xmm1
+	aeskeygenassist $0x10, %xmm0, %xmm1
 	call _key_expansion_256b
-	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
+	aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
 	call _key_expansion_256a
-	AESKEYGENASSIST 0x20 %xmm0 %xmm1
+	aeskeygenassist $0x20, %xmm0, %xmm1
 	call _key_expansion_256b
-	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
+	aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
 	call _key_expansion_256a
 	jmp .Ldec_key
 .Lenc_key192:
 	movq 0x10(UKEYP), %xmm2		# other user key
-	AESKEYGENASSIST 0x1 %xmm2 %xmm1		# round 1
+	aeskeygenassist $0x1, %xmm2, %xmm1	# round 1
 	call _key_expansion_192a
-	AESKEYGENASSIST 0x2 %xmm2 %xmm1		# round 2
+	aeskeygenassist $0x2, %xmm2, %xmm1	# round 2
 	call _key_expansion_192b
-	AESKEYGENASSIST 0x4 %xmm2 %xmm1		# round 3
+	aeskeygenassist $0x4, %xmm2, %xmm1	# round 3
 	call _key_expansion_192a
-	AESKEYGENASSIST 0x8 %xmm2 %xmm1		# round 4
+	aeskeygenassist $0x8, %xmm2, %xmm1	# round 4
 	call _key_expansion_192b
-	AESKEYGENASSIST 0x10 %xmm2 %xmm1	# round 5
+	aeskeygenassist $0x10, %xmm2, %xmm1	# round 5
 	call _key_expansion_192a
-	AESKEYGENASSIST 0x20 %xmm2 %xmm1	# round 6
+	aeskeygenassist $0x20, %xmm2, %xmm1	# round 6
 	call _key_expansion_192b
-	AESKEYGENASSIST 0x40 %xmm2 %xmm1	# round 7
+	aeskeygenassist $0x40, %xmm2, %xmm1	# round 7
 	call _key_expansion_192a
-	AESKEYGENASSIST 0x80 %xmm2 %xmm1	# round 8
+	aeskeygenassist $0x80, %xmm2, %xmm1	# round 8
 	call _key_expansion_192b
 	jmp .Ldec_key
 .Lenc_key128:
-	AESKEYGENASSIST 0x1 %xmm0 %xmm1		# round 1
+	aeskeygenassist $0x1, %xmm0, %xmm1	# round 1
 	call _key_expansion_128
-	AESKEYGENASSIST 0x2 %xmm0 %xmm1		# round 2
+	aeskeygenassist $0x2, %xmm0, %xmm1	# round 2
 	call _key_expansion_128
-	AESKEYGENASSIST 0x4 %xmm0 %xmm1		# round 3
+	aeskeygenassist $0x4, %xmm0, %xmm1	# round 3
 	call _key_expansion_128
-	AESKEYGENASSIST 0x8 %xmm0 %xmm1		# round 4
+	aeskeygenassist $0x8, %xmm0, %xmm1	# round 4
 	call _key_expansion_128
-	AESKEYGENASSIST 0x10 %xmm0 %xmm1	# round 5
+	aeskeygenassist $0x10, %xmm0, %xmm1	# round 5
 	call _key_expansion_128
-	AESKEYGENASSIST 0x20 %xmm0 %xmm1	# round 6
+	aeskeygenassist $0x20, %xmm0, %xmm1	# round 6
 	call _key_expansion_128
-	AESKEYGENASSIST 0x40 %xmm0 %xmm1	# round 7
+	aeskeygenassist $0x40, %xmm0, %xmm1	# round 7
 	call _key_expansion_128
-	AESKEYGENASSIST 0x80 %xmm0 %xmm1	# round 8
+	aeskeygenassist $0x80, %xmm0, %xmm1	# round 8
 	call _key_expansion_128
-	AESKEYGENASSIST 0x1b %xmm0 %xmm1	# round 9
+	aeskeygenassist $0x1b, %xmm0, %xmm1	# round 9
 	call _key_expansion_128
-	AESKEYGENASSIST 0x36 %xmm0 %xmm1	# round 10
+	aeskeygenassist $0x36, %xmm0, %xmm1	# round 10
 	call _key_expansion_128
 .Ldec_key:
 	sub $0x10, TKEYP
@@ -1927,7 +1926,7 @@ SYM_FUNC_START(aesni_set_key)
 .align 4
 .Ldec_key_loop:
 	movaps (KEYP), %xmm0
-	AESIMC %xmm0 %xmm1
+	aesimc %xmm0, %xmm1
 	movaps %xmm1, (UKEYP)
 	add $0x10, KEYP
 	sub $0x10, UKEYP
@@ -1988,37 +1987,37 @@ SYM_FUNC_START_LOCAL(_aesni_enc1)
 	je .Lenc192
 	add $0x20, TKEYP
 	movaps -0x60(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps -0x50(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 .align 4
 .Lenc192:
 	movaps -0x40(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps -0x30(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 .align 4
 .Lenc128:
 	movaps -0x20(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps -0x10(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps (TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps 0x10(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps 0x20(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps 0x30(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps 0x40(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps 0x50(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps 0x60(TKEYP), KEY
-	AESENC KEY STATE
+	aesenc KEY, STATE
 	movaps 0x70(TKEYP), KEY
-	AESENCLAST KEY STATE
+	aesenclast KEY, STATE
 	ret
 SYM_FUNC_END(_aesni_enc1)
 
@@ -2054,79 +2053,79 @@ SYM_FUNC_START_LOCAL(_aesni_enc4)
 	je .L4enc192
 	add $0x20, TKEYP
 	movaps -0x60(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps -0x50(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 #.align 4
 .L4enc192:
 	movaps -0x40(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps -0x30(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 #.align 4
 .L4enc128:
 	movaps -0x20(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps -0x10(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps (TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps 0x10(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps 0x20(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps 0x30(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps 0x40(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps 0x50(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps 0x60(TKEYP), KEY
-	AESENC KEY STATE1
-	AESENC KEY STATE2
-	AESENC KEY STATE3
-	AESENC KEY STATE4
+	aesenc KEY, STATE1
+	aesenc KEY, STATE2
+	aesenc KEY, STATE3
+	aesenc KEY, STATE4
 	movaps 0x70(TKEYP), KEY
-	AESENCLAST KEY STATE1		# last round
-	AESENCLAST KEY STATE2
-	AESENCLAST KEY STATE3
-	AESENCLAST KEY STATE4
+	aesenclast KEY, STATE1		# last round
+	aesenclast KEY, STATE2
+	aesenclast KEY, STATE3
+	aesenclast KEY, STATE4
 	ret
 SYM_FUNC_END(_aesni_enc4)
 
@@ -2178,37 +2177,37 @@ SYM_FUNC_START_LOCAL(_aesni_dec1)
 	je .Ldec192
 	add $0x20, TKEYP
 	movaps -0x60(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps -0x50(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 .align 4
 .Ldec192:
 	movaps -0x40(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps -0x30(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 .align 4
 .Ldec128:
 	movaps -0x20(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps -0x10(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps (TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps 0x10(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps 0x20(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps 0x30(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps 0x40(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps 0x50(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps 0x60(TKEYP), KEY
-	AESDEC KEY STATE
+	aesdec KEY, STATE
 	movaps 0x70(TKEYP), KEY
-	AESDECLAST KEY STATE
+	aesdeclast KEY, STATE
 	ret
 SYM_FUNC_END(_aesni_dec1)
 
@@ -2244,79 +2243,79 @@ SYM_FUNC_START_LOCAL(_aesni_dec4)
 	je .L4dec192
 	add $0x20, TKEYP
 	movaps -0x60(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps -0x50(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 .align 4
 .L4dec192:
 	movaps -0x40(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps -0x30(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 .align 4
 .L4dec128:
 	movaps -0x20(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps -0x10(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps (TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps 0x10(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps 0x20(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps 0x30(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps 0x40(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps 0x50(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps 0x60(TKEYP), KEY
-	AESDEC KEY STATE1
-	AESDEC KEY STATE2
-	AESDEC KEY STATE3
-	AESDEC KEY STATE4
+	aesdec KEY, STATE1
+	aesdec KEY, STATE2
+	aesdec KEY, STATE3
+	aesdec KEY, STATE4
 	movaps 0x70(TKEYP), KEY
-	AESDECLAST KEY STATE1		# last round
-	AESDECLAST KEY STATE2
-	AESDECLAST KEY STATE3
-	AESDECLAST KEY STATE4
+	aesdeclast KEY, STATE1		# last round
+	aesdeclast KEY, STATE2
+	aesdeclast KEY, STATE3
+	aesdeclast KEY, STATE4
 	ret
 SYM_FUNC_END(_aesni_dec4)
 
@@ -2599,10 +2598,10 @@ SYM_FUNC_END(aesni_cbc_dec)
 SYM_FUNC_START_LOCAL(_aesni_inc_init)
 	movaps .Lbswap_mask, BSWAP_MASK
 	movaps IV, CTR
-	PSHUFB_XMM BSWAP_MASK CTR
+	pshufb BSWAP_MASK, CTR
 	mov $1, TCTR_LOW
-	MOVQ_R64_XMM TCTR_LOW INC
-	MOVQ_R64_XMM CTR TCTR_LOW
+	movq TCTR_LOW, INC
+	movq CTR, TCTR_LOW
 	ret
 SYM_FUNC_END(_aesni_inc_init)
 
@@ -2630,7 +2629,7 @@ SYM_FUNC_START_LOCAL(_aesni_inc)
 	psrldq $8, INC
 .Linc_low:
 	movaps CTR, IV
-	PSHUFB_XMM BSWAP_MASK IV
+	pshufb BSWAP_MASK, IV
 	ret
 SYM_FUNC_END(_aesni_inc)
 
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 0cea33295287..5fee47956f3b 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -120,7 +120,6 @@
 ##
 
 #include <linux/linkage.h>
-#include <asm/inst.h>
 
 # constants in mergeable sections, linker can reorder and merge
 .section	.rodata.cst16.POLY, "aM", @progbits, 16
diff --git a/arch/x86/crypto/crc32-pclmul_asm.S b/arch/x86/crypto/crc32-pclmul_asm.S
index 9fd28ff65bc2..6e7d4c4d3208 100644
--- a/arch/x86/crypto/crc32-pclmul_asm.S
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -38,7 +38,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/inst.h>
 
 
 .section .rodata
@@ -129,17 +128,17 @@ loop_64:/*  64 bytes Full cache line folding */
 #ifdef __x86_64__
 	movdqa  %xmm4, %xmm8
 #endif
-	PCLMULQDQ 00, CONSTANT, %xmm1
-	PCLMULQDQ 00, CONSTANT, %xmm2
-	PCLMULQDQ 00, CONSTANT, %xmm3
+	pclmulqdq $0x00, CONSTANT, %xmm1
+	pclmulqdq $0x00, CONSTANT, %xmm2
+	pclmulqdq $0x00, CONSTANT, %xmm3
 #ifdef __x86_64__
-	PCLMULQDQ 00, CONSTANT, %xmm4
+	pclmulqdq $0x00, CONSTANT, %xmm4
 #endif
-	PCLMULQDQ 0x11, CONSTANT, %xmm5
-	PCLMULQDQ 0x11, CONSTANT, %xmm6
-	PCLMULQDQ 0x11, CONSTANT, %xmm7
+	pclmulqdq $0x11, CONSTANT, %xmm5
+	pclmulqdq $0x11, CONSTANT, %xmm6
+	pclmulqdq $0x11, CONSTANT, %xmm7
 #ifdef __x86_64__
-	PCLMULQDQ 0x11, CONSTANT, %xmm8
+	pclmulqdq $0x11, CONSTANT, %xmm8
 #endif
 	pxor    %xmm5, %xmm1
 	pxor    %xmm6, %xmm2
@@ -149,8 +148,8 @@ loop_64:/*  64 bytes Full cache line folding */
 #else
 	/* xmm8 unsupported for x32 */
 	movdqa  %xmm4, %xmm5
-	PCLMULQDQ 00, CONSTANT, %xmm4
-	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pclmulqdq $0x00, CONSTANT, %xmm4
+	pclmulqdq $0x11, CONSTANT, %xmm5
 	pxor    %xmm5, %xmm4
 #endif
 
@@ -172,20 +171,20 @@ less_64:/*  Folding cache line into 128bit */
 	prefetchnta     (BUF)
 
 	movdqa  %xmm1, %xmm5
-	PCLMULQDQ 0x00, CONSTANT, %xmm1
-	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pclmulqdq $0x00, CONSTANT, %xmm1
+	pclmulqdq $0x11, CONSTANT, %xmm5
 	pxor    %xmm5, %xmm1
 	pxor    %xmm2, %xmm1
 
 	movdqa  %xmm1, %xmm5
-	PCLMULQDQ 0x00, CONSTANT, %xmm1
-	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pclmulqdq $0x00, CONSTANT, %xmm1
+	pclmulqdq $0x11, CONSTANT, %xmm5
 	pxor    %xmm5, %xmm1
 	pxor    %xmm3, %xmm1
 
 	movdqa  %xmm1, %xmm5
-	PCLMULQDQ 0x00, CONSTANT, %xmm1
-	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pclmulqdq $0x00, CONSTANT, %xmm1
+	pclmulqdq $0x11, CONSTANT, %xmm5
 	pxor    %xmm5, %xmm1
 	pxor    %xmm4, %xmm1
 
@@ -193,8 +192,8 @@ less_64:/*  Folding cache line into 128bit */
 	jb      fold_64
 loop_16:/* Folding rest buffer into 128bit */
 	movdqa  %xmm1, %xmm5
-	PCLMULQDQ 0x00, CONSTANT, %xmm1
-	PCLMULQDQ 0x11, CONSTANT, %xmm5
+	pclmulqdq $0x00, CONSTANT, %xmm1
+	pclmulqdq $0x11, CONSTANT, %xmm5
 	pxor    %xmm5, %xmm1
 	pxor    (BUF), %xmm1
 	sub     $0x10, LEN
@@ -205,7 +204,7 @@ loop_16:/* Folding rest buffer into 128bit */
 fold_64:
 	/* perform the last 64 bit fold, also adds 32 zeroes
 	 * to the input stream */
-	PCLMULQDQ 0x01, %xmm1, CONSTANT /* R4 * xmm1.low */
+	pclmulqdq $0x01, %xmm1, CONSTANT /* R4 * xmm1.low */
 	psrldq  $0x08, %xmm1
 	pxor    CONSTANT, %xmm1
 
@@ -220,7 +219,7 @@ fold_64:
 #endif
 	psrldq  $0x04, %xmm2
 	pand    %xmm3, %xmm1
-	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	pclmulqdq $0x00, CONSTANT, %xmm1
 	pxor    %xmm2, %xmm1
 
 	/* Finish up with the bit-reversed barrett reduction 64 ==> 32 bits */
@@ -231,11 +230,11 @@ fold_64:
 #endif
 	movdqa  %xmm1, %xmm2
 	pand    %xmm3, %xmm1
-	PCLMULQDQ 0x10, CONSTANT, %xmm1
+	pclmulqdq $0x10, CONSTANT, %xmm1
 	pand    %xmm3, %xmm1
-	PCLMULQDQ 0x00, CONSTANT, %xmm1
+	pclmulqdq $0x00, CONSTANT, %xmm1
 	pxor    %xmm2, %xmm1
-	PEXTRD  0x01, %xmm1, %eax
+	pextrd  $0x01, %xmm1, %eax
 
 	ret
 SYM_FUNC_END(crc32_pclmul_le_16)
diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 8501ec4532f4..d84c8bf64f02 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -43,7 +43,6 @@
  * SOFTWARE.
  */
 
-#include <asm/inst.h>
 #include <linux/linkage.h>
 #include <asm/nospec-branch.h>
 
@@ -225,10 +224,10 @@ LABEL crc_ %i
 	subq    %rax, tmp			# tmp -= rax*24
 
 	movq    crc_init, %xmm1			# CRC for block 1
-	PCLMULQDQ 0x00,%xmm0,%xmm1		# Multiply by K2
+	pclmulqdq $0x00, %xmm0, %xmm1		# Multiply by K2
 
 	movq    crc1, %xmm2			# CRC for block 2
-	PCLMULQDQ 0x10, %xmm0, %xmm2		# Multiply by K1
+	pclmulqdq $0x10, %xmm0, %xmm2		# Multiply by K1
 
 	pxor    %xmm2,%xmm1
 	movq    %xmm1, %rax
diff --git a/arch/x86/crypto/ghash-clmulni-intel_asm.S b/arch/x86/crypto/ghash-clmulni-intel_asm.S
index bb9735fbb865..99ac25e18e09 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_asm.S
+++ b/arch/x86/crypto/ghash-clmulni-intel_asm.S
@@ -14,7 +14,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/inst.h>
 #include <asm/frame.h>
 
 .section	.rodata.cst16.bswap_mask, "aM", @progbits, 16
@@ -51,9 +50,9 @@ SYM_FUNC_START_LOCAL(__clmul_gf128mul_ble)
 	pxor DATA, T2
 	pxor SHASH, T3
 
-	PCLMULQDQ 0x00 SHASH DATA	# DATA = a0 * b0
-	PCLMULQDQ 0x11 SHASH T1		# T1 = a1 * b1
-	PCLMULQDQ 0x00 T3 T2		# T2 = (a1 + a0) * (b1 + b0)
+	pclmulqdq $0x00, SHASH, DATA	# DATA = a0 * b0
+	pclmulqdq $0x11, SHASH, T1	# T1 = a1 * b1
+	pclmulqdq $0x00, T3, T2		# T2 = (a1 + a0) * (b1 + b0)
 	pxor DATA, T2
 	pxor T1, T2			# T2 = a0 * b1 + a1 * b0
 
@@ -95,9 +94,9 @@ SYM_FUNC_START(clmul_ghash_mul)
 	movups (%rdi), DATA
 	movups (%rsi), SHASH
 	movaps .Lbswap_mask, BSWAP
-	PSHUFB_XMM BSWAP DATA
+	pshufb BSWAP, DATA
 	call __clmul_gf128mul_ble
-	PSHUFB_XMM BSWAP DATA
+	pshufb BSWAP, DATA
 	movups DATA, (%rdi)
 	FRAME_END
 	ret
@@ -114,18 +113,18 @@ SYM_FUNC_START(clmul_ghash_update)
 	movaps .Lbswap_mask, BSWAP
 	movups (%rdi), DATA
 	movups (%rcx), SHASH
-	PSHUFB_XMM BSWAP DATA
+	pshufb BSWAP, DATA
 .align 4
 .Lupdate_loop:
 	movups (%rsi), IN1
-	PSHUFB_XMM BSWAP IN1
+	pshufb BSWAP, IN1
 	pxor IN1, DATA
 	call __clmul_gf128mul_ble
 	sub $16, %rdx
 	add $16, %rsi
 	cmp $16, %rdx
 	jge .Lupdate_loop
-	PSHUFB_XMM BSWAP DATA
+	pshufb BSWAP, DATA
 	movups DATA, (%rdi)
 .Lupdate_just_ret:
 	FRAME_END
diff --git a/arch/x86/include/asm/inst.h b/arch/x86/include/asm/inst.h
deleted file mode 100644
index f5a796da07f8..000000000000
--- a/arch/x86/include/asm/inst.h
+++ /dev/null
@@ -1,311 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Generate .byte code for some instructions not supported by old
- * binutils.
- */
-#ifndef X86_ASM_INST_H
-#define X86_ASM_INST_H
-
-#ifdef __ASSEMBLY__
-
-#define REG_NUM_INVALID		100
-
-#define REG_TYPE_R32		0
-#define REG_TYPE_R64		1
-#define REG_TYPE_XMM		2
-#define REG_TYPE_INVALID	100
-
-	.macro R32_NUM opd r32
-	\opd = REG_NUM_INVALID
-	.ifc \r32,%eax
-	\opd = 0
-	.endif
-	.ifc \r32,%ecx
-	\opd = 1
-	.endif
-	.ifc \r32,%edx
-	\opd = 2
-	.endif
-	.ifc \r32,%ebx
-	\opd = 3
-	.endif
-	.ifc \r32,%esp
-	\opd = 4
-	.endif
-	.ifc \r32,%ebp
-	\opd = 5
-	.endif
-	.ifc \r32,%esi
-	\opd = 6
-	.endif
-	.ifc \r32,%edi
-	\opd = 7
-	.endif
-#ifdef CONFIG_X86_64
-	.ifc \r32,%r8d
-	\opd = 8
-	.endif
-	.ifc \r32,%r9d
-	\opd = 9
-	.endif
-	.ifc \r32,%r10d
-	\opd = 10
-	.endif
-	.ifc \r32,%r11d
-	\opd = 11
-	.endif
-	.ifc \r32,%r12d
-	\opd = 12
-	.endif
-	.ifc \r32,%r13d
-	\opd = 13
-	.endif
-	.ifc \r32,%r14d
-	\opd = 14
-	.endif
-	.ifc \r32,%r15d
-	\opd = 15
-	.endif
-#endif
-	.endm
-
-	.macro R64_NUM opd r64
-	\opd = REG_NUM_INVALID
-#ifdef CONFIG_X86_64
-	.ifc \r64,%rax
-	\opd = 0
-	.endif
-	.ifc \r64,%rcx
-	\opd = 1
-	.endif
-	.ifc \r64,%rdx
-	\opd = 2
-	.endif
-	.ifc \r64,%rbx
-	\opd = 3
-	.endif
-	.ifc \r64,%rsp
-	\opd = 4
-	.endif
-	.ifc \r64,%rbp
-	\opd = 5
-	.endif
-	.ifc \r64,%rsi
-	\opd = 6
-	.endif
-	.ifc \r64,%rdi
-	\opd = 7
-	.endif
-	.ifc \r64,%r8
-	\opd = 8
-	.endif
-	.ifc \r64,%r9
-	\opd = 9
-	.endif
-	.ifc \r64,%r10
-	\opd = 10
-	.endif
-	.ifc \r64,%r11
-	\opd = 11
-	.endif
-	.ifc \r64,%r12
-	\opd = 12
-	.endif
-	.ifc \r64,%r13
-	\opd = 13
-	.endif
-	.ifc \r64,%r14
-	\opd = 14
-	.endif
-	.ifc \r64,%r15
-	\opd = 15
-	.endif
-#endif
-	.endm
-
-	.macro XMM_NUM opd xmm
-	\opd = REG_NUM_INVALID
-	.ifc \xmm,%xmm0
-	\opd = 0
-	.endif
-	.ifc \xmm,%xmm1
-	\opd = 1
-	.endif
-	.ifc \xmm,%xmm2
-	\opd = 2
-	.endif
-	.ifc \xmm,%xmm3
-	\opd = 3
-	.endif
-	.ifc \xmm,%xmm4
-	\opd = 4
-	.endif
-	.ifc \xmm,%xmm5
-	\opd = 5
-	.endif
-	.ifc \xmm,%xmm6
-	\opd = 6
-	.endif
-	.ifc \xmm,%xmm7
-	\opd = 7
-	.endif
-	.ifc \xmm,%xmm8
-	\opd = 8
-	.endif
-	.ifc \xmm,%xmm9
-	\opd = 9
-	.endif
-	.ifc \xmm,%xmm10
-	\opd = 10
-	.endif
-	.ifc \xmm,%xmm11
-	\opd = 11
-	.endif
-	.ifc \xmm,%xmm12
-	\opd = 12
-	.endif
-	.ifc \xmm,%xmm13
-	\opd = 13
-	.endif
-	.ifc \xmm,%xmm14
-	\opd = 14
-	.endif
-	.ifc \xmm,%xmm15
-	\opd = 15
-	.endif
-	.endm
-
-	.macro REG_TYPE type reg
-	R32_NUM reg_type_r32 \reg
-	R64_NUM reg_type_r64 \reg
-	XMM_NUM reg_type_xmm \reg
-	.if reg_type_r64 <> REG_NUM_INVALID
-	\type = REG_TYPE_R64
-	.elseif reg_type_r32 <> REG_NUM_INVALID
-	\type = REG_TYPE_R32
-	.elseif reg_type_xmm <> REG_NUM_INVALID
-	\type = REG_TYPE_XMM
-	.else
-	\type = REG_TYPE_INVALID
-	.endif
-	.endm
-
-	.macro PFX_OPD_SIZE
-	.byte 0x66
-	.endm
-
-	.macro PFX_REX opd1 opd2 W=0
-	.if ((\opd1 | \opd2) & 8) || \W
-	.byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8) >> 1) | (\W << 3)
-	.endif
-	.endm
-
-	.macro MODRM mod opd1 opd2
-	.byte \mod | (\opd1 & 7) | ((\opd2 & 7) << 3)
-	.endm
-
-	.macro PSHUFB_XMM xmm1 xmm2
-	XMM_NUM pshufb_opd1 \xmm1
-	XMM_NUM pshufb_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX pshufb_opd1 pshufb_opd2
-	.byte 0x0f, 0x38, 0x00
-	MODRM 0xc0 pshufb_opd1 pshufb_opd2
-	.endm
-
-	.macro PCLMULQDQ imm8 xmm1 xmm2
-	XMM_NUM clmul_opd1 \xmm1
-	XMM_NUM clmul_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX clmul_opd1 clmul_opd2
-	.byte 0x0f, 0x3a, 0x44
-	MODRM 0xc0 clmul_opd1 clmul_opd2
-	.byte \imm8
-	.endm
-
-	.macro PEXTRD imm8 xmm gpr
-	R32_NUM extrd_opd1 \gpr
-	XMM_NUM extrd_opd2 \xmm
-	PFX_OPD_SIZE
-	PFX_REX extrd_opd1 extrd_opd2
-	.byte 0x0f, 0x3a, 0x16
-	MODRM 0xc0 extrd_opd1 extrd_opd2
-	.byte \imm8
-	.endm
-
-	.macro AESKEYGENASSIST rcon xmm1 xmm2
-	XMM_NUM aeskeygen_opd1 \xmm1
-	XMM_NUM aeskeygen_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX aeskeygen_opd1 aeskeygen_opd2
-	.byte 0x0f, 0x3a, 0xdf
-	MODRM 0xc0 aeskeygen_opd1 aeskeygen_opd2
-	.byte \rcon
-	.endm
-
-	.macro AESIMC xmm1 xmm2
-	XMM_NUM aesimc_opd1 \xmm1
-	XMM_NUM aesimc_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX aesimc_opd1 aesimc_opd2
-	.byte 0x0f, 0x38, 0xdb
-	MODRM 0xc0 aesimc_opd1 aesimc_opd2
-	.endm
-
-	.macro AESENC xmm1 xmm2
-	XMM_NUM aesenc_opd1 \xmm1
-	XMM_NUM aesenc_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX aesenc_opd1 aesenc_opd2
-	.byte 0x0f, 0x38, 0xdc
-	MODRM 0xc0 aesenc_opd1 aesenc_opd2
-	.endm
-
-	.macro AESENCLAST xmm1 xmm2
-	XMM_NUM aesenclast_opd1 \xmm1
-	XMM_NUM aesenclast_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX aesenclast_opd1 aesenclast_opd2
-	.byte 0x0f, 0x38, 0xdd
-	MODRM 0xc0 aesenclast_opd1 aesenclast_opd2
-	.endm
-
-	.macro AESDEC xmm1 xmm2
-	XMM_NUM aesdec_opd1 \xmm1
-	XMM_NUM aesdec_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX aesdec_opd1 aesdec_opd2
-	.byte 0x0f, 0x38, 0xde
-	MODRM 0xc0 aesdec_opd1 aesdec_opd2
-	.endm
-
-	.macro AESDECLAST xmm1 xmm2
-	XMM_NUM aesdeclast_opd1 \xmm1
-	XMM_NUM aesdeclast_opd2 \xmm2
-	PFX_OPD_SIZE
-	PFX_REX aesdeclast_opd1 aesdeclast_opd2
-	.byte 0x0f, 0x38, 0xdf
-	MODRM 0xc0 aesdeclast_opd1 aesdeclast_opd2
-	.endm
-
-	.macro MOVQ_R64_XMM opd1 opd2
-	REG_TYPE movq_r64_xmm_opd1_type \opd1
-	.if movq_r64_xmm_opd1_type == REG_TYPE_XMM
-	XMM_NUM movq_r64_xmm_opd1 \opd1
-	R64_NUM movq_r64_xmm_opd2 \opd2
-	.else
-	R64_NUM movq_r64_xmm_opd1 \opd1
-	XMM_NUM movq_r64_xmm_opd2 \opd2
-	.endif
-	PFX_OPD_SIZE
-	PFX_REX movq_r64_xmm_opd1 movq_r64_xmm_opd2 1
-	.if movq_r64_xmm_opd1_type == REG_TYPE_XMM
-	.byte 0x0f, 0x7e
-	.else
-	.byte 0x0f, 0x6e
-	.endif
-	MODRM 0xc0 movq_r64_xmm_opd1 movq_r64_xmm_opd2
-	.endm
-#endif
-
-#endif
-- 
2.26.2

