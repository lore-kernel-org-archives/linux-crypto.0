From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5 12/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Fri, 6 Oct 2017 20:49:51 +0200
Message-ID: <20171006184951.vq6hlhjanaefizli@pd.tnic>
References: <20171004131412.13038-1-brijesh.singh@amd.com>
 <20171004131412.13038-13-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752343AbdJFSuS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 14:50:18 -0400
Content-Disposition: inline
In-Reply-To: <20171004131412.13038-13-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 04, 2017 at 08:13:53AM -0500, Brijesh Singh wrote:
> AMDs new Secure Encrypted Virtualization (SEV) feature allows the memory
> contents of a virtual machines to be transparently encrypted with a key
> unique to the guest VM. The programming and management of the encryption
> keys are handled by the AMD Secure Processor (AMD-SP), which exposes the
> commands for these tasks. The complete spec is available at:
> 
> http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
> 
> Extend the AMD-SP driver to provide the following support:
> 
>  - an in-kernel APIs to communicate with a SEV firmware. The APIs can be
>    used by the hypervisor to create encryption context for the SEV guests.
> 
>  - a userspace IOCTL to manage the platform certificates

Change that commit message to:

"AMD's new Secure Encrypted Virtualization (SEV) feature allows the
memory contents of virtual machines to be transparently encrypted with a
key unique to the VM. The programming and management of the encryption
keys are handled by the AMD Secure Processor (AMD-SP) which exposes the
commands for these tasks. The complete spec is available at:

http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf

Extend the AMD-SP driver to provide the following support:

 - an in-kernel API to communicate with the SEV firmware. The API can be
   used by the hypervisor to create encryption context for a SEV guest.

 - a userspace IOCTL to manage the platform certificates."

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
>  drivers/crypto/ccp/psp-dev.c | 734 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  17 +
>  include/linux/psp-sev.h      | 159 ++++++++++
>  include/uapi/linux/psp-sev.h | 116 +++++++
>  4 files changed, 1026 insertions(+)
>  create mode 100644 include/uapi/linux/psp-sev.h
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 7480d4316239..1b87a699bd3f 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -23,9 +23,20 @@
>  #include <linux/hw_random.h>
>  #include <linux/ccp.h>
>  
> +#include <uapi/linux/psp-sev.h>
> +
>  #include "sp-dev.h"
>  #include "psp-dev.h"
>  
> +#define DEVICE_NAME	"sev"
> +
> +static unsigned int sev_poll;
> +module_param(sev_poll, uint, 0444);
> +MODULE_PARM_DESC(sev_poll, "Poll for sev command completion - any non-zero value");

What is that used for? Some debugging leftover probably? If not, add a
comment for why it is useful.

