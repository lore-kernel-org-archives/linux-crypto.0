From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v7 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 2 Nov 2017 18:10:17 +0100
Message-ID: <20171102171017.t7auzgm7zqp4ncjb@pd.tnic>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-14-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171101211623.71496-14-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 01, 2017 at 04:15:58PM -0500, Brijesh Singh wrote:
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
>  drivers/crypto/ccp/psp-dev.c | 350 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  24 +++
>  drivers/crypto/ccp/sp-dev.c  |   9 ++
>  drivers/crypto/ccp/sp-dev.h  |   4 +
>  include/linux/psp-sev.h      | 143 ++++++++++++++++++
>  5 files changed, 530 insertions(+)

Some more cleanups:

* If sev_data_init is per psp_device, you can simply embed it in the
struct psp_device and save yourself the complete allocation.

* s/sev_ops_init/sev_misc_init/ because it doesn't do anything ops-like

* save some header lines.

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index c61ca16096ca..81c70f9ce23c 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -186,7 +186,7 @@ static int __sev_platform_init_locked(struct sev_data_init *data, int *error)
 		return 0;
 
 	if (!data)
-		data = psp->sev_init;
+		data = &psp->cmd_buf;
 
 	rc = __sev_do_cmd_locked(SEV_CMD_INIT, data, error);
 	if (rc)
@@ -282,7 +282,7 @@ static void sev_exit(struct kref *ref)
 	misc_deregister(&misc_dev->misc);
 }
 
-static int sev_ops_init(struct psp_device *psp)
+static int sev_misc_init(struct psp_device *psp)
 {
 	struct device *dev = psp->dev;
 	int ret;
@@ -319,10 +319,6 @@ static int sev_ops_init(struct psp_device *psp)
 	if (!psp->sev_status)
 		return -ENOMEM;
 
-	psp->sev_init = devm_kzalloc(dev, sizeof(*psp->sev_init), GFP_KERNEL);
-	if (!psp->sev_init)
-		return -ENOMEM;
-
 	init_waitqueue_head(&psp->sev_int_queue);
 	psp->sev_misc = misc_dev;
 	dev_dbg(dev, "registered SEV device\n");
@@ -338,7 +334,7 @@ static int sev_init(struct psp_device *psp)
 		return 1;
 	}
 
-	return sev_ops_init(psp);
+	return sev_misc_init(psp);
 }
 
 int psp_dev_init(struct sp_device *sp)
diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
index 2236d6749d2e..fa62ff50912b 100644
--- a/drivers/crypto/ccp/psp-dev.h
+++ b/drivers/crypto/ccp/psp-dev.h
@@ -77,7 +77,7 @@ struct psp_device {
 	wait_queue_head_t sev_int_queue;
 	struct sev_misc_dev *sev_misc;
 	struct sev_user_data_status *sev_status;
-	struct sev_data_init *sev_init;
+	struct sev_data_init cmd_buf;
 };
 
 #endif /* __PSP_DEV_H */
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index fb563248d9a9..d57cd7625a9f 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -626,11 +626,7 @@ sev_guest_activate(struct sev_data_activate *data, int *error) { return -ENODEV;
 static inline int sev_guest_df_flush(int *error) { return -ENODEV; }
 
 static inline int
-sev_issue_cmd_external_user(struct file *filep,
-			    unsigned int id, void *data, int *error)
-{
-	return -ENODEV;
-}
+sev_issue_cmd_external_user(struct file *filep, unsigned int id, void *data, int *error) { return -ENODEV; }
 
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
