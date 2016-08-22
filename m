From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 19/28] KVM: SVM: prepare to reserve asid for SEV guest
Date: Mon, 22 Aug 2016 19:27:45 -0400
Message-ID: <147190846546.9523.8365293594479732082.stgit__44233.8971574374$1471910618$gmane$org@brijesh-build-machine>
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
Received: from mail-sn1nam01on0088.outbound.protection.outlook.com ([104.47.32.88]:55566
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752800AbcHWADL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 20:03:11 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In current implementation, asid allocation starts from 1, this patch
adds a min_asid variable in svm_vcpu structure to allow starting asid
from something other than 1.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 211be94..f010b23 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -470,6 +470,7 @@ struct svm_cpu_data {
 	u64 asid_generation;
 	u32 max_asid;
 	u32 next_asid;
+	u32 min_asid;
 	struct kvm_ldttss_desc *tss_desc;
 
 	struct page *save_area;
@@ -726,6 +727,7 @@ static int svm_hardware_enable(void)
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	sd->next_asid = sd->max_asid + 1;
+	sd->min_asid = 1;
 
 	native_store_gdt(&gdt_descr);
 	gdt = (struct desc_struct *)gdt_descr.address;
@@ -1887,7 +1889,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 {
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
-		sd->next_asid = 1;
+		sd->next_asid = sd->min_asid;
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 
