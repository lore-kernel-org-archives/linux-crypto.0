From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v6 21/23] crypto: port ChaCha20 to Zinc
Date: Tue, 2 Oct 2018 22:56:00 -0700
Message-ID: <20181003055559.GA745@sol.localdomain>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-22-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180925145622.29959-22-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 25, 2018 at 04:56:20PM +0200, Jason A. Donenfeld wrote:
> diff --git a/crypto/chacha20_zinc.c b/crypto/chacha20_zinc.c
> new file mode 100644
> index 000000000000..f7d70b3efc31
> --- /dev/null
> +++ b/crypto/chacha20_zinc.c
> @@ -0,0 +1,90 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * Copyright (C) 2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#include <asm/unaligned.h>
> +#include <crypto/algapi.h>
> +#include <crypto/internal/skcipher.h>
> +#include <zinc/chacha20.h>
> +#include <linux/module.h>
> +
> +static int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
> +				  unsigned int keysize)
> +{
> +	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +	if (keysize != CHACHA20_KEY_SIZE)
> +		return -EINVAL;
> +	chacha20_init(ctx, key, 0);
> +	return 0;
> +}
> +
> +static int crypto_chacha20_crypt(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct chacha20_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_walk walk;
> +	simd_context_t simd_context;
> +	int err, i;
> +
> +	err = skcipher_walk_virt(&walk, req, true);
> +	if (unlikely(err))
> +		return err;
> +
> +	for (i = 0; i < ARRAY_SIZE(ctx->counter); ++i)
> +		ctx->counter[i] = get_unaligned_le32(walk.iv + i * sizeof(u32));
> +

Multiple threads may use the same tfm concurrently, so the tfm context must not
be used to store per-request information such as the IV.

- Eric
