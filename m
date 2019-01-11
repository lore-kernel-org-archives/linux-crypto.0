Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64451C43387
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 06:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2822F20872
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 06:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ODILqu5d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfAKGlf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jan 2019 01:41:35 -0500
Received: from mail-ua1-f67.google.com ([209.85.222.67]:34485 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbfAKGlf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:41:35 -0500
Received: by mail-ua1-f67.google.com with SMTP id c24so4445785uak.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2019 22:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=insVKXAI2BdmwV+tijyrOG00REZx8cOa7WU0NuC4TI0=;
        b=ODILqu5dnmrqfImCcEVSmEtsCNihVzIzkrzUqk41vZxeCVWAZ55T/ppOs+RqYZbYQh
         BIZDM7eR2FkTRi7gQ77VBnE8GjxiMxU0yw5X1nFm1td28eNUbceS5vhFSzrpSI67vEhW
         MTURbW8vQnB0fRBMK92N1QTvXiCyvjPYgw6MY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=insVKXAI2BdmwV+tijyrOG00REZx8cOa7WU0NuC4TI0=;
        b=cppJ7zl6sDPs9xXH5dmkqHTtecqpH5H6rBiw5jc5V6hfSVROP4HLHyKB2VGRU5t+7s
         gfU0CSLvsV2rTRUbc+UA9S89xP9/hwrLAeU2FI/38omqJqXc1hTEntVVzt5ADKBHdjgw
         TBFN1yfllTO/6vkDbgdDtx8hbg7nF63aDNBeaZMQ7bBAbU5j0R/IGUubICgYO7y9KoFR
         uGQLW1RoLXcYmwVKrMsPbW7I6PxaXCfDCUN1ctrW5nmJtjsHrGLwg7MsxAu+90AS9tnX
         uQKk9HHMI0aYnXA2QwaL/mMj65Y0Tn44BR+lY70hzRNDxNPYkiT8NmAW6TUiHrFz5wU/
         JmyA==
X-Gm-Message-State: AJcUukf1fmfHLp0oTRuwcN3V9u3M1bRX9qnC6oEaxw7PvGXverxQjtN8
        9Bqs2+HhTkpLufrlCt1FKGiIuhMrBLH9W6CuARPdtQ==
X-Google-Smtp-Source: ALg8bN5o5TAmUmPaCmJgalCoDhfb2Fpe0YR7o9GrMl9Ufbuj1Ui8DXNfXYOBRu6I0EOLWPbDajSAxdap3NK12an+Z2Y=
X-Received: by 2002:a9f:314c:: with SMTP id n12mr5247700uab.33.1547188893591;
 Thu, 10 Jan 2019 22:41:33 -0800 (PST)
MIME-Version: 1.0
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-2-git-send-email-sumit.garg@linaro.org> <20190110140630.js7mrhu6nfnjsfhx@holly.lan>
In-Reply-To: <20190110140630.js7mrhu6nfnjsfhx@holly.lan>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 11 Jan 2019 12:11:22 +0530
Message-ID:
 <CAFA6WYNu-wm+V3qc85wodbMYoorMNMKMhG9dde7xqcPH5XVyUA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] tee: add bus driver framework for TEE based devices
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
Message-ID: <20190111064122.yy_yEMg2B2RRVr3cqcFraz4k5bSvQ58T8Ed3p7Jbu_I@z>

On Thu, 10 Jan 2019 at 19:36, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
>
> On Thu, Jan 10, 2019 at 05:54:54PM +0530, Sumit Garg wrote:
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
> >  drivers/tee/tee_core.c  | 41 ++++++++++++++++++++++++++++++++++++++---
> >  include/linux/tee_drv.h | 36 ++++++++++++++++++++++++++++++++++++
> >  2 files changed, 74 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/tee/tee_core.c b/drivers/tee/tee_core.c
> > index 7b2bb4c..9ddb89e 100644
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
> >  static int __init tee_init(void)
> >  {
> >       int rc;
> > @@ -1040,10 +1063,21 @@ static int __init tee_init(void)
> >       rc = alloc_chrdev_region(&tee_devt, 0, TEE_NUM_DEVICES, "tee");
> >       if (rc) {
> >               pr_err("failed to allocate char dev region\n");
> > -             class_destroy(tee_class);
> > -             tee_class = NULL;
> > +             goto class_err;
> >       }
> >
> > +     rc = bus_register(&tee_bus_type);
> > +     if (rc) {
> > +             pr_err("failed to register tee bus\n");
> > +             goto class_err;
>
> There is an unregister_chrdev_region() in tee_exit(). Why isn't it
> needed on this error path?
>

Will add "unregister_chrdev_region()" on this error path.

-Sumit

>
> > +     }
> > +
> > +     return 0;
> > +
> > +class_err:
> > +     class_destroy(tee_class);
> > +     tee_class = NULL;
> > +
> >       return rc;
> >  }
> >
> > @@ -1052,6 +1086,7 @@ static void __exit tee_exit(void)
> >       class_destroy(tee_class);
> >       tee_class = NULL;
> >       unregister_chrdev_region(tee_devt, TEE_NUM_DEVICES);
> > +     bus_unregister(&tee_bus_type);
> >  }
> >
> >  subsys_initcall(tee_init);
> > diff --git a/include/linux/tee_drv.h b/include/linux/tee_drv.h
> > index 6cfe058..ed16bf1 100644
> > --- a/include/linux/tee_drv.h
> > +++ b/include/linux/tee_drv.h
> > @@ -20,6 +20,8 @@
> >  #include <linux/kref.h>
> >  #include <linux/list.h>
> >  #include <linux/tee.h>
> > +#include <linux/device.h>
> > +#include <linux/uuid.h>
> >
> >  /*
> >   * The file describes the API provided by the generic TEE driver to the
> > @@ -538,4 +540,38 @@ static inline bool tee_param_is_memref(struct tee_param *param)
> >       }
> >  }
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
> > +#define to_tee_client_driver(d) \
> > +             container_of(d, struct tee_client_driver, driver)
> > +
> >  #endif /*__TEE_DRV_H*/
> > --
> > 2.7.4
> >
