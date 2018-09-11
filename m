From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/4] crypto: skcipher - Enforce non-ASYNC for on-stack
 requests
Date: Tue, 11 Sep 2018 13:52:30 +0800
Message-ID: <20180911055230.iiiq2uu5gczlwjon@gondor.apana.org.au>
References: <20180906225854.40989-1-keescook@chromium.org>
 <20180906225854.40989-3-keescook@chromium.org>
 <20180907034242.zhm4dglzkldhvh3x@gondor.apana.org.au>
 <CAKv+Gu9kHpBTKjQKA3W4Q424FeY+Zq4srq2-r0MxjfCNKHT_5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@google.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9kHpBTKjQKA3W4Q424FeY+Zq4srq2-r0MxjfCNKHT_5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 07, 2018 at 08:56:23AM +0200, Ard Biesheuvel wrote:
>
> OK, so given that all SKCIPHER_REQUEST_ON_STACK occurrences are
> updated in this series anyway, perhaps we should add
> skcipher_[en|de]crypt_onstack() flavors that encapsulate the
> additional check? Only question is how to enforce at compile time that
> those are used instead of the ordinary ones when using a stack
> allocated request. Would you mind using some macro foo here involving
> __builtin_types_compatible_p() ?

Something like a completely new type which in reality is just a
wrapper around skcipher:

	struct crypto_sync_skcipher {
		struct crypto_skcipher base;
	} tfm;

	tfm = crypto_alloc_sync_skcipher(...);

	crypto_sync_skcipher_encrypt(...)
	crypto_sync_skcipher_decrypt(...)

These functions would just be trivial inline functions around their
crypto_skcipher counterparts.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
