Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94FFC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 07:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbiCVHCV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 03:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237151AbiCVHCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 03:02:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2D221A4
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 00:00:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1332FCE1CB1
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 07:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A83C340EC;
        Tue, 22 Mar 2022 07:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647932447;
        bh=yUcgnO83m6wpw6WaeePnlqcDePF0XZJ7jRcIVZ2+Jbg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iOwjqVf1C2VN85JgSPne9cK3Q/5CbqGi0QU3tQriKAMeAPh3VllB2ePZjxNK3RdWA
         mB8K5Sh6OaIoHL2lIgRTaAbvdrxb148iGPKMSH8aAT7bSe1QXdcjM06ZGOTcdxIqNb
         NjZULbEMnls4SJUquZOswP3vy6tDP6g9hKTFom6tZePkqL/Q3KdclPySL/cjJmrb+b
         AkpsoZ81JHC2IwoeoFdBHdw1ofb1VoVUl9Kfn54uMD/B+lHxXyFVjHsR7WOGbSO6ZD
         IBTDW+R4wMnKOXjZSIMFcfuIl2MXKpdICp8E6C54rMsIMzCtSKFlsKFZ3IaCvAuU1o
         y2qdajpMhe4Fg==
Date:   Tue, 22 Mar 2022 00:00:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 3/8] crypto: hctr2 - Add HCTR2 support
Message-ID: <Yjl0HeuCyFx8BdH3@sol.localdomain>
References: <20220315230035.3792663-1-nhuck@google.com>
 <20220315230035.3792663-4-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315230035.3792663-4-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 15, 2022 at 11:00:30PM +0000, Nathan Huckleberry wrote:
> +struct hctr2_tfm_ctx {
> +	struct crypto_cipher *blockcipher;
> +	struct crypto_skcipher *xctr;
> +	struct crypto_shash *polyval;
> +	u8 L[BLOCKCIPHER_BLOCK_SIZE];
> +};

How about adding a comment at the end of the struct above that says that the
struct is followed by the two exported_length_digests?  (Or hashed_tweaklen,
which is the name suggested in my suggested helper functions below?)

> +
> +struct hctr2_request_ctx {
> +	u8 first_block[BLOCKCIPHER_BLOCK_SIZE];
> +	u8 xctr_iv[BLOCKCIPHER_BLOCK_SIZE];
> +	struct scatterlist *bulk_part_dst;
> +	struct scatterlist *bulk_part_src;
> +	struct scatterlist sg_src[2];
> +	struct scatterlist sg_dst[2];
> +	/* Sub-requests, must be last */
> +	union {
> +		struct shash_desc hash_desc;
> +		struct skcipher_request xctr_req;
> +	} u;
> +};

Likewise above for the hashed tweak.

Also how about adding inline functions or macros that return these new fields,
so that the arithmetic to find them doesn't have to be duplicated in the code?
The 'exported_length_digests' array local variables are a bit weird.  Maybe just
use some helper functions directly to get at the fields?

How about:

static inline u8 *hctr2_hashed_tweaklen(const struct hctr2_tfm_ctx *tctx,
                                        bool odd)
{
        u8 *p = (u8 *)tctx + sizeof(*tctx);

        if (odd) /* For messages not a multiple of block length */
                p += crypto_shash_statesize(tctx->polyval);
        return p;
}

static inline u8 *hctr2_hashed_tweak(const struct hctr2_tfm_ctx *tctx,
                                     struct hctr2_request_ctx *rctx)
{
        return (u8 *)rctx + tctx->hashed_tweak_offset;
}

> +static int hctr2_setkey(struct crypto_skcipher *tfm, const u8 *key,
> +			unsigned int keylen)
> +{
> +	struct hctr2_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
> +	u8 hbar[BLOCKCIPHER_BLOCK_SIZE];
> +	__le64 tweak_length_block[2];
> +	void *exported_length_digests[2];
> +	SHASH_DESC_ON_STACK(shash, tfm->polyval);
> +	int err;
> +
> +	exported_length_digests[0] = (u8 *)tctx + sizeof(*tctx);
> +	exported_length_digests[1] = (u8 *)tctx + sizeof(*tctx) +
> +				     crypto_shash_descsize(tctx->polyval);

The size needed by crypto_shash_export() is crypto_shash_statesize(), not
crypto_shash_descsize().  They happen to be the same with all polyval
implementations you've proposed, but it's not guaranteed for shash algorithms in
general.

> +	crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
> +	crypto_cipher_set_flags(tctx->blockcipher,
> +				crypto_skcipher_get_flags(tfm) &
> +				CRYPTO_TFM_REQ_MASK);
> +	err = crypto_cipher_setkey(tctx->blockcipher, key, keylen);
> +	if (err)
> +		return err;
> +
> +	crypto_skcipher_clear_flags(tctx->xctr, CRYPTO_TFM_REQ_MASK);
> +	crypto_skcipher_set_flags(tctx->xctr,
> +				  crypto_skcipher_get_flags(tfm) &
> +				  CRYPTO_TFM_REQ_MASK);
> +	err = crypto_skcipher_setkey(tctx->xctr, key, keylen);
> +	if (err)
> +		return err;
> +
> +	memset(tctx->L, 0, sizeof(tctx->L));
> +	memset(hbar, 0, sizeof(hbar));
> +	tctx->L[0] = 0x01;
> +	crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);
> +	crypto_cipher_encrypt_one(tctx->blockcipher, hbar, hbar);
> +
> +	crypto_shash_clear_flags(tctx->polyval, CRYPTO_TFM_REQ_MASK);
> +	crypto_shash_set_flags(tctx->polyval, crypto_skcipher_get_flags(tfm) &
> +			       CRYPTO_TFM_REQ_MASK);
> +	err = crypto_shash_setkey(tctx->polyval, hbar, BLOCKCIPHER_BLOCK_SIZE);
> +	if (err)
> +		return err;
> +	memzero_explicit(hbar, sizeof(hbar));
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
> +	err = crypto_shash_export(shash, exported_length_digests[0]);
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
> +	return crypto_shash_export(shash, exported_length_digests[1]);
> +}

hctr2_setkey() is getting pretty long.  How about splitting the tweak length
pre-hashing into a helper function?

Also, a comment that explains why the tweak length is being pre-hashed, and why
it *can* be pre-hashed, would be helpful.  Note that it is only possible because
this implementation only supports one tweak length.

- Eric
