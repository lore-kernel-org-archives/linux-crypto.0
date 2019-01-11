Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-vs1-f68.google.com ([209.85.217.68]:41979 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730155AbfAKJwE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 04:52:04 -0500
Received: by mail-vs1-f68.google.com with SMTP id t17so8831441vsc.8
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jan 2019 01:52:02 -0800 (PST)
MIME-Version: 1.0
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-3-git-send-email-sumit.garg@linaro.org> <20190110141856.p3evqyf34py74gkg@holly.lan>
 <CAFA6WYPHmtY4N9ruGLZ70FNeiDCbQE-fs+EP2px-S+GEj2nPTw@mail.gmail.com> <20190111093902.hfxb67txjhhlegzu@holly.lan>
In-Reply-To: <20190111093902.hfxb67txjhhlegzu@holly.lan>
From: Sumit Garg <sumit.garg@linaro.org>
Date: Fri, 11 Jan 2019 15:21:50 +0530
Message-ID: <CAFA6WYNp5ve=xZ1bQL+HUGK4Pz7dpzMzWy_fuS0_q8NHaZWL4Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] tee: optee: add TEE bus device enumeration support
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

On Fri, 11 Jan 2019 at 15:09, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
>
> On Fri, Jan 11, 2019 at 12:52:19PM +0530, Sumit Garg wrote:
> > On Thu, 10 Jan 2019 at 19:49, Daniel Thompson
> > <daniel.thompson@linaro.org> wrote:
> > > > +static int get_devices(struct tee_context *ctx, u32 session,
> > > > +                    struct tee_shm *device_uuid, u32 *shm_size)
> > >
> > > Missing const on device_uuid?
> > >
> >
> > I don't think we should have a const for device_uuid here as this is
> > shared memory struct pointer which is dynamically allocated and used
> > to fetch device UUIDs.
>
> Agree. Perhaps device_uuid is misnamed though (part of the reason I
> misread this is that it is singular so I though it was a single UUID
> travelling into the TZ).
>

Will rename it to device_shm instead.

> > > > +     rc = get_devices(ctx, sess_arg.session, device_shm, &shm_size);
> > > > +     if (rc < 0)
> > > > +             goto out_shm;
> > > > +
> > > > +     device_uuid = tee_shm_get_va(device_shm, 0);
> > > > +     if (IS_ERR(device_uuid)) {
> > > > +             pr_err("tee_shm_get_va failed\n");
> > > > +             rc = PTR_ERR(device_uuid);
> > > > +             goto out_shm;
> > > > +     }
> > > > +
> > > > +     while (idx < shm_size / sizeof(uuid_t)) {
> > >
> > > This is a very uncommon way to write a for loop ;-).
> > >
> >
> > Ok, will add "num_devices" variable.
>
> num_devices might add readability but that is not what I meant.
>
> The most idiomatic way to write somthing that loops for every valid index
> value is:
>
>         for (i=0; i < limit; i++)
>
> You wrote it like this:
>
>         int idx=0;
>
>         /* lots of code between initializer and first use */
>
>         while (idx < limit) {
>                 /* more code */
>                 idx++;
>         }
>
> Sure, they are equivalent but the idiomatic form is easier to read.
>

Oh okay, will use "for" loop instead.

-Sumit

>
> Daniel.
