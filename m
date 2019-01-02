Return-Path: <SRS0=M78F=PK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33386 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727158AbfABI0a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Jan 2019 03:26:30 -0500
Received: by mail-lf1-f65.google.com with SMTP id i26so20506827lfc.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Jan 2019 00:26:27 -0800 (PST)
MIME-Version: 1.0
References: <1545908831-25910-1-git-send-email-sumit.garg@linaro.org>
 <1545908831-25910-3-git-send-email-sumit.garg@linaro.org> <CAKv+Gu9ShfrBhfCuRK_L_ZtZ3KnN7Jb-4hcX9nSO7AYbT8V8LQ@mail.gmail.com>
 <CAFA6WYN5+NWKpPhnGHRnh_ZOF9A8K=MvbbSQ9uvc2Tv1expXcA@mail.gmail.com>
 <CAKv+Gu-Go=GwsO=_WvmTr-OZb4WMGGQrMb2joxX1Kzfhza3JiA@mail.gmail.com>
 <CAFA6WYPm3_SZ59vOxceZkn0uzcJw3ECQZs5R_Ypz0ejpzTgAbQ@mail.gmail.com>
 <20181228144610.GA21561@jax.urgonet> <CAFA6WYMC8_VHyXft_jKJOaZ3RDQMm5Djq+wLC4rVSiduGtjiLA@mail.gmail.com>
 <CAHUa44Go8zrxcRiCLmtKqVJZTSQue1Lo4ZdFFadxDVnT2EB++w@mail.gmail.com>
In-Reply-To: <CAHUa44Go8zrxcRiCLmtKqVJZTSQue1Lo4ZdFFadxDVnT2EB++w@mail.gmail.com>
From: Bhupesh Sharma <bhsharma@redhat.com>
Date: Wed, 2 Jan 2019 13:56:12 +0530
Message-ID: <CACi5LpMp=E0Z2Bp+OvFudLogTTq4G6BgsWzr7CL40MCUcup-Ww@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] hwrng: add OP-TEE based rng driver
To: Jens Wiklander <jens.wiklander@linaro.org>
Cc: Sumit Garg <sumit.garg@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        tee-dev@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Sumit, Jens,

