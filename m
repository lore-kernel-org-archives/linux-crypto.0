From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 27/32] kvm: svm: Add support for SEV LAUNCH_FINISH
 command
Date: Thu, 2 Mar 2017 10:17:56 -0500
Message-ID: <148846787592.2349.5101158172858135011.stgit__23784.9722769626$1488488576$gmane$org@brijesh-build-machine>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
        <brijesh.singh@amd.com>, <kvm@vger.kernel.org>,
        <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
        <linux-pci@vger.kernel.org>, <linus.walleij@linaro.org>,
        <gary.hook@amd.com>, <linux-mm@kvack.org>,
        <paul.gortmaker@windriver.com>, <hpa@zytor.com>, <cl@linux.com>,
        <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <peterz@infradead.org>, <piotr.luc@intel.com>, <mingo@redhat.com>,
        <msalter@redhat.com>, <ross.zwisler@linux.intel.com>, <bp@suse.de>,
        <dyoung@redhat.com>, <thomas.lendacky@amd.com>, <jroedel@suse.de>,
        <keescook@chromium.org>, <arnd@arndb.de>, <toshi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0080.outbound.protection.outlook.com ([104.47.40.80]:10583
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751029AbdCBVCj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 16:02:39 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The command is used for finializing the SEV guest launch process.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 62c2b22..c108064 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5921,6 +5921,38 @@ static int sev_launch_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_launch_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	int i, ret;
+	struct sev_data_launch_finish *data;
+	struct kvm_vcpu *vcpu;
+
+	if (!sev_guest(kvm))
+		return -EINVAL;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* launch finish */
+	data->handle = sev_get_handle(kvm);
+	ret = sev_issue_cmd(kvm, SEV_CMD_LAUNCH_FINISH, data, &argp->error);
+	if (ret)
+		goto err_1;
+
+	/* Iterate through each vcpus and set SEV KVM_SEV_FEATURE bit in
+	 * KVM_CPUID_FEATURE to indicate that SEV is enabled on this vcpu
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		sev_init_vmcb(to_svm(vcpu));
+		svm_cpuid_update(vcpu);
+	}
+
+err_1:
+	kfree(data);
+	return ret;
+}
+
 static int amd_memory_encryption_cmd(struct kvm *kvm, void __user *argp)
 {
 	int r = -ENOTTY;
@@ -5940,6 +5972,10 @@ static int amd_memory_encryption_cmd(struct kvm *kvm, void __user *argp)
 		r = sev_launch_update_data(kvm, &sev_cmd);
 		break;
 	}
+	case KVM_SEV_LAUNCH_FINISH: {
+		r = sev_launch_finish(kvm, &sev_cmd);
+		break;
+	}
 	default:
 		break;
 	}
