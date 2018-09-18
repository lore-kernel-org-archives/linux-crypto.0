From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v5 09/20] zinc: Poly1305 ARM and ARM64
 implementations
Date: Tue, 18 Sep 2018 15:55:53 -0700
Message-ID: <20180918225552.GA74746@gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com>
 <20180918161646.19105-10-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180918161646.19105-10-Jason@zx2c4.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 18, 2018 at 06:16:35PM +0200, Jason A. Donenfeld wrote:
> diff --git a/lib/zinc/poly1305/poly1305-arm-glue.h b/lib/zinc/poly1305/poly1305-arm-glue.h
> new file mode 100644
> index 000000000000..dd3fa5a38c62
> --- /dev/null
> +++ b/lib/zinc/poly1305/poly1305-arm-glue.h
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: MIT
> + *
> + * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> + */
> +
> +#include <asm/hwcap.h>
> +#include <asm/neon.h>
> +
> +asmlinkage void poly1305_init_arm(void *ctx, const u8 key[16]);
> +asmlinkage void poly1305_blocks_arm(void *ctx, const u8 *inp, const size_t len,
> +				    const u32 padbit);
> +asmlinkage void poly1305_emit_arm(void *ctx, u8 mac[16], const u32 nonce[4]);
> +#if IS_ENABLED(CONFIG_KERNEL_MODE_NEON) &&                                     \
> +	(defined(CONFIG_64BIT) || __LINUX_ARM_ARCH__ >= 7)
> +#define ARM_USE_NEON
> +asmlinkage void poly1305_blocks_neon(void *ctx, const u8 *inp, const size_t len,
> +				     const u32 padbit);
> +asmlinkage void poly1305_emit_neon(void *ctx, u8 mac[16], const u32 nonce[4]);
> +#endif
> +
> +static bool poly1305_use_neon __ro_after_init;
> +
> +static void __init poly1305_fpu_init(void)
> +{
> +#if defined(CONFIG_ARM64)
> +	poly1305_use_neon = elf_hwcap & HWCAP_ASIMD;
> +#elif defined(CONFIG_ARM)
> +	poly1305_use_neon = elf_hwcap & HWCAP_NEON;
> +#endif
> +}
> +
> +static inline bool poly1305_init_arch(void *ctx,
> +				      const u8 key[POLY1305_KEY_SIZE])
> +{
> +	poly1305_init_arm(ctx, key);
> +	return true;
> +}
> +
> +static inline bool poly1305_blocks_arch(void *ctx, const u8 *inp,
> +					const size_t len, const u32 padbit,
> +					simd_context_t *simd_context)
> +{
> +#if defined(ARM_USE_NEON)
> +	if (poly1305_use_neon && simd_use(simd_context)) {
> +		poly1305_blocks_neon(ctx, inp, len, padbit);
> +		return true;
> +	}
> +#endif
> +	poly1305_blocks_arm(ctx, inp, len, padbit);
> +	return true;
> +}

This will compute the wrong digest if called with simd_context=HAVE_FULL_SIMD
and then later with simd_context=HAVE_NO_SIMD, since poly1305_blocks_neon()
converts the accumulator from base 32 to base 26, whereas poly1305_blocks_arm()
assumes it is still in base 32.  Is that intentional?  I'm sure this is a rare
case, but my understanding is that the existing crypto API doesn't preclude
calling successive steps in different contexts.  And I'm concerned that it could
be relevant in some cases, e.g. especially if people are importing a hash state
that was exported earlier.  Handling it by silently computing the wrong digest
is not a great idea...

- Eric
