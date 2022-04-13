Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C64C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 04:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiDMEXR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 00:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiDMEXR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 00:23:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CE031939
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 21:20:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7F2661B89
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 04:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE75C385A4;
        Wed, 13 Apr 2022 04:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649823656;
        bh=c/fCEPTx2HVL8TUiXs+ChZnbqm4uSRO6M1PiAupk78U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KeVb1v8dFZmF+mI1DSKFG/MDNdX/p1xW6Fyg0bq3QuKnTnQprWRjmB2O49LCRfqoD
         DLuiByllu3mJaGJ+VOglTvrsT8FYzYEwIVQGH+mYZgK71PCnmlRIoIbiyuKsBxTzdl
         nqCHsv4GxtH3NxIyG7DXgJogoykNxNB0f5CeTnC6ADF8Hk3TRIKcqY9CaQHNKOjGTg
         x6eK0+SjXZyJ0Px8BYfftGt6G59R34hu+woF+EdwCZpnLRnEBca4hlbGE5Dfw4CuLt
         5AFqESZJMaXeLcO3z+0cCQYcDJzvIr/I5jfaSI8T20hcQzNSJM2NULDea7czw6W7bN
         cH82rcAoDv+QA==
Date:   Tue, 12 Apr 2022 21:20:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 3/8] crypto: hctr2 - Add HCTR2 support
Message-ID: <YlZPmoCPYQgZ6SQZ@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 12, 2022 at 05:28:11PM +0000, Nathan Huckleberry wrote:
> + /*                                                                               
> +  * HCTR2 is a length-preserving encryption mode that is efficient on             
> +  * processors with instructions to accelerate aes and carryless                  

"aes" should be capitalized ("AES")

> * For more details, see the paper: Length-preserving encryption with HCTR2

Quote the title to distinguish it from the surrounding text:

	For more details, see the paper "Length-preserving encryption with HCTR2"

> +struct hctr2_tfm_ctx {
> +	struct crypto_cipher *blockcipher;
> +	struct crypto_skcipher *xctr;
> +	struct crypto_shash *polyval;
> +	u8 L[BLOCKCIPHER_BLOCK_SIZE];
> +	int hashed_tweak_offset;
> +	/*
> +	 * This struct is allocated with extra space for two exported hash
> +	 * digests.  Since the digest length is not known at compile-time, we
> +	 * can't add them to the struct directly.
> +	 *
> +	 * hashed_tweaklen_even;
> +	 * hashed_tweaklen_odd;
> +	 */
> +};

The digest length *is* known at compile time; it's POLYVAL_DIGEST_SIZE.
This should say "hash state" instead of "hash digest", and "hash state size"
instead of "digest length".

> +      /* Sub-requests, must be last */
> +      union {
> +              struct shash_desc hash_desc;
> +              struct skcipher_request xctr_req;
> +      } u;

Clarify what "last" means above, since it is no longer really last.

> +
> +	/*
> +	 * This struct is allocated with extra space for one exported hash
> +	 * digest.  Since the digest length is not known at compile-time, we
> +	 * can't add it to the struct directly.
> +	 *
> +	 * hashed_tweak;
> +	 */

Similarly, this should say "hash state" and "hash state size", not "hash digest"
and "digest length".

> +/*
> + * HCTR2 requires hashing values based off the tweak length.  Since the kernel
> + * implementation only supports 32-byte tweaks, we can precompute these when
> + * setting the key.

It's not clear what "hashing values based off the tweak length" means.  Please
write something clearer like:

"The input data for each HCTR2 hash step begins with a 16-byte block that
contains the tweak length and a flag that indicates whether the input is evenly
divisible into blocks.  Since this implementation only supports one tweak
length, we precompute the two hash states resulting from hashing the two
possible values of this initial block.  This reduces by one block the amount of
data that needs to be hashed for each encryption/decryption."

> + * If the message length is a multiple of the blocksize, we use H(tweak_len * 2
> + * + 2).  If the message length is not a multiple of the blocksize, we use
> + * H(tweak_len * 2 + 3).
> + */

This would basically be covered by what I suggested above.  Repeating the exact
formula isn't really needed, especially if it's going to be misleading.  (As
written, it omits the conversion from bytes to bits.)

