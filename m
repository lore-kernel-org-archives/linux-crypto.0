Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE3EC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Feb 2022 23:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbiBPXBP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Feb 2022 18:01:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiBPXBO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Feb 2022 18:01:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFE52A2281
        for <linux-crypto@vger.kernel.org>; Wed, 16 Feb 2022 15:01:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E0CBB81C1B
        for <linux-crypto@vger.kernel.org>; Wed, 16 Feb 2022 23:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8646C004E1;
        Wed, 16 Feb 2022 23:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645052459;
        bh=U3nZEbSsGVB9h2ebJpJ+Bcw4S/E1cLnl7y3EFZRXQxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ty1RZM/aOn21QMB5Wg1nCrMP0DxtylXLddumaIZTt0RztqjWValeHwbwwj/EGUKB/
         MO1lnfxzkOasXOkx/Cmw1Vqw79+kEJoJSFgOaxuZoxcxHXmkJ8JoF739fzECpsu4mi
         p2JCEEFTb0bfWF/nYveBnYg6R9Y5DoJ9HV9CTUzBa/j5z0X6/08L9z1xdNKBb34x8y
         5tQwCx3qtj7nGrBNBvTc68N+cPFK6KpSYaYpQ0PladSmAaoMlIHNZXKW7Cjg1OQxD6
         WClldi62Fql6aPnirmoy6EA5Vu8ud8Mj1jumAI3u/iCoZF9R1PJ389Y5EW9q5q/5XG
         rcBZhMK9EZ/6Q==
Date:   Wed, 16 Feb 2022 15:00:57 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH v2 1/7] crypto: xctr - Add XCTR support
Message-ID: <Yg2CKcftTJFfH+s4@sol.localdomain>
References: <20220210232812.798387-1-nhuck@google.com>
 <20220210232812.798387-2-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210232812.798387-2-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 11:28:06PM +0000, Nathan Huckleberry wrote:
> Add a generic implementation of XCTR mode as a template.  XCTR is a
> blockcipher mode similar to CTR mode.  XCTR uses XORs and little-endian
> addition rather than big-endian arithmetic which has two advantages:  It
> is slightly faster on little-endian CPUs and it is less likely to be
> implemented incorrect since integer overflows are not possible on
> practical input sizes.  XCTR is used as a component to implement HCTR2.
> 
> More information on XCTR mode can be found in the HCTR2 paper:
> https://eprint.iacr.org/2021/1441.pdf
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> 
> Changes since v1:
>  * Restricted blocksize to 16-bytes
>  * Removed xctr.h and u32_to_le_block
>  * Use single crypto_template instead of array
> ---

Changelog text conventionally goes in the cover letter, not in the individual
patches.  Having the changelog be above the scissors line ("---") is especially
problematic, as it will show up in the git commit message.

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index fa1741bb568f..8543f34fa200 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -452,6 +452,15 @@ config CRYPTO_PCBC
>  	  PCBC: Propagating Cipher Block Chaining mode
>  	  This block cipher algorithm is required for RxRPC.
>  
> +config CRYPTO_XCTR
> +	tristate
> +	select CRYPTO_SKCIPHER
> +	select CRYPTO_MANAGER
> +	help
> +	  XCTR: XOR Counter mode. This blockcipher mode is a variant of CTR mode
> +	  using XORs and little-endian addition rather than big-endian arithmetic.
> +	  XCTR mode is used to implement HCTR2.

