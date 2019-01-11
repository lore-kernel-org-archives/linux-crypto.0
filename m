Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39927 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfAKJyT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 04:54:19 -0500
Received: by mail-wr1-f66.google.com with SMTP id t27so14458919wra.6
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 01:54:18 -0800 (PST)
Date: Fri, 11 Jan 2019 09:54:14 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Sumit Garg <sumit.garg@linaro.org>
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
Subject: Re: [PATCH v2 3/4] tee: add supp_nowait flag in tee_context struct
Message-ID: <20190111095414.nbnzbocdn32zypdc@holly.lan>
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-4-git-send-email-sumit.garg@linaro.org>
 <20190110142355.bcgw62w2qk2mlzj6@holly.lan>
 <CAFA6WYPzA+rKMq58xVPghSe-mLa6fDi4t=1DYxakEaeG+ayQug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYPzA+rKMq58xVPghSe-mLa6fDi4t=1DYxakEaeG+ayQug@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 11, 2019 at 01:00:49PM +0530, Sumit Garg wrote:
> On Thu, 10 Jan 2019 at 19:53, Daniel Thompson
> <daniel.thompson@linaro.org> wrote:
> > > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > > index 9ddb89e..5d6c317 100644
> > > --- a/drivers/tee/tee_core.c
> > > +++ b/drivers/tee/tee_core.c
> > > @@ -105,6 +105,7 @@ static int tee_open(struct inode *inode, struct file *filp)
> > >       if (IS_ERR(ctx))
> > >               return PTR_ERR(ctx);
> > >
> > > +     ctx->supp_nowait = false;
> > >       filp->private_data = ctx;
> > >       return 0;
> > >  }
> > > @@ -981,6 +982,7 @@ tee_client_open_context(struct tee_context *start,
> > >       } while (IS_ERR(ctx) && PTR_ERR(ctx) != -ENOMEM);
> > >
> > >       put_device(put_dev);
> > > +     ctx->supp_nowait = true;
> >
> > Why automatically set supp_nowait inside open_context() ?
> >
> 
> I think this is the default behaviour (non-blocking request) that any
> in kernel client would expect. Also this flag could be configured
> again before call to open_session() if any in kernel client requires
> different behaviour.

Makes sense. I think this is a deep enough behaviour to warrant proper
commenting though.


Daniel.
