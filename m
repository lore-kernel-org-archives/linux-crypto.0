From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH v2] crypto: xts - Drop use of auxiliary buffer
Date: Wed, 5 Sep 2018 10:35:54 +0200
Message-ID: <CAFqZXNtoJmbzzTyifJoi3yPP9tL1jC-1DwQ9o+HpX-R_mydm2A@mail.gmail.com>
References: <20180904080642.26897-1-omosnace@redhat.com>
	<20180905063231.GA6813@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
To: ebiggers@kernel.org
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180905063231.GA6813@sol.localdomain>
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

Hi Eric,

On Wed, Sep 5, 2018 at 8:32 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Hi Ondrej,
>
> On Tue, Sep 04, 2018 at 10:06:42AM +0200, Ondrej Mosnacek wrote:
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
> > ALGORITHM       KEY (b) DATA (B)        TIME ENC (ns)   TIME DEC (ns)
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
> > ALGORITHM       KEY (b) DATA (B)        TIME ENC (ns)   TIME DEC (ns)
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
>
> Can you align the headers of these tables?

Sure.

>
> > +static int xor_tweak(struct rctx *rctx, struct skcipher_request *req)
> >  {
> > -     struct rctx *rctx = skcipher_request_ctx(req);
> > -     le128 *buf = rctx->ext ?: rctx->buf;
> > -     struct skcipher_request *subreq;
> >       const int bs = XTS_BLOCK_SIZE;
> >       struct skcipher_walk w;
> > -     struct scatterlist *sg;
> > -     unsigned offset;
> > +     le128 t = rctx->t;
> >       int err;
>
> Maybe you could add a brief comment above xor_tweak() explaining the design
> choice for posterity, e.g.:
>
> /*
>  * We compute the tweak masks twice (both before and after the ECB encryption or
>  * decryption) to avoid having to allocate a temporary buffer, which usually
>  * would be slower than just doing the gf128mul_x_ble() calls again.
>  */

Definitely, that's a good idea! I'll put something like that into v3.

>
> Otherwise this looks good.  Thanks for doing this!
>
> The new implementation isn't *guaranteed* to be faster, but it should be most of
> the time, and it's definitely much simpler.  And the current one has had bugs.

Yes, it's not guaranteed, but the complexity of gfmul should be always
small enough when compared to a block cipher call. If it is small
enough compared to AES-NI, which is already crazy-fast, then should be
fine in all realistic cases. Either way, the massive simplification
should be worth it even with a minor slowdown.

>
> Note that if ever needed there's also still room for optimizing the GF(2^128)
> multiplications further, e.g. multiplying by 'x' and 'x^2' in parallel, or maybe
> having a version specialized for 32-bit processors.
>
> FYI, I think that 'subreq' can have an alignmask insufficient for 'le128', which
> can cause misaligned accesses during the second xor_tweak().  But, the current
> version has that bug too...

That's a good point, I haven't thought of that... I think I could fix
it with a clever one-liner in my version, but ideally someone should
write a patch for the old version, too, so it can get fixed in stable
as well... but that would be more work than I planned to spend on
this, I should really be doing other things right now :)

BTW, I noticed later that crypto/lrw.c uses a very similar pattern
(with kmalloc and calls to ECB). I am now trying to simplify it in the
same way, but in this case the xor_tweak operation seems to be slower
and the difference is more noticeable. I have managed to optimize it
quite a bit and bring the difference down, hopefully enough to mandate
the simplification. I will send a patch later with some concrete
numbers.

>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
>
> - Eric

Thanks,

--
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
