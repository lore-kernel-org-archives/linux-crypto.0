Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9A6C636CD
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 18:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjBJSP4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 13:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbjBJSPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 13:15:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F2E3A0B7
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 10:15:54 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so10716749pjq.0
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 10:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lYmWu441lxPUFesI53ppDALxbkM5i6JUPxK9yIzMBkA=;
        b=S5t5BsSqtavQse/YG6UEClDXUNtEy1ZtLGjlYrhwBI2Rh8c7MpDpXgoBRahZM6txvI
         5p+YK16VHJXnJU5bA2ynGkqo7s1voPxXb3OphmMt0hXlcGmdXqfXl76BOmEO0r4aR9Ib
         e79vN7bngYPBTyURhPge9ABdMxgA2kSnOdqY6mqn+ZTqt+v/in7QzqmEdGnCd5+NMRQn
         Hdfvs0jALVNl3iKXmfgfZhUFrjKp59CvUG+VtvV+ghsSvx7Tt8t4S5va5MLM90AXIjF8
         +Y7gIQv2PIQwpCS0YiSGvZx7LAjeLFV7qsx1ku7bhR5R1V0xG1dPADwMXPO+wnkq1GWX
         8jxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lYmWu441lxPUFesI53ppDALxbkM5i6JUPxK9yIzMBkA=;
        b=PY0OGEt+UUoQPOm0vQ2HcdGSNtMDhi0vi5ADfIaY1l9uc4sEc8fIWiq4I5+RRNF4B6
         Zsg6IO1XP0yimeCftAcxhha+Rb6VGmjLdvLFdKUjmSRUjP5Ia74Iqjt/rqiHsYCAPlsg
         aXTwjiwIk5XY6tLIC568/7n+Zb4jD5u+SLcTCycMRUhAGm9KT6EZMqjKytPtjqQzUqtK
         rP2XPy9fMnNC4H9J0APP68a7WRap9RJmb/lgy09oweYZ5fe9L2vRtxibhG5b4kVVVJFm
         bQ5rQmO3PbAigpibwSTi+VIM2+Qd17gCpDrMzU+rjXbA/nq2BPG/YhEXqX9s7oCkK1IR
         7UJQ==
X-Gm-Message-State: AO0yUKX+opkl/IbV0kvjxQqd6GUIj1kHOPXrItgpjiet3Jg/BFZeumcV
        HjYdnhnGWB5tbkg5dnX1qDuJJ2sV/z9kwA==
X-Google-Smtp-Source: AK7set9kvatRB5G/N4QCkrxsb5gpoce9Dh3NcZ1FJF0bkVKrCMSar2ioXNYnTqkP2EcoBKEXdLHFfQ==
X-Received: by 2002:a17:903:4112:b0:19a:67c0:53ee with SMTP id r18-20020a170903411200b0019a67c053eemr3991941pld.54.1676052952636;
        Fri, 10 Feb 2023 10:15:52 -0800 (PST)
Received: from ap.. ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id ji11-20020a170903324b00b0019682e27995sm3010442plb.223.2023.02.10.10.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 10:15:51 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Cc:     ap420073@gmail.com, erhard_f@mailbox.org
Subject: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Date:   Fri, 10 Feb 2023 18:15:41 +0000
Message-Id: <20230210181541.2895144-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

vpbroadcastb and vpbroadcastd are not AVX instructions.
But the aria-avx assembly code contains these instructions.
So, kernel panic will occur if the aria-avx works on AVX2 unsupported
CPU.

vbroadcastss, and vpshufb are used to avoid using vpbroadcastb in it.
Unfortunately, this change reduces performance by about 5%.
Also, vpbroadcastd is simply replaced by vmovdqa in it.

Fixes: ba3579e6e45c ("crypto: aria-avx - add AES-NI/AVX/x86_64/GFNI assembler implementation of aria cipher")
Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

My CPU supports AVX2.
So, I disabled AVX2 with QEMU.
In the VM, lscpu doesn't show AVX2, but kernel panic didn't occur.
Therefore, I couldn't reproduce kernel panic.
I will really appreciate it if someone test this patch.

 arch/x86/crypto/aria-aesni-avx-asm_64.S | 134 +++++++++++++++++-------
 1 file changed, 94 insertions(+), 40 deletions(-)

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index fe0d84a7ced1..9243f6289d34 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -267,35 +267,44 @@
 
 #define aria_ark_8way(x0, x1, x2, x3,			\
 		      x4, x5, x6, x7,			\
-		      t0, rk, idx, round)		\
+		      t0, t1, t2, rk,			\
+		      idx, round)			\
 	/* AddRoundKey */                               \
