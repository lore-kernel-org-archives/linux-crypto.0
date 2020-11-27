Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C117C64E75
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 09:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF407221F7
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 09:45:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GZFpJlSE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgK0JpJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgK0JpJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 04:45:09 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D9BC0613D1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2020 01:45:08 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id r22so5039761edw.6
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2020 01:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RdO+xgkSodtNTqdVxQLi3RQ4R+L0y7zrkFu0WoeGDZM=;
        b=GZFpJlSE26+jkD1gunCb8BIaYI2HfMZ3RxS8iLcU3TY+fcvTiBoLwcfwEOo4KwFVMv
         XEgwDEBJNbgE7B9ILlFP1V/WHi6Mhgl6UU7NR4ZQ9NngvYmziA0+pBK/jeKJHyWF5fJm
         w4yGA9XD03dWoaYuC2LE8dS9AxMRvoKikyqu4lXLZLZDDBmXY44I/jBicLwctj5nc9Aj
         a5+oXpHY3zPEdRtyFLEJBmSVCne2o9m1sd60inz/kLgoNiezL0mAg9vZHF8V/X2T1dZY
         ifdluPGts1yQIGTf4VM7Zd7LRA6l0cEBILf6o9gk3i3u+IoDBe4CyKgzHEQ8yDnO+hWO
         h/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RdO+xgkSodtNTqdVxQLi3RQ4R+L0y7zrkFu0WoeGDZM=;
        b=CWYt3hmsNT0XMKx5VRxkCzfEgITXTaSBERAm2zESThJjzhA2kf0p2WxVIxSdyUk4D+
         ZT9uaovxs5sn4nCWXkrkVFfiIZ8DhOpJj8uIDnfFFuFesWbksao0bG/ogkQv8JTOpgcs
         wq6JYtnyMXD8fxi2wBJ9PGREnvzHpAKzVjjJlxGVdRYu6qBVH2TCpcG65jLBmhJUKjTW
         uUwBy1nsfMpS1RV+OvlHcAxdODlNGSIUHwsv3zQ99DbGbZ6XAA74a4OVKzMMP3FdkVHx
         wkBSegrbZ1RXNvR6agIT6R0eLK0UzG4RRF7RfTzz8sLLFv7a+jXXAdEXkqK/pQSoLhg3
         88gg==
X-Gm-Message-State: AOAM531hyJWucWGGET14qOO9nlACHdtTCVfJ6jQ0OzTgZq38Ms4/BBA2
        WLqDZ822C2j9V5qJ5Y0aLeeDyxz4tUUOcQ==
X-Google-Smtp-Source: ABdhPJz+oIKgw+ZdX1ZlTc2CibFobUvIy/y456vjAxdhhswmT/fZsXjPvYjXNk7V9VU3cdJaeQkutg==
X-Received: by 2002:a05:6402:b08:: with SMTP id bm8mr6656627edb.29.1606470307261;
        Fri, 27 Nov 2020 01:45:07 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id f24sm4282848ejf.117.2020.11.27.01.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 01:45:06 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     linux-crypto@vger.kernel.org, x86@kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] crypto: x86/aesni-intel: Use TEST %reg,%reg instead of CMP $0,%reg
Date:   Fri, 27 Nov 2020 10:44:52 +0100
Message-Id: <20201127094452.7721-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CMP $0,%reg can't set overflow flag, so we can use shorter TEST %reg,%reg
instruction when only zero and sign flags are checked (E,L,LE,G,GE conditions).

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/crypto/aesni-intel_asm.S        | 20 ++++++++++----------
 arch/x86/crypto/aesni-intel_avx-x86_64.S | 20 ++++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_asm.S b/arch/x86/crypto/aesni-intel_asm.S
index 1852b19a73a0..d1436c37008b 100644
--- a/arch/x86/crypto/aesni-intel_asm.S
+++ b/arch/x86/crypto/aesni-intel_asm.S
@@ -318,7 +318,7 @@ _initial_blocks_\@:
 
 	# Main loop - Encrypt/Decrypt remaining blocks
 
-	cmp	$0, %r13
+	test	%r13, %r13
 	je	_zero_cipher_left_\@
 	sub	$64, %r13
 	je	_four_cipher_left_\@
@@ -437,7 +437,7 @@ _multiple_of_16_bytes_\@:
 
 	mov PBlockLen(%arg2), %r12
 
-	cmp $0, %r12
+	test %r12, %r12
 	je _partial_done\@
 
 	GHASH_MUL %xmm8, %xmm13, %xmm9, %xmm10, %xmm11, %xmm5, %xmm6
@@ -474,7 +474,7 @@ _T_8_\@:
 	add	$8, %r10
 	sub	$8, %r11
 	psrldq	$8, %xmm0
-	cmp	$0, %r11
+	test	%r11, %r11
 	je	_return_T_done_\@
 _T_4_\@:
 	movd	%xmm0, %eax
@@ -482,7 +482,7 @@ _T_4_\@:
 	add	$4, %r10
 	sub	$4, %r11
 	psrldq	$4, %xmm0
-	cmp	$0, %r11
+	test	%r11, %r11
 	je	_return_T_done_\@
 _T_123_\@:
 	movd	%xmm0, %eax
@@ -619,7 +619,7 @@ _get_AAD_blocks\@:
 
 	/* read the last <16B of AAD */
 _get_AAD_rest\@:
-	cmp	   $0, %r11
+	test	   %r11, %r11
 	je	   _get_AAD_done\@
 
 	READ_PARTIAL_BLOCK %r10, %r11, \TMP1, \TMP7
