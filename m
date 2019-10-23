Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A883CCA9EB7
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60AB421906
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 11:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TfWAAtO7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733010AbfJWLuA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 07:50:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38052 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733180AbfJWLt6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 07:49:58 -0400
Received: by mail-wm1-f65.google.com with SMTP id 3so19367381wmi.3
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2019 04:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4K9OCfit5T6n8+/AYdI1Tur6T3rLImT5pMyF0OcvrVI=;
        b=TfWAAtO7aIn31fG81rNWnhgSG1xr+Ssyix6UpSdstHjP1sSuRsDoslVRVtISMYqxjz
         ArK0ORNkWDZUj5sj1xb7i4prhMEc2b7aII/ykkHlYJMEwWEsIa047Bw8mOLcY5y4ORvF
         sfwJhiPtQosZnNtdydGS+Y2WwzbJ7KLFUQ7Kpy3KePbi/Kwp1htGwxe5d0q9zKRBxsbP
         iJMaS4iHvMHmbq4K5aTrror1d4ED+z/Ru+ZGGlf+CaZHjbHXD6pJgJNzrjyeSOZ+txvP
         gLjEAZ40VWdJolO0kXHlgl0C0UsCioR5oij+OkFTcE6Cup4uV2B6fpGl2g5DZDhpXhRZ
         5DNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4K9OCfit5T6n8+/AYdI1Tur6T3rLImT5pMyF0OcvrVI=;
        b=IkaHIXDLce2WUH1Xuft0T3pJZ5bytBjz42+ACJ3Mg/6aHyKtL+NZJ/Rn6rkqbUJC/A
         LidesbnCZscy/ZD52rwAz3bcKIO3awqJCk952cwq1+6pcuiVs4n0v4f7Ou4dZjk6VGsw
         cU6YDyqAfbvN1aw1w74imLqhMehRbCfNkhmqqROV0988UT/Vdn2QeSdWdHCaY1nUmIpJ
         dFRqDYUeSWEAKfEoUSxReadOeMpU5Jm5TRTikcSh1i7brj6kqlEdkn/Pem3fG7BUXwhI
         gf30lovYX4+E4wxaJXncW2fyL3HyLKO0fADvcnlIO7VQRI4RF8mQHJwLeURfWItcCrVO
         oA7Q==
X-Gm-Message-State: APjAAAXukXiLNulgPnEXUFExfC9b10WjTgsVoLQEowTLBj5Ddl3G4WVy
        Lw6c5GVnRQiNSDLQ//pZZO96QhOhc+EmT2EI1ukZaA==
X-Google-Smtp-Source: APXvYqzyT7JLnx2yu9dDk42L3TBnzCekQ1L1nn6ZtMPNZDzi1tenWwIW7ax1HvaEU7Vs+a5tvtiWoK41D3IrntlMJ4A=
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr7541058wme.53.1571831392823;
 Wed, 23 Oct 2019 04:49:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571817675.git.Rijo-john.Thomas@amd.com> <fba6bc3fe8ec3d163f5e37e54046f412cd6435b5.1571817675.git.Rijo-john.Thomas@amd.com>
In-Reply-To: <fba6bc3fe8ec3d163f5e37e54046f412cd6435b5.1571817675.git.Rijo-john.Thomas@amd.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 23 Oct 2019 13:49:41 +0200
Message-ID: <CAKv+Gu_3qh4g-e2Ek5-8eJzmDpmRD6o3kwe=MdFiSDqYhMm0aQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] crypto: ccp - add TEE support for Raven Ridge
To:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Easow, Nimesh" <Nimesh.Easow@amd.com>,
        "Rangasamy, Devaraj" <Devaraj.Rangasamy@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Jens)

