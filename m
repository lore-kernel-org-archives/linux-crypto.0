Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E7FC433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  1 May 2022 18:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354970AbiEASg4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 May 2022 14:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354955AbiEASgz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 May 2022 14:36:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4C815FF1
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 11:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1544D60F5D
        for <linux-crypto@vger.kernel.org>; Sun,  1 May 2022 18:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CD5C385AA;
        Sun,  1 May 2022 18:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651430008;
        bh=IyGWWqmqLPlCfRpXCsmhbH7KCfxVS7fe1ibyNyBxHtg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UOTwP/YhnU8GMK6aNGWtUpmII6yurTzpAZPtA6mVKsGOXwuu1tBge+yI7qURC0T+B
         1PuqaOCiERdDtqh5ODxt1VmV7RuRNR4WfKPHA0bQple3QGziXLA3E7qDxS2sRUQv/s
         FHujk5yQY0qRJl8EPcuST+MQj6Yk9PSpW2h8tqLyhNeK94Sse8vfuwgP0DRf7LeG14
         bEKeqWfNgCWRCcSRwfUd4epBpcB/D/6y58WgcwyZsjM2NSmdIgpceQXZ/e7UhHqPdf
         5ATZ7svT8obuvwbold17nLEj8anXDLCQJrclj10pgspzlc8R1+B1mG1kZYIXwXpcZE
         g2VknH1FP1uew==
Date:   Sun, 1 May 2022 11:33:26 -0700
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
Subject: Re: [PATCH v5 3/8] crypto: hctr2 - Add HCTR2 support
Message-ID: <Ym7SdohJAlp6pOM9@sol.localdomain>
References: <20220427003759.1115361-1-nhuck@google.com>
 <20220427003759.1115361-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427003759.1115361-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 27, 2022 at 12:37:54AM +0000, Nathan Huckleberry wrote:
> +/* The input data for each HCTR2 hash step begins with a 16-byte block that
> + * contains the tweak length and a flag that indicates whether the input is evenly
> + * divisible into blocks.  Since this implementation only supports one tweak
> + * length, we precompute the two hash states resulting from hashing the two
> + * possible values of this initial block.  This reduces by one block the amount of
> + * data that needs to be hashed for each encryption/decryption
> + *
> + * These precomputed hashes are stored in hctr2_tfm_ctx.
> + */

Block comments should look like this:

/*
 * text
 */

i.e. there should be a newline after the "/*"

> +	memset(tctx->L, 0, sizeof(tctx->L));
> +	memset(hbar, 0, sizeof(hbar));
> +	tctx->L[0] = 0x01;
> +	crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);
> +	crypto_cipher_encrypt_one(tctx->blockcipher, hbar, hbar);

This would be easier to read if the computations of hbar and L were separated:

	memset(hbar, 0, sizeof(hbar));
	crypto_cipher_encrypt_one(tctx->blockcipher, hbar, hbar);

	memset(tctx->L, 0, sizeof(tctx->L));
	tctx->L[0] = 0x01;
	crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);

> +static int hctr2_hash_message(struct skcipher_request *req,
> +			      struct scatterlist *sgl,
> +			      u8 digest[POLYVAL_DIGEST_SIZE])
> +{
> +	u8 padding[BLOCKCIPHER_BLOCK_SIZE];
> +	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
> +	struct shash_desc *hash_desc = &rctx->u.hash_desc;
> +	const unsigned int bulk_len = req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
> +	struct sg_mapping_iter miter;
> +	unsigned int remainder = bulk_len % BLOCKCIPHER_BLOCK_SIZE;
> +	int err, i;
> +	int n = 0;
> +
> +	sg_miter_start(&miter, sgl, sg_nents(sgl),
> +		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
> +	for (i = 0; i < bulk_len; i += n) {
> +		sg_miter_next(&miter);
> +		n = min_t(unsigned int, miter.length, bulk_len - i);
> +		err = crypto_shash_update(hash_desc, miter.addr, n);
> +		if (err)
> +			break;
> +	}
> +	sg_miter_stop(&miter);
> +
> +	if (err)
> +		return err;

There's actually an uninitialized variable bug here.  If bulk_len==0, then 'err'
never gets initialized before being checked.  I'm surprised this doesn't cause a
compiler warning, but it doesn't!  'err' needs to be initialized to 0.

> +
> +	if (remainder) {
> +		memset(padding, 0, BLOCKCIPHER_BLOCK_SIZE);
> +		padding[0] = 0x01;

'padding' can be static const:

	static const u8 padding[BLOCKCIPHER_BLOCK_SIZE] = { 0x1 };

> +	subreq_size = max(sizeof_field(struct hctr2_request_ctx, u.hash_desc) +
> +			  crypto_shash_descsize(polyval), sizeof_field(struct
> +			  hctr2_request_ctx, u.xctr_req) +
> +			  crypto_skcipher_reqsize(xctr));

This is a little hard to read; it would be better if the sizeof_field()'s were
aligned:

	subreq_size = max(sizeof_field(struct hctr2_request_ctx, u.hash_desc) +
			  crypto_shash_descsize(polyval),
			  sizeof_field(struct hctr2_request_ctx, u.xctr_req) +
			  crypto_skcipher_reqsize(xctr));

Other than that, everything looks good.  The only thing that really has to be
fixed is the uninitialized variable.  After that feel free to add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