@@ -640,7 +640,7 @@ _get_AAD_done\@:
 .macro PARTIAL_BLOCK CYPH_PLAIN_OUT PLAIN_CYPH_IN PLAIN_CYPH_LEN DATA_OFFSET \
 	AAD_HASH operation
 	mov 	PBlockLen(%arg2), %r13
-	cmp	$0, %r13
+	test	%r13, %r13
 	je	_partial_block_done_\@	# Leave Macro if no partial blocks
 	# Read in input data without over reading
 	cmp	$16, \PLAIN_CYPH_LEN
@@ -692,7 +692,7 @@ _no_extra_mask_1_\@:
 	pshufb	%xmm2, %xmm3
 	pxor	%xmm3, \AAD_HASH
 
-	cmp	$0, %r10
+	test	%r10, %r10
 	jl	_partial_incomplete_1_\@
 
 	# GHASH computation for the last <16 Byte block
@@ -727,7 +727,7 @@ _no_extra_mask_2_\@:
 	pshufb	%xmm2, %xmm9
 	pxor	%xmm9, \AAD_HASH
 
-	cmp	$0, %r10
+	test	%r10, %r10
 	jl	_partial_incomplete_2_\@
 
 	# GHASH computation for the last <16 Byte block
@@ -747,7 +747,7 @@ _encode_done_\@:
 	pshufb	%xmm2, %xmm9
 .endif
 	# output encrypted Bytes
-	cmp	$0, %r10
+	test	%r10, %r10
 	jl	_partial_fill_\@
 	mov	%r13, %r12
 	mov	$16, %r13
@@ -2720,7 +2720,7 @@ SYM_FUNC_END(aesni_ctr_enc)
  */
 SYM_FUNC_START(aesni_xts_crypt8)
 	FRAME_BEGIN
-	cmpb $0, %cl
+	testb %cl, %cl
 	movl $0, %ecx
 	movl $240, %r10d
 	leaq _aesni_enc4, %r11
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 5fee47956f3b..2cf8e94d986a 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -369,7 +369,7 @@ _initial_num_blocks_is_0\@:
 
 
 _initial_blocks_encrypted\@:
-        cmp     $0, %r13
+        test    %r13, %r13
         je      _zero_cipher_left\@
 
         sub     $128, %r13
@@ -528,7 +528,7 @@ _multiple_of_16_bytes\@:
         vmovdqu HashKey(arg2), %xmm13
 
         mov PBlockLen(arg2), %r12
-        cmp $0, %r12
+        test %r12, %r12
         je _partial_done\@
 
 	#GHASH computation for the last <16 Byte block
@@ -573,7 +573,7 @@ _T_8\@:
         add     $8, %r10
         sub     $8, %r11
         vpsrldq $8, %xmm9, %xmm9
-        cmp     $0, %r11
+        test    %r11, %r11
         je     _return_T_done\@
 _T_4\@:
         vmovd   %xmm9, %eax
@@ -581,7 +581,7 @@ _T_4\@:
         add     $4, %r10
         sub     $4, %r11
         vpsrldq     $4, %xmm9, %xmm9
-        cmp     $0, %r11
+        test    %r11, %r11
         je     _return_T_done\@
 _T_123\@:
         vmovd     %xmm9, %eax
@@ -625,7 +625,7 @@ _get_AAD_blocks\@:
 	cmp     $16, %r11
 	jge     _get_AAD_blocks\@
 	vmovdqu \T8, \T7
-	cmp     $0, %r11
+	test    %r11, %r11
 	je      _get_AAD_done\@
 
 	vpxor   \T7, \T7, \T7
@@ -644,7 +644,7 @@ _get_AAD_rest8\@:
 	vpxor   \T1, \T7, \T7
 	jmp     _get_AAD_rest8\@
 _get_AAD_rest4\@:
-	cmp     $0, %r11
+	test    %r11, %r11
 	jle      _get_AAD_rest0\@
 	mov     (%r10), %eax
 	movq    %rax, \T1
@@ -749,7 +749,7 @@ _done_read_partial_block_\@:
 .macro PARTIAL_BLOCK GHASH_MUL CYPH_PLAIN_OUT PLAIN_CYPH_IN PLAIN_CYPH_LEN DATA_OFFSET \
         AAD_HASH ENC_DEC
         mov 	PBlockLen(arg2), %r13
-        cmp	$0, %r13
+        test	%r13, %r13
         je	_partial_block_done_\@	# Leave Macro if no partial blocks
         # Read in input data without over reading
         cmp	$16, \PLAIN_CYPH_LEN
@@ -801,7 +801,7 @@ _no_extra_mask_1_\@:
         vpshufb	%xmm2, %xmm3, %xmm3
         vpxor	%xmm3, \AAD_HASH, \AAD_HASH
 
-        cmp	$0, %r10
+        test	%r10, %r10
         jl	_partial_incomplete_1_\@
 
         # GHASH computation for the last <16 Byte block
@@ -836,7 +836,7 @@ _no_extra_mask_2_\@:
         vpshufb %xmm2, %xmm9, %xmm9
         vpxor	%xmm9, \AAD_HASH, \AAD_HASH
 
-        cmp	$0, %r10
+        test	%r10, %r10
         jl	_partial_incomplete_2_\@
 
         # GHASH computation for the last <16 Byte block
@@ -856,7 +856,7 @@ _encode_done_\@:
         vpshufb	%xmm2, %xmm9, %xmm9
 .endif
         # output encrypted Bytes
-        cmp	$0, %r10
+        test	%r10, %r10
         jl	_partial_fill_\@
         mov	%r13, %r12
         mov	$16, %r13
-- 
2.26.2

