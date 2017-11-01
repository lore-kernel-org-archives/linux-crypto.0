From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v7 15/38] crypto: ccp: Implement SEV_PLATFORM_STATUS ioctl command
Date: Wed,  1 Nov 2017 16:16:00 -0500
Message-ID: <20171101211623.71496-16-brijesh.singh@amd.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0087.outbound.protection.outlook.com ([104.47.33.87]:27280
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933175AbdKAVRD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2017 17:17:03 -0400
In-Reply-To: <20171101211623.71496-1-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The SEV_PLATFORM_STATUS command can be used by the platform owner to
get the current status of the platform. The command is defined in
SEV spec section 5.5.

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
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index a757bd1c34e8..ef473ec4a413 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -270,6 +270,21 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
 	return __sev_do_cmd_locked(SEV_CMD_FACTORY_RESET, 0, &argp->error);
 }
 
+static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_status *data = psp_master->sev_status;
+	int ret;
+
+	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
+	if (ret)
+		return ret;
+
+	if (copy_to_user((void __user *)argp->data, data, sizeof(*data)))
+		ret = -EFAULT;
+
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -295,6 +310,9 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 	case SEV_FACTORY_RESET:
 		ret = sev_ioctl_do_reset(&input);
 		break;
+	case SEV_PLATFORM_STATUS:
+		ret = sev_ioctl_do_platform_status(&input);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.9.5
