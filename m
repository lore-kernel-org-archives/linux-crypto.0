Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585B4C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  1 May 2022 21:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355064AbiEAVfI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 May 2022 17:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiEAVfI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 May 2022 17:35:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6A636322
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 14:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5773EB80E92
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 21:31:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8DAC385A9;
        Sun,  1 May 2022 21:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651440698;
        bh=WeRRG4BLMn2nheT0tIBFSxNPYhUfchErXx3IZQQ2mlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sb67Us74Gi8vk5fVPHEycB1rGg2Sgh5Rkx2TmCP9jhv5Nx+rWiYlSehdtst2MJOaY
         KfD1Y2T8c6UYSzx+THZ7sxldLko0wmKyNGFXdcafJ8UvrgNZkkdmFDXdLUOp9VhJQy
         bsKNl4aKKwl/KkwD5kT8NJYkhfMVLRS+wDnnEUf3OVox8XSYbKwHz0IdYX3nvo0wOt
         zyzFV/VxFCOrp5Lb3nue6Ftu5+8Js/QfFM72HcsobW60s71/k3kgsIySTkYodV4pXR
         Qa+59HRiQLea0di18r4DKVLgqDdFy9lKrStoWjGxBUSCFrdbQoYQ9bxyCCyZseUy22
         Ee3XERXvE4k9w==
Date:   Sun, 1 May 2022 14:31:32 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        linux-fscrypt.vger.kernel.org@google.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v5 4/8] crypto: x86/aesni-xctr: Add accelerated
 implementation of XCTR
Message-ID: <Ym78NIBGa0iMKaMT@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-5-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003759.1115361-5-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 27, 2022 at 12:37:55AM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated versions of XCTR for x86-64 CPUs with AESNI
> support.  These implementations are modified versions of the CTR
> implementations found in aesni-intel_asm.S and aes_ctrby8_avx-x86_64.S.

Just one implementation now, using aes_ctrby8_avx-x86_64.S.

> +/* Note: the "x" prefix in these aliases means "this is an xmm register".  The
> + * alias prefixes have no relation to XCTR where the "X" prefix means "XOR
> + * counter".
> + */

Block comments look like:

/*
 * text
 */

> +	.if !\xctr
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
> +	.else
> +		movq counter, xtmp
> +		.set i, 0
> +		.rept (by)
> +			club XDATA, i
> +			vpaddq	(ddq_add_1 + 16 * i)(%rip), xtmp, var_xdata
> +			.set i, (i +1)
> +		.endr
> +		.set i, 0
> +		.rept (by)
> +			club	XDATA, i
> +			vpxor	xiv, var_xdata, var_xdata
> +			.set i, (i +1)
> +		.endr
> +	.endif

I'm not a fan of 'if !condition ... else ...', as the else clause is
double-negated.  It's more straightforward to do 'if condition ... else ...'.

> +	.if !\xctr
> +		vmovdqa	byteswap_const(%rip), xbyteswap
> +		vmovdqu	(p_iv), xcounter
> +		vpshufb	xbyteswap, xcounter, xcounter
> +	.else
> +		andq	$(~0xf), num_bytes
> +		shr	$4, counter
> +		vmovdqu	(p_iv), xiv
> +	.endif

Isn't the 'andq $(~0xf), num_bytes' instruction unnecessary?  If it is
necessary, I'd expect it to be necessary for CTR too.

Otherwise this file looks good.

Note, the macros in this file all expand to way too much code, especially due to
the separate cases for AES-128, AES-192, and AES-256, and for each one every
partial stride length 1..7.  Of course, this is true for the existing CTR code
too, so I don't think you have to fix this...  But maybe think about addressing
this later.  Changing the handling of partial strides might be the easiest way
to save a lot of code without hurting any micro-benchmarks too much.  Also maybe
some or all of the AES key sizes could be combined.

> +#ifdef CONFIG_X86_64
> +/*
> + * XCTR does not have a non-AVX implementation, so it must be enabled
> + * conditionally.
> + */
> +static struct skcipher_alg aesni_xctr = {
> +	.base = {
> +		.cra_name		= "__xctr(aes)",
> +		.cra_driver_name	= "__xctr-aes-aesni",
> +		.cra_priority		= 400,
> +		.cra_flags		= CRYPTO_ALG_INTERNAL,
> +		.cra_blocksize		= 1,
> +		.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
> +		.cra_module		= THIS_MODULE,
> +	},
> +	.min_keysize	= AES_MIN_KEY_SIZE,
> +	.max_keysize	= AES_MAX_KEY_SIZE,
> +	.ivsize		= AES_BLOCK_SIZE,
> +	.chunksize	= AES_BLOCK_SIZE,
> +	.setkey		= aesni_skcipher_setkey,
> +	.encrypt	= xctr_crypt,
> +	.decrypt	= xctr_crypt,
> +};
> +
> +static struct simd_skcipher_alg *aesni_simd_xctr;
> +#endif

Comment the #endif above:

#endif /* CONFIG_X86_64 */

> @@ -1180,8 +1274,19 @@ static int __init aesni_init(void)
>  	if (err)
>  		goto unregister_skciphers;
>  
> +#ifdef CONFIG_X86_64
> +	if (boot_cpu_has(X86_FEATURE_AVX))
> +		err = simd_register_skciphers_compat(&aesni_xctr, 1,
> +						     &aesni_simd_xctr);
> +	if (err)
> +		goto unregister_aeads;
> +#endif
> +
>  	return 0;
>  
> +unregister_aeads:
> +	simd_unregister_aeads(aesni_aeads, ARRAY_SIZE(aesni_aeads),
> +				aesni_simd_aeads);

This will cause a compiler warning in 32-bit builds because the
'unregister_aeads' label won't be used.

- Eric
