Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F78C43387
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Jan 2019 11:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37E4C20656
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Jan 2019 11:54:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="M20DtUKR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbfAOLyC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:54:02 -0500
Received: from mail-ua1-f68.google.com ([209.85.222.68]:38567 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbfAOLyC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 06:54:02 -0500
Received: by mail-ua1-f68.google.com with SMTP id p9so809250uaa.5
        for <linux-crypto@vger.kernel.org>; Tue, 15 Jan 2019 03:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGZ8jmwFtpmyKE1bae9s1cFmCnLiCPqF39zEMxqmUIk=;
        b=M20DtUKRFqZeeuuhf4mbmFrkhb3K5dyZ2KnkjvinKesWO2GLPsHjVnmb4CZ0Ihf7wi
         w3SsxUmZq22ehZllF7uAEZjXUeLyZoKi2x/s/5djqylxvayIp0BS5aW704B/C8s7FCC7
         7mVIgqLPamTWGaBnyq75aAtxXKPbzRA1WieKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGZ8jmwFtpmyKE1bae9s1cFmCnLiCPqF39zEMxqmUIk=;
        b=iI5g7uEr8XoDw2EFSP/3qVnntboh6N4qFjKJsIFXbYPQH4L+WITB+qYzEdUg9OyMIu
         QBxZcRI+1vu86arm3mstAxmppBC67QScTTS/0jxWUvBQI+CDvHyw+Ae3HIk0+xs/b2oR
         c7lNboUzHvKkMpxuAY9jV7yw6U6JxWCD7Uown9bUQbtXBBuVBrlBx61HuiuWvsmB1QFy
         Cpv57TN1F3YXCkpO3qnUK35HJz2Zolxzoks+fpMugBgLZfmRc8oWVtOaUbJyVfbG+7vH
         lOaSFz3OGtuTrbOUOBexBvnEoN0sxDoZ8EhMz64oqkne66IbmsyLs7FyM4Ty9ri6alET
         LV4Q==
X-Gm-Message-State: AJcUukdFUsfO0MB4oNS0TNUcbBpPQxSFv4CSv6OeKYq9NThEutG80Jse
        wb7KQOBtNYgfDRcGOs3d4JW1GPgp2I+QpAA7F+zp2w==
X-Google-Smtp-Source: ALg8bN6dAB1cphC4ghhhPcCf5peHRxAozdhR4j/11tumXfCuPWXnblFrrqTDpRafqWZ68nAvx9oJClVx/O6ymWXXiHI=
X-Received: by 2002:a9f:314c:: with SMTP id n12mr1486974uab.33.1547553240372;
 Tue, 15 Jan 2019 03:54:00 -0800 (PST)
MIME-Version: 1.0
References: <1547207251-9372-1-git-send-email-sumit.garg@linaro.org>
 <1547207251-9372-2-git-send-email-sumit.garg@linaro.org> <6a01fee4-4331-be63-9a78-c4d646b43d29@redhat.com>
In-Reply-To: <6a01fee4-4331-be63-9a78-c4d646b43d29@redhat.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Tue, 15 Jan 2019 17:23:48 +0530
Message-ID:
 <CAFA6WYNmALRBZ=_61e__rMeVsRNJjUOB=E2Gc4RHzMF0OvqhcQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] tee: add bus driver framework for TEE based devices
To:     Bhupesh Sharma <bhsharma@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Jens Wiklander <jens.wiklander@linaro.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
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
Message-ID: <20190115115348.niKwZW2BB6L9mqAZHJh3NybotZturnSY798dFxbU8AU@z>

On Fri, 11 Jan 2019 at 20:39, Bhupesh Sharma <bhsharma@redhat.com> wrote:
>
> Hi Sumit,
>
> Thanks for the patch. Some nitpicks in-line:
>

Apologies for delay in my response as I was on leave. Please find my
comments inline.

Will include these nitpicks in v4 but let me wait for any further
major comments.

