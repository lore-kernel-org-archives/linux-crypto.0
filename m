From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.1/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Sat, 7 Oct 2017 20:40:49 +0200
Message-ID: <20171007184049.jrbxebb4jlciu3hj@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171007010607.78088-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 06, 2017 at 08:05:59PM -0500, Brijesh Singh wrote:
> AMD's new Secure Encrypted Virtualization (SEV) feature allows the
> memory contents of virtual machines to be transparently encrypted with a
> key unique to the VM. The programming and management of the encryption
> keys are handled by the AMD Secure Processor (AMD-SP) which exposes the
> commands for these tasks. The complete spec is available at:
> 
> http://support.amd.com/TechDocs/55766_SEV-KM%20API_Specification.pdf
> 
> Extend the AMD-SP driver to provide the following support:
> 
>  - an in-kernel API to communicate with the SEV firmware. The API can be
>    used by the hypervisor to create encryption context for a SEV guest.
> 
>  - a userspace IOCTL to manage the platform certificates.
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
> Improvements-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
> 
> Based on Boris feedback split this patch in 9 logical patches, they are
> numbers from 12.1 to 12.9.
> 
>  drivers/crypto/ccp/psp-dev.c | 244 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  17 +++
>  include/linux/psp-sev.h      | 159 ++++++++++++++++++++++++++++
>  3 files changed, 420 insertions(+)

A bunch of fixes ontop:

* sev_fops_registered is superfluous if you can use psp->has_sev_fops

* s/sev_handle_cmd/sev_do_cmd/g - it really is sev_do_cmd(). "handle" is
something else.

* Flip misc dev reg logic in sev_ops_init()

* PSP_P2CMSG needs arg eval

* text streamlining

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index e9b776c3acb2..f0e0fc1fb512 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -31,7 +31,6 @@
 #define DEVICE_NAME	"sev"
 
 static DEFINE_MUTEX(sev_cmd_mutex);
-static bool sev_fops_registered;
 
 static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 {
@@ -121,7 +120,7 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
-static int sev_handle_cmd(int cmd, void *data, int *psp_ret)
+static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 {
 	unsigned int phys_lsb, phys_msb;
 	struct psp_device *psp;
@@ -182,26 +181,26 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	return -ENOTTY;
 }
 
-const struct file_operations sev_fops = {
+static const struct file_operations sev_fops = {
 	.owner	= THIS_MODULE,
 	.unlocked_ioctl = sev_ioctl,
 };
 
 int sev_platform_init(struct sev_data_init *data, int *error)
 {
-	return sev_handle_cmd(SEV_CMD_INIT, data, error);
+	return sev_do_cmd(SEV_CMD_INIT, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_platform_init);
 
 int sev_platform_shutdown(int *error)
 {
-	return sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, error);
+	return sev_do_cmd(SEV_CMD_SHUTDOWN, 0, error);
 }
 EXPORT_SYMBOL_GPL(sev_platform_shutdown);
 
 int sev_platform_status(struct sev_data_status *data, int *error)
 {
-	return sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
+	return sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_platform_status);
 
@@ -211,58 +210,58 @@ int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 	if (!filep || filep->f_op != &sev_fops)
 		return -EBADF;
 
-	return sev_handle_cmd(cmd, data, error);
+	return sev_do_cmd(cmd, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 
 int sev_guest_deactivate(struct sev_data_deactivate *data, int *error)
 {
-	return sev_handle_cmd(SEV_CMD_DEACTIVATE, data, error);
+	return sev_do_cmd(SEV_CMD_DEACTIVATE, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_guest_deactivate);
 
 int sev_guest_activate(struct sev_data_activate *data, int *error)
 {
-	return sev_handle_cmd(SEV_CMD_ACTIVATE, data, error);
+	return sev_do_cmd(SEV_CMD_ACTIVATE, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_guest_activate);
 
 int sev_guest_decommission(struct sev_data_decommission *data, int *error)
 {
-	return sev_handle_cmd(SEV_CMD_DECOMMISSION, data, error);
+	return sev_do_cmd(SEV_CMD_DECOMMISSION, data, error);
 }
 EXPORT_SYMBOL_GPL(sev_guest_decommission);
 
 int sev_guest_df_flush(int *error)
 {
-	return sev_handle_cmd(SEV_CMD_DF_FLUSH, 0, error);
+	return sev_do_cmd(SEV_CMD_DF_FLUSH, 0, error);
 }
 EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 
 static int sev_ops_init(struct psp_device *psp)
 {
 	struct miscdevice *misc = &psp->sev_misc;
-	int ret = 0;
+	int ret;
 
 	/*
-	 * SEV feature support can be detected on the multiple devices but the
-	 * SEV FW commands must be issued on the master. During probe time we
-	 * do not know the master hence we create /dev/sev on the first device
-	 * probe. sev_handle_cmd() finds the right master device to when issuing
-	 * the command to the firmware.
+	 * SEV feature support can be detected on multiple devices but the SEV
+	 * FW commands must be issued on the master. During probe, we do not
+	 * know the master hence we create /dev/sev on the first device probe.
+	 * sev_do_cmd() finds the right master device to which to issue the
+	 * command to the firmware.
 	 */
-	if (!sev_fops_registered) {
-		misc->minor = MISC_DYNAMIC_MINOR;
-		misc->name = DEVICE_NAME;
-		misc->fops = &sev_fops;
-
-		ret = misc_register(misc);
-		if (!ret) {
-			sev_fops_registered = true;
-			psp->has_sev_fops = true;
-			init_waitqueue_head(&psp->sev_int_queue);
-			dev_info(psp->dev, "registered SEV device\n");
-		}
+	if (psp->has_sev_fops)
+		return 0;
+
+	misc->minor = MISC_DYNAMIC_MINOR;
+	misc->name = DEVICE_NAME;
+	misc->fops = &sev_fops;
+
+	ret = misc_register(misc);
+	if (!ret) {
+		psp->has_sev_fops = true;
+		init_waitqueue_head(&psp->sev_int_queue);
+		dev_info(psp->dev, "registered SEV device\n");
 	}
 
 	return ret;
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index 6e8f83b41521..60a33f5ff79f 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -36,7 +36,7 @@
 #define PSP_CMDBUFF_ADDR_HI             PSP_C2PMSG(57)
 #define PSP_FEATURE_REG			PSP_C2PMSG(63)
 
-#define PSP_P2CMSG(_num)		(_num << 2)
+#define PSP_P2CMSG(_num)		((_num) << 2)
 #define PSP_CMD_COMPLETE_REG		1
 #define PSP_CMD_COMPLETE		PSP_P2CMSG(PSP_CMD_COMPLETE_REG)
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 2b334fd853c9..10b843cce75f 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -512,8 +512,7 @@ struct sev_data_dbg {
 	u32 len;				/* In */
 } __packed;
 
-#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
-
+#ifdef CONFIG_CRYPTO_DEV_SP_PSP
 /**
  * sev_platform_init - perform SEV INIT command
  *
@@ -562,9 +561,9 @@ int sev_platform_status(struct sev_data_status *status, int *error);
  * sev_issue_cmd_external_user - issue SEV command by other driver with a file
  * handle.
  *
- * The function can be used by other drivers to issue a SEV command on
- * behalf by userspace. The caller must pass a valid SEV file descriptor
- * so that we know that caller has access to SEV device.
+ * This function can be used by other drivers to issue a SEV command on
+ * behalf of userspace. The caller must pass a valid SEV file descriptor
+ * so that we know that it has access to SEV device.
  *
  * @filep - SEV device file pointer
  * @cmd - command to issue

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
