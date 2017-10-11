From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.2 12.3/31] crypto: ccp: Implement SEV_FACTORY_RESET ioctl command
Date: Wed, 11 Oct 2017 11:55:21 -0500
Message-ID: <20171011165521.115904-1-brijesh.singh@amd.com>
References: <20171007010607.78088-3-brijesh.singh@amd.com>
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
In-Reply-To: <20171007010607.78088-3-brijesh.singh@amd.com>
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
---

Changes since v5.1:
 * rename sev_handle_cmd -> sev_do_cmd (from Boris)
 * skip copy_to_user when invalid cmd id is passed (from Boris)
 * use SEV_MAX instead of SEV_CMD_MAX to check for invalid command

 drivers/crypto/ccp/psp-dev.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 175cb3c3b8ef..a9c885a39910 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -179,7 +179,34 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
-	return -ENOTTY;
+	void __user *argp = (void __user *)arg;
+	struct sev_issue_cmd input;
+	int ret = -EFAULT;
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
+	switch (input.cmd) {
+
+	case SEV_FACTORY_RESET: {
+		ret = sev_do_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
+		break;
+	}
+	default:
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (copy_to_user(argp, &input, sizeof(struct sev_issue_cmd)))
+		ret = -EFAULT;
+out:
+	return ret;
 }
 
 static const struct file_operations sev_fops = {
-- 
2.9.5
