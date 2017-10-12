From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.7/31] crypto: ccp: Implement SEV_PEK_CSR
 ioctl command
Date: Thu, 12 Oct 2017 21:53:31 +0200
Message-ID: <20171012195331.bdzwqzyrjc6fi5lj@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-7-brijesh.singh@amd.com>
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
In-Reply-To: <20171007010607.78088-7-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 06, 2017 at 08:06:05PM -0500, Brijesh Singh wrote:
> The SEV_PEK_CSR command can be used to generate a PEK certificate
> signing request. The command is defined in SEV spec section 5.7.
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
>  drivers/crypto/ccp/psp-dev.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)

Ok, a couple of things here:

* Move the checks first and the allocations second so that you allocate
memory only after all checks have been passed and you don't allocate
pointlessly.

* That:

        if (state == SEV_STATE_WORKING) {
                ret = -EBUSY;
                goto e_free_blob;
        } else if (state == SEV_STATE_UNINIT) {
                ret = sev_firmware_init(&argp->error);
                if (ret)
                        goto e_free_blob;
                do_shutdown = 1;
        }

is a repeating pattern. Perhaps it should be called
sev_firmware_reinit() and called by other functions.

* The rest is simplifications and streamlining.

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index e3ee68afd068..d41f5448a25b 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -302,33 +302,30 @@ static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
 	int ret, state;
 	void *blob;
 
-	if (copy_from_user(&input, (void __user *)(uintptr_t)argp->data,
-			   sizeof(struct sev_user_data_pek_csr)))
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	if (!input.address)
+		return -EINVAL;
+
+	/* allocate a physically contiguous buffer to store the CSR blob */
+	if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
+	    input.length > SEV_FW_BLOB_MAX_SIZE)
 		return -EFAULT;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
-	/* allocate a temporary physical contigous buffer to store the CSR blob */
-	blob = NULL;
-	if (input.address) {
-		if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
-		    input.length > SEV_FW_BLOB_MAX_SIZE) {
-			ret = -EFAULT;
-			goto e_free;
-		}
-
-		blob = kmalloc(input.length, GFP_KERNEL);
-		if (!blob) {
-			ret = -ENOMEM;
-			goto e_free;
-		}
-
-		data->address = __psp_pa(blob);
-		data->len = input.length;
+	blob = kmalloc(input.length, GFP_KERNEL);
+	if (!blob) {
+		ret = -ENOMEM;
+		goto e_free;
 	}
 
+	data->address = __psp_pa(blob);
+	data->len = input.length;
+
 	ret = sev_platform_get_state(&state, &argp->error);
 	if (ret)
 		goto e_free_blob;
@@ -349,25 +346,23 @@ static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
 		do_shutdown = 1;
 	}
 
-	ret = sev_handle_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
 
 	input.length = data->len;
 
 	/* copy blob to userspace */
-	if (blob &&
-	    copy_to_user((void __user *)(uintptr_t)input.address,
-			blob, input.length)) {
+	if (copy_to_user((void __user *)input.address, blob, input.length)) {
 		ret = -EFAULT;
 		goto e_shutdown;
 	}
 
-	if (copy_to_user((void __user *)(uintptr_t)argp->data, &input,
-			 sizeof(struct sev_user_data_pek_csr)))
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
 		ret = -EFAULT;
 
 e_shutdown:
 	if (do_shutdown)
-		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+		ret = sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+
 e_free_blob:
 	kfree(blob);
 e_free:
@@ -408,10 +403,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_pdh_gen(&input);
 		break;
 
-	case SEV_PEK_CSR: {
+	case SEV_PEK_CSR:
 		ret = sev_ioctl_pek_csr(&input);
 		break;
-	}
+
 	default:
 		ret = -EINVAL;
 		goto out;

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
