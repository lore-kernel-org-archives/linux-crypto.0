From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v4 07/29] crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support
Date: Tue, 19 Sep 2017 15:46:05 -0500
Message-ID: <20170919204627.3875-8-brijesh.singh@amd.com>
References: <20170919204627.3875-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0056.outbound.protection.outlook.com ([104.47.34.56]:55572
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751660AbdISUrC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Sep 2017 16:47:02 -0400
In-Reply-To: <20170919204627.3875-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

AMDs new Secure Encrypted Virtualization (SEV) feature allows the memory
contents of a virtual machines to be transparently encrypted with a key
unique to the guest VM. The programming and management of the encryption
keys are handled by the AMD Secure Processor (AMD-SP), which exposes the
commands for these tasks. The complete spec is available at:

http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf

Extend the AMD-SP driver to provide the following support:

 - an in-kernel APIs to communicate with a SEV firmware. The APIs can be
   used by the hypervisor to create encryption context for the SEV guests.

 - an userspace IOCTL to manage the platform certificates

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 743 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/crypto/ccp/psp-dev.h |  17 +
 include/linux/psp-sev.h      | 171 ++++++++++
 include/uapi/linux/psp-sev.h | 114 +++++++
 4 files changed, 1044 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/psp-sev.h

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index e60e53272e71..c74e383666f8 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -23,9 +23,20 @@
 #include <linux/hw_random.h>
 #include <linux/ccp.h>
 
+#include <uapi/linux/psp-sev.h>
+
 #include "sp-dev.h"
 #include "psp-dev.h"
 
+#define DEVICE_NAME	"sev"
+
+static unsigned int sev_poll;
+module_param(sev_poll, uint, 0444);
+MODULE_PARM_DESC(sev_poll, "Poll for sev command completion - any non-zero value");
+
+DEFINE_MUTEX(sev_cmd_mutex);
+static bool sev_fops_registered;
+
 const struct psp_vdata psp_entry = {
 	.offset = 0x10500,
 };
@@ -49,9 +60,732 @@ static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 
 irqreturn_t psp_irq_handler(int irq, void *data)
 {
+	unsigned int status;
+	struct psp_device *psp = data;
+
+	/* read the interrupt status */
+	status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
+
+	/* check if its command completion */
+	if (status & (1 << PSP_CMD_COMPLETE_REG)) {
+		int reg;
+
+		/* check if its SEV command completion */
+		reg = ioread32(psp->io_regs + PSP_CMDRESP);
+		if (reg & PSP_CMDRESP_RESP) {
+			psp->sev_int_rcvd = 1;
+			wake_up(&psp->sev_int_queue);
+		}
+	}
+
+	/* clear the interrupt status by writing 1 */
+	iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);
+
 	return IRQ_HANDLED;
 }
 
