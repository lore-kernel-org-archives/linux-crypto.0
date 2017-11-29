From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] ARM64: crypto: do not call crypto_unregister_skcipher
 twice on error
Date: Wed, 29 Nov 2017 17:40:09 +1100
Message-ID: <20171129064009.GP21575@gondor.apana.org.au>
References: <1511511727-15385-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, catalin.marinas@arm.com, will.deacon@arm.com,
        ard.biesheuvel@linaro.org, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511511727-15385-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 24, 2017 at 08:22:07AM +0000, Corentin Labbe wrote:
> When a cipher fails to register in aes_init(), the error path goes thought
> aes_exit() then crypto_unregister_skciphers().
> Since aes_exit calls also crypto_unregister_skcipher, this triggers a
> refcount_t: underflow; use-after-free.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
