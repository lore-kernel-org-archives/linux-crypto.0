From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 22/28] KVM: SVM: add SEV launch start command
Date: Mon, 22 Aug 2016 19:28:28 -0400
Message-ID: <147190850830.9523.15876380749386321765.stgit__28382.2477249943$1471909468$gmane$org@brijesh-build-machine>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
        <brijesh.singh@amd.com>, <kvm@vger.kernel.org>,
        <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
        <linus.walleij@linaro.org>, <linux-mm@kvack.org>,
        <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <mingo@redhat.com>, <msalter@redhat.com>,
        <ross.zwisler@linux.intel.com>, <bp@suse.de>, <dyoung@redhat.com>,
        <thomas.lendacky@amd.com>, <jroedel@suse.de>,
        <keescook@chromium.org>, <toshi.kani@hpe.com>,
        <mathieu.desnoyers@efficios.com>, <devel@linuxdriverproject.org>,
        <tglx@linutronix.de>, <mchehab@kernel.or
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:45504
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932520AbcHVXoB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 19:44:01 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The command initate the process to launch this guest into
SEV-enabled mode.

For more information on command structure see [1], section 6.1

[1] http://support.amd.com/TechDocs/55766_SEV-KM%20API_Spec.pdf

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm.c |  212 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 209 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index dcee635..0b6da4a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -265,6 +265,9 @@ static unsigned long *sev_asid_bitmap;
 
 static int sev_asid_new(void);
 static void sev_asid_free(int asid);
+static void sev_deactivate_handle(unsigned int handle);
+static void sev_decommission_handle(unsigned int handle);
+static int sev_activate_asid(unsigned int handle, int asid, int *psp_ret);
 
 static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
@@ -1645,9 +1648,18 @@ static void sev_uninit_vcpu(struct vcpu_svm *svm)
 
 	svm_sev_unref();
 
-	for_each_possible_cpu(cpu) {
-		sd = per_cpu(svm_data, cpu);
-		sd->sev_vmcb[asid] = NULL;
+	/* when reference count reaches to zero then free SEV asid and
+	 * deactivate psp handle
+	 */
+	if (!svm_sev_ref_count()) {
+		sev_deactivate_handle(svm_sev_handle());
+		sev_decommission_handle(svm_sev_handle());
+		sev_asid_free(svm_sev_asid());
+
+		for_each_possible_cpu(cpu) {
+			sd = per_cpu(svm_data, cpu);
+			sd->sev_vmcb[asid] = NULL;
+		}
 	}
 }
 
@@ -5196,6 +5208,198 @@ static void sev_asid_free(int asid)
 	clear_bit(asid, sev_asid_bitmap);
 }
 
