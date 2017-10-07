From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.1 12.6/31] crypto: ccp: Implement SEV_PDH_GEN ioctl command
Date: Fri,  6 Oct 2017 20:06:04 -0500
Message-ID: <20171007010607.78088-6-brijesh.singh@amd.com>
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

The SEV_PDH_GEN command is used to re-generate the Platform
Diffie-Hellman (PDH) key. The command is defined in SEV spec section
5.9.

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
 drivers/crypto/ccp/psp-dev.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 03d7bd03ad58..28efb7a9245a 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -271,6 +271,34 @@ static int sev_ioctl_pek_gen(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_pdh_gen(struct sev_issue_cmd *argp)
+{
+	int ret, state, do_shutdown = 0;
+
+	/*
+	 * PDH_GEN command can be issued when platform is in INIT or WORKING
+	 * state. If we are in UNINIT state then transition in INIT state
+	 * before issuing the command.
+	 */
+	ret = sev_platform_get_state(&state, &argp->error);
+	if (ret)
+		return ret;
+
+	if (state == SEV_STATE_UNINIT) {
+		ret = sev_firmware_init(&argp->error);
+		if (ret)
+			return ret;
+		do_shutdown = 1;
+	}
+
+	ret = sev_handle_cmd(SEV_CMD_PDH_GEN, 0, &argp->error);
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
@@ -300,6 +328,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_ioctl_pek_gen(&input);
 		break;
 	}
+	case SEV_PDH_GEN: {
+		ret = sev_ioctl_pdh_gen(&input);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.9.5
