From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [dm-devel] [PATCH v2 10/11] crypto: ahash: Remove VLA usage for
 AHASH_REQUEST_ON_STACK
Date: Tue, 26 Jun 2018 17:19:59 +0800
Message-ID: <20180626091958.zy3m24sjukfbn7av@gondor.apana.org.au>
References: <20180625211026.15819-1-keescook@chromium.org>
 <20180625211026.15819-11-keescook@chromium.org>
 <20180625225609.GA181665@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kees Cook <keescook@chromium.org>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        qat-linux@intel.com, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180625225609.GA181665@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 25, 2018 at 03:56:09PM -0700, Eric Biggers wrote:
>
> > diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
> > index a0b0ad9d585e..d96ae5f52125 100644
> > --- a/include/crypto/internal/hash.h
> > +++ b/include/crypto/internal/hash.h
> > @@ -142,6 +142,7 @@ static inline struct ahash_alg *__crypto_ahash_alg(struct crypto_alg *alg)
> >  static inline void crypto_ahash_set_reqsize(struct crypto_ahash *tfm,
> >  					    unsigned int reqsize)
> >  {
> > +	BUG_ON(reqsize > AHASH_MAX_REQSIZE);
> >  	tfm->reqsize = reqsize;
> >  }
> 
> This isn't accounting for the cases where a hash algorithm is "wrapped" with
> another one, which increases the request size.  For example, "sha512_mb" ends up
> with a request size of

I think this patch is on the wrong track.  The stack requests are
only ever meant to be used for synchronous algorithms (IOW shash
algorithms) and were a quick-and-dirty fix for legacy users.

So either check SHASH_MAX_REQSIZE or just convert the users to
kmalloc or even better make them real async users.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
