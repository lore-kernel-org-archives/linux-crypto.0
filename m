Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9763FC3DA78
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Jan 2023 12:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjAOMQM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Jan 2023 07:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjAOMQI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Jan 2023 07:16:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C12EC72
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:06 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z1-20020a17090a66c100b00226f05b9595so13532535pjl.0
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 04:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsIHUBPNIc9WbNZUL0qiZArx3gr0fKEZEvsvg+a0Ja8=;
        b=WMNFp9q7PMPWpJB2sQMXSgYJ/zgEJLAnYCHawTc5GHUt6iduqz4bYqGc8y+yn4CQm+
         zzs0tLjOGkr+vwgroeRKsIC2tqUsHxZbOQTpnsTnrncPJmDLPD1IOokBP31ncXUDWLY8
         eZPr4ql6/7BLEQNIpFEWquk5U2SLxpVrK5KS2ckk6xsDS4Evu7+TnbSDP9Yxxv4Pvi/l
         JD/yBUsfEUrwTzYkFs6CIF037w7vr85DHTOO7cql0Ljh4UdOeDrLyFpdMdEqyz9yFYJR
         cihrrT8brEEOyU2vzNXCZe5HKmZBKLXzSQeA34A0cCUsf/7DR5RdAHiuqiv9QNqNkN+s
         XcYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsIHUBPNIc9WbNZUL0qiZArx3gr0fKEZEvsvg+a0Ja8=;
        b=qJHQISLVp0kkkUm575vmEc4D3cCwzWL2IQbKF4bFu/Vqidke2Z0vOnG84lh88aFOcL
         aPzv2bJ1/BoaanD/34zLE2giJ0qMQRcq4Di03vxia50NTrYEDfh/HjxqhD3FffEI3oRj
         EZWiRXd3yKHKbWInnwcZzjaNsmH9U0Luje/hspZTm5btxZ+ablPMQZdDx73cE+ZNdN6K
         ZPyzh6gItwUMwoGCyFmcSOU/YKibj8Hd478g8ufe6/VGbJLMFeC9XtoKhEZIQNBma5tR
         tV/due4PIoN2AUVYXKQ71Pc2GgYLaBNgo6w7PKjb90nKVxutpKp06GGWRxtkudNhow9v
         dS3A==
X-Gm-Message-State: AFqh2ko9m6Ryoq2gvk9oR3Tq1TrNKn35ti5H9FVDBVvnOYXNnUSC4xw3
        uXt+bXjcoAyG0W5KGqWeRPQgXhWdX+I=
X-Google-Smtp-Source: AMrXdXvCwN8PV4GsrWLAnbsAGC2X9qztR6p6CUwj7blnMYMl6yJq0485P5uCp6bLk2MNfJ5eCB1V9A==
X-Received: by 2002:a05:6a20:b91c:b0:af:89c2:ad01 with SMTP id fe28-20020a056a20b91c00b000af89c2ad01mr90230594pzb.40.1673784965690;
        Sun, 15 Jan 2023 04:16:05 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id e13-20020a63e00d000000b00485cbedd34bsm14361783pgh.89.2023.01.15.04.16.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Jan 2023 04:16:04 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     jbeulich@suse.com, ap420073@gmail.com
Subject: [PATCH 2/3] crypto: x86/aria-avx2 - fix build failure with old binutils
Date:   Sun, 15 Jan 2023 12:15:35 +0000
Message-Id: <20230115121536.465367-3-ap420073@gmail.com>
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
So, it fails to build the aria-avx2 if the old binutils is used.
The code using GFNI is an optional part of aria-avx2.
So, it disables GFNI part in it when the old binutils is used.

Fixes: 37d8d3ae7a58 ("crypto: x86/aria - implement aria-avx2")
Reported-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 arch/x86/crypto/aria-aesni-avx2-asm_64.S | 10 +++++++++-
 arch/x86/crypto/aria_aesni_avx2_glue.c   |  4 +++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx2-asm_64.S b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
