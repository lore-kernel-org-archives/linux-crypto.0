From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v1 08/28] Access BOOT related data encrypted with SEV
 active
Date: Mon, 22 Aug 2016 19:25:14 -0400
Message-ID: <147190831414.9523.1885664762210149209.stgit__14816.0457298674$1471910356$gmane$org@brijesh-build-machine>
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
        id S1756228AbcHVX6Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Aug 2016 19:58:24 -0400
In-Reply-To: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

When Secure Encrypted Virtualization (SEV) is active, BOOT data (such as
EFI related data) is encrypted and needs to be access as such. Update the
architecture override in early_memremap to keep the encryption attribute
when mapping this data.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/ioremap.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index e3bdc5a..2ea6deb 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -429,10 +429,11 @@ pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
 					     pgprot_t prot)
 {
 	/*
-	 * If memory encryption is enabled and BOOT_DATA is being mapped
-	 * then remove the encryption bit.
+	 * If memory encryption is enabled, we are not running with
+	 * SEV active and BOOT_DATA is being mapped then remove the
+	 * encryption bit
 	 */
-	if (_PAGE_ENC && (owner == BOOT_DATA))
+	if (_PAGE_ENC && !sev_active && (owner == BOOT_DATA))
 		prot = __pgprot(pgprot_val(prot) & ~_PAGE_ENC);
 
 	return prot;