On Wed, Jan 2, 2019 at 1:34 PM Jens Wiklander <jens.wiklander@linaro.org> wrote:
>
> On Mon, Dec 31, 2018 at 11:24 AM Sumit Garg <sumit.garg@linaro.org> wrote:
> >
> > On Fri, 28 Dec 2018 at 20:16, Jens Wiklander <jens.wiklander@linaro.org> wrote:
> > >
> > > Hi Sumit,
> > >
> > > On Fri, Dec 28, 2018 at 06:33:22PM +0530, Sumit Garg wrote:
> > > > On Fri, 28 Dec 2018 at 16:08, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > > >
> > > > > On Fri, 28 Dec 2018 at 10:58, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > > > >
> > > > > > Thanks Ard for your comments.
> > > > > >
> > > > > > On Thu, 27 Dec 2018 at 23:58, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > > > > >
> > > > > > > On Thu, 27 Dec 2018 at 12:08, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > > > > > >
> > > > > > > > On ARM SoC's with TrustZone enabled, peripherals like entropy sources
> > > > > > > > might not be accessible to normal world (linux in this case) and rather
> > > > > > > > accessible to secure world (OP-TEE in this case) only. So this driver
> > > > > > > > aims to provides a generic interface to OP-TEE based random number
> > > > > > > > generator service.
> > > > > > > >
> > > > > > > > Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
> > > > > > > > ---
> > > > > > > >  MAINTAINERS                        |   5 +
> > > > > > > >  drivers/char/hw_random/Kconfig     |  15 ++
> > > > > > > >  drivers/char/hw_random/Makefile    |   1 +
> > > > > > > >  drivers/char/hw_random/optee-rng.c | 273 +++++++++++++++++++++++++++++++++++++
> > > > > > > >  4 files changed, 294 insertions(+)
> > > > > > > >  create mode 100644 drivers/char/hw_random/optee-rng.c
> > > > > > > >
> > > > > > >
> > > > > > > Hi Sumit,
> > > > > > >
> > > > > > > I am having some trouble with this driver. Even though the firmware
> > > > > > > manages to invoke the pseudo-TA, the kernel driver responds with
> > > > > > >
> > > > > > > [   73.915971] tee_client_open_session failed, error: ffff0008
> > > > > > >
> > > > > >
> > > > > > Please double check UUID in device tree (probably via dtc dump).
> > > > > >
> > > > >
> > > > > I have added this to the DT:
> > > > >
> > > > > --- a/Silicon/Socionext/SynQuacer/DeviceTree/SynQuacer.dtsi
> > > > > +++ b/Silicon/Socionext/SynQuacer/DeviceTree/SynQuacer.dtsi
> > > > > @@ -583,6 +583,7 @@
> > > > >              compatible = "linaro,optee-tz";
> > > > >              method = "smc";
> > > > >              status = "disabled";
> > > > > +            rng-uuid = "ab7a617c-b8e7-4d8f-8301-d09b61036b64";
> > > > >          };
> > > > >      };
> > > > >  };
> > > > >
> > > >
> > > > It pretty strange as it could work well at my end. Can you please
> > > > build optee_os with CFG_TEE_CORE_LOG_LEVEL=4 and share logs?
> > > >
> > > > >
> > > > > > > (note that I need to run teesupplicant or the insmod just hangs)
> > > > > > >
> > > > > >
> > > > > > Actually OP-TEE tries to find TA in following order:
> > > > > >
> > > > > > 1. early/pseudo TAs (resident).
> > > > > > 2. Dynamic TAs (loaded at runtime).
> > > > > >
> > > > > > So if it doesn't find early/pseudo TAs then it tries to load dynamic
> > > > > > TAs via tee-supplicant. It seems that its probably stuck in
> > > > > > "optee_supp_thrd_req" (drivers/tee/optee/supp.c +85) where it waits
> > > > > > for supplicant to fulfil the request.
> > > > > >
> > > > > > I think this should be resolved via TEE bus driver approach that I
> > > > > > have proposed in previous patch.
> > > > > >
> > > > >
> > > > > It would be useful if we could detect the absence of teesupplicant
> > > > > rather than wait indefinitely. Currenty, we cannot make the RNG driver
> > > > > a builtin due to this, so please add 'depends on m' as a dependency if
> > > > > we don't resolve this in the short term.
> > > > >
> > > >
> > > > By default this module is out of tree only (default m).
> > > >
> > > > Jens,
> > > >
> > > > Is there any particular reason to wait indefinitely in
> > > > "optee_supp_thrd_req" if there is no supplicant running? I think we
> > > > should probably return as follows from "optee_supp_thrd_req" API in
> > > > case no supplicant is available:
> > > >
> > > > --- a/drivers/tee/optee/supp.c
> > > > +++ b/drivers/tee/optee/supp.c
> > > > @@ -88,10 +88,15 @@ u32 optee_supp_thrd_req(struct tee_context *ctx,
> > > > u32 func, size_t num_params,
> > > >  {
> > > >         struct optee *optee = tee_get_drvdata(ctx->teedev);
> > > >         struct optee_supp *supp = &optee->supp;
> > > > -       struct optee_supp_req *req = kzalloc(sizeof(*req), GFP_KERNEL);
> > > > +       struct optee_supp_req *req;
> > > >         bool interruptable;
> > > >         u32 ret;
> > > >
> > > > +       /* Return in case there is no supplicant available */
> > > > +       if (!supp->ctx)
> > > > +               return TEEC_ERROR_COMMUNICATION;
> > > > +
> > > > +       req = kzalloc(sizeof(*req), GFP_KERNEL);
> > > >         if (!req)
> > > >                 return TEEC_ERROR_OUT_OF_MEMORY;
> > >
> > > From a user space point of view it has been more useful to just wait
> > > until the supplicant starts to serve requests than polling the interface
> > > until the call succeeds. For this new use case it makes more sense to be
> > > able to return an error instead.
> >
> > I don't see any case in user-space where user would launch client
> > applications before tee-supplicant daemon. If it does so, to me it
> > looks like error scenario only. Like in case of dynamic TA loading,
> > user should be informed that TA is not found indicating that
> > tee-supplicant might not be running.
>
> It takes a little while after the tee-supplicant daemon has been
> started until it has registered itself as a tee-supplicant. That
> window has to be closed in some way and that's what we've done with
> the current design.
>
> As I said in my previous mail, we need a way for the caller to tell if
> it should be blocked or get an error if tee-supplicant isn't
> available. This has to be done by extending the API instead of making
> incompatible changes of it.
>
> It is tempting to add a flag to struct tee_context (caller specific
> struct) which would indicate if tee-supplicant communication is
> allowed or not.

+1 . Adding a flag to specify a NONBLOCK'ing (call from the caller)
[similar to the getrandom() user space call - see
<http://man7.org/linux/man-pages/man2/getrandom.2.html> for details),
would be helpful - specially when we look to integrate these
user-space TEE applications with a 'systemd' like framework so that
they can be launched appropriately (in the right order) while loading
the initramfs.

Regards,
Bhupesh

> However, it's a bit ugly and also I'm not sure it will
> cover all cases we'll need.
>
> -Jens
>
> >
> > -Sumit
> >
> > >
> > > The proposed change is a user space API change, so we will need to do a
> > > bit more than that.
> > >
> > > -Jens
> > >
> > > >
> > > > > > > Also, I have some concerns about the DT dependency (see my comment on
> > > > > > > the previous patch)
> > > > > > > I will cc you on some patches I have to expose OP-TEE via ACPI (as
> > > > > > > well as DT) as a platform device. I'd prefer it if we could do the
> > > > > > > same for this driver in one way or the other.
> > > > > > >
> > > > > >
> > > > > > Probably via TEE bus driver approach we may get rid of DT or ACPI
> > > > > > dependency. BTW, I will switch to platform device as it looks more
> > > > > > appropriate.
> > > > > >
> > > > >
> > > > > The bus driver approach only makes sense if we can enumerate the
> > > > > available TAs, rather than describe them via the DT or ACPI tables.
> > > > >
> > > > > But a child node with its own compatible string is an improvement in
> > > > > any case, and you can let the driver core instantiate the platform
> > > > > device for you.
> > > > >
> > > >
> > > > Ok then I will keep DT or ACPI child node.
> > > >
> > > > -Sumit
> > > >
> > > > > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > > > > index 0767f1d..fe0fb74 100644
> > > > > > > > --- a/MAINTAINERS
> > > > > > > > +++ b/MAINTAINERS
> > > > > > > > @@ -11100,6 +11100,11 @@ M:     Jens Wiklander <jens.wiklander@linaro.org>
> > > > > > > >  S:     Maintained
> > > > > > > >  F:     drivers/tee/optee/
> > > > > > > >
> > > > > > > > +OP-TEE RANDOM NUMBER GENERATOR (RNG) DRIVER
> > > > > > > > +M:     Sumit Garg <sumit.garg@linaro.org>
> > > > > > > > +S:     Maintained
> > > > > > > > +F:     drivers/char/hw_random/optee-rng.c
> > > > > > > > +
> > > > > > > >  OPA-VNIC DRIVER
> > > > > > > >  M:     Dennis Dalessandro <dennis.dalessandro@intel.com>
> > > > > > > >  M:     Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
> > > > > > > > diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> > > > > > > > index dac895d..25a7d8f 100644
> > > > > > > > --- a/drivers/char/hw_random/Kconfig
> > > > > > > > +++ b/drivers/char/hw_random/Kconfig
> > > > > > > > @@ -424,6 +424,21 @@ config HW_RANDOM_EXYNOS
> > > > > > > >           will be called exynos-trng.
> > > > > > > >
> > > > > > > >           If unsure, say Y.
> > > > > > > > +
> > > > > > > > +config HW_RANDOM_OPTEE
> > > > > > > > +       tristate "OP-TEE based Random Number Generator support"
> > > > > > > > +       depends on OPTEE
> > > > > > > > +       default HW_RANDOM
> > > > > > > > +       help
> > > > > > > > +         This  driver provides support for OP-TEE based Random Number
> > > > > > > > +         Generator on ARM SoCs where hardware entropy sources are not
> > > > > > > > +         accessible to normal world (Linux).
> > > > > > > > +
> > > > > > > > +         To compile this driver as a module, choose M here: the module
> > > > > > > > +         will be called optee-rng.
> > > > > > > > +
> > > > > > > > +         If unsure, say Y.
> > > > > > > > +
> > > > > > > >  endif # HW_RANDOM
> > > > > > > >
> > > > > > > >  config UML_RANDOM
> > > > > > > > diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> > > > > > > > index e35ec3c..7c9ef4a 100644
> > > > > > > > --- a/drivers/char/hw_random/Makefile
> > > > > > > > +++ b/drivers/char/hw_random/Makefile
> > > > > > > > @@ -38,3 +38,4 @@ obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
> > > > > > > >  obj-$(CONFIG_HW_RANDOM_MTK)    += mtk-rng.o
> > > > > > > >  obj-$(CONFIG_HW_RANDOM_S390) += s390-trng.o
> > > > > > > >  obj-$(CONFIG_HW_RANDOM_KEYSTONE) += ks-sa-rng.o
> > > > > > > > +obj-$(CONFIG_HW_RANDOM_OPTEE) += optee-rng.o
> > > > > > > > diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
> > > > > > > > new file mode 100644
> > > > > > > > index 0000000..8c63730
> > > > > > > > --- /dev/null
> > > > > > > > +++ b/drivers/char/hw_random/optee-rng.c
> > > > > > > > @@ -0,0 +1,273 @@
> > > > > > > > +// SPDX-License-Identifier: GPL-2.0
> > > > > > > > +/*
> > > > > > > > + * Copyright (C) 2018 Linaro Ltd.
> > > > > > > > + */
> > > > > > > > +
> > > > > > > > +#include <linux/delay.h>
> > > > > > > > +#include <linux/of.h>
> > > > > > > > +#include <linux/hw_random.h>
> > > > > > > > +#include <linux/kernel.h>
> > > > > > > > +#include <linux/module.h>
> > > > > > > > +#include <linux/tee_drv.h>
> > > > > > > > +#include <linux/uuid.h>
> > > > > > > > +
> > > > > > > > +#define TEE_ERROR_HEALTH_TEST_FAIL     0x00000001
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * TA_CMD_GET_ENTROPY - Get Entropy from RNG
> > > > > > > > + *
> > > > > > > > + * param[0] (inout memref) - Entropy buffer memory reference
> > > > > > > > + * param[1] unused
> > > > > > > > + * param[2] unused
> > > > > > > > + * param[3] unused
> > > > > > > > + *
> > > > > > > > + * Result:
> > > > > > > > + * TEE_SUCCESS - Invoke command success
> > > > > > > > + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > > > > > > > + * TEE_ERROR_NOT_SUPPORTED - Requested entropy size greater than size of pool
> > > > > > > > + * TEE_ERROR_HEALTH_TEST_FAIL - Continuous health testing failed
> > > > > > > > + */
> > > > > > > > +#define TA_CMD_GET_ENTROPY             0x0
> > > > > > > > +
> > > > > > > > +/*
> > > > > > > > + * TA_CMD_GET_RNG_INFO - Get RNG information
> > > > > > > > + *
> > > > > > > > + * param[0] (out value) - value.a: RNG data-rate in bytes per second
> > > > > > > > + *                        value.b: Quality/Entropy per 1024 bit of data
> > > > > > > > + * param[1] unused
> > > > > > > > + * param[2] unused
> > > > > > > > + * param[3] unused
> > > > > > > > + *
> > > > > > > > + * Result:
> > > > > > > > + * TEE_SUCCESS - Invoke command success
> > > > > > > > + * TEE_ERROR_BAD_PARAMETERS - Incorrect input param
> > > > > > > > + */
> > > > > > > > +#define TA_CMD_GET_RNG_INFO            0x1
> > > > > > > > +
> > > > > > > > +#define MAX_ENTROPY_REQ_SZ             (4 * 1024)
> > > > > > > > +
> > > > > > > > +static struct tee_context *ctx;
> > > > > > > > +static struct tee_shm *entropy_shm_pool;
> > > > > > > > +static u32 ta_rng_data_rate;
> > > > > > > > +static u32 ta_rng_seesion_id;
> > > > > > >
> > > > > > > session not seesion
> > > > > > >
> > > > > >
> > > > > > Will fix.
> > > > > >
> > > > > > > > +
> > > > > > > > +static size_t get_optee_rng_data(void *buf, size_t req_size)
> > > > > > > > +{
> > > > > > > > +       u32 ret = 0;
> > > > > > > > +       u8 *rng_data = NULL;
> > > > > > > > +       size_t rng_size = 0;
> > > > > > > > +       struct tee_ioctl_invoke_arg inv_arg = {0};
> > > > > > > > +       struct tee_param param[4] = {0};
> > > > > > > > +
> > > > > > > > +       /* Invoke TA_CMD_GET_RNG function of Trusted App */
> > > > > > > > +       inv_arg.func = TA_CMD_GET_ENTROPY;
> > > > > > > > +       inv_arg.session = ta_rng_seesion_id;
> > > > > > > > +       inv_arg.num_params = 4;
> > > > > > > > +
> > > > > > > > +       /* Fill invoke cmd params */
> > > > > > > > +       param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT;
> > > > > > > > +       param[0].u.memref.shm = entropy_shm_pool;
> > > > > > > > +       param[0].u.memref.size = req_size;
> > > > > > > > +       param[0].u.memref.shm_offs = 0;
> > > > > > > > +
> > > > > > > > +       ret = tee_client_invoke_func(ctx, &inv_arg, param);
> > > > > > > > +       if ((ret < 0) || (inv_arg.ret != 0)) {
> > > > > > > > +               pr_err("TA_CMD_GET_ENTROPY invoke function error: %x\n",
> > > > > > > > +                      inv_arg.ret);
> > > > > > > > +               return 0;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       rng_data = tee_shm_get_va(entropy_shm_pool, 0);
> > > > > > > > +       if (IS_ERR(rng_data)) {
> > > > > > > > +               pr_err("tee_shm_get_va failed\n");
> > > > > > > > +               return 0;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       rng_size = param[0].u.memref.size;
> > > > > > > > +       memcpy(buf, rng_data, rng_size);
> > > > > > > > +
> > > > > > > > +       return rng_size;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> > > > > > > > +{
> > > > > > > > +       u8 *data = buf;
> > > > > > > > +       size_t read = 0, rng_size = 0;
> > > > > > > > +       int timeout = 1;
> > > > > > > > +
> > > > > > > > +       if (max > MAX_ENTROPY_REQ_SZ)
> > > > > > > > +               max = MAX_ENTROPY_REQ_SZ;
> > > > > > > > +
> > > > > > > > +       while (read == 0) {
> > > > > > > > +               rng_size = get_optee_rng_data(data, (max - read));
> > > > > > > > +
> > > > > > > > +               data += rng_size;
> > > > > > > > +               read += rng_size;
> > > > > > > > +
> > > > > > > > +               if (wait) {
> > > > > > > > +                       if (timeout-- == 0)
> > > > > > > > +                               return read;
> > > > > > > > +                       msleep((1000 * (max - read)) / ta_rng_data_rate);
> > > > > > > > +               } else {
> > > > > > > > +                       return read;
> > > > > > > > +               }
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       return read;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static int optee_rng_init(struct hwrng *rng)
> > > > > > > > +{
> > > > > > > > +       entropy_shm_pool = tee_shm_alloc(ctx, MAX_ENTROPY_REQ_SZ,
> > > > > > > > +                                        TEE_SHM_MAPPED | TEE_SHM_DMA_BUF);
> > > > > > > > +       if (IS_ERR(entropy_shm_pool)) {
> > > > > > > > +               pr_err("tee_shm_alloc failed\n");
> > > > > > > > +               return PTR_ERR(entropy_shm_pool);
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       return 0;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static void optee_rng_cleanup(struct hwrng *rng)
> > > > > > > > +{
> > > > > > > > +       tee_shm_free(entropy_shm_pool);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static struct hwrng optee_rng = {
> > > > > > > > +       .name           = "optee-rng",
> > > > > > > > +       .init           = optee_rng_init,
> > > > > > > > +       .cleanup        = optee_rng_cleanup,
> > > > > > > > +       .read           = optee_rng_read,
> > > > > > > > +};
> > > > > > > > +
> > > > > > > > +static const struct of_device_id optee_match[] = {
> > > > > > > > +       { .compatible = "linaro,optee-tz" },
> > > > > > > > +       {},
> > > > > > > > +};
> > > > > > > > +
> > > > > > > > +static int get_optee_rng_uuid(uuid_t *ta_rng_uuid)
> > > > > > > > +{
> > > > > > > > +       struct device_node *fw_np;
> > > > > > > > +       struct device_node *np;
> > > > > > > > +       const char *uuid;
> > > > > > > > +
> > > > > > > > +       /* Node is supposed to be below /firmware */
> > > > > > > > +       fw_np = of_find_node_by_name(NULL, "firmware");
> > > > > > > > +       if (!fw_np)
> > > > > > > > +               return -ENODEV;
> > > > > > > > +
> > > > > > > > +       np = of_find_matching_node(fw_np, optee_match);
> > > > > > > > +       if (!np || !of_device_is_available(np))
> > > > > > > > +               return -ENODEV;
> > > > > > > > +
> > > > > > > > +       if (of_property_read_string(np, "rng-uuid", &uuid)) {
> > > > > > > > +               pr_warn("missing \"uuid\" property\n");
> > > > > > > > +               return -ENXIO;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > >
> > > > > > > So, duplicating all of this is really not a good idea.
> > > > > > >
> > > > > >
> > > > > > Yeah, we may not need this in case we go via TEE bus driver approach.
> > > > > >
> > > > > > > > +       if (uuid_parse(uuid, ta_rng_uuid)) {
> > > > > > > > +               pr_warn("incorrect rng ta uuid\n");
> > > > > > > > +               return -EINVAL;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       return 0;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static int get_optee_rng_info(void)
> > > > > > > > +{
> > > > > > > > +       u32 ret = 0;
> > > > > > > > +       struct tee_ioctl_invoke_arg inv_arg = {0};
> > > > > > > > +       struct tee_param param[4] = {0};
> > > > > > > > +
> > > > > > > > +       /* Invoke TA_CMD_GET_RNG function of Trusted App */
> > > > > > > > +       inv_arg.func = TA_CMD_GET_RNG_INFO;
> > > > > > > > +       inv_arg.session = ta_rng_seesion_id;
> > > > > > > > +       inv_arg.num_params = 4;
> > > > > > > > +
> > > > > > > > +       /* Fill invoke cmd params */
> > > > > > > > +       param[0].attr = TEE_IOCTL_PARAM_ATTR_TYPE_VALUE_OUTPUT;
> > > > > > > > +
> > > > > > > > +       ret = tee_client_invoke_func(ctx, &inv_arg, param);
> > > > > > > > +       if ((ret < 0) || (inv_arg.ret != 0)) {
> > > > > > > > +               pr_err("TA_CMD_GET_RNG_INFO invoke function error: %x\n",
> > > > > > > > +                      inv_arg.ret);
> > > > > > > > +               return -EINVAL;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       ta_rng_data_rate = param[0].u.value.a;
> > > > > > > > +       optee_rng.quality = param[0].u.value.b;
> > > > > > > > +
> > > > > > > > +       return 0;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static int optee_ctx_match(struct tee_ioctl_version_data *ver, const void *data)
> > > > > > > > +{
> > > > > > > > +       if (ver->impl_id == TEE_IMPL_ID_OPTEE)
> > > > > > > > +               return 1;
> > > > > > > > +       else
> > > > > > > > +               return 0;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static int __init mod_init(void)
> > > > > > > > +{
> > > > > > > > +       int ret = 0, err = -ENODEV;
> > > > > > > > +       struct tee_ioctl_open_session_arg sess_arg = {0};
> > > > > > > > +       uuid_t ta_rng_uuid = {0};
> > > > > > > > +
> > > > > > > > +       err = get_optee_rng_uuid(&ta_rng_uuid);
> > > > > > > > +       if (err)
> > > > > > > > +               return err;
> > > > > > > > +
> > > > > > > > +       /* Open context with TEE driver */
> > > > > > > > +       ctx = tee_client_open_context(NULL, optee_ctx_match, NULL, NULL);
> > > > > > > > +       if (IS_ERR(ctx))
> > > > > > > > +               return -ENODEV;
> > > > > > > > +
> > > > > > > > +       /* Open session with hwrng Trusted App */
> > > > > > > > +       memcpy(sess_arg.uuid, ta_rng_uuid.b, TEE_IOCTL_UUID_LEN);
> > > > > > > > +       sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
> > > > > > > > +       sess_arg.num_params = 0;
> > > > > > > > +
> > > > > > > > +       ret = tee_client_open_session(ctx, &sess_arg, NULL);
> > > > > > > > +       if ((ret < 0) || (sess_arg.ret != 0)) {
> > > > > > > > +               pr_err("tee_client_open_session failed, error: %x\n",
> > > > > > > > +                      sess_arg.ret);
> > > > > > > > +               err = -EINVAL;
> > > > > > > > +               goto out_ctx;
> > > > > > > > +       }
> > > > > > > > +       ta_rng_seesion_id = sess_arg.session;
> > > > > > > > +
> > > > > > > > +       err = get_optee_rng_info();
> > > > > > > > +       if (err)
> > > > > > > > +               goto out_sess;
> > > > > > > > +
> > > > > > > > +       err = hwrng_register(&optee_rng);
> > > > > > > > +       if (err) {
> > > > > > > > +               pr_err("registering failed (%d)\n", err);
> > > > > > > > +               goto out_sess;
> > > > > > > > +       }
> > > > > > > > +
> > > > > > > > +       return 0;
> > > > > > > > +
> > > > > > > > +out_sess:
> > > > > > > > +       tee_client_close_session(ctx, ta_rng_seesion_id);
> > > > > > > > +out_ctx:
> > > > > > > > +       tee_client_close_context(ctx);
> > > > > > > > +
> > > > > > > > +       return err;
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +static void __exit mod_exit(void)
> > > > > > > > +{
> > > > > > > > +       tee_client_close_session(ctx, ta_rng_seesion_id);
> > > > > > > > +       tee_client_close_context(ctx);
> > > > > > > > +       hwrng_unregister(&optee_rng);
> > > > > > > > +}
> > > > > > > > +
> > > > > > > > +module_init(mod_init);
> > > > > > > > +module_exit(mod_exit);
> > > > > > > > +
> > > > > > > > +MODULE_LICENSE("GPL");
> > > > > > > > +MODULE_AUTHOR("Sumit Garg <sumit.garg@linaro.org>");
> > > > > > > > +MODULE_DESCRIPTION("OP-TEE based random number generator driver");
> > > > > > > > +MODULE_SOFTDEP("pre: optee");
> > > > > > >
> > > > > > > This is also an indicator that the API design needs some work. If the
> > > > > > > OP-TEE driver becomes a 'bus' driver of some sort, the child RNG
> > > > > > > device (which is what this driver should bind to) will only exist if
> > > > > > > a) the OP-TEE driver is loaded, and b) it has actually bound to the
> > > > > > > /firmware/optee node.
> > > > > > >
> > > > > >
> > > > > > Agree.
> > > > > >
> > > > > > > > --
> > > > > > > > 2.7.4
> > > > > > > >
