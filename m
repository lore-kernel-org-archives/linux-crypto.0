From: Borislav Petkov <bp@suse.de>
Subject: Re: [Part2 PATCH v5.1 12.8/31] crypto: ccp: Implement
 SEV_PEK_CERT_IMPORT ioctl command
Date: Fri, 13 Oct 2017 16:53:44 +0200
Message-ID: <20171013145344.wfll3ltikl26zj2y@pd.tnic>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
 <20171007010607.78088-8-brijesh.singh@amd.com>
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
In-Reply-To: <20171007010607.78088-8-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 06, 2017 at 08:06:06PM -0500, Brijesh Singh wrote:
> The SEV_PEK_CERT_IMPORT command can be used to import the signed PEK
> certificate. The command is defined in SEV spec section 5.8.
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
>  drivers/crypto/ccp/psp-dev.c | 97 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)

Just minor cleanups, otherwise looks ok.

---
diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 25a437c8d532..e61758af288f 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -392,7 +392,7 @@ static void *copy_user_blob(u64 __user uaddr, u32 len)
 	if (!data)
 		return ERR_PTR(-ENOMEM);
 
-	if (copy_from_user(data, (void __user *)(uintptr_t)uaddr, len))
+	if (copy_from_user(data, (void __user *)uaddr, len))
 		goto e_free;
 
 	return data;
@@ -409,8 +409,7 @@ static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
 	int ret, state, do_shutdown = 0;
 	void *pek_blob, *oca_blob;
 
-	if (copy_from_user(&input, (void __user *)(uintptr_t) argp->data,
-			   sizeof(struct sev_user_data_pek_cert_import)))
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
@@ -456,10 +455,10 @@ static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
 		do_shutdown = 1;
 	}
 
-	ret = sev_handle_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
+	ret = sev_do_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
 
 	if (do_shutdown)
-		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+		sev_do_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
 
 e_free_oca:
 	kfree(oca_blob);
@@ -503,14 +502,14 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_pdh_gen(&input);
 		break;
 
-	case SEV_PEK_CSR: {
+	case SEV_PEK_CSR:
 		ret = sev_ioctl_pek_csr(&input);
 		break;
-	}
-	case SEV_PEK_CERT_IMPORT: {
+
+	case SEV_PEK_CERT_IMPORT:
 		ret = sev_ioctl_pek_cert_import(&input);
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
