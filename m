From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 01/32] x86: Add the Secure Encrypted Virtualization
 CPU feature
Date: Thu, 2 Mar 2017 10:12:09 -0500
Message-ID: <148846752953.2349.17505492128445909591.stgit__4069.84168007529$1488470060$gmane$org@brijesh-build-machine>
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
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:3554
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752444AbdCBPwQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 10:52:16 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

Update the CPU features to include identifying and reporting on the
Secure Encrypted Virtualization (SEV) feature.  SME is identified by
CPUID 0x8000001f, but requires BIOS support to enable it (set bit 23 of
MSR_K8_SYSCFG and set bit 0 of MSR_K7_HWCR).  Only show the SEV feature
as available if reported by CPUID and enabled by BIOS.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |    1 +
 arch/x86/include/asm/msr-index.h   |    2 ++
 arch/x86/kernel/cpu/amd.c          |   22 ++++++++++++++++++----
 arch/x86/kernel/cpu/scattered.c    |    1 +
 4 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b1a4468..9907579 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -188,6 +188,7 @@
  */
 
 #define X86_FEATURE_SME		( 7*32+ 0) /* AMD Secure Memory Encryption */
+#define X86_FEATURE_SEV		( 7*32+ 1) /* AMD Secure Encrypted Virtualization */
 #define X86_FEATURE_CPB		( 7*32+ 2) /* AMD Core Performance Boost */
 #define X86_FEATURE_EPB		( 7*32+ 3) /* IA32_ENERGY_PERF_BIAS support */
 #define X86_FEATURE_CAT_L3	( 7*32+ 4) /* Cache Allocation Technology L3 */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index e2d0503..e8b3b28 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -361,6 +361,8 @@
 #define MSR_K7_PERFCTR3			0xc0010007
 #define MSR_K7_CLK_CTL			0xc001001b
 #define MSR_K7_HWCR			0xc0010015
+#define MSR_K7_HWCR_SMMLOCK_BIT		0
+#define MSR_K7_HWCR_SMMLOCK		BIT_ULL(MSR_K7_HWCR_SMMLOCK_BIT)
 #define MSR_K7_FID_VID_CTL		0xc0010041
 #define MSR_K7_FID_VID_STATUS		0xc0010042
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 6bddda3..675958e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -617,10 +617,13 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 		set_cpu_bug(c, X86_BUG_AMD_E400);
 
 	/*
-	 * BIOS support is required for SME. If BIOS has enabld SME then
-	 * adjust x86_phys_bits by the SME physical address space reduction
-	 * value. If BIOS has not enabled SME then don't advertise the
-	 * feature (set in scattered.c).
+	 * BIOS support is required for SME and SEV.
+	 *   For SME: If BIOS has enabled SME then adjust x86_phys_bits by
+	 *	      the SME physical address space reduction value.
+	 *	      If BIOS has not enabled SME then don't advertise the
+	 *	      SME feature (set in scattered.c).
+	 *   For SEV: If BIOS has not enabled SEV then don't advertise the
+	 *            SEV feature (set in scattered.c).
 	 */
 	if (c->extended_cpuid_level >= 0x8000001f) {
 		if (cpu_has(c, X86_FEATURE_SME)) {
@@ -637,6 +640,17 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 				clear_cpu_cap(c, X86_FEATURE_SME);
 			}
 		}
+
+		if (cpu_has(c, X86_FEATURE_SEV)) {
+			u64 syscfg, hwcr;
+
+			/* Check if SEV is enabled */
+			rdmsrl(MSR_K8_SYSCFG, syscfg);
+			rdmsrl(MSR_K7_HWCR, hwcr);
+			if (!(syscfg & MSR_K8_SYSCFG_MEM_ENCRYPT) ||
+			    !(hwcr & MSR_K7_HWCR_SMMLOCK))
+				clear_cpu_cap(c, X86_FEATURE_SEV);
+		}
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index cabda87..c3f58d9 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -31,6 +31,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_SME,		CPUID_EAX,  0, 0x8000001f, 0 },
+	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
