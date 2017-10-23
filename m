From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v6.1 16/38] crypto: ccp: Implement SEV_PEK_GEN ioctl command
Date: Mon, 23 Oct 2017 16:55:19 -0500
Message-ID: <20171023215519.32512-1-brijesh.singh@amd.com>
References: <20171020023413.122280-17-brijesh.singh@amd.com>
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
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2nam01on0078.outbound.protection.outlook.com ([104.47.34.78]:62941
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932206AbdJWVze (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Oct 2017 17:55:34 -0400
In-Reply-To: <20171020023413.122280-17-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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

Changes since v6:
 * when sev_do_cmd() and sev_platform_shutdown() fails then propogate
   the error status code from sev_do_cmd() because it can give us
   much better reason for the failure.

 drivers/crypto/ccp/psp-dev.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index dd4bab143de9..18e2d8291997 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -195,6 +195,34 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 	return ret;
 }
 
+static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
+{
+	int ret, err;
+
+	ret = sev_platform_init(NULL, &argp->error);
+	if (ret)
+		return ret;
+
+	ret = sev_do_cmd(cmd, 0, &argp->error);
+
+	if (sev_platform_shutdown(&err)) {
+		/*
+		 * If both sev_do_cmd() and sev_platform_shutdown() commands
+		 * failed then propogate the error code from the sev_do_cmd()
+		 * because it contains a useful status code for the command
+		 * failure.
+		 */
+		if (ret)
+			goto done;
+
+		argp->error = err;
+		ret = -EIO;
+	}
+
+done:
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -218,6 +246,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
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
