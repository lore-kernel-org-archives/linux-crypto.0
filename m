From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v6 13/38] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Mon, 23 Oct 2017 09:34:29 +0200
Message-ID: <20171023073429.GA10952@nazgul.tnic>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
 <20171020023413.122280-14-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.skyhub.de ([5.9.137.197]:60390 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750756AbdJWHeg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 03:34:36 -0400
Content-Disposition: inline
In-Reply-To: <20171020023413.122280-14-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 19, 2017 at 09:33:48PM -0500, Brijesh Singh wrote:
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

Just minor cleanups:

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index e9966d5fc6c4..f9a9a6e6ab99 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -31,7 +31,7 @@
 static DEFINE_MUTEX(sev_cmd_mutex);
 static DEFINE_MUTEX(fw_init_mutex);
 
-static struct sev_misc_dev *sev_misc_dev;
+static struct sev_misc_dev *misc_dev;
 static int fw_init_count;
 
 static struct psp_device *psp_alloc_struct(struct sp_device *sp)
@@ -299,14 +299,14 @@ static int sev_ops_init(struct psp_device *psp)
 	 * sev_do_cmd() finds the right master device to which to issue the
 	 * command to the firmware.
 	 */
-	if (!sev_misc_dev) {
+	if (!misc_dev) {
 		struct miscdevice *misc;
 
-		sev_misc_dev = devm_kzalloc(dev, sizeof(*sev_misc_dev), GFP_KERNEL);
-		if (!sev_misc_dev)
+		misc_dev = devm_kzalloc(dev, sizeof(*misc_dev), GFP_KERNEL);
+		if (!misc_dev)
 			return -ENOMEM;
 
-		misc = &sev_misc_dev->misc;
+		misc = &misc_dev->misc;
 		misc->minor = MISC_DYNAMIC_MINOR;
 		misc->name = DEVICE_NAME;
 		misc->fops = &sev_fops;
@@ -315,13 +315,13 @@ static int sev_ops_init(struct psp_device *psp)
 		if (ret)
 			return ret;
 
-		kref_init(&sev_misc_dev->refcount);
+		kref_init(&misc_dev->refcount);
 	} else {
-		kref_get(&sev_misc_dev->refcount);
+		kref_get(&misc_dev->refcount);
 	}
 
 	init_waitqueue_head(&psp->sev_int_queue);
-	psp->sev_misc = sev_misc_dev;
+	psp->sev_misc = misc_dev;
 	dev_info(dev, "registered SEV device\n");
 
 	return 0;
@@ -340,9 +340,9 @@ static int sev_init(struct psp_device *psp)
 
 static void sev_exit(struct kref *ref)
 {
-	struct sev_misc_dev *sev_dev = container_of(ref, struct sev_misc_dev, refcount);
+	struct sev_misc_dev *misc_dev = container_of(ref, struct sev_misc_dev, refcount);
 
-	misc_deregister(&sev_dev->misc);
+	misc_deregister(&misc_dev->misc);
 }
 
 int psp_dev_init(struct sp_device *sp)
@@ -405,7 +405,7 @@ void psp_dev_destroy(struct sp_device *sp)
 	struct psp_device *psp = sp->psp_data;
 
 	if (psp->sev_misc)
-		kref_put(&sev_misc_dev->refcount, sev_exit);
+		kref_put(&misc_dev->refcount, sev_exit);
 
 	sp_free_psp_irq(sp, psp);
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 21511419bfe6..eac850a97610 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -525,7 +525,7 @@ int sev_platform_shutdown(int *error);
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
  *
- * @init: sev_data_status structure to be processed
+ * @status: sev_user_data_status structure to be processed
  * @error: SEV command return code
  *
  * Returns:

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
