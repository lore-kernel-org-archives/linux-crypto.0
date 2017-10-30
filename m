From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v6.2 18/38] crypto: ccp: Implement SEV_PEK_CSR ioctl command
Date: Sun, 29 Oct 2017 22:23:32 -0500
Message-ID: <20171030032332.19510-1-brijesh.singh@amd.com>
References: <20171023221009.46924-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: bp@alien8.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0046.outbound.protection.outlook.com ([104.47.40.46]:31078
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751857AbdJ3DXt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2017 23:23:49 -0400
In-Reply-To: <20171023221009.46924-1-brijesh.singh@amd.com>
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
Improvements-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
---

Changes since v6.1:
 * use psp->sev_state to check the state before transition to INIT

 drivers/crypto/ccp/psp-dev.c | 68 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 0d4d95bc35ab..e69ac6f6173c 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -253,6 +253,71 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
 	return sev_do_cmd_locked(cmd, 0, &argp->error);
 }
 
+static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_csr input;
+	struct sev_data_pek_csr *data;
+	void *blob = NULL;
+	int ret;
+
+	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* userspace wants to query CSR length */
+	if (!input.address || !input.length)
+		goto cmd;
+
+	/* allocate a physically contiguous buffer to store the CSR blob */
+	if (!access_ok(VERIFY_WRITE, input.address, input.length) ||
+	    input.length > SEV_FW_BLOB_MAX_SIZE) {
+		ret = -EFAULT;
+		goto e_free;
+	}
+
+	blob = kmalloc(input.length, GFP_KERNEL);
+	if (!blob) {
+		ret = -ENOMEM;
+		goto e_free;
+	}
+
+	data->address = __psp_pa(blob);
+	data->len = input.length;
+
+cmd:
+	if (psp_master->sev_state == SEV_STATE_UNINIT) {
+		ret = sev_platform_init_locked(NULL, &argp->error);
+		if (ret)
+			goto e_free_blob;
+	}
+
+	ret = sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
+
+	/*
+	 * If we query the CSR length, FW responded with expected data
+	 */
+	input.length = data->len;
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
+		ret = -EFAULT;
+		goto e_free_blob;
+	}
+
+	if (blob) {
+		if (copy_to_user((void __user *)input.address, blob, input.length))
+			ret = -EFAULT;
+	}
+
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
@@ -287,6 +352,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_PDH_GEN:
 		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PDH_GEN, &input);
 		break;
+	case SEV_PEK_CSR:
+		ret = sev_ioctl_do_pek_csr(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.9.5
