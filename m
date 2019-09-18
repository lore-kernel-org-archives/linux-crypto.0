Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4CCC4CEC9
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 03:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4E4721929
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 03:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwkMmrkp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfIRDN1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 23:13:27 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39227 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfIRDN1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 23:13:27 -0400
Received: by mail-io1-f67.google.com with SMTP id a1so12718289ioc.6;
        Tue, 17 Sep 2019 20:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rEYrYVf7tayatQ3DYC0kTCJs8LfnvOcz1FP4YQiGvH0=;
        b=iwkMmrkpLOVrUWbglP/bGxLXRzql4VUpt07f9PwQ63DTCGvsGcuJr0LiPtQVDPBGmY
         ytWRz2B6xKTr0FOe6L0aYegE8ovH7fhvurJf5vyGjONPG/iamJ2dVtT4Jf+LIgZqz9dU
         Vw/9YTXE/2JfU1A8D1+MrD2aVCA1tRs+yCkp8s3s3EUGMRnQ72eLv39xiHZkg5YyPD+b
         fXFFbgVdjkSJgtY2tkI9qxEfitdirMQ5uPeMOveZiNrAqoJb1mZj2qrpTvoJ/AiA5vOH
         KHyJIaU/E0SuiMuUe3i3SLcx+8cijgrRORY/RnBGGyBJ1fkLY9vnazx6UcQwMKuIuOlI
         ixdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rEYrYVf7tayatQ3DYC0kTCJs8LfnvOcz1FP4YQiGvH0=;
        b=Zzsr81QrZB1FMMvgSLB8u59d6okzY+/kn6EUGmixtE2IGGaz9c5RgCcZSODphf2kyf
         ENZib8jl8rvV/zDA7XUgKm5pnB7vX7uWbsTEa4+h1Rm4ahEtZV4y+ModieHoDtbop9UB
         nDVHjDpTnj/Q2RWP2XEka2X9S+6AyX7L3MDEzxBooHY5zATnbTUO6W0drhucKGgkvdlr
         ZOw9lMgcUedINNjVMGEp+j8NzLReuuPLglkH0wXAOoBuff/DW0f3LUBoIuqoejDRzs9O
         efpDSlJ3iciNZDKj5f0CTLv4YrMs8IzJ6RZoLiMMcMfQLpqfqGQ9mgPxZjsWWZvVd5Fu
         5u0A==
X-Gm-Message-State: APjAAAVXLJ1G9mDjkbHynar4f88Salqxw1liy8cKfmRZpVCBcEGB4zMh
        rH+IN3A99H4SXjIcdxYXBqC1kEs8vnvL7sJU3+Ruzg+u
X-Google-Smtp-Source: APXvYqwKLHQFmA4Otct7QWIL2a5sh57LVlYorkW4vsJYH+WZmwY4laCsPTSf2uUXFRZC7fw180iNewLBEKuu3deIl7E=
X-Received: by 2002:a5e:a712:: with SMTP id b18mr2778793iod.263.1568776405915;
 Tue, 17 Sep 2019 20:13:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-13-andrew.smirnov@gmail.com> <VI1PR04MB7023A7EC91599A537CB6A487EEB30@VI1PR04MB7023.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB7023A7EC91599A537CB6A487EEB30@VI1PR04MB7023.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 17 Sep 2019 20:13:14 -0700
