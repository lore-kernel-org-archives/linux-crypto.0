From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v5 12/20] zinc: BLAKE2s generic C implementation
 and selftest
Date: Tue, 18 Sep 2018 17:41:33 -0700
Message-ID: <20180919004132.GB74746@gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com>
 <20180918161646.19105-13-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180918161646.19105-13-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 18, 2018 at 06:16:38PM +0200, Jason A. Donenfeld wrote:
> The C implementation was originally based on Samuel Neves' public
> domain reference implementation but has since been heavily modified
> for the kernel. We're able to do compile-time optimizations by moving
> some scaffolding around the final function into the header file.
> 
> Information: https://blake2.net/
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Samuel Neves <sneves@dei.uc.pt>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
> ---
>  include/zinc/blake2s.h      |   95 ++
>  lib/zinc/Kconfig            |    3 +
>  lib/zinc/Makefile           |    3 +
>  lib/zinc/blake2s/blake2s.c  |  301 +++++
>  lib/zinc/selftest/blake2s.h | 2095 +++++++++++++++++++++++++++++++++++
>  5 files changed, 2497 insertions(+)
>  create mode 100644 include/zinc/blake2s.h
>  create mode 100644 lib/zinc/blake2s/blake2s.c
>  create mode 100644 lib/zinc/selftest/blake2s.h
> 
> diff --git a/include/zinc/blake2s.h b/include/zinc/blake2s.h
> new file mode 100644
> index 000000000000..951281596274
> --- /dev/null
> +++ b/include/zinc/blake2s.h
> @@ -0,0 +1,95 @@
> +/* SPDX-License-Identifier: MIT
> + *
> + * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#ifndef _ZINC_BLAKE2S_H
> +#define _ZINC_BLAKE2S_H
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <crypto/algapi.h>
> +
> +enum blake2s_lengths {
> +	BLAKE2S_BLOCKBYTES = 64,
> +	BLAKE2S_OUTBYTES = 32,
> +	BLAKE2S_KEYBYTES = 32
> +};
> +
> +struct blake2s_state {
> +	u32 h[8];
> +	u32 t[2];
> +	u32 f[2];
> +	u8 buf[BLAKE2S_BLOCKBYTES];
> +	size_t buflen;
> +	u8 last_node;
> +};
> +
> +void blake2s_init(struct blake2s_state *state, const size_t outlen);
> +void blake2s_init_key(struct blake2s_state *state, const size_t outlen,
> +		      const void *key, const size_t keylen);
> +void blake2s_update(struct blake2s_state *state, const u8 *in, size_t inlen);
> +void __blake2s_final(struct blake2s_state *state);
> +static inline void blake2s_final(struct blake2s_state *state, u8 *out,
> +				 const size_t outlen)
> +{
> +	int i;
> +
> +#ifdef DEBUG
> +	BUG_ON(!out || !outlen || outlen > BLAKE2S_OUTBYTES);
> +#endif
> +	__blake2s_final(state);
> +
> +	if (__builtin_constant_p(outlen) && !(outlen % sizeof(u32))) {
> +		if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) ||
> +		    IS_ALIGNED((unsigned long)out, __alignof__(u32))) {
> +			__le32 *outwords = (__le32 *)out;
> +
> +			for (i = 0; i < outlen / sizeof(u32); ++i)
> +				outwords[i] = cpu_to_le32(state->h[i]);
> +		} else {
> +			__le32 buffer[BLAKE2S_OUTBYTES];

This buffer is 4 times too long.

> +
> +			for (i = 0; i < outlen / sizeof(u32); ++i)
> +				buffer[i] = cpu_to_le32(state->h[i]);
> +			memcpy(out, buffer, outlen);
> +			memzero_explicit(buffer, sizeof(buffer));
> +		}
> +	} else {
> +		u8 buffer[BLAKE2S_OUTBYTES] __aligned(__alignof__(u32));
> +		__le32 *outwords = (__le32 *)buffer;
> +
> +		for (i = 0; i < 8; ++i)
> +			outwords[i] = cpu_to_le32(state->h[i]);
> +		memcpy(out, buffer, outlen);
> +		memzero_explicit(buffer, sizeof(buffer));
> +	}
> +
> +	memzero_explicit(state, sizeof(*state));
> +}

Or how about something much simpler:

static inline void blake2s_final(struct blake2s_state *state, u8 *out,
				 const size_t outlen)
{
#ifdef DEBUG
	BUG_ON(!out || !outlen || outlen > BLAKE2S_OUTBYTES);
#endif
	__blake2s_final(state);

	cpu_to_le32_array(state->h, ARRAY_SIZE(state->h));
	memcpy(out, state->h, outlen);

	memzero_explicit(state, sizeof(*state));
}
