Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:35812 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbeK2SEX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 13:04:23 -0500
MIME-Version: 1.0
References: <CA+XhMqz7ZaGVNpkrRM-t4h2f9UZVQPjLVB5Txco4bKGRm8k=mA@mail.gmail.com>
 <20181129064913.wbudlexjzszpa7dq@gondor.apana.org.au>
In-Reply-To: <20181129064913.wbudlexjzszpa7dq@gondor.apana.org.au>
From: David CARLIER <devnexen@gmail.com>
Date: Thu, 29 Nov 2018 06:59:50 +0000
Message-ID: <CA+XhMqzw9pqFw30QD=XpFTAqu+t1v5q24ODR+zynZQJJrS9xZw@mail.gmail.com>
Subject: Re: [PATCH] crypto: use memzero_explicit instead of memset to clear contexts.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Meant regardless how the kernel is compiled (ie optimisation level),
the contexts are guaranteed to be wiped because of the memory fences
used.

Kind regards.
On Thu, 29 Nov 2018 at 06:49, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Nov 28, 2018 at 07:36:50PM +0000, David CARLIER wrote:
> > There might be a little performance drop but to make sure it stands
> > by it comments, we really wipe the whole context after usage.
> > ---
> >  crypto/chacha20poly1305.c | 3 ++-
> >  crypto/md5.c              | 2 +-
> >  crypto/rmd128.c           | 3 ++-
> >  crypto/rmd160.c           | 3 ++-
> >  crypto/rmd256.c           | 3 ++-
> >  crypto/rmd320.c           | 3 ++-
> >  crypto/sha3_generic.c     | 3 ++-
> >  7 files changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
> > index 600afa99941f..6e93d998109e 100644
> > --- a/crypto/chacha20poly1305.c
> > +++ b/crypto/chacha20poly1305.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/init.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > +#include <linux/string.h>
> >
> >  #include "internal.h"
> >
> > @@ -388,7 +389,7 @@ static int poly_genkey(struct aead_request *req)
> >         }
> >
> >         sg_init_table(creq->src, 1);
> > -       memset(rctx->key, 0, sizeof(rctx->key));
> > +       memzero_explicit(rctx->key, sizeof(rctx->key));
>
> Please explain the purpose of this patch.  As it stands this
> makes no sense.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
