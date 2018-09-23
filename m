From: Lars Persson <lars.persson@axis.com>
Subject: Re: [PATCH crypto-next 18/23] crypto: artpec6 - Remove VLA usage of
 skcipher
Date: Sun, 23 Sep 2018 14:13:44 +0200
Message-ID: <29e492c8-671a-2077-043f-e4f829ba04f2@axis.com>
References: <20180919021100.3380-1-keescook@chromium.org>
 <20180919021100.3380-19-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jesper Nilsson <jespern@axis.com>, Lars Persson <larper@axis.com>,
        <linux-arm-kernel@axis.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Eric Biggers" <ebiggers@google.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180919021100.3380-19-keescook@chromium.org>
Content-Language: sv
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 9/19/18 4:10 AM, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> replaces struct crypto_skcipher and SKCIPHER_REQUEST_ON_STACK() usage
> with struct crypto_sync_skcipher and SYNC_SKCIPHER_REQUEST_ON_STACK(),
> which uses a fixed stack size.
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> Cc: Lars Persson <lars.persson@axis.com>
> Cc: linux-arm-kernel@axis.com
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   drivers/crypto/axis/artpec6_crypto.c | 19 +++++++++----------
>   1 file changed, 9 insertions(+), 10 deletions(-)
> 

Acked-by: Lars Persson <lars.persson@axis.com>
