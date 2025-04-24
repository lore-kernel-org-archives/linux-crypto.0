Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672831B414E
	for <linux-crypto@vger.kernel.org>; Thu, 24 Apr 2025 15:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745509281; cv=none; b=NEddn3i8kOdPz9GTUKZ2F9AGLp2sLma+txDqVf6DWyjNMaWBrGOGDybR2A6ag1BiZGDL6tr0AM8vMbA8fubTJnWQwvwuihBdRDKar70+DtkuJjpPm3D2m2bYHM/M4ar7ELDBQ3jl5ZWZXjLUNFtMySrBJcCm/rAUJLkw4Pu2jjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745509281; c=relaxed/simple;
	bh=0wMFKMOJTth0HrRy02xB2T4szT66xJ7fcycu09ukxx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kdh71cUgb4ZRLT8DGGJtSP/YEkvTp8hnnYkZhbBj1pBkKaF7JffCIKqhHqcQSVQoUY78dlex4izti5I/hthFu3mAdwoOt0O0LXhyyfPXrp54BcKx7c3px+PXpeE7I4GqyWvjUOmsnqtQIYE5kq0HEU0Fb3d896ZaYkmDDPDdBNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BCF5bDBo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BCF5bDBo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD69AC4CEE3;
	Thu, 24 Apr 2025 15:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745509280;
	bh=0wMFKMOJTth0HrRy02xB2T4szT66xJ7fcycu09ukxx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BCF5bDBo8hasaFK5uD2l2mkCnsf1ZooI63PIO0BnN2CIl9aDtVdJByIkSfV1RXP2H
	 VI804gxarm8qn5F0mpiPgVtfIKgyiKxHR0be5xtPJm4PlEv4fhq9gcTN10ms5iCZtK
	 0AvuWRcIrkt4Rv59c7JKvMtm5x2LitxR3kDenl949P/rMgJJI+xXcEKuPa2yT6YBx2
	 yPswaVEm3+5PdNQegAbYzqH0r9D8ej++0Fwsuh08TDlQr1HD9yXzQJuZcEYJSoE9C+
	 ueNch816XL9Kwdyg+KX7nicNa+WZ6TlhWItHdlvDAl1Oq9E1ytVmNdiYjKhT8d0co4
	 +5yQ0ddxWkQaw==
Date: Thu, 24 Apr 2025 08:41:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 01/15] crypto: lib/sha256 - Move partial block handling
 out
Message-ID: <20250424154119.GB2427@sol.localdomain>
References: <cover.1745490652.git.herbert@gondor.apana.org.au>
 <c57b8d9aa2c314378791cc130b7651d9a18f2637.1745490652.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c57b8d9aa2c314378791cc130b7651d9a18f2637.1745490652.git.herbert@gondor.apana.org.au>

On Thu, Apr 24, 2025 at 06:46:58PM +0800, Herbert Xu wrote:
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

Do we really have to have this random macro that obfuscates what is going on?

- Eric
