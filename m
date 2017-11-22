From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/5] crypto: chacha20 - Use unaligned access macros when
 loading key and IV
Date: Wed, 22 Nov 2017 20:27:51 +0000
Message-ID: <CAKv+Gu8c3ECTQ+-4KpEHEMCOwU_a8RAsnaneW55BYc2AASgmUg@mail.gmail.com>
References: <20171122195139.121269-1-ebiggers3@gmail.com> <20171122195139.121269-3-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Martin Willi <martin@strongswan.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:45829 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbdKVU1w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 15:27:52 -0500
Received: by mail-io0-f193.google.com with SMTP id z74so24487438iof.12
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2017 12:27:52 -0800 (PST)
In-Reply-To: <20171122195139.121269-3-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22 November 2017 at 19:51, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The generic ChaCha20 implementation has a cra_alignmask of 3, which
> ensures that the key passed into crypto_chacha20_setkey() and the IV
> passed into crypto_chacha20_init() are 4-byte aligned.  However, these
> functions are also called from the ARM and ARM64 implementations of
> ChaCha20, which intentionally do not have a cra_alignmask set.  This is
> broken because 32-bit words are being loaded from potentially-unaligned
> buffers without the unaligned access macros.
>
> Fix it by using the unaligned access macros when loading the key and IV.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/chacha20_generic.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
> index ec84e7837aac..b5a10ebf1b82 100644
> --- a/crypto/chacha20_generic.c
> +++ b/crypto/chacha20_generic.c
> @@ -9,16 +9,12 @@
>   * (at your option) any later version.
>   */
>
> +#include <asm/unaligned.h>
>  #include <crypto/algapi.h>
>  #include <crypto/chacha20.h>
>  #include <crypto/internal/skcipher.h>
>  #include <linux/module.h>
>
> -static inline u32 le32_to_cpuvp(const void *p)
> -{
> -       return le32_to_cpup(p);
> -}
> -
>  static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
>                              unsigned int bytes)
>  {
> @@ -53,10 +49,10 @@ void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
>         state[9]  = ctx->key[5];
>         state[10] = ctx->key[6];
>         state[11] = ctx->key[7];
> -       state[12] = le32_to_cpuvp(iv +  0);
> -       state[13] = le32_to_cpuvp(iv +  4);
> -       state[14] = le32_to_cpuvp(iv +  8);
> -       state[15] = le32_to_cpuvp(iv + 12);
> +       state[12] = get_unaligned_le32(iv +  0);
> +       state[13] = get_unaligned_le32(iv +  4);
> +       state[14] = get_unaligned_le32(iv +  8);
> +       state[15] = get_unaligned_le32(iv + 12);
>  }
>  EXPORT_SYMBOL_GPL(crypto_chacha20_init);
>
> @@ -70,7 +66,7 @@ int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
>                 return -EINVAL;
>
>         for (i = 0; i < ARRAY_SIZE(ctx->key); i++)
> -               ctx->key[i] = le32_to_cpuvp(key + i * sizeof(u32));
> +               ctx->key[i] = get_unaligned_le32(key + i * sizeof(u32));
>
>         return 0;
>  }
> --
> 2.15.0.448.gf294e3d99a-goog
>
