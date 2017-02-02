From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH v2 4/4] crypto: aes - add generic time invariant AES
 for CTR/CCM/GCM
Date: Wed, 1 Feb 2017 23:38:24 -0800
Message-ID: <20170202073824.GC582@zzz>
References: <1485646413-17491-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485646413-17491-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35379 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750871AbdBBHi1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 02:38:27 -0500
Received: by mail-pf0-f195.google.com with SMTP id f144so880927pfa.2
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 23:38:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1485646413-17491-5-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ard,

On Sat, Jan 28, 2017 at 11:33:33PM +0000, Ard Biesheuvel wrote:
> 
> Note that this only implements AES encryption, which is all we need
> for CTR and CBC-MAC. AES decryption can easily be implemented in a
> similar way, but is significantly more costly.

Is the expectation of decryption being more costly the only reason why "aes-ti"
couldn't be a "cipher" algorithm, allowing it to automatically be used by the
existing templates for CTR, CBC-MAC, CBC, ECB, XTS, CMAC, etc.?  It doesn't seem
to do anything expensive on a per-block basis like loading SSE registers, so it
seems it would fit better as a "cipher" algorithm if at all possible.  Then
there would be no need to implement all these modes yet again.

Also, what would be the feasibility of simply replacing aes-generic with the
time-invariant implementation, rather than offering two implementations and
requiring users to choose one, usually without the needed expertise?

> +
> +/*
> + * Emit the sbox as __weak with external linkage to prevent the compiler
> + * from doing constant folding on sbox references involving fixed indexes.
> + */
> +__weak const u8 __cacheline_aligned __aesti_sbox[] = {

Did you consider marking it 'volatile' instead?

> +static int aesti_set_key(struct aes_ti_ctx *ctx, const u8 *in_key,
> +			 unsigned int key_len)
> +{
> +	struct crypto_aes_ctx rk;
> +	int err;
> +
> +	err = crypto_aes_expand_key(&rk, in_key, key_len);
> +	if (err)
> +		return err;

crypto_aes_expand_key() assumes that the key is u32-aligned; I don't think
that's guaranteed here.

Eric
