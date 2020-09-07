Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278EEC433E2
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 17:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C02962080A
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 17:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZLvaVIWK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbgIGRqG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:46:06 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:49281 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729446AbgIGNRi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 09:17:38 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 511a2b1e;
        Mon, 7 Sep 2020 12:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
        :cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=mail; bh=W4gXInNmSu0I9yniK7J+bIBfYz4=; b=ZLvaVIW
        KiTnPaiyDcZUmImWX/0VrKn4+G2xV67W2A0MPv4zTgE8BZtit79s5JrL9kIGQa66
        GOjOk8C1rzAo51Jc9OiYmKjD1w+n1KfmcYA+IonvGMsSo4ds6rTGd3xxq3ISItX6
        FeWQ3XrDDc4pUYgPE034j3AiuK4zsq6jsQ5NzC12Or6xYQkwA3Q0J8FljXLMSx2o
        uLUwpeetzZ6Nu/f9IKXOhIQdOkKblJnYsOX58VwkDNBUeR5dOtvkhuhnrDAMXpPQ
        bUGi9XPs8itpy2EcVZMZFneW99yHoAOK9nQkluKdH3DmW1hkoWlKJMP7fdA1OLyb
        H/hcNXkgKtSiv2A==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3574d307 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 7 Sep 2020 12:47:19 +0000 (UTC)
Date:   Mon, 7 Sep 2020 15:16:03 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Uros Bizjak <ubizjak@gmail.com>, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto/x86: Use XORL r32,32 in
 poly1305-x86_64-cryptogams.pl
Message-ID: <20200907131603.GB52901@zx2c4.com>
References: <20200827173831.95039-1-ubizjak@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200827173831.95039-1-ubizjak@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Uros, Herbert,

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

Per the discussion elsewhere,

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

for cryptodev-2.6.git, rather than crypto-2.6.git

Thanks,
Jason
