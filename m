From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 22/32] kvm: svm: prepare to reserve asid for SEV guest
Date: Thu, 2 Mar 2017 10:16:56 -0500
Message-ID: <148846781666.2349.1816322796563357670.stgit__11192.3443772413$1488470185$gmane$org@brijesh-build-machine>
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
Received: from mail-bn3nam01on0087.outbound.protection.outlook.com ([104.47.33.87]:52544
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753362AbdCBPwB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 10:52:01 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In current implementation, asid allocation starts from 1, this patch
adds a min_asid variable in svm_vcpu structure to allow starting asid
from something other than 1.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b581499..8d8fe62 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -507,6 +507,7 @@ struct svm_cpu_data {
 	u64 asid_generation;
 	u32 max_asid;
 	u32 next_asid;
+	u32 min_asid;
 	struct kvm_ldttss_desc *tss_desc;
 
 	struct page *save_area;
@@ -763,6 +764,7 @@ static int svm_hardware_enable(void)
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	sd->next_asid = sd->max_asid + 1;
+	sd->min_asid = 1;
 
 	native_store_gdt(&gdt_descr);
 	gdt = (struct desc_struct *)gdt_descr.address;
@@ -2026,7 +2028,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 {
 	if (sd->next_asid > sd->max_asid) {
 		++sd->asid_generation;
-		sd->next_asid = 1;
+		sd->next_asid = sd->min_asid;
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ALL_ASID;
 	}
 
