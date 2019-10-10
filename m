Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0642C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 22:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F00820B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 22:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570745526;
	bh=JbNb5inZRvoXzs5hBJ/TDurRanaJpHBWZkdiJDO0mnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=kCZepXeiNFFRMt42xJowofVeX0PDLZyCdEQbmAJDEbpUCRcp2Ja2IJN/yG49MIwZB
	 wQpeyz1ndAr9tasEZTxsNJXPA0P7XQPWL5i9wrEKl/lb6+hE/1O5/QTez9rVWfNMMH
	 AnCzCAj31tQAlq5YSl+pVkHRYP8wltsuoi2J7cQ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfJJWMF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 18:12:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfJJWMF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 18:12:05 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93FF120B7C;
        Thu, 10 Oct 2019 22:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570745523;
        bh=JbNb5inZRvoXzs5hBJ/TDurRanaJpHBWZkdiJDO0mnA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FonJftMDt6uV2kWWKrwmMlr0KbMZb3SuN8WjewY2JlBUmcj/SV+IBAi2SokoM7mBo
         lDzA3rdvCjW2mRZIq/NZpQ4JKjZOrC3NHo8nw1Wshm1zhm3YNaKhBGpl0EkMfth65F
         oBBbZjHhvbsZ20pRK3eyr9JL9HrjleQLjdpMmcuE=
Date:   Thu, 10 Oct 2019 15:12:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH v3] crypto: add blake2b generic implementation
Message-ID: <20191010221200.GB143518@gmail.com>
Mail-Followup-To: David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7f46def436c2c705c0b2cac3324f817efa4717d.1570715842.git.dsterba@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi David, thanks for working on this.  Comments below.

On Thu, Oct 10, 2019 at 04:10:05PM +0200, David Sterba wrote:
> The patch brings support of several BLAKE2 variants (2b with various
> digest lengths).  The keyed digest is supported, using tfm->setkey call.
> The in-tree user will be btrfs (for checksumming), we're going to use
> the BLAKE2b-256 variant.
> 
> The code is reference implementation taken from the official sources and
> modified only in terms of kernel coding style (whitespace, comments,
> uintXX_t -> uXX types, removed unused prototypes and #ifdefs, removed
> testing code, changed secure_zero_memory -> memzero_explicit, used own
> helpers for unaligned reads/writes and rotations).
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> V3:
> 
> - added 'static' to blake2b_* and removed .h declarations
> - updated Kconfig help text
> - replaced custom build bug check with BUILD_BUG_ON
> 
> - added .setkey to TFM, optional key, the length validation is same as
>   what blake2b_init_key accepts, ie. 1..BLAKE2B_KEYBYTES
> 
> - fixed a serious bug: digestsize in all callbacks must be obtained from
>   TFM, as the same functions are used for all variants but the default
>   output size was used (in digest_init, digest_final, digest_finup),
> 
> I'm going to do the selftests next so the above can't happen again.

The test vectors should be included in this patch.

> +
> +	  - blake2b     - the default 512b digest
> +	  - blake2b-160
> +	  - blake2b-256
> +	  - blake2b-384
> +	  - blake2b-512
> +

Why have the "blake2b" algorithm at all, when it's already available under the
name "blake2b-512"?  It's confusing to have two different names for the same
algorithm because then people will need to decide which one to use, and both
will need to be tested.

> diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
> new file mode 100644
> index 000000000000..588f2c5daa2d
> --- /dev/null
> +++ b/crypto/blake2b_generic.c
> @@ -0,0 +1,504 @@
> +// SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0)
> +/*
> + * BLAKE2b reference source code package - reference C implementations
> + *
> + * Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under the
> + * terms of the CC0, the OpenSSL Licence, or the Apache Public License 2.0, at
> + * your option.  The terms of these licenses can be found at:
> + *
> + * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
> + * - OpenSSL license   : https://www.openssl.org/source/license.html
> + * - Apache 2.0        : http://www.apache.org/licenses/LICENSE-2.0
> + *
> + * More information about the BLAKE2 hash function can be found at
> + * https://blake2.net.
> + */
> +
> +#include <asm/unaligned.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/kernel.h>
> +#include <linux/bitops.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/blake2b.h>
> +
> +struct blake2b_param
> +{
> +	u8  digest_length; /* 1 */
> +	u8  key_length;    /* 2 */
> +	u8  fanout;        /* 3 */
> +	u8  depth;         /* 4 */
> +	u32 leaf_length;   /* 8 */
> +	u32 node_offset;   /* 12 */
> +	u32 xof_length;    /* 16 */

The u32 fields need to be __le32, since this struct is interpreted as an array
of bytes.

> +static int blake2b_init(struct blake2b_state *S, size_t outlen)
> +{
> +	struct blake2b_param P[1];

This shouldn't be an array.

> +
> +	if ((!outlen) || (outlen > BLAKE2B_OUTBYTES))
> +		return -1;

No need for these checks, since this patch doesn't provide any way for the user
to set an arbitrary outlen.  They should either be removed, or replaced with a
WARN_ON().  As-is, it looks like a valid error, which is bad because some
callers of the crypto_shash API don't handle errors.

> +
> +	P->digest_length = (u8)outlen;
> +	P->key_length    = 0;
> +	P->fanout        = 1;
> +	P->depth         = 1;
> +	put_unaligned_le32(0, &P->leaf_length);
> +	put_unaligned_le32(0, &P->node_offset);
> +	put_unaligned_le32(0, &P->xof_length);

struct blake2b_param is already a packed structure, so these should be direct
assignments.  No need for put_unaligned_le32().

> +	P->node_depth    = 0;
> +	P->inner_length  = 0;
> +	memset(P->reserved, 0, sizeof(P->reserved));
> +	memset(P->salt,     0, sizeof(P->salt));
> +	memset(P->personal, 0, sizeof(P->personal));
> +	return blake2b_init_param(S, P);
> +}
> +
> +static int blake2b_init_key(struct blake2b_state *S, size_t outlen,
> +			 const void *key, size_t keylen)
> +{
> +	struct blake2b_param P[1];
> +
> +	if ((!outlen) || (outlen > BLAKE2B_OUTBYTES))
> +		return -1;
> +
> +	if (!key || !keylen || keylen > BLAKE2B_KEYBYTES)
> +		return -1;

More unclear error checks here.  Which are actually valid reachable errors, and
which are assertions that should never trigger?  See comment above.

> +
> +	P->digest_length = (u8)outlen;
> +	P->key_length    = (u8)keylen;
> +	P->fanout        = 1;
> +	P->depth         = 1;
> +	put_unaligned_le32(0, &P->leaf_length);
> +	put_unaligned_le32(0, &P->node_offset);
> +	put_unaligned_le32(0, &P->xof_length);

Same problem with the unnecessary put_unaligned_le32().

> +static int blake2b_final(struct blake2b_state *S, void *out, size_t outlen)
> +{
> +	u8 buffer[BLAKE2B_OUTBYTES] = {0};
> +	size_t i;
> +
> +	if (out == NULL || outlen < S->outlen)
> +		return -1;

More unnecessary error checks.  None of the other hash algorithms check for a
NULL output buffer, and some users don't check for errors.  So returning -1
instead of just crashing could hide bugs.

> +
> +	if (blake2b_is_lastblock(S))
> +		return -1;

This can't be the case because lastblock is only set by final().

> +static int digest_setkey(struct crypto_shash *tfm, const u8 *key,
> +			 unsigned int keylen)
> +{
> +	struct digest_tfm_ctx *mctx = crypto_shash_ctx(tfm);
> +
> +	if (keylen == 0 || keylen > BLAKE2B_KEYBYTES) {
> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -EINVAL;
> +	}
> +
> +	memcpy(mctx->key, key, BLAKE2B_KEYBYTES);
> +	mctx->keylen = keylen;
> +
> +	return 0;
> +}

This reads past the end of the key buffer if keylen < BLAKE2B_KEYBYTES.

Please add tests and run with CONFIG_KASAN=y.

> +static int digest_update(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length)
> +{
> +	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
> +	int ret;
> +
> +	ret = blake2b_update(ctx->S, data, length);
> +	if (ret)
> +		return -EINVAL;
> +	return 0;
> +}

Why does update() need to fail?  Not all shash API users check for errors.

> +
> +static int digest_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
> +	const int digestsize = crypto_shash_digestsize(desc->tfm);
> +	int ret;
> +
> +	ret = blake2b_final(ctx->S, out, digestsize);
> +	if (ret)
> +		return -EINVAL;
> +	return 0;
> +}

Likewise.  Why does final() need to fail?

> +
> +static int digest_finup(struct shash_desc *desc, const u8 *data,
> +			unsigned int len, u8 *out)
> +{
> +	struct digest_desc_ctx *ctx = shash_desc_ctx(desc);
> +	const int digestsize = crypto_shash_digestsize(desc->tfm);
> +	int ret;
> +
> +	ret = blake2b_update(ctx->S, data, len);
> +	if (ret)
> +		return -EINVAL;
> +	ret = blake2b_final(ctx->S, out, digestsize);
> +	if (ret)
> +		return -EINVAL;
> +	return 0;
> +}

finup() shouldn't be implemented if it can't be made more efficient than
update() and final() separately.

> +static int blake2b_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct digest_tfm_ctx *mctx = crypto_tfm_ctx(tfm);
> +
> +	/* Use the unkeyed version by default */
> +	memset(mctx->key, 0, BLAKE2B_KEYBYTES);
> +	mctx->keylen = 0;
> +
> +	return 0;
> +}

No need for this function, since the tfm_ctx starts out zeroed by default.

> +static struct shash_alg blake2b_algs[] = {
> +	{
> +		.digestsize		= BLAKE2B_512_DIGEST_SIZE,
> +		.setkey			= digest_setkey,
> +		.init			= digest_init,
> +		.update			= digest_update,
> +		.final			= digest_final,
> +		.finup			= digest_finup,
> +		.descsize		= sizeof(struct digest_desc_ctx),
> +		.base.cra_name		= "blake2b",
> +		.base.cra_driver_name	= "blake2b-generic",
> +		.base.cra_priority	= 100,
> +		.base.cra_flags		= CRYPTO_ALG_OPTIONAL_KEY,
> +		.base.cra_blocksize	= BLAKE2B_BLOCKBYTES,
> +		.base.cra_ctxsize	= 0,

Need to set cra_ctxsize to sizeof(struct digest_tfm_ctx), otherwise the code is
using an area beyond the end of the buffer for the tfm_ctx.  This would have
been caught if there were self tests and they were run with CONFIG_KASAN=y.

Thanks!

- Eric