+static void sev_decommission_handle(unsigned int handle)
+{
+	int ret, psp_ret;
+	struct psp_data_decommission *decommission;
+
+	decommission = kzalloc(sizeof(*decommission), GFP_KERNEL);
+	if (!decommission)
+		return;
+
+	decommission->hdr.buffer_len = sizeof(*decommission);
+	decommission->handle = handle;
+	ret = psp_guest_decommission(decommission, &psp_ret);
+	if (ret)
+		printk(KERN_ERR "SEV: DECOMISSION ret=%d (%#010x)\n",
+				ret, psp_ret);
+
+	kfree(decommission);
+}
+
+static void sev_deactivate_handle(unsigned int handle)
+{
+	int ret, psp_ret;
+	struct psp_data_deactivate *deactivate;
+
+	deactivate = kzalloc(sizeof(*deactivate), GFP_KERNEL);
+	if (!deactivate)
+		return;
+
+	deactivate->hdr.buffer_len = sizeof(*deactivate);
+	deactivate->handle = handle;
+	ret = psp_guest_deactivate(deactivate, &psp_ret);
+	if (ret) {
+		printk(KERN_ERR "SEV: DEACTIVATE ret=%d (%#010x)\n",
+				ret, psp_ret);
+		goto buffer_free;
+	}
+
+	wbinvd_on_all_cpus();
+
+	ret = psp_guest_df_flush(&psp_ret);
+	if (ret)
+		printk(KERN_ERR "SEV: DF_FLUSH ret=%d (%#010x)\n",
+				ret, psp_ret);
+
+buffer_free:
+	kfree(deactivate);
+}
+
+static int sev_activate_asid(unsigned int handle, int asid, int *psp_ret)
+{
+	int ret;
+	struct psp_data_activate *activate;
+
+	wbinvd_on_all_cpus();
+
+	ret = psp_guest_df_flush(psp_ret);
+	if (ret) {
+		printk(KERN_ERR "SEV: DF_FLUSH ret=%d (%#010x)\n",
+				ret, *psp_ret);
+		return ret;
+	}
+
+	activate = kzalloc(sizeof(*activate), GFP_KERNEL);
+	if (!activate)
+		return -ENOMEM;
+
+	activate->hdr.buffer_len = sizeof(*activate);
+	activate->handle = handle;
+	activate->asid   = asid;
+	ret = psp_guest_activate(activate, psp_ret);
+	if (ret)
+		printk(KERN_ERR "SEV: ACTIVATE ret=%d (%#010x)\n",
+				ret, *psp_ret);
+	kfree(activate);
+	return ret;
+}
+
+static int sev_pre_start(struct kvm *kvm, int *asid)
+{
+	int ret;
+
+	/* If guest has active psp handle then deactivate before calling
+	 * launch start.
+	 */
+	if (kvm_sev_guest()) {
+		sev_deactivate_handle(kvm_sev_handle());
+		sev_decommission_handle(kvm_sev_handle());
+		*asid = kvm->arch.sev_info.asid;  /* reuse the asid */
+		ret = 0;
+	} else {
+		/* Allocate new asid for this launch */
+		ret = sev_asid_new();
+		if (ret < 0) {
+			printk(KERN_ERR "SEV: failed to allocate asid\n");
+			return ret;
+		}
+		*asid = ret;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int sev_post_start(struct kvm *kvm, int asid, int handle, int *psp_ret)
+{
+	int ret;
+
+	/* activate asid */
+	ret = sev_activate_asid(handle, asid, psp_ret);
+	if (ret)
+		return ret;
+
+	kvm->arch.sev_info.handle = handle;
+	kvm->arch.sev_info.asid = asid;
+
+	return 0;
+}
+
+static int sev_launch_start(struct kvm *kvm,
+			    struct kvm_sev_launch_start __user *arg,
+			    int *psp_ret)
+{
+	int ret, asid;
+	struct kvm_sev_launch_start params;
+	struct psp_data_launch_start *start;
+
+	/* Get parameter from the user */
+	if (copy_from_user(&params, arg, sizeof(*arg)))
+		return -EFAULT;
+
+	start = kzalloc(sizeof(*start), GFP_KERNEL);
+	if (!start)
+		return -ENOMEM;
+
+	ret = sev_pre_start(kvm, &asid);
+	if (ret)
+		goto err_1;
+
+	start->hdr.buffer_len = sizeof(*start);
+	start->flags  = params.flags;
+	start->policy = params.policy;
+	start->handle = params.handle;
+	memcpy(start->nonce, &params.nonce, sizeof(start->nonce));
+	memcpy(start->dh_pub_qx, &params.dh_pub_qx, sizeof(start->dh_pub_qx));
+	memcpy(start->dh_pub_qy, &params.dh_pub_qy, sizeof(start->dh_pub_qy));
+
+	/* launch start */
+	ret = psp_guest_launch_start(start, psp_ret);
+	if (ret) {
+		printk(KERN_ERR "SEV: LAUNCH_START ret=%d (%#010x)\n",
+			ret, *psp_ret);
+		goto err_2;
+	}
+
+	ret = sev_post_start(kvm, asid, start->handle, psp_ret);
+	if (ret)
+		goto err_2;
+
+	kfree(start);
+	return 0;
+
+err_2:
+	sev_asid_free(asid);
+err_1:
+	kfree(start);
+	return ret;
+}
+
+static int amd_sev_issue_cmd(struct kvm *kvm,
+			     struct kvm_sev_issue_cmd __user *user_data)
+{
+	int r = -ENOTTY;
+	struct kvm_sev_issue_cmd arg;
+
+	if (copy_from_user(&arg, user_data, sizeof(struct kvm_sev_issue_cmd)))
+		return -EFAULT;
+
+	switch (arg.cmd) {
+	case KVM_SEV_LAUNCH_START: {
+		r = sev_launch_start(kvm, (void *)arg.opaque,
+					&arg.ret_code);
+		break;
+	}
+	default:
+		break;
+	}
+
+	if (copy_to_user(user_data, &arg, sizeof(struct kvm_sev_issue_cmd)))
+		r = -EFAULT;
+	return r;
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -5313,6 +5517,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.pmu_ops = &amd_pmu_ops,
 	.deliver_posted_interrupt = svm_deliver_avic_intr,
+
+	.sev_issue_cmd = amd_sev_issue_cmd,
 };
 
 static int __init svm_init(void)
