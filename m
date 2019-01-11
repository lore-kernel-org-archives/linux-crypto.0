Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7055C43387
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 06:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 905D820872
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jan 2019 06:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="WeE5/3oD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfAKGfG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jan 2019 01:35:06 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:44186 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728462AbfAKGfF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:35:05 -0500
Received: by mail-vk1-f194.google.com with SMTP id h128so3043064vkg.11
        for <linux-crypto@vger.kernel.org>; Thu, 10 Jan 2019 22:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uf5RlXm9R4Tp6j/EM7HwfH2Fw0OWn67h4QYTzr31mZI=;
        b=WeE5/3oDiIyYSLcpcNtPA/IhfXo3ucNL2mEyUrEfpVzQPAy1db0Bsjd4C/WDV8RAFp
         CQ+Pd8+CuVkX00GE7G7BmewFOczyymLc+bWZSvmCU4uqKhnedwezuDu1NTchVCDzXNYU
         eqsUW5IB5vTS28ho/VmvSFDmYCFT0JujmiU7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uf5RlXm9R4Tp6j/EM7HwfH2Fw0OWn67h4QYTzr31mZI=;
        b=mnNc/dDRNBRpkv8IiFPMBa1chNtu0B2vpVd/RHsNXJbZttxcMFbeMouWNOF3cJYAzK
         d1sn07ykMbLdrVLCY+/pXI/h9uz5akgDKxHYJunosLIZHHLN048U2Z5DtWXMgHazDhlo
         Zm3HfXakcL4wXx1KMceDYb81aeJaHho4Na9BPMb4tpfawVW4IFU7/WK7jVc46ru+LC1B
         l6Z7h99Dfv0YP+lHcC13UhgUo7Umxn8bgXlpEq/f1Il9cEmehukUHEHj0m9DsZ7OZ5Uy
         ATAvA7fbfGSoPm0l8Ex63RI1nSYE3MsmORbi6G9LtuOEaSyxeGIIlAzT3NMRPGjz4Ecq
         IG0w==
X-Gm-Message-State: AJcUukdQijTGJEIiy/04fXWMeZtRY0gN6McJceHMTulyHG8wS1Bbzw2i
        c0dg3QC72rUbzyWaMZuUZj5gepIgJiAVLvAFT6jNIQ==
X-Google-Smtp-Source: ALg8bN7OYFHCYmSr1im68IQmOv/WNjjd8raJuLHEAe3kyzraMM0xNsWIAWSRyoVsKUb2fUL8tzacpQbaIGojeYS7SBw=
X-Received: by 2002:a1f:aa44:: with SMTP id t65mr5053502vke.66.1547188503857;
 Thu, 10 Jan 2019 22:35:03 -0800 (PST)
MIME-Version: 1.0
References: <1547123097-16431-1-git-send-email-sumit.garg@linaro.org>
 <1547123097-16431-5-git-send-email-sumit.garg@linaro.org> <20190110135557.wjnusuwe5vpkho4t@debby>
In-Reply-To: <20190110135557.wjnusuwe5vpkho4t@debby>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Fri, 11 Jan 2019 12:04:52 +0530
Message-ID:
 <CAFA6WYO61DdOMxErP4PUBcmgTq3x9AKzeZGR9L+t4B+FvUfrnw@mail.gmail.com>
Subject: Re: [Tee-dev] [PATCH v2 4/4] hwrng: add OP-TEE based rng driver
To:     Joakim Bech <joakim.bech@linaro.org>
Cc:     linux-arm-kernel@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhsharma@redhat.com>,
        linux-kernel@vger.kernel.org, tee-dev@lists.linaro.org,
        Rob Herring <robh+dt@kernel.org>, mpm@selenic.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190111063452.spjMzbNMLG2CWy4wPdtv-w_bKZYsFydPbK_sFnpbmZM@z>

