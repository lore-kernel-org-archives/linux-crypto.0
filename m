From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 05/28] KVM: SVM: prepare for new bit definition in
 nested_ctl
Date: Mon, 22 Aug 2016 19:24:32 -0400
Message-ID: <147190827232.9523.18200019204059963746.stgit__46197.5064863966$1471910849$gmane$org@brijesh-build-machine>
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
Received: from mail-bl2nam02on0076.outbound.protection.outlook.com ([104.47.38.76]:60235
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932973AbcHWAG5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 20:06:57 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

Currently the nested_ctl variable in the vmcb_control_area structure is
used to indicate nested paging support. The nested paging support field
is actually defined as bit 0 of the this field. In order to support a new
feature flag the usage of the nested_ctl and nested paging support must
be converted to operate on a single bit.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h |    2 ++
 arch/x86/kvm/svm.c         |    7 ++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 14824fc..2aca535 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -136,6 +136,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_LOCK_MASK 0x0008ULL
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
+#define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
+
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9b2de7c..9b59260 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1177,7 +1177,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 
 	if (npt_enabled) {
 		/* Setup VMCB for Nested Paging */
-		control->nested_ctl = 1;
+		control->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
 		clr_intercept(svm, INTERCEPT_INVLPG);
 		clr_exception_intercept(svm, PF_VECTOR);
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
@@ -2701,7 +2701,8 @@ static bool nested_vmcb_checks(struct vmcb *vmcb)
 	if (vmcb->control.asid == 0)
 		return false;
 
-	if (vmcb->control.nested_ctl && !npt_enabled)
+	if ((vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) &&
+	    !npt_enabled)
 		return false;
 
 	return true;
@@ -2776,7 +2777,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	else
 		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
 
-	if (nested_vmcb->control.nested_ctl) {
+	if (nested_vmcb->control.nested_ctl & SVM_NESTED_CTL_NP_ENABLE) {
 		kvm_mmu_unload(&svm->vcpu);
 		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
 		nested_svm_init_mmu_context(&svm->vcpu);
