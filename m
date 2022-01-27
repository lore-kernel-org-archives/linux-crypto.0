Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 475E5C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 05:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiA0FIo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 00:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiA0FIn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 00:08:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35183C06161C
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 21:08:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF38EB81F86
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 05:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B25AC340E4;
        Thu, 27 Jan 2022 05:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643260120;
        bh=9LPIspuiV7bnXfjY9MjLb7cttyrCIyz8hNMkNnkhq6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b66vdap5xAQocyvsJVvhvfwt+oqzheDdF10aFc+SldnDRwKr4GBWXiPUlpTGNLuYp
         Pn0pov98VMUJNO4prCpIO7bT6a+ew4C5n/oGij3cjxQb7CjkNa6Qoo7q3NI0ddAVMT
         DTczSaiQmX2r7y2rIgK6JMwrO5R5T8TOxJXDiwU0WqBzXSLffc4Z1soowZf8uH2sdz
         ZgipB8tvT9tKt+S4YbmUxhxtB1bz7rr/Gg7+q6TSFhrLUZ+4p3SZNC4BTEV/F79Zx8
         qFJ2KUBu0vdUxahqP6e0ZQlM/ZCcY+SSzJW3Z6bPB5i4ZeYkQjgp0y9+4eeG3u6A8E
         m26XlTlMoE8pQ==
Date:   Wed, 26 Jan 2022 21:08:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <YfIo1pL69+GRsSzp@sol.localdomain>
References: <20220125014422.80552-1-nhuck@google.com>
 <20220125014422.80552-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125014422.80552-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Huck,

This patch generally looks good.  Some comments below:

> +config CRYPTO_HCTR2
> +	tristate "HCTR2 support"
> +	select CRYPTO_XCTR
> +	select CRYPTO_POLYVAL
> +	select CRYPTO_MANAGER
> +	help
> +	  HCTR2 is a length-preserving encryption mode that is efficient on
> +	  processors with instructions to accelerate AES and carryless
> +	  multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
> +	  processors with the ARMv8 crypto extensions.

The Kconfig help text should mention that this is for storage encryption.

> diff --git a/crypto/hctr2.c b/crypto/hctr2.c
> new file mode 100644
> index 000000000000..af43f81b68f3
> --- /dev/null
> +++ b/crypto/hctr2.c
> @@ -0,0 +1,475 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * HCTR2 length-preserving encryption mode
> + *
> + * Copyright 2021 Google LLC
> + */
> +
> +
> +/*
> + * HCTR2 is a length-preserving encryption mode that is efficient on
> + * processors with instructions to accelerate aes and carryless
> + * multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
> + * processors with the ARMv8 crypto extensions.
> + *
> + * Length-preserving encryption with HCTR2
> + *	(https://eprint.iacr.org/2021/1441.pdf)

The mention of the paper should fit into the rest of the text, like "Reference:
..." or "For more details, see the paper ...".

> + *
> + *	HCTR2 has a strict set of requirements for the hash function. For this
> + *	purpose we only allow POLYVAL. To avoid misuse, XCTR is required as
> + *	specified in the HCTR2 paper, though theoretically there is a larger class
> + *	of algorithms that could be used.
> + */

HCTR2 is only defined with POLYVAL and XCTR.  So this paragraph isn't necessary.

You could mention that the block cipher can be replaced with one other than AES,
although that can be considered "obvious".

> +static int hctr2_setkey(struct crypto_skcipher *tfm, const u8 *key,
> +			unsigned int keylen)
> +{
> +	struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
> +	u8 hbar[BLOCKCIPHER_BLOCK_SIZE];
> +	int err;
> +
> +	crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
> +	crypto_cipher_set_flags(tctx->blockcipher,
> +				crypto_skcipher_get_flags(tfm) &
> +				CRYPTO_TFM_REQ_MASK);
> +	err = crypto_cipher_setkey(tctx->blockcipher, key, keylen);
> +	if (err)
> +		return err;
> +
> +	crypto_skcipher_clear_flags(tctx->streamcipher, CRYPTO_TFM_REQ_MASK);
> +	crypto_skcipher_set_flags(tctx->streamcipher,
> +				  crypto_skcipher_get_flags(tfm) &
> +				  CRYPTO_TFM_REQ_MASK);
> +	err = crypto_skcipher_setkey(tctx->streamcipher, key, keylen);
> +	if (err)
> +		return err;
> +
> +	memset(tctx->L, 0, sizeof(tctx->L));
> +	memset(hbar, 0, sizeof(hbar));
> +	tctx->L[0] = 0x01;
> +	crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);
> +	crypto_cipher_encrypt_one(tctx->blockcipher, hbar, hbar);
> +
> +	crypto_shash_clear_flags(tctx->hash, CRYPTO_TFM_REQ_MASK);
> +	crypto_shash_set_flags(tctx->hash, crypto_skcipher_get_flags(tfm) &
> +			       CRYPTO_TFM_REQ_MASK);
> +	err = crypto_shash_setkey(tctx->hash, hbar, BLOCKCIPHER_BLOCK_SIZE);
> +	return err;
> +}

