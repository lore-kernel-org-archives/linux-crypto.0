From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 07/32] x86/efi: Access EFI data as encrypted when SEV
 is active
Date: Thu, 2 Mar 2017 10:13:21 -0500
Message-ID: <148846760142.2349.8522516472305792434.stgit__12218.2652623907$1488468668$gmane$org@brijesh-build-machine>
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
Received: from mail-sn1nam02on0088.outbound.protection.outlook.com ([104.47.36.88]:53145
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753304AbdCBPaA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 10:30:00 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

EFI data is encrypted when the kernel is run under SEV. Update the
page table references to be sure the EFI memory areas are accessed
encrypted.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/platform/efi/efi_64.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 2d8674d..9a76ed8 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -45,6 +45,7 @@
 #include <asm/realmode.h>
 #include <asm/time.h>
 #include <asm/pgalloc.h>
+#include <asm/mem_encrypt.h>
 
 /*
  * We allocate runtime services regions bottom-up, starting from -4G, i.e.
@@ -286,7 +287,10 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	 * as trim_bios_range() will reserve the first page and isolate it away
 	 * from memory allocators anyway.
 	 */
-	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
+	pf = _PAGE_RW;
+	if (sev_active())
+		pf |= _PAGE_ENC;
+	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, pf)) {
 		pr_err("Failed to create 1:1 mapping for the first page!\n");
 		return 1;
 	}
@@ -329,6 +333,9 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 	if (!(md->attribute & EFI_MEMORY_WB))
 		flags |= _PAGE_PCD;
 
+	if (sev_active())
+		flags |= _PAGE_ENC;
+
 	pfn = md->phys_addr >> PAGE_SHIFT;
 	if (kernel_map_pages_in_pgd(pgd, pfn, va, md->num_pages, flags))
 		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
@@ -455,6 +462,9 @@ static int __init efi_update_mem_attr(struct mm_struct *mm, efi_memory_desc_t *m
 	if (!(md->attribute & EFI_MEMORY_RO))
 		pf |= _PAGE_RW;
 
+	if (sev_active())
+		pf |= _PAGE_ENC;
+
 	return efi_update_mappings(md, pf);
 }
 
@@ -506,6 +516,9 @@ void __init efi_runtime_update_mappings(void)
 			(md->type != EFI_RUNTIME_SERVICES_CODE))
 			pf |= _PAGE_RW;
 
+		if (sev_active())
+			pf |= _PAGE_ENC;
+
 		efi_update_mappings(md, pf);
 	}
 }
