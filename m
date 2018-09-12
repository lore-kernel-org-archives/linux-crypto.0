From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH v3 2/2] crypto: lrw - Do not use auxiliary
	buffer
Date: Wed, 12 Sep 2018 09:57:57 +0200
Message-ID: <CAFqZXNuuPiUjy0g9-4RQBzK8cZYKPnp77GD=3nAF=CxeaQj4hw@mail.gmail.com>
References: <20180911074239.2398-1-omosnace@redhat.com>
	<20180911074239.2398-3-omosnace@redhat.com>
	<20180912065054.GC752@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180912065054.GC752@sol.localdomain>
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

On Wed, Sep 12, 2018 at 8:51 AM Eric Biggers <ebiggers@kernel.org> wrote:
> On Tue, Sep 11, 2018 at 09:42:39AM +0200, Ondrej Mosnacek wrote:
> > This patch simplifies the LRW template to recompute the LRW tweaks from
> > scratch in the second pass and thus also removes the need to allocate a
> > dynamic buffer using kmalloc().
> >
> > As discussed at [1], the use of kmalloc causes deadlocks with dm-crypt.
> >
> > PERFORMANCE MEASUREMENTS (x86_64)
> > Performed using: https://gitlab.com/omos/linux-crypto-bench
> > Crypto driver used: lrw(ecb-aes-aesni)
> >
> > The results show that the new code has about the same performance as the
> > old code. For 512-byte message it seems to be even slightly faster, but
> > that might be just noise.
> >
> > Before:
> >        ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
> >         lrw(aes)     256              64             200             203
> >         lrw(aes)     320              64             202             204
> >         lrw(aes)     384              64             204             205
> >         lrw(aes)     256             512             415             415
> >         lrw(aes)     320             512             432             440
> >         lrw(aes)     384             512             449             451
> >         lrw(aes)     256            4096            1838            1995
> >         lrw(aes)     320            4096            2123            1980
> >         lrw(aes)     384            4096            2100            2119
> >         lrw(aes)     256           16384            7183            6954
> >         lrw(aes)     320           16384            7844            7631
> >         lrw(aes)     384           16384            8256            8126
> >         lrw(aes)     256           32768           14772           14484
> >         lrw(aes)     320           32768           15281           15431
> >         lrw(aes)     384           32768           16469           16293
> >
> > After:
> >        ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
> >         lrw(aes)     256              64             197             196
> >         lrw(aes)     320              64             200             197
> >         lrw(aes)     384              64             203             199
> >         lrw(aes)     256             512             385             380
> >         lrw(aes)     320             512             401             395
> >         lrw(aes)     384             512             415             415
> >         lrw(aes)     256            4096            1869            1846
> >         lrw(aes)     320            4096            2080            1981
> >         lrw(aes)     384            4096            2160            2109
> >         lrw(aes)     256           16384            7077            7127
> >         lrw(aes)     320           16384            7807            7766
> >         lrw(aes)     384           16384            8108            8357
> >         lrw(aes)     256           32768           14111           14454
> >         lrw(aes)     320           32768           15268           15082
> >         lrw(aes)     384           32768           16581           16250
> >
> > [1] https://lkml.org/lkml/2018/8/23/1315
> >
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  crypto/lrw.c | 280 ++++++++++-----------------------------------------
> >  1 file changed, 51 insertions(+), 229 deletions(-)
> >
> > diff --git a/crypto/lrw.c b/crypto/lrw.c
> > index b4f30b6f16d6..d5d2fba9af59 100644
> > --- a/crypto/lrw.c
> > +++ b/crypto/lrw.c
> > @@ -29,8 +29,6 @@
> >  #include <crypto/b128ops.h>
> >  #include <crypto/gf128mul.h>
> >
> > -#define LRW_BUFFER_SIZE 128u
> > -
> >  #define LRW_BLOCK_SIZE 16
> >
> >  struct priv {
> > @@ -56,19 +54,7 @@ struct priv {
> >  };
> >
> >  struct rctx {
> > -     be128 buf[LRW_BUFFER_SIZE / sizeof(be128)];
> > -
> > -     be128 t;
> > -
> > -     be128 *ext;
> > -
> > -     struct scatterlist srcbuf[2];
> > -     struct scatterlist dstbuf[2];
> > -     struct scatterlist *src;
> > -     struct scatterlist *dst;
> > -
> > -     unsigned int left;
> > -
> > +     be128 t, orig_iv;
> >       struct skcipher_request subreq;
> >  };
> >
> > @@ -135,86 +121,31 @@ static int next_index(u32 *counter)
> >       return res;
> >  }
> >
> > -static int post_crypt(struct skcipher_request *req)
> > +/*
> > + * We compute the tweak masks twice (both before and after the ECB encryption or
> > + * decryption) to avoid having to allocate a temporary buffer and/or make
> > + * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
> > + * just doing the gf128mul_x_ble() calls again.
> > + */
>
> next_index(), not gf128mul_x_ble().

Fixed for next revision, thanks.

>
> > +static void init_crypt(struct skcipher_request *req)
> >  {
> > +     struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> >       struct rctx *rctx = skcipher_request_ctx(req);
> > -     struct skcipher_request *subreq;
> > +     struct skcipher_request *subreq = &rctx->subreq;
> >
> > -     subreq = &rctx->subreq;
> > -
> > -     while (!err && rctx->left) {
> > -             err = pre_crypt(req) ?:
> > -                   crypto_skcipher_decrypt(subreq) ?:
> > -                   post_crypt(req);
> > +     skcipher_request_set_tfm(subreq, ctx->child);
> > +     skcipher_request_set_callback(subreq, req->base.flags, crypt_done, req);
> > +     skcipher_request_set_crypt(subreq, req->dst, req->dst,
> > +                                req->cryptlen, &rctx->orig_iv);
>
> Can you leave a comment that the 'iv' of 'subreq' is set to 'orig_iv' is set so
> that it's available in xor_tweak_post()?  My first thought was that the 'iv'
> should be NULL as this same request is also used for the ECB step.
>
> Or alternatively, you could get the IV directly from 'rctx->orig_iv' in
> xor_tweak(), and only save the incremented IV back to 'walk.iv' on the first
> pass.  Then subreq->iv would be left NULL.

Good point, now that we have the explicit first/second pass
distinction this should be quite easy to do and will be also cleaner.

Thanks,
-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