-	vpbroadcastb ((round * 16) + idx + 3)(rk), t0;	\
-	vpxor t0, x0, x0;				\
-	vpbroadcastb ((round * 16) + idx + 2)(rk), t0;	\
-	vpxor t0, x1, x1;				\
-	vpbroadcastb ((round * 16) + idx + 1)(rk), t0;	\
-	vpxor t0, x2, x2;				\
-	vpbroadcastb ((round * 16) + idx + 0)(rk), t0;	\
-	vpxor t0, x3, x3;				\
-	vpbroadcastb ((round * 16) + idx + 7)(rk), t0;	\
-	vpxor t0, x4, x4;				\
-	vpbroadcastb ((round * 16) + idx + 6)(rk), t0;	\
-	vpxor t0, x5, x5;				\
-	vpbroadcastb ((round * 16) + idx + 5)(rk), t0;	\
-	vpxor t0, x6, x6;				\
-	vpbroadcastb ((round * 16) + idx + 4)(rk), t0;	\
-	vpxor t0, x7, x7;
+	vbroadcastss ((round * 16) + idx + 0)(rk), t0;	\
+	vpsrld $24, t0, t2;				\
+	vpshufb t1, t2, t2;				\
+	vpxor t2, x0, x0;				\
+	vpsrld $16, t0, t2;				\
+	vpshufb t1, t2, t2;				\
+	vpxor t2, x1, x1;				\
+	vpsrld $8, t0, t2;				\
+	vpshufb t1, t2, t2;				\
+	vpxor t2, x2, x2;				\
+	vpshufb t1, t0, t2;				\
+	vpxor t2, x3, x3;				\
+	vbroadcastss ((round * 16) + idx + 4)(rk), t0;	\
+	vpsrld $24, t0, t2;				\
+	vpshufb t1, t2, t2;				\
+	vpxor t2, x4, x4;				\
+	vpsrld $16, t0, t2;				\
+	vpshufb t1, t2, t2;				\
+	vpxor t2, x5, x5;				\
+	vpsrld $8, t0, t2;				\
+	vpshufb t1, t2, t2;				\
+	vpxor t2, x6, x6;				\
+	vpshufb t1, t0, t2;				\
+	vpxor t2, x7, x7;
 
 #ifdef CONFIG_AS_GFNI
 #define aria_sbox_8way_gfni(x0, x1, x2, x3,		\
 			    x4, x5, x6, x7,		\
 			    t0, t1, t2, t3,		\
 			    t4, t5, t6, t7)		\
-	vpbroadcastq .Ltf_s2_bitmatrix, t0;		\
-	vpbroadcastq .Ltf_inv_bitmatrix, t1;		\
-	vpbroadcastq .Ltf_id_bitmatrix, t2;		\
-	vpbroadcastq .Ltf_aff_bitmatrix, t3;		\
-	vpbroadcastq .Ltf_x2_bitmatrix, t4;		\
+	vmovdqa .Ltf_s2_bitmatrix, t0;			\
+	vmovdqa .Ltf_inv_bitmatrix, t1;			\
+	vmovdqa .Ltf_id_bitmatrix, t2;			\
+	vmovdqa .Ltf_aff_bitmatrix, t3;			\
+	vmovdqa .Ltf_x2_bitmatrix, t4;			\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
 	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
 	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
@@ -315,10 +324,9 @@
 		       x4, x5, x6, x7,			\
 		       t0, t1, t2, t3,			\
 		       t4, t5, t6, t7)			\
-	vpxor t7, t7, t7;				\
 	vmovdqa .Linv_shift_row, t0;			\
 	vmovdqa .Lshift_row, t1;			\
-	vpbroadcastd .L0f0f0f0f, t6;			\
+	vbroadcastss .L0f0f0f0f, t6;			\
 	vmovdqa .Ltf_lo__inv_aff__and__s2, t2;		\
 	vmovdqa .Ltf_hi__inv_aff__and__s2, t3;		\
 	vmovdqa .Ltf_lo__x2__and__fwd_aff, t4;		\
@@ -413,8 +421,9 @@
 		y0, y1, y2, y3,				\
 		y4, y5, y6, y7,				\
 		mem_tmp, rk, round)			\
+	vpxor y7, y7, y7;				\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, round);		\
+		      y0, y7, y2, rk, 8, round);	\
 							\
 	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 		       y0, y1, y2, y3, y4, y5, y6, y7);	\
@@ -429,7 +438,7 @@
 			     x4, x5, x6, x7,		\
 			     mem_tmp, 0);		\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, round);		\
