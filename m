Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDACDC636CC
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Feb 2023 19:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjBKTJq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Feb 2023 14:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBKTJo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Feb 2023 14:09:44 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AEA138
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2023 11:09:43 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d8so8641659plr.10
        for <linux-crypto@vger.kernel.org>; Sat, 11 Feb 2023 11:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R3dyCmBTvYfMxYq89TafHnhB0U3eSob4XWUodE6XlKA=;
        b=IVIsT0kDIbXAGcSeNj3uEphm0Z+xl3Bg6sftUoG/Vrju74pPwFGShj3cZO3NydxgVn
         TekSk7TbEB8PCowzi1gUovsEM/5dPW1o27r6SwJul4C963wGm4gpyypokKRm6bCfZmL5
         MZhiKHsjlztNlWke/yxM5l9C/+UPgqSWIbxR/F3TgTpFqge280CTbvG7ck3AUulJY+8W
         1I8uG2vyB50atNBYHoiozomj5Rm52OPMM4sSybI8Z46DYblQEoJz67eU3naZ4HQ5xoEl
         1lh6IrY3aeU1zpZC/6VlYVvrTYl1TXWvPnRVY1AmbfOJM0AMqWndBvspdTlgyksP0HRD
         LSHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R3dyCmBTvYfMxYq89TafHnhB0U3eSob4XWUodE6XlKA=;
        b=KhpFCt/D1JCf3XONcjvg6KbKNLW4ej+w9oTSdtYlzDO5mubn8HMyzEgmfC1EjFLjs7
         ZgXCxoUSz8FG0o/zsqPG8qqyo2j4+oHwReeATEbfEqdT/Gt8LMo454g6kEaeWuwKohIv
         +b3DZN2dKn9n3I6t9NXDqFKtEPN0l3vccc9QpUMUsi4HJSvpJTr/0EQ1uRLKY9bN8/3p
         5PonPm+t3QifAS40baZiPQ30dvQpa2Jn6k9CB+BcoCwrQ5t9k1eT0dRx2HOqwYr4vAI/
         +KWcoKWLaSEtaQ/hJlntgQq5oF4tQDQjCM2dF1E5NW7DTo7MsXpjvyG/urxhKWBQh4t+
         kR8A==
X-Gm-Message-State: AO0yUKUXikdX42IZBP1KwEIO6P8ZAxvbSD4U1CRnRcBFtW9qNOQddjyc
        vg8cRMhyZjF6H2OlU7id6uo=
X-Google-Smtp-Source: AK7set93enYo/03UoTr+n660rDL2Ug0DN+9ZpdHFbTUd4/929xLI/IXSzBZLwPywLInMD4HiQJIEAg==
X-Received: by 2002:a17:90b:3904:b0:22c:b2bf:e462 with SMTP id ob4-20020a17090b390400b0022cb2bfe462mr21831085pjb.34.1676142581823;
        Sat, 11 Feb 2023 11:09:41 -0800 (PST)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id p9-20020a17090a2d8900b00233bab35b57sm2171537pjd.29.2023.02.11.11.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 11:09:41 -0800 (PST)
Message-ID: <e4df2d68-6106-0c42-e61a-65fff0292a9d@gmail.com>
Date:   Sun, 12 Feb 2023 04:09:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] crypto: x86/aria-avx - fix using avx2 instructions
Content-Language: en-US
To:     "Erhard F." <erhard_f@mailbox.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, x86@kernel.org
References: <20230210181541.2895144-1-ap420073@gmail.com>
 <20230211004855.52a8380c@yea>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20230211004855.52a8380c@yea>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/11/23 08:48, Erhard F. wrote:

Hi Erhard,
Thank you so much for the testing!

 > On Fri, 10 Feb 2023 18:15:41 +0000
 > Taehee Yoo <ap420073@gmail.com> wrote:
 >
 >> vpbroadcastb and vpbroadcastd are not AVX instructions.
 >> But the aria-avx assembly code contains these instructions.
 >> So, kernel panic will occur if the aria-avx works on AVX2 unsupported
 >> CPU.
 >>
 >> vbroadcastss, and vpshufb are used to avoid using vpbroadcastb in it.
 >> Unfortunately, this change reduces performance by about 5%.
 >> Also, vpbroadcastd is simply replaced by vmovdqa in it.
 >
 > Thanks Taehee, your patch fixes the issue on my AMD FX-8370!

