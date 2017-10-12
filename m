From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.2 12.2/31] crypto: ccp: Add Secure Encrypted
 Virtualization (SEV) command support
Date: Thu, 12 Oct 2017 16:08:16 +0200
Message-ID: <20171012140816.6siefvahj6ww7uzf@pd.tnic>
References: <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171011165030.115696-1-brijesh.singh@amd.com>
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
In-Reply-To: <20171011165030.115696-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 11, 2017 at 11:50:30AM -0500, Brijesh Singh wrote:
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
> Make it as a second patch in the series (changes from 12.1 -> 12.2)
> 
> Changes since v5.1:
>  * text streamlining (from Boris)
>  * rename sev_handle_cmd -> sev_do_cmd (from Boris)
>  * PSP_P2CMSG needs arg eval (from Boris)
>  * use #ifdef instead of #if defined() (from Boris)
> 
>  drivers/crypto/ccp/psp-dev.c | 251 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/psp-dev.h |  16 +++
>  include/linux/psp-sev.h      | 159 +++++++++++++++++++++++++++
>  3 files changed, 426 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index b5789f878560..175cb3c3b8ef 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -23,9 +23,16 @@
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
> +static DEFINE_MUTEX(sev_cmd_mutex);
> +static bool sev_fops_registered;

Well, if you're going to have a global var, why not pull up the misc
device instead?

And mind you, I've moved out this assignments:

+       psp->sev_misc = psp_misc_dev;
+       init_waitqueue_head(&psp->sev_int_queue);
+       dev_info(dev, "registered SEV device\n");

outside of the if-conditional as I'm assuming you want to do this for
each psp device for which sev_ops_init() is called.

Or am I wrong here?

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 175cb3c3b8ef..d50aaa1ca75b 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -31,7 +31,7 @@
 #define DEVICE_NAME	"sev"
 
 static DEFINE_MUTEX(sev_cmd_mutex);
-static bool sev_fops_registered;
+static struct miscdevice *psp_misc_dev;
 
 static struct psp_device *psp_alloc_struct(struct sp_device *sp)
 {
@@ -242,7 +242,6 @@ EXPORT_SYMBOL_GPL(sev_guest_df_flush);
 static int sev_ops_init(struct psp_device *psp)
 {
 	struct device *dev = psp->dev;
-	struct miscdevice *misc;
 	int ret;
 
 	/*
@@ -252,26 +251,24 @@ static int sev_ops_init(struct psp_device *psp)
 	 * sev_do_cmd() finds the right master device to which to issue the
 	 * command to the firmware.
 	 */
-	if (!sev_fops_registered) {
-
-		misc = devm_kzalloc(dev, sizeof(*misc), GFP_KERNEL);
-		if (!misc)
+	if (!psp_misc_dev) {
+		psp_misc_dev = devm_kzalloc(dev, sizeof(struct miscdevice), GFP_KERNEL);
+		if (!psp_misc_dev)
 			return -ENOMEM;
 
-		misc->minor = MISC_DYNAMIC_MINOR;
-		misc->name = DEVICE_NAME;
-		misc->fops = &sev_fops;
+		psp_misc_dev->minor = MISC_DYNAMIC_MINOR;
+		psp_misc_dev->name = DEVICE_NAME;
+		psp_misc_dev->fops = &sev_fops;
 
-		ret = misc_register(misc);
+		ret = misc_register(psp_misc_dev);
 		if (ret)
 			return ret;
-
-		sev_fops_registered = true;
-		psp->sev_misc = misc;
-		init_waitqueue_head(&psp->sev_int_queue);
-		dev_info(dev, "registered SEV device\n");
 	}
 
+	psp->sev_misc = psp_misc_dev;
+	init_waitqueue_head(&psp->sev_int_queue);
+	dev_info(dev, "registered SEV device\n");
+
 	return 0;
 }
 
@@ -288,8 +285,8 @@ static int sev_init(struct psp_device *psp)
 
 static void sev_exit(struct psp_device *psp)
 {
-	if (psp->sev_misc)
-		misc_deregister(psp->sev_misc);
+	if (psp_misc_dev)
+		misc_deregister(psp_misc_dev);
 }
 
 int psp_dev_init(struct sp_device *sp)

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