+		      y0, y7, y2, rk, 0, round);	\
 							\
 	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 		       y0, y1, y2, y3, y4, y5, y6, y7);	\
@@ -467,8 +476,9 @@
 		y0, y1, y2, y3,				\
 		y4, y5, y6, y7,				\
 		mem_tmp, rk, round)			\
+	vpxor y7, y7, y7;				\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, round);		\
+		      y0, y7, y2, rk, 8, round);	\
 							\
 	aria_sbox_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 		       y0, y1, y2, y3, y4, y5, y6, y7);	\
@@ -483,7 +493,7 @@
 			     x4, x5, x6, x7,		\
 			     mem_tmp, 0);		\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, round);		\
+		      y0, y7, y2, rk, 0, round);	\
 							\
 	aria_sbox_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 		       y0, y1, y2, y3, y4, y5, y6, y7);	\
@@ -521,14 +531,15 @@
 		y0, y1, y2, y3,				\
 		y4, y5, y6, y7,				\
 		mem_tmp, rk, round, last_round)		\
+	vpxor y7, y7, y7;				\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, round);		\
+		      y0, y7, y2, rk, 8, round);	\
 							\
 	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 							\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, last_round);		\
+		      y0, y7, y2, rk, 8, last_round);	\
 							\
 	aria_store_state_8way(x0, x1, x2, x3,		\
 			      x4, x5, x6, x7,		\
@@ -538,13 +549,13 @@
 			     x4, x5, x6, x7,		\
 			     mem_tmp, 0);		\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, round);		\
+		      y0, y7, y2, rk, 0, round);	\
 							\
 	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 							\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, last_round);		\
+		      y0, y7, y2, rk, 0, last_round);	\
 							\
 	aria_load_state_8way(y0, y1, y2, y3,		\
 			     y4, y5, y6, y7,		\
@@ -556,8 +567,9 @@
 		     y0, y1, y2, y3,			\
 		     y4, y5, y6, y7,			\
 		     mem_tmp, rk, round)		\
+	vpxor y7, y7, y7;				\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, round);		\
+		      y0, y7, y2, rk, 8, round);	\
 							\
 	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 			    x6, x7, x4, x5,		\
@@ -574,7 +586,7 @@
 			     x4, x5, x6, x7,		\
 			     mem_tmp, 0);		\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, round);		\
+		      y0, y7, y2, rk, 0, round);	\
 							\
 	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 			    x6, x7, x4, x5,		\
@@ -614,8 +626,9 @@
 		     y0, y1, y2, y3,			\
 		     y4, y5, y6, y7,			\
 		     mem_tmp, rk, round)		\
+	vpxor y7, y7, y7;				\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, round);		\
+		      y0, y7, y2, rk, 8, round);	\
 							\
 	aria_sbox_8way_gfni(x0, x1, x2, x3, 		\
 			    x4, x5, x6, x7,		\
@@ -632,7 +645,7 @@
 			     x4, x5, x6, x7,		\
 			     mem_tmp, 0);		\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, round);		\
+		      y0, y7, y2, rk, 0, round);	\
 							\
 	aria_sbox_8way_gfni(x0, x1, x2, x3, 		\
 			    x4, x5, x6, x7,		\
@@ -672,8 +685,9 @@
 		y0, y1, y2, y3,				\
 		y4, y5, y6, y7,				\
 		mem_tmp, rk, round, last_round)		\
+	vpxor y7, y7, y7;				\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, round);		\
+		      y0, y7, y2, rk, 8, round);	\
 							\
 	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 			    x6, x7, x4, x5,		\
@@ -681,7 +695,7 @@
 			    y4, y5, y6, y7);		\
 							\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 8, last_round);		\
+		      y0, y7, y2, rk, 8, last_round);	\
 							\
 	aria_store_state_8way(x0, x1, x2, x3,		\
 			      x4, x5, x6, x7,		\
@@ -691,7 +705,7 @@
 			     x4, x5, x6, x7,		\
 			     mem_tmp, 0);		\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, round);		\
+		      y0, y7, y2, rk, 0, round);	\
 							\
 	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 			    x6, x7, x4, x5,		\
@@ -699,7 +713,7 @@
 			    y4, y5, y6, y7);		\
 							\
 	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
-		      y0, rk, 0, last_round);		\
+		      y0, y7, y2, rk, 0, last_round);	\
 							\
 	aria_load_state_8way(y0, y1, y2, y3,		\
 			     y4, y5, y6, y7,		\
@@ -772,6 +786,14 @@
 		    BV8(0, 1, 1, 1, 1, 1, 0, 0),
 		    BV8(0, 0, 1, 1, 1, 1, 1, 0),
 		    BV8(0, 0, 0, 1, 1, 1, 1, 1))
