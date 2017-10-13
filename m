From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.7/31] crypto: ccp: Implement SEV_PEK_CSR
 ioctl command
Date: Fri, 13 Oct 2017 12:20:46 +0200
Message-ID: <20171013102046.ey3mfobd7fum46pf@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-7-brijesh.singh@amd.com>
 <20171012195331.bdzwqzyrjc6fi5lj@pd.tnic>
 <d83b3e27-1195-817e-e976-36982e275588@amd.com>
 <df846578-247a-978f-703e-ed6a6d23ee01@amd.com>
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
In-Reply-To: <df846578-247a-978f-703e-ed6a6d23ee01@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 12, 2017 at 11:13:44PM -0500, Brijesh Singh wrote:
> As per the spec, its perfectly legal to pass input.address = 0x0 and
> input.length = 0x0. If userspace wants to query CSR length then it will
> fill all the fields with. In response, FW will return error
> (LENGTH_TO_SMALL) and input.length will be filled with the expected
> length. Several command work very similar (e.g PEK_CSR,
> PEK_CERT_EXPORT). A typical usage from userspace will be:
> 
> - query the length of the blob (call command with all fields set to zero)
> - SEV FW will response with expected length
> - userspace allocate the blob and retries the command. 

Ok, let's make that a clearer and more precise by explicitly checking
the query case:

+       /* Userspace wants to query CSR length */
+       if (!input.address && !input.length)
+               goto cmd;

and commenting why we're doing this.

The rest is cleanups.

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index e3ee68afd068..e10f507f9a60 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -299,36 +299,37 @@ static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
 	struct sev_user_data_pek_csr input;
 	struct sev_data_pek_csr *data;
 	int do_shutdown = 0;
+	void *blob = NULL;
 	int ret, state;
-	void *blob;
 
-	if (copy_from_user(&input, (void __user *)(uintptr_t)argp->data,
-			   sizeof(struct sev_user_data_pek_csr)))
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
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
+	/* Userspace wants to query CSR length */
+	if (!input.address && !input.length)
+		goto cmd;
 
-		blob = kmalloc(input.length, GFP_KERNEL);
-		if (!blob) {
-			ret = -ENOMEM;
-			goto e_free;
-		}
+	/* allocate a physically contiguous buffer to store the CSR blob */
+	if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
+	    input.length > SEV_FW_BLOB_MAX_SIZE) {
+		ret = -EFAULT;
+		goto e_free;
+	}
 
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
+cmd:
 	ret = sev_platform_get_state(&state, &argp->error);
 	if (ret)
 		goto e_free_blob;
@@ -349,25 +350,26 @@ static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
 		do_shutdown = 1;
 	}
 
-	ret = sev_handle_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
 
+	/*
+	 * If we query the CSR length, FW responded with the expected length.
+	 */
 	input.length = data->len;
 
-	/* copy blob to userspace */
-	if (blob &&
-	    copy_to_user((void __user *)(uintptr_t)input.address,
-			blob, input.length)) {
-		ret = -EFAULT;
-		goto e_shutdown;
+	if (blob) {
+		if (copy_to_user((void __user *)input.address, blob, input.length)) {
+			ret = -EFAULT;
+			goto e_shutdown;
+		}
 	}
 
-	if (copy_to_user((void __user *)(uintptr_t)argp->data, &input,
-			 sizeof(struct sev_user_data_pek_csr)))
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
 		ret = -EFAULT;
 
 e_shutdown:
 	if (do_shutdown)
-		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+		sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
 e_free_blob:
 	kfree(blob);
 e_free:

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
