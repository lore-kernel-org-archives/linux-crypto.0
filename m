From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 04/28] x86: Secure Encrypted Virtualization (SEV)
 support
Date: Mon, 22 Aug 2016 19:24:19 -0400
Message-ID: <147190825949.9523.11406635622434950066.stgit__15258.8529549123$1471909804$gmane$org@brijesh-build-machine>
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
Received: from mail-by2nam03on0054.outbound.protection.outlook.com ([104.47.42.54]:58815
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754177AbcHVXtv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 19:49:51 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

Provide support for Secure Encyrpted Virtualization (SEV). This initial
support defines the SEV active flag in order for the kernel to determine
if it is running with SEV active or not.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h |    3 +++
 arch/x86/kernel/mem_encrypt.S      |    8 ++++++++
 arch/x86/kernel/x8664_ksyms_64.c   |    1 +
 3 files changed, 12 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index e395729..9c592d1 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -20,6 +20,7 @@
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 
 extern unsigned long sme_me_mask;
+extern unsigned int sev_active;
 
 u8 sme_get_me_loss(void);
 
@@ -50,6 +51,8 @@ void swiotlb_set_mem_dec(void *vaddr, unsigned long size);
 
 #define sme_me_mask		0UL
 
+#define sev_active		0
+
 static inline u8 sme_get_me_loss(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/mem_encrypt.S b/arch/x86/kernel/mem_encrypt.S
index bf9f6a9..6a8cd18 100644
--- a/arch/x86/kernel/mem_encrypt.S
+++ b/arch/x86/kernel/mem_encrypt.S
@@ -96,6 +96,10 @@ ENDPROC(sme_enable)
 
 ENTRY(sme_encrypt_kernel)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
+	/* If SEV is active then the kernel is already encrypted */
+	cmpl	$0, sev_active(%rip)
+	jnz	.Lencrypt_exit
+
 	/* If SME is not active then no need to encrypt the kernel */
 	cmpq	$0, sme_me_mask(%rip)
 	jz	.Lencrypt_exit
@@ -334,6 +338,10 @@ sme_me_loss:
 	.byte	0x00
 	.align	8
 
+ENTRY(sev_active)
+	.word	0x00000000
+	.align	8
+
 mem_encrypt_enable_option:
 	.asciz "mem_encrypt=on"
 	.align	8
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 651c4c8..14bfc0b 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -88,4 +88,5 @@ EXPORT_SYMBOL(___preempt_schedule_notrace);
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 EXPORT_SYMBOL_GPL(sme_me_mask);
 EXPORT_SYMBOL_GPL(sme_get_me_loss);
+EXPORT_SYMBOL_GPL(sev_active);
 #endif
