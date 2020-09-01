Return-Path: <SRS0=65YJ=CK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2844C433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 19:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 816AA2087D
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Sep 2020 19:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GMxaySSd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgIATQW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Sep 2020 15:16:22 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36479 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgIATQV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Sep 2020 15:16:21 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 7eb4ff33;
        Tue, 1 Sep 2020 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=IuL+XOYUz+FWG8y0kVOuo+1PvnI=; b=GMxaySS
        dtU6lqHOO0vWcE+HPdyyF8bds7IaT2zp/CWF+aQxI/28B5ZULM1Q81jJTb2EpLSe
        gO9SUkUUKKF+1vvS9txF3KEbQ5n1KBiE2eL18Th8rxGIN3fe/phMqN2IOixjN+pp
        ibDpJn2wTpAKyhDCBwpuTDkrqPdHWPZqQOnc5aW/IoWGRA6m/9MKrYuRL5h51FRA
        v8Y9GA5+SNkmUXX++pcCHEntet1dp1Lie7lLt2zEvNnn+UnPru3mOmjY5UidbrLO
        /3PWzE6u/7wi8aoa7kICFv1e16rMjQQ9LqCKQz4RTS+QTR/wXEjHeosE1hEtzUQa
        iUhp6ACKlkvsprA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4cc14368 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 1 Sep 2020 18:48:17 +0000 (UTC)
Date:   Tue, 1 Sep 2020 21:16:11 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Uros Bizjak <ubizjak@gmail.com>,
        Andy Polyakov <appro@cryptogams.org>
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in
 poly1305-x86_64-cryptogams.pl
Message-ID: <20200901191611.GA869399@zx2c4.com>
References: <20200827173831.95039-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200827173831.95039-1-ubizjak@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Uros,

Any benchmarks for this? Seems like it's all in initialization code,
right? I'm CC'ing Andy into this.

Jason

On Thu, Aug 27, 2020 at 07:38:31PM +0200, Uros Bizjak wrote:
> x86_64 zero extends 32bit operations, so for 64bit operands,
> XORL r32,r32 is functionally equal to XORQ r64,r64, but avoids
> a REX prefix byte when legacy registers are used.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> ---
>  arch/x86/crypto/poly1305-x86_64-cryptogams.pl | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
> index 137edcf038cb..7d568012cc15 100644
> --- a/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
> +++ b/arch/x86/crypto/poly1305-x86_64-cryptogams.pl
> @@ -246,7 +246,7 @@ $code.=<<___ if (!$kernel);
>  ___
>  &declare_function("poly1305_init_x86_64", 32, 3);
>  $code.=<<___;
> -	xor	%rax,%rax
> +	xor	%eax,%eax
>  	mov	%rax,0($ctx)		# initialize hash value
>  	mov	%rax,8($ctx)
>  	mov	%rax,16($ctx)
> @@ -2853,7 +2853,7 @@ $code.=<<___;
>  .type	poly1305_init_base2_44,\@function,3
>  .align	32
>  poly1305_init_base2_44:
> -	xor	%rax,%rax
> +	xor	%eax,%eax
>  	mov	%rax,0($ctx)		# initialize hash value
>  	mov	%rax,8($ctx)
>  	mov	%rax,16($ctx)
> @@ -3947,7 +3947,7 @@ xor128_decrypt_n_pad:
>  	mov	\$16,$len
>  	sub	%r10,$len
>  	xor	%eax,%eax
> -	xor	%r11,%r11
> +	xor	%r11d,%r11d
>  .Loop_dec_byte:
>  	mov	($inp,$otp),%r11b
>  	mov	($otp),%al
> @@ -4085,7 +4085,7 @@ avx_handler:
>  	.long	0xa548f3fc		# cld; rep movsq
>  
>  	mov	$disp,%rsi
> -	xor	%rcx,%rcx		# arg1, UNW_FLAG_NHANDLER
> +	xor	%ecx,%ecx		# arg1, UNW_FLAG_NHANDLER
>  	mov	8(%rsi),%rdx		# arg2, disp->ImageBase
>  	mov	0(%rsi),%r8		# arg3, disp->ControlPc
>  	mov	16(%rsi),%r9		# arg4, disp->FunctionEntry
> -- 
> 2.26.2
> 

-- 
Jason A. Donenfeld
Deep Space Explorer
fr: +33 6 51 90 82 66
us: +1 513 476 1200
www.jasondonenfeld.com
www.zx2c4.com
zx2c4.com/keys/AB9942E6D4A4CFC3412620A749FC7012A5DE03AE.asc