On Wed, 23 Oct 2019 at 13:27, Thomas, Rijo-john
<Rijo-john.Thomas@amd.com> wrote:
>
> Adds a PCI device entry for Raven Ridge. Raven Ridge is an APU with a
> dedicated AMD Secure Processor having Trusted Execution Environment (TEE)
> support. The TEE provides a secure environment for running Trusted
> Applications (TAs) which implement security-sensitive parts of a feature.
>
> This patch configures AMD Secure Processor's TEE interface by initializing
> a ring buffer (shared memory between Rich OS and Trusted OS) which can hold
> multiple command buffer entries. The TEE interface is facilitated by a set
> of CPU to PSP mailbox registers.
>
> The next patch will address how commands are submitted to the ring buffer.
>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> ---
>  drivers/crypto/ccp/Makefile  |   3 +-
>  drivers/crypto/ccp/psp-dev.c |  74 +++++++++++++-
>  drivers/crypto/ccp/psp-dev.h |   8 ++
>  drivers/crypto/ccp/sp-dev.h  |  11 +-
>  drivers/crypto/ccp/sp-pci.c  |  27 ++++-
>  drivers/crypto/ccp/tee-dev.c | 237 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/tee-dev.h | 108 ++++++++++++++++++++
>  7 files changed, 461 insertions(+), 7 deletions(-)
>  create mode 100644 drivers/crypto/ccp/tee-dev.c
>  create mode 100644 drivers/crypto/ccp/tee-dev.h
>

How does this patch tie into the TEE subsystem we have in drivers/tee?




> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 3b29ea4..db362fe 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -9,7 +9,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
>  ccp-$(CONFIG_CRYPTO_DEV_CCP_DEBUGFS) += ccp-debugfs.o
>  ccp-$(CONFIG_PCI) += sp-pci.o
>  ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
> -                                   sev-dev.o
> +                                   sev-dev.o \
> +                                   tee-dev.o
>
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index ef8affa..90bcd5f 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -13,6 +13,7 @@
>  #include "sp-dev.h"
>  #include "psp-dev.h"
>  #include "sev-dev.h"
> +#include "tee-dev.h"
>
>  struct psp_device *psp_master;
>
> @@ -45,6 +46,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>         if (status) {
>                 if (psp->sev_irq_handler)
>                         psp->sev_irq_handler(irq, psp->sev_irq_data, status);
> +
> +               if (psp->tee_irq_handler)
> +                       psp->tee_irq_handler(irq, psp->tee_irq_data, status);
>         }
>
>         /* Clear the interrupt status by writing the same value we read. */
> @@ -53,10 +57,11 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>         return IRQ_HANDLED;
>  }
>
> -static int psp_check_sev_support(struct psp_device *psp)
> +static int psp_check_sev_support(struct psp_device *psp,
> +                                unsigned int capability)
>  {
>         /* Check if device supports SEV feature */
> -       if (!(ioread32(psp->io_regs + psp->vdata->feature_reg) & 1)) {
> +       if (!(capability & 1)) {
>                 dev_dbg(psp->dev, "psp does not support SEV\n");
>                 return -ENODEV;
>         }
> @@ -64,10 +69,54 @@ static int psp_check_sev_support(struct psp_device *psp)
>         return 0;
>  }
>
> +static int psp_check_tee_support(struct psp_device *psp,
> +                                unsigned int capability)
> +{
> +       /* Check if device supports TEE feature */
> +       if (!(capability & 2)) {
> +               dev_dbg(psp->dev, "psp does not support TEE\n");
> +               return -ENODEV;
> +       }
> +
> +       return 0;
> +}
> +
> +static int psp_check_support(struct psp_device *psp, unsigned int capability)
> +{
> +       int sev_support = psp_check_sev_support(psp, capability);
> +       int tee_support = psp_check_tee_support(psp, capability);
> +
> +       /* Check if device supprts SEV and TEE feature */
> +       if (sev_support && tee_support)
> +               return -ENODEV;
> +
> +       return 0;
> +}
> +
> +static int psp_init(struct psp_device *psp, unsigned int capability)
> +{
> +       int ret;
> +
> +       if (!psp_check_sev_support(psp, capability)) {
> +               ret = sev_dev_init(psp);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       if (!psp_check_tee_support(psp, capability)) {
> +               ret = tee_dev_init(psp);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       return 0;
> +}
> +
>  int psp_dev_init(struct sp_device *sp)
>  {
>         struct device *dev = sp->dev;
>         struct psp_device *psp;
> +       unsigned int capability;
>         int ret;
>
>         ret = -ENOMEM;
> @@ -86,7 +135,10 @@ int psp_dev_init(struct sp_device *sp)
>
>         psp->io_regs = sp->io_map;
>
> -       ret = psp_check_sev_support(psp);
> +       /* Read the feature register to get the PSP capability */
> +       capability = ioread32(psp->io_regs + psp->vdata->feature_reg);
> +
> +       ret = psp_check_support(psp, capability);
>         if (ret)
>                 goto e_disable;
>
> @@ -101,7 +153,7 @@ int psp_dev_init(struct sp_device *sp)
>                 goto e_err;
>         }
>
> -       ret = sev_dev_init(psp);
> +       ret = psp_init(psp, capability);
>         if (ret)
>                 goto e_irq;
>
> @@ -139,6 +191,8 @@ void psp_dev_destroy(struct sp_device *sp)
>
>         sev_dev_destroy(psp);
>
> +       tee_dev_destroy(psp);
> +
>         sp_free_psp_irq(sp, psp);
>  }
>
> @@ -154,6 +208,18 @@ void psp_clear_sev_irq_handler(struct psp_device *psp)
>         psp_set_sev_irq_handler(psp, NULL, NULL);
>  }
>
> +void psp_set_tee_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
> +                            void *data)
> +{
> +       psp->tee_irq_data = data;
> +       psp->tee_irq_handler = handler;
> +}
> +
> +void psp_clear_tee_irq_handler(struct psp_device *psp)
> +{
> +       psp_set_tee_irq_handler(psp, NULL, NULL);
> +}
> +
>  struct psp_device *psp_get_master_device(void)
>  {
>         struct sp_device *sp = sp_get_psp_master_device();
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> index 7c014ac..ef38e41 100644
> --- a/drivers/crypto/ccp/psp-dev.h
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -40,13 +40,21 @@ struct psp_device {
>         psp_irq_handler_t sev_irq_handler;
>         void *sev_irq_data;
>
> +       psp_irq_handler_t tee_irq_handler;
> +       void *tee_irq_data;
> +
>         void *sev_data;
> +       void *tee_data;
>  };
>
>  void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
>                              void *data);
>  void psp_clear_sev_irq_handler(struct psp_device *psp);
>
> +void psp_set_tee_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
> +                            void *data);
> +void psp_clear_tee_irq_handler(struct psp_device *psp);
> +
>  struct psp_device *psp_get_master_device(void);
>
>  #endif /* __PSP_DEV_H */
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 0394c75..4235946 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -2,7 +2,7 @@
>  /*
>   * AMD Secure Processor driver
>   *
> - * Copyright (C) 2017-2018 Advanced Micro Devices, Inc.
> + * Copyright (C) 2017-2019 Advanced Micro Devices, Inc.
>   *
>   * Author: Tom Lendacky <thomas.lendacky@amd.com>
>   * Author: Gary R Hook <gary.hook@amd.com>
> @@ -45,8 +45,17 @@ struct sev_vdata {
>         const unsigned int cmdbuff_addr_hi_reg;
>  };
>
> +struct tee_vdata {
> +       const unsigned int cmdresp_reg;
> +       const unsigned int cmdbuff_addr_lo_reg;
> +       const unsigned int cmdbuff_addr_hi_reg;
> +       const unsigned int ring_wptr_reg;
> +       const unsigned int ring_rptr_reg;
> +};
> +
>  struct psp_vdata {
>         const struct sev_vdata *sev;
> +       const struct tee_vdata *tee;
>         const unsigned int feature_reg;
>         const unsigned int inten_reg;
>         const unsigned int intsts_reg;
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 733693d..56c1f61 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -2,7 +2,7 @@
>  /*
>   * AMD Secure Processor device driver
>   *
> - * Copyright (C) 2013,2018 Advanced Micro Devices, Inc.
> + * Copyright (C) 2013,2019 Advanced Micro Devices, Inc.
>   *
>   * Author: Tom Lendacky <thomas.lendacky@amd.com>
>   * Author: Gary R Hook <gary.hook@amd.com>
> @@ -274,6 +274,14 @@ static int sp_pci_resume(struct pci_dev *pdev)
>         .cmdbuff_addr_hi_reg    = 0x109e4,
>  };
>
> +static const struct tee_vdata teev1 = {
> +       .cmdresp_reg            = 0x10544,
> +       .cmdbuff_addr_lo_reg    = 0x10548,
> +       .cmdbuff_addr_hi_reg    = 0x1054c,
> +       .ring_wptr_reg          = 0x10550,
> +       .ring_rptr_reg          = 0x10554,
> +};
> +
>  static const struct psp_vdata pspv1 = {
>         .sev                    = &sevv1,
>         .feature_reg            = 0x105fc,
> @@ -287,6 +295,13 @@ static int sp_pci_resume(struct pci_dev *pdev)
>         .inten_reg              = 0x10690,
>         .intsts_reg             = 0x10694,
>  };
> +
> +static const struct psp_vdata pspv3 = {
> +       .tee                    = &teev1,
> +       .feature_reg            = 0x109fc,
> +       .inten_reg              = 0x10690,
> +       .intsts_reg             = 0x10694,
> +};
>  #endif
>
>  static const struct sp_dev_vdata dev_vdata[] = {
> @@ -320,12 +335,22 @@ static int sp_pci_resume(struct pci_dev *pdev)
>                 .psp_vdata = &pspv2,
>  #endif
>         },
> +       {       /* 4 */
> +               .bar = 2,
> +#ifdef CONFIG_CRYPTO_DEV_SP_CCP
> +               .ccp_vdata = &ccpv5a,
> +#endif
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +               .psp_vdata = &pspv3,
> +#endif
> +       },
>  };
>  static const struct pci_device_id sp_pci_table[] = {
>         { PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
>         { PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&dev_vdata[1] },
>         { PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
>         { PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
> +       { PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
>         /* Last entry must be zero */
>         { 0, }
>  };
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> new file mode 100644
> index 0000000..b2b0215
> --- /dev/null
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -0,0 +1,237 @@
> +// SPDX-License-Identifier: MIT
> +/*
> + * AMD Trusted Execution Environment (TEE) interface
> + *
> + * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
> + *
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/gfp.h>
> +#include <linux/psp-sev.h>
> +
> +#include "psp-dev.h"
> +#include "tee-dev.h"
> +
> +static bool psp_dead;
> +
> +static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
> +{
> +       struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
> +       void *start_addr;
> +
> +       if (!ring_size)
> +               return -EINVAL;
> +
> +       /* We need actual physical address instead of DMA address, since
> +        * Trusted OS running on AMD Secure Processor will map this region
> +        */
> +       start_addr = (void *)__get_free_pages(GFP_KERNEL, get_order(ring_size));
> +       if (!start_addr)
> +               return -ENOMEM;
> +
> +       rb_mgr->ring_start = start_addr;
> +       rb_mgr->ring_size = ring_size;
> +       rb_mgr->ring_pa = __psp_pa(start_addr);
> +
> +       return 0;
> +}
> +
> +static void tee_free_ring(struct psp_tee_device *tee)
> +{
> +       struct ring_buf_manager *rb_mgr = &tee->rb_mgr;
> +
> +       if (!rb_mgr->ring_start)
> +               return;
> +
> +       free_pages((unsigned long)rb_mgr->ring_start,
> +                  get_order(rb_mgr->ring_size));
> +
> +       rb_mgr->ring_start = NULL;
> +       rb_mgr->ring_size = 0;
> +       rb_mgr->ring_pa = 0;
> +}
> +
> +static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
> +                            unsigned int *reg)
> +{
> +       /* ~10ms sleep per loop => nloop = timeout * 100 */
> +       int nloop = timeout * 100;
> +
> +       while (--nloop) {
> +               *reg = ioread32(tee->io_regs + tee->vdata->cmdresp_reg);
> +               if (*reg & PSP_CMDRESP_RESP)
> +                       return 0;
> +
> +               usleep_range(10000, 10100);
> +       }
> +
> +       dev_err(tee->dev, "tee: command timed out, disabling PSP\n");
> +       psp_dead = true;
> +
> +       return -ETIMEDOUT;
> +}
> +
> +static
> +struct tee_init_ring_cmd *tee_alloc_cmd_buffer(struct psp_tee_device *tee)
> +{
> +       struct tee_init_ring_cmd *cmd;
> +
> +       cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +       if (!cmd)
> +               return NULL;
> +
> +       cmd->hi_addr = upper_32_bits(tee->rb_mgr.ring_pa);
> +       cmd->low_addr = lower_32_bits(tee->rb_mgr.ring_pa);
> +       cmd->size = tee->rb_mgr.ring_size;
> +
> +       dev_dbg(tee->dev, "tee: ring address: high = 0x%x low = 0x%x size = %u\n",
> +               cmd->hi_addr, cmd->low_addr, cmd->size);
> +
> +       return cmd;
> +}
> +
> +static inline void tee_free_cmd_buffer(struct tee_init_ring_cmd *cmd)
> +{
> +       kfree(cmd);
> +}
> +
> +static int tee_init_ring(struct psp_tee_device *tee)
> +{
> +       int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
> +       struct tee_init_ring_cmd *cmd;
> +       phys_addr_t cmd_buffer;
> +       unsigned int reg;
> +       int ret;
> +
> +       BUILD_BUG_ON(sizeof(struct tee_ring_cmd) != 1024);
> +
> +       ret = tee_alloc_ring(tee, ring_size);
> +       if (ret) {
> +               dev_err(tee->dev, "tee: ring allocation failed %d\n", ret);
> +               return ret;
> +       }
> +
> +       tee->rb_mgr.wptr = 0;
> +
> +       cmd = tee_alloc_cmd_buffer(tee);
> +       if (!cmd) {
> +               tee_free_ring(tee);
> +               return -ENOMEM;
> +       }
> +
> +       cmd_buffer = __psp_pa((void *)cmd);
> +
> +       /* Send command buffer details to Trusted OS by writing to
> +        * CPU-PSP message registers
> +        */
> +
> +       iowrite32(lower_32_bits(cmd_buffer),
> +                 tee->io_regs + tee->vdata->cmdbuff_addr_lo_reg);
> +       iowrite32(upper_32_bits(cmd_buffer),
> +                 tee->io_regs + tee->vdata->cmdbuff_addr_hi_reg);
> +       iowrite32(TEE_RING_INIT_CMD,
> +                 tee->io_regs + tee->vdata->cmdresp_reg);
> +
> +       ret = tee_wait_cmd_poll(tee, TEE_DEFAULT_TIMEOUT, &reg);
> +       if (ret) {
> +               dev_err(tee->dev, "tee: ring init command timed out\n");
> +               tee_free_ring(tee);
> +               goto free_buf;
> +       }
> +
> +       if (reg & PSP_CMDRESP_ERR_MASK) {
> +               dev_err(tee->dev, "tee: ring init command failed (%#010x)\n",
> +                       reg & PSP_CMDRESP_ERR_MASK);
> +               tee_free_ring(tee);
> +               ret = -EIO;
> +       }
> +
> +free_buf:
> +       tee_free_cmd_buffer(cmd);
> +
> +       return ret;
> +}
> +
> +static void tee_destroy_ring(struct psp_tee_device *tee)
> +{
> +       unsigned int reg;
> +       int ret;
> +
> +       if (!tee->rb_mgr.ring_start)
> +               return;
> +
> +       if (psp_dead)
> +               goto free_ring;
> +
> +       iowrite32(TEE_RING_DESTROY_CMD,
> +                 tee->io_regs + tee->vdata->cmdresp_reg);
> +
> +       ret = tee_wait_cmd_poll(tee, TEE_DEFAULT_TIMEOUT, &reg);
> +       if (ret) {
> +               dev_err(tee->dev, "tee: ring destroy command timed out\n");
> +       } else if (reg & PSP_CMDRESP_ERR_MASK) {
> +               dev_err(tee->dev, "tee: ring destroy command failed (%#010x)\n",
> +                       reg & PSP_CMDRESP_ERR_MASK);
> +       }
> +
> +free_ring:
> +       tee_free_ring(tee);
> +}
> +
> +int tee_dev_init(struct psp_device *psp)
> +{
> +       struct device *dev = psp->dev;
> +       struct psp_tee_device *tee;
> +       int ret;
> +
> +       ret = -ENOMEM;
> +       tee = devm_kzalloc(dev, sizeof(*tee), GFP_KERNEL);
> +       if (!tee)
> +               goto e_err;
> +
> +       psp->tee_data = tee;
> +
> +       tee->dev = dev;
> +       tee->psp = psp;
> +
> +       tee->io_regs = psp->io_regs;
> +
> +       tee->vdata = (struct tee_vdata *)psp->vdata->tee;
> +       if (!tee->vdata) {
> +               ret = -ENODEV;
> +               dev_err(dev, "tee: missing driver data\n");
> +               goto e_err;
> +       }
> +
> +       ret = tee_init_ring(tee);
> +       if (ret) {
> +               dev_err(dev, "tee: failed to init ring buffer\n");
> +               goto e_err;
> +       }
> +
> +       dev_notice(dev, "tee enabled\n");
> +
> +       return 0;
> +
> +e_err:
> +       psp->tee_data = NULL;
> +
> +       dev_notice(dev, "tee initialization failed\n");
> +
> +       return ret;
> +}
> +
> +void tee_dev_destroy(struct psp_device *psp)
> +{
> +       struct psp_tee_device *tee = psp->tee_data;
> +
> +       if (!tee)
> +               return;
> +
> +       tee_destroy_ring(tee);
> +}
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> new file mode 100644
> index 0000000..0d51a0a7
> --- /dev/null
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -0,0 +1,108 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + *
> + * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
> + *
> + */
> +
> +/* This file describes the TEE communication interface between host and AMD
> + * Secure Processor
> + */
> +
> +#ifndef __TEE_DEV_H__
> +#define __TEE_DEV_H__
> +
> +#include <linux/device.h>
> +#include <linux/mutex.h>
> +
> +#define TEE_DEFAULT_TIMEOUT            10
> +#define MAX_BUFFER_SIZE                        992
> +
> +/**
> + * enum tee_ring_cmd_id - TEE interface commands for ring buffer configuration
> + * @TEE_RING_INIT_CMD:         Initialize ring buffer
> + * @TEE_RING_DESTROY_CMD:      Destroy ring buffer
> + * @TEE_RING_MAX_CMD:          Maximum command id
> + */
> +enum tee_ring_cmd_id {
> +       TEE_RING_INIT_CMD               = 0x00010000,
> +       TEE_RING_DESTROY_CMD            = 0x00020000,
> +       TEE_RING_MAX_CMD                = 0x000F0000,
> +};
> +
> +/**
> + * struct tee_init_ring_cmd - Command to init TEE ring buffer
> + * @low_addr:  bits [31:0] of the physical address of ring buffer
> + * @hi_addr:   bits [63:32] of the physical address of ring buffer
> + * @size:      size of ring buffer in bytes
> + */
> +struct tee_init_ring_cmd {
> +       u32 low_addr;
> +       u32 hi_addr;
> +       u32 size;
> +};
> +
> +#define MAX_RING_BUFFER_ENTRIES                32
> +
> +/**
> + * struct ring_buf_manager - Helper structure to manage ring buffer.
> + * @ring_start:  starting address of ring buffer
> + * @ring_size:   size of ring buffer in bytes
> + * @ring_pa:     physical address of ring buffer
> + * @wptr:        index to the last written entry in ring buffer
> + */
> +struct ring_buf_manager {
> +       void *ring_start;
> +       u32 ring_size;
> +       phys_addr_t ring_pa;
> +       u32 wptr;
> +};
> +
> +struct psp_tee_device {
> +       struct device *dev;
> +       struct psp_device *psp;
> +       void __iomem *io_regs;
> +       struct tee_vdata *vdata;
> +       struct ring_buf_manager rb_mgr;
> +};
> +
> +/**
> + * enum tee_cmd_state - TEE command states for the ring buffer interface
> + * @TEE_CMD_STATE_INIT:      initial state of command when sent from host
> + * @TEE_CMD_STATE_PROCESS:   command being processed by TEE environment
> + * @TEE_CMD_STATE_COMPLETED: command processing completed
> + */
> +enum tee_cmd_state {
> +       TEE_CMD_STATE_INIT,
> +       TEE_CMD_STATE_PROCESS,
> +       TEE_CMD_STATE_COMPLETED,
> +};
> +
> +/**
> + * struct tee_ring_cmd - Structure of the command buffer in TEE ring
> + * @cmd_id:      refers to &enum tee_cmd_id. Command id for the ring buffer
> + *               interface
> + * @cmd_state:   refers to &enum tee_cmd_state
> + * @status:      status of TEE command execution
> + * @res0:        reserved region
> + * @pdata:       private data (currently unused)
> + * @res1:        reserved region
> + * @buf:         TEE command specific buffer
> + */
> +struct tee_ring_cmd {
> +       u32 cmd_id;
> +       u32 cmd_state;
> +       u32 status;
> +       u32 res0[1];
> +       u64 pdata;
> +       u32 res1[2];
> +       u8 buf[MAX_BUFFER_SIZE];
> +
> +       /* Total size: 1024 bytes */
> +} __packed;
> +
> +int tee_dev_init(struct psp_device *psp);
> +void tee_dev_destroy(struct psp_device *psp);
> +
> +#endif /* __TEE_DEV_H__ */
> --
> 1.9.1
>
