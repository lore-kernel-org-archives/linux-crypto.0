From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 02/26] crypto: ccp: Add Platform Security
 Processor (PSP) device support
Date: Thu, 7 Sep 2017 16:27:37 +0200
Message-ID: <20170907142737.g4aot7xatyopdfwp@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-3-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?XCJSYWRpbSBLcsSNbcOhxZlcIg==?= <rkrcmar@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724200303.12197-3-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jul 24, 2017 at 03:02:39PM -0500, Brijesh Singh wrote:
> Platform Security Processor (PSP) is part of AMD Secure Processor (AMD-SP),
> PSP is a dedicated processor that provides the support for key management
> commands in a Secure Encrypted Virtualiztion (SEV) mode, along with
> software-based Tursted Executation Environment (TEE) to enable the
		 ^^^^^^^^^^^^^^^^^^^

> third-party tursted applications.
	      ^^^^^^^

Spellcheck pls.

> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/Kconfig   |   9 ++
>  drivers/crypto/ccp/Makefile  |   1 +
>  drivers/crypto/ccp/psp-dev.c | 226 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  82 ++++++++++++++++
>  drivers/crypto/ccp/sp-dev.c  |  43 ++++++++
>  drivers/crypto/ccp/sp-dev.h  |  41 +++++++-
>  drivers/crypto/ccp/sp-pci.c  |  46 +++++++++
>  7 files changed, 447 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/ccp/psp-dev.c
>  create mode 100644 drivers/crypto/ccp/psp-dev.h
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 15b63fd..41c0ff5 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -31,3 +31,12 @@ config CRYPTO_DEV_CCP_CRYPTO
>  	  Support for using the cryptographic API with the AMD Cryptographic
>  	  Coprocessor. This module supports offload of SHA and AES algorithms.
>  	  If you choose 'M' here, this module will be called ccp_crypto.
> +
> +config CRYPTO_DEV_SP_PSP
> +	bool "Platform Security Processor device"
> +	default y
> +	depends on CRYPTO_DEV_CCP_DD
> +	help
> +	 Provide the support for AMD Platform Security Processor (PSP) device
> +	 which can be used for communicating with Secure Encryption Virtualization
> +	 (SEV) firmware.

The commit message above reads better to me as the help text than what
you have here.

Also, in order to make it easier for the user, I think we'll need a
CONFIG_AMD_MEM_ENCRYPT_SEV or so and make that depend on CONFIG_KVM_AMD,
this above and all the other pieces that are needed. Just so that when
the user builds such a kernel, all is enabled and not her having to go
look for what else is needed.

And then put the sev code behind that config option. Depending on how
ugly it gets...


> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 5f2adc5..8aae4ff 100644
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
> index 0000000..bb0ea9a
> --- /dev/null
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -0,0 +1,226 @@
> +/*
> + * AMD Platform Security Processor (PSP) interface
> + *
> + * Copyright (C) 2016 Advanced Micro Devices, Inc.
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
> +static LIST_HEAD(psp_devs);
> +static DEFINE_SPINLOCK(psp_devs_lock);
> +
> +const struct psp_vdata psp_entry = {
> +	.offset = 0x10500,
> +};
> +
> +void psp_add_device(struct psp_device *psp)

That function is needlessly global and should be static, AFAICT.

Better yet, it is called only once and its body is trivial so you can
completely get rid of it and meld it into the callsite.

> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&psp_devs_lock, flags);
> +
> +	list_add_tail(&psp->entry, &psp_devs);
> +
> +	spin_unlock_irqrestore(&psp_devs_lock, flags);
> +}
> +
> +void psp_del_device(struct psp_device *psp)

Ditto.

> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&psp_devs_lock, flags);
> +
> +	list_del(&psp->entry);
> +	spin_unlock_irqrestore(&psp_devs_lock, flags);
> +}
> +
> +static struct psp_device *psp_alloc_struct(struct sp_device *sp)

"psp_alloc()" is enough I guess.

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

static.

Please audit all your functions in the psp pile and make them static if
not needed outside of their compilation unit.

> +{
> +	unsigned int status;
> +	irqreturn_t ret = IRQ_HANDLED;
> +	struct psp_device *psp = data;

Please sort function local variables declaration in a reverse christmas
tree order:

	<type> longest_variable_name;
	<type> shorter_var_name;
	<type> even_shorter;
	<type> i;

> +
> +	/* read the interrupt status */
> +	status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
> +
> +	/* invoke subdevice interrupt handlers */
> +	if (status) {
> +		if (psp->sev_irq_handler)
> +			ret = psp->sev_irq_handler(irq, psp->sev_irq_data);
> +		if (psp->tee_irq_handler)
> +			ret = psp->tee_irq_handler(irq, psp->tee_irq_data);
> +	}
> +
> +	/* clear the interrupt status */
> +	iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);

