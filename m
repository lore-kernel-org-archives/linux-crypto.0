From: Borislav Petkov <bp@alien8.de>
Subject: Re: [Part2 PATCH v7 20/38] crypto: ccp: Implement
 SEV_PDH_CERT_EXPORT ioctl command
Date: Sun, 5 Nov 2017 12:34:12 +0100
Message-ID: <20171105113412.2xtuifkbmxwrf3ji@pd.tnic>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
 <20171101211623.71496-21-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171101211623.71496-21-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 01, 2017 at 04:16:05PM -0500, Brijesh Singh wrote:
> The SEV_PDH_CERT_EXPORT command can be used to export the PDH and its
> certificate chain. The command is defined in SEV spec section 5.10.

...

> ---
>  drivers/crypto/ccp/psp-dev.c | 98 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)

Fixes ontop:

* !input.cert_chain_address test was repeated. I saw that by aligning
them vertically, i.e., after making it more readable, the repetition
became obvious.

* Do the lengths checks first and the access_ok after, in each PDH and
cert chain test.

* Do the checks first and the allocations after, not interleaved.

* Comments are sentences which should end with a '.'

(hunk below contains also that &psp_master->cmd_buf change but you're going to
 remove that arg anyway).

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 09f69e573d00..d3fdcce61e6d 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -455,14 +455,22 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
 	if (!data)
 		return -ENOMEM;
 
-	/* Userspace wants to query the certificate length */
-	if (!input.pdh_cert_address || !input.pdh_cert_len ||
-	    !input.cert_chain_address || !input.cert_chain_address)
+	/* Userspace wants to query the certificate length. */
+	if (!input.pdh_cert_address ||
+	    !input.pdh_cert_len ||
+	    !input.cert_chain_address)
 		goto cmd;
 
-	/* allocate a physically contiguous buffer to store the PDH blob */
-	if (!access_ok(VERIFY_WRITE, input.pdh_cert_address, input.pdh_cert_len) ||
-	    (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)) {
+	/* allocate a physically contiguous buffer to store the PDH blob. */
+	if ((input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) ||
+	    !access_ok(VERIFY_WRITE, input.pdh_cert_address, input.pdh_cert_len)) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	/* allocate a physically contiguous buffer to store the cert chain blob. */
+	if ((input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) ||
+	    !access_ok(VERIFY_WRITE, input.cert_chain_address, input.cert_chain_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
@@ -476,13 +484,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
 	data->pdh_cert_address = __psp_pa(pdh_blob);
 	data->pdh_cert_len = input.pdh_cert_len;
 
-	/* allocate a physically contiguous buffer to store the cert chain blob */
-	if (!access_ok(VERIFY_WRITE, input.cert_chain_address, input.cert_chain_len) ||
-	    (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)) {
-		ret = -EFAULT;
-		goto e_free_pdh;
-	}
-
 	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
 	if (!cert_blob) {
 		ret = -ENOMEM;
@@ -493,18 +494,16 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
 	data->cert_chain_len = input.cert_chain_len;
 
 cmd:
-	/* If platform is not in INIT state then transition it to INIT */
+	/* If platform is not in INIT state then transition it to INIT. */
 	if (psp_master->sev_state != SEV_STATE_INIT) {
-		ret = __sev_platform_init_locked(psp_master->sev_init, &argp->error);
+		ret = __sev_platform_init_locked(&psp_master->cmd_buf, &argp->error);
 		if (ret)
 			goto e_free_cert;
 	}
 
 	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
 
-	/*
-	 * If we query the length, FW responded with expected data
-	 */
+	/* If we query the length, FW responded with expected data. */
 	input.cert_chain_len = data->cert_chain_len;
 	input.pdh_cert_len = data->pdh_cert_len;
 

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
