From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.1 12.5/31] crypto: ccp: Implement SEV_PEK_GEN ioctl command
Date: Fri,  6 Oct 2017 20:06:03 -0500
Message-ID: <20171007010607.78088-5-brijesh.singh@amd.com>
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

The SEV_PEK_GEN command is used to generate a new Platform Endorsement
Key (PEK). The command is defined in SEV spec section 5.6.

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
 drivers/crypto/ccp/psp-dev.c | 68 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index d68303a06464..03d7bd03ad58 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -207,6 +207,70 @@ static int sev_ioctl_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_platform_get_state(int *state, int *error)
+{
+	struct sev_data_status *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = sev_handle_cmd(SEV_CMD_PLATFORM_STATUS, data, error);
+	if (!ret)
+		*state = data->state;
+
+	kfree(data);
+	return ret;
+}
+
+static int sev_firmware_init(int *error)
+{
+	struct sev_data_init *data;
+	int rc;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	rc = sev_handle_cmd(SEV_CMD_INIT, data, error);
+
+	kfree(data);
+	return rc;
+}
+
+static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
+{
+	int do_shutdown = 0;
+	int ret, state;
+
+	/*
+	 * PEK_GEN command can be issued only when firmware is in INIT state.
+	 * If firmware is in UNINIT state then we transition it in INIT state
+	 * and issue the command.
+	 */
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		return ret;
+
+	if (state == SEV_STATE_WORKING) {
+		return -EBUSY;
+	} else if (state == SEV_STATE_UNINIT) {
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			return ret;
+
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PEK_GEN, 0, &argp->error);
+
+	if (do_shutdown)
+		sev_handle_cmd(SEV_CMD_SHUTDOWN, 0, NULL);
+
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -232,6 +296,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_platform_status(&input);
 		break;
 	}
+	case SEV_PEK_GEN: {
+		ret = sev_ioctl_pek_gen(&input);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.9.5
