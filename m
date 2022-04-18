Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC13BC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 23:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbiDRXrH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 19:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbiDRXrG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 19:47:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D7B1BEBD
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 16:44:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1BE261269
        for <linux-crypto@vger.kernel.org>; Mon, 18 Apr 2022 23:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FF2C385A7;
        Mon, 18 Apr 2022 23:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650325465;
        bh=iYBJn49zqBQzPWYiNRTt8PA6tBTUPYfQbLPnh2SubZU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jvYSrcHT38rD8JU7fCnaeHIETnfJHb8pTe+bHzj3MO71TfR4/nHzoQnbWZD+95ReD
         pwnMIXwKUJTfbojKaDBdZzkb0Ewdxm3llOkRLvwssULPnCGL4+DUW0bhhsfhOtesRH
         s7vqmTfxLjv9lb1byIhdZ2tEiKtFCwp7EtrhlsC/mjBDuiiMge6oDpchoIW4qMoq9B
         zQnooZN8DEUcJgOIneY3voB7eHWKkc5fsJTYautsb+cc9BMcNtb4+gPC0C2Q+Qzmuu
         +JPcDSx0a26tNwD+Mk9jA4GGhFIrkdmOaProYoglKcKOi5+zrfRRct84cie2RHEJBs
         3OxxrDstVLIJA==
Date:   Mon, 18 Apr 2022 16:44:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 4/8] crypto: x86/aesni-xctr: Add accelerated
 implementation of XCTR
Message-ID: <Yl3319lf33hgZniP@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-5-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-5-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 12, 2022 at 05:28:12PM +0000, Nathan Huckleberry wrote:
> diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> index 43852ba6e19c..9e20d7d3d6da 100644
> --- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> +++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
> @@ -53,6 +53,10 @@
>  #define KEY_192		2
>  #define KEY_256		3
>  
> +// XCTR mode only
> +#define counter		%r9
> +#define xiv		%xmm8
> +

It would be helpful if the registers were listed in order, and if the
CTR-specific ones were marked as being specific to CTR.  This would make it easy
to verify that there are no collisions in register allocation.  I.e.:

[...]
#define xdata7		%xmm7
#define xcounter	%xmm8	// CTR mode only
#define xiv		%xmm8	// XCTR mode only
#define xbyteswap	%xmm9	// CTR mode only
#define xkey0		%xmm10
[...]
#define num_bytes	%r8
#define counter		%r9	// XCTR mode only
#define tmp		%r10
[...]


I'm also not a fan of the naming, with "xcounter" being used by CTR only and
"counter" being used by XCTR only...  I see why you did it, though, as the
existing code uses the "x" prefix to mean "this is an xmm register".  It could
at least use a comment that makes this super clear, though:

// Note: the "x" prefix in these aliases means "this is an xmm register".
// No relation to XCTR where the "X" prefix means "XOR counter".
#define xdata0		%xmm0

> +	.if (\xctr == 1)

As \xctr is either 0 or 1, this can be written as simply '.if \xctr'

> +		.set i, 0
> +		.rept (by)
> +			club XDATA, i
> +			movq counter, var_xdata
> +			.set i, (i +1)
> +		.endr
> +	.endif
> +

Since the 3-operand add instruction (vpaddq) is available here, and in fact is
being used already, it isn't necessary to move 'counter' into all (up to 8) of
the var_xdata registers.  Just move it into the last var_xdata register, or into
a temporary register, and use it as a source operand for all the additions.

> -	vpshufb	xbyteswap, xcounter, xdata0
> -
> -	.set i, 1
> -	.rept (by - 1)
> -		club XDATA, i
> -		vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
> -		vptest	ddq_low_msk(%rip), var_xdata
> -		jnz 1f
> -		vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
> -		vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
> -		1:
> -		vpshufb	xbyteswap, var_xdata, var_xdata
> -		.set i, (i +1)
> -	.endr
> +	.if (\xctr == 0)
> +		vpshufb	xbyteswap, xcounter, xdata0
> +		.set i, 1
> +		.rept (by - 1)
> +			club XDATA, i
> +			vpaddq	(ddq_add_1 + 16 * (i - 1))(%rip), xcounter, var_xdata
> +			vptest	ddq_low_msk(%rip), var_xdata
> +			jnz 1f
> +			vpaddq	ddq_high_add_1(%rip), var_xdata, var_xdata
> +			vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
> +			1:
> +			vpshufb	xbyteswap, var_xdata, var_xdata
> +			.set i, (i +1)
> +		.endr
> +	.endif
> +	.if (\xctr == 1)
> +		.set i, 0
> +		.rept (by)
> +			club XDATA, i
> +			vpaddq	(ddq_add_1 + 16 * i)(%rip), var_xdata, var_xdata
> +			.set i, (i +1)
> +		.endr
> +		.set i, 0
> +		.rept (by)
> +			club	XDATA, i
> +			vpxor	xiv, var_xdata, var_xdata
> +			.set i, (i +1)
> +		.endr
> +	.endif

This can be written as:

	.if \xctr
	[second part above]
	.else
	[first part above]
	.endif

> -	vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
> -	vptest	ddq_low_msk(%rip), xcounter
> -	jnz	1f
> -	vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
> -	1:
> +	.if (\xctr == 0)
> +		vpaddq	(ddq_add_1 + 16 * (by - 1))(%rip), xcounter, xcounter
> +		vptest	ddq_low_msk(%rip), xcounter
> +		jnz	1f
> +		vpaddq	ddq_high_add_1(%rip), xcounter, xcounter
> +		1:
> +	.endif
> +	.if (\xctr == 1)
> +		add $by, counter
> +	.endif

Likewise here.

> +.macro do_aes_ctrmain key_len, xctr
>  	cmp	$16, num_bytes
> -	jb	.Ldo_return2\key_len
> +	jb	.Ldo_return2\xctr\key_len
>  
>  	vmovdqa	byteswap_const(%rip), xbyteswap
> -	vmovdqu	(p_iv), xcounter
> -	vpshufb	xbyteswap, xcounter, xcounter
> +	.if (\xctr == 0)
> +		vmovdqu	(p_iv), xcounter
> +		vpshufb	xbyteswap, xcounter, xcounter
> +	.endif
> +	.if (\xctr == 1)
> +		andq	$(~0xf), num_bytes
> +		shr	$4, counter
> +		vmovdqu	(p_iv), xiv
> +	.endif

And likewise here.  Also, the load of byteswap_const can be moved into the
!\xctr block.

- Eric