+	.quad BM8X8(BV8(1, 0, 0, 0, 1, 1, 1, 1),
+		    BV8(1, 1, 0, 0, 0, 1, 1, 1),
+		    BV8(1, 1, 1, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 1, 1, 0, 0, 0, 1),
+		    BV8(1, 1, 1, 1, 1, 0, 0, 0),
+		    BV8(0, 1, 1, 1, 1, 1, 0, 0),
+		    BV8(0, 0, 1, 1, 1, 1, 1, 0),
+		    BV8(0, 0, 0, 1, 1, 1, 1, 1))
 
 /* AES inverse affine: */
 #define tf_inv_const BV8(1, 0, 1, 0, 0, 0, 0, 0)
@@ -784,6 +806,14 @@
 		    BV8(0, 0, 1, 0, 1, 0, 0, 1),
 		    BV8(1, 0, 0, 1, 0, 1, 0, 0),
 		    BV8(0, 1, 0, 0, 1, 0, 1, 0))
+	.quad BM8X8(BV8(0, 0, 1, 0, 0, 1, 0, 1),
+		    BV8(1, 0, 0, 1, 0, 0, 1, 0),
+		    BV8(0, 1, 0, 0, 1, 0, 0, 1),
+		    BV8(1, 0, 1, 0, 0, 1, 0, 0),
+		    BV8(0, 1, 0, 1, 0, 0, 1, 0),
+		    BV8(0, 0, 1, 0, 1, 0, 0, 1),
+		    BV8(1, 0, 0, 1, 0, 1, 0, 0),
+		    BV8(0, 1, 0, 0, 1, 0, 1, 0))
 
 /* S2: */
 #define tf_s2_const BV8(0, 1, 0, 0, 0, 1, 1, 1)
@@ -796,6 +826,14 @@
 		    BV8(1, 1, 0, 0, 1, 1, 1, 0),
 		    BV8(0, 1, 1, 0, 0, 0, 1, 1),
 		    BV8(1, 1, 1, 1, 0, 1, 1, 0))
+	.quad BM8X8(BV8(0, 1, 0, 1, 0, 1, 1, 1),
+		    BV8(0, 0, 1, 1, 1, 1, 1, 1),
+		    BV8(1, 1, 1, 0, 1, 1, 0, 1),
+		    BV8(1, 1, 0, 0, 0, 0, 1, 1),
+		    BV8(0, 1, 0, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 0, 0, 1, 1, 1, 0),
+		    BV8(0, 1, 1, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 1, 1, 0, 1, 1, 0))
 
 /* X2: */
 #define tf_x2_const BV8(0, 0, 1, 1, 0, 1, 0, 0)
@@ -808,6 +846,14 @@
 		    BV8(0, 1, 1, 0, 1, 0, 1, 1),
 		    BV8(1, 0, 1, 1, 1, 1, 0, 1),
 		    BV8(1, 0, 0, 1, 0, 0, 1, 1))
+	.quad BM8X8(BV8(0, 0, 0, 1, 1, 0, 0, 0),
+		    BV8(0, 0, 1, 0, 0, 1, 1, 0),
+		    BV8(0, 0, 0, 0, 1, 0, 1, 0),
+		    BV8(1, 1, 1, 0, 0, 0, 1, 1),
+		    BV8(1, 1, 1, 0, 1, 1, 0, 0),
+		    BV8(0, 1, 1, 0, 1, 0, 1, 1),
+		    BV8(1, 0, 1, 1, 1, 1, 0, 1),
+		    BV8(1, 0, 0, 1, 0, 0, 1, 1))
 
 /* Identity matrix: */
 .Ltf_id_bitmatrix:
@@ -819,6 +865,14 @@
 		    BV8(0, 0, 0, 0, 0, 1, 0, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
 		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
+	.quad BM8X8(BV8(1, 0, 0, 0, 0, 0, 0, 0),
+		    BV8(0, 1, 0, 0, 0, 0, 0, 0),
+		    BV8(0, 0, 1, 0, 0, 0, 0, 0),
+		    BV8(0, 0, 0, 1, 0, 0, 0, 0),
+		    BV8(0, 0, 0, 0, 1, 0, 0, 0),
+		    BV8(0, 0, 0, 0, 0, 1, 0, 0),
+		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
+		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
 #endif /* CONFIG_AS_GFNI */
 
 /* 4-bit mask */
-- 
2.34.1

