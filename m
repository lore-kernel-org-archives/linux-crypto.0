From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [Part2 PATCH v5.2 12.4/31] crypto: ccp: Implement SEV_PLATFORM_STATUS ioctl command
Date: Wed, 11 Oct 2017 12:01:26 -0500
Message-ID: <20171011170126.116154-1-brijesh.singh@amd.com>
References: <20171007010607.78088-4-brijesh.singh@amd.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0073.outbound.protection.outlook.com ([104.47.36.73]:43824
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751908AbdJKRBl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 13:01:41 -0400
In-Reply-To: <20171007010607.78088-4-brijesh.singh@amd.com>
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
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---

Changes since v5.1:
 * rename sev_handle_cmd -> sev_do_cmd

 drivers/crypto/ccp/psp-dev.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index a9c885a39910..1f4925cf9ae5 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -177,6 +177,36 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
 	return ret;
 }
 
+static int sev_ioctl_platform_status(struct sev_issue_cmd *argp)
+{
+	struct sev_user_data_status out;
+	struct sev_data_status *data;
+	int ret;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ret = sev_do_cmd(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
+	if (ret)
+		goto e_free;
+
+	out.api_major = data->api_major;
+	out.api_minor = data->api_minor;
+	out.state = data->state;
+	out.owner = data->owner;
+	out.config = data->config;
+	out.build = data->build;
+	out.guest_count = data->guest_count;
+	if (copy_to_user((void __user *)(uintptr_t) argp->data,
+			 &out, sizeof(struct sev_user_data_status)))
+		ret = -EFAULT;
+
+e_free:
+	kfree(data);
+	return ret;
+}
+
 static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
@@ -198,6 +228,10 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
 		ret = sev_do_cmd(SEV_CMD_FACTORY_RESET, 0, &input.error);
 		break;
 	}
+	case SEV_PLATFORM_STATUS: {
+		ret = sev_ioctl_platform_status(&input);
+		break;
+	}
 	default:
 		ret = -EINVAL;
 		goto out;
-- 
2.9.5
