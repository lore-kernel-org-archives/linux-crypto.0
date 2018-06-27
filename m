From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 11/11] crypto: skcipher: Remove VLA usage for
 SKCIPHER_REQUEST_ON_STACK
Date: Thu, 28 Jun 2018 06:27:49 +0800
Message-ID: <20180627222749.xa5333caq5vaa7st@gondor.apana.org.au>
References: <20180625211026.15819-1-keescook@chromium.org>
 <20180625211026.15819-12-keescook@chromium.org>
 <20180626092041.mxfg4lxcvxfivzc2@gondor.apana.org.au>
 <CAGXu5jKYb-0NNvOcN79hzqU7O6vCFhMTBDGBL8Knuoc-YHamPg@mail.gmail.com>
 <20180627143622.ntksjxsymo4yw6dz@gondor.apana.org.au>
 <CAGXu5jJ2Z=YP+fNsvy+6a_BpC1ibZf6tOzZuPHk=Qx1qNVvOZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, qat-linux@intel.com,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ2Z=YP+fNsvy+6a_BpC1ibZf6tOzZuPHk=Qx1qNVvOZw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 27, 2018 at 11:31:09AM -0700, Kees Cook wrote:
>
> I might be catching on... so from this list, I should only "count" the
> synchronous ones as being wrappable? The skcipher list is actually
> pretty short:
> 
> crypto/cryptd.c:        crypto_skcipher_set_reqsize(
> crypto/cryptd.c-                tfm, sizeof(struct
> cryptd_skcipher_request_ctx));

cryptd is async so you don't have to include it.
 
> These are "simple" wrappers:
> 
> crypto/lrw.c:   crypto_skcipher_set_reqsize(tfm,
> crypto_skcipher_reqsize(cipher) +
> crypto/lrw.c-                                    sizeof(struct rctx));
> 
> crypto/simd.c-  reqsize = sizeof(struct skcipher_request);
> crypto/simd.c-  reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
> crypto/simd.c:  crypto_skcipher_set_reqsize(tfm, reqsize);

simd is async.

> crypto/xts.c:   crypto_skcipher_set_reqsize(tfm,
> crypto_skcipher_reqsize(child) +
> crypto/xts.c-                                    sizeof(struct rctx));
> 
> But what are the "legitimate" existing crypto_skcipher_reqsize() values here?
> 
> These are "complex" wrappers, with cts even adding blocksize to the mix...
> 
> crypto/ctr.c-   align = crypto_skcipher_alignmask(tfm);
> crypto/ctr.c-   align &= ~(crypto_tfm_ctx_alignment() - 1);
> crypto/ctr.c-   reqsize = align + sizeof(struct crypto_rfc3686_req_ctx) +
> crypto/ctr.c-             crypto_skcipher_reqsize(cipher);
> crypto/ctr.c:   crypto_skcipher_set_reqsize(tfm, reqsize);
> 
> crypto/cts.c-   align = crypto_skcipher_alignmask(tfm);
> crypto/cts.c-   bsize = crypto_skcipher_blocksize(cipher);
> crypto/cts.c-   reqsize = ALIGN(sizeof(struct crypto_cts_reqctx) +
> crypto/cts.c-                   crypto_skcipher_reqsize(cipher),
> crypto/cts.c-                   crypto_tfm_ctx_alignment()) +
> crypto/cts.c-             (align & ~(crypto_tfm_ctx_alignment() - 1)) + bsize;
> crypto/cts.c-
> crypto/cts.c:   crypto_skcipher_set_reqsize(tfm, reqsize);
> 
> What values might be expected here? It seems the entire blocksize
> needs to be included as well...

But otherwise yes these are the ones that count.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
