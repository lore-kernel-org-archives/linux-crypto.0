Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECDDC282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 08:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A03621726
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 08:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ASQkEC1X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfBAIml (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 03:42:41 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:45740 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfBAIml (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 03:42:41 -0500
Received: by mail-ua1-f66.google.com with SMTP id e16so1943077uam.12
        for <linux-crypto@vger.kernel.org>; Fri, 01 Feb 2019 00:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i+Gp5jaVCOt92KDq1sA7Q9owziG7gAjhSETFMgPAZgo=;
        b=ASQkEC1Xyt1LCtglVGnNcAJ0eIj6N5ZlCGNnQybr3mTNuihNJhdlu/UUSwJZY7RzKm
         7j/Xguyzs4TY7zi03S546bNUn1QE2xYBA3c9U/iXb23QdEl2uteYxEC7wj95mQyriGwN
         hw24qaAvBY0sq6xyT/ONhEbQZaR2aY4zxAGKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i+Gp5jaVCOt92KDq1sA7Q9owziG7gAjhSETFMgPAZgo=;
        b=oK6Wigm9fAs/U7hJJ49x3rSm80ygzwGkjzIvudam/JPH1VNwh6qmdjDZgD6bztI9z2
         pCKy70ZyNQRk/5W0sVNIiUNlltj5ZtWnZUfzRzipnQvMTrfhXrJrErxSytN2fzdXWHC0
         wBHUR6DUmUZAx5TKfvdmc7o8meTUKBDQuN6TBu1Qj/PXgtfxs//gTGMsGsYNHN3Xpv86
         64Ar5HEPj/iJbkXlx0FE2LDNsaBKfMBGgAW1HJ6fugW5cIlgtmJOsJEqYJxLSUs1TYfJ
         S45zAfl4x57utmC08z8h6C+0SbCOJH1BUliL8cQT3Iu3iRkhtvjbPvYr+stkxgmPzab8
         rQXA==
X-Gm-Message-State: AHQUAuYTWo3AiOyDpLemMwHRpLMHsLmBYz/BwcgtSle8hxl9L6qzK2ms
        RHWTkRorvUogQ337U4xrKEeyIrW3FPaTQiNiVGw97w==
X-Google-Smtp-Source: AHgI3IY6F/TPkBJC9rmAR9aeUJRwtvy9CwMBrwq4v0Q00d9Cew5vq+6PL10WOcWSIcSJVD5rmTZ6D/WC4ovYlO+quxw=
X-Received: by 2002:ab0:148e:: with SMTP id d14mr582565uae.23.1549010559929;
 Fri, 01 Feb 2019 00:42:39 -0800 (PST)
MIME-Version: 1.0
References: <1548740978-28495-1-git-send-email-sumit.garg@linaro.org>
 <1548740978-28495-4-git-send-email-sumit.garg@linaro.org> <20190201082809.GA5329@jax.urgonet>
In-Reply-To: <20190201082809.GA5329@jax.urgonet>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 1 Feb 2019 14:12:28 +0530
Message-ID: <CAFA6WYN_xMambVCUdKxUg3AcS_pteDyitXgw4+9ZDA=tabQf5g@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] tee: optee: add TEE bus device enumeration support
To:     Jens Wiklander <jens.wiklander@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        yamada.masahiro@socionext.com, michal.lkml@markovi.net,
        Matt Mackall <mpm@selenic.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 1 Feb 2019 at 13:58, Jens Wiklander <jens.wiklander@linaro.org> wrote:
>
> On Tue, Jan 29, 2019 at 11:19:37AM +0530, Sumit Garg wrote:
> > OP-TEE provides a pseudo TA to enumerate TAs which can act as devices/
> > services for TEE bus. So implement device enumeration using invoke
> > function: PTA_CMD_GET_DEVICES provided by pseudo TA to fetch array of
> > device UUIDs. Also register these enumerated devices with TEE bus as
> > "optee-clntX" device.
> >
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > Reviewed-by: Daniel Thompson <daniel.thompson@linaro.org>
> > ---
> >  drivers/tee/optee/Makefile        |   1 +
> >  drivers/tee/optee/core.c          |   4 +
> >  drivers/tee/optee/device.c        | 155 ++++++++++++++++++++++++++++++++++++++
> >  drivers/tee/optee/optee_private.h |   3 +
> >  4 files changed, 163 insertions(+)
> >  create mode 100644 drivers/tee/optee/device.c
> >
> > diff --git a/drivers/tee/optee/Makefile b/drivers/tee/optee/Makefile
> > index 48d262a..56263ae 100644
> > --- a/drivers/tee/optee/Makefile
> > +++ b/drivers/tee/optee/Makefile
> > @@ -5,3 +5,4 @@ optee-objs += call.o
> >  optee-objs += rpc.o
> >  optee-objs += supp.o
> >  optee-objs += shm_pool.o
> > +optee-objs += device.o
> > diff --git a/drivers/tee/optee/core.c b/drivers/tee/optee/core.c
> > index e5efce3..ac59c77 100644
> > --- a/drivers/tee/optee/core.c
> > +++ b/drivers/tee/optee/core.c
> > @@ -634,6 +634,10 @@ static struct optee *optee_probe(struct device_node *np)
> >       if (optee->sec_caps & OPTEE_SMC_SEC_CAP_DYNAMIC_SHM)
> >               pr_info("dynamic shared memory is enabled\n");
> >
> > +     rc = optee_enumerate_devices();
> > +     if (rc)
> > +             goto err;
> > +
> >       pr_info("initialized driver\n");
> >       return optee;
> >  err:
> > diff --git a/drivers/tee/optee/device.c b/drivers/tee/optee/device.c
> > new file mode 100644
> > index 0000000..c24c37f
> > --- /dev/null
> > +++ b/drivers/tee/optee/device.c
> > @@ -0,0 +1,155 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2019 Linaro Ltd.
> > + */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/slab.h>
> > +#include <linux/tee_drv.h>
> > +#include <linux/uuid.h>
> > +#include "optee_private.h"
> > +
> > +/*
> > + * Get device UUIDs
> > + *
> > + * [out]     memref[0]        Array of device UUIDs
> > + *
> > + * Return codes:
> > + * TEE_SUCCESS - Invoke command success
> > + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > + * TEE_ERROR_SHORT_BUFFER - Output buffer size less than required
> > + */
> > +#define PTA_CMD_GET_DEVICES          0x0
> > +
> > +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> > +{
> > +     if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> > +             return 1;
> > +     else
> > +             return 0;
> > +}
> > +
> > +static int get_devices(struct tee_context *ctx, u32 session,
> > +                    struct tee_shm *device_shm, u32 *shm_size)
> > +{
> > +     u32 ret = 0;
> > +     struct tee_ioctl_invoke_arg inv_arg = {0};
> > +     struct tee_param param[4] = {0};
> > +
> > +     /* Invoke PTA_CMD_GET_DEVICES function */
> > +     inv_arg.func = PTA_CMD_GET_DEVICES;
> > +     inv_arg.session = session;
> > +     inv_arg.num_params = 4;
> > +
> > +     /* Fill invoke cmd params */
> > +     param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_OUTPUT;
> > +     param[0].u.memref.shm = device_shm;
> > +     param[0].u.memref.size = *shm_size;
> > +     param[0].u.memref.shm_offs = 0;
> > +
> > +     ret = tee_client_invoke_func(ctx, &inv_arg, param);
> > +     if ((ret < 0) || ((inv_arg.ret != TEEC_SUCCESS) &&
> > +                       (inv_arg.ret != TEEC_ERROR_SHORT_BUFFER))) {
> > +             pr_err("PTA_CMD_GET_DEVICES invoke function err: %x\n",
> > +                    inv_arg.ret);
> > +             return -EINVAL;
> > +     }
> > +
> > +     *shm_size = param[0].u.memref.size;
> > +
> > +     return 0;
> > +}
> > +
> > +static int optee_register_device(const uuid_t *device_uuid, u32 device_id)
> > +{
> > +     struct tee_client_device *optee_device = NULL;
> > +     int rc;
> > +
> > +     optee_device = kzalloc(sizeof(*optee_device), GFP_KERNEL);
> > +     if (!optee_device)
> > +             return -ENOMEM;
> > +
> > +     optee_device->dev.bus = &tee_bus_type;
> > +     dev_set_name(&optee_device->dev, "optee-clnt%u", device_id);
> > +     uuid_copy(&optee_device->id.uuid, device_uuid);
> > +
> > +     rc = device_register(&optee_device->dev);
> > +     if (rc) {
> > +             pr_err("device registration failed, err: %d\n", rc);
> > +             kfree(optee_device);
> > +     }
> > +
> > +     return rc;
> > +}
> > +
> > +int optee_enumerate_devices(void)
> > +{
> > +     const uuid_t pta_uuid =
> > +             UUID_INIT(0x7011a688, 0xddde, 0x4053,
> > +                       0xa5, 0xa9, 0x7b, 0x3c, 0x4d, 0xdf, 0x13, 0xb8);
> > +     struct tee_ioctl_open_session_arg sess_arg = {0};
> > +     struct tee_shm *device_shm = NULL;
> > +     const uuid_t *device_uuid = NULL;
> > +     struct tee_context *ctx = NULL;
> > +     u32 shm_size = 0, idx, num_devices = 0;
> > +     int rc;
> > +
> > +     /* Open context with OP-TEE driver */
> > +     ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
> > +     if (IS_ERR(ctx))
> > +             return -ENODEV;
> > +
> > +     /* Open session with device enumeration pseudo TA */
> > +     memcpy(sess_arg.uuid, pta_uuid.b, TEE_IOCTL_UUID_LEN);
> > +     sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> > +     sess_arg.num_params = 0;
> > +
> > +     rc = tee_client_open_session(ctx, &sess_arg, NULL);
> > +     if ((rc < 0) || (sess_arg.ret != TEEC_SUCCESS)) {
> > +             /* Device enumeration pseudo TA not found */
> > +             rc = 0;
> > +             goto out_ctx;
> > +     }
> > +
> > +     rc = get_devices(ctx, sess_arg.session, NULL, &shm_size);
> > +     if (rc < 0)
>
> While testing I discovered that this line should be:
>         if (rc < 0 || !shm_size)
>

Ah, yes you are correct. BTW, thanks for testing.

> to cover the common case where there's no devices. I'll fixup the commit
> with this trivial change.
>

Thanks,
-Sumit

> Cheers,
> Jens
>
> > +             goto out_sess;
> > +
> > +     device_shm = tee_shm_alloc(ctx, shm_size,
> > +                                TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> > +     if (IS_ERR(device_shm)) {
> > +             pr_err("tee_shm_alloc failed\n");
> > +             rc = PTR_ERR(device_shm);
> > +             goto out_sess;
> > +     }
> > +
> > +     rc = get_devices(ctx, sess_arg.session, device_shm, &shm_size);
> > +     if (rc < 0)
> > +             goto out_shm;
> > +
> > +     device_uuid = tee_shm_get_va(device_shm, 0);
> > +     if (IS_ERR(device_uuid)) {
> > +             pr_err("tee_shm_get_va failed\n");
> > +             rc = PTR_ERR(device_uuid);
> > +             goto out_shm;
> > +     }
> > +
> > +     num_devices = shm_size / sizeof(uuid_t);
> > +
> > +     for (idx = 0; idx < num_devices; idx++) {
> > +             rc = optee_register_device(&device_uuid[idx], idx);
> > +             if (rc)
> > +                     goto out_shm;
> > +     }
> > +
> > +out_shm:
> > +     tee_shm_free(device_shm);
> > +out_sess:
> > +     tee_client_close_session(ctx, sess_arg.session);
> > +out_ctx:
> > +     tee_client_close_context(ctx);
> > +
> > +     return rc;
> > +}
> > diff --git a/drivers/tee/optee/optee_private.h b/drivers/tee/optee/optee_private.h
> > index 35e7938..a5e84af 100644
> > --- a/drivers/tee/optee/optee_private.h
> > +++ b/drivers/tee/optee/optee_private.h
> > @@ -28,6 +28,7 @@
> >  #define TEEC_ERROR_BAD_PARAMETERS    0xFFFF0006
> >  #define TEEC_ERROR_COMMUNICATION     0xFFFF000E
> >  #define TEEC_ERROR_OUT_OF_MEMORY     0xFFFF000C
> > +#define TEEC_ERROR_SHORT_BUFFER              0xFFFF0010
> >
> >  #define TEEC_ORIGIN_COMMS            0x00000002
> >
> > @@ -181,6 +182,8 @@ void optee_free_pages_list(void *array, size_t num_entries);
> >  void optee_fill_pages_list(u64 *dst, struct page **pages, int num_pages,
> >                          size_t page_offset);
> >
> > +int optee_enumerate_devices(void);
> > +
> >  /*
> >   * Small helpers
> >   */
> > --
> > 2.7.4
> >
