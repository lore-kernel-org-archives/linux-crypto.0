Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DCFCA9EA0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C68D214B2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 03:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571800214;
	bh=/2J5Wb1EU6oo8p74l66/XEQWhrel6LVJuend+kjBnhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=og+o2w2KIqN+70hfD8k17CR8gfsljp1zMSw585y7u8RQMLJcntabB5WS2wOVWGsWJ
	 lDk68rVhU5K63gVKyU74WsnZSibu9FxuvaoPhBzWg9xxOtOTFW0Rz/I45H5ggw/meg
	 bf2mD3hErP9JkedyaT/FOq4eG5v4zVuJ6LUQNIU0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfJWDKO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Oct 2019 23:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbfJWDKO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Oct 2019 23:10:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10322064A;
        Wed, 23 Oct 2019 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571800213;
        bh=/2J5Wb1EU6oo8p74l66/XEQWhrel6LVJuend+kjBnhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LJ1O9lZLx14qIfdup+28TF/+6VoWTQu6sfX1SQN/H4wFBuiM8RiYhIgjetYcXCLvD
         w5fyXrrir+en35Y3TvkH9Be7oFtBlxuTRpUHSDnAhLzeutd7PHvCv1Q4y70r0ZPDOu
         UF3bIL0TaLe+JFtCESu5OBNyGyDXZ8rwP3EqIERE=
Date:   Tue, 22 Oct 2019 20:10:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v4 04/35] crypto: x86/chacha - expose SIMD ChaCha routine
 as library function
Message-ID: <20191023031011.GC4278@sol.localdomain>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-5-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017190932.1947-5-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 17, 2019 at 09:09:01PM +0200, Ard Biesheuvel wrote:
> +void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
> +{
> +	state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
> +
> +	if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable()) {
> +		hchacha_block_generic(state, stream, nrounds);
> +	} else {
> +		kernel_fpu_begin();
> +		hchacha_block_ssse3(state, stream, nrounds);
> +		kernel_fpu_end();
> +	}
> +}
> +EXPORT_SYMBOL(hchacha_block_arch);

I generally find negative logic like the above harder to read than the other
way:

	if (static_branch_likely(&chacha_use_simd) && crypto_simd_usable()) {
		kernel_fpu_begin();
		hchacha_block_ssse3(state, stream, nrounds);
		kernel_fpu_end();
	} else {
		hchacha_block_generic(state, stream, nrounds);
	}

(This applies to lots of places in this patch series.)  Not a big deal though.

>  static int __init chacha_simd_mod_init(void)
>  {
>  	if (!boot_cpu_has(X86_FEATURE_SSSE3))
> -		return -ENODEV;
> -
> -#ifdef CONFIG_AS_AVX2
> -	chacha_use_avx2 = boot_cpu_has(X86_FEATURE_AVX) &&
> -			  boot_cpu_has(X86_FEATURE_AVX2) &&
> -			  cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL);
> -#ifdef CONFIG_AS_AVX512
> -	chacha_use_avx512vl = chacha_use_avx2 &&
> -			      boot_cpu_has(X86_FEATURE_AVX512VL) &&
> -			      boot_cpu_has(X86_FEATURE_AVX512BW); /* kmovq */
> -#endif
> -#endif
> +		return 0;
> +
> +	static_branch_enable(&chacha_use_simd);
> +
> +	if (IS_ENABLED(CONFIG_AS_AVX2) &&
> +	    boot_cpu_has(X86_FEATURE_AVX) &&
> +	    boot_cpu_has(X86_FEATURE_AVX2) &&
> +	    cpu_has_xfeatures(XFEATURE_MASK_SSE | XFEATURE_MASK_YMM, NULL)) {
> +		static_branch_enable(&chacha_use_avx2);
> +
> +		if (IS_ENABLED(CONFIG_AS_AVX512) &&
> +		    boot_cpu_has(X86_FEATURE_AVX512VL) &&
> +		    boot_cpu_has(X86_FEATURE_AVX512BW)) /* kmovq */
> +			static_branch_enable(&chacha_use_avx512vl);
> +	}
>  	return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
>  }
>  

This patch is missing the corresponding change to chacha_simd_mod_fini(), to
skip unregistering the skcipher algorithms if they weren't registered.

- Eric
