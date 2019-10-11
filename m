Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7B3C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 12:04:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8285F2190F
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 12:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbfJKMEY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 08:04:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:42110 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727198AbfJKMEY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 08:04:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 72C19AFA9;
        Fri, 11 Oct 2019 12:04:21 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29BE2DA7FF; Fri, 11 Oct 2019 14:04:35 +0200 (CEST)
Date:   Fri, 11 Oct 2019 14:04:35 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>, linux-crypto@vger.kernel.org,
        ard.biesheuvel@linaro.org, ebiggers@google.com
Subject: Re: [PATCH v3] crypto: add blake2b generic implementation
Message-ID: <20191011120434.GC2751@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org,
        ebiggers@google.com
References: <e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com>
 <20191010221200.GB143518@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010221200.GB143518@gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 10, 2019 at 03:12:02PM -0700, Eric Biggers wrote:
> > I'm going to do the selftests next so the above can't happen again.
> 
> The test vectors should be included in this patch.
> 
> > +
> > +	  - blake2b     - the default 512b digest
> > +	  - blake2b-160
> > +	  - blake2b-256
> > +	  - blake2b-384
> > +	  - blake2b-512
> > +
> 
> Why have the "blake2b" algorithm at all, when it's already available under the
> name "blake2b-512"?  It's confusing to have two different names for the same
> algorithm because then people will need to decide which one to use, and both
> will need to be tested.

The idea is that 'blake2b' is a convenience alias for the default digest
size, as it is commonly referred. But I agree it's can cause some
confusion, so I'll remove it.

