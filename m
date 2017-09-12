From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC Part2 PATCH v3 03/26] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) device support
Date: Tue, 12 Sep 2017 16:02:50 +0200
Message-ID: <20170912140249.f26w5xedbrqu52i4@pd.tnic>
References: <20170724200303.12197-1-brijesh.singh@amd.com>
 <20170724200303.12197-4-brijesh.singh@amd.com>
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
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170724200303.12197-4-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Just a cursory review: more indepth after the redesign.

On Mon, Jul 24, 2017 at 03:02:40PM -0500, Brijesh Singh wrote:
> AMDs new Secure Encrypted Virtualization (SEV) feature allows the memory
> contents of a virtual machine to be transparently encrypted with a key
> unique to the guest VM. The programming and management of the encryption
> keys are handled by the AMD Secure Processor (AMD-SP), which exposes the
> commands for these tasks. The complete spec for various commands are

s/ for various commands are/is/

> available at:
> http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
> 
> This patch extends AMD-SP driver to provide:

Never say "This patch" in a commit message of a patch. It is
tautologically useless.

>  - a in-kernel APIs to communicate with SEV device. The APIs can be used

s/a/an/				     with a SEV ...

>    by the hypervisor to create encryption context for the SEV guests.
> 
>  - a userspace IOCTL to manage the platform certificates etc
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Gary Hook <gary.hook@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  drivers/crypto/ccp/Kconfig   |  10 +
>  drivers/crypto/ccp/Makefile  |   1 +
>  drivers/crypto/ccp/psp-dev.c |   4 +
>  drivers/crypto/ccp/psp-dev.h |  27 ++
>  drivers/crypto/ccp/sev-dev.c | 416 ++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  67 +++++
>  drivers/crypto/ccp/sev-ops.c | 457 +++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sp-pci.c  |   2 +-
>  include/linux/psp-sev.h      | 683 +++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/psp-sev.h | 110 +++++++
>  10 files changed, 1776 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/ccp/sev-dev.c
>  create mode 100644 drivers/crypto/ccp/sev-dev.h
>  create mode 100644 drivers/crypto/ccp/sev-ops.c
>  create mode 100644 include/linux/psp-sev.h
>  create mode 100644 include/uapi/linux/psp-sev.h
> 
> diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
> index 41c0ff5..ae0ff1c 100644
> --- a/drivers/crypto/ccp/Kconfig
> +++ b/drivers/crypto/ccp/Kconfig
> @@ -40,3 +40,13 @@ config CRYPTO_DEV_SP_PSP
>  	 Provide the support for AMD Platform Security Processor (PSP) device
>  	 which can be used for communicating with Secure Encryption Virtualization
>  	 (SEV) firmware.
> +
> +config CRYPTO_DEV_PSP_SEV
> +	bool "Secure Encrypted Virtualization (SEV) interface"
> +	default y
> +	depends on CRYPTO_DEV_CCP_DD
> +	depends on CRYPTO_DEV_SP_PSP
> +	help
> +	 Provide the kernel and userspace (/dev/sev) interface to communicate with
> +	 Secure Encrypted Virtualization (SEV) firmware running inside AMD Platform
> +	 Security Processor (PSP)
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 8aae4ff..94ca748 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -8,6 +8,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
>  	    ccp-debugfs.o
>  ccp-$(CONFIG_PCI) += sp-pci.o
>  ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o
> +ccp-$(CONFIG_CRYPTO_DEV_PSP_SEV) += sev-dev.o sev-ops.o
>  
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index bb0ea9a..0c9d25c 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -97,6 +97,7 @@ irqreturn_t psp_irq_handler(int irq, void *data)
>  static int psp_init(struct psp_device *psp)
>  {
>  	psp_add_device(psp);
> +	sev_dev_init(psp);
>  
>  	return 0;
>  }
> @@ -166,17 +167,20 @@ void psp_dev_destroy(struct sp_device *sp)
>  	struct psp_device *psp = sp->psp_data;
>  
>  	sp_free_psp_irq(sp, psp);
> +	sev_dev_destroy(psp);
>  
>  	psp_del_device(psp);
>  }
>  
>  int psp_dev_resume(struct sp_device *sp)
>  {
> +	sev_dev_resume(sp->psp_data);
>  	return 0;
>  }
>  
>  int psp_dev_suspend(struct sp_device *sp, pm_message_t state)
>  {
> +	sev_dev_suspend(sp->psp_data, state);
>  	return 0;
>  }
>  
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> index 6e167b8..9334d87 100644
> --- a/drivers/crypto/ccp/psp-dev.h
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -78,5 +78,32 @@ int psp_free_tee_irq(struct psp_device *psp, void *data);
>  struct psp_device *psp_get_master_device(void);
>  
>  extern const struct psp_vdata psp_entry;
> +#ifdef CONFIG_CRYPTO_DEV_PSP_SEV
> +
> +int sev_dev_init(struct psp_device *psp);
> +void sev_dev_destroy(struct psp_device *psp);
> +int sev_dev_resume(struct psp_device *psp);
> +int sev_dev_suspend(struct psp_device *psp, pm_message_t state);
> +
> +#else /* !CONFIG_CRYPTO_DEV_PSP_SEV */
> +
> +static inline int sev_dev_init(struct psp_device *psp)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline void sev_dev_destroy(struct psp_device *psp) { }
> +
> +static inline int sev_dev_resume(struct psp_device *psp)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline int sev_dev_suspend(struct psp_device *psp, pm_message_t state)
> +{
> +	return -ENODEV;
> +}
> +
> +#endif /* CONFIG_CRYPTO_DEV_PSP_SEV */
>  
>  #endif /* __PSP_DEV_H */
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> new file mode 100644
> index 0000000..a2b41dd
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -0,0 +1,416 @@
> +/*
> + * AMD Secure Encrypted Virtualization (SEV) interface
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
> +#include <linux/wait.h>
> +#include <linux/jiffies.h>
> +
> +#include "psp-dev.h"
> +#include "sev-dev.h"
> +
> +extern const struct file_operations sev_fops;
> +
> +static LIST_HEAD(sev_devs);
> +static DEFINE_SPINLOCK(sev_devs_lock);
> +static atomic_t sev_id;
> +
> +static unsigned int sev_poll;
> +module_param(sev_poll, uint, 0444);
> +MODULE_PARM_DESC(sev_poll, "Poll for sev command completion - any non-zero value");
> +
> +DEFINE_MUTEX(sev_cmd_mutex);

Please audit all those drivers after you redesign them and check for
variables and functions which are not static but used in a single
compilation unit. Like this one, for example.

<... skipping over the rest, will look at it in the next version ...>

...

> +static int sev_cmd_buffer_len(int cmd)
> +{
> +	int size;
> +
> +	switch (cmd) {
> +	case SEV_CMD_INIT:
> +		size = sizeof(struct sev_data_init);
> +		break;

You could make that more tabular like this:

        case SEV_CMD_INIT:              return sizeof(struct sev_data_init);
        case SEV_CMD_PLATFORM_STATUS:   return sizeof(struct sev_data_status);
        case SEV_CMD_PEK_CSR:           return sizeof(struct sev_data_pek_csr);
	...

which should make it more readable.

But looking at this more, this is a static mapping between the commands
and the corresponding struct sizes and you use it in

        print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
                        sev_cmd_buffer_len(cmd), false);

But then, I don't see what that brings you because you're not dumping
the actual @data length but the *expected* data length based on the
command type.

And *that* you can look up in the manual and do not need it in code,
enlarging the driver unnecessarily.

...

> +int sev_platform_init(struct sev_data_init *data, int *error)
> +{
> +       return sev_issue_cmd(SEV_CMD_INIT, data, error);
> +}
> +EXPORT_SYMBOL_GPL(sev_platform_init);
> +
> +int sev_platform_shutdown(int *error)
> +{
> +       return sev_issue_cmd(SEV_CMD_SHUTDOWN, 0, error);
> +}
> +EXPORT_SYMBOL_GPL(sev_platform_shutdown);

All those could be static inlines in a header instead of separate
symbols.

> +int sev_issue_cmd(int cmd, void *data, int *psp_ret)
> +{
> +	struct sev_device *sev = get_sev_master_device();
> +	unsigned int phys_lsb, phys_msb;
> +	unsigned int reg, ret;
> +
> +	if (!sev)
> +		return -ENODEV;
> +
> +	if (psp_ret)
> +		*psp_ret = 0;
> +
> +	/* Set the physical address for the PSP */
> +	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
> +	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
> +
> +	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x\n",
> +			cmd, phys_msb, phys_lsb);
> +	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +			sev_cmd_buffer_len(cmd), false);
> +
> +	/* Only one command at a time... */
> +	mutex_lock(&sev_cmd_mutex);
> +
> +	iowrite32(phys_lsb, sev->io_regs + PSP_CMDBUFF_ADDR_LO);
> +	iowrite32(phys_msb, sev->io_regs + PSP_CMDBUFF_ADDR_HI);
> +	wmb();

