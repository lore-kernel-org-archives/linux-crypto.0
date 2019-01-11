Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B607C43387
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 09:57:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDAC720872
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 09:57:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="QgSAZmqy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfAKJ5N (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jan 2019 04:57:13 -0500
Received: from mail-vs1-f66.google.com ([209.85.217.66]:39353 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729792AbfAKJ5M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 04:57:12 -0500
Received: by mail-vs1-f66.google.com with SMTP id h78so8856673vsi.6
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 01:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdxivZjww+kdiSrhuzC1PWn78pP7JY13s0K0FNua8kQ=;
        b=QgSAZmqy+LoU5cca445Mn/9Qjb4V+2eRA4M90GScviuRacw1X5qVNSdDk12BEX48jj
         w97mbncn2bJOmB2FO/HI82hxjJ0sNIYDyqGD98Nu5lXttJNP1HO2MxAwAseEIYcePsWZ
         et/UJL8NdNyjaDaOWruepTft55hi/eDaF38PI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hdxivZjww+kdiSrhuzC1PWn78pP7JY13s0K0FNua8kQ=;
        b=b6Kwggoyau7rlNecXxJ0E32ey7GSe2R3ASMlMxGM3A5xV3SCvmhvBUNM0BadRxPPHR
         UqRTNBVimMHJEYV/WN59+mRr/0QrR4vSe3fMcDTB4NSbBam5KsaMSrwzwVMiWCz6mUM9
         AYT8C6qCIbyTefGNYt+34DvYh4Smi2XacCEq8ojuFWUXDHxvBc4I+ulWdyMzXY/MY+m9
         QNnVhWAUFseU0qCWse11/7cejQ9744iNX/yiaKkeSEGLu9OgNLswWrnpR3DmO3Izqbtc
         IpYSq1vK4ppGfvT4TyBvOu/CWmvKLlyrYj1TylflAuX/Y/UWQGdem/HAgM4wKrNuUva4
         Qweg==
X-Gm-Message-State: AJcUuke6JAT9UGYzpFcF+6foomFSxAK7QTq3e3+HQ+NLtxN+cPKp6WGZ
        E5i3xMooEv7bi0hued714ncJgGIaVBCRpD8OJwALCg==
X-Google-Smtp-Source: ALg8bN7gBLpnCYKzcoKbQM+Py6BQ9g4M4vk28CNSgFNbS2ONxp7bUleFVwMZ1lWpqEpu1bWOJ0Jw1ZB6656JfxVec8M=
X-Received: by 2002:a67:8cc2:: with SMTP id o185mr5575802vsd.55.1547200631444;
 Fri, 11 Jan 2019 01:57:11 -0800 (PST)
MIME-Version: 1.0
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-4-git-send-email-sumit.garg@linaro.org> <20190110142355.bcgw62w2qk2mlzj6@holly.lan>
 <CAFA6WYPzA+rKMq58xVPghSe-mLa6fDi4t=1DYxakEaeG+ayQug@mail.gmail.com> <20190111095414.nbnzbocdn32zypdc@holly.lan>
In-Reply-To: <20190111095414.nbnzbocdn32zypdc@holly.lan>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 11 Jan 2019 15:27:00 +0530
Message-ID:
 <CAFA6WYM7JpE+h+6FC-YmqjyLo-xopeMg=d0BhOLx1C+N-tsZvA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] tee: add supp_nowait flag in tee_context struct
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
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
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190111095700.6Q_uGLdl8kP2R9wiQfDN2Gu7t-eY22__TxR3oY3QAG4@z>

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