> +
> +DEFINE_MUTEX(sev_cmd_mutex);
> +static bool sev_fops_registered;
> +
>  const struct psp_vdata psp_entry = {
>  	.offset = 0x10500,
>  };
> @@ -49,9 +60,725 @@ static struct psp_device *psp_alloc_struct(struct sp_device *sp)
>  
>  static irqreturn_t psp_irq_handler(int irq, void *data)
>  {
> +	struct psp_device *psp = data;
> +	unsigned int status;
> +
> +	/* read the interrupt status */
> +	status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
> +
> +	/* check if its command completion */
> +	if (status & (1 << PSP_CMD_COMPLETE_REG)) {
> +		int reg;
> +
> +		/* check if its SEV command completion */
> +		reg = ioread32(psp->io_regs + PSP_CMDRESP);
> +		if (reg & PSP_CMDRESP_RESP) {
> +			psp->sev_int_rcvd = 1;
> +			wake_up(&psp->sev_int_queue);
> +		}
> +	}
> +
> +	/* clear the interrupt status by writing 1 */
> +	iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);
> +
>  	return IRQ_HANDLED;
>  }
>  
> +static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeout,
> +			     unsigned int *reg)
> +{
> +	int wait = timeout * 10;	/* 100ms sleep => timeout * 10 */

How is this a 100ms sleep?!

10 * 10 * 100ms = 10000ms = 10 seconds max sleep is what my math says.

> +
> +	while (--wait) {
> +		msleep(100);
> +
> +		*reg = ioread32(psp->io_regs + PSP_CMDRESP);
> +		if (*reg & PSP_CMDRESP_RESP)
> +			break;
> +	}
> +
> +	if (!wait) {
> +		dev_err(psp->dev, "sev command timed out\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sev_wait_cmd_ioc(struct psp_device *psp, unsigned int *reg)
> +{
> +	psp->sev_int_rcvd = 0;
> +
> +	wait_event(psp->sev_int_queue, psp->sev_int_rcvd);

What happens if the command times out and it never sets psp->sev_int_rcvd?

> +	*reg = ioread32(psp->io_regs + PSP_CMDRESP);
> +
> +	return 0;
> +}
> +
> +static int sev_wait_cmd(struct psp_device *psp, unsigned int *reg)
> +{
> +	return (*reg & PSP_CMDRESP_IOC) ? sev_wait_cmd_ioc(psp, reg)
> +					: sev_wait_cmd_poll(psp, 10, reg);
> +}
> +
> +static int sev_cmd_buffer_len(int cmd)
> +{
> +	switch (cmd) {
> +	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
> +	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_data_status);
> +	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
> +	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
> +	case SEV_CMD_PDH_CERT_EXPORT:		return sizeof(struct sev_data_pdh_cert_export);
> +	case SEV_CMD_LAUNCH_START:		return sizeof(struct sev_data_launch_start);
> +	case SEV_CMD_LAUNCH_UPDATE_DATA:	return sizeof(struct sev_data_launch_update_data);
> +	case SEV_CMD_LAUNCH_UPDATE_VMSA:	return sizeof(struct sev_data_launch_update_vmsa);
> +	case SEV_CMD_LAUNCH_FINISH:		return sizeof(struct sev_data_launch_finish);
> +	case SEV_CMD_LAUNCH_MEASURE:		return sizeof(struct sev_data_launch_measure);
> +	case SEV_CMD_ACTIVATE:			return sizeof(struct sev_data_activate);
> +	case SEV_CMD_DEACTIVATE:		return sizeof(struct sev_data_deactivate);
> +	case SEV_CMD_DECOMMISSION:		return sizeof(struct sev_data_decommission);
> +	case SEV_CMD_GUEST_STATUS:		return sizeof(struct sev_data_guest_status);
> +	case SEV_CMD_DBG_DECRYPT:		return sizeof(struct sev_data_dbg);
> +	case SEV_CMD_DBG_ENCRYPT:		return sizeof(struct sev_data_dbg);
> +	case SEV_CMD_SEND_START:		return sizeof(struct sev_data_send_start);
> +	case SEV_CMD_SEND_UPDATE_DATA:		return sizeof(struct sev_data_send_update_data);
> +	case SEV_CMD_SEND_UPDATE_VMSA:		return sizeof(struct sev_data_send_update_vmsa);
> +	case SEV_CMD_SEND_FINISH:		return sizeof(struct sev_data_send_finish);
> +	case SEV_CMD_RECEIVE_START:		return sizeof(struct sev_data_receive_start);
> +	case SEV_CMD_RECEIVE_FINISH:		return sizeof(struct sev_data_receive_finish);
> +	case SEV_CMD_RECEIVE_UPDATE_DATA:	return sizeof(struct sev_data_receive_update_data);
> +	case SEV_CMD_RECEIVE_UPDATE_VMSA:	return sizeof(struct sev_data_receive_update_vmsa);
> +	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
> +	default:				return 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
> +{
> +	struct sp_device *sp = sp_get_psp_master_device();
> +	unsigned int phys_lsb, phys_msb;
> +	struct psp_device *psp = sp->psp_data;
> +	unsigned int reg, ret;
> +
> +	if (!psp)
> +		return -ENODEV;
> +
> +	/* Get the physical address of the command buffer */
> +	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
> +	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
> +
> +	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x\n",
> +			cmd, phys_msb, phys_lsb);
> +	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +			sev_cmd_buffer_len(cmd), false);
> +
> +	/* Only one command at a time... */
> +	mutex_lock(&sev_cmd_mutex);
> +
> +	iowrite32(phys_lsb, psp->io_regs + PSP_CMDBUFF_ADDR_LO);
> +	iowrite32(phys_msb, psp->io_regs + PSP_CMDBUFF_ADDR_HI);
> +
> +	reg = cmd;
> +	reg <<= PSP_CMDRESP_CMD_SHIFT;
> +	reg |= sev_poll ? 0 : PSP_CMDRESP_IOC;
> +	iowrite32(reg, psp->io_regs + PSP_CMDRESP);
> +
> +	ret = sev_wait_cmd(psp, &reg);
> +	if (ret)
> +		goto unlock;
> +
> +	if (psp_ret)
> +		*psp_ret = reg & PSP_CMDRESP_ERR_MASK;
> +
> +	if (reg & PSP_CMDRESP_ERR_MASK) {
> +		dev_dbg(psp->dev, "sev command %#x failed (%#010x)\n",
> +			cmd, reg & PSP_CMDRESP_ERR_MASK);
> +		ret = -EIO;
> +	}
> +
> +unlock:
> +	mutex_unlock(&sev_cmd_mutex);
> +	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
> +			sev_cmd_buffer_len(cmd), false);
> +	return ret;
> +}

Ok, this patch is humongous. Please split it in at least 3 or 4 separate
logical patches as it is very hard to review as one huge chunk right
now. Like, for example, the header file additions could be one patch,
then part of psp-dev.c and so on.

You can then send me those split-up ones as a reply here so that I can
take a look again.

Also, here are a bunch of fixes ontop. Please add

"Improvements by Borislav Petkov <bp@suse.de>"

to the commit message when you decide to use them.

Btw, the psp_entry thing I've moved to sp-pci.c, you probably should do
that in the patch which adds it, not here.

Also, I've fixed:

+       /* Clear the interrupt status by writing 1. */
+       iowrite32(1, psp->io_regs + PSP_P2CMSG_INTSTS);

to really write 1 and not reuse the old status value.

And so on, they should be obvious from the diff.

Thx.

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 1b87a699bd3f..13633eaa7889 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -32,15 +32,11 @@
 
 static unsigned int sev_poll;
 module_param(sev_poll, uint, 0444);
-MODULE_PARM_DESC(sev_poll, "Poll for sev command completion - any non-zero value");
+MODULE_PARM_DESC(sev_poll, "Poll for SEV command completion - any non-zero value");
 
-DEFINE_MUTEX(sev_cmd_mutex);
+static DEFINE_MUTEX(sev_cmd_mutex);
 static bool sev_fops_registered;
 
-const struct psp_vdata psp_entry = {
-	.offset = 0x10500,
-};
-
 static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 {
 	struct device *dev = sp->dev;
@@ -62,34 +58,37 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 {
 	struct psp_device *psp = data;
 	unsigned int status;
+	int reg;
 
-	/* read the interrupt status */
+	/* Read the interrupt status: */
 	status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
 
-	/* check if its command completion */
-	if (status & (1 << PSP_CMD_COMPLETE_REG)) {
-		int reg;
+	/* Check if it is command completion: */
+	if (!(status & BIT(PSP_CMD_COMPLETE_REG)))
+		goto done;
 
-		/* check if its SEV command completion */
-		reg = ioread32(psp->io_regs + PSP_CMDRESP);
-		if (reg & PSP_CMDRESP_RESP) {
-			psp->sev_int_rcvd = 1;
-			wake_up(&psp->sev_int_queue);
-		}
+	/* Check if it is SEV command completion: */
+	reg = ioread32(psp->io_regs + PSP_CMDRESP);
+	if (reg & PSP_CMDRESP_RESP) {
+		psp->sev_int_rcvd = 1;
+		wake_up(&psp->sev_int_queue);
 	}
 
-	/* clear the interrupt status by writing 1 */
-	iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);
+done:
+	/* Clear the interrupt status by writing 1. */
+	iowrite32(1, psp->io_regs + PSP_P2CMSG_INTSTS);
 
 	return IRQ_HANDLED;
 }
 
-static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeout,
+static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeouts,
 			     unsigned int *reg)
 {
-	int wait = timeout * 10;	/* 100ms sleep => timeout * 10 */
+	/* 10*100ms max timeout */
+	if (timeouts > 10)
+		timeouts = 10;
 
-	while (--wait) {
+	while (--timeouts) {
 		msleep(100);
 
 		*reg = ioread32(psp->io_regs + PSP_CMDRESP);
@@ -97,8 +96,8 @@ static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeout,
 			break;
 	}
 
-	if (!wait) {
-		dev_err(psp->dev, "sev command timed out\n");
+	if (!timeouts) {
+		dev_err(psp->dev, "SEV command timed out\n");
 		return -ETIMEDOUT;
 	}
 
@@ -157,11 +156,16 @@ static int sev_cmd_buffer_len(int cmd)
 
 static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
 {
-	struct sp_device *sp = sp_get_psp_master_device();
 	unsigned int phys_lsb, phys_msb;
-	struct psp_device *psp = sp->psp_data;
+	struct psp_device *psp;
 	unsigned int reg, ret;
+	struct sp_device *sp;
+
+	sp = sp_get_psp_master_device();
+	if (!sp)
+		return -ENODEV;
 
+	psp = sp->psp_data;
 	if (!psp)
 		return -ENODEV;
 
@@ -170,9 +174,10 @@ static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
 	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
 
 	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x\n",
-			cmd, phys_msb, phys_lsb);
+		cmd, phys_msb, phys_lsb);
+
 	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			sev_cmd_buffer_len(cmd), false);
+			     sev_cmd_buffer_len(cmd), false);
 
 	/* Only one command at a time... */
 	mutex_lock(&sev_cmd_mutex);
@@ -201,7 +206,7 @@ static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
 unlock:
 	mutex_unlock(&sev_cmd_mutex);
 	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
-			sev_cmd_buffer_len(cmd), false);
+			     sev_cmd_buffer_len(cmd), false);
 	return ret;
 }
 
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index 51d3cd966eed..6e8f83b41521 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -73,6 +73,4 @@ struct psp_device {
 	struct miscdevice sev_misc;
 };
 
-extern const struct psp_vdata psp_entry;
-
 #endif /* __PSP_DEV_H */
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 20a0f3543cf4..f5f43c50698a 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -268,6 +268,12 @@ static int sp_pci_resume(struct pci_dev *pdev)
 }
 #endif
 
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
+static const struct psp_vdata psp_entry = {
+	.offset = 0x10500,
+};
+#endif
+
 static const struct sp_dev_vdata dev_vdata[] = {
 	{
 		.bar = 2,

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
