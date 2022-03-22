Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D85C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 05:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiCVFYm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 01:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236658AbiCVFYl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 01:24:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4C5617C
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 22:23:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDBA461325
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 05:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA0BC340EC;
        Tue, 22 Mar 2022 05:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647926593;
        bh=8CVVJiQkbBhVIRWaOnzwRvFv+xRtoFgLVhj6bjHLPKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JauDG43MLi8K27DebrqwsEQts2Kdn16fRNC2Mwv0JGOBEKkjjgPCpYq+z9vxUTlsT
         oZKvgzRdViWbHE4bHse012fzOXQKVGqN1OKNh84Ip1Qu0GvjY4N24PhKtin/QYtNZG
         bkJasi2vYWJHGlnl16kAoh+rZ1pkMN05MR9O/ME8LD4PK57JjWy9rFVoRfqIluY1Qu
         MEFjhn4Ahsi+QU72Hc5vy/7SJ27pYQS8TebpWwlK4Ke5Svzu5/tW8t9ZAJiuIt0DNk
         DXgaaVQakios+S33wkUfTVnVGgTtt9ZG5b9vYEEQBdoKRb/MN8nq/QVR2ZN4V+hvS/
         Zmw6S7EQwbynA==
Date:   Mon, 21 Mar 2022 22:23:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 1/8] crypto: xctr - Add XCTR support
Message-ID: <YjldP/l1TpAWv0c0@sol.localdomain>
References: <20220315230035.3792663-1-nhuck@google.com>
 <20220315230035.3792663-2-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315230035.3792663-2-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 15, 2022 at 11:00:28PM +0000, Nathan Huckleberry wrote:
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

Looks good, feel free to add:

Reviewed-by: Eric Biggers <ebiggers@google.com>

A few minor nits below:

> +// Limited to 16-byte blocks for simplicity
> +#define XCTR_BLOCKSIZE 16
> +
> +static void crypto_xctr_crypt_final(struct skcipher_walk *walk,
> +				   struct crypto_cipher *tfm, u32 byte_ctr)
> +{
> +	u8 keystream[XCTR_BLOCKSIZE];
> +	u8 *src = walk->src.virt.addr;

Use 'const u8 *src'

> +static int crypto_xctr_crypt_segment(struct skcipher_walk *walk,
> +				    struct crypto_cipher *tfm, u32 byte_ctr)
> +{
> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
> +		   crypto_cipher_alg(tfm)->cia_encrypt;
> +	u8 *src = walk->src.virt.addr;

Likewise, 'const u8 *src'

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

The comment "/* create keystream /*" is a bit misleading, since the part of the
code that it describes isn't just creating the keystream, but also XOR'ing it
with the data.  It would be better to just remove that comment.

> +
> +		ctr32 = cpu_to_le32(le32_to_cpu(ctr32) + 1);

This could use le32_add_cpu().

> +
> +		src += XCTR_BLOCKSIZE;
> +		dst += XCTR_BLOCKSIZE;
> +	} while ((nbytes -= XCTR_BLOCKSIZE) >= XCTR_BLOCKSIZE);
> +
> +	return nbytes;
> +}
> +
> +static int crypto_xctr_crypt_inplace(struct skcipher_walk *walk,
> +				    struct crypto_cipher *tfm, u32 byte_ctr)
> +{
> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *) =
> +		   crypto_cipher_alg(tfm)->cia_encrypt;
> +	unsigned long alignmask = crypto_cipher_alignmask(tfm);
> +	unsigned int nbytes = walk->nbytes;
> +	u8 *src = walk->src.virt.addr;

Perhaps call this 'data' instead of 'src', since here it's both the source and
destination?

> +	u8 tmp[XCTR_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
> +	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
> +	__le32 ctr32 = cpu_to_le32(byte_ctr / XCTR_BLOCKSIZE + 1);
> +
> +	do {
> +		/* create keystream */

Likewise, remove or clarify the '/* create keystream */' comment.

> +		crypto_xor(walk->iv, (u8 *)&ctr32, sizeof(ctr32));
> +		fn(crypto_cipher_tfm(tfm), keystream, walk->iv);
> +		crypto_xor(src, keystream, XCTR_BLOCKSIZE);
> +		crypto_xor(walk->iv, (u8 *)&ctr32, sizeof(ctr32));
> +
> +		ctr32 = cpu_to_le32(le32_to_cpu(ctr32) + 1);

Likewise, le32_add_cpu().

- Eric
