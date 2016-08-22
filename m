From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 14/28] x86: Don't set the SME MSR bit when SEV is
 active
Date: Mon, 22 Aug 2016 19:26:28 -0400
Message-ID: <147190838870.9523.7536164067495140361.stgit__24029.4303432622$1471910389$gmane$org@brijesh-build-machine>
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
Received: from mail-cys01nam02on0046.outbound.protection.outlook.com ([104.47.37.46]:37218
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932424AbcHVX7K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 19:59:10 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

When SEV is active the virtual machine cannot set the MSR for SME, so
don't set the trampoline flag for SME.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/realmode/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index f3207e5..391d8ba 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -102,7 +102,7 @@ static void __init setup_real_mode(void)
 	*trampoline_cr4_features = mmu_cr4_features;
 
 	trampoline_header->flags = 0;
-	if (sme_me_mask)
+	if (sme_me_mask && !sev_active)
 		trampoline_header->flags |= TH_FLAGS_SME_ENABLE;
 
 	trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
