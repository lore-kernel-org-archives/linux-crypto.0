From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v6.1 15/38] crypto: ccp: Implement SEV_PEK_GEN ioctl command
Date: Sun, 29 Oct 2017 22:13:18 -0500
Message-ID: <20171030031318.19055-1-brijesh.singh@amd.com>
References: <20171020023413.122280-16-brijesh.singh@amd.com>
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
In-Reply-To: <20171020023413.122280-16-brijesh.singh@amd.com>
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
Reviewed-by: Borislav Petkov <bp@suse.de>
Improvements-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Gary R Hook <gary.hook@amd.com>
---

Boris,

I had your R-b in v6 and have kept it. The changes in this patch are
very minor. Let me know if you are okay with it - thanks

Changes since v6:
 * use psp->sev_state to check if FW is in correct state before
   doing the INIT transition

 drivers/crypto/ccp/psp-dev.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 24a970809ded..53fbbc41b521 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -240,6 +240,19 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
+{
+	int rc;
+
+	if (psp_master->sev_state == SEV_STATE_UNINIT) {
+		rc = sev_platform_init_locked(NULL, &argp->error);
+		if (rc)
+			return rc;
+	}
+
+	return sev_do_cmd_locked(cmd, 0, &argp->error);
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -268,6 +281,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_PLATFORM_STATUS:
 		ret = sev_ioctl_do_platform_status(&input);
 		break;
+	case SEV_PEK_GEN:
+		ret = sev_ioctl_do_pek_pdh_gen(SEV_CMD_PEK_GEN, &input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.9.5
