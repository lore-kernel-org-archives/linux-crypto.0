Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:39353 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbfAKJ5M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 04:57:12 -0500
Received: by mail-vs1-f66.google.com with SMTP id h78so8856673vsi.6
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 01:57:11 -0800 (PST)
MIME-Version: 1.0
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-4-git-send-email-sumit.garg@linaro.org> <20190110142355.bcgw62w2qk2mlzj6@holly.lan>
 <CAFA6WYPzA+rKMq58xVPghSe-mLa6fDi4t=1DYxakEaeG+ayQug@mail.gmail.com> <20190111095414.nbnzbocdn32zypdc@holly.lan>
In-Reply-To: <20190111095414.nbnzbocdn32zypdc@holly.lan>
From: Sumit Garg <sumit.garg@linaro.org>
Date: Fri, 11 Jan 2019 15:27:00 +0530
Message-ID: <CAFA6WYM7JpE+h+6FC-YmqjyLo-xopeMg=d0BhOLx1C+N-tsZvA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] tee: add supp_nowait flag in tee_context struct
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Jens Wiklander <jens.wiklander@linaro.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 11 Jan 2019 at 15:24, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
>
> On Fri, Jan 11, 2019 at 01:00:49PM +0530, Sumit Garg wrote:
> > On Thu, 10 Jan 2019 at 19:53, Daniel Thompson
> > <daniel.thompson@linaro.org> wrote:
> > > > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > > > index 9ddb89e..5d6c317 100644
> > > > --- a/drivers/tee/tee_core.c
> > > > +++ b/drivers/tee/tee_core.c
> > > > @@ -105,6 +105,7 @@ static int tee_open(struct inode *inode, struct file *filp)
> > > >       if (IS_ERR(ctx))
> > > >               return PTR_ERR(ctx);
> > > >
> > > > +     ctx->supp_nowait = false;
> > > >       filp->private_data = ctx;
> > > >       return 0;
> > > >  }
> > > > @@ -981,6 +982,7 @@ tee_client_open_context(struct tee_context *start,
> > > >       } while (IS_ERR(ctx) && PTR_ERR(ctx) != -ENOMEM);
> > > >
> > > >       put_device(put_dev);
> > > > +     ctx->supp_nowait = true;
> > >
> > > Why automatically set supp_nowait inside open_context() ?
> > >
> >
> > I think this is the default behaviour (non-blocking request) that any
> > in kernel client would expect. Also this flag could be configured
> > again before call to open_session() if any in kernel client requires
> > different behaviour.
>
> Makes sense. I think this is a deep enough behaviour to warrant proper
> commenting though.
>

Sure, will add comments.

-Sumit

>
> Daniel.