On Thu, 10 Jan 2019 at 19:26, Joakim Bech <joakim.bech@linaro.org> wrote:
>
> On Thu, Jan 10, 2019 at 05:54:57PM +0530, Sumit Garg wrote:
> > On ARM SoC's with TrustZone enabled, peripherals like entropy sources
> > might not be accessible to normal world (linux in this case) and rather
> > accessible to secure world (OP-TEE in this case) only. So this driver
> > aims to provides a generic interface to OP-TEE based random number
> > generator service.
> >
> > This driver registers on TEE bus to interact with OP-TEE based rng
> >
> > device/service.
> >
> > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > ---
> >  MAINTAINERS                        |   5 +
> >  drivers/char/hw_random/Kconfig     |  15 ++
> >  drivers/char/hw_random/Makefile    |   1 +
> >  drivers/char/hw_random/optee-rng.c | 272 +++++++++++++++++++++++++++++++++++++
> >  4 files changed, 293 insertions(+)
> >  create mode 100644 drivers/char/hw_random/optee-rng.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 32d44447..502733c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -11260,6 +11260,11 @@ M:   Jens Wiklander <jens.wiklander@linaro.org>
> >  S:   Maintained
> >  F:   drivers/tee/optee/
> >
> > +OP-TEE RANDOM NUMBER GENERATOR (RNG) DRIVER
> > +M:   Sumit Garg <sumit.garg@linaro.org>
> > +S:   Maintained
> > +F:   drivers/char/hw_random/optee-rng.c
> > +
> >  OPA-VNIC DRIVER
> >  M:   Dennis Dalessandro <dennis.dalessandro@intel.com>
> >  M:   Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
> > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > index dac895d..25a7d8f 100644
> > --- a/drivers/char/hw_random/Kconfig
> > +++ b/drivers/char/hw_random/Kconfig
> > @@ -424,6 +424,21 @@ config HW_RANDOM_EXYNOS
> >         will be called exynos-trng.
> >
> >         If unsure, say Y.
> > +
> > +config HW_RANDOM_OPTEE
> > +     tristate "OP-TEE based Random Number Generator support"
> > +     depends on OPTEE
> > +     default HW_RANDOM
> > +     help
> > +       This  driver provides support for OP-TEE based Random Number
> > +       Generator on ARM SoCs where hardware entropy sources are not
> > +       accessible to normal world (Linux).
> > +
> > +       To compile this driver as a module, choose M here: the module
> > +       will be called optee-rng.
> > +
> > +       If unsure, say Y.
> > +
> >  endif # HW_RANDOM
> >
> >  config UML_RANDOM
> > diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> > index e35ec3c..7c9ef4a 100644
> > --- a/drivers/char/hw_random/Makefile
> > +++ b/drivers/char/hw_random/Makefile
> > @@ -38,3 +38,4 @@ obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
> >  obj-$(CONFIG_HW_RANDOM_MTK)  += mtk-rng.o
> >  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
> >  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
> > +obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > new file mode 100644
> > index 0000000..ebfe1f2c
> > --- /dev/null
> > +++ b/drivers/char/hw_random/optee-rng.c
> > @@ -0,0 +1,272 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) 2018-2019 Linaro Ltd.
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/of.h>
> > +#include <linux/hw_random.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/tee_drv.h>
> > +#include <linux/uuid.h>
> > +
> > +#define DRIVER_NAME "optee-rng"
> > +
> > +#define TEE_ERROR_HEALTH_TEST_FAIL   0x00000001
> > +
> > +/*
> > + * TA_CMD_GET_ENTROPY - Get Entropy from RNG
> > + *
> > + * param[0] (inout memref) - Entropy buffer memory reference
> > + * param[1] unused
> > + * param[2] unused
> > + * param[3] unused
> > + *
> > + * Result:
> > + * TEE_SUCCESS - Invoke command success
> > + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > + * TEE_ERROR_NOT_SUPPORTED - Requested entropy size greater than size of pool
> > + * TEE_ERROR_HEALTH_TEST_FAIL - Continuous health testing failed
> > + */
> > +#define TA_CMD_GET_ENTROPY           0x0
> > +
> > +/*
> > + * TA_CMD_GET_RNG_INFO - Get RNG information
> > + *
> > + * param[0] (out value) - value.a: RNG data-rate in bytes per second
> > + *                        value.b: Quality/Entropy per 1024 bit of data
> > + * param[1] unused
> > + * param[2] unused
> > + * param[3] unused
> > + *
> > + * Result:
> > + * TEE_SUCCESS - Invoke command success
> > + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > + */
> > +#define TA_CMD_GET_RNG_INFO          0x1
> > +
> > +#define MAX_ENTROPY_REQ_SZ           (4 * 1024)
> > +
> > +static struct tee_context *ctx;
> > +static struct tee_shm *entropy_shm_pool;
> > +static u32 ta_rng_data_rate;
> > +static u32 ta_rng_session_id;
> > +
> > +static size_t get_optee_rng_data(void *buf, size_t req_size)
> > +{
> > +     u32 ret = 0;
> > +     u8 *rng_data = NULL;
> > +     size_t rng_size = 0;
> > +     struct tee_ioctl_invoke_arg inv_arg = {0};
> > +     struct tee_param param[4] = {0};
> > +
> > +     /* Invoke TA_CMD_GET_RNG function of Trusted App */
> >
> TA_CMD_GET_ENTROPY?
>

Will correct.

> > +     inv_arg.func = TA_CMD_GET_ENTROPY;
> > +     inv_arg.session = ta_rng_session_id;
> > +     inv_arg.num_params = 4;
> > +
> > +     /* Fill invoke cmd params */
> > +     param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
> >
> > +     param[0].u.memref.shm = entropy_shm_pool;
> > +     param[0].u.memref.size = req_size;
> > +     param[0].u.memref.shm_offs = 0;
> > +
> > +     ret = tee_client_invoke_func(ctx, &inv_arg, param);
> > +     if ((ret < 0) || (inv_arg.ret != 0)) {
> > +             pr_err("TA_CMD_GET_ENTROPY invoke function error: %x\n",
> > +                    inv_arg.ret);
> > +             return 0;
> > +     }
> > +
> > +     rng_data = tee_shm_get_va(entropy_shm_pool, 0);
> > +     if (IS_ERR(rng_data)) {
> > +             pr_err("tee_shm_get_va failed\n");
> > +             return 0;
> > +     }
> > +
> > +     rng_size = param[0].u.memref.size;
> > +     memcpy(buf, rng_data, rng_size);
> > +
> > +     return rng_size;
> > +}
> > +
> > +static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > +{
> > +     u8 *data = buf;
> > +     size_t read = 0, rng_size = 0;
> > +     int timeout = 1;
> > +
> > +     if (max > MAX_ENTROPY_REQ_SZ)
> > +             max = MAX_ENTROPY_REQ_SZ;
> > +
> > +     while (read == 0) {
> > +             rng_size = get_optee_rng_data(data, (max - read));
> > +
> > +             data += rng_size;
> > +             read += rng_size;
> > +
> > +             if (wait) {
> > +                     if (timeout-- == 0)
> > +                             return read;
> > +                     msleep((1000 * (max - read)) / ta_rng_data_rate);
> > +             } else {
> > +                     return read;
> > +             }
> > +     }
> > +
> > +     return read;
> > +}
> > +
> > +static int optee_rng_init(struct hwrng *rng)
> > +{
> > +     entropy_shm_pool = tee_shm_alloc(ctx, MAX_ENTROPY_REQ_SZ,
> > +                                      TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> > +     if (IS_ERR(entropy_shm_pool)) {
> > +             pr_err("tee_shm_alloc failed\n");
> > +             return PTR_ERR(entropy_shm_pool);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static void optee_rng_cleanup(struct hwrng *rng)
> > +{
> > +     tee_shm_free(entropy_shm_pool);
> > +}
> > +
> > +static struct hwrng optee_rng = {
> > +     .name           = DRIVER_NAME,
> > +     .init           = optee_rng_init,
> > +     .cleanup        = optee_rng_cleanup,
> > +     .read           = optee_rng_read,
> > +};
> > +
> > +static int get_optee_rng_info(void)
> > +{
> > +     u32 ret = 0;
> > +     struct tee_ioctl_invoke_arg inv_arg = {0};
> > +     struct tee_param param[4] = {0};
> > +
> > +     /* Invoke TA_CMD_GET_RNG function of Trusted App */
> >
> TA_CMD_GET_RNG_INFO?
>

Will correct.

> > +     inv_arg.func = TA_CMD_GET_RNG_INFO;
> > +     inv_arg.session = ta_rng_session_id;
> > +     inv_arg.num_params = 4;
> > +
> > +     /* Fill invoke cmd params */
> > +     param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_OUTPUT;
> > +
> > +     ret = tee_client_invoke_func(ctx, &inv_arg, param);
> > +     if ((ret < 0) || (inv_arg.ret != 0)) {
> > +             pr_err("TA_CMD_GET_RNG_INFO invoke function error: %x\n",
> > +                    inv_arg.ret);
> > +             return -EINVAL;
> > +     }
> > +
> > +     ta_rng_data_rate = param[0].u.value.a;
> > +     optee_rng.quality = param[0].u.value.b;
> > +
> > +     return 0;
> > +}
> > +
> > +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> > +{
> > +     if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> > +             return 1;
> > +     else
> > +             return 0;
> > +}
> > +
> > +static int optee_rng_probe(struct device *dev)
> > +{
> > +     struct tee_client_device *rng_device = to_tee_client_device(dev);
> > +     int ret = 0, err = -ENODEV;
> > +     struct tee_ioctl_open_session_arg sess_arg = {0};
> > +
> > +     /* Open context with TEE driver */
> > +     ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
> > +     if (IS_ERR(ctx))
> > +             return -ENODEV;
> > +
> > +     /* Open session with hwrng Trusted App */
> > +     memcpy(sess_arg.uuid, rng_device->id.uuid.b, TEE_IOCTL_UUID_LEN);
> > +     sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> > +     sess_arg.num_params = 0;
> > +
> > +     ret = tee_client_open_session(ctx, &sess_arg, NULL);
> > +     if ((ret < 0) || (sess_arg.ret != 0)) {
> > +             pr_err("tee_client_open_session failed, error: %x\n",
> > +                    sess_arg.ret);
> > +             err = -EINVAL;
> > +             goto out_ctx;
> > +     }
> > +     ta_rng_session_id = sess_arg.session;
> > +
> > +     err = get_optee_rng_info();
> > +     if (err)
> > +             goto out_sess;
> > +
> > +     err = hwrng_register(&optee_rng);
> > +     if (err) {
> > +             pr_err("registering failed (%d)\n", err);
> > +             goto out_sess;
> > +     }
> > +
> > +     return 0;
> > +
> > +out_sess:
> > +     tee_client_close_session(ctx, ta_rng_session_id);
> > +out_ctx:
> > +     tee_client_close_context(ctx);
> > +
> > +     return err;
> > +}
> > +
> > +static int optee_rng_remove(struct device *dev)
> > +{
> > +     tee_client_close_session(ctx, ta_rng_session_id);
> > +     tee_client_close_context(ctx);
> > +     hwrng_unregister(&optee_rng);
> > +
> > +     return 0;
> > +}
> > +
> > +const struct tee_client_device_id optee_rng_id_table[] = {
> > +     {UUID_INIT(0xab7a617c, 0xb8e7, 0x4d8f,
> > +                0x83, 0x01, 0xd0, 0x9b, 0x61, 0x03, 0x6b, 0x64)},
> > +     {}
> > +};
> >
> Just so I'm with you here, in the v1 patch set you said, that this could be
> populated with other platform specific RNG UUID/GUID later. So if I implement
> another RNG TA for another device in OP-TEE, then I only need to update this
> array with another corresponding ID? To me it looks like the ta_rng_session_id
> just stores an id for a single TEE RNG source, correct? I.e., this patch set is
> not really written to fully support more than a single source in OP-TEE at this
> point? I.e., my assumption about just adding another UUID to the array is wrong?
>

But do you think multiple OP-TEE RNG devices/TAs for a particular
platform would be a feasible use-case? I would expect a particular
platform would expose only a single OP-TEE RNG device even if it has
multiple hardware entropy sources accessible to secure world only.

So my intention of having this id_table populated with other RNG
UUID/GUID was that if another platform chooses to implement RNG TA
with different UUID (not having global RNG TA UUID) rather than this
driver trying to support multiple devices running concurrently. Having
said that, this may be true for other TEE based drivers which would
like to support multiple devices running concurrently.

-Sumit

> > +
> > +static struct tee_client_driver optee_rng_driver = {
> > +     .id_table       = optee_rng_id_table,
> > +     .driver         = {
> > +             .name           = DRIVER_NAME,
> > +             .bus            = &tee_bus_type,
> > +             .probe          = optee_rng_probe,
> > +             .remove         = optee_rng_remove,
> > +     },
> > +};
> > +
> > +static int __init mod_init(void)
> > +{
> > +     int rc;
> > +
> > +     rc = driver_register(&optee_rng_driver.driver);
> > +     if (rc)
> > +             pr_warn("driver registration failed, err: %d", rc);
> > +
> > +     return rc;
> > +}
> > +
> > +static void __exit mod_exit(void)
> > +{
> > +     driver_unregister(&optee_rng_driver.driver);
> > +}
> > +
> > +module_init(mod_init);
> > +module_exit(mod_exit);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Sumit Garg <sumit.garg@linaro.org>");
> > +MODULE_DESCRIPTION("OP-TEE based random number generator driver");
> > --
> > 2.7.4
> >
> > _______________________________________________
> > Tee-dev mailing list
> > Tee-dev@lists.linaro.org
> > https://lists.linaro.org/mailman/listinfo/tee-dev
>
> --
> Regards,
> Joakim
