From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v7 25/28] crypto: port Poly1305 to Zinc
Date: Mon, 8 Oct 2018 16:21:00 -0700
Message-ID: <20181008232059.GA164708@gmail.com>
References: <20181006025709.4019-1-Jason@zx2c4.com>
 <20181006025709.4019-26-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181006025709.4019-26-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 06, 2018 at 04:57:06AM +0200, Jason A. Donenfeld wrote:
> diff --git a/crypto/poly1305_zinc.c b/crypto/poly1305_zinc.c
> new file mode 100644
> index 000000000000..4794442edf26
> --- /dev/null
> +++ b/crypto/poly1305_zinc.c
> @@ -0,0 +1,98 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * Copyright (C) 2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#include <crypto/algapi.h>
> +#include <crypto/internal/hash.h>
> +#include <zinc/poly1305.h>
> +#include <linux/crypto.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/simd.h>
> +
> +struct poly1305_desc_ctx {
> +	struct poly1305_ctx ctx;
> +	u8 key[POLY1305_KEY_SIZE];
> +	unsigned int rem_key_bytes;
> +};
> +
> +static int crypto_poly1305_init(struct shash_desc *desc)
> +{
> +	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
> +	dctx->rem_key_bytes = POLY1305_KEY_SIZE;
> +	return 0;
> +}
> +
> +static int crypto_poly1305_update(struct shash_desc *desc, const u8 *src,
> +				  unsigned int srclen)
> +{
> +	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
> +	simd_context_t simd_context;
> +
> +	if (unlikely(dctx->rem_key_bytes)) {
> +		unsigned int key_bytes = min(srclen, dctx->rem_key_bytes);
> +		memcpy(dctx->key + (POLY1305_KEY_SIZE - dctx->rem_key_bytes),
> +		       src, key_bytes);
> +		src += key_bytes;
> +		srclen -= key_bytes;
> +		dctx->rem_key_bytes -= key_bytes;
> +		if (!dctx->rem_key_bytes) {
> +			poly1305_init(&dctx->ctx, dctx->key);
> +			memzero_explicit(dctx->key, sizeof(dctx->key));
> +		}
> +		if (!srclen)
> +			return 0;
> +	}
> +
> +	simd_get(&simd_context);
> +	poly1305_update(&dctx->ctx, src, srclen, &simd_context);
> +	simd_put(&simd_context);
> +
> +	return 0;
> +}
> +
> +static int crypto_poly1305_final(struct shash_desc *desc, u8 *dst)
> +{
> +	struct poly1305_desc_ctx *dctx = shash_desc_ctx(desc);
> +	simd_context_t simd_context;
> +
> +	simd_get(&simd_context);
> +	poly1305_final(&dctx->ctx, dst, &simd_context);
> +	simd_put(&simd_context);
> +	return 0;
> +}

This crashes on very short inputs.  crypto_poly1305_final() is missing:

	if (dctx->rem_key_bytes)
		return -ENOKEY;

- Eric
