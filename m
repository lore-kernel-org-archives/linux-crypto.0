Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16752C3DA78
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Jan 2023 12:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbjAOMQG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Jan 2023 07:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjAOMQF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Jan 2023 07:16:05 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62788EC72
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:04 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id q5so442520pjh.1
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B6oF+4VZyEAvmo7w8Nzwr9qcZrAklAmY5ZcuUNzWjhI=;
        b=fTn5yfJhYtmG+vkB+ptUvD/c25kNu8mH4OEPRK26zrlcCUcRhesdQ+YD8DKgJM8bs2
         Jci9x/Ija9SlAnWMTO6J9FzB8tgUL0F3AqkbjHjxtktK0b4Qx+GcWmMZ6q4pUpwCZrvi
         bwyqPjn4av4JGL7uhdI8gH6bEDplvNXmlvfSE3Hnn6PA+NgCZV6tcYyw0IjyxYuF2Qlm
         qUTd0dmi0lpTROMPiPQS6cvl82WmVr9rqvcy6HdoVXdM1iSPfltPjbJBykDKsVKWk5sw
         +XAzmbvGFXjfb/EfKf4+hDhO35MuP8p7DIAL878nl0k9+435QPrNP2PufSJG+tcUXmcK
         cHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B6oF+4VZyEAvmo7w8Nzwr9qcZrAklAmY5ZcuUNzWjhI=;
        b=77jrcQ3jyKRYhlAvYOMuWWziRml+dPLzJ9k+mowbDTbvzqm0gffYNjCiG2WWqQ6ABQ
         hMZy1++zqWk8Wf4byXcQVHKxLzdZyOR3Yf6OvKpmlMMdO9nuRDkBTlOgvpM6JjN0z2ls
         ai5bSU3WethF4DdfOTu7LyAJyOMhLSiPLTQCdYSMWfjOHa16Z+wLAE5fVQKmKyFOrsuj
         lEQO9ppO/NCrwtE90rPTu0rgqfuARelQMANgE/TebxNxgROl7IjoAOq/q3WwO4/1xN3L
         a3blYlIq+ntgXFt4Vb5FrR+EV/X9hqMYFdJwQh1YdebIQh9YUxdZkoqvAf1auwzU42H4
         M/Yg==
X-Gm-Message-State: AFqh2koNQdZLkOWs7qbAlePQrHooLLNwt6868X3yTOtYAYZdb3F1jyrs
        aOX7YjSEnCUU3o+2C59yRCApV5iuoJs=
X-Google-Smtp-Source: AMrXdXvpdnPBqCe4rYOo7BQtOQomZoHToMylzUzTj/YGkUo5X4OqZBJPzSJkvn3clJjiuONt2KrUDg==
X-Received: by 2002:a05:6a21:e385:b0:b3:4044:1503 with SMTP id cc5-20020a056a21e38500b000b340441503mr89854994pzc.52.1673784962695;
        Sun, 15 Jan 2023 04:16:02 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e13-20020a63e00d000000b00485cbedd34bsm14361783pgh.89.2023.01.15.04.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 04:16:01 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     jbeulich@suse.com, ap420073@gmail.com
Subject: [PATCH 1/3] crypto: x86/aria-avx - fix build failure with old binutils
Date:   Sun, 15 Jan 2023 12:15:34 +0000
Message-Id: <20230115121536.465367-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230115121536.465367-1-ap420073@gmail.com>
References: <20230115121536.465367-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The minimum version of binutils for kernel build is currently 2.23 and
it doesn't support GFNI.
So, it fails to build the aria-avx if the old binutils is used.
The code using GFNI is an optional part of aria-avx.
So, it disables GFNI part in it when the old binutils is used.
In order to check whether the using binutils is supporting GFNI or not,
AS_GFNI is added.

Fixes: ba3579e6e45c ("crypto: aria-avx - add AES-NI/AVX/x86_64/GFNI assembler implementation of aria cipher")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 arch/x86/Kconfig.assembler              |  5 +++++
 arch/x86/crypto/aria-aesni-avx-asm_64.S | 10 ++++++++++
 arch/x86/crypto/aria_aesni_avx_glue.c   |  4 +++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig.assembler b/arch/x86/Kconfig.assembler