index b6cac9a40f2c..82a14b4ad920 100644
--- a/arch/x86/crypto/aria-aesni-avx2-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx2-asm_64.S
@@ -302,6 +302,7 @@
 	vpbroadcastb ((round * 16) + idx + 4)(rk), t0;	\
 	vpxor t0, x7, x7;
 
+#ifdef CONFIG_AS_GFNI
 #define aria_sbox_8way_gfni(x0, x1, x2, x3,		\
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
@@ -324,6 +325,7 @@
 	vgf2p8affineinvqb $0, t2, x3, x3;		\
 	vgf2p8affineinvqb $0, t2, x7, x7
 
+#endif /* CONFIG_AS_GFNI */
 #define aria_sbox_8way(x0, x1, x2, x3,			\
 		       x4, x5, x6, x7,			\
 		       t0, t1, t2, t3,			\
@@ -596,7 +598,7 @@
 	aria_load_state_8way(y0, y1, y2, y3,		\
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
-
+#ifdef CONFIG_AS_GFNI
 #define aria_fe_gfni(x0, x1, x2, x3,			\
 		     x4, x5, x6, x7,			\
 		     y0, y1, y2, y3,			\
@@ -750,6 +752,7 @@
 	aria_load_state_8way(y0, y1, y2, y3,		\
 			     y4, y5, y6, y7,		\
 			     mem_tmp, 8);
+#endif /* CONFIG_AS_GFNI */
 
 .section        .rodata.cst32.shufb_16x16b, "aM", @progbits, 32
 .align 32
@@ -803,6 +806,7 @@
 .Ltf_hi__x2__and__fwd_aff:
 	.octa 0x3F893781E95FE1576CDA64D2BA0CB204
 
+#ifdef CONFIG_AS_GFNI
 .section	.rodata.cst8, "aM", @progbits, 8
 .align 8
 /* AES affine: */
@@ -864,6 +868,8 @@
 		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
 
+#endif /* CONFIG_AS_GFNI */
+
 /* 4-bit mask */
 .section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
 .align 4
@@ -1213,6 +1219,7 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_ctr_crypt_32way)
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_ctr_crypt_32way)
 
+#ifdef CONFIG_AS_GFNI
 SYM_FUNC_START_LOCAL(__aria_aesni_avx2_gfni_crypt_32way)
 	/* input:
 	 *      %r9: rk
@@ -1431,3 +1438,4 @@ SYM_TYPED_FUNC_START(aria_aesni_avx2_gfni_ctr_crypt_32way)
 	FRAME_END
 	RET;
 SYM_FUNC_END(aria_aesni_avx2_gfni_ctr_crypt_32way)
+#endif /* CONFIG_AS_GFNI */
diff --git a/arch/x86/crypto/aria_aesni_avx2_glue.c b/arch/x86/crypto/aria_aesni_avx2_glue.c
index 95fccc6dc420..87a11804fc77 100644
--- a/arch/x86/crypto/aria_aesni_avx2_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx2_glue.c
@@ -26,6 +26,7 @@ asmlinkage void aria_aesni_avx2_ctr_crypt_32way(const void *ctx, u8 *dst,
 						const u8 *src,
 						u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx2_ctr_crypt_32way);
+#ifdef CONFIG_AS_GFNI
 asmlinkage void aria_aesni_avx2_gfni_encrypt_32way(const void *ctx, u8 *dst,
 						   const u8 *src);
 EXPORT_SYMBOL_GPL(aria_aesni_avx2_gfni_encrypt_32way);
@@ -36,6 +37,7 @@ asmlinkage void aria_aesni_avx2_gfni_ctr_crypt_32way(const void *ctx, u8 *dst,
 						     const u8 *src,
 						     u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx2_gfni_ctr_crypt_32way);
+#endif /* CONFIG_AS_GFNI */
 
 static struct aria_avx_ops aria_ops;
 
@@ -215,7 +217,7 @@ static int __init aria_avx2_init(void)
 		return -ENODEV;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_GFNI)) {
+	if (boot_cpu_has(X86_FEATURE_GFNI) && IS_ENABLED(CONFIG_AS_GFNI)) {
 		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
 		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
 		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
-- 
2.34.1

