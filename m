From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.1 12.7/31] crypto: ccp: Implement SEV_PEK_CSR ioctl command
Date: Fri,  6 Oct 2017 20:06:05 -0500
Message-ID: <20171007010607.78088-7-brijesh.singh@amd.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0081.outbound.protection.outlook.com ([104.47.32.81]:49120
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753137AbdJGBGa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 21:06:30 -0400
In-Reply-To: <20171007010607.78088-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SEV_PEK_CSR command can be used to generate a PEK certificate
signing request. The command is defined in SEV spec section 5.7.

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
 drivers/crypto/ccp/psp-dev.c | 85 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 28efb7a9245a..8038ca7aef03 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -299,6 +299,87 @@ static int sev_ioctl_pdh_gen(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_csr input;
+	struct sev_data_pek_csr *data;
+	int do_shutdown = 0;
+	int ret, state;
+	void *blob;
+
+	if (copy_from_user(&input, (void __user *)(uintptr_t)argp->data,
+			   sizeof(struct sev_user_data_pek_csr)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* allocate a temporary physical contigous buffer to store the CSR blob */
+	blob = NULL;
+	if (input.address) {
+		if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
+		    input.length > SEV_FW_BLOB_MAX_SIZE) {
+			ret = -EFAULT;
+			goto e_free;
+		}
+
+		blob = kmalloc(input.length, GFP_KERNEL);
+		if (!blob) {
+			ret = -ENOMEM;
+			goto e_free;
+		}
+
+		data->address = __psp_pa(blob);
+		data->len = input.length;
+	}
+
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		goto e_free_blob;
+
+	/*
+	 * PEK_CERT command can be issued only when we are in INIT state.
+	 * if current state is WORKING then reject it, if state is UNINIT
+	 * then transition the platform to INIT state before issuing the
+	 * command.
+	 */
+	if (state == SEV_STATE_WORKING) {
+		ret = -EBUSY;
+		goto e_free_blob;
+	} else if (state == SEV_STATE_UNINIT) {
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			goto e_free_blob;
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
+
+	input.length = data->len;
+
+	/* copy blob to userspace */
+	if (blob &&
+	    copy_to_user((void __user *)(uintptr_t)input.address,
+			blob, input.length)) {
+		ret = -EFAULT;
+		goto e_shutdown;
+	}
+
+	if (copy_to_user((void __user *)(uintptr_t)argp->data, &input,
+			 sizeof(struct sev_user_data_pek_csr)))
+		ret = -EFAULT;
+
+e_shutdown:
+	if (do_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+e_free_blob:
+	kfree(blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -332,6 +413,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_pdh_gen(&input);
 		break;
 	}
+	case SEV_PEK_CSR: {
+		ret = sev_ioctl_pek_csr(&input);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.9.5
