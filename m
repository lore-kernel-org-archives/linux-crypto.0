From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 11/11] crypto: skcipher: Remove VLA usage for SKCIPHER_REQUEST_ON_STACK
Date: Wed, 20 Jun 2018 21:44:42 +0200
Message-ID: <CAK8P3a1U1RNxmx-G5QCS8emzXc3nHqEN5bqmZDMqZBBmo3vCtQ@mail.gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org> <20180620190408.45104-12-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620190408.45104-12-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 9:04 PM, Kees Cook <keescook@chromium.org> wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> caps the skcipher request size similar to other limits and adds a sanity
> check at registration.
>
>
> +#define SKCIPHER_MAX_REQSIZE   (PAGE_SIZE / 8)
> +
>  #define SKCIPHER_REQUEST_ON_STACK(name, tfm) \
>         char __##name##_desc[sizeof(struct skcipher_request) + \
> -               crypto_skcipher_reqsize(tfm)] CRYPTO_MINALIGN_ATTR; \
> +               SKCIPHER_MAX_REQSIZE] CRYPTO_MINALIGN_ATTR; \
>         struct skcipher_request *name = (void *)__##name##_desc
>

This is probably a bad idea on kernels with large values of PAGE_SIZE.
Some users on ppc64 and arm64 use 64KB here, but still limit
the per-function stack size to 2KB.

        Arnd
