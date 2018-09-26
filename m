From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH crypto-next 07/23] block: cryptoloop: Remove VLA usage of skcipher
Date: Wed, 26 Sep 2018 10:19:30 +0200
Message-ID: <CAKv+Gu8ZNVTBsQQQaFgbXLkRkwm1tKf32+Mo98gv12HhWrFbxg@mail.gmail.com>
References: <20180919021100.3380-1-keescook@chromium.org> <20180919021100.3380-8-keescook@chromium.org>
 <CAKv+Gu8ynaVi1KCMNsjCU0ucAjFFku=ourh9Yc9Rizoc4ztvOQ@mail.gmail.com>
 <CAGXu5jLw3+nvb9opPeoCyH0MhyVK5UY7H5qeQ2b8GFTUGDGrUQ@mail.gmail.com>
 <CAKv+Gu-xKWsiegZXnsMvmMVgKTo7S2cm4wEqdaL7w9z64X7SAA@mail.gmail.com>
 <9c71afda-a668-10b3-842e-26f72e425691@kernel.dk> <CAKv+Gu_p2UgYMZ5jEUudruUOPYQEF-=VMou=xXbj_rd+-Lxktg@mail.gmail.com>
 <eaf66894-2f85-12ba-f91c-4387437cc8d9@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-block@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <eaf66894-2f85-12ba-f91c-4387437cc8d9@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 25 Sep 2018 at 18:32, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/25/18 10:16 AM, Ard Biesheuvel wrote:
> > On Tue, 25 Sep 2018 at 18:03, Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 9/25/18 3:25 AM, Ard Biesheuvel wrote:
> >>> On Mon, 24 Sep 2018 at 19:53, Kees Cook <keescook@chromium.org> wrote:
> >>>>
> >>>> On Mon, Sep 24, 2018 at 4:52 AM, Ard Biesheuvel
> >>>> <ard.biesheuvel@linaro.org> wrote:
> >>>>> On Wed, 19 Sep 2018 at 04:11, Kees Cook <keescook@chromium.org> wrote:
> >>>>>> @@ -119,7 +119,7 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
> >>>>>>         unsigned in_offs, out_offs;
> >>>>>>         int err;
> >>>>>>
> >>>>>> -       skcipher_request_set_tfm(req, tfm);
> >>>>>> +       skcipher_request_set_sync_tfm(req, tfm);
> >>>>>>         skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
> >>>>>>                                       NULL, NULL);
> >>>>>>
> >>>>>
> >>>>> Does this work?
> >>>>
> >>>> Everything is a direct wrapper for existing types and functions, so I
> >>>> wouldn't expect any functional change. I haven't been able to test
> >>>> this particular interface, though. cryptoloop is very deprecated,
> >>>> isn't it?
> >>>>
> >>>
> >>> Ah yes, I managed to confuse myself there. This looks all fine to me.
> >>>
> >>> In any case, this is another example where we may decide to fix the
> >>> code rather than retain the request allocation on the stack (but that
> >>> is Jens's call ultimately, I suppose)
> >>>
> >>> diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
> >>> index 7033a4beda66..5ed2167219ba 100644
> >>> --- a/drivers/block/cryptoloop.c
> >>> +++ b/drivers/block/cryptoloop.c
> >>> @@ -110,7 +110,7 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
> >>>                     int size, sector_t IV)
> >>>  {
> >>>         struct crypto_skcipher *tfm = lo->key_data;
> >>> -       SKCIPHER_REQUEST_ON_STACK(req, tfm);
> >>> +       struct skcipher_request *req;
> >>>         struct scatterlist sg_out;
> >>>         struct scatterlist sg_in;
> >>>
> >>> @@ -119,7 +119,10 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
> >>>         unsigned in_offs, out_offs;
> >>>         int err;
> >>>
> >>> -       skcipher_request_set_tfm(req, tfm);
> >>> +       req = skcipher_request_alloc(tfm, GFP_NOIO);
> >>> +       if (!req)
> >>> +               return -ENOMEM;
> >>
> >> Is this going to be reliable? ->transfer() is called when we're doing IO,
> >> and you'd normally need a mempool backed allocation to make this safe
> >> and guarantee forward progress.
> >>
> >
> > As far as I can tell, this function is only called from
> > lo_read_transfer/lo_write_transfer, both of which do an unconditional
> > alloc_page(GFP_NOIO), which is why I assumed that kmalloc(GFP_NOIO)
> > would be permissible in the same context. Are you saying this may not
> > be the case?
>
> Doesn't appear to be safe for either your case, nor the page it's
> allocating. If the allocator fails this allocation, then you'll get
> an EIO on that request. The more likely case is the allocator taking
> forever to satisfy the request, in which case you'll have very
> large latencies for IO when you are close to being out of memory.
> The preferred setup for allocating memory for IO is having a mempool
> of at least one item. If you end up blocking for memory, you'll at
> most get to wait for the existing IO that's using that memory to
> complete (per waiter, of course).
>

Ah, great. So the code is already broken to begin with.

In that case, may we have your ack for Kees's original patch, which is
effectively a no-op except for the fact that the size of the stack
buffer is no longer decided at runtime?