Now that this option isn't user-selectable, no one will see this help text.
I think it would be best to remove it, and make sure that the comment in
crypto/xctr.c fully explains what XCTR is (currently it's a bit inadequate).

> +/*
> + * Test vectors generated using https://github.com/google/hctr2
> + */
> +static const struct cipher_testvec aes_xctr_tv_template[] = {
[...]
> +		.klen	= 16,
> +		.len	= 255,
[...]
> +		.klen	= 16,
> +		.len	= 255,

I commented on the test vectors before in the context of the HCTR2 ones, but the
same comments apply here: the actual test coverage for the number of test
vectors included is not great, due to lengths being repeated.  It would be
better to vary the lengths a bit more, especially the message lengths.  What you
have here isn't bad, but I think there's some room for improvement.

> +/*
> + * XCTR mode is a blockcipher mode of operation used to implement HCTR2. XCTR is
> + * closely related to the CTR mode of operation; the main difference is that CTR
> + * generates the keystream using E(CTR + IV) whereas XCTR generates the
> + * keystream using E(CTR ^ IV).
> + *
> + * See the HCTR2 paper for more details:
> + *	Length-preserving encryption with HCTR2
> + *      (https://eprint.iacr.org/2021/1441.pdf)
> + */

The above comment could use a bit more detail, e.g. mentioning endianness as
well as the fact that XCTR avoids having to deal with multi-limb integers.

> +static void crypto_xctr_crypt_final(struct skcipher_walk *walk,
> +				   struct crypto_cipher *tfm, u32 byte_ctr)
> +{
> +	unsigned long alignmask = crypto_cipher_alignmask(tfm);
> +	u8 tmp[XCTR_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
> +	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
> +	u8 *src = walk->src.virt.addr;
> +	u8 *dst = walk->dst.virt.addr;
> +	unsigned int nbytes = walk->nbytes;
> +	__le32 ctr32 = cpu_to_le32(byte_ctr / XCTR_BLOCKSIZE + 1);
> +
> +	crypto_xor(walk->iv, (u8 *)&ctr32, sizeof(ctr32));
> +	crypto_cipher_encrypt_one(tfm, keystream, walk->iv);
> +	crypto_xor_cpy(dst, keystream, src, nbytes);
> +	crypto_xor(walk->iv, (u8 *)&ctr32, sizeof(ctr32));
> +}

When crypto_cipher_encrypt_one() is used instead of ->cia_encrypt directly, the
caller doesn't need to align the buffers, sincec crypto_cipher_encrypt_one()
handles that.

> +static int crypto_xctr_crypt_segment(struct skcipher_walk *walk,
> +				    struct crypto_cipher *tfm, u32 byte_ctr)
> +{
> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
> +		   crypto_cipher_alg(tfm)->cia_encrypt;
> +	u8 *src = walk->src.virt.addr;
> +	u8 *dst = walk->dst.virt.addr;
> +	unsigned int nbytes = walk->nbytes;
> +	__le32 ctr32 = cpu_to_le32(byte_ctr / XCTR_BLOCKSIZE + 1);
> +
> +	do {
> +		/* create keystream */
> +		crypto_xor(walk->iv, (u8 *)&ctr32, sizeof(ctr32));
> +		fn(crypto_cipher_tfm(tfm), dst, walk->iv);
> +		crypto_xor(dst, src, XCTR_BLOCKSIZE);
> +		crypto_xor(walk->iv, (u8 *)&ctr32, sizeof(ctr32));
> +
> +		ctr32++;
> +
> +		src += XCTR_BLOCKSIZE;
> +		dst += XCTR_BLOCKSIZE;
> +	} while ((nbytes -= XCTR_BLOCKSIZE) >= XCTR_BLOCKSIZE);
> +
> +	return nbytes;
> +}

This won't work on big endian systems due to the 'ctr32++' on a __le32 variable.
I recommend installing 'sparse' and passing C=2 to make, as it will warn about
endianness bugs like this.

Either endianness needs to be converted for the increment, or it needs to be
converted when doing the XOR.  (The latter would work if the XOR is done
manually instead of with crypto_xor, which could be a nice optimization
separately from fixing the endianness bug.)

> +	/* Block size must be >= 4 bytes. */
> +	err = -EINVAL;
> +	if (alg->cra_blocksize != XCTR_BLOCKSIZE)
> +		goto out_free_inst;

The comment above is outdated.

- Eric
