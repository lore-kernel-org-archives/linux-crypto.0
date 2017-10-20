From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v6 18/38] crypto: ccp: Implement SEV_PEK_CSR ioctl command
Date: Thu, 19 Oct 2017 21:33:53 -0500
Message-ID: <20171020023413.122280-19-brijesh.singh@amd.com>
References: <20171020023413.122280-1-brijesh.singh@amd.com>
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
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: kvm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171020023413.122280-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

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
 drivers/crypto/ccp/psp-dev.c | 69 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index d9771d104eea..26a365c9b0e0 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -213,6 +213,72 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_csr input;
+	struct sev_data_pek_csr *data;
+	void *blob = NULL;
+	int ret, err;
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
+	ret = sev_platform_init(NULL, &argp->error);
+	if (ret)
+		goto e_free_blob;
+
+	ret = sev_do_cmd(SEV_CMD_PEK_CSR, data, &argp->error);
+
+	/*
+	 * If we query the CSR length, FW responded with expected data
+	 */
+	input.length = data->len;
+
+	if (blob) {
+		if (copy_to_user((void __user *)input.address, blob, input.length))
+			ret = -EFAULT;
+	}
+
+	if (sev_platform_shutdown(&err)) {
+		ret = -EIO;
+		argp->error = err;
+	}
+
+	if (copy_to_user((void __user *)argp->data, &input, sizeof(input)))
+		ret = -EFAULT;
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
@@ -242,6 +308,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
