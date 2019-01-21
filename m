Return-Path: <SRS0=ru6j=P5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F1DC2F3A6
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 13:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D5E92084C
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Jan 2019 13:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ru3C/8P3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728761AbfAUNNw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:13:52 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:46615 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbfAUNNw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Jan 2019 08:13:52 -0500
Received: by mail-vs1-f67.google.com with SMTP id n10so12544213vso.13
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jan 2019 05:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZBOKKZFD+nGvCwkJNtLaO3wMav7694SfHXPRlek558c=;
        b=Ru3C/8P3bo+6vPrVWg63nXoUaPGyos6wpCj9LNeP7+kVwy+YJ3gpYk5rnC3IpWGztY
         fH5XcJIuD524+DJ/fmo8q4iEUMNUdwxkefb9wXzKHNY7K3JLefzUrs6alW6pj0cmZnLR
         VnWoAnwT88GcVJ9DMn90ZiUlAuCFCB8nPH918=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBOKKZFD+nGvCwkJNtLaO3wMav7694SfHXPRlek558c=;
        b=pkSnRnUaG7LIh5Nq1cYMq/Zy/xgd1U+wNqXt62KrtExmdibya1a7yZn0DLs61YbMvo
         Qr17fopkb0mHlmLaA5P53Wf82W63geLlOF61DByyb47p2fNbL7fxPDlqAetCwDFD98Wd
         LDqhKfj56vwmWp53Zv4J9i9I4T44G5hom0pEJGfnvnf+tw6X8YqYLrr54RTiqhzlbR0k
         kamNq1i8DMQWf/2SwoT6KsJUS+1/XJNdVX9NHp0UyDy0WRc3t1h2RVSYV25cwySlENjP
         1sJWLl9Vt+HQoeWrATQNe0UVoQkxeeOtJFuiqPtGlfDrnXCAxgk8BUQ1RpeAy/bjEovD
         bVMQ==
X-Gm-Message-State: AJcUukdutHgORw/iXozzgDTTFi3JML7qJMCrSC7gtm+prweNgPW973m8
        AA73p7DiiKqQ3HesN4PXEpTkm6/qAkQzHlwJU8NXEg==
X-Google-Smtp-Source: ALg8bN49+2uPILt7oxeBXFI0N0U0UYFueVeJyD0pZxxG3TJY3ncJPnqlssCb3U5tZvlwVk0TEGjSMxboSzC6EoJ4zGg=
X-Received: by 2002:a67:1b04:: with SMTP id b4mr11997758vsb.141.1548076430563;
 Mon, 21 Jan 2019 05:13:50 -0800 (PST)
MIME-Version: 1.0
References: <1548062959-31860-1-git-send-email-sumit.garg@linaro.org>
 <1548062959-31860-5-git-send-email-sumit.garg@linaro.org> <CAKv+Gu8icUVE1kqyHkK72wiGpmj7Gzqj_z_z2ox686gY=dCOcQ@mail.gmail.com>
 <CAFA6WYO8HrTr0U+u-iwQ3g84E8H69rKqoBzLsP=5TTFamEv3jA@mail.gmail.com> <CAKv+Gu8bFRoY8ThuDzm8S8gBB3_6Jf9h3=S2ZvEWqy2Tcr7Vuw@mail.gmail.com>
In-Reply-To: <CAKv+Gu8bFRoY8ThuDzm8S8gBB3_6Jf9h3=S2ZvEWqy2Tcr7Vuw@mail.gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Mon, 21 Jan 2019 18:43:39 +0530
Message-ID: <CAFA6WYN+4EFsxnbhSsUb=TZMCeJF_5pxhOfXUBh9MTMsq8QMBQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] hwrng: add OP-TEE based rng driver
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
        Bhupesh Sharma <bhsharma@redhat.com>, tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 21 Jan 2019 at 18:32, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> On Mon, 21 Jan 2019 at 13:59, Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > On Mon, 21 Jan 2019 at 15:33, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > >
