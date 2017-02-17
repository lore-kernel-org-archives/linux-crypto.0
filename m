From: Dennis Chen <dennis.chen@arm.com>
Subject: Re: [PATCH] crypto: Fix next IV issue for CTS template
Date: Fri, 17 Feb 2017 17:17:27 +0800
Message-ID: <20170217091724.GA28198@arm.com>
References: <1487303262-5602-1-git-send-email-Libo.Wang@arm.com>
 <CAKv+Gu8s6PrAv9ZMGa_TsRn2UYKoo8KhqERU0NZPjfBhMDK88Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <Libo.Wang@arm.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        <Ofir.Drang@arm.com>, <nd@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0054.outbound.protection.outlook.com ([104.47.1.54]:21879
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755684AbdBQJRr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 04:17:47 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8s6PrAv9ZMGa_TsRn2UYKoo8KhqERU0NZPjfBhMDK88Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Ard,
Morning!
On Fri, Feb 17, 2017 at 07:12:46AM +0000, Ard Biesheuvel wrote:
> Hello Libo,
> 
> On 17 February 2017 at 03:47,  <Libo.Wang@arm.com> wrote:
> > From: Libo Wang <Libo Wang@arm.com>
> >
> > CTS template assumes underlying CBC algorithm will carry out next IV for
> > further process.But some implementations of CBC algorithm in kernel break
> > this assumption, for example, some hardware crypto drivers ignore next IV
> > for performance consider, inthis case, tcry cts(cbc(aes)) test case will
> > fail. This patch is trying to fix it by getting next IV information ready
> > before last two blocks processed.
> >
> > Signed-off-by: Libo Wang <libo.wang@arm.com>
> > Signed-off-by: Dennis Chen <dennis.chen@arm.com>
> 
> Which algorithms in particular break this assumption? I recently fixed
> some ARM accelerated software drivers for this reason. If there are
> others, we should fix those rather than try to fix it in the CTS
> driver.
>
There're some ARM HW accelerated drivers which are not upstream yet(IP license)
breaks this assumption. The current CTS template requires the underlying CBC 
algorithm always fill the next IV, but in some cases like CBC standalone mode, 
it doesn't need to fill the next IV, so apparently it will induce performance
degrade from the point of drivers, that's why we fix it in the CTS template,except
that it will also mitigate the potential defect of other HW-based CBC drivers. 
> 
> > ---
> >  crypto/cts.c | 29 +++++++++++++++++++++++++----
> >  1 file changed, 25 insertions(+), 4 deletions(-)
> >
> > diff --git a/crypto/cts.c b/crypto/cts.c
> > index a1335d6..712164b 100644
> > --- a/crypto/cts.c
> > +++ b/crypto/cts.c
> > @@ -154,6 +154,7 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
> >         unsigned int nbytes = req->cryptlen;
> >         int cbc_blocks = (nbytes + bsize - 1) / bsize - 1;
> >         unsigned int offset;
> > +       int ret = 0;
> >
> >         skcipher_request_set_tfm(subreq, ctx->child);
> >
> > @@ -174,8 +175,17 @@ static int crypto_cts_encrypt(struct skcipher_request *req)
> >         skcipher_request_set_crypt(subreq, req->src, req->dst,
> >                                    offset, req->iv);
> >
> > -       return crypto_skcipher_encrypt(subreq) ?:
> > -              cts_cbc_encrypt(req);
> > +       /* process CBC blocks */
> > +       ret = crypto_skcipher_encrypt(subreq);
> > +       /* process last two blocks */
> > +       if (!ret) {
> 
> What happens if an async driver returns -EINPROGRESS here?
For this case, the CTS will return -EINPROGRESS directly.

Thanks,
Dennis
> 
> > +               /* Get IVn-1 back */
> > +               scatterwalk_map_and_copy(req->iv, req->dst, (offset - bsize), bsize, 0);
> > +               /* Continue last two blocks */
> > +               return cts_cbc_encrypt(req);
> > +       }
> > +
> > +       return ret;
> >  }
> >
> >  static int cts_cbc_decrypt(struct skcipher_request *req)
> > @@ -248,6 +258,8 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
> >         int cbc_blocks = (nbytes + bsize - 1) / bsize - 1;
> >         unsigned int offset;
> >         u8 *space;
> > +       int ret = 0;
> > +       u8 iv_next[bsize];
> >
> >         skcipher_request_set_tfm(subreq, ctx->child);
> >
> > @@ -277,8 +289,17 @@ static int crypto_cts_decrypt(struct skcipher_request *req)
> >         skcipher_request_set_crypt(subreq, req->src, req->dst,
> >                                    offset, req->iv);
> >
> > -       return crypto_skcipher_decrypt(subreq) ?:
> > -              cts_cbc_decrypt(req);
> > +       /* process last two blocks */
> > +       scatterwalk_map_and_copy(iv_next, req->src, (offset - bsize), bsize, 0);
> > +       ret = crypto_skcipher_decrypt(subreq);
> > +       if (!ret) {
> > +               /* Set Next IV */
> > +               subreq->iv = iv_next;
> > +               /* process last two blocks */
> > +               return cts_cbc_decrypt(req);
> > +       }
> > +
> > +       return ret;
> >  }
> >
> >  static int crypto_cts_init_tfm(struct crypto_skcipher *tfm)
> > --
> > 1.8.3.1
> >
