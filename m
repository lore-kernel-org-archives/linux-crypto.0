From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v7 14/38] crypto: ccp: Implement SEV_FACTORY_RESET ioctl command
Date: Wed,  1 Nov 2017 16:15:59 -0500
Message-ID: <20171101211623.71496-15-brijesh.singh@amd.com>
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

The SEV_FACTORY_RESET command can be used by the platform owner to
reset the non-volatile SEV related data. The command is defined in
SEV spec section 5.4

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
 drivers/crypto/ccp/psp-dev.c | 70 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index c61ca16096ca..a757bd1c34e8 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -235,9 +235,77 @@ static int sev_platform_shutdown(int *error)
 	return rc;
 }
 
+static int sev_platform_state(int *state, int *error)
+{
+	int rc;
+
+	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
+				 psp_master->sev_status, error);
+	if (rc)
+		return rc;
+
+	*state = psp_master->sev_status->state;
+	return rc;
+}
+
+static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
+{
+	int state, rc;
+
+	rc = sev_platform_state(&state, &argp->error);
+	if (rc)
+		return rc;
+
+	if (state == SEV_STATE_WORKING) {
+		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
+		return -EBUSY;
+	}
+
+	if (state == SEV_STATE_INIT) {
+		rc = __sev_platform_shutdown_locked(&argp->error);
+		if (rc)
+			return rc;
+	}
+
+	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, 0, &argp->error);
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
-	return -ENOTTY;
+	void __user *argp = (void __user *)arg;
+	struct sev_issue_cmd input;
+	int ret = -EFAULT;
+
+	if (!psp_master)
+		return -ENODEV;
+
+	if (ioctl != SEV_ISSUE_CMD)
+		return -EINVAL;
+
+	if (copy_from_user(&input, argp, sizeof(struct sev_issue_cmd)))
+		return -EFAULT;
+
+	if (input.cmd > SEV_MAX)
+		return -EINVAL;
+
+	mutex_lock(&sev_cmd_mutex);
+
+	switch (input.cmd) {
+
+	case SEV_FACTORY_RESET:
+		ret = sev_ioctl_do_reset(&input);
+		break;
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
+		ret = -EFAULT;
+out:
+	mutex_unlock(&sev_cmd_mutex);
+
+	return ret;
 }
 
 static const struct file_operations sev_fops = {
-- 
2.9.5
