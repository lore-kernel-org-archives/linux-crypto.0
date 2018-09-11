From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH v4] crypto: xts - Drop use of auxiliary buffer
Date: Tue, 11 Sep 2018 09:33:47 +0200
Message-ID: <CAFqZXNs8N1gQ_LsxbmMMWRDsA8cS_chfiWoMmc5Y5bA7K9J+TA@mail.gmail.com>
References: <20180910112841.23914-1-omosnace@redhat.com>
	<20180910161713.GA774@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180910161713.GA774@sol.localdomain>
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

On Mon, Sep 10, 2018 at 6:17 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Hi Ondrej,
>
> On Mon, Sep 10, 2018 at 01:28:41PM +0200, Ondrej Mosnacek wrote:
> >
> > -static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
> > +static int xor_tweak_pre(struct skcipher_request *req)
> >  {
> > -     struct priv *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
> > -     struct rctx *rctx = skcipher_request_ctx(req);
> > -     struct skcipher_request *subreq;
> > -     gfp_t gfp;
> > -
> > -     subreq = &rctx->subreq;
> > -     skcipher_request_set_tfm(subreq, ctx->child);
> > -     skcipher_request_set_callback(subreq, req->base.flags, done, req);
> > -
> > -     gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
> > -                                                        GFP_ATOMIC;
> > -     rctx->ext = NULL;
> > -
> > -     subreq->cryptlen = XTS_BUFFER_SIZE;
> > -     if (req->cryptlen > XTS_BUFFER_SIZE) {
> > -             unsigned int n = min(req->cryptlen, (unsigned int)PAGE_SIZE);
> > -
> > -             rctx->ext = kmalloc(n, gfp);
> > -             if (rctx->ext)
> > -                     subreq->cryptlen = n;
> > -     }
> > -
> > -     rctx->src = req->src;
> > -     rctx->dst = req->dst;
> > -     rctx->left = req->cryptlen;
> > -
> > -     /* calculate first value of T */
> > -     crypto_cipher_encrypt_one(ctx->tweak, (u8 *)&rctx->t, req->iv);
> > -
> > -     return 0;
> > +     return xor_tweak(req, false);
> >  }
> >
> > -static void exit_crypt(struct skcipher_request *req)
> > +static int xor_tweak_post(struct skcipher_request *req)
> >  {
> > -     struct rctx *rctx = skcipher_request_ctx(req);
> > -
> > -     rctx->left = 0;
> > -
> > -     if (rctx->ext)
> > -             kzfree(rctx->ext);
> > +     return xor_tweak(req, false);
> >  }
>
> I think you meant 'xor_tweak(req, true);' here?

Ouch, yes I sent the patches out too quickly... Will fix it all and resubmit.

>
> > +static void crypt_done(struct crypto_async_request *areq, int err)
> >  {
> >       struct skcipher_request *req = areq->data;
> > -     struct skcipher_request *subreq;
> > -     struct rctx *rctx;
> > -
> > -     rctx = skcipher_request_ctx(req);
> > -
> > -     if (err == -EINPROGRESS) {
> > -             if (rctx->left != req->cryptlen)
> > -                     return;
> > -             goto out;
> > -     }
> > -
> > -     subreq = &rctx->subreq;
> > -     subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
> >
> > -     err = do_encrypt(req, err ?: post_crypt(req));
> > -     if (rctx->left)
> > -             return;
> > +     if (!err)
> > +             err = xor_tweak(req, true);
>
> Use xor_tweak_post()?
>
> Note that you could also change the bool to
>
> enum {
>         FIRST_PASS,
>         SECOND_PASS,
> }
>
> if you find the bool to be unclear.

Yes, that would work, too. I slightly prefer aliasing the functions,
but I guess it is a matter of taste...

Thanks for the review,

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