WARNING: memory barrier without comment
#503: FILE: drivers/crypto/ccp/sev-dev.c:339:
+       wmb();

Again:

Please integrate scripts/checkpatch.pl into your patch creation
workflow. Some of the warnings/errors *actually* make sense.

> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> new file mode 100644
> index 0000000..0a8ce08
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -0,0 +1,67 @@
> +/*
> + * AMD Secure Encrypted Virtualization (SEV) interface
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
> +#ifndef __SEV_DEV_H__
> +#define __SEV_DEV_H__
> +
> +#include <linux/device.h>
> +#include <linux/spinlock.h>
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/wait.h>
> +#include <linux/interrupt.h>
> +#include <linux/irqreturn.h>
> +#include <linux/miscdevice.h>
> +
> +#include <linux/psp-sev.h>
> +
> +#define PSP_C2PMSG(_num)		((_num) << 2)
> +#define PSP_CMDRESP			PSP_C2PMSG(32)
> +#define PSP_CMDBUFF_ADDR_LO		PSP_C2PMSG(56)
> +#define PSP_CMDBUFF_ADDR_HI             PSP_C2PMSG(57)
> +#define PSP_FEATURE_REG			PSP_C2PMSG(63)
> +
> +#define PSP_P2CMSG(_num)		(_num << 2)
> +#define PSP_CMD_COMPLETE_REG		1
> +#define PSP_CMD_COMPLETE		PSP_P2CMSG(PSP_CMD_COMPLETE_REG)
> +
> +#define MAX_PSP_NAME_LEN		16
> +#define SEV_DEFAULT_TIMEOUT		5
> +
> +struct sev_device {
> +	struct list_head entry;
> +
> +	struct dentry *debugfs;
> +	struct miscdevice misc;
> +
> +	unsigned int id;
> +	char name[MAX_PSP_NAME_LEN];
> +
> +	struct device *dev;
> +	struct sp_device *sp;
> +	struct psp_device *psp;
> +
> +	void __iomem *io_regs;
> +
> +	unsigned int int_rcvd;
> +	wait_queue_head_t int_queue;
> +};
> +
> +void sev_add_device(struct sev_device *sev);
> +void sev_del_device(struct sev_device *sev);
> +
> +int sev_ops_init(struct sev_device *sev);
> +void sev_ops_destroy(struct sev_device *sev);
> +
> +int sev_issue_cmd(int cmd, void *data, int *error);
> +
> +#endif /* __SEV_DEV_H */
> diff --git a/drivers/crypto/ccp/sev-ops.c b/drivers/crypto/ccp/sev-ops.c
> new file mode 100644
> index 0000000..a13d857
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-ops.c
> @@ -0,0 +1,457 @@
> +/*
> + * AMD Secure Encrypted Virtualization (SEV) command interface
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
> +#include <linux/uaccess.h>
> +
> +#include <uapi/linux/psp-sev.h>
> +
> +#include "psp-dev.h"
> +#include "sev-dev.h"
> +
> +static bool sev_initialized;

Variables like this one are a good example that the design is not
optimal. sev-ops should all be in psp-dev and then you don't need all those
registrations and ops passing around and so on... But you get the idea...

> +static int sev_platform_get_state(int *state, int *error)
> +{
> +	int ret;
> +	struct sev_data_status *data;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	ret = sev_platform_status(data, error);
> +	*state = data->state;
> +
> +	kfree(data);
> +	return ret;
> +}
> +
> +static int __sev_platform_init(int *error)
> +{
> +	int ret;
> +	struct sev_data_init *data;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	ret = sev_platform_init(data, error);

It is usually the other way around: the function without the "__" calls
the "__" variant.

> +
> +	kfree(data);
> +	return ret;
> +}
> +
> +static int sev_ioctl_factory_reset(struct sev_issue_cmd *argp)
> +{
> +	return sev_issue_cmd(SEV_CMD_FACTORY_RESET, 0, &argp->error);
> +}

static inline in a header.

> +
> +static int sev_ioctl_platform_status(struct sev_issue_cmd *argp)
> +{
> +	int ret;
> +	struct sev_data_status *data;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	ret = sev_platform_status(data, &argp->error);
> +
> +	if (copy_to_user((void *)argp->data, data, sizeof(*data)))
> +		ret = -EFAULT;
> +
> +	kfree(data);
> +	return ret;
> +}
> +
> +static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
> +{
> +	int do_shutdown = 0;
> +	int ret, state, error;
> +	void *csr_addr = NULL;
> +	struct sev_data_pek_csr *data;
> +	struct sev_user_data_pek_csr input;
> +
> +	if (copy_from_user(&input, (void *)argp->data,
> +			sizeof(struct sev_user_data_pek_csr)))
> +		return -EFAULT;
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/*
> +	 * PEK_CSR command can be issued when firmware is in INIT or WORKING
> +	 * state. If firmware is in UNINIT state then we transition into INIT
> +	 * state and issue the command.
> +	 */
> +	ret = sev_platform_get_state(&state, &argp->error);
> +	if (ret)
> +		return ret;
> +
> +	if (state == SEV_STATE_UNINIT) {
> +		/* transition the plaform into INIT state */
> +		ret = __sev_platform_init(&argp->error);
> +		if (ret)
> +			return ret;
> +		do_shutdown = 1;
> +	}
> +
> +	if (input.address) {
> +		csr_addr = kmalloc(input.length, GFP_KERNEL);
> +		if (!csr_addr) {
> +			ret = -ENOMEM;
> +			goto e_free;
> +		}
> +		data->address = __psp_pa(csr_addr);
> +		data->length = input.length;
> +	}
> +
> +	ret = sev_issue_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
> +
> +	if (csr_addr) {
> +		if (copy_to_user((void *)input.address, csr_addr,
> +				input.length)) {
> +			ret = -EFAULT;
> +			goto e_free;
> +		}
> +	}
> +
> +	input.length = data->length;
> +	if (copy_to_user((void *)argp->data, &input,
> +			sizeof(struct sev_user_data_pek_csr)))
> +		ret = -EFAULT;
> +e_free:
> +	if (do_shutdown)
> +		sev_platform_shutdown(&error);

