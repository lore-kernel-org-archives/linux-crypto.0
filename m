From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 06/28] KVM: SVM: Add SEV feature definitions to KVM
Date: Mon, 22 Aug 2016 19:24:46 -0400
Message-ID: <147190828659.9523.13390615310993962670.stgit__7793.80515818975$1471910362$gmane$org@brijesh-build-machine>
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
Received: from mail-cys01nam02on0065.outbound.protection.outlook.com ([104.47.37.65]:41796
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756934AbcHVX62 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 19:58:28 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

Define a new KVM cpu feature for Secure Encrypted Virtualization (SEV).
The kernel will check for the presence of this feature to determine if
it is running with SEV active.

Define the SEV enable bit for the VMCB control structure. The hypervisor
will use this bit to enable SEV in the guest.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/svm.h           |    1 +
 arch/x86/include/uapi/asm/kvm_para.h |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 2aca535..fba2a7b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -137,6 +137,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_VM_CR_SVM_DIS_MASK  0x0010ULL
 
 #define SVM_NESTED_CTL_NP_ENABLE	BIT(0)
+#define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 94dc8ca..67dd610f 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -24,6 +24,7 @@
 #define KVM_FEATURE_STEAL_TIME		5
 #define KVM_FEATURE_PV_EOI		6
 #define KVM_FEATURE_PV_UNHALT		7
+#define KVM_FEATURE_SEV			8
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
