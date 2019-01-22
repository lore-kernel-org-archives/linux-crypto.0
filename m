Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AE3C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 13:34:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B26A20870
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 13:34:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="FUkP7iMW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbfAVNeJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 08:34:09 -0500
Received: from mail-ua1-f65.google.com ([209.85.222.65]:47059 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbfAVNeJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 08:34:09 -0500
Received: by mail-ua1-f65.google.com with SMTP id v24so8027077uap.13
        for <linux-crypto@vger.kernel.org>; Tue, 22 Jan 2019 05:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EfdIwdbRK43b54fj1Noa2nq7BBPRmS7ID38/9dZ/ej4=;
        b=FUkP7iMW/ncP9QxPm4dgq077EOzpkKzOfWnQBowPhnBrEqdTXPoiLpfl0tqMsu5bRM
         aHDcFFejbqmZfz2hbI/G3BY4HjhhuDEppkf3CFMxOf+1K/cW217ni0+m71fXMtwmXc/Z
         VfMIHP8v8u3N+9+Qtg/NN0eYXub86epKYCtG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EfdIwdbRK43b54fj1Noa2nq7BBPRmS7ID38/9dZ/ej4=;
        b=m7/1xvoJbVR2dZx4kYuCVoFnUO1Q6qm+3cnvD+j1boOEw8XqgAOjCrMkcpofnazkZS
         4EmETBuM/6/rimg1368arhh38fA1h9XuoBBYl+u30qiqBXHO4oLVM8pKqObMqVVGZJsO
         csue/VG2FZ5qsYMoKhkbnN8F+BCVZrxcNUNX/MZLq7mk+N1IQ8BLjOwPUOdhIVCffFP2
         fX39+PT7jVpPNp46LX87IsmfFGgPhJWALbt6fK1II4tNxVGdwQy54qBn75dtWPBFh7C0
         lNO6iKmMWw/StaPOXUgy9Xz7p8bzMpFwvkzvXyClvZ/2i1X6nVxPZ+x0TyTuXSnV4tub
         u5Ug==
X-Gm-Message-State: AJcUukfHoN525L9LLPWvYEKyXxOlo48eEZr8tTmtn8We4dtcwvK67VvW
        0afi+7Wb4SB//coBCDH63FRs/RgSBJv+xrvcSdlaQQ==
X-Google-Smtp-Source: ALg8bN4l8lnSDBnIygvscA7mC5eSoxhJVCjQV6W+yI7/heRBXhQV1fCZ+6BEgWVNY/Upa/uHx/mzjeq8JGTuGJSLHcM=
X-Received: by 2002:ab0:148e:: with SMTP id d14mr13161268uae.23.1548164047542;
 Tue, 22 Jan 2019 05:34:07 -0800 (PST)
MIME-Version: 1.0
References: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
 <1548062959-31860-2-git-send-email-sumit.garg@linaro.org> <CACi5LpMN2N1joWxmwDy=DtH+stenUs64oJ2_T4T-7sSoS=NAgw@mail.gmail.com>
In-Reply-To: <CACi5LpMN2N1joWxmwDy=DtH+stenUs64oJ2_T4T-7sSoS=NAgw@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 22 Jan 2019 19:03:56 +0530
Message-ID: <CAFA6WYNDt2Mf3cwPrgfCpxYrCZ5Z1eMD9ieu0sfUCNeCSmu=RA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] tee: add bus driver framework for TEE based devices
To:     Bhupesh Sharma <bhsharma@redhat.com>
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mpm@selenic.com, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Jan 2019 at 20:58, Bhupesh Sharma <bhsharma@redhat.com> wrote:
>
> Hi Sumit,
>
> On Mon, Jan 21, 2019 at 3:00 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > Introduce a generic TEE bus driver concept for TEE based kernel drivers
> > which would like to communicate with TEE based devices/services.
> >
> > In this TEE bus concept, devices/services are identified via Universally
> > Unique Identifier (UUID) and drivers register a table of device UUIDs
> > which they can support.
> >
> > So this TEE bus framework registers a match() callback function which
> > iterates over the driver UUID table to find a corresponding match for
> > device UUID. If a match is found, then this particular device is probed
> > via corresponding probe api registered by the driver. This process
> > happens whenever a device or a driver is registered with TEE bus.
> >
> > Also this framework allows for device enumeration to be specific to
> > corresponding TEE implementation like OP-TEE etc.
> >
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > ---
> >  drivers/tee/tee_core.c  | 45 +++++++++++++++++++++++++++++++++++++++++----
> >  include/linux/tee_drv.h | 37 ++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 77 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > index 7b2bb4c..55370d5 100644
> > --- a/drivers/tee/tee_core.c
> > +++ b/drivers/tee/tee_core.c
> > @@ -15,7 +15,6 @@
> >  #define pr_fmt(fmt) "%s: " fmt, __func__
> >
> >  #include <linux/cdev.h>
> > -#include <linux/device.h>
> >  #include <linux/fs.h>
> >  #include <linux/idr.h>
> >  #include <linux/module.h>
> > @@ -1027,6 +1026,30 @@ int tee_client_invoke_func(struct tee_context *ctx,
> >  }
> >  EXPORT_SYMBOL_GPL(tee_client_invoke_func);
> >
> > +static int tee_client_device_match(struct device *dev,
> > +                                  struct device_driver *drv)
> > +{
> > +       const tee_client_device_id *id_table;
> > +       struct tee_client_device *tee_device;
> > +
> > +       id_table = to_tee_client_driver(drv)->id_table;
> > +       tee_device = to_tee_client_device(dev);
> > +
> > +       while (!uuid_is_null(id_table)) {
> > +               if (uuid_equal(&tee_device->id, id_table))
> > +                       return 1;
> > +               id_table++;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> > +struct bus_type tee_bus_type = {
> > +       .name           = "tee",
> > +       .match          = tee_client_device_match,
> > +};
> > +EXPORT_SYMBOL_GPL(tee_bus_type);
> > +
> >  static int __init tee_init(void)
> >  {
> >         int rc;
> > @@ -1040,18 +1063,32 @@ static int __init tee_init(void)
> >         rc = alloc_chrdev_region(&tee_devt, 0, TEE_NUM_DEVICES, "tee");
> >         if (rc) {
> >                 pr_err("failed to allocate char dev region\n");
> > -               class_destroy(tee_class);
> > -               tee_class = NULL;
> > +               goto out_unreg_class;
> >         }
> >
> > +       rc = bus_register(&tee_bus_type);
> > +       if (rc) {
> > +               pr_err("failed to register tee bus\n");
> > +               goto out_unreg_chrdev;
> > +       }
> > +
> > +       return 0;
> > +
> > +out_unreg_chrdev:
> > +       unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> > +out_unreg_class:
> > +       class_destroy(tee_class);
> > +       tee_class = NULL;
> > +
> >         return rc;
> >  }
> >
> >  static void __exit tee_exit(void)
> >  {
> > +       bus_unregister(&tee_bus_type);
> > +       unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> >         class_destroy(tee_class);
> >         tee_class = NULL;
> > -       unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> >  }
> >
> >  subsys_initcall(tee_init);
> > diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
> > index 6cfe058..ba985d8 100644
> > --- a/include/linux/tee_drv.h
> > +++ b/include/linux/tee_drv.h
> > @@ -15,11 +15,13 @@
> >  #ifndef __TEE_DRV_H
> >  #define __TEE_DRV_H
> >
> > -#include <linux/types.h>
> > +#include <linux/device.h>
> >  #include <linux/idr.h>
> >  #include <linux/kref.h>
> >  #include <linux/list.h>
> >  #include <linux/tee.h>
> > +#include <linux/types.h>
> > +#include <linux/uuid.h>
> >
> >  /*
> >   * The file describes the API provided by the generic TEE driver to the
> > @@ -538,4 +540,37 @@ static inline bool tee_param_is_memref(struct tee_param *param)
> >         }
> >  }
> >
> > +extern struct bus_type tee_bus_type;
> > +
> > +/*
> > + * For TEE based client devices we use the device uuid as the
> > + * identifier.
> > + */
> > +typedef uuid_t tee_client_device_id;
> > +
> > +/**
> > + * struct tee_client_device - tee based device
> > + * @id:                        device identifier
> > + * @dev:               device structure
> > + */
> > +struct tee_client_device {
> > +       tee_client_device_id id;
> > +       struct device dev;
> > +};
> > +
> > +#define to_tee_client_device(d) container_of(d, struct tee_client_device, dev)
> > +
> > +/**
> > + * struct tee_client_driver - tee client driver
> > + * @id_table:          device id table supported by this driver
> > + * @driver:            driver structure
> > + */
> > +struct tee_client_driver {
> > +       const tee_client_device_id *id_table;
> > +       struct device_driver driver;
> > +};
> > +
> > +#define to_tee_client_driver(d) \
> > +               container_of(d, struct tee_client_driver, driver)
> > +
> >  #endif /*__TEE_DRV_H*/
> > --
> > 2.7.4
> >
>
> LGTM, if there are no further comments on this patch please free to add:
> Reviewed-by: Bhupesh Sharma <bhsharma@redhat.com>
>

Thanks for this review tag. Actually I have to add support in module
device table for TEE bus devices as per Ard's comments on patch #4. So
that will require changes in this patch in next version.

-Sumit

> Thanks.
