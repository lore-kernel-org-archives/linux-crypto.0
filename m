Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C06C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 05:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbiA0F21 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:28:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34338 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiA0F20 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 00:28:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FE2DB8210C
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 05:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24876C340E4;
        Thu, 27 Jan 2022 05:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643261304;
        bh=Q3qF/5ZWSe6syjSmD536S8sOy5+4UjHleenLI0y9wII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bK0TwYHPfH8OB0szVwIQkYECazWi3ziRUPF46fKzmPdjkPpKYTSBeOyQg8gItdPRo
         oR3TR1I6K6a9teMbrakntH7rCyoEQrZ30qH+QkZD8MFRa49miWqzbgfQ7Ta94ZlkP2
         1iOwAqkh2BYZstHgo0hALFOYXRaKP9EAme3KiX28emeR+8JBaT261SLg+9/wUnv6ip
         HRBxU2B3RDse0/aWwyFa1ef071/yFjLKJmN2/JqpyC7bP7EZo0l3r+DwbKOC1v+KiC
         Tjslc69U7s09saZGaYe4H2O+IswpQbUyfLDx1XCTeTr8sctrt9CEukW4p9xa+kFljm
         2VSZ9LgN0ADQQ==
Date:   Wed, 26 Jan 2022 21:28:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 1/7] crypto: xctr - Add XCTR support
Message-ID: <YfItdqtnwhaxpz89@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-2-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125014422.80552-2-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 24, 2022 at 07:44:16PM -0600, Nathan Huckleberry wrote:
> Add a generic implementation of XCTR mode as a template.  XCTR is a
> blockcipher mode similar to CTR mode.  XCTR uses XORs and little-endian
> addition rather than big-endian arithmetic which makes it slightly
> faster on little-endian CPUs.  It is used as a component to implement
> HCTR2.
>
> 
> More information on XCTR mode can be found in the HCTR2 paper:
> https://eprint.iacr.org/2021/1441.pdf

The other advantage (besides being faster on little-endian CPUs) of XCTR over
CTR is that on practical input sizes, XCTR never needs to deal with integer
overflows, and therefore is less likely to be implemented incorrectly.  It is in
the paper, but it's worth emphasizing.

> +static void crypto_xctr_crypt_final(struct skcipher_walk *walk,
> +				   struct crypto_cipher *tfm, u32 byte_ctr)
> +{
> +	unsigned int bsize = crypto_cipher_blocksize(tfm);
> +	unsigned long alignmask = crypto_cipher_alignmask(tfm);
> +	u8 ctr[MAX_CIPHER_BLOCKSIZE];
> +	u8 ctrblk[MAX_CIPHER_BLOCKSIZE];
> +	u8 tmp[MAX_CIPHER_BLOCKSIZE + MAX_CIPHER_ALIGNMASK];
> +	u8 *keystream = PTR_ALIGN(tmp + 0, alignmask + 1);
> +	u8 *src = walk->src.virt.addr;
> +	u8 *dst = walk->dst.virt.addr;
> +	unsigned int nbytes = walk->nbytes;
> +	u32 ctr32 = byte_ctr / bsize + 1;
> +
> +	u32_to_le_block(ctr, ctr32, bsize);
> +	crypto_xor_cpy(ctrblk, ctr, walk->iv, bsize);
> +	crypto_cipher_encrypt_one(tfm, keystream, ctrblk);
> +	crypto_xor_cpy(dst, keystream, src, nbytes);
> +}

How about limiting it to a 16-byte block size for now?  That would simplify the
implementation.  You can enforce the block size in crypto_xctr_create().

> +static struct crypto_template crypto_xctr_tmpl[] = {
> +	{
> +		.name = "xctr",
> +		.create = crypto_xctr_create,
> +		.module = THIS_MODULE,
> +	}
> +};

This is defining an array containing 1 crypto_template.  It should just define a
crypto_template struct on its own (not an array).

- Eric
