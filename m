From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v4 05/29] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Fri, 29 Sep 2017 17:16:07 +0200
Message-ID: <20170929151607.zn4lmdkyn25sczfg@pd.tnic>
References: <20170919204627.3875-1-brijesh.singh@amd.com>
 <20170919204627.3875-6-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55203 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752092AbdI2PQY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 11:16:24 -0400
Content-Disposition: inline
In-Reply-To: <20170919204627.3875-6-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 19, 2017 at 03:46:03PM -0500, Brijesh Singh wrote:
> Platform Security Processor (PSP) is part of AMD Secure Processor (AMD-SP),

The Platform...

> PSP is a dedicated processor that provides the support for key management
> commands in a Secure Encrypted Virtualiztion (SEV) mode, along with

Virtualization

Is integrating that spellchecker hard? Because what I do, for example,
is press F7 in vim when I've written the commit message. And F7 is
mapped to:

map <F7> :set spell! spelllang=en_us spellfile=~/.vim/spellfile.add<CR><Bar>:echo "spellcheck: " . strpart("offon", 3 * &spell, 3)<CR>

in my .vimrc

And I'm pretty sure you can do a similar thing with other editors.

> software-based Trusted Executation Environment (TEE) to enable the
> third-party trusted applications.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/Kconfig   |  11 +++++
>  drivers/crypto/ccp/Makefile  |   1 +
>  drivers/crypto/ccp/psp-dev.c | 111 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  61 ++++++++++++++++++++++++
>  drivers/crypto/ccp/sp-dev.c  |  32 +++++++++++++
>  drivers/crypto/ccp/sp-dev.h  |  27 ++++++++++-
>  drivers/crypto/ccp/sp-pci.c  |  46 ++++++++++++++++++
>  7 files changed, 288 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/ccp/psp-dev.c
>  create mode 100644 drivers/crypto/ccp/psp-dev.h
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 6d626606b9c5..1d927e13bf31 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -32,3 +32,14 @@ config CRYPTO_DEV_CCP_CRYPTO
>  	  Support for using the cryptographic API with the AMD Cryptographic
>  	  Coprocessor. This module supports offload of SHA and AES algorithms.
>  	  If you choose 'M' here, this module will be called ccp_crypto.
> +
> +config CRYPTO_DEV_SP_PSP
> +	bool "Platform Security Processor (PSP) device"
> +	default y
> +	depends on CRYPTO_DEV_CCP_DD

So this last symbol CRYPTO_DEV_CCP_DD is default m and it doesn't depend
on anything. And I'm pretty sure it should depend on CPU_SUP_AMD as this
is AMD-specific hw. You can add that dependency in a prepatch.

And what happened to adding dependencies on CONFIG_KVM_AMD? Or can you
use the PSP without virtualization in any sensible way?

> +	help
> +	 Provide the support for AMD Platform Security Processor (PSP). PSP is

			... for the AMD ... 				The PSP ... 

> +	 a dedicated processor that provides the support for key management

				that provides support for

> +	 commands in in a Secure Encrypted Virtualiztion (SEV) mode, along with

		... in Secure Encrypted Virtualization

> +	 software-based Trusted Executation Environment (TEE) to enable the
> +	 third-party trusted applications.
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 57f8debfcfb3..008bae7e26ec 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -7,6 +7,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
>  	    ccp-dmaengine.o \
>  	    ccp-debugfs.o
>  ccp-$(CONFIG_PCI) += sp-pci.o
> +ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o
>  
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> new file mode 100644
> index 000000000000..e60e53272e71
> --- /dev/null
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -0,0 +1,111 @@
> +/*
> + * AMD Platform Security Processor (PSP) interface
> + *
> + * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/kthread.h>
> +#include <linux/sched.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/spinlock_types.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +#include <linux/hw_random.h>
> +#include <linux/ccp.h>
> +
> +#include "sp-dev.h"
> +#include "psp-dev.h"
> +
> +const struct psp_vdata psp_entry = {
> +	.offset = 0x10500,
> +};
> +
> +static struct psp_device *psp_alloc_struct(struct sp_device *sp)
> +{
> +	struct device *dev = sp->dev;
> +	struct psp_device *psp;
> +
> +	psp = devm_kzalloc(dev, sizeof(*psp), GFP_KERNEL);
> +	if (!psp)
> +		return NULL;
> +
> +	psp->dev = dev;
> +	psp->sp = sp;
> +
> +	snprintf(psp->name, sizeof(psp->name), "psp-%u", sp->ord);
> +
> +	return psp;
> +}
> +
> +irqreturn_t psp_irq_handler(int irq, void *data)

Not static because... ?

> +{
> +	return IRQ_HANDLED;
> +}
> +
> +int psp_dev_init(struct sp_device *sp)
> +{
> +	struct device *dev = sp->dev;
> +	struct psp_device *psp;
> +	int ret;
> +
> +	ret = -ENOMEM;
> +	psp = psp_alloc_struct(sp);
> +	if (!psp)
> +		goto e_err;

<---- newline here. I already pointed this out last time. Please be more
careful when incorporating feedback. This is not the first time I'm
writing this. :-\

> +	sp->psp_data = psp;
> +
> +	psp->vdata = (struct psp_vdata *)sp->dev_vdata->psp_vdata;
> +	if (!psp->vdata) {
> +		ret = -ENODEV;
> +		dev_err(dev, "missing driver data\n");
> +		goto e_err;
> +	}
> +
> +	psp->io_regs = sp->io_map + psp->vdata->offset;
> +
> +	/* Disable and clear interrupts until ready */
> +	iowrite32(0, psp->io_regs + PSP_P2CMSG_INTEN);
> +	iowrite32(-1, psp->io_regs + PSP_P2CMSG_INTSTS);
> +
> +	dev_dbg(dev, "requesting an IRQ ...\n");
> +	/* Request an irq */
> +	ret = sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
> +	if (ret) {
> +		dev_err(dev, "psp: unable to allocate an IRQ\n");
> +		goto e_err;
> +	}
> +
> +	sp_set_psp_master(sp);

>From last review:

> So this function is called only once and declared somewhere else. You
> could simply do here:
>
>          if (sp->set_psp_master_device)
>                  sp->set_psp_master_device(sp);
>
> and get rid of one more global function.

and you said:

> Sure I can do that.

> +
> +	/* Enable interrupt */
> +	dev_dbg(dev, "Enabling interrupts ...\n");

That statement is superfluous...

> +	iowrite32(7, psp->io_regs + PSP_P2CMSG_INTEN);
> +
> +	dev_notice(dev, "psp enabled\n");

... as this will issue anyway and there are no conditional code paths
in-between.

> +
> +	return 0;
> +
> +e_err:
> +	sp->psp_data = NULL;
> +
> +	dev_notice(dev, "psp initialization failed\n");
> +
> +	return ret;
> +}
> +
> +void psp_dev_destroy(struct sp_device *sp)
> +{
> +	struct psp_device *psp = sp->psp_data;
> +
> +	sp_free_psp_irq(sp, psp);
> +}

So I'm going to stop right here. Please go over

https://lkml.kernel.org/r/20170907142737.g4aot7xatyopdfwp@pd.tnic

make sure you've addressed *every* piece of feedback and then send me a
v4.1 for review.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