> > > On Mon, 21 Jan 2019 at 10:30, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > >
> > > > On ARM SoC's with TrustZone enabled, peripherals like entropy sources
> > > > might not be accessible to normal world (linux in this case) and rather
> > > > accessible to secure world (OP-TEE in this case) only. So this driver
> > > > aims to provides a generic interface to OP-TEE based random number
> > > > generator service.
> > > >
> > > > This driver registers on TEE bus to interact with OP-TEE based rng
> > > > device/service.
> > > >
> > > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > > ---
> > > >  MAINTAINERS                        |   5 +
> > > >  drivers/char/hw_random/Kconfig     |  15 ++
> > > >  drivers/char/hw_random/Makefile    |   1 +
> > > >  drivers/char/hw_random/optee-rng.c | 272 +++++++++++++++++++++++++++++++++++++
> > > >  4 files changed, 293 insertions(+)
> > > >  create mode 100644 drivers/char/hw_random/optee-rng.c
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 32d44447..502733c 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -11260,6 +11260,11 @@ M:     Jens Wiklander <jens.wiklander@linaro.org>
> > > >  S:     Maintained
> > > >  F:     drivers/tee/optee/
> > > >
> > > > +OP-TEE RANDOM NUMBER GENERATOR (RNG) DRIVER
> > > > +M:     Sumit Garg <sumit.garg@linaro.org>
> > > > +S:     Maintained
> > > > +F:     drivers/char/hw_random/optee-rng.c
> > > > +
> > > >  OPA-VNIC DRIVER
> > > >  M:     Dennis Dalessandro <dennis.dalessandro@intel.com>
> > > >  M:     Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
> > > > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > > > index dac895d..25a7d8f 100644
> > > > --- a/drivers/char/hw_random/Kconfig
> > > > +++ b/drivers/char/hw_random/Kconfig
> > > > @@ -424,6 +424,21 @@ config HW_RANDOM_EXYNOS
> > > >           will be called exynos-trng.
> > > >
> > > >           If unsure, say Y.
> > > > +
> > > > +config HW_RANDOM_OPTEE
> > > > +       tristate "OP-TEE based Random Number Generator support"
> > > > +       depends on OPTEE
> > > > +       default HW_RANDOM
> > > > +       help
> > > > +         This  driver provides support for OP-TEE based Random Number
> > > > +         Generator on ARM SoCs where hardware entropy sources are not
> > > > +         accessible to normal world (Linux).
> > > > +
> > > > +         To compile this driver as a module, choose M here: the module
> > > > +         will be called optee-rng.
> > > > +
> > > > +         If unsure, say Y.
> > > > +
> > > >  endif # HW_RANDOM
> > > >
> > > >  config UML_RANDOM
> > > > diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> > > > index e35ec3c..7c9ef4a 100644
> > > > --- a/drivers/char/hw_random/Makefile
> > > > +++ b/drivers/char/hw_random/Makefile
> > > > @@ -38,3 +38,4 @@ obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
> > > >  obj-$(CONFIG_HW_RANDOM_MTK)    += mtk-rng.o
> > > >  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
> > > >  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
> > > > +obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> > > > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > > > new file mode 100644
> > > > index 0000000..6ac862a
> > > > --- /dev/null
> > > > +++ b/drivers/char/hw_random/optee-rng.c
> > > > @@ -0,0 +1,272 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +/*
> > > > + * Copyright (C) 2018-2019 Linaro Ltd.
> > > > + */
> > > > +
> > > > +#include <linux/delay.h>
> > > > +#include <linux/of.h>
> > > > +#include <linux/hw_random.h>
> > > > +#include <linux/kernel.h>
> > > > +#include <linux/module.h>
> > > > +#include <linux/slab.h>
> > > > +#include <linux/tee_drv.h>
> > > > +#include <linux/uuid.h>
> > > > +
> > > > +#define DRIVER_NAME "optee-rng"
> > > > +
> > > > +#define TEE_ERROR_HEALTH_TEST_FAIL     0x00000001
> > > > +
> > > > +/*
> > > > + * TA_CMD_GET_ENTROPY - Get Entropy from RNG
> > > > + *
> > > > + * param[0] (inout memref) - Entropy buffer memory reference
> > > > + * param[1] unused
> > > > + * param[2] unused
> > > > + * param[3] unused
> > > > + *
> > > > + * Result:
> > > > + * TEE_SUCCESS - Invoke command success
> > > > + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > > > + * TEE_ERROR_NOT_SUPPORTED - Requested entropy size greater than size of pool
> > > > + * TEE_ERROR_HEALTH_TEST_FAIL - Continuous health testing failed
> > > > + */
> > > > +#define TA_CMD_GET_ENTROPY             0x0
> > > > +
> > > > +/*
> > > > + * TA_CMD_GET_RNG_INFO - Get RNG information
> > > > + *
> > > > + * param[0] (out value) - value.a: RNG data-rate in bytes per second
> > > > + *                        value.b: Quality/Entropy per 1024 bit of data
> > > > + * param[1] unused
> > > > + * param[2] unused
> > > > + * param[3] unused
> > > > + *
> > > > + * Result:
> > > > + * TEE_SUCCESS - Invoke command success
> > > > + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > > > + */
> > > > +#define TA_CMD_GET_RNG_INFO            0x1
> > > > +
> > > > +#define MAX_ENTROPY_REQ_SZ             (4 * 1024)
> > > > +
> > > > +static struct tee_context *ctx;
> > > > +static struct tee_shm *entropy_shm_pool;
> > > > +static u32 ta_rng_data_rate;
> > > > +static u32 ta_rng_session_id;
> > > > +
> > > > +static size_t get_optee_rng_data(void *buf, size_t req_size)
> > > > +{
> > > > +       u32 ret = 0;
> > > > +       u8 *rng_data = NULL;
> > > > +       size_t rng_size = 0;
> > > > +       struct tee_ioctl_invoke_arg inv_arg = {0};
> > > > +       struct tee_param param[4] = {0};
> > > > +
> > > > +       /* Invoke TA_CMD_GET_ENTROPY function of Trusted App */
> > > > +       inv_arg.func = TA_CMD_GET_ENTROPY;
> > > > +       inv_arg.session = ta_rng_session_id;
> > > > +       inv_arg.num_params = 4;
> > > > +
> > > > +       /* Fill invoke cmd params */
> > > > +       param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
> > > > +       param[0].u.memref.shm = entropy_shm_pool;
> > > > +       param[0].u.memref.size = req_size;
> > > > +       param[0].u.memref.shm_offs = 0;
> > > > +
> > > > +       ret = tee_client_invoke_func(ctx, &inv_arg, param);
> > > > +       if ((ret < 0) || (inv_arg.ret != 0)) {
> > > > +               pr_err("TA_CMD_GET_ENTROPY invoke function error: %x\n",
> > > > +                      inv_arg.ret);
> > > > +               return 0;
> > > > +       }
> > > > +
> > > > +       rng_data = tee_shm_get_va(entropy_shm_pool, 0);
> > > > +       if (IS_ERR(rng_data)) {
> > > > +               pr_err("tee_shm_get_va failed\n");
> > > > +               return 0;
> > > > +       }
> > > > +
> > > > +       rng_size = param[0].u.memref.size;
> > > > +       memcpy(buf, rng_data, rng_size);
> > > > +
> > > > +       return rng_size;
> > > > +}
> > > > +
> > > > +static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > > > +{
> > > > +       u8 *data = buf;
> > > > +       size_t read = 0, rng_size = 0;
> > > > +       int timeout = 1;
> > > > +
> > > > +       if (max > MAX_ENTROPY_REQ_SZ)
> > > > +               max = MAX_ENTROPY_REQ_SZ;
> > > > +
> > > > +       while (read == 0) {
> > > > +               rng_size = get_optee_rng_data(data, (max - read));
> > > > +
> > > > +               data += rng_size;
> > > > +               read += rng_size;
> > > > +
> > > > +               if (wait) {
> > > > +                       if (timeout-- == 0)
> > > > +                               return read;
> > > > +                       msleep((1000 * (max - read)) / ta_rng_data_rate);
> > > > +               } else {
> > > > +                       return read;
> > > > +               }
> > > > +       }
> > > > +
> > > > +       return read;
> > > > +}
> > > > +
> > > > +static int optee_rng_init(struct hwrng *rng)
> > > > +{
> > > > +       entropy_shm_pool = tee_shm_alloc(ctx, MAX_ENTROPY_REQ_SZ,
> > > > +                                        TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> > > > +       if (IS_ERR(entropy_shm_pool)) {
> > > > +               pr_err("tee_shm_alloc failed\n");
> > > > +               return PTR_ERR(entropy_shm_pool);
> > > > +       }
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +static void optee_rng_cleanup(struct hwrng *rng)
> > > > +{
> > > > +       tee_shm_free(entropy_shm_pool);
> > > > +}
> > > > +
> > > > +static struct hwrng optee_rng = {
> > > > +       .name           = DRIVER_NAME,
> > > > +       .init           = optee_rng_init,
> > > > +       .cleanup        = optee_rng_cleanup,
> > > > +       .read           = optee_rng_read,
> > > > +};
> > > > +
> > > > +static int get_optee_rng_info(struct device *dev)
> > > > +{
> > > > +       u32 ret = 0;
> > > > +       struct tee_ioctl_invoke_arg inv_arg = {0};
> > > > +       struct tee_param param[4] = {0};
> > > > +
> > > > +       /* Invoke TA_CMD_GET_RNG_INFO function of Trusted App */
> > > > +       inv_arg.func = TA_CMD_GET_RNG_INFO;
> > > > +       inv_arg.session = ta_rng_session_id;
> > > > +       inv_arg.num_params = 4;
> > > > +
> > > > +       /* Fill invoke cmd params */
> > > > +       param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_OUTPUT;
> > > > +
> > > > +       ret = tee_client_invoke_func(ctx, &inv_arg, param);
> > > > +       if ((ret < 0) || (inv_arg.ret != 0)) {
> > > > +               dev_err(dev, "TA_CMD_GET_RNG_INFO invoke func error: %x\n",
> > > > +                       inv_arg.ret);
> > > > +               return -EINVAL;
> > > > +       }
> > > > +
> > > > +       ta_rng_data_rate = param[0].u.value.a;
> > > > +       optee_rng.quality = param[0].u.value.b;
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> > > > +{
> > > > +       if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> > > > +               return 1;
> > > > +       else
> > > > +               return 0;
> > > > +}
> > > > +
> > > > +static int optee_rng_probe(struct device *dev)
> > > > +{
> > > > +       struct tee_client_device *rng_device = to_tee_client_device(dev);
> > > > +       int ret = 0, err = -ENODEV;
> > > > +       struct tee_ioctl_open_session_arg sess_arg = {0};
> > > > +
> > > > +       /* Open context with TEE driver */
> > > > +       ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
> > > > +       if (IS_ERR(ctx))
> > > > +               return -ENODEV;
> > > > +
> > > > +       /* Open session with hwrng Trusted App */
> > > > +       memcpy(sess_arg.uuid, rng_device->id.b, TEE_IOCTL_UUID_LEN);
> > > > +       sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> > > > +       sess_arg.num_params = 0;
> > > > +
> > > > +       ret = tee_client_open_session(ctx, &sess_arg, NULL);
> > > > +       if ((ret < 0) || (sess_arg.ret != 0)) {
> > > > +               dev_err(dev, "tee_client_open_session failed, error: %x\n",
> > > > +                       sess_arg.ret);
> > > > +               err = -EINVAL;
> > > > +               goto out_ctx;
> > > > +       }
> > > > +       ta_rng_session_id = sess_arg.session;
> > > > +
> > > > +       err = get_optee_rng_info(dev);
> > > > +       if (err)
> > > > +               goto out_sess;
> > > > +
> > > > +       err = hwrng_register(&optee_rng);
> > > > +       if (err) {
> > > > +               dev_err(dev, "hwrng registration failed (%d)\n", err);
> > > > +               goto out_sess;
> > > > +       }
> > > > +
> > > > +       return 0;
> > > > +
> > > > +out_sess:
> > > > +       tee_client_close_session(ctx, ta_rng_session_id);
> > > > +out_ctx:
> > > > +       tee_client_close_context(ctx);
> > > > +
> > > > +       return err;
> > > > +}
> > > > +
> > > > +static int optee_rng_remove(struct device *dev)
> > > > +{
> > > > +       hwrng_unregister(&optee_rng);
> > > > +       tee_client_close_session(ctx, ta_rng_session_id);
> > > > +       tee_client_close_context(ctx);
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +const tee_client_device_id optee_rng_id_table[] = {
> > > > +       UUID_INIT(0xab7a617c, 0xb8e7, 0x4d8f,
> > > > +                  0x83, 0x01, 0xd0, 0x9b, 0x61, 0x03, 0x6b, 0x64),
> > > > +       {}
> > > > +};
> > > > +
> > >
> > > Could we expose this via MODULE_DEVICE_TABLE() as well? That should
> > > allow udev to load the module on demand.
> > >
> >
> > IIUC, here you are referring to addition of "modalias" infrastructure
> > for TEE bus. I think this is good feature to have for automatic
> > out-of-tree module loading via udev. Shall I create a separate patch
> > for this feature addition rather than including it in this patch-set?
> >
> > Currently I use to put this module entry in /etc/modules for auto-loading.
> >
>
> I wouldn't call that auto-loading :-)
>

Haha.

> But seriously, I think it provides an important rationale for the
> patch set as a whole, so I would prefer it if it were included.

Okay then I will include this feature in next version.

-Sumit
