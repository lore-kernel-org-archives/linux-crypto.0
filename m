Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DE2D530
	for <linux-crypto@vger.kernel.org>; Sun, 27 Apr 2025 01:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745717072; cv=none; b=bsCNi7D7UKQI9rX0o9s89WVAcrFVzDq94hbCm0uUM9WSwmLhJe/CtbJio0YEcebrPCxC7uozWbXvsf4wVGJApnIMy8bF6Kxmx9D0VqTiEZMZHWrYVRsRHmKpIMSoOj3UEsV+qI35wVrJPcxmX6XnpwqbfjONOdE6l5TE3kMxpb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745717072; c=relaxed/simple;
	bh=eEjQllRVFnX5WxK+P6ReR82qkgzC9xWvp+nGoxUB9xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EpUVeBJva1AyBTujAXXnqQQAOAeklczDB6x6JYs3n2HXGzTwCddmddoV6mGEl1UkEAXx5PixdW6q43PT5Q8WV+7hAfk5FT4u05JlhOr5jxSDyO010Yz3uwzqjyT77CG57CWMfT1oP6OigrRsW7XWiqTDGfXEHRQVyEbxoy1Gucc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSroCSEo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSroCSEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2760C4CEE2;
	Sun, 27 Apr 2025 01:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745717072;
	bh=eEjQllRVFnX5WxK+P6ReR82qkgzC9xWvp+nGoxUB9xQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VSroCSEo/B7FOUcssaTTSTzoo0qtbdJWiqqqsZs/cQyPsv7O3QVBqXrIDaChj2tvB
	 lr+XyGFCug+Rr1wwUVHRfuzwp+dlr742mWVnz1oiMobzE9TndGUIpEjDRpijd4W4X0
	 hUL+Y+tzAMMGEnc1YaBz1EcUfwTXoGUoHR5dcXrJUxNBSXZn9lUN8jj5YxoFj61gvE
	 JA2CZrzdbfRrgQfFAFaBd1lLi6Xv6LIObInXd/6znfEICxE9XQHtQneFn0mcxLJ8tt
	 whMlxt5oM9dlXwG40pc5WNWFMwvdfit7t3VViu853aZTxezSYF9Nvp/gYGBUpVuozq
	 PuFJUO5IeXe8w==
Date: Sat, 26 Apr 2025 18:24:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH 01/11] crypto: lib/sha256 - Move partial block
 handling out
Message-ID: <20250427012436.GD68006@quark>
References: <cover.1745714715.git.herbert@gondor.apana.org.au>
 <1c0e3c751c836db7999c8e95ca30d7546b1b2355.1745714715.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c0e3c751c836db7999c8e95ca30d7546b1b2355.1745714715.git.herbert@gondor.apana.org.au>

On Sun, Apr 27, 2025 at 08:59:59AM +0800, Herbert Xu wrote:
> Extract the common partial block handling into a helper macro
> that can be reused by other library code.
> 
> Also delete the unused sha256_base_do_finalize function.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  include/crypto/internal/blockhash.h | 52 +++++++++++++++++++++++++++++
>  include/crypto/sha2.h               |  9 +++--
>  include/crypto/sha256_base.h        | 38 ++-------------------
>  3 files changed, 62 insertions(+), 37 deletions(-)
>  create mode 100644 include/crypto/internal/blockhash.h
> 
> diff --git a/include/crypto/internal/blockhash.h b/include/crypto/internal/blockhash.h
> new file mode 100644
> index 000000000000..4184e2337d68
> --- /dev/null
> +++ b/include/crypto/internal/blockhash.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Handle partial blocks for block hash.
> + *
> + * Copyright (c) 2015 Linaro Ltd <ard.biesheuvel@linaro.org>
> + * Copyright (c) 2025 Herbert Xu <herbert@gondor.apana.org.au>
> + */
> +
> +#ifndef _CRYPTO_INTERNAL_BLOCKHASH_H
> +#define _CRYPTO_INTERNAL_BLOCKHASH_H
> +
> +#include <linux/string.h>
> +#include <linux/types.h>
> +
> +#define BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, dv, buf,	\
> +			       buflen)					\
> +	({								\
> +		unsigned int _nbytes = (nbytes);			\
> +		unsigned int _buflen = (buflen);			\
> +		typeof(block) _block = (block);				\
> +		typeof(state) _state = (state); 			\
> +		unsigned int _bs = (bs);				\
> +		unsigned int _dv = (dv);				\
> +		const u8 *_src = (src);					\
> +		u8 *_buf = (buf);					\
> +		while ((_buflen + _nbytes) >= _bs) {			\
> +			unsigned int len = _nbytes;			\
> +			const u8 *data = _src;				\
> +			int blocks, remain;				\
> +			if (_buflen) {					\
> +				remain = _bs - _buflen;			\
> +				memcpy(_buf + _buflen, _src, remain);	\
> +				data = _buf;				\
> +				len = _bs;				\
> +			}						\
> +			remain = len % bs;				\
> +			blocks = (len - remain) / _dv;			\
> +			_block(_state, data, blocks);			\
> +			_src += len - remain - _buflen;			\
> +			_nbytes -= len - remain - _buflen;		\
> +			_buflen = 0;					\
> +		}							\
> +		memcpy(_buf + _buflen, _src, _nbytes);			\
> +		_buflen += _nbytes;					\
> +	})
> +
> +#define BLOCK_HASH_UPDATE(block, state, src, nbytes, bs, buf, buflen) \
> +	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, 1, buf, buflen)
> +#define BLOCK_HASH_UPDATE_BLOCKS(block, state, src, nbytes, bs, buf, buflen) \
> +	BLOCK_HASH_UPDATE_BASE(block, state, src, nbytes, bs, bs, buf, buflen)

Again, these pointless macros just obfuscate things.  And there's no reason to
still be futzing around with SHA-256 when my patchset reworks it anyway.

- Eric