Who's looking at that error?

No one, AFAICT. It is a stack variable which gets destroyed after this
function returns. The other call sites look the same. Please fix.

> +	kfree(csr_addr);
> +	kfree(data);
> +	return ret;
> +}
> +
> +static int sev_ioctl_pdh_gen(struct sev_issue_cmd *argp)
> +{
> +	int ret, state, error, do_shutdown = 0;
> +
> +	/*
> +	 * PDH_GEN command can be issued when platform is in INIT or WORKING
> +	 * state. If we are in UNINIT state then transition into INIT.
> +	 */
> +	ret = sev_platform_get_state(&state, &argp->error);
> +	if (ret)
> +		return ret;
> +
> +	if (state == SEV_STATE_UNINIT) {
> +		/* transition the plaform into INIT state */
> +		ret = __sev_platform_init(&argp->error);
> +		if (ret)
> +			return ret;
> +		do_shutdown = 1;
> +	}
> +
> +	ret = sev_issue_cmd(SEV_CMD_PDH_GEN, 0,	&argp->error);
> +	if (do_shutdown)
> +		sev_platform_shutdown(&error);
> +	return ret;
> +}
> +
> +static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
> +{
> +	int do_shutdown = 0;
> +	int error, ret, state;
> +
> +	/*
> +	 * PEK_GEN command can be issued only when firmware is in INIT state.
> +	 * If firmware is in UNINIT state then we transition into INIT state
> +	 * and issue the command and then shutdown.
> +	 */
> +	ret = sev_platform_get_state(&state, &argp->error);
> +	if (ret)
> +		return ret;
> +
> +	if (state == SEV_STATE_UNINIT) {
> +		/* transition the plaform into INIT state */
> +		ret = __sev_platform_init(&argp->error);
> +		if (ret)
> +			return ret;
> +
> +		do_shutdown = 1;
> +	}
> +
> +	ret = sev_issue_cmd(SEV_CMD_PEK_GEN, 0,	&argp->error);
> +
> +	if (do_shutdown)
> +		sev_platform_shutdown(&error);
> +	return ret;
> +}
> +
> +static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
> +{
> +	int ret, state, error, do_shutdown = 0;
> +	struct sev_data_pek_cert_import *data;
> +	struct sev_user_data_pek_cert_import input;
> +	void *pek_cert = NULL, *oca_cert = NULL;
> +
> +	if (copy_from_user(&input, (void *)argp->data, sizeof(*data)))
> +		return -EFAULT;
> +
> +	if (!input.pek_cert_address || !input.pek_cert_length ||
> +		!input.oca_cert_address || !input.oca_cert_length)
> +		return -EINVAL;

Here and everywhere else: please audit all those copy_from_user() calls
for user-controlled fields and the such and conservatively sanity-check
them. ou don't want to have security bugs in this driver!

You need to massage all those user values into sanity.

> +	ret = sev_platform_get_state(&state, &argp->error);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * CERT_IMPORT command can be issued only when platform is in INIT
> +	 * state. If we are in UNINIT state then transition into INIT state
> +	 * and issue the command.
> +	 */
> +	if (state == SEV_STATE_UNINIT) {
> +		/* transition platform init INIT state */
> +		ret = __sev_platform_init(&argp->error);
> +		if (ret)
> +			return ret;
> +		do_shutdown = 1;
> +	}
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		ret = -ENOMEM;
> +		goto e_free;
> +	}
> +
> +	pek_cert = kmalloc(input.pek_cert_length, GFP_KERNEL);
> +	if (!pek_cert) {
> +		ret = -ENOMEM;
> +		goto e_free;
> +	}
> +
> +	/* copy PEK certificate from userspace */
> +	if (copy_from_user(pek_cert, (void *)input.pek_cert_address,
> +				input.pek_cert_length)) {
> +		ret = -EFAULT;
> +		goto e_free;
> +	}
> +
> +	data->pek_cert_address = __psp_pa(pek_cert);
> +	data->pek_cert_length = input.pek_cert_length;
> +
> +	oca_cert = kmalloc(input.oca_cert_length, GFP_KERNEL);