> > +struct blake2b_param
> > +{
> > +	u8  digest_length; /* 1 */
> > +	u8  key_length;    /* 2 */
> > +	u8  fanout;        /* 3 */
> > +	u8  depth;         /* 4 */
> > +	u32 leaf_length;   /* 8 */
> > +	u32 node_offset;   /* 12 */
> > +	u32 xof_length;    /* 16 */
> 
> The u32 fields need to be __le32, since this struct is interpreted as an array
> of bytes.

For this and several other comments: I tried to minimize changes to the
the reference implementation, not to introduce bugs or remove code that
should be there, unless requested by a reviewer. I hope you understand
that and don't mind.

> > +static int blake2b_init(struct blake2b_state *S, size_t outlen)
> > +{
> > +	struct blake2b_param P[1];
> 
> This shouldn't be an array.

Copied from the original, will switch to simple variable.

> > +	if ((!outlen) || (outlen > BLAKE2B_OUTBYTES))
> > +		return -1;
> 
> No need for these checks, since this patch doesn't provide any way for the user
> to set an arbitrary outlen.  They should either be removed, or replaced with a
> WARN_ON().  As-is, it looks like a valid error, which is bad because some
> callers of the crypto_shash API don't handle errors.

I see and will remove it.

> > +	P->digest_length = (u8)outlen;
> > +	P->key_length    = 0;
> > +	P->fanout        = 1;
> > +	P->depth         = 1;
> > +	put_unaligned_le32(0, &P->leaf_length);
> > +	put_unaligned_le32(0, &P->node_offset);
> > +	put_unaligned_le32(0, &P->xof_length);
> 
> struct blake2b_param is already a packed structure, so these should be direct
> assignments.  No need for put_unaligned_le32().
> 
> > +	P->node_depth    = 0;
> > +	P->inner_length  = 0;
> > +	memset(P->reserved, 0, sizeof(P->reserved));
> > +	memset(P->salt,     0, sizeof(P->salt));
> > +	memset(P->personal, 0, sizeof(P->personal));
> > +	return blake2b_init_param(S, P);
> > +}
> > +
> > +static int blake2b_init_key(struct blake2b_state *S, size_t outlen,
> > +			 const void *key, size_t keylen)
> > +{
> > +	struct blake2b_param P[1];
> > +
> > +	if ((!outlen) || (outlen > BLAKE2B_OUTBYTES))
> > +		return -1;
> > +
> > +	if (!key || !keylen || keylen > BLAKE2B_KEYBYTES)
> > +		return -1;
> 
> More unclear error checks here.  Which are actually valid reachable errors, and
> which are assertions that should never trigger?  See comment above.
> 
> > +
> > +	P->digest_length = (u8)outlen;
> > +	P->key_length    = (u8)keylen;
> > +	P->fanout        = 1;
> > +	P->depth         = 1;
> > +	put_unaligned_le32(0, &P->leaf_length);
> > +	put_unaligned_le32(0, &P->node_offset);
> > +	put_unaligned_le32(0, &P->xof_length);
> 
> Same problem with the unnecessary put_unaligned_le32().
> 
> > +static int blake2b_final(struct blake2b_state *S, void *out, size_t outlen)
> > +{
> > +	u8 buffer[BLAKE2B_OUTBYTES] = {0};
> > +	size_t i;
> > +
> > +	if (out == NULL || outlen < S->outlen)
> > +		return -1;
> 
> More unnecessary error checks.  None of the other hash algorithms check for a
> NULL output buffer, and some users don't check for errors.  So returning -1
> instead of just crashing could hide bugs.

Yeah, removing the checks will allow to remove return values.

> > +	if (blake2b_is_lastblock(S))
> > +		return -1;
> 
> This can't be the case because lastblock is only set by final().
> 
> > +static int digest_setkey(struct crypto_shash *tfm, const u8 *key,
> > +			 unsigned int keylen)
> > +{
> > +	struct digest_tfm_ctx *mctx = crypto_shash_ctx(tfm);
> > +
> > +	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES) {
> > +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > +		return -EINVAL;
> > +	}
> > +
> > +	memcpy(mctx->key, key, BLAKE2B_KEYBYTES);
> > +	mctx->keylen = keylen;
> > +
> > +	return 0;
> > +}
> 
> This reads past the end of the key buffer if keylen < BLAKE2B_KEYBYTES.
> 
> Please add tests and run with CONFIG_KASAN=y.

Right, I'll fix it. The selftests did not catch this because all of them
used the maximum key length.

> > +static int digest_update(struct shash_desc *desc, const u8 *data,
> > +			 unsigned int length)
> > +{
> > +	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
> > +	int ret;
> > +
> > +	ret = blake2b_update(ctx->S, data, length);
> > +	if (ret)
> > +		return -EINVAL;
> > +	return 0;
> > +}
> 
> Why does update() need to fail?  Not all shash API users check for errors.
> 
> > +
> > +static int digest_final(struct shash_desc *desc, u8 *out)
> > +{
> > +	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
> > +	const int digestsize = crypto_shash_digestsize(desc->tfm);
> > +	int ret;
> > +
> > +	ret = blake2b_final(ctx->S, out, digestsize);
> > +	if (ret)
> > +		return -EINVAL;
> > +	return 0;
> > +}
> 
> Likewise.  Why does final() need to fail?
> 
> > +
> > +static int digest_finup(struct shash_desc *desc, const u8 *data,
> > +			unsigned int len, u8 *out)
> > +{
> > +	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
> > +	const int digestsize = crypto_shash_digestsize(desc->tfm);
> > +	int ret;
> > +
> > +	ret = blake2b_update(ctx->S, data, len);
> > +	if (ret)
> > +		return -EINVAL;
> > +	ret = blake2b_final(ctx->S, out, digestsize);
> > +	if (ret)
> > +		return -EINVAL;
> > +	return 0;
> > +}
> 
> finup() shouldn't be implemented if it can't be made more efficient than
> update() and final() separately.

Ok, will be removed.

> > +static int blake2b_cra_init(struct crypto_tfm *tfm)
> > +{
> > +	struct digest_tfm_ctx *mctx = crypto_tfm_ctx(tfm);
> > +
> > +	/* Use the unkeyed version by default */
> > +	memset(mctx->key, 0, BLAKE2B_KEYBYTES);
> > +	mctx->keylen = 0;
> > +
> > +	return 0;
> > +}
> 
> No need for this function, since the tfm_ctx starts out zeroed by default.

Ok, will be removed.

> > +static struct shash_alg blake2b_algs[] = {
> > +	{
> > +		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
> > +		.setkey			= digest_setkey,
> > +		.init			= digest_init,
> > +		.update			= digest_update,
> > +		.final			= digest_final,
> > +		.finup			= digest_finup,
> > +		.descsize		= sizeof(struct digest_desc_ctx),
> > +		.base.cra_name		= "blake2b",
> > +		.base.cra_driver_name	= "blake2b-generic",
> > +		.base.cra_priority	= 100,
> > +		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
> > +		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
> > +		.base.cra_ctxsize	= 0,
> 
> Need to set cra_ctxsize to sizeof(struct digest_tfm_ctx), otherwise the code is
> using an area beyond the end of the buffer for the tfm_ctx.  This would have
> been caught if there were self tests and they were run with CONFIG_KASAN=y.

I found it out the hard way, the sefltests caused memory overwrite,
caught by SLUB_DEBUG, but I did the KASAN pass as well, no further
problems found.

I'll spin v4, adding the test vectors. It'll be probably a series
because single patch I have now is over 400K in size, so we'd need one
more feedback round to decide what test values to include.

Thanks for the comments.
