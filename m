From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] crypto: aes_ti - fix comment for MixColumns step
Date: Wed, 10 May 2017 08:40:30 +0100
Message-ID: <CAKv+Gu8oGx5i=Eap9+UF+cEE8kxZ6PSRykQ4xmgQdtF+bUQ1qQ@mail.gmail.com>
References: <20170510002027.47632-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:35981 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdEJHkc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 May 2017 03:40:32 -0400
Received: by mail-it0-f43.google.com with SMTP id o5so19780129ith.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 May 2017 00:40:31 -0700 (PDT)
In-Reply-To: <20170510002027.47632-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10 May 2017 at 01:20, Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> mix_columns() contains a comment which shows the matrix used by the
> MixColumns step of AES, but the last entry in this matrix was incorrect
> --- and did not match the code, which is correct.  Fix the comment.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/aes_ti.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
> index 92644fd1ac19..03023b2290e8 100644
> --- a/crypto/aes_ti.c
> +++ b/crypto/aes_ti.c
> @@ -114,7 +114,7 @@ static u32 mix_columns(u32 x)
>          * | 0x2 0x3 0x1 0x1 |   | x[0] |
>          * | 0x1 0x2 0x3 0x1 |   | x[1] |
>          * | 0x1 0x1 0x2 0x3 | x | x[2] |
> -        * | 0x3 0x1 0x1 0x3 |   | x[3] |
> +        * | 0x3 0x1 0x1 0x2 |   | x[3] |
>          */
>         u32 y = mul_by_x(x) ^ ror32(x, 16);
>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