There's your first overrun: that oca_cert_length you copy from userspace
and check only if it is 0 but it can be huuge.

> +	if (!oca_cert) {
> +		ret = -ENOMEM;
> +		goto e_free;
> +	}
> +
> +	/* copy OCA certificate from userspace */
> +	if (copy_from_user(oca_cert, (void *)input.oca_cert_address,

... and here's the user-controlled address where you copy the exploit
code from. You need to revisit all those copy_from_user() calls and be
absolutely defensive here.

> +				input.oca_cert_length)) {
> +		ret = -EFAULT;
> +		goto e_free;
> +	}
> +
> +	data->oca_cert_address = __psp_pa(oca_cert);
> +	data->oca_cert_length = input.oca_cert_length;
> +
> +	ret = sev_issue_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
> +e_free:
> +	if (do_shutdown)
> +		sev_platform_shutdown(&error);
> +	kfree(oca_cert);
> +	kfree(pek_cert);
> +	kfree(data);
> +	return ret;
> +}
> +
> +static int sev_ioctl_pdh_cert_export(struct sev_issue_cmd *argp)
> +{
> +	int ret, state, error, need_shutdown = 0;
> +	struct sev_data_pdh_cert_export *data;
> +	struct sev_user_data_pdh_cert_export input;
> +	void *pdh_cert = NULL, *cert_chain = NULL;
> +
> +	if (copy_from_user(&input, (void *)argp->data, sizeof(*data)))
> +		return -EFAULT;
> +
> +	/*
> +	 * CERT_EXPORT command can be issued in INIT or WORKING state.
> +	 * If we are in UNINIT state then transition into INIT state and
> +	 * shutdown before exiting. But if platform is in WORKING state
> +	 * then EXPORT the certificate but do not shutdown the platform.
> +	 */
> +	ret = sev_platform_get_state(&state, &argp->error);
> +	if (ret)
> +		return ret;
> +
> +	if (state == SEV_STATE_UNINIT) {
> +		ret = __sev_platform_init(&argp->error);
> +		if (ret)
> +			return ret;
> +		need_shutdown = 1;
> +	}
> +
> +	data = kzalloc(sizeof(*data), GFP_KERNEL);
> +	if (!data) {
> +		ret = -ENOMEM;
> +		goto e_free;
> +	}
> +
> +	if (input.pdh_cert_address) {

Oh wow, so that address is absolutely unchecked.

> +		pdh_cert = kmalloc(input.pdh_cert_length, GFP_KERNEL);
> +		if (!pdh_cert) {
> +			ret = -ENOMEM;
> +			goto e_free;
> +		}
> +
> +		data->pdh_cert_address = __psp_pa(pdh_cert);
> +		data->pdh_cert_length = input.pdh_cert_length;
> +	}
> +
> +	if (input.cert_chain_address) {

Ditto.

And so on and so on...

> +		cert_chain = kmalloc(input.cert_chain_length, GFP_KERNEL);
> +		if (!cert_chain) {
> +			ret = -ENOMEM;
> +			goto e_free;
> +		}
> +
> +		data->cert_chain_address = __psp_pa(cert_chain);
> +		data->cert_chain_length = input.cert_chain_length;
> +	}
> +
> +	ret = sev_issue_cmd(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
> +
> +	input.cert_chain_length = data->cert_chain_length;
> +	input.pdh_cert_length = data->pdh_cert_length;
> +
> +	/* copy PDH certificate to userspace */
> +	if (pdh_cert) {
> +		if (copy_to_user((void *)input.pdh_cert_address,
> +				pdh_cert, input.pdh_cert_length)) {
> +			ret = -EFAULT;
> +			goto e_free;
> +		}
> +	}
> +
> +	/* copy certificate chain to userspace */
> +	if (cert_chain) {
> +		if (copy_to_user((void *)input.cert_chain_address,
> +				cert_chain, input.cert_chain_length)) {
> +			ret = -EFAULT;
> +			goto e_free;
> +		}
> +	}
> +
> +	/* copy certificate length to userspace */
> +	if (copy_to_user((void *)argp->data, &input,
> +			sizeof(struct sev_user_data_pdh_cert_export)))
> +		ret = -EFAULT;
> +
> +e_free:
> +	if (need_shutdown)
> +		sev_platform_shutdown(&error);
> +
> +	kfree(cert_chain);
> +	kfree(pdh_cert);
> +	kfree(data);
> +	return ret;
> +}
> +
> +static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
> +{
> +	int ret = -EFAULT;
> +	void __user *argp = (void __user *)arg;
> +	struct sev_issue_cmd input;
> +
> +	if (ioctl != SEV_ISSUE_CMD)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&input, argp, sizeof(struct sev_issue_cmd)))
> +		return -EFAULT;
> +
> +	if (input.cmd > SEV_CMD_MAX)
> +		return -EINVAL;
> +
> +	switch (input.cmd) {
> +
> +	case SEV_USER_CMD_FACTORY_RESET: {
> +		ret = sev_ioctl_factory_reset(&input);
> +		break;
> +	}
> +	case SEV_USER_CMD_PLATFORM_STATUS: {
> +		ret = sev_ioctl_platform_status(&input);
> +		break;
> +	}
> +	case SEV_USER_CMD_PEK_GEN: {
> +		ret = sev_ioctl_pek_gen(&input);
> +		break;
> +	}
> +	case SEV_USER_CMD_PDH_GEN: {
> +		ret = sev_ioctl_pdh_gen(&input);
> +		break;
> +	}
> +	case SEV_USER_CMD_PEK_CSR: {
> +		ret = sev_ioctl_pek_csr(&input);
> +		break;
> +	}
> +	case SEV_USER_CMD_PEK_CERT_IMPORT: {
> +		ret = sev_ioctl_pek_cert_import(&input);
> +		break;
> +	}
> +	case SEV_USER_CMD_PDH_CERT_EXPORT: {
> +		ret = sev_ioctl_pdh_cert_export(&input);
> +		break;
> +	}
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
> +		ret = -EFAULT;
> +
> +	return ret;
> +}
> +
> +const struct file_operations sev_fops = {
> +	.owner	= THIS_MODULE,
> +	.unlocked_ioctl = sev_ioctl,
> +};
> +
> +int sev_ops_init(struct sev_device *sev)
> +{
> +	struct miscdevice *misc = &sev->misc;
> +
> +	/* if sev device is already registered then do nothing */
> +	if (sev_initialized)
> +		return 0;
> +
> +	misc->minor = MISC_DYNAMIC_MINOR;
> +	misc->name = sev->name;
> +	misc->fops = &sev_fops;
> +	sev_initialized = true;
> +
> +	return misc_register(misc);
> +}
> +
> +void sev_ops_destroy(struct sev_device *sev)
> +{
> +	misc_deregister(&sev->misc);
> +}
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index e58b3ad..20a0f35 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -280,7 +280,7 @@ static const struct sp_dev_vdata dev_vdata[] = {
>  #ifdef CONFIG_CRYPTO_DEV_SP_CCP
>  		.ccp_vdata = &ccpv5a,
>  #endif
> -#ifdef CONFIG_CRYPTO_DEV_PSP
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  		.psp_vdata = &psp_entry
>  #endif
>  	},
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> new file mode 100644
> index 0000000..1736880
> --- /dev/null
> +++ b/include/linux/psp-sev.h
> @@ -0,0 +1,683 @@
> +/*
> + * AMD Secure Encrypted Virtualization (SEV) driver interface
> + *
> + * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

<--- you probably should have a reference to the document containing all
those commands, i.e.,

http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf

Also, for your next submission, please split this huuge patch. Those
definitions can go separately, for example.

> + */
> +
> +#ifndef __PSP_SEV_H__
> +#define __PSP_SEV_H__
> +
> +#ifdef CONFIG_X86
> +#include <linux/mem_encrypt.h>
> +
> +#define __psp_pa(x)	__sme_pa(x)
> +#else
> +#define __psp_pa(x)	__pa(x)
> +#endif
> +
> +/**
> + * SEV platform state
> + */
> +enum sev_state {
> +	SEV_STATE_UNINIT		= 0x0,
> +	SEV_STATE_INIT			= 0x1,
> +	SEV_STATE_WORKING		= 0x2,
> +
> +	SEV_STATE_MAX
> +};
> +
> +/**
> + * SEV platform and guest management commands
> + */
> +enum sev_cmd {
> +	/* platform commands */
> +	SEV_CMD_INIT			= 0x001,
> +	SEV_CMD_SHUTDOWN		= 0x002,
> +	SEV_CMD_FACTORY_RESET		= 0x003,
> +	SEV_CMD_PLATFORM_STATUS		= 0x004,
> +	SEV_CMD_PEK_GEN			= 0x005,
> +	SEV_CMD_PEK_CSR			= 0x006,
> +	SEV_CMD_PEK_CERT_IMPORT		= 0x007,
> +	SEV_CMD_PDH_CERT_EXPORT		= 0x008,
> +	SEV_CMD_PDH_GEN			= 0x009,
> +	SEV_CMD_DF_FLUSH		= 0x00A,
> +
> +	/* Guest commands */
> +	SEV_CMD_DECOMMISSION		= 0x020,
> +	SEV_CMD_ACTIVATE		= 0x021,
> +	SEV_CMD_DEACTIVATE		= 0x022,
> +	SEV_CMD_GUEST_STATUS		= 0x023,
> +
> +	/* Guest launch commands */
> +	SEV_CMD_LAUNCH_START		= 0x030,
> +	SEV_CMD_LAUNCH_UPDATE_DATA	= 0x031,
> +	SEV_CMD_LAUNCH_UPDATE_VMSA	= 0x032,
> +	SEV_CMD_LAUNCH_MEASURE		= 0x033,
> +	SEV_CMD_LAUNCH_UPDATE_SECRET	= 0x034,
> +	SEV_CMD_LAUNCH_FINISH		= 0x035,
> +
> +	/* Guest migration commands (outgoing) */
> +	SEV_CMD_SEND_START		= 0x040,
> +	SEV_CMD_SEND_UPDATE_DATA	= 0x041,
> +	SEV_CMD_SEND_UPDATE_VMSA	= 0x042,
> +	SEV_CMD_SEND_FINISH		= 0x043,
> +
> +	/* Guest migration commands (incoming) */
> +	SEV_CMD_RECEIVE_START		= 0x050,
> +	SEV_CMD_RECEIVE_UPDATE_DATA	= 0x051,
> +	SEV_CMD_RECEIVE_UPDATE_VMSA	= 0x052,
> +	SEV_CMD_RECEIVE_FINISH		= 0x053,
> +
> +	/* Guest debug commands */
> +	SEV_CMD_DBG_DECRYPT		= 0x060,
> +	SEV_CMD_DBG_ENCRYPT		= 0x061,
> +
> +	SEV_CMD_MAX,
> +};
> +
> +/**
> + * status code returned by the commands
> + */
> +enum psp_ret_code {
> +	SEV_RET_SUCCESS = 0,
> +	SEV_RET_INVALID_PLATFORM_STATE,
> +	SEV_RET_INVALID_GUEST_STATE,
> +	SEV_RET_INAVLID_CONFIG,
> +	SEV_RET_INVALID_LENGTH,
> +	SEV_RET_ALREADY_OWNED,
> +	SEV_RET_INVALID_CERTIFICATE,
> +	SEV_RET_POLICY_FAILURE,
> +	SEV_RET_INACTIVE,
> +	SEV_RET_INVALID_ADDRESS,
> +	SEV_RET_BAD_SIGNATURE,
> +	SEV_RET_BAD_MEASUREMENT,
> +	SEV_RET_ASID_OWNED,
> +	SEV_RET_INVALID_ASID,
> +	SEV_RET_WBINVD_REQUIRED,
> +	SEV_RET_DFFLUSH_REQUIRED,
> +	SEV_RET_INVALID_GUEST,
> +	SEV_RET_INVALID_COMMAND,
> +	SEV_RET_ACTIVE,
> +	SEV_RET_HWSEV_RET_PLATFORM,
> +	SEV_RET_HWSEV_RET_UNSAFE,
> +	SEV_RET_UNSUPPORTED,
> +	SEV_RET_MAX,
> +};
> +
> +/**
> + * struct sev_data_init - INIT command parameters
> + *
> + * @flags: processing flags
> + * @tmr_address: system physical address used for SEV-ES
> + * @tmr_length: length of tmr_address
> + */
> +struct sev_data_init {
> +	__u32 flags;				/* In */
> +	__u32 reserved;				/* In */
> +	__u64 tmr_address;			/* In */
> +	__u32 tmr_length;			/* In */
> +};

I guess all those structs should be __packed to avoid the compiler
adding padding.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