Message-ID: <CAHQ1cqEkdUJGxUnRQbJSG9L32yC0HVmddzi4GyOkVfq2uvJOMQ@mail.gmail.com>
Subject: Re: [PATCH 12/12] crypto: caam - change JR device ownership scheme
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 13, 2019 at 12:16 PM Leonard Crestez
<leonard.crestez@nxp.com> wrote:
>
> On 04.09.2019 05:35, Andrey Smirnov wrote:
> > Returning -EBUSY from platform device's .remove() callback won't stop
> > the removal process, so the code in caam_jr_remove() is not going to
> > have the desired effect of preventing JR from being removed.
> >
> > In order to be able to deal with removal of the JR device, change the
> > code as follows:
> >
> >    1. To make sure that underlying struct device remains valid for as
> >       long as we have a reference to it, add appropriate device
> >       refcount management to caam_jr_alloc() and caam_jr_free()
> >
> >    2. To make sure that device removal doesn't happen in parallel to
> >        use using the device in caam_jr_enqueue() augment the latter to
> >        acquire/release device lock for the duration of the subroutine
> >
> >    3. In order to handle the case when caam_jr_enqueue() is executed
> >       right after corresponding caam_jr_remove(), add code to check
> >       that driver data has not been set to NULL.
>
> What happens if a driver is unbound while a transform is executing
> asynchronously?
>

AFAICT caam_jr_shutdown() is going to disable JR's interrupt and kill
corresponding tasklet, so I think that transform will never finish. We
probably could handle that better by walking the list of unfinished
jobs and calling their callbacks with an appropriate error code.

> Doing get_device and put_device in caam_jr_alloc and caam_jr_free
> doesn't protect you against an explicit unbind of caam_jr, that path
> doesn't care about device reference counts. For example on imx6qp:
>

My thinking with get_device() and put_device() was to prevent struct
device * from being freed while we are using it. The intent with
explicit unbind was to protect against it by
device_lock()/device_unlock() as a well as check that device data is
not NULL. I think I did miss code to do that in caam_jr_free() before
accessing tfm_count.


> # echo 2102000.jr1 > /sys/bus/platform/drivers/caam_jr/unbind
>

A bit of a silly question, but is this with my patches applied or
against the vanilla driver?

> CPU: 2 PID: 561 Comm: bash Not tainted 5.3.0-rc7-next-20190904
> Hardware name: Freescale i.MX6 Quad/DualLite (Device Tree)
> Backtrace:
> [<c010f8a4>] (dump_backtrace) from [<c010fc5c>] (show_stack+0x20/0x24)
> [<c010fc3c>] (show_stack) from [<c0d21600>] (dump_stack+0xdc/0x114)
> [<c0d21524>] (dump_stack) from [<c0955774>] (caam_jr_remove+0x24/0xf8)
> [<c0955750>] (caam_jr_remove) from [<c06e2d98>]
> (platform_drv_remove+0x34/0x4c)
> [<c06e2d64>] (platform_drv_remove) from [<c06e0b74>]
> (device_release_driver_internal+0xf8/0x1b0)
> [<c06e0a7c>] (device_release_driver_internal) from [<c06e0c70>]
> (device_driver_detach+0x20/0x24)
> [<c06e0c50>] (device_driver_detach) from [<c06de5a4>]
> (unbind_store+0x6c/0xe0)
> [<c06de538>] (unbind_store) from [<c06dd950>] (drv_attr_store+0x30/0x3c)
> [<c06dd920>] (drv_attr_store) from [<c0364c18>] (sysfs_kf_write+0x50/0x5c)
> [<c0364bc8>] (sysfs_kf_write) from [<c0363e0c>]
> (kernfs_fop_write+0x10c/0x1f8)
> [<c0363d00>] (kernfs_fop_write) from [<c02c3a30>] (__vfs_write+0x44/0x1d0)
> [<c02c39ec>] (__vfs_write) from [<c02c68ec>] (vfs_write+0xb0/0x194)
> [<c02c683c>] (vfs_write) from [<c02c6b7c>] (ksys_write+0x64/0xd8)
> [<c02c6b18>] (ksys_write) from [<c02c6c08>] (sys_write+0x18/0x1c)
> [<c02c6bf0>] (sys_write) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
>
> I think you need to do some form of slow wait loop in jrpriv until
> jrpriv->tfm_count reaches zero.

Hmm, what do we do if it never does? Why do you think it would be
better than cancelling all outstanding jobs and resetting the HW?

> Preventing new operations from starting
> would help but isn't strictly necessary for correctness.

Wouldn't it be strictly necessary if you want to wait for tfm_count
reaching zero?

Thanks,
Andrey Smirnov
