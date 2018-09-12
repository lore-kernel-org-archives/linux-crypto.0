From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [PATCH v3 1/2] crypto: lrw - Optimize tweak
	computation
Date: Wed, 12 Sep 2018 09:52:58 +0200
Message-ID: <CAFqZXNuOYeNAY8uixzkvq=DdkXs674ARFJ09fJCB3cyZ-jbkjA@mail.gmail.com>
References: <20180911074239.2398-1-omosnace@redhat.com>
	<20180911074239.2398-2-omosnace@redhat.com>
	<20180912062815.GB752@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180912062815.GB752@sol.localdomain>
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

On Wed, Sep 12, 2018 at 8:28 AM Eric Biggers <ebiggers@kernel.org> wrote:
> Hi Ondrej,
>
> On Tue, Sep 11, 2018 at 09:42:38AM +0200, Ondrej Mosnacek wrote:
> > This patch rewrites the tweak computation to a slightly simpler method
> > that performs less bswaps. Based on performance measurements the new
> > code seems to provide slightly better performance than the old one.
> >
> > PERFORMANCE MEASUREMENTS (x86_64)
> > Performed using: https://gitlab.com/omos/linux-crypto-bench
> > Crypto driver used: lrw(ecb-aes-aesni)
> >
> > Before:
> >        ALGORITHM KEY (b)        DATA (B)   TIME ENC (ns)   TIME DEC (ns)
> >         lrw(aes)     256              64             204             286
> >         lrw(aes)     320              64             227             203
> >         lrw(aes)     384              64             208             204
> >         lrw(aes)     256             512             441             439
> >         lrw(aes)     320             512             456             455
> >         lrw(aes)     384             512             469             483
> >         lrw(aes)     256            4096            2136            2190
> >         lrw(aes)     320            4096            2161            2213
> >         lrw(aes)     384            4096            2295            2369
> >         lrw(aes)     256           16384            7692            7868
> >         lrw(aes)     320           16384            8230            8691
> >         lrw(aes)     384           16384            8971            8813
> >         lrw(aes)     256           32768           15336           15560
> >         lrw(aes)     320           32768           16410           16346
> >         lrw(aes)     384           32768           18023           17465
> >
> > After:
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
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  crypto/lrw.c | 49 +++++++++++++++++++++++++------------------------
> >  1 file changed, 25 insertions(+), 24 deletions(-)
> >
> > diff --git a/crypto/lrw.c b/crypto/lrw.c
> > index 393a782679c7..b4f30b6f16d6 100644
> > --- a/crypto/lrw.c
> > +++ b/crypto/lrw.c
> > @@ -120,30 +120,19 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
> >       return 0;
> >  }
> >
> > -static inline void inc(be128 *iv)
> > +static int next_index(u32 *counter)
> >  {
> > -     be64_add_cpu(&iv->b, 1);
> > -     if (!iv->b)
> > -             be64_add_cpu(&iv->a, 1);
> > -}
> > -
> > -/* this returns the number of consequative 1 bits starting
> > - * from the right, get_index128(00 00 00 00 00 00 ... 00 00 10 FB) = 2 */
> > -static inline int get_index128(be128 *block)
> > -{
> > -     int x;
> > -     __be32 *p = (__be32 *) block;
> > -
> > -     for (p += 3, x = 0; x < 128; p--, x += 32) {
> > -             u32 val = be32_to_cpup(p);
> > -
> > -             if (!~val)
> > -                     continue;
> > +     int i, res = 0;
> >
> > -             return x + ffz(val);
> > +     for (i = 0; i < 4; i++) {
> > +             if (counter[i] + 1 != 0) {
> > +                     res += ffz(counter[i]++);
> > +                     break;
> > +             }
> > +             counter[i] = 0;
> > +             res += 32;
> >       }
> > -
> > -     return x;
> > +     return res;
> >  }
>
> This looks good, but can you leave the comment that says it returns the number
> of leading 1's in the counter?  And now that it increments the counter too.

Good idea, will do.

>
> Actually, I think it's wrong in the case where the counter is all 1's and wraps
> around.  It will XOR with ->mulinc[128], which is off the end of the array,
> instead of the correct value of ->mulinc[127]... But that's an existing bug :-/

Oh, right, good catch!

> (If you do want to fix that, please do it in a separate patch, probably
> preceding this one in the series, and add a test vector that covers it...)

Yeah, will do that.

>
> >
> >  static int post_crypt(struct skcipher_request *req)
> > @@ -209,8 +198,9 @@ static int pre_crypt(struct skcipher_request *req)
> >       struct scatterlist *sg;
> >       unsigned cryptlen;
> >       unsigned offset;
> > -     be128 *iv;
> >       bool more;
> > +     __u32 *iv;
> > +     u32 counter[4];
>
> 'iv' should be '__be32 *', not '__u32 *'.

Yep.

>
> >       int err;
> >
> >       subreq = &rctx->subreq;
> > @@ -227,6 +217,11 @@ static int pre_crypt(struct skcipher_request *req)
> >       err = skcipher_walk_virt(&w, subreq, false);
> >       iv = w.iv;
> >
> > +     counter[0] = be32_to_cpu(iv[3]);
> > +     counter[1] = be32_to_cpu(iv[2]);
> > +     counter[2] = be32_to_cpu(iv[1]);
> > +     counter[3] = be32_to_cpu(iv[0]);
> > +
> >       while (w.nbytes) {
> >               unsigned int avail = w.nbytes;
> >               be128 *wsrc;
> > @@ -242,10 +237,16 @@ static int pre_crypt(struct skcipher_request *req)
> >                       /* T <- I*Key2, using the optimization
> >                        * discussed in the specification */
> >                       be128_xor(&rctx->t, &rctx->t,
> > -                               &ctx->mulinc[get_index128(iv)]);
> > -                     inc(iv);
> > +                               &ctx->mulinc[next_index(counter)]);
> >               } while ((avail -= bs) >= bs);
> >
> > +             if (w.nbytes == w.total) {
> > +                     iv[0] = cpu_to_be32(counter[3]);
> > +                     iv[1] = cpu_to_be32(counter[2]);
> > +                     iv[2] = cpu_to_be32(counter[1]);
> > +                     iv[3] = cpu_to_be32(counter[0]);
> > +             }
> > +
> >               err = skcipher_walk_done(&w, avail);
> >       }
> >
> > --
> > 2.17.1
> >
>
> - Eric

Thanks,
-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Associate Software Engineer, Security Technologies
Red Hat, Inc.
