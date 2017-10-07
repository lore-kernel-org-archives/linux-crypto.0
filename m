From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.1 12.9/31] crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command
Date: Fri,  6 Oct 2017 20:06:07 -0500
Message-ID: <20171007010607.78088-9-brijesh.singh@amd.com>
References: <20171004131412.13038-13-brijesh.singh@amd.com>
 <20171007010607.78088-1-brijesh.singh@amd.com>
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
In-Reply-To: <20171007010607.78088-1-brijesh.singh@amd.com>
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 110 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 861c44bf2910..0a069e3c7b8c 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -473,6 +473,112 @@ static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_pdh_cert_export(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pdh_cert_export input;
+	struct sev_data_pdh_cert_export *data;
+	int ret, state, need_shutdown = 0;
+	void *pdh_blob, *cert_blob;
+
+	if (copy_from_user(&input, (void __user *)(uintptr_t)argp->data,
+			   sizeof(struct sev_user_data_pdh_cert_export)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	pdh_blob = NULL;
+	if (input.pdh_cert_address) {
+		if (!access_ok(VERIFY_WRITE, input.pdh_cert_address, input.pdh_cert_len) ||
+		     (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)) {
+			ret = -EFAULT;
+			goto e_free;
+		}
+
+		pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
+		if (!pdh_blob) {
+			ret = -ENOMEM;
+			goto e_free;
+		}
+
+		data->pdh_cert_address = __psp_pa(pdh_blob);
+		data->pdh_cert_len = input.pdh_cert_len;
+	}
+
+	cert_blob = NULL;
+	if (input.cert_chain_address) {
+		if (!access_ok(VERIFY_WRITE, input.cert_chain_address, input.cert_chain_len) ||
+		    (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)) {
+			ret = -EFAULT;
+			goto e_free_pdh;
+		}
+
+		cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
+		if (!cert_blob) {
+			ret = -ENOMEM;
+			goto e_free_pdh;
+		}
+
+		data->cert_chain_address = __psp_pa(cert_blob);
+		data->cert_chain_len = input.cert_chain_len;
+	}
+
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		goto e_free_cert;
+
+	/*
+	 * CERT_EXPORT command can be issued in INIT or WORKING state.
+	 * If we are in UNINIT state then transition to INIT.
+	 */
+	if (state == SEV_STATE_UNINIT) {
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			goto e_free_cert;
+
+		need_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
+
+	input.cert_chain_len = data->cert_chain_len;
+	input.pdh_cert_len = data->pdh_cert_len;
+
+	/* copy certificate length to userspace */
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &input,
+			 sizeof(struct sev_user_data_pdh_cert_export)))
+		ret = -EFAULT;
+
+	if (ret)
+		goto e_shutdown;
+
+	/* copy PDH certificate to userspace */
+	if (pdh_blob &&
+	    copy_to_user((void __user *)(uintptr_t)input.pdh_cert_address,
+			 pdh_blob, input.pdh_cert_len)) {
+		ret = -EFAULT;
+		goto e_shutdown;
+	}
+
+	/* copy certificate chain to userspace */
+	if (cert_blob &&
+	    copy_to_user((void __user *)(uintptr_t)input.cert_chain_address,
+			 cert_blob, input.cert_chain_len))
+		ret = -EFAULT;
+
+e_shutdown:
+	if (need_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
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
@@ -514,6 +620,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_pek_cert_import(&input);
 		break;
 	}
+	case SEV_PDH_CERT_EXPORT: {
+		ret = sev_ioctl_pdh_cert_export(&input);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.9.5
