Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05850C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Feb 2022 01:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiBQBHZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Feb 2022 20:07:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiBQBHY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Feb 2022 20:07:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D302A39E1
        for <linux-crypto@vger.kernel.org>; Wed, 16 Feb 2022 17:07:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3618B820B3
        for <linux-crypto@vger.kernel.org>; Thu, 17 Feb 2022 01:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575BEC004E1;
        Thu, 17 Feb 2022 01:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645060028;
        bh=jU2sHrH9ZkW24tsrrPI3R3zVKRWOw/VpRGZqbQ2eZf4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dsls3/xwrvyxORTdMk6G8LxtsrMcVxFatTv4AzcAuN6cIGtpXaI1uyIzWt/seImic
         ZXZVMN2B4z0cwdoUZKuJ2i3v3OxAfe8nol0szs+qIi6ZBvnasRh/FM6wJhln9ZJ/Ld
         paTs0Idk6Y4wSYTgWQLP70aBqD22IZ9AepGG/ULYE1sIb+aNDqruRSsjoS9Rz9pbi6
         rdebHzjRwfygZLEaVxFGsgBRONgyAuHvgd3CK8g4D+Y1pnIQAVmKPTJp/QU6DOM5aM
         CbKkL1/1ldapl7bb4TQoQAIe+961unQUvTp+RlXcUPrnVtxs3UL6cq0XBiUo/0kYU/
         4tGxFpZFQqHUQ==
Date:   Wed, 16 Feb 2022 17:07:06 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [RFC PATCH v2 3/7] crypto: hctr2 - Add HCTR2 support
Message-ID: <Yg2fusq8IyWsiDQj@sol.localdomain>
References: <20220210232812.798387-1-nhuck@google.com>
 <20220210232812.798387-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220210232812.798387-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 11:28:08PM +0000, Nathan Huckleberry wrote:
> Changes since v1:
>  * Rename streamcipher -> xctr
>  * Rename hash -> polyval
>  * Use __le64 instead of u64 for little-endian length
>  * memzero_explicit in set_key
>  * Use crypto request length instead of scatterlist length for polyval
>  * Add comments referencing the paper's pseudocode
>  * Derive blockcipher name from xctr name
>  * Pass IV through request context
>  * Use .generic_driver
>  * Make tests more comprehensive

This is looking much better than v1.  A few comments below.

> +static int hctr2_hash_tweak(struct skcipher_request *req)
> +{
> +	__le64 tweak_length_block[2];
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	const struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
> +	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
> +	struct shash_desc *hash_desc = &rctx->u.hash_desc;
> +	int err;
> +
> +	memset(tweak_length_block, 0, sizeof(tweak_length_block));
> +	if (req->cryptlen % POLYVAL_BLOCK_SIZE == 0)
> +		tweak_length_block[0] = cpu_to_le64(TWEAK_SIZE * 8 * 2 + 2);
> +	else
> +		tweak_length_block[0] = cpu_to_le64(TWEAK_SIZE * 8 * 2 + 3);
> +
> +	hash_desc->tfm = tctx->polyval;
> +	err = crypto_shash_init(hash_desc);
> +	if (err)
> +		return err;
> +
> +	err = crypto_shash_update(hash_desc, (u8 *)tweak_length_block,
> +				  sizeof(tweak_length_block));
> +	if (err)
> +		return err;
> +	return crypto_shash_update(hash_desc, req->iv, TWEAK_SIZE);
> +}

Have you considered taking advantage of the hash function precomputation that is
possible?  That should improve the performance a bit, especially on short
inputs.  Per-key, a hash state could be precomputed containing the
tweak_length_block, since it will always have the same contents, due to this
implementation only supporting a single tweak length.  hctr2_setkey() could
compute that and export it using crypto_shash_export() into the hctr2_tfm_ctx.
hctr2_crypt() could import it using crypto_shash_import().

Similarly, the tweak only needs to be hashed once per request, as the state
could be exported after hashing it the first time, then imported for the second
hash step.  The saved state would need to be part of the hctr2_request_ctx.