This should call 'memzero_explicit(hbar, sizeof(hbar))' before returning.

> +static int hctr2_hash_tweak(struct skcipher_request *req, u8 *iv)
> +{
> +	u64 tweak_length_part[2];

This should be __le64, not u64.   Also, how about calling this
tweak_length_block or tweaklen_block, given that it's one POLYVAL block?

> +	err = crypto_shash_update(hash_desc, (u8 *)tweak_length_part, sizeof(tweak_length_part));
> +	if (err)
> +		return err;

Limiting lines to 80 columns is still recommended.
'checkpatch --max-line-length=80' will warn about this.

> +	err = crypto_shash_update(hash_desc, iv, TWEAK_SIZE);
> +	return err;
> +}

This can be just 'return crypto_shash_update(...'

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
> +	int err;
> +
> +	sg_miter_start(&miter, sgl, sg_nents(sgl),
> +		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
> +	while (sg_miter_next(&miter)) {
> +		err = crypto_shash_update(hash_desc, miter.addr, miter.length);
> +		if (err)
> +			break;
> +	}
> +	sg_miter_stop(&miter);

I don't think it is guaranteed that the length of the crypto request is equal to
the length of the scatterlist; the scatterlist could be longer.

So this would need to stop after processing bulk_len bytes only, like what
adiantum_hash_message() does.

> +static int hctr2_finish(struct skcipher_request *req)
> +{
> +	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
> +	u8 digest[POLYVAL_DIGEST_SIZE];
> +	int err;
> +
> +	err = hctr2_hash_tweak(req, req->iv);
> +	if (err)
> +		return err;
> +	err = hctr2_hash_message(req, rctx->bulk_part_dst, digest);
> +	if (err)
> +		return err;
> +	crypto_xor(rctx->first_block, digest, BLOCKCIPHER_BLOCK_SIZE);
> +
> +	scatterwalk_map_and_copy(rctx->first_block, req->dst,
> +				 0, BLOCKCIPHER_BLOCK_SIZE, 1);
> +	return 0;
> +}

In general, I think the code could use some more comments that map what is being
done to the pseudocode in the paper.  That would make it easier to understand.

> +	err = -ENAMETOOLONG;
> +	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
> +				 "hctr2(%s)", blockcipher_alg->cra_name) >= CRYPTO_MAX_ALG_NAME)
> +		goto err_free_inst;
> +	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
> +		     "hctr2(%s,%s,%s)",
> +		     blockcipher_alg->cra_driver_name,
> +		     streamcipher_alg->base.cra_driver_name,
> +		     hash_alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
> +		goto err_free_inst;
[...]
> +/* hctr2(blockcipher_name [, xctr(blockcipher_name)] [, polyval_name]) */
> +static struct crypto_template hctr2_tmpl = {
> +	.name = "hctr2",
> +	.create = hctr2_create,
> +	.module = THIS_MODULE,
> +};

The optional parameters mentioned in the comment above don't appear to be
implemented.  Also, the syntax described is ambiguous.  I think you meant for
there to be only one set of square brackets?

xctr(blockcipher_name) should be xctr_name, since it would have to be a driver /
implementation name, and those don't necessarily include parentheses like the
algorithm names do.

Did you consider not allowing the single block cipher implementation to be
overridden?  The single block cipher is a minor part compared to xctr.  This
would simplify the "full" syntax slighty, as then it would be
"hctr2(xctr_name, polyval_name)" instead of
"hctr2(blockcipher_name, xctr_name, polyval_name)".

I suppose it does make sense to take the single block cipher parameter, given
that it is used.  But you'll need to make sure to make hctr2_create() enforce
that the same block cipher is used in both parameters.

> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index da3736e51982..87e4df6f8ea9 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -33630,4 +33630,791 @@ static const struct hash_testvec polyval_tv_template[] = {
>  	},
>  };
>  
> +/*
> + * Test vectors generated using https://github.com/google/hctr2
> + */
> +static const struct cipher_testvec aes_hctr2_tv_template[] = {
[snip 787 lines]

I think the selection of test vectors still needs some improvemnt.  As-is, there
are two random test vectors for every permutation of message length in [16, 17,
48, 255] and key length in [16, 24, 32] -- so, 24 test vectors total.  However,
multiple random test vectors with the same lengths are unlikely to be better
than one.  Also, testing each AES key length with every message length is
unlikely to be useful.

Message length is really the main way that things can go wrong in practice.  And
the real-world case of "long aligned message" is not being tested at all.  So I
think the test coverage would be better, with fewer test vectors, if more
message lengths were tested but there were fewer tests for each length.  For
example, one test vector for each message length in [16, 17, 31, 48, 64, 128,
255, 512], assigning different AES key lengths to different ones so that all AES
key lengths get covered.

- Eric