We're clearing the status by writing the same value back?!? Shouldn't
that be:

	iowrite32(0, psp->io_regs + PSP_P2CMSG_INTSTS);

Below I see

	iowrite32(0xffffffff, psp->io_regs + PSP_P2CMSG_INTSTS);

which is supposed to clear IRQs. Btw, you can write that:

	iowrite32(-1, psp->io_regs + PSP_P2CMSG_INTSTS);

> +
> +	return ret;
> +}
> +
> +static int psp_init(struct psp_device *psp)
> +{
> +	psp_add_device(psp);
> +
> +	return 0;
> +}

A function which should be returning void.

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

<---- newline here.

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
> +	iowrite32(0xffffffff, psp->io_regs + PSP_P2CMSG_INTSTS);
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

So this function is called only once and declared somewhere else. You
could simply do here:

        if (sp->set_psp_master_device)
                sp->set_psp_master_device(sp);

and get rid of one more global function.

> +
> +	dev_dbg(dev, "initializing psp\n");
> +	ret = psp_init(psp);
> +	if (ret) {
> +		dev_err(dev, "failed to init psp\n");
> +		goto e_irq;
> +	}

That error handling will never execute. Thus the e_irq label is not
needed too.

> +
> +	/* Enable interrupt */
> +	dev_dbg(dev, "Enabling interrupts ...\n");
> +	iowrite32(7, psp->io_regs + PSP_P2CMSG_INTEN);

Uh, a magic "7"! Exciting!

I wonder what that means and whether it could be a define with an
explanatory name instead. Ditto for the other values...

> +
> +	dev_notice(dev, "psp enabled\n");
> +
> +	return 0;
> +
> +e_irq:
> +	sp_free_psp_irq(psp->sp, psp);
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
> +
> +	psp_del_device(psp);
> +}
> +
> +int psp_dev_resume(struct sp_device *sp)
> +{
> +	return 0;
> +}
> +
> +int psp_dev_suspend(struct sp_device *sp, pm_message_t state)
> +{
> +	return 0;
> +}

Those last two are completely useless. Delete them pls.

> +
> +int psp_request_tee_irq(struct psp_device *psp, irq_handler_t handler,
> +			void *data)
> +{
> +	psp->tee_irq_data = data;
> +	psp->tee_irq_handler = handler;
> +
> +	return 0;
> +}

void

> +
> +int psp_free_tee_irq(struct psp_device *psp, void *data)
> +{
> +	if (psp->tee_irq_handler) {
> +		psp->tee_irq_data = NULL;
> +		psp->tee_irq_handler = NULL;
> +	}
> +
> +	return 0;
> +}

void

> +
> +int psp_request_sev_irq(struct psp_device *psp, irq_handler_t handler,
> +			void *data)
> +{
> +	psp->sev_irq_data = data;
> +	psp->sev_irq_handler = handler;
> +
> +	return 0;
> +}
> +
> +int psp_free_sev_irq(struct psp_device *psp, void *data)
> +{
> +	if (psp->sev_irq_handler) {
> +		psp->sev_irq_data = NULL;
> +		psp->sev_irq_handler = NULL;
> +	}
> +
> +	return 0;
> +}

Both void. Please do not return values from functions which are simply
void functions by design.

