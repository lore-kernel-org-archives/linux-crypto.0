Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6846AC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Apr 2022 07:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240205AbiDNHDc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Apr 2022 03:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240190AbiDNHDV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Apr 2022 03:03:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD5C21807
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 00:00:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28DDFB827CB
        for <linux-crypto@vger.kernel.org>; Thu, 14 Apr 2022 07:00:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B075C385A5;
        Thu, 14 Apr 2022 07:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649919653;
        bh=uHr1+Cwk86eR3a3pxOBg7H43IWRGQGcenpXAPlFZX4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AOcwbyv8bz3OKJR/W9KdvGEitDnENEPLZ0FbcyK6tb8Q9nBqE+05Um11dUIT4+Dvc
         u0hjXDCoTv1Kq+uwp8ZzhFkjeD2KPPKPDUabZ3LuB0X+h+xwpwz5gNYQjiJwSVvEZd
         8YwC8y83PeGlO/JFx2aY1OYnV8T96ICtdB6eSrVbnH57SaRGjVJIxdO/RIcnGwzWo6
         KLI8mEPP7Uaf5GdHMSax42P6kR+qMoqg28hAj+gxuto5AKHQw642s5AdNixMdTZiwJ
         sxwmzKDv7NUuK9VD7ABVlYMB00te7PcscP36DoVGnizsk7HVTblYjzUBJySeuQJP0K
         AqDjxDLqjwUYA==
Date:   Thu, 14 Apr 2022 00:00:51 -0700
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
Message-ID: <YlfGo8wSXS58mKmL@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-5-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-5-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

A few initial comments, I'll take a closer look at the .S file soon...

On Tue, Apr 12, 2022 at 05:28:12PM +0000, Nathan Huckleberry wrote:
> Add hardware accelerated versions of XCTR for x86-64 CPUs with AESNI
> support.  These implementations are modified versions of the CTR
> implementations found in aesni-intel_asm.S and aes_ctrby8_avx-x86_64.S.
> 
> More information on XCTR can be found in the HCTR2 paper:
> Length-preserving encryption with HCTR2:
> https://enterprint.iacr.org/2021/1441.pdf

The above link doesn't work.

> +#ifdef __x86_64__
> +/*
> + * void aesni_xctr_enc(struct crypto_aes_ctx *ctx, const u8 *dst, u8 *src,
> + *		      size_t len, u8 *iv, int byte_ctr)
> + */

This prototype doesn't match the one declared in the .c file.

> +
> +asmlinkage void aes_xctr_enc_128_avx_by8(const u8 *in, u8 *iv, void *keys, u8
> +	*out, unsigned int num_bytes, unsigned int byte_ctr);
> +
> +asmlinkage void aes_xctr_enc_192_avx_by8(const u8 *in, u8 *iv, void *keys, u8
> +	*out, unsigned int num_bytes, unsigned int byte_ctr);
> +
> +asmlinkage void aes_xctr_enc_256_avx_by8(const u8 *in, u8 *iv, void *keys, u8
> +	*out, unsigned int num_bytes, unsigned int byte_ctr);

Please don't have line breaks between parameter types and their names.
These should look like:

asmlinkage void aes_xctr_enc_128_avx_by8(const u8 *in, u8 *iv, void *keys,
	u8 *out, unsigned int num_bytes, unsigned int byte_ctr);

Also, why aren't the keys const?

> +static void aesni_xctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out, const u8
> +				   *in, unsigned int len, u8 *iv, unsigned int
> +				   byte_ctr)
> +{
> +	if (ctx->key_length == AES_KEYSIZE_128)
> +		aes_xctr_enc_128_avx_by8(in, iv, (void *)ctx, out, len,
> +					 byte_ctr);
> +	else if (ctx->key_length == AES_KEYSIZE_192)
> +		aes_xctr_enc_192_avx_by8(in, iv, (void *)ctx, out, len,
> +					 byte_ctr);
> +	else
> +		aes_xctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len,
> +					 byte_ctr);
> +}

Same comments above.

> +static int xctr_crypt(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct crypto_aes_ctx *ctx = aes_ctx(crypto_skcipher_ctx(tfm));
> +	u8 keystream[AES_BLOCK_SIZE];
> +	u8 ctr[AES_BLOCK_SIZE];
> +	struct skcipher_walk walk;
> +	unsigned int nbytes;
> +	unsigned int byte_ctr = 0;
> +	int err;
> +	__le32 ctr32;
> +
> +	err = skcipher_walk_virt(&walk, req, false);
> +
> +	while ((nbytes = walk.nbytes) > 0) {
> +		kernel_fpu_begin();
> +		if (nbytes & AES_BLOCK_MASK)
> +			static_call(aesni_xctr_enc_tfm)(ctx, walk.dst.virt.addr,
> +				walk.src.virt.addr, nbytes & AES_BLOCK_MASK,
> +				walk.iv, byte_ctr);
> +		nbytes &= ~AES_BLOCK_MASK;
> +		byte_ctr += walk.nbytes - nbytes;
> +
> +		if (walk.nbytes == walk.total && nbytes > 0) {
> +			ctr32 = cpu_to_le32(byte_ctr / AES_BLOCK_SIZE + 1);
> +			memcpy(ctr, walk.iv, AES_BLOCK_SIZE);
> +			crypto_xor(ctr, (u8 *)&ctr32, sizeof(ctr32));
> +			aesni_enc(ctx, keystream, ctr);
> +			crypto_xor_cpy(walk.dst.virt.addr + walk.nbytes -
> +				       nbytes, walk.src.virt.addr + walk.nbytes
> +				       - nbytes, keystream, nbytes);
> +			byte_ctr += nbytes;
> +			nbytes = 0;
> +		}

For the final block case, it would be a bit simpler to do something like this:

	__le32 block[AES_BLOCK_SIZE / sizeof(__le32)]

	
	...
	memcpy(block, walk.iv, AES_BLOCK_SIZE);
	block[0] ^= cpu_to_le32(1 + byte_ctr / AES_BLOCK_SIZE);
	aesni_enc(ctx, (u8 *)block, (u8 *)block);

I.e., have one buffer, use a regular XOR instead of crypto_xor(), and encrypt it
in-place.

> @@ -1162,6 +1249,8 @@ static int __init aesni_init(void)
>  		/* optimize performance of ctr mode encryption transform */
>  		static_call_update(aesni_ctr_enc_tfm, aesni_ctr_enc_avx_tfm);
>  		pr_info("AES CTR mode by8 optimization enabled\n");
> +		static_call_update(aesni_xctr_enc_tfm, aesni_xctr_enc_avx_tfm);
> +		pr_info("AES XCTR mode by8 optimization enabled\n");
>  	}

Please don't add the log message above, as it would get printed at every boot-up
on most x86 systems, and it's not important enough for that.  The existing
message "AES CTR mode ..." shouldn't really exist in the first place.

- Eric
