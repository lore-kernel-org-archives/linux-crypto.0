From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v8 9/9] crypto: skcipher: Remove VLA usage for
 SKCIPHER_REQUEST_ON_STACK
Date: Tue, 4 Sep 2018 11:15:09 +0800
Message-ID: <20180904031509.korwr7o7e4i7cjcq@gondor.apana.org.au>
References: <20180807211843.47586-1-keescook@chromium.org>
 <20180807211843.47586-10-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Tudor-Dan Ambarus <tudor.ambarus@microchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        qat-linux@intel.com, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180807211843.47586-10-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 07, 2018 at 02:18:43PM -0700, Kees Cook wrote:
> In the quest to remove all stack VLA usage from the kernel[1], this
> caps the skcipher request size similar to other limits and adds a sanity
> check at registration. Looking at instrumented tcrypt output, the largest
> is for lrw:
> 
> 	crypt: testing lrw(aes)
> 	crypto_skcipher_set_reqsize: 8
> 	crypto_skcipher_set_reqsize: 88
> 	crypto_skcipher_set_reqsize: 472
> 
> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/crypto/internal/skcipher.h | 1 +
>  include/crypto/skcipher.h          | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
> index e42f7063f245..5035482cbe68 100644
> --- a/include/crypto/internal/skcipher.h
> +++ b/include/crypto/internal/skcipher.h
> @@ -130,6 +130,7 @@ static inline struct crypto_skcipher *crypto_spawn_skcipher(
>  static inline void crypto_skcipher_set_reqsize(
>  	struct crypto_skcipher *skcipher, unsigned int reqsize)
>  {
> +	BUG_ON(reqsize > SKCIPHER_MAX_REQSIZE);

Please do not add these BUG_ONs.  Instead allow this function to
fail and check for the failure in the caller.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
