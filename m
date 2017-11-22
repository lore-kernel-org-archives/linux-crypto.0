From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] crypto: chacha20 - Fix unaligned access when loading constants
Date: Wed, 22 Nov 2017 20:26:31 +0000
Message-ID: <CAKv+Gu8gQF2CpH_n5ox5KjFzJstnayEk5QAuqVZ5dO7hZ+qMfg@mail.gmail.com>
References: <20171122195139.121269-1-ebiggers3@gmail.com> <20171122195139.121269-2-ebiggers3@gmail.com>
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
Received: from mail-io0-f196.google.com ([209.85.223.196]:38746 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751260AbdKVU0c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 15:26:32 -0500
Received: by mail-io0-f196.google.com with SMTP id h205so23745611iof.5
        for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2017 12:26:32 -0800 (PST)
In-Reply-To: <20171122195139.121269-2-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 22 November 2017 at 19:51, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The four 32-bit constants for the initial state of ChaCha20 were loaded
> from a char array which is not guaranteed to have the needed alignment.
>
> Fix it by just assigning the constants directly instead.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

I'm not thrilled about the open coded hex numbers but I don't care
enough to object.

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/chacha20_generic.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/crypto/chacha20_generic.c b/crypto/chacha20_generic.c
> index 4a45fa4890c0..ec84e7837aac 100644
> --- a/crypto/chacha20_generic.c
> +++ b/crypto/chacha20_generic.c
> @@ -41,12 +41,10 @@ static void chacha20_docrypt(u32 *state, u8 *dst, const u8 *src,
>
>  void crypto_chacha20_init(u32 *state, struct chacha20_ctx *ctx, u8 *iv)
>  {
> -       static const char constant[16] = "expand 32-byte k";
> -
> -       state[0]  = le32_to_cpuvp(constant +  0);
> -       state[1]  = le32_to_cpuvp(constant +  4);
> -       state[2]  = le32_to_cpuvp(constant +  8);
> -       state[3]  = le32_to_cpuvp(constant + 12);
> +       state[0]  = 0x61707865; /* "expa" */
> +       state[1]  = 0x3320646e; /* "nd 3" */
> +       state[2]  = 0x79622d32; /* "2-by" */
> +       state[3]  = 0x6b206574; /* "te k" */
>         state[4]  = ctx->key[0];
>         state[5]  = ctx->key[1];
>         state[6]  = ctx->key[2];
> --
> 2.15.0.448.gf294e3d99a-goog
>
