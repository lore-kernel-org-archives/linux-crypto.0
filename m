From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.1 12.8/31] crypto: ccp: Implement SEV_PEK_CERT_IMPORT ioctl command
Date: Fri,  6 Oct 2017 20:06:06 -0500
Message-ID: <20171007010607.78088-8-brijesh.singh@amd.com>
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

The SEV_PEK_CERT_IMPORT command can be used to import the signed PEK
certificate. The command is defined in SEV spec section 5.8.

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
 drivers/crypto/ccp/psp-dev.c | 97 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 8038ca7aef03..861c44bf2910 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -380,6 +380,99 @@ static int sev_ioctl_pek_csr(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static void *copy_user_blob(u64 __user uaddr, u32 len)
+{
+	void *data;
+
+	if (!uaddr || !len)
+		return ERR_PTR(-EINVAL);
+
+	/* verify that blob length does not exceed our limit */
+	if (len > SEV_FW_BLOB_MAX_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	data = kmalloc(len, GFP_KERNEL);
+	if (!data)
+		return ERR_PTR(-ENOMEM);
+
+	if (copy_from_user(data, (void __user *)(uintptr_t)uaddr, len))
+		goto e_free;
+
+	return data;
+
+e_free:
+	kfree(data);
+	return ERR_PTR(-EFAULT);
+}
+
+static int sev_ioctl_pek_cert_import(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_pek_cert_import input;
+	struct sev_data_pek_cert_import *data;
+	int ret, state, do_shutdown = 0;
+	void *pek_blob, *oca_blob;
+
+	if (copy_from_user(&input, (void __user *)(uintptr_t) argp->data,
+			   sizeof(struct sev_user_data_pek_cert_import)))
+		return -EFAULT;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* copy PEK certificate blobs from userspace */
+	pek_blob = copy_user_blob(input.pek_cert_address, input.pek_cert_len);
+	if (IS_ERR(pek_blob)) {
+		ret = PTR_ERR(pek_blob);
+		goto e_free;
+	}
+
+	data->pek_cert_address = __psp_pa(pek_blob);
+	data->pek_cert_len = input.pek_cert_len;
+
+	/* copy PEK certificate blobs from userspace */
+	oca_blob = copy_user_blob(input.oca_cert_address, input.oca_cert_len);
+	if (IS_ERR(oca_blob)) {
+		ret = PTR_ERR(oca_blob);
+		goto e_free_pek;
+	}
+
+	data->oca_cert_address = __psp_pa(oca_blob);
+	data->oca_cert_len = input.oca_cert_len;
+
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		goto e_free_oca;
+
+	/*
+	 * PEK_CERT_IMPORT command can be issued only when platform is in INIT
+	 * state. If we are in UNINIT state then transition in INIT state
+	 * before issuing the command.
+	 */
+	if (state == SEV_STATE_WORKING) {
+		ret = -EBUSY;
+		goto e_free_oca;
+	} else if (state == SEV_STATE_UNINIT) {
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			goto e_free_oca;
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
+
+	if (do_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+
+e_free_oca:
+	kfree(oca_blob);
+e_free_pek:
+	kfree(pek_blob);
+e_free:
+	kfree(data);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -417,6 +510,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_pek_csr(&input);
 		break;
 	}
+	case SEV_PEK_CERT_IMPORT: {
+		ret = sev_ioctl_pek_cert_import(&input);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.9.5