> +
> +struct psp_device *psp_get_master_device(void)
> +{
> +	struct sp_device *sp = sp_get_psp_master_device();
> +
> +	return sp ? sp->psp_data : NULL;
> +}
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> new file mode 100644
> index 0000000..6e167b8
> --- /dev/null
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -0,0 +1,82 @@
> +/*
> + * AMD Platform Security Processor (PSP) interface driver
> + *
> + * Copyright (C) 2017 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __PSP_DEV_H__
> +#define __PSP_DEV_H__
> +
> +#include <linux/device.h>
> +#include <linux/pci.h>
> +#include <linux/spinlock.h>
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/wait.h>
> +#include <linux/dmapool.h>
> +#include <linux/hw_random.h>
> +#include <linux/bitops.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqreturn.h>
> +#include <linux/dmaengine.h>
> +
> +#include "sp-dev.h"
> +
> +#define PSP_P2CMSG_INTEN		0x0110
> +#define PSP_P2CMSG_INTSTS		0x0114
> +
> +#define PSP_C2PMSG_ATTR_0		0x0118
> +#define PSP_C2PMSG_ATTR_1		0x011c
> +#define PSP_C2PMSG_ATTR_2		0x0120
> +#define PSP_C2PMSG_ATTR_3		0x0124
> +#define PSP_P2CMSG_ATTR_0		0x0128
> +
> +#define PSP_CMDRESP_CMD_SHIFT		16
> +#define PSP_CMDRESP_IOC			BIT(0)
> +#define PSP_CMDRESP_RESP		BIT(31)
> +#define PSP_CMDRESP_ERR_MASK		0xffff
> +
> +#define MAX_PSP_NAME_LEN		16
> +
> +struct psp_device {
> +	struct list_head entry;
> +
> +	struct psp_vdata *vdata;
> +	char name[MAX_PSP_NAME_LEN];
> +
> +	struct device *dev;
> +	struct sp_device *sp;
> +
> +	void __iomem *io_regs;
> +
> +	irq_handler_t sev_irq_handler;
> +	void *sev_irq_data;
> +	irq_handler_t tee_irq_handler;
> +	void *tee_irq_data;
> +
> +	void *sev_data;
> +	void *tee_data;
> +};
> +
> +void psp_add_device(struct psp_device *psp);
> +void psp_del_device(struct psp_device *psp);
> +
> +int psp_request_sev_irq(struct psp_device *psp, irq_handler_t handler,
> +			void *data);
> +int psp_free_sev_irq(struct psp_device *psp, void *data);
> +
> +int psp_request_tee_irq(struct psp_device *psp, irq_handler_t handler,
> +			void *data);

Let them stick out.

> +int psp_free_tee_irq(struct psp_device *psp, void *data);
> +
> +struct psp_device *psp_get_master_device(void);
> +
> +extern const struct psp_vdata psp_entry;
> +
> +#endif /* __PSP_DEV_H */
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c

So this file is called sp-dev and the other psp-dev. Confusing.

And in general, why isn't the whole thing a single psp-dev and you can
save yourself all the registering blabla and have a single driver for
the whole PSP functionality?

Distros will have to enable everything anyway and the whole CCP/PSP code
is only a couple of KBs so you can just as well put it all into a single
driver. Hm.

> @@ -102,6 +113,8 @@ void sp_free_ccp_irq(struct sp_device *sp, void *data);
>  int sp_request_psp_irq(struct sp_device *sp, irq_handler_t handler,
>  		       const char *name, void *data);
>  void sp_free_psp_irq(struct sp_device *sp, void *data);
> +void sp_set_psp_master(struct sp_device *sp);
> +struct sp_device *sp_get_psp_master_device(void);
>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_CCP
>  
> @@ -129,4 +142,30 @@ static inline int ccp_dev_resume(struct sp_device *sp)
>  }
>  #endif	/* CONFIG_CRYPTO_DEV_SP_CCP */
>  
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +
> +int psp_dev_init(struct sp_device *sp);
> +void psp_dev_destroy(struct sp_device *sp);
> +
> +int psp_dev_suspend(struct sp_device *sp, pm_message_t state);
> +int psp_dev_resume(struct sp_device *sp);
> +#else /* !CONFIG_CRYPTO_DEV_SP_PSP */
> +
> +static inline int psp_dev_init(struct sp_device *sp)
> +{
> +	return 0;
> +}
> +static inline void psp_dev_destroy(struct sp_device *sp) { }
> +
> +static inline int psp_dev_suspend(struct sp_device *sp, pm_message_t state)
> +{
> +	return 0;
> +}
> +static inline int psp_dev_resume(struct sp_device *sp)
> +{
> +	return 0;
> +}

Put them on a single line:

static inline int psp_dev_resume(struct sp_device *sp) 		{  return 0; }

and so on... Do that for the rest of the function stubs in the headers pls.

Thx.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
