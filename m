From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH v3] crypto: xts - Drop use of auxiliary buffer
Date: Mon, 10 Sep 2018 08:55:50 +0200
Message-ID: <CAFqZXNsWxVcWUCs5Hoxv9+yWNNzvWWx7cSYdHaXqy5=Gf8rWnw@mail.gmail.com>
References: <20180905113039.3324-1-omosnace@redhat.com>
	<20180908013505.GA764@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180908013505.GA764@sol.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 8, 2018 at 3:35 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Hi Ondrej,
>
> On Wed, Sep 05, 2018 at 01:30:39PM +0200, Ondrej Mosnacek wrote:
> > Since commit acb9b159c784 ("crypto: gf128mul - define gf128mul_x_* in
> > gf128mul.h"), the gf128mul_x_*() functions are very fast and therefore
> > caching the computed XTS tweaks has only negligible advantage over
> > computing them twice.
> >
> > In fact, since the current caching implementation limits the size of
> > the calls to the child ecb(...) algorithm to PAGE_SIZE (usually 4096 B),
> > it is often actually slower than the simple recomputing implementation.
> >
> > This patch simplifies the XTS template to recompute the XTS tweaks from
> > scratch in the second pass and thus also removes the need to allocate a
> > dynamic buffer using kmalloc().
> >
> > As discussed at [1], the use of kmalloc causes deadlocks with dm-crypt.
> >
> > PERFORMANCE RESULTS
> > I measured time to encrypt/decrypt a memory buffer of varying sizes with
> > xts(ecb-aes-aesni) using a tool I wrote ([2]) and the results suggest
> > that after this patch the performance is either better or comparable for
> > both small and large buffers. Note that there is a lot of noise in the
> > measurements, but the overall difference is easy to see.
> >
> > Old code:
> >        ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
> >         xts(aes)     256              64             331             328
> >         xts(aes)     384              64             332             333
> >         xts(aes)     512              64             338             348
> >         xts(aes)     256             512             889             920
> >         xts(aes)     384             512            1019             993
> >         xts(aes)     512             512            1032             990
> >         xts(aes)     256            4096            2152            2292
> >         xts(aes)     384            4096            2453            2597
> >         xts(aes)     512            4096            3041            2641
> >         xts(aes)     256           16384            9443            8027
> >         xts(aes)     384           16384            8536            8925
> >         xts(aes)     512           16384            9232            9417
> >         xts(aes)     256           32768           16383           14897
> >         xts(aes)     384           32768           17527           16102
> >         xts(aes)     512           32768           18483           17322
> >
> > New code:
> >        ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
> >         xts(aes)     256              64             328             324
> >         xts(aes)     384              64             324             319
> >         xts(aes)     512              64             320             322
> >         xts(aes)     256             512             476             473
> >         xts(aes)     384             512             509             492
> >         xts(aes)     512             512             531             514
> >         xts(aes)     256            4096            2132            1829
> >         xts(aes)     384            4096            2357            2055
> >         xts(aes)     512            4096            2178            2027
> >         xts(aes)     256           16384            6920            6983
> >         xts(aes)     384           16384            8597            7505
> >         xts(aes)     512           16384            7841            8164
> >         xts(aes)     256           32768           13468           12307
> >         xts(aes)     384           32768           14808           13402
> >         xts(aes)     512           32768           15753           14636
> >
> > [1] https://lkml.org/lkml/2018/8/23/1315
> > [2] https://gitlab.com/omos/linux-crypto-bench
> >
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  crypto/xts.c | 265 ++++++++-------------------------------------------
> >  1 file changed, 39 insertions(+), 226 deletions(-)
> >
> > Changes in v3:
> >   - add comment explaining the new approach as suggested by Eric
> >   - ensure correct alignment in second xor_tweak() pass
> >   - align performance results table header to the right
> >
> > v2: https://www.spinics.net/lists/linux-crypto/msg34799.html
> > Changes in v2:
> >   - rebase to latest cryptodev tree
> >
> > v1: https://www.spinics.net/lists/linux-crypto/msg34776.html
> >
> > diff --git a/crypto/xts.c b/crypto/xts.c
> > index ccf55fbb8bc2..24cfecdec565 100644
> > --- a/crypto/xts.c
> > +++ b/crypto/xts.c
> > @@ -26,8 +26,6 @@
> >  #include <crypto/b128ops.h>
> >  #include <crypto/gf128mul.h>
> >
> > -#define XTS_BUFFER_SIZE 128u
> > -
> >  struct priv {
> >       struct crypto_skcipher *child;
> >       struct crypto_cipher *tweak;
> > @@ -39,19 +37,7 @@ struct xts_instance_ctx {
> >  };
> >
> >  struct rctx {
> > -     le128 buf[XTS_BUFFER_SIZE / sizeof(le128)];
> > -
> >       le128 t;
> > -
> > -     le128 *ext;
> > -
> > -     struct scatterlist srcbuf[2];
> > -     struct scatterlist dstbuf[2];
> > -     struct scatterlist *src;
> > -     struct scatterlist *dst;
> > -
> > -     unsigned int left;
> > -
> >       struct skcipher_request subreq;
> >  };
> >
> > @@ -96,265 +82,92 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
> >       return err;
> >  }
> >
> > -static int post_crypt(struct skcipher_request *req)
> > +/*
> > + * We compute the tweak masks twice (both before and after the ECB encryption or
> > + * decryption) to avoid having to allocate a temporary buffer and/or make
> > + * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
> > + * just doing the gf128mul_x_ble() calls again.
> > + */
> > +static int xor_tweak(struct skcipher_request *req, struct skcipher_request *subreq)
> >  {
> >       struct rctx *rctx = skcipher_request_ctx(req);
> > -     le128 *buf = rctx->ext ?: rctx->buf;
> > -     struct skcipher_request *subreq;
> > +     struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> >       const int bs = XTS_BLOCK_SIZE;
> >       struct skcipher_walk w;
> > -     struct scatterlist *sg;
> > -     unsigned offset;
> > +     le128 t = rctx->t;
> >       int err;
> >
> > -     subreq = &rctx->subreq;
> > +     /* set to our TFM to enforce correct alignment: */
> > +     skcipher_request_set_tfm(subreq, tfm);
> > +
> >       err = skcipher_walk_virt(&w, subreq, false);
> >
>
> Hmm, it confused me how 'subreq' isn't necessarily the same as 'rctx->subreq'.
> Also skcipher_request_set_tfm() is called even on the original 'req'.  I suppose
> it ends up setting it to the previous value and therefore is safe, but I'm not
> completely sure; do any other algorithms do that?  I don't think it's a good
> idea in general to modify the request besides the request_ctx() portion.

I don't think it can do any harm, skcipher_request_set_tfm() is just:

static inline void skcipher_request_set_tfm(struct skcipher_request *req,
                                             struct crypto_skcipher *tfm)
{
        req->base.tfm = crypto_skcipher_tfm(tfm);
}

However I agree it is a bit hacky...

>
> Actually all the information is available from the original 'req' anyway, so why
> not just pass a bool that indicates whether it's the first or second XOR pass?
> Like the following incremental patch:

I generally try to avoid bool arguments (or at least too many of them)
if possible, since it is easy to get lost in what the 0s and 1s mean
in a function call, but I concur that in this case a bool argument is
better than the alternative. I like your patch, I am going to fold it
in, thanks!

>
> diff --git a/crypto/xts.c b/crypto/xts.c
> index 24cfecdec5656..0df868aa0ae7f 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -88,7 +88,7 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
>   * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
>   * just doing the gf128mul_x_ble() calls again.
>   */
> -static int xor_tweak(struct skcipher_request *req, struct skcipher_request *subreq)
> +static int xor_tweak(struct skcipher_request *req, bool second_pass)
>  {
>         struct rctx *rctx = skcipher_request_ctx(req);
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> @@ -97,10 +97,12 @@ static int xor_tweak(struct skcipher_request *req, struct skcipher_request *subr
>         le128 t = rctx->t;
>         int err;
>
> -       /* set to our TFM to enforce correct alignment: */
> -       skcipher_request_set_tfm(subreq, tfm);
> -
> -       err = skcipher_walk_virt(&w, subreq, false);
> +       if (second_pass) {
> +               req = &rctx->subreq;
> +               /* set to our TFM to enforce correct alignment: */
> +               skcipher_request_set_tfm(req, tfm);
> +       }
> +       err = skcipher_walk_virt(&w, req, false);
>
>         while (w.nbytes) {
>                 unsigned int avail = w.nbytes;
> @@ -124,11 +126,9 @@ static int xor_tweak(struct skcipher_request *req, struct skcipher_request *subr
>  static void crypt_done(struct crypto_async_request *areq, int err)
>  {
>         struct skcipher_request *req = areq->data;
> -       struct rctx *rctx = skcipher_request_ctx(req);
> -       struct skcipher_request *subreq = &rctx->subreq;
>
>         if (!err)
> -               err = xor_tweak(req, subreq);
> +               err = xor_tweak(req, true);
>
>         skcipher_request_complete(req, err);
>  }
> @@ -154,9 +154,9 @@ static int encrypt(struct skcipher_request *req)
>         struct skcipher_request *subreq = &rctx->subreq;
>
>         init_crypt(req);
> -       return xor_tweak(req, req) ?:
> +       return xor_tweak(req, false) ?:
>                 crypto_skcipher_encrypt(subreq) ?:
> -               xor_tweak(req, subreq);
> +               xor_tweak(req, true);
>  }
>
>  static int decrypt(struct skcipher_request *req)
> @@ -165,9 +165,9 @@ static int decrypt(struct skcipher_request *req)
>         struct skcipher_request *subreq = &rctx->subreq;
>
>         init_crypt(req);
> -       return xor_tweak(req, req) ?:
> +       return xor_tweak(req, false) ?:
>                 crypto_skcipher_decrypt(subreq) ?:
> -               xor_tweak(req, subreq);
> +               xor_tweak(req, true);
>  }
>
>  static int init_tfm(struct crypto_skcipher *tfm)

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