> On 01/11/2019 05:17 PM, Sumit Garg wrote:
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
> >   drivers/tee/tee_core.c  | 43 ++++++++++++++++++++++++++++++++++++++++---
> >   include/linux/tee_drv.h | 36 ++++++++++++++++++++++++++++++++++++
> >   2 files changed, 76 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > index 7b2bb4c..a685940 100644
> > --- a/drivers/tee/tee_core.c
> > +++ b/drivers/tee/tee_core.c
> > @@ -15,7 +15,6 @@
> >   #define pr_fmt(fmt) "%s: " fmt, __func__
> >
> >   #include <linux/cdev.h>
> > -#include <linux/device.h>
> >   #include <linux/fs.h>
> >   #include <linux/idr.h>
> >   #include <linux/module.h>
> > @@ -1027,6 +1026,30 @@ int tee_client_invoke_func(struct tee_context *ctx,
> >   }
> >   EXPORT_SYMBOL_GPL(tee_client_invoke_func);
> >
> > +static int tee_client_device_match(struct device *dev,
> > +                                struct device_driver *drv)
> > +{
> > +     struct tee_client_device *tee_device;
> > +     const struct tee_client_device_id *id_table;
> > +
> > +     tee_device = to_tee_client_device(dev);
> > +     id_table = to_tee_client_driver(drv)->id_table;
> > +
> > +     while (!uuid_is_null(&id_table->uuid)) {
> > +             if (uuid_equal(&tee_device->id.uuid, &id_table->uuid))
> > +                     return 1;
> > +             id_table++;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +struct bus_type tee_bus_type = {
> > +     .name           = "tee",
> > +     .match          = tee_client_device_match,
> > +};
> > +EXPORT_SYMBOL_GPL(tee_bus_type);
> > +
> >   static int __init tee_init(void)
> >   {
> >       int rc;
> > @@ -1040,10 +1063,23 @@ static int __init tee_init(void)
> >       rc = alloc_chrdev_region(&tee_devt, 0, TEE_NUM_DEVICES, "tee");
> >       if (rc) {
> >               pr_err("failed to allocate char dev region\n");
> > -             class_destroy(tee_class);
> > -             tee_class = NULL;
> > +             goto chrdev_err;
> >       }
> >
> > +     rc = bus_register(&tee_bus_type);
> > +     if (rc) {
> > +             pr_err("failed to register tee bus\n");
> > +             goto bus_err;
> > +     }
> > +
> > +     return 0;
> > +
> > +bus_err:
> > +     unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> > +chrdev_err:
> > +     class_destroy(tee_class);
> > +     tee_class = NULL;
> > +
>
> Hmm.. these error paths/labels look out-of-order.
> See 'drivers/i2c/i2c-dev.c' for example.
>
> Normally our error paths in an __init function is of the same order as
> the __exit function implementation. So this should be changed to
> something like:
>
>    +out_unreg_class:
>    +    class_destroy(tee_class);
>    +    tee_class = NULL;
>    +out_unreg_chrdev:
>    +    unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
>

It seems that prior to this patch also allocation order in __init
function differed from release order in __exit function. Will correct
that too along with this.

> >       return rc;
> >   }
> >
> > @@ -1052,6 +1088,7 @@ static void __exit tee_exit(void)
> >       class_destroy(tee_class);
> >       tee_class = NULL;
> >       unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> > +     bus_unregister(&tee_bus_type);
>
> Since the __exit function order is the reverse of the __init one, lets
> reorder this as:
>
>   +     bus_unregister(&tee_bus_type);
>         class_destroy(tee_class);
>         tee_class = NULL;
>         unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
>

Ok.

> See 'drivers/i2c/i2c-dev.c' for example.
>
> >   }
> >
> >   subsys_initcall(tee_init);
> > diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
> > index 6cfe058..ed16bf1 100644
> > --- a/include/linux/tee_drv.h
> > +++ b/include/linux/tee_drv.h
> > @@ -20,6 +20,8 @@
> >   #include <linux/kref.h>
> >   #include <linux/list.h>
> >   #include <linux/tee.h>
> > +#include <linux/device.h>
> > +#include <linux/uuid.h>
>
> If possible, let's keep alphabetical order of header files when making
> changes in the patch.
>

Ok.

> >
> >   /*
> >    * The file describes the API provided by the generic TEE driver to the
> > @@ -538,4 +540,38 @@ static inline bool tee_param_is_memref(struct tee_param *param)
> >       }
> >   }
> >
> > +extern struct bus_type tee_bus_type;
> > +
> > +/**
> > + * struct tee_client_device_id - tee based device identifier
> > + * @uuid:            For TEE based client devices we use the device uuid
> > + *                   as the identifier.
> > + */
> > +struct tee_client_device_id {
> > +     uuid_t uuid;
> > +};
>
> Hmm.. Do we really need a struct for a single element, rather lets use a
> simple typedef here.
>

Agree, will rather use typedef here.

> > +
> > +/**
> > + * struct tee_client_device - tee based device
> > + * @id:                      device identifier
> > + * @dev:             device structure
> > + */
> > +struct tee_client_device {
> > +     struct tee_client_device_id id;
> > +     struct device dev;
> > +};
>
> Add a blank line here.
>

Ok.

> > +#define to_tee_client_device(d) container_of(d, struct tee_client_device, dev)
> > +
> > +/**
> > + * struct tee_client_driver - tee client driver
> > + * @id_table:                device id table supported by this driver
> > + * @driver:          driver structure
> > + */
> > +struct tee_client_driver {
> > +     const struct tee_client_device_id *id_table;
> > +     struct device_driver driver;
> > +};
>
> Add a blank line here.

Ok.

-Sumit

> > +#define to_tee_client_driver(d) \
> > +             container_of(d, struct tee_client_driver, driver)
> > +
> >   #endif /*__TEE_DRV_H*/
> >
>
> Thanks,
> Bhupesh
