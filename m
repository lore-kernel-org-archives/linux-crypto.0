Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56BAC636D4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 23:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBJXtG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 18:49:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBJXtG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 18:49:06 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C95511E93
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 15:49:03 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4PD9Rt6g7Jz9sYd;
        Sat, 11 Feb 2023 00:48:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1676072938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=47jNWr1JdAc0yNzMDj9l5Gi9JnlTOZC7wAqROptU+nM=;
        b=QwDhrBeGxlQD6Pij31ci5A6MCSEuZL82mJLosV8S8BvIbXmDg/C/E7Xm4zEoQ6Uf9Z+jgR
        SszrZBFmzwRJLTU8C2uudfPZ+9/8tceVJKJlPotfqTTXfENlr0aVxGfo98SPidc0InNdy0
        UNBxe0irxpNL11Zv+ZkMOGDFYzARvUtuzxEkiS26EW9WoWf3azGtt9Erdsg535+LgIdb+4
        PSz98M1ZBWxXkeq4TRUo1sEX085eFaraOU5nX8sPRWoNg9jvFHdqJb2yM3LNTXuhZzMSDj
        l8f/eqbupLqE6yykM61g0ZoIEf01A1iOQ9aMm1YJzTSk8bYjMeBmmOKPjB+7dQ==
Date:   Sat, 11 Feb 2023 00:48:55 +0100
From:   "Erhard F." <erhard_f@mailbox.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
Subject: Re: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Message-ID: <20230211004855.52a8380c@yea>
In-Reply-To: <20230210181541.2895144-1-ap420073@gmail.com>
References: <20230210181541.2895144-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-RS-ID: 34887e700ddd964495e
X-MBO-RS-META: xz5jtfj4gakzehb5334qtoq4c3cpczzu
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 10 Feb 2023 18:15:41 +0000
Taehee Yoo <ap420073@gmail.com> wrote:

> vpbroadcastb and vpbroadcastd are not AVX instructions.
> But the aria-avx assembly code contains these instructions.
> So, kernel panic will occur if the aria-avx works on AVX2 unsupported
> CPU.
> 
> vbroadcastss, and vpshufb are used to avoid using vpbroadcastb in it.
> Unfortunately, this change reduces performance by about 5%.
> Also, vpbroadcastd is simply replaced by vmovdqa in it.

Thanks Taehee, your patch fixes the issue on my AMD FX-8370!

# cryptsetup benchmark -c aria-ctr-plain64
# Tests are approximate using memory only (no storage IO).
# Algorithm |       Key |      Encryption |      Decryption
   aria-ctr        256b       301.3 MiB/s       303.6 MiB/s

The patch did not apply cleanly on v6.2-rc7 however. I needed to do small trivial modifications on hunk #1 and #21. Perhaps this is useful for other users to test so i'll attach it.

Regards,
Erhard

diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S b/arch/x86/crypto/aria-aesni-avx-asm_64.S
index fe0d84a7ced1..9243f6289d34 100644
--- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
+++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
@@ -271,34 +271,43 @@
 
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
@@ -862,6 +862,14 @@
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
 
 /* 4-bit mask */
 .section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4
-- 
2.34.1
