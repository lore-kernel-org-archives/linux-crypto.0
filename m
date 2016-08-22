From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 11/28] x86: Don't decrypt trampoline area if SEV is
 active
Date: Mon, 22 Aug 2016 19:25:51 -0400
Message-ID: <147190835102.9523.9786544054464015663.stgit__42481.2495163225$1471910452$gmane$org@brijesh-build-machine>
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
Received: from mail-by2nam01on0044.outbound.protection.outlook.com ([104.47.34.44]:60832
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755358AbcHVX7w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 19:59:52 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

When Secure Encrypted Virtualization is active instruction fetches are
always interpreted as being from encrypted memory so the trampoline area
must remain encrypted when SEV is active.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/realmode/init.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index c3edb49..f3207e5 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -138,10 +138,13 @@ static void __init set_real_mode_permissions(void)
 	/*
 	 * If memory encryption is active, the trampoline area will need to
 	 * be in non-encrypted memory in order to bring up other processors
-	 * successfully.
+	 * successfully. This only applies to SME, SEV requires the trampoline
+	 * to be encrypted.
 	 */
-	sme_early_mem_dec(__pa(base), size);
-	sme_set_mem_dec(base, size);
+	if (!sev_active) {
+		sme_early_mem_dec(__pa(base), size);
+		sme_set_mem_dec(base, size);
+	}
 
 	set_memory_nx((unsigned long) base, size >> PAGE_SHIFT);
 	set_memory_ro((unsigned long) base, ro_size >> PAGE_SHIFT);
