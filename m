From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support
Date: Fri,  6 Oct 2017 20:05:59 -0500
Message-ID: <20171007010607.78088-1-brijesh.singh@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: bp@suse.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171004131412.13038-13-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

AMD's new Secure Encrypted Virtualization (SEV) feature allows the
memory contents of virtual machines to be transparently encrypted with a
key unique to the VM. The programming and management of the encryption
keys are handled by the AMD Secure Processor (AMD-SP) which exposes the
commands for these tasks. The complete spec is available at:

http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf

Extend the AMD-SP driver to provide the following support:

 - an in-kernel API to communicate with the SEV firmware. The API can be
   used by the hypervisor to create encryption context for a SEV guest.

 - a userspace IOCTL to manage the platform certificates.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Radim Krčmář" <rkrcmar@redhat.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Gary Hook <gary.hook@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-crypto@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Improvements-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---

Based on Boris feedback split this patch in 9 logical patches, they are
numbers from 12.1 to 12.9.

 drivers/crypto/ccp/psp-dev.c | 244 +++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/psp-dev.h |  17 +++
 include/linux/psp-sev.h      | 159 ++++++++++++++++++++++++++++
 3 files changed, 420 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index b5789f878560..e9b776c3acb2 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -23,9 +23,16 @@
 #include <linux/hw_random.h>
 #include <linux/ccp.h>
 
+#include <uapi/linux/psp-sev.h>
+
 #include "sp-dev.h"
 #include "psp-dev.h"
 
+#define DEVICE_NAME	"sev"
+
+static DEFINE_MUTEX(sev_cmd_mutex);
+static bool sev_fops_registered;
+
 static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 {
 	struct device *dev = sp->dev;
@@ -45,9 +52,239 @@ static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 
 static irqreturn_t psp_irq_handler(int irq, void *data)
 {
+	struct psp_device *psp = data;
+	unsigned int status;
+	int reg;
+
+	/* Read the interrupt status: */
+	status = ioread32(psp->io_regs + PSP_P2CMSG_INTSTS);
+
+	/* Check if it is command completion: */
+	if (!(status & BIT(PSP_CMD_COMPLETE_REG)))
+		goto done;
+
+	/* Check if it is SEV command completion: */
+	reg = ioread32(psp->io_regs + PSP_CMDRESP);
+	if (reg & PSP_CMDRESP_RESP) {
+		psp->sev_int_rcvd = 1;
+		wake_up(&psp->sev_int_queue);
+	}
+
+done:
+	/* Clear the interrupt status by writing the same value we read. */
+	iowrite32(status, psp->io_regs + PSP_P2CMSG_INTSTS);
+
 	return IRQ_HANDLED;
 }
 
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
+static int sev_cmd_buffer_len(int cmd)
+{
+	switch (cmd) {
+	case SEV_CMD_INIT:			return sizeof(struct sev_data_init);
+	case SEV_CMD_PLATFORM_STATUS:		return sizeof(struct sev_data_status);
+	case SEV_CMD_PEK_CSR:			return sizeof(struct sev_data_pek_csr);
+	case SEV_CMD_PEK_CERT_IMPORT:		return sizeof(struct sev_data_pek_cert_import);
+	case SEV_CMD_PDH_CERT_EXPORT:		return sizeof(struct sev_data_pdh_cert_export);
+	case SEV_CMD_LAUNCH_START:		return sizeof(struct sev_data_launch_start);
+	case SEV_CMD_LAUNCH_UPDATE_DATA:	return sizeof(struct sev_data_launch_update_data);
+	case SEV_CMD_LAUNCH_UPDATE_VMSA:	return sizeof(struct sev_data_launch_update_vmsa);
+	case SEV_CMD_LAUNCH_FINISH:		return sizeof(struct sev_data_launch_finish);
+	case SEV_CMD_LAUNCH_MEASURE:		return sizeof(struct sev_data_launch_measure);
+	case SEV_CMD_ACTIVATE:			return sizeof(struct sev_data_activate);
+	case SEV_CMD_DEACTIVATE:		return sizeof(struct sev_data_deactivate);
+	case SEV_CMD_DECOMMISSION:		return sizeof(struct sev_data_decommission);
+	case SEV_CMD_GUEST_STATUS:		return sizeof(struct sev_data_guest_status);
+	case SEV_CMD_DBG_DECRYPT:		return sizeof(struct sev_data_dbg);
+	case SEV_CMD_DBG_ENCRYPT:		return sizeof(struct sev_data_dbg);
+	case SEV_CMD_SEND_START:		return sizeof(struct sev_data_send_start);
+	case SEV_CMD_SEND_UPDATE_DATA:		return sizeof(struct sev_data_send_update_data);
+	case SEV_CMD_SEND_UPDATE_VMSA:		return sizeof(struct sev_data_send_update_vmsa);
+	case SEV_CMD_SEND_FINISH:		return sizeof(struct sev_data_send_finish);
+	case SEV_CMD_RECEIVE_START:		return sizeof(struct sev_data_receive_start);
+	case SEV_CMD_RECEIVE_FINISH:		return sizeof(struct sev_data_receive_finish);
+	case SEV_CMD_RECEIVE_UPDATE_DATA:	return sizeof(struct sev_data_receive_update_data);
+	case SEV_CMD_RECEIVE_UPDATE_VMSA:	return sizeof(struct sev_data_receive_update_vmsa);
+	case SEV_CMD_LAUNCH_UPDATE_SECRET:	return sizeof(struct sev_data_launch_secret);
+	default:				return 0;
+	}
+
+	return 0;
+}
+
+static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
+{
+	unsigned int phys_lsb, phys_msb;
+	struct psp_device *psp;
+	unsigned int reg, ret;
+	struct sp_device *sp;
+
+	sp = sp_get_psp_master_device();
+	if (!sp)
+		return -ENODEV;
+
+	psp = sp->psp_data;
+	if (!psp)
+		return -ENODEV;
+
+	/* Get the physical address of the command buffer */
+	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
+	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
+
+	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x\n",
+		cmd, phys_msb, phys_lsb);
+
+	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
+			     sev_cmd_buffer_len(cmd), false);
+
+	/* Only one command at a time... */
+	mutex_lock(&sev_cmd_mutex);
+
+	iowrite32(phys_lsb, psp->io_regs + PSP_CMDBUFF_ADDR_LO);
+	iowrite32(phys_msb, psp->io_regs + PSP_CMDBUFF_ADDR_HI);
+
+	reg = cmd;
+	reg <<= PSP_CMDRESP_CMD_SHIFT;
+	reg |= PSP_CMDRESP_IOC;
+	iowrite32(reg, psp->io_regs + PSP_CMDRESP);
+
+	ret = sev_wait_cmd_ioc(psp, &reg);
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
+			     sev_cmd_buffer_len(cmd), false);
+	return ret;
+}
+
+static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
+{
+	return -ENOTTY;
+}
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
+	struct miscdevice *misc = &psp->sev_misc;
+	int ret = 0;
+
+	/*
+	 * SEV feature support can be detected on the multiple devices but the
+	 * SEV FW commands must be issued on the master. During probe time we
+	 * do not know the master hence we create /dev/sev on the first device
+	 * probe. sev_handle_cmd() finds the right master device to when issuing
+	 * the command to the firmware.
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
+			dev_info(psp->dev, "registered SEV device\n");
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
@@ -84,11 +321,17 @@ int psp_dev_init(struct sp_device *sp)
 	if (sp->set_psp_master_device)
 		sp->set_psp_master_device(sp);
 
+	ret = sev_init(psp);
+	if (ret)
+		goto e_irq;
+
 	/* Enable interrupt */
 	iowrite32(-1, psp->io_regs + PSP_P2CMSG_INTEN);
 
 	return 0;
 