> +static int hctr2_hash_tweaklens(struct hctr2_tfm_ctx *tctx)
> +{
> +	SHASH_DESC_ON_STACK(shash, tfm->polyval);
> +	__le64 tweak_length_block[2];
> +	int err;
> +
> +	shash->tfm = tctx->polyval;
> +	memset(tweak_length_block, 0, sizeof(tweak_length_block));
> +
> +	tweak_length_block[0] = cpu_to_le64(TWEAK_SIZE * 8 * 2 + 2);
> +	err = crypto_shash_init(shash);
> +	if (err)
> +		return err;
> +	err = crypto_shash_update(shash, (u8 *)tweak_length_block,
> +				  POLYVAL_BLOCK_SIZE);
> +	if (err)
> +		return err;
> +	err = crypto_shash_export(shash, hctr2_hashed_tweaklen(tctx, true));
> +	if (err)
> +		return err;
> +
> +	tweak_length_block[0] = cpu_to_le64(TWEAK_SIZE * 8 * 2 + 3);
> +	err = crypto_shash_init(shash);
> +	if (err)
> +		return err;
> +	err = crypto_shash_update(shash, (u8 *)tweak_length_block,
> +				  POLYVAL_BLOCK_SIZE);
> +	if (err)
> +		return err;
> +	return crypto_shash_export(shash, hctr2_hashed_tweaklen(tctx, false));
> +}

The two hashed_tweaklens are backwards; odd means even, and even means odd :-(
Can you write it the logical way?  Even should mean evenly divisible into
blocks, while odd should mean *not* evenly divisible into blocks.  If you want
to call it something else, like aligned and unaligned, that could also work, but
the way you've written it is definitely backwards if we're going with even/odd.

Also, when possible please keep things concise and avoid duplicating code.
This could be replaced with just the following:

static int hctr2_hash_tweaklen(struct hctr2_tfm_ctx *tctx, bool odd)
{
	SHASH_DESC_ON_STACK(shash, unused);
	__le64 block[2] = { cpu_to_le64(TWEAK_SIZE * 8 * 2 + 2 + odd), 0 };

	shash->tfm = tctx->polyval;

	return crypto_shash_init(shash) ?:
	       crypto_shash_update(shash, (u8 *)block, sizeof(block)) ?:
	       crypto_shash_export(shash, hctr2_hashed_tweaklen(tctx, odd));
}

/* (comment here) */
static int hctr2_hash_tweaklens(struct hctr2_tfm_ctx *tctx)
{
	return hctr2_hash_tweaklen(tctx, false) ?:
	       hctr2_hash_tweaklen(tctx, true);
}

> +       subreq_size = max(sizeof_field(struct hctr2_request_ctx, u.hash_desc) +
> +                         crypto_shash_statesize(polyval), sizeof_field(struct
> +                         hctr2_request_ctx, u.xctr_req) +
> +                         crypto_skcipher_reqsize(xctr));

This one needs to be crypto_shash_descsize(), not crypto_shash_statesize().  The
descsize is the size of the context that follows the struct shash_desc, whereas
the statesize is the size of the opaque byte array used by crypto_shash_export()
and crypto_shash_import().  They don't necessarily have the same value.

Also, this would be easier to read if the two parts were indented the same:

        subreq_size = max(sizeof_field(struct hctr2_request_ctx, u.hash_desc) +
                          crypto_shash_descsize(polyval),
                          sizeof_field(struct hctr2_request_ctx, u.xctr_req) +
                          crypto_skcipher_reqsize(xctr));

> +        if (!strncmp(xctr_alg->base.cra_name, "xctr(", 5)) {                     
> +                len = strscpy(blockcipher_name, xctr_name + 5,                   
> +                            sizeof(blockcipher_name));                           
> +                                                                                 
> +                if (len < 1)                                                     
> +                        return -EINVAL;                                          
> +                                                                                 
> +                if (blockcipher_name[len - 1] != ')')                            
> +                        return -EINVAL;                                          
> +                                                                                 
> +                blockcipher_name[len - 1] = 0;                                   
> +        } else                                                                   
> +                return -EINVAL;                                                  

The "return -EINVAL" cases are leaking memory.  How about writing this as:

	err = -EINVAL;
	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
		goto err_free_inst;
	len = strscpy(blockcipher_name, xctr_name + 5,
		      sizeof(blockcipher_name));
	if (len < 1)
		goto err_free_inst;
	if (blockcipher_name[len - 1] != ')')
		goto err_free_inst;
	blockcipher_name[len - 1] = 0;

> + /* hctr2(blockcipher_name) */                                                    
> + /* hctr2_base(xctr_name, polyval_name) */                                        
> + static struct crypto_template hctr2_tmpls[] = {                                  
> +         {                                                                        
> +                 .name = "hctr2_base",                                            
> +                 .create = hctr2_create_base,                                     
> +                 .module = THIS_MODULE,                                           
> +         }, {                                                                     
> +                 .name = "hctr2",                                                 
> +                 .create = hctr2_create,                                          
> +                 .module = THIS_MODULE,                                           
> +         }                                                                        
> + };                                                                               

Perhaps put the comments by the corresponding entries?

static struct crypto_template hctr2_tmpls[] = {
	{
		/* hctr2_base(xctr_name, polyval_name) */
		.name = "hctr2_base",
		.create = hctr2_create_base,
		.module = THIS_MODULE,
	}, {
		/* hctr2(blockcipher_name) */
		.name = "hctr2",
		.create = hctr2_create,
		.module = THIS_MODULE,
	}
};


- Eric
