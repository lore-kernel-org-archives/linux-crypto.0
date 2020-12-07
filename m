Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA284C4361B
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 18:47:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA8A02389F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Dec 2020 18:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLGSrO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:47:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgLGSrO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Dec 2020 13:47:14 -0500
Date:   Mon, 7 Dec 2020 10:46:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607366793;
        bh=JBixQUkzOkhiB9Bd33TyeEeWD3v529EPSHNS2wBFeAU=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=PIVLFFqm3hFDKabhtxYK6TzKLcbdX+Bwu+HlW41LgFQgI2WG52DDxkdNWjbWT/Lic
         HoxG/U3YKlDjceBP8bNQMBnwC+GI2vo3bjSzTl+Cm6dQIdsuHFlnL+97XNk7YdyWjn
         JJIgxPJfjCZ3Uv44ZwKI3EpncFPxACbUistTRcAWoT07mFaE4LelxFe4gs7feQeIcT
         tn+siJb4cfU0s2AqEcb2UvBX4ONWcp16OWDj0L2AeJHNNdWvFyiJ4n6A8BmYmhY2F2
         E2+4uW1K8yhVxXqHlQkxU7m/xvAUOk6YOBgBgUSm4TrXU34UZ4iNiaVXp7tlxtY7iI
         jtWIsNsvlTL+Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        dhowells@redhat.com
Subject: Re: [PATCH] crypto: aes-ni - implement support for cts(cbc(aes))
Message-ID: <X854h5CjaI8ru7PT@gmail.com>
References: <20201206224523.30777-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206224523.30777-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Dec 06, 2020 at 11:45:23PM +0100, Ard Biesheuvel wrote:
> Follow the same approach as the arm64 driver for implementing a version
> of AES-NI in CBC mode that supports ciphertext stealing. Compared to the
> generic CTS template wrapped around the existing cbc-aes-aesni skcipher,
> this results in a ~2x speed increase for relatively short inputs (less
> than 256 bytes), which is relevant given that AES-CBC with ciphertext
> stealing is used for filename encryption in the fscrypt layer. For larger
> inputs, the speedup is still significant (~25% on decryption, ~6% on
> encryption).
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> Full tcrypt benchmark results for cts(cbc-aes-aesni) vs cts-cbc-aes-aesni
> after the diff (Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz)
> 
>  arch/x86/crypto/aesni-intel_asm.S  |  87 +++++++++++++
>  arch/x86/crypto/aesni-intel_glue.c | 133 ++++++++++++++++++++
>  2 files changed, 220 insertions(+)

This is passing the self-tests (including the extra tests), and it's definitely
faster, and would be useful for fscrypt.  I did my own benchmarks and got

Encryption:

        Message size  Before (MB/s)  After (MB/s)
        ------------  -------------  ------------
        32            136.83         273.04
        64            230.03         262.04
        128           372.92         487.71
        256           541.41         652.95

Decryption:

        Message size  Before (MB/s)  After (MB/s)
        ------------  -------------  ------------
        32            121.95         280.04
        64            208.72         279.72
        128           397.98         635.79
        256           723.09         1105.05

(This was with "Intel(R) Xeon(R) Gold 6154 CPU @ 3.00GHz")

So feel free to add:

Tested-by: Eric Biggers <ebiggers@google.com>

I might not have time to fully review this, but one comment below:

> +static int cts_cbc_encrypt(struct skcipher_request *req)
> +{
[...]
> +static int cts_cbc_decrypt(struct skcipher_request *req)
> +{
[...]
>  #ifdef CONFIG_X86_64
> +	}, {
> +		.base = {
> +			.cra_name		= "__cts(cbc(aes))",
> +			.cra_driver_name	= "__cts-cbc-aes-aesni",
> +			.cra_priority		= 400,
> +			.cra_flags		= CRYPTO_ALG_INTERNAL,
> +			.cra_blocksize		= AES_BLOCK_SIZE,
> +			.cra_ctxsize		= CRYPTO_AES_CTX_SIZE,
> +			.cra_module		= THIS_MODULE,
> +		},
> +		.min_keysize	= AES_MIN_KEY_SIZE,
> +		.max_keysize	= AES_MAX_KEY_SIZE,
> +		.ivsize		= AES_BLOCK_SIZE,
> +		.walksize	= 2 * AES_BLOCK_SIZE,
> +		.setkey		= aesni_skcipher_setkey,
> +		.encrypt	= cts_cbc_encrypt,
> +		.decrypt	= cts_cbc_decrypt,

The algorithm is conditional on CONFIG_X86_64, but the function definitions
aren't.

It needs to be one way or the other, otherwise there will be a compiler warning
on 32-bit builds.

- Eric