> +static int hctr2_finish(struct skcipher_request *req)
> +{
> +	struct hctr2_request_ctx *rctx = skcipher_request_ctx(req);
> +	u8 digest[POLYVAL_DIGEST_SIZE];
> +	int err;
> +
> +	// U = UU ^ H(T || V)
> +	err = hctr2_hash_tweak(req);
> +	if (err)
> +		return err;
> +	err = hctr2_hash_message(req, rctx->bulk_part_dst, digest);
> +	if (err)
> +		return err;
> +	crypto_xor(rctx->first_block, digest, BLOCKCIPHER_BLOCK_SIZE);
> +
> +	// Copy U into dst scatterlist
> +	scatterwalk_map_and_copy(rctx->first_block, req->dst,
> +				 0, BLOCKCIPHER_BLOCK_SIZE, 1);
> +	return 0;
> +}

The comments here and in hctr2_crypt() are assuming encryption, but the code
also handles decryption.  It would be helpful to give the pseudocode for both,
e.g.:

	//    U = UU ^ H(T || V)
	// or M = MM ^ H(T || N)

> +static int hctr2_create_base(struct crypto_template *tmpl, struct rtattr **tb)
> +{
> +	const char *xctr_name;
> +	const char *polyval_name;
> +	char blockcipher_name[CRYPTO_MAX_ALG_NAME];
> +	int len;
> +
> +	xctr_name = crypto_attr_alg_name(tb[1]);
> +	if (IS_ERR(xctr_name))
> +		return PTR_ERR(xctr_name);
> +
> +	if (!strncmp(xctr_name, "xctr(", 5)) {
> +		len = strscpy(blockcipher_name, xctr_name + 5,
> +			    sizeof(blockcipher_name));
> +
> +		if (len < 1)
> +			return -EINVAL;
> +
> +		if (blockcipher_name[len - 1] != ')')
> +			return -EINVAL;
> +
> +		blockcipher_name[len - 1] = 0;
> +	} else
> +		return -EINVAL;

I don't think this is exactly what Herbert and I had in mind.  It's close, but
the problem with grabbing the block cipher name from the raw string the user
passes in is that the string could be an implementation name like "xctr-aes-ni",
rather than an algorithm name like "xctr(aes)".

The correct way to do this is to wait to determine the block cipher algorithm
until after calling crypto_grab_skcipher().  Then it will be available in the
->cra_name of the skcipher algorithm (that should be xctr).

> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index da3736e51982..a16b631730e9 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -33630,4 +33630,674 @@ static const struct hash_testvec polyval_tv_template[] = {
>  	},
>  };
>  
> +/*
> + * Test vectors generated using https://github.com/google/hctr2
> + */
> +static const struct cipher_testvec aes_hctr2_tv_template[] = {
> +		.klen	= 16,
> +		.len	= 16,
> +	},
> +	{
[...]
> +		.klen	= 16,
> +		.len	= 16,
> +	},
> +	{
[...]
> +		.klen	= 16,
> +		.len	= 17,
> +	},
> +	{
[...]
> +		.klen	= 16,
> +		.len	= 17,
> +	},
> +	{
[...]
> +		.klen	= 24,
> +		.len	= 31,
> +	},
> +	{
> +		.klen	= 24,
> +		.len	= 31,
> +	},
[...]
> +	{
> +		.klen	= 24,
> +		.len	= 48,
> +	},
[...]
> +		.klen	= 24,
> +		.len	= 48,
[...]
> +		.klen	= 32,
> +		.len	= 128,
[...]
> +		.klen	= 32,
> +		.len	= 128,
[...]
> +		.klen	= 32,
> +		.len	= 255,
[...]
> +		.klen	= 32,
> +		.len	= 255,
[...]
> +		.klen	= 32,
> +		.len	= 512,
[...]
> +		.klen	= 32,
> +		.len	= 512,

These are better but still could use some improvement.  There are two test
vectors for each message length, but they also have the same key length.  That
provides little additional test coverage over having just half the test vectors.
It would be better to use different key lengths within each pair.  Maybe always
use klen=32 for one test vector, and randomly choose klen=16 or klen=24 for the
other test vector.  The overall point is: we can't test a zillion test vectors,
so we should make sure to get as most test coverage as possible with the smaller
set that will actually be included.

- Eric