index 26b8c08e2fc4..b88f784cb02e 100644
--- a/arch/x86/Kconfig.assembler
+++ b/arch/x86/Kconfig.assembler
@@ -19,3 +19,8 @@ config AS_TPAUSE
 	def_bool $(as-instr,tpause %ecx)
 	help
 	  Supported by binutils >= 2.31.1 and LLVM integrated assembler >= V7
+
+config AS_GFNI
+	def_bool $(as-instr,vgf2p8mulb %xmm0$(comma)%xmm1$(comma)%xmm2)
+	help
+	  Supported by binutils >= 2.30 and LLVM integrated assembler
diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index be6adc6e7458..fe0d84a7ced1 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -286,6 +286,7 @@
 	vpbroadcastb ((round * 16) + idx + 4)(rk), t0;	\
 	vpxor t0, x7, x7;
 
+#ifdef CONFIG_AS_GFNI
 #define aria_sbox_8way_gfni(x0, x1, x2, x3,		\
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
@@ -308,6 +309,8 @@
 	vgf2p8affineinvqb $0, t2, x3, x3;		\
 	vgf2p8affineinvqb $0, t2, x7, x7
 
+#endif /* CONFIG_AS_GFNI */
+
 #define aria_sbox_8way(x0, x1, x2, x3,            	\
 		       x4, x5, x6, x7,			\
 		       t0, t1, t2, t3,			\
@@ -547,6 +550,7 @@
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
 
+#ifdef CONFIG_AS_GFNI
 #define aria_fe_gfni(x0, x1, x2, x3,			\
 		     x4, x5, x6, x7,			\
 		     y0, y1, y2, y3,			\
@@ -701,6 +705,8 @@
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
 
+#endif /* CONFIG_AS_GFNI */
+
 /* NB: section is mergeable, all elements must be aligned 16-byte blocks */
 .section	.rodata.cst16, "aM", @progbits, 16
 .align 16
@@ -752,6 +758,7 @@
 .Ltf_hi__x2__and__fwd_aff:
 	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
 
+#ifdef CONFIG_AS_GFNI
 .section	.rodata.cst8, "aM", @progbits, 8
 .align 8
 /* AES affine: */
@@ -812,6 +819,7 @@
 		    BV8(0, 0, 0, 0, 0, 1, 0, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
+#endif /* CONFIG_AS_GFNI */
 
 /* 4-bit mask */
 .section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
@@ -1080,6 +1088,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_ctr_crypt_16way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx_ctr_crypt_16way)
 
+#ifdef CONFIG_AS_GFNI
 SYM_FUNC_START_LOCAL(__aria_aesni_avx_gfni_crypt_16way)
 	/* input:
 	*      %r9: rk
@@ -1298,3 +1307,4 @@ SYM_TYPED_FUNC_START(aria_aesni_avx_gfni_ctr_crypt_16way)
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx_gfni_ctr_crypt_16way)
+#endif /* CONFIG_AS_GFNI */
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index 487094d64863..4e1516b76669 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -26,6 +26,7 @@ asmlinkage void aria_aesni_avx_ctr_crypt_16way(const void *ctx, u8 *dst,
 					       const u8 *src,
 					       u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx_ctr_crypt_16way);
+#ifdef CONFIG_AS_GFNI
 asmlinkage void aria_aesni_avx_gfni_encrypt_16way(const void *ctx, u8 *dst,
 						  const u8 *src);
 EXPORT_SYMBOL_GPL(aria_aesni_avx_gfni_encrypt_16way);
@@ -36,6 +37,7 @@ asmlinkage void aria_aesni_avx_gfni_ctr_crypt_16way(const void *ctx, u8 *dst,
 						    const u8 *src,
 						    u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx_gfni_ctr_crypt_16way);
+#endif /* CONFIG_AS_GFNI */
 
 static struct aria_avx_ops aria_ops;
 
@@ -201,7 +203,7 @@ static int __init aria_avx_init(void)
 		return -ENODEV;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_GFNI)) {
+	if (boot_cpu_has(X86_FEATURE_GFNI) && IS_ENABLED(CONFIG_AS_GFNI)) {
 		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
 		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
 		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
-- 
2.34.1