+static struct psp_device *psp_get_master_device(void)
+{
+	struct sp_device *sp = sp_get_psp_master_device();
+
+	return sp ? sp->psp_data : NULL;
+}
+
+static int sev_wait_cmd_poll(struct psp_device *psp, unsigned int timeout,
+			     unsigned int *reg)
+{
+	int wait = timeout * 10;	/* 100ms sleep => timeout * 10 */
+
+	while (--wait) {
+		msleep(100);
+
+		*reg = ioread32(psp->io_regs + PSP_CMDRESP);
+		if (*reg & PSP_CMDRESP_RESP)
+			break;
+	}
+
+	if (!wait) {
+		dev_err(psp->dev, "sev command timed out\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static int sev_wait_cmd_ioc(struct psp_device *psp, unsigned int *reg)
+{
+	psp->sev_int_rcvd = 0;
+
+	wait_event(psp->sev_int_queue, psp->sev_int_rcvd);
+	*reg = ioread32(psp->io_regs + PSP_CMDRESP);
+
+	return 0;
+}
+
+static int sev_wait_cmd(struct psp_device *psp, unsigned int *reg)
+{
+	return (*reg & PSP_CMDRESP_IOC) ? sev_wait_cmd_ioc(psp, reg)
+					: sev_wait_cmd_poll(psp, 10, reg);
+}
+
+static int sev_cmd_buffer_len(int cmd)
+{
+	switch (cmd) {
+	case SEV_CMD_INIT:
+		return sizeof(struct sev_data_init);
+	case SEV_CMD_PLATFORM_STATUS:
+		return sizeof(struct sev_data_status);
+	case SEV_CMD_PEK_CSR:
+		return sizeof(struct sev_data_pek_csr);
+	case SEV_CMD_PEK_CERT_IMPORT:
+		return sizeof(struct sev_data_pek_cert_import);
+	case SEV_CMD_PDH_CERT_EXPORT:
+		return sizeof(struct sev_data_pdh_cert_export);
+	case SEV_CMD_LAUNCH_START:
+		return sizeof(struct sev_data_launch_start);
+	case SEV_CMD_LAUNCH_UPDATE_DATA:
+		return sizeof(struct sev_data_launch_update_data);
+	case SEV_CMD_LAUNCH_UPDATE_VMSA:
+		return sizeof(struct sev_data_launch_update_vmsa);
+	case SEV_CMD_LAUNCH_FINISH:
+		return sizeof(struct sev_data_launch_finish);
+	case SEV_CMD_LAUNCH_UPDATE_SECRET:
+		return sizeof(struct sev_data_launch_secret);
+	case SEV_CMD_LAUNCH_MEASURE:
+		return sizeof(struct sev_data_launch_measure);
+	case SEV_CMD_ACTIVATE:
+		return sizeof(struct sev_data_activate);
+	case SEV_CMD_DEACTIVATE:
+		return sizeof(struct sev_data_deactivate);
+	case SEV_CMD_DECOMMISSION:
+		return sizeof(struct sev_data_decommission);
+	case SEV_CMD_GUEST_STATUS:
+		return sizeof(struct sev_data_guest_status);
+	case SEV_CMD_DBG_DECRYPT:
+	case SEV_CMD_DBG_ENCRYPT:
+		return sizeof(struct sev_data_dbg);
+	case SEV_CMD_SEND_START:
+		return sizeof(struct sev_data_send_start);
+	case SEV_CMD_SEND_UPDATE_DATA:
+		return sizeof(struct sev_data_send_update_data);
+	case SEV_CMD_SEND_UPDATE_VMSA:
+		return sizeof(struct sev_data_send_update_vmsa);
+	case SEV_CMD_SEND_FINISH:
+		return sizeof(struct sev_data_send_finish);
+	case SEV_CMD_RECEIVE_START:
+		return sizeof(struct sev_data_receive_start);
+	case SEV_CMD_RECEIVE_UPDATE_DATA:
+		return sizeof(struct sev_data_receive_update_data);
+	case SEV_CMD_RECEIVE_UPDATE_VMSA:
+		return sizeof(struct sev_data_receive_update_vmsa);
+	case SEV_CMD_RECEIVE_FINISH:
+		return sizeof(struct sev_data_receive_finish);
+	default:
+		return 0;
+	}
+
+	return 0;
+}
+
+static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
+{
+	struct psp_device *psp = psp_get_master_device();
+	unsigned int phys_lsb, phys_msb;
+	unsigned int reg, ret;
+
+	if (!psp)
+		return -ENODEV;
+
+	/* Set the physical address for the PSP */
+	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
+	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
+
+	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x\n",
+			cmd, phys_msb, phys_lsb);
+	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			sev_cmd_buffer_len(cmd), false);
+
+	/* Only one command at a time... */
+	mutex_lock(&sev_cmd_mutex);
+
+	iowrite32(phys_lsb, psp->io_regs + PSP_CMDBUFF_ADDR_LO);
+	iowrite32(phys_msb, psp->io_regs + PSP_CMDBUFF_ADDR_HI);
+
+	reg = cmd;
+	reg <<= PSP_CMDRESP_CMD_SHIFT;
+	reg |= sev_poll ? 0 : PSP_CMDRESP_IOC;
+	iowrite32(reg, psp->io_regs + PSP_CMDRESP);
+
+	ret = sev_wait_cmd(psp, &reg);
+	if (ret)
+		goto unlock;
+
+	if (psp_ret)
+		*psp_ret = reg & PSP_CMDRESP_ERR_MASK;
+
+	if (reg & PSP_CMDRESP_ERR_MASK) {
+		dev_dbg(psp->dev, "sev command %#x failed (%#010x)\n",
+			cmd, reg & PSP_CMDRESP_ERR_MASK);
+		ret = -EIO;
+	}
+
+unlock:
+	mutex_unlock(&sev_cmd_mutex);
+	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			sev_cmd_buffer_len(cmd), false);
+	return ret;
+}
+
+static int sev_platform_get_state(int *state, int *error)
+{
+	struct sev_data_status *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
+	if (!ret)
+		*state = data->state;
+
+	kfree(data);
+	return ret;
+}
+
+static int sev_firmware_init(int *error)
+{
+	struct sev_data_init *data;
+	int rc;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	rc = sev_handle_cmd(SEV_CMD_INIT, data, error);
+
+	kfree(data);
+	return rc;
+}
+
+static inline int sev_ioctl_factory_reset(struct sev_issue_cmd *argp)
+{
+	return sev_handle_cmd(SEV_CMD_FACTORY_RESET, 0, &argp->error);
+}
+
+static int sev_ioctl_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_data_status *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
+	if (ret)
+		goto e_free;
+
+	if (copy_to_user((void __user *)(uintptr_t) argp->data,
+			 data, sizeof(*data))) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+e_free:
+	kfree(data);
+	return ret;
+}
+
+static void *copy_user_blob(u64 __user uaddr, u32 len)
+{
+	void *data;
+
+	if (!uaddr || !len)
+		return ERR_PTR(-EINVAL);
+
+	/* verify that blob length does not exceed our limit */
+	if (len > SEV_FW_BLOB_MAX_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	data = kmalloc(len, GFP_KERNEL);
+	if (IS_ERR(data))
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(data, (void __user *)(uintptr_t)uaddr, len))
+		goto e_free;
+
+	return data;
+e_free:
+	kfree(data);
+	return ERR_PTR(-EFAULT);
+}
+
+static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_csr input;
+	struct sev_data_pek_csr *data;
+	int do_shutdown = 0;
+	int ret, state;
+	void *blob;
+
+	if (copy_from_user(&input, (void __user *)(uintptr_t)argp->data,
+			   sizeof(struct sev_user_data_pek_csr)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+
+	/* copy the PEK certificate blob from userspace */
+	blob = NULL;
+	if (input.address) {
+		blob = copy_user_blob(input.address, input.length);
+		if (IS_ERR(blob)) {
+			ret = PTR_ERR(blob);
+			goto e_free;
+		}
+
+		data->address = __psp_pa(blob);
+		data->len = input.length;
+	}
+
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		goto e_free_blob;
+
+	/*
+	 * PEK_CERT command can be issued only when we are in INIT state.
+	 * if current state is WORKING then reject it, if state is UNINIT
+	 * then transition the platform to INIT state before issuing the
+	 * command.
+	 */
+	if (state == SEV_STATE_WORKING) {
+		ret = -EBUSY;
+		goto e_free_blob;
+	} else if (state == SEV_STATE_UNINIT) {
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			goto e_free_blob;
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
+
+	input.length = data->len;
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &input,
+			 sizeof(struct sev_user_data_pek_csr)))
+		ret = -EFAULT;
+
+	/* transition the plaform into INIT state */
+	if (do_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+
+e_free_blob:
+	kfree(blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
+static int sev_ioctl_pdh_gen(struct sev_issue_cmd *argp)
+{
+	int ret, state, do_shutdown = 0;
+
+	/*
+	 * PDH_GEN command can be issued when platform is in INIT or WORKING
+	 * state. If we are in UNINIT state then transition into INIT state
+	 * before issuing the command.
+	 */
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		return ret;
+
+	if (state == SEV_STATE_UNINIT) {
+		/* transition the plaform into INIT state */
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			return ret;
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PDH_GEN, 0, &argp->error);
+
+	if (do_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+
+	return ret;
+}
+
+static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
+{
+	int do_shutdown = 0;
+	int ret, state;
+
+	/*
+	 * PEK_GEN command can be issued only when firmware is in INIT state.
+	 * If firmware is in UNINIT state then we transition it into INIT state
+	 * and issue the command.
+	 */
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		return ret;
+
+	if (state == SEV_STATE_WORKING) {
+		return -EBUSY;
+	} else if (state == SEV_STATE_UNINIT) {
+		/* transition the plaform into INIT state */
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			return ret;
+
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PEK_GEN, 0, &argp->error);
+
+	if (do_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+
+	return ret;
+}
+
+static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_cert_import input;
+	struct sev_data_pek_cert_import *data;
+	int ret, state, do_shutdown = 0;
+	void *pek_blob, *oca_blob;
+
+	if (copy_from_user(&input, (void __user *)(uintptr_t) argp->data,
+			   sizeof(struct sev_user_data_pek_cert_import)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* copy PEK certificate blobs from userspace */
+	pek_blob = copy_user_blob(input.pek_cert_address, input.pek_cert_len);
+	if (IS_ERR(pek_blob)) {
+		ret = PTR_ERR(pek_blob);
+		goto e_free;
+	}
+
+	data->pek_cert_address = __psp_pa(pek_blob);
+	data->pek_cert_len = input.pek_cert_len;
+
+	/* copy PEK certificate blobs from userspace */
+	oca_blob = copy_user_blob(input.oca_cert_address, input.oca_cert_len);
+	if (IS_ERR(oca_blob)) {
+		ret = PTR_ERR(oca_blob);
+		goto e_free_pek;
+	}
+
+	data->oca_cert_address = __psp_pa(oca_blob);
+	data->oca_cert_len = input.oca_cert_len;
+
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		goto e_free_oca;
+
+	/*
+	 * PEK_CERT_IMPORT command can be issued only when platform is in INIT
+	 * state. If we are in UNINIT state then transition into INIT state
+	 * before issuing the command.
+	 */
+	if (state == SEV_STATE_WORKING) {
+		ret = -EBUSY;
+		goto e_free_oca;
+	} else if (state == SEV_STATE_UNINIT) {
+		/* transition platform init INIT state */
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			goto e_free_oca;
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
+
+	if (do_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+e_free_oca:
+	kfree(oca_blob);
+e_free_pek:
+	kfree(pek_blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
+static int sev_ioctl_pdh_cert_export(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pdh_cert_export input;
+	struct sev_data_pdh_cert_export *data;
+	int ret, state, need_shutdown = 0;
+	void *pdh_blob, *cert_blob;
+
+	if (copy_from_user(&input, (void __user *)(uintptr_t)argp->data,
+			   sizeof(struct sev_user_data_pdh_cert_export)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	pdh_blob = NULL;
+	if (input.pdh_cert_address) {
+		if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) {
+			ret = -EINVAL;
+			goto e_free;
+		}
+
+		pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
+		if (!pdh_blob) {
+			ret = -ENOMEM;
+			goto e_free;
+		}
+
+		data->pdh_cert_address = __psp_pa(pdh_blob);
+		data->pdh_cert_len = input.pdh_cert_len;
+	}
+
+	cert_blob = NULL;
+	if (input.cert_chain_address) {
+		if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) {
+			ret = -EINVAL;
+			goto e_free_pdh;
+		}
+
+		cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
+		if (!cert_blob) {
+			ret = -ENOMEM;
+			goto e_free_pdh;
+		}
+
+		data->cert_chain_address = __psp_pa(cert_blob);
+		data->cert_chain_len = input.cert_chain_len;
+	}
+
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		goto e_free_cert;
+
+	/*
+	 * CERT_EXPORT command can be issued in INIT or WORKING state.
+	 * If we are in UNINIT state then transition into INIT state and
+	 * shutdown before exiting. But if platform is in WORKING state
+	 * then EXPORT the certificate but do not shutdown the platform.
+	 */
+	if (state == SEV_STATE_UNINIT) {
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			goto e_free_cert;
+
+		need_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
+
+	input.cert_chain_len = data->cert_chain_len;
+	input.pdh_cert_len = data->pdh_cert_len;
+
+	/* copy certificate length to userspace */
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &input,
+			 sizeof(struct sev_user_data_pdh_cert_export)))
+		ret = -EFAULT;
+
+	if (ret)
+		goto e_shutdown;
+
+	/* copy PDH certificate to userspace */
+	if (pdh_blob &&
+	    copy_to_user((void __user *)(uintptr_t)input.pdh_cert_address,
+			 pdh_blob, input.pdh_cert_len)) {
+		ret = -EFAULT;
+		goto e_shutdown;
+	}
+
+	/* copy certificate chain to userspace */
+	if (cert_blob &&
+	    copy_to_user((void __user *)(uintptr_t)input.cert_chain_address,
+			cert_blob, input.cert_chain_len)) {
+		ret = -EFAULT;
+		goto e_shutdown;
+	}
+
+e_shutdown:
+	if (need_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+e_free_cert:
+	kfree(cert_blob);
+e_free_pdh:
+	kfree(pdh_blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
+static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct sev_issue_cmd input;
+	int ret = -EFAULT;
+
+	if (ioctl != SEV_ISSUE_CMD)
+		return -EINVAL;
+
+	if (copy_from_user(&input, argp, sizeof(struct sev_issue_cmd)))
+		return -EFAULT;
+
+	if (input.cmd > SEV_CMD_MAX)
+		return -EINVAL;
+
+	switch (input.cmd) {
+
+	case SEV_USER_CMD_FACTORY_RESET: {
+		ret = sev_ioctl_factory_reset(&input);
+		break;
+	}
+	case SEV_USER_CMD_PLATFORM_STATUS: {
+		ret = sev_ioctl_platform_status(&input);
+		break;
+	}
+	case SEV_USER_CMD_PEK_GEN: {
+		ret = sev_ioctl_pek_gen(&input);
+		break;
+	}
+	case SEV_USER_CMD_PDH_GEN: {
+		ret = sev_ioctl_pdh_gen(&input);
+		break;
+	}
+	case SEV_USER_CMD_PEK_CSR: {
+		ret = sev_ioctl_pek_csr(&input);
+		break;
+	}
+	case SEV_USER_CMD_PEK_CERT_IMPORT: {
+		ret = sev_ioctl_pek_cert_import(&input);
+		break;
+	}
+	case SEV_USER_CMD_PDH_CERT_EXPORT: {
+		ret = sev_ioctl_pdh_cert_export(&input);
+		break;
+	}
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
+
+const struct file_operations sev_fops = {
+	.owner	= THIS_MODULE,
+	.unlocked_ioctl = sev_ioctl,
+};
+
+int sev_platform_init(struct sev_data_init *data, int *error)
+{
+	return sev_handle_cmd(SEV_CMD_INIT, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_platform_init);
+
+int sev_platform_shutdown(int *error)
+{
+	return sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, error);
+}
+EXPORT_SYMBOL_GPL(sev_platform_shutdown);
+
+int sev_platform_status(struct sev_data_status *data, int *error)
+{
+	return sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_platform_status);
+
+int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
+				void *data, int *error)
+{
+	if (!filep || filep->f_op != &sev_fops)
+		return -EBADF;
+
+	return sev_handle_cmd(cmd, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
+
+int sev_guest_deactivate(struct sev_data_deactivate *data, int *error)
+{
+	return sev_handle_cmd(SEV_CMD_DEACTIVATE, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_deactivate);
+
+int sev_guest_activate(struct sev_data_activate *data, int *error)
+{
+	return sev_handle_cmd(SEV_CMD_ACTIVATE, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_activate);
+
+int sev_guest_decommission(struct sev_data_decommission *data, int *error)
+{
+	return sev_handle_cmd(SEV_CMD_DECOMMISSION, data, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_decommission);
+
+int sev_guest_df_flush(int *error)
+{
+	return sev_handle_cmd(SEV_CMD_DF_FLUSH, 0, error);
+}
+EXPORT_SYMBOL_GPL(sev_guest_df_flush);
+
+static int sev_ops_init(struct psp_device *psp)
+{
+	int ret = 0;
+	struct miscdevice *misc = &psp->sev_misc;
+
+	/*
+	 * SEV feature support can be detected on the multiple devices but the
+	 * SEV FW commands must be issued on the master. During probe time we
+	 * do not know the master hence we create /dev/sev on the first device
+	 * probe. sev_handle_cmd() finds the right master device to send the
+	 * command.
+	 */
+	if (!sev_fops_registered) {
+		misc->minor = MISC_DYNAMIC_MINOR;
+		misc->name = DEVICE_NAME;
+		misc->fops = &sev_fops;
+
+		ret = misc_register(misc);
+		if (!ret) {
+			sev_fops_registered = true;
+			psp->has_sev_fops = true;
+			init_waitqueue_head(&psp->sev_int_queue);
+		}
+	}
+
+	return ret;
+}
+
+static int sev_init(struct psp_device *psp)
+{
+	/* Check if device supports SEV feature */
+	if (!(ioread32(psp->io_regs + PSP_FEATURE_REG) & 1)) {
+		dev_dbg(psp->dev, "device does not support SEV\n");
+		return 1;
+	}
+
+	return sev_ops_init(psp);
+}
+
+static void sev_exit(struct psp_device *psp)
+{
+	if (psp->has_sev_fops)
+		misc_deregister(&psp->sev_misc);
+}
+
 int psp_dev_init(struct sp_device *sp)
 {
 	struct device *dev = sp->dev;
@@ -87,14 +821,20 @@ int psp_dev_init(struct sp_device *sp)
 
 	sp_set_psp_master(sp);
 
+	ret = sev_init(psp);
+	if (ret)
+		goto e_irq;
+
 	/* Enable interrupt */
 	dev_dbg(dev, "Enabling interrupts ...\n");
-	iowrite32(7, psp->io_regs + PSP_P2CMSG_INTEN);
+	iowrite32(-1, psp->io_regs + PSP_P2CMSG_INTEN);
 
 	dev_notice(dev, "psp enabled\n");
 
 	return 0;
 
+e_irq:
+	sp_free_psp_irq(psp->sp, psp);
 e_err:
 	sp->psp_data = NULL;
 
@@ -107,5 +847,6 @@ void psp_dev_destroy(struct sp_device *sp)
 {
 	struct psp_device *psp = sp->psp_data;
 
+	sev_exit(psp);
 	sp_free_psp_irq(sp, psp);
 }
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index d53970ef5960..51d3cd966eed 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -25,9 +25,21 @@
 #include <linux/interrupt.h>
 #include <linux/irqreturn.h>
 #include <linux/dmaengine.h>
+#include <linux/psp-sev.h>
+#include <linux/miscdevice.h>
 
 #include "sp-dev.h"
 
+#define PSP_C2PMSG(_num)		((_num) << 2)
+#define PSP_CMDRESP			PSP_C2PMSG(32)
+#define PSP_CMDBUFF_ADDR_LO		PSP_C2PMSG(56)
+#define PSP_CMDBUFF_ADDR_HI             PSP_C2PMSG(57)
+#define PSP_FEATURE_REG			PSP_C2PMSG(63)
+
+#define PSP_P2CMSG(_num)		(_num << 2)
+#define PSP_CMD_COMPLETE_REG		1
+#define PSP_CMD_COMPLETE		PSP_P2CMSG(PSP_CMD_COMPLETE_REG)
+
 #define PSP_P2CMSG_INTEN		0x0110
 #define PSP_P2CMSG_INTSTS		0x0114
 
@@ -54,6 +66,11 @@ struct psp_device {
 	struct sp_device *sp;
 
 	void __iomem *io_regs;
+
+	unsigned int sev_int_rcvd;
+	wait_queue_head_t sev_int_queue;
+	bool has_sev_fops;
+	struct miscdevice sev_misc;
 };
 
 extern const struct psp_vdata psp_entry;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index d40709b65b18..70ba2dcdba04 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -509,4 +509,175 @@ struct __attribute__((__packed__)) sev_data_dbg {
 	u32 len;				/* In */
 };
 
+#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
+
+/**
+ * sev_platform_init - perform SEV INIT command
+ *
+ * @init: sev_data_init structure to be processed
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_platform_init(struct sev_data_init *init, int *error);
+
+/**
+ * sev_platform_shutdown - perform SEV SHUTDOWN command
+ *
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_platform_shutdown(int *error);
+
+/**
+ * sev_platform_status - perform SEV PLATFORM_STATUS command
+ *
+ * @init: sev_data_status structure to be processed
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_platform_status(struct sev_data_status *status, int *error);
+/**
+ * sev_issue_cmd_external_user - issue SEV command by other driver with a file handle.
+ *
+ * The function can be used by other drivers to issue a SEV command on
+ * behalf by userspace. The caller must pass a valid SEV file descriptor
+ * so that we know that caller has access to SEV device.
+ *
+ * @filep - SEV device file pointer
+ * @cmd - command to issue
+ * @data - command buffer
+ * @error: SEV command return code
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SEV device is not available
+ * -%ENOTSUPP  if the SEV does not support SEV
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ * -%EINVAL    if the SEV file descriptor is not valid
+ */
+int sev_issue_cmd_external_user(struct file *filep, unsigned int id,
+				void *data, int *error);
+
+/**
+ * sev_guest_deactivate - perform SEV DEACTIVATE command
+ *
+ * @deactivate: sev_data_deactivate structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_deactivate(struct sev_data_deactivate *data, int *error);
+
+/**
+ * sev_guest_activate - perform SEV ACTIVATE command
+ *
+ * @activate: sev_data_activate structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_activate(struct sev_data_activate *data, int *error);
+
+/**
+ * sev_guest_df_flush - perform SEV DF_FLUSH command
+ *
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_df_flush(int *error);
+
+/**
+ * sev_guest_decommission - perform SEV DECOMMISSION command
+ *
+ * @decommission: sev_data_decommission structure to be processed
+ * @sev_ret: sev command return code
+ *
+ * Returns:
+ * 0 if the sev successfully processed the command
+ * -%ENODEV    if the sev device is not available
+ * -%ENOTSUPP  if the sev does not support SEV
+ * -%ETIMEDOUT if the sev command timed out
+ * -%EIO       if the sev returned a non-zero return code
+ */
+int sev_guest_decommission(struct sev_data_decommission *data, int *error);
+
+#else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
+
+static inline int sev_platform_status(struct sev_data_status *status,
+				      int *error)
+{
+	return -ENODEV;
+}
+
+static inline int sev_platform_init(struct sev_data_init *init, int *error)
+{
+	return -ENODEV;
+}
+
+static inline int sev_platform_shutdown(int *error) { return -ENODEV; }
+
+
+static inline int sev_issue_cmd_external_user(int fd, unsigned int id,
+					void *data, int *error)
+{
+	return -ENODEV;
+}
+
+static inline int sev_guest_deactivate(struct sev_data_deactivate *data,
+					int *error)
+{
+	return -ENODEV;
+}
+
+static inline int sev_guest_decommission(struct sev_data_decommission *data,
+					int *error)
+{
+	return -ENODEV;
+}
+
+static inline int sev_guest_activate(struct sev_data_activate *data,
+					int *error)
+{
+	return -ENODEV;
+}
+
+static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
+
+#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
+
 #endif	/* __PSP_SEV_H__ */
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
new file mode 100644
index 000000000000..885d9940786a
--- /dev/null
+++ b/include/uapi/linux/psp-sev.h
@@ -0,0 +1,114 @@
+
+/*
+ * Userspace interface for AMD Secure Encrypted Virtualization (SEV)
+ *
+ * Copyright (C) 2016-2017 Advanced Micro Devices, Inc.
+ *
+ * Author: Brijesh Singh <brijesh.singh@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PSP_SEV_USER_H__
+#define __PSP_SEV_USER_H__
+
+#include <linux/types.h>
+
+/**
+ * SEV platform commands
+ */
+enum {
+	SEV_USER_CMD_FACTORY_RESET = 0,
+	SEV_USER_CMD_PLATFORM_STATUS,
+	SEV_USER_CMD_PEK_GEN,
+	SEV_USER_CMD_PEK_CSR,
+	SEV_USER_CMD_PDH_GEN,
+	SEV_USER_CMD_PDH_CERT_EXPORT,
+	SEV_USER_CMD_PEK_CERT_IMPORT,
+
+	SEV_USER_CMD_MAX,
+};
+
+/**
+ * struct sev_user_data_status - PLATFORM_STATUS command parameters
+ *
+ * @major: major API version
+ * @minor: minor API version
+ * @state: platform state
+ * @owner: self-owned or externally owned
+ * @config: platform config flags
+ * @build: firmware build id for API version
+ * @guest_count: number of active guests
+ */
+struct sev_user_data_status {
+	__u8 api_major;				/* Out */
+	__u8 api_minor;				/* Out */
+	__u8 state;				/* Out */
+	__u8 owner : 1;				/* Out */
+	__u8 reserved1 : 7;
+	__u32 config : 1;			/* Out */
+	__u32 reserved2 : 23;
+	__u32 build : 8;			/* Out */
+	__u32 guest_count;			/* Out */
+} __attribute__ ((__packed__));
+
+/**
+ * struct sev_user_data_pek_csr - PEK_CSR command parameters
+ *
+ * @address: PEK certificate chain
+ * @length: length of certificate
+ */
+struct sev_user_data_pek_csr {
+	__u64 address;				/* In */
+	__u32 length;				/* In/Out */
+};
+
+/**
+ * struct sev_user_data_cert_import - PEK_CERT_IMPORT command parameters
+ *
+ * @pek_address: PEK certificate chain
+ * @pek_len: length of PEK certificate
+ * @oca_address: OCA certificate chain
+ * @oca_len: length of OCA certificate
+ */
+struct sev_user_data_pek_cert_import {
+	__u64 pek_cert_address;			/* In */
+	__u32 pek_cert_len;			/* In */
+	__u64 oca_cert_address;			/* In */
+	__u32 oca_cert_len;			/* In */
+};
+
+/**
+ * struct sev_user_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
+ *
+ * @pdh_address: PDH certificate address
+ * @pdh_len: length of PDH certificate
+ * @cert_chain_address: PDH certificate chain
+ * @cert_chain_len: length of PDH certificate chain
+ */
+struct sev_user_data_pdh_cert_export {
+	__u64 pdh_cert_address;			/* In */
+	__u32 pdh_cert_len;			/* In/Out */
+	__u64 cert_chain_address;		/* In */
+	__u32 cert_chain_len;			/* In/Out */
+};
+
+/**
+ * struct sev_issue_cmd - SEV ioctl parameters
+ *
+ * @cmd: SEV commands to execute
+ * @opaque: pointer to the command structure
+ * @error: SEV FW return code on failure
+ */
+struct sev_issue_cmd {
+	__u32 cmd;				/* In */
+	__u64 data;				/* In */
+	__u32 error;				/* Out */
+};
+
+#define SEV_IOC_TYPE		'S'
+#define SEV_ISSUE_CMD	_IOWR(SEV_IOC_TYPE, 0x0, struct sev_issue_cmd)
+
+#endif /* __PSP_USER_SEV_H */
-- 
2.9.5