Nice :)

 >
 > # cryptsetup benchmark -c aria-ctr-plain64
 > # Tests are approximate using memory only (no storage IO).
 > # Algorithm |       Key |      Encryption |      Decryption
 >     aria-ctr        256b       301.3 MiB/s       303.6 MiB/s

Thanks for this benchmark!

 >
 > The patch did not apply cleanly on v6.2-rc7 however. I needed to do 
small trivial modifications on hunk #1 and #21. Perhaps this is useful 
for other users to test so i'll attach it.

Thanks for this :)

 >
 > Regards,
 > Erhard
 >
 > diff --git a/arch/x86/crypto/aria-aesni-avx-asm_64.S 
b/arch/x86/crypto/aria-aesni-avx-asm_64.S
 > index fe0d84a7ced1..9243f6289d34 100644
 > --- a/arch/x86/crypto/aria-aesni-avx-asm_64.S
 > +++ b/arch/x86/crypto/aria-aesni-avx-asm_64.S
 > @@ -271,34 +271,43 @@
 >
 >   #define aria_ark_8way(x0, x1, x2, x3,			\
 >   		      x4, x5, x6, x7,			\
 > -		      t0, rk, idx, round)		\
 > +		      t0, t1, t2, rk,			\
 > +		      idx, round)			\
 >   	/* AddRoundKey */                               \
 > -	vpbroadcastb ((round * 16) + idx + 3)(rk), t0;	\
 > -	vpxor t0, x0, x0;				\
 > -	vpbroadcastb ((round * 16) + idx + 2)(rk), t0;	\
 > -	vpxor t0, x1, x1;				\
 > -	vpbroadcastb ((round * 16) + idx + 1)(rk), t0;	\
 > -	vpxor t0, x2, x2;				\
 > -	vpbroadcastb ((round * 16) + idx + 0)(rk), t0;	\
 > -	vpxor t0, x3, x3;				\
 > -	vpbroadcastb ((round * 16) + idx + 7)(rk), t0;	\
 > -	vpxor t0, x4, x4;				\
 > -	vpbroadcastb ((round * 16) + idx + 6)(rk), t0;	\
 > -	vpxor t0, x5, x5;				\
 > -	vpbroadcastb ((round * 16) + idx + 5)(rk), t0;	\
 > -	vpxor t0, x6, x6;				\
 > -	vpbroadcastb ((round * 16) + idx + 4)(rk), t0;	\
 > -	vpxor t0, x7, x7;
 > +	vbroadcastss ((round * 16) + idx + 0)(rk), t0;	\
 > +	vpsrld $24, t0, t2;				\
 > +	vpshufb t1, t2, t2;				\
 > +	vpxor t2, x0, x0;				\
 > +	vpsrld $16, t0, t2;				\
 > +	vpshufb t1, t2, t2;				\
 > +	vpxor t2, x1, x1;				\
 > +	vpsrld $8, t0, t2;				\
 > +	vpshufb t1, t2, t2;				\
 > +	vpxor t2, x2, x2;				\
 > +	vpshufb t1, t0, t2;				\
 > +	vpxor t2, x3, x3;				\
 > +	vbroadcastss ((round * 16) + idx + 4)(rk), t0;	\
 > +	vpsrld $24, t0, t2;				\
 > +	vpshufb t1, t2, t2;				\
 > +	vpxor t2, x4, x4;				\
 > +	vpsrld $16, t0, t2;				\
 > +	vpshufb t1, t2, t2;				\
 > +	vpxor t2, x5, x5;				\
 > +	vpsrld $8, t0, t2;				\
 > +	vpshufb t1, t2, t2;				\
 > +	vpxor t2, x6, x6;				\
 > +	vpshufb t1, t0, t2;				\
 > +	vpxor t2, x7, x7;
 >
 >   #define aria_sbox_8way_gfni(x0, x1, x2, x3,		\
 >   			    x4, x5, x6, x7,		\
 >   			    t0, t1, t2, t3,		\
 >   			    t4, t5, t6, t7)		\
 > -	vpbroadcastq .Ltf_s2_bitmatrix, t0;		\
 > -	vpbroadcastq .Ltf_inv_bitmatrix, t1;		\
 > -	vpbroadcastq .Ltf_id_bitmatrix, t2;		\
 > -	vpbroadcastq .Ltf_aff_bitmatrix, t3;		\
 > -	vpbroadcastq .Ltf_x2_bitmatrix, t4;		\
 > +	vmovdqa .Ltf_s2_bitmatrix, t0;			\
 > +	vmovdqa .Ltf_inv_bitmatrix, t1;			\
 > +	vmovdqa .Ltf_id_bitmatrix, t2;			\
 > +	vmovdqa .Ltf_aff_bitmatrix, t3;			\
 > +	vmovdqa .Ltf_x2_bitmatrix, t4;			\
 >   	vgf2p8affineinvqb $(tf_s2_const), t0, x1, x1;	\
 >   	vgf2p8affineinvqb $(tf_s2_const), t0, x5, x5;	\
 >   	vgf2p8affineqb $(tf_inv_const), t1, x2, x2;	\
 > @@ -315,10 +324,9 @@
 >   		       x4, x5, x6, x7,			\
 >   		       t0, t1, t2, t3,			\
 >   		       t4, t5, t6, t7)			\
 > -	vpxor t7, t7, t7;				\
 >   	vmovdqa .Linv_shift_row, t0;			\
 >   	vmovdqa .Lshift_row, t1;			\
 > -	vpbroadcastd .L0f0f0f0f, t6;			\
 > +	vbroadcastss .L0f0f0f0f, t6;			\
 >   	vmovdqa .Ltf_lo__inv_aff__and__s2, t2;		\
 >   	vmovdqa .Ltf_hi__inv_aff__and__s2, t3;		\
 >   	vmovdqa .Ltf_lo__x2__and__fwd_aff, t4;		\
 > @@ -413,8 +421,9 @@
 >   		y0, y1, y2, y3,				\
 >   		y4, y5, y6, y7,				\
 >   		mem_tmp, rk, round)			\
 > +	vpxor y7, y7, y7;				\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, round);		\
 > +		      y0, y7, y2, rk, 8, round);	\
 >   							\
 >   	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 >   		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 > @@ -429,7 +438,7 @@
 >   			     x4, x5, x6, x7,		\
 >   			     mem_tmp, 0);		\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, round);		\
 > +		      y0, y7, y2, rk, 0, round);	\
 >   							\
 >   	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 >   		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 > @@ -467,8 +476,9 @@
 >   		y0, y1, y2, y3,				\
 >   		y4, y5, y6, y7,				\
 >   		mem_tmp, rk, round)			\
 > +	vpxor y7, y7, y7;				\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, round);		\
 > +		      y0, y7, y2, rk, 8, round);	\
 >   							\
 >   	aria_sbox_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 >   		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 > @@ -483,7 +493,7 @@
 >   			     x4, x5, x6, x7,		\
 >   			     mem_tmp, 0);		\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, round);		\
 > +		      y0, y7, y2, rk, 0, round);	\
 >   							\
 >   	aria_sbox_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 >   		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 > @@ -521,14 +531,15 @@
 >   		y0, y1, y2, y3,				\
 >   		y4, y5, y6, y7,				\
 >   		mem_tmp, rk, round, last_round)		\
 > +	vpxor y7, y7, y7;				\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, round);		\
 > +		      y0, y7, y2, rk, 8, round);	\
 >   							\
 >   	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 >   		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 >   							\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, last_round);		\
 > +		      y0, y7, y2, rk, 8, last_round);	\
 >   							\
 >   	aria_store_state_8way(x0, x1, x2, x3,		\
 >   			      x4, x5, x6, x7,		\
 > @@ -538,13 +549,13 @@
 >   			     x4, x5, x6, x7,		\
 >   			     mem_tmp, 0);		\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, round);		\
 > +		      y0, y7, y2, rk, 0, round);	\
 >   							\
 >   	aria_sbox_8way(x2, x3, x0, x1, x6, x7, x4, x5,	\
 >   		       y0, y1, y2, y3, y4, y5, y6, y7);	\
 >   							\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, last_round);		\
 > +		      y0, y7, y2, rk, 0, last_round);	\
 >   							\
 >   	aria_load_state_8way(y0, y1, y2, y3,		\
 >   			     y4, y5, y6, y7,		\
 > @@ -556,8 +567,9 @@
 >   		     y0, y1, y2, y3,			\
 >   		     y4, y5, y6, y7,			\
 >   		     mem_tmp, rk, round)		\
 > +	vpxor y7, y7, y7;				\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, round);		\
 > +		      y0, y7, y2, rk, 8, round);	\
 >   							\
 >   	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 >   			    x6, x7, x4, x5,		\
 > @@ -574,7 +586,7 @@
 >   			     x4, x5, x6, x7,		\
 >   			     mem_tmp, 0);		\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, round);		\
 > +		      y0, y7, y2, rk, 0, round);	\
 >   							\
 >   	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 >   			    x6, x7, x4, x5,		\
 > @@ -614,8 +626,9 @@
 >   		     y0, y1, y2, y3,			\
 >   		     y4, y5, y6, y7,			\
 >   		     mem_tmp, rk, round)		\
 > +	vpxor y7, y7, y7;				\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, round);		\
 > +		      y0, y7, y2, rk, 8, round);	\
 >   							\
 >   	aria_sbox_8way_gfni(x0, x1, x2, x3, 		\
 >   			    x4, x5, x6, x7,		\
 > @@ -632,7 +645,7 @@
 >   			     x4, x5, x6, x7,		\
 >   			     mem_tmp, 0);		\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, round);		\
 > +		      y0, y7, y2, rk, 0, round);	\
 >   							\
 >   	aria_sbox_8way_gfni(x0, x1, x2, x3, 		\
 >   			    x4, x5, x6, x7,		\
 > @@ -672,8 +685,9 @@
 >   		y0, y1, y2, y3,				\
 >   		y4, y5, y6, y7,				\
 >   		mem_tmp, rk, round, last_round)		\
 > +	vpxor y7, y7, y7;				\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, round);		\
 > +		      y0, y7, y2, rk, 8, round);	\
 >   							\
 >   	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 >   			    x6, x7, x4, x5,		\
 > @@ -681,7 +695,7 @@
 >   			    y4, y5, y6, y7);		\
 >   							\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 8, last_round);		\
 > +		      y0, y7, y2, rk, 8, last_round);	\
 >   							\
 >   	aria_store_state_8way(x0, x1, x2, x3,		\
 >   			      x4, x5, x6, x7,		\
 > @@ -691,7 +705,7 @@
 >   			     x4, x5, x6, x7,		\
 >   			     mem_tmp, 0);		\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, round);		\
 > +		      y0, y7, y2, rk, 0, round);	\
 >   							\
 >   	aria_sbox_8way_gfni(x2, x3, x0, x1, 		\
 >   			    x6, x7, x4, x5,		\
 > @@ -699,7 +713,7 @@
 >   			    y4, y5, y6, y7);		\
 >   							\
 >   	aria_ark_8way(x0, x1, x2, x3, x4, x5, x6, x7,	\
 > -		      y0, rk, 0, last_round);		\
 > +		      y0, y7, y2, rk, 0, last_round);	\
 >   							\
 >   	aria_load_state_8way(y0, y1, y2, y3,		\
 >   			     y4, y5, y6, y7,		\
 > @@ -772,6 +786,14 @@
 >   		    BV8(0, 1, 1, 1, 1, 1, 0, 0),
 >   		    BV8(0, 0, 1, 1, 1, 1, 1, 0),
 >   		    BV8(0, 0, 0, 1, 1, 1, 1, 1))
 > +	.quad BM8X8(BV8(1, 0, 0, 0, 1, 1, 1, 1),
 > +		    BV8(1, 1, 0, 0, 0, 1, 1, 1),
 > +		    BV8(1, 1, 1, 0, 0, 0, 1, 1),
 > +		    BV8(1, 1, 1, 1, 0, 0, 0, 1),
 > +		    BV8(1, 1, 1, 1, 1, 0, 0, 0),
 > +		    BV8(0, 1, 1, 1, 1, 1, 0, 0),
 > +		    BV8(0, 0, 1, 1, 1, 1, 1, 0),
 > +		    BV8(0, 0, 0, 1, 1, 1, 1, 1))
 >
 >   /* AES inverse affine: */
 >   #define tf_inv_const BV8(1, 0, 1, 0, 0, 0, 0, 0)
 > @@ -784,6 +806,14 @@
 >   		    BV8(0, 0, 1, 0, 1, 0, 0, 1),
 >   		    BV8(1, 0, 0, 1, 0, 1, 0, 0),
 >   		    BV8(0, 1, 0, 0, 1, 0, 1, 0))
 > +	.quad BM8X8(BV8(0, 0, 1, 0, 0, 1, 0, 1),
 > +		    BV8(1, 0, 0, 1, 0, 0, 1, 0),
 > +		    BV8(0, 1, 0, 0, 1, 0, 0, 1),
 > +		    BV8(1, 0, 1, 0, 0, 1, 0, 0),
 > +		    BV8(0, 1, 0, 1, 0, 0, 1, 0),
 > +		    BV8(0, 0, 1, 0, 1, 0, 0, 1),
 > +		    BV8(1, 0, 0, 1, 0, 1, 0, 0),
 > +		    BV8(0, 1, 0, 0, 1, 0, 1, 0))
 >
 >   /* S2: */
 >   #define tf_s2_const BV8(0, 1, 0, 0, 0, 1, 1, 1)
 > @@ -796,6 +826,14 @@
 >   		    BV8(1, 1, 0, 0, 1, 1, 1, 0),
 >   		    BV8(0, 1, 1, 0, 0, 0, 1, 1),
 >   		    BV8(1, 1, 1, 1, 0, 1, 1, 0))
 > +	.quad BM8X8(BV8(0, 1, 0, 1, 0, 1, 1, 1),
 > +		    BV8(0, 0, 1, 1, 1, 1, 1, 1),
 > +		    BV8(1, 1, 1, 0, 1, 1, 0, 1),
 > +		    BV8(1, 1, 0, 0, 0, 0, 1, 1),
 > +		    BV8(0, 1, 0, 0, 0, 0, 1, 1),
 > +		    BV8(1, 1, 0, 0, 1, 1, 1, 0),
 > +		    BV8(0, 1, 1, 0, 0, 0, 1, 1),
 > +		    BV8(1, 1, 1, 1, 0, 1, 1, 0))
 >
 >   /* X2: */
 >   #define tf_x2_const BV8(0, 0, 1, 1, 0, 1, 0, 0)
 > @@ -808,6 +846,14 @@
 >   		    BV8(0, 1, 1, 0, 1, 0, 1, 1),
 >   		    BV8(1, 0, 1, 1, 1, 1, 0, 1),
 >   		    BV8(1, 0, 0, 1, 0, 0, 1, 1))
 > +	.quad BM8X8(BV8(0, 0, 0, 1, 1, 0, 0, 0),
 > +		    BV8(0, 0, 1, 0, 0, 1, 1, 0),
 > +		    BV8(0, 0, 0, 0, 1, 0, 1, 0),
 > +		    BV8(1, 1, 1, 0, 0, 0, 1, 1),
 > +		    BV8(1, 1, 1, 0, 1, 1, 0, 0),
 > +		    BV8(0, 1, 1, 0, 1, 0, 1, 1),
 > +		    BV8(1, 0, 1, 1, 1, 1, 0, 1),
 > +		    BV8(1, 0, 0, 1, 0, 0, 1, 1))
 >
 >   /* Identity matrix: */
 >   .Ltf_id_bitmatrix:
 > @@ -862,6 +862,14 @@
 >   		    BV8(0, 0, 0, 0, 0, 1, 0, 0),
 >   		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
 >   		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
 > +	.quad BM8X8(BV8(1, 0, 0, 0, 0, 0, 0, 0),
 > +		    BV8(0, 1, 0, 0, 0, 0, 0, 0),
 > +		    BV8(0, 0, 1, 0, 0, 0, 0, 0),
 > +		    BV8(0, 0, 0, 1, 0, 0, 0, 0),
 > +		    BV8(0, 0, 0, 0, 1, 0, 0, 0),
 > +		    BV8(0, 0, 0, 0, 0, 1, 0, 0),
 > +		    BV8(0, 0, 0, 0, 0, 0, 1, 0),
 > +		    BV8(0, 0, 0, 0, 0, 0, 0, 1))
 >
 >   /* 4-bit mask */
 >   .section	.rodata.cst4.L0f0f0f0f, "aM", @progbits, 4

Thank you so much,
Taehee Yoo
