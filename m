From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v7 20/38] crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command
Date: Wed,  1 Nov 2017 16:16:05 -0500
Message-ID: <20171101211623.71496-21-brijesh.singh@amd.com>
References: <20171101211623.71496-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: bp@alien8.de, Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171101211623.71496-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The SEV_PDH_CERT_EXPORT command can be used to export the PDH and its
certificate chain. The command is defined in SEV spec section 5.10.

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
Acked-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 98 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 2648faf33a19..96739ff105e6 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -441,6 +441,101 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pdh_cert_export input;
+	void *pdh_blob = NULL, *cert_blob = NULL;
+	struct sev_data_pdh_cert_export *data;
+	int ret;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* Userspace wants to query the certificate length */
+	if (!input.pdh_cert_address || !input.pdh_cert_len ||
+	    !input.cert_chain_address || !input.cert_chain_address)
+		goto cmd;
+
+	/* allocate a physically contiguous buffer to store the PDH blob */
+	if (!access_ok(VERIFY_WRITE, input.pdh_cert_address, input.pdh_cert_len) ||
+	    (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
+	if (!pdh_blob) {
+		ret = -ENOMEM;
+		goto e_free;
+	}
+
+	data->pdh_cert_address = __psp_pa(pdh_blob);
+	data->pdh_cert_len = input.pdh_cert_len;
+
+	/* allocate a physically contiguous buffer to store the cert chain blob */
+	if (!access_ok(VERIFY_WRITE, input.cert_chain_address, input.cert_chain_len) ||
+	    (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)) {
+		ret = -EFAULT;
+		goto e_free_pdh;
+	}
+
+	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
+	if (!cert_blob) {
+		ret = -ENOMEM;
+		goto e_free_pdh;
+	}
+
+	data->cert_chain_address = __psp_pa(cert_blob);
+	data->cert_chain_len = input.cert_chain_len;
+
+cmd:
+	/* If platform is not in INIT state then transition it to INIT */
+	if (psp_master->sev_state != SEV_STATE_INIT) {
+		ret = __sev_platform_init_locked(psp_master->sev_init, &argp->error);
+		if (ret)
+			goto e_free_cert;
+	}
+
+	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
+
+	/*
+	 * If we query the length, FW responded with expected data
+	 */
+	input.cert_chain_len = data->cert_chain_len;
+	input.pdh_cert_len = data->pdh_cert_len;
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
+		ret = -EFAULT;
+		goto e_free_cert;
+	}
+
+	if (pdh_blob) {
+		if (copy_to_user((void __user *)input.pdh_cert_address,
+				 pdh_blob, input.pdh_cert_len)) {
+			ret = -EFAULT;
+			goto e_free_cert;
+		}
+	}
+
+	if (cert_blob) {
+		if (copy_to_user((void __user *)input.cert_chain_address,
+				 cert_blob, input.cert_chain_len))
+			ret = -EFAULT;
+	}
+
+e_free_cert:
+	kfree(cert_blob);
+e_free_pdh:
+	kfree(pdh_blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -481,6 +576,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_PEK_CERT_IMPORT:
 		ret = sev_ioctl_do_pek_import(&input);
 		break;
+	case SEV_PDH_CERT_EXPORT:
+		ret = sev_ioctl_do_pdh_export(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.9.5
