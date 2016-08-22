From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 03/28] kvm: svm: Use the hardware provided GPA
 instead of page walk
Date: Mon, 22 Aug 2016 19:24:07 -0400
Message-ID: <147190824754.9523.13923968456167130181.stgit__25312.3562819839$1471909219$gmane$org@brijesh-build-machine>
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
Received: from mail-dm3nam03on0059.outbound.protection.outlook.com ([104.47.41.59]:2944
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756869AbcHVXjX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 19:39:23 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

When a guest causes a NPF which requires emulation, KVM sometimes walks
the guest page tables to translate the GVA to a GPA. This is unnecessary
most of the time on AMD hardware since the hardware provides the GPA in
EXITINFO2.

The only exception cases involve string operations involving rep or
operations that use two memory locations. With rep, the GPA will only be
the value of the initial NPF and with dual memory locations we won't know
which memory address was translated into EXITINFO2.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_emulate.h |    3 +++
 arch/x86/include/asm/kvm_host.h    |    3 +++
 arch/x86/kvm/svm.c                 |    2 ++
 arch/x86/kvm/x86.c                 |   17 ++++++++++++++++-
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index e9cd7be..2d1ac09 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -344,6 +344,9 @@ struct x86_emulate_ctxt {
 	struct read_cache mem_read;
 };
 
+/* String operation identifier (matches the definition in emulate.c) */
+#define CTXT_STRING_OP	(1 << 13)
+
 /* Repeat String Operation Prefix */
 #define REPE_PREFIX	0xf3
 #define REPNE_PREFIX	0xf2
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c38f878..b1dd673 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -667,6 +667,9 @@ struct kvm_vcpu_arch {
 
 	int pending_ioapic_eoi;
 	int pending_external_vector;
+
+	/* GPA available (AMD only) */
+	bool gpa_available;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index fd5a9a8..9b2de7c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4055,6 +4055,8 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
+	vcpu->arch.gpa_available = (exit_code == SVM_EXIT_NPF);
+
 	if (!is_cr_intercept(svm, INTERCEPT_CR0_WRITE))
 		vcpu->arch.cr0 = svm->vmcb->save.cr0;
 	if (npt_enabled)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 78295b0..d6f2f4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4382,7 +4382,19 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 		return 1;
 	}
 
-	*gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
+	/*
+	 * If the exit was due to a NPF we may already have a GPA.
+	 * If the GPA is present, use it to avoid the GVA to GPA table
+	 * walk. Note, this cannot be used on string operations since
+	 * string operation using rep will only have the initial GPA
+	 * from when the NPF occurred.
+	 */
+	if (vcpu->arch.gpa_available &&
+	    !(vcpu->arch.emulate_ctxt.d & CTXT_STRING_OP))
+		*gpa = exception->address;
+	else
+		*gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access,
+						       exception);
 
 	if (*gpa == UNMAPPED_GVA)
 		return -1;
@@ -5504,6 +5516,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 	}
 
 restart:
+	/* Save the faulting GPA (cr2) in the address field */
+	ctxt->exception.address = cr2;
+
 	r = x86_emulate_insn(ctxt);
 
 	if (r == EMULATION_INTERCEPTED)