+e_irq:
+	sp_free_psp_irq(psp->sp, psp);
 e_err:
 	sp->psp_data = NULL;
 
@@ -101,5 +344,6 @@ void psp_dev_destroy(struct sp_device *sp)
 {
 	struct psp_device *psp = sp->psp_data;
 
+	sev_exit(psp);
 	sp_free_psp_irq(sp, psp);
 }
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index 55b7808367c3..6e8f83b41521 100644
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
 
 #endif /* __PSP_DEV_H */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 496375d7f6a9..2b334fd853c9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -512,4 +512,163 @@ struct sev_data_dbg {
 	u32 len;				/* In */
 } __packed;
 
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
+
+/**
+ * sev_issue_cmd_external_user - issue SEV command by other driver with a file
+ * handle.
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
+static inline int
+sev_platform_status(struct sev_data_status *status, int *error) { return -ENODEV; }
+
+static inline int
+sev_platform_init(struct sev_data_init *init, int *error) { return -ENODEV; }
+
+static inline int sev_platform_shutdown(int *error) { return -ENODEV; }
+
+static inline int
+sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
+
+static inline int
+sev_guest_decommission(struct sev_data_decommission *data, int *error) { return -ENODEV; }
+
+static inline int
+sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV; }
+
+static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
+
+static inline int
+sev_issue_cmd_external_user(struct file *filep,
+			    unsigned int id, void *data, int *error)
+{
+	return -ENODEV;
+}
+
+#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
+
 #endif	/* __PSP_SEV_H__ */
-- 
2.9.5
