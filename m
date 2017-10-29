From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v6.1 14/38] crypto: ccp: Implement SEV_FACTORY_RESET ioctl command
Date: Sun, 29 Oct 2017 16:16:40 -0500
Message-ID: <20171029211640.18507-1-brijesh.singh@amd.com>
References: <20171020023413.122280-15-brijesh.singh@amd.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171020023413.122280-15-brijesh.singh@amd.com>
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

Boris,

It may look confusing that we call PLATFORM_STATUS command to check the
current FW state even when we keep the state in psp->sev_state.
Per spec, PLATFORM_INIT transitions FW from UINIT -> INIT and SHUTDOWN from
<ANY_STATE> -> UINIT but there are multiple commands which can transition FW
from INIT -> WORKING state. Hence my thinking is, if we really need to know
whether we are in WORKING state then invoke PLATFORM_STATUS. So far,
FACTORY_RESET is where we need to know if we are in WORKING state to avoid
shutdown the FW. In real world app this command may not be used that
often hence I don't feel like adding more complexity to the code.

Changes since v6:
 * If FW is in WORKING state then reject the command
 * If FW is in INIT state then shutdown before issuing the command


 drivers/crypto/ccp/psp-dev.c | 77 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 060f57ac08b3..b02ea56508b4 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -177,9 +177,84 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 	return rc;
 }
 
+static int sev_platform_state(int *state, int *error)
+{
+	struct sev_user_data_status *data;
+	int rc;
+
+	data = kzalloc(sizeof (*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	rc = sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, error);
+	if (rc)
+		goto e_free;
+
+	*state = data->state;
+
+e_free:
+	kfree(data);
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
+		rc = sev_platform_shutdown_locked(&argp->error);
+		if (rc)
+			return rc;
+	}
+
+	return sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, 0, &argp->error);
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
