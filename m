From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 15/32] x86: Add support for changing memory
 encryption attribute in early boot
Date: Thu, 2 Mar 2017 10:15:28 -0500
Message-ID: <148846772794.2349.1396854638510933455.stgit__5706.98869782991$1488477557$gmane$org@brijesh-build-machine>
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
Received: from mail-sn1nam01on0084.outbound.protection.outlook.com ([104.47.32.84]:65264
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752680AbdCBRz2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 12:55:28 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Some KVM-specific custom MSRs shares the guest physical address with
hypervisor. When SEV is active, the shared physical address must be mapped
with encryption attribute cleared so that both hypervsior and guest can
access the data.

Add APIs to change memory encryption attribute in early boot code.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/mem_encrypt.h |   15 +++++++++
 arch/x86/mm/mem_encrypt.c          |   63 ++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
index 9799835..95bbe4c 100644
--- a/arch/x86/include/asm/mem_encrypt.h
+++ b/arch/x86/include/asm/mem_encrypt.h
@@ -47,6 +47,9 @@ void __init sme_unmap_bootdata(char *real_mode_data);
 
 void __init sme_early_init(void);
 
+int __init early_set_memory_decrypted(void *addr, unsigned long size);
+int __init early_set_memory_encrypted(void *addr, unsigned long size);
+
 /* Architecture __weak replacement functions */
 void __init mem_encrypt_init(void);
 
@@ -110,6 +113,18 @@ static inline void __init sme_early_init(void)
 {
 }
 
+static inline int __init early_set_memory_decrypted(void *addr,
+						    unsigned long size)
+{
+	return 1;
+}
+
+static inline int __init early_set_memory_encrypted(void *addr,
+						    unsigned long size)
+{
+	return 1;
+}
+
 #define __sme_pa		__pa
 #define __sme_pa_nodebug	__pa_nodebug
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 7df5f4c..567e0d8 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/dma-mapping.h>
 #include <linux/swiotlb.h>
+#include <linux/mem_encrypt.h>
 
 #include <asm/tlbflush.h>
 #include <asm/fixmap.h>
@@ -258,6 +259,68 @@ static void sme_free(struct device *dev, size_t size, void *vaddr,
 	swiotlb_free_coherent(dev, size, vaddr, dma_handle);
 }
 
+static unsigned long __init get_pte_flags(unsigned long address)
+{
+	int level;
+	pte_t *pte;
+	unsigned long flags = _KERNPG_TABLE_NOENC | _PAGE_ENC;
+
+	pte = lookup_address(address, &level);
+	if (!pte)
+		return flags;
+
+	switch (level) {
+	case PG_LEVEL_4K:
+		flags = pte_flags(*pte);
+		break;
+	case PG_LEVEL_2M:
+		flags = pmd_flags(*(pmd_t *)pte);
+		break;
+	case PG_LEVEL_1G:
+		flags = pud_flags(*(pud_t *)pte);
+		break;
+	default:
+		break;
+	}
+
+	return flags;
+}
+
+int __init early_set_memory_enc_dec(void *vaddr, unsigned long size,
+				    unsigned long flags)
+{
+	unsigned long pfn, npages;
+	unsigned long addr = (unsigned long)vaddr & PAGE_MASK;
+
+	/* We are going to change the physical page attribute from C=1 to C=0.
+	 * Flush the caches to ensure that all the data with C=1 is flushed to
+	 * memory. Any caching of the vaddr after function returns will
+	 * use C=0.
+	 */
+	clflush_cache_range(vaddr, size);
+
+	npages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	pfn = slow_virt_to_phys((void *)addr) >> PAGE_SHIFT;
+
+	return kernel_map_pages_in_pgd(init_mm.pgd, pfn, addr, npages,
+					flags & ~sme_me_mask);
+
+}
+
+int __init early_set_memory_decrypted(void *vaddr, unsigned long size)
+{
+	unsigned long flags = get_pte_flags((unsigned long)vaddr);
+
+	return early_set_memory_enc_dec(vaddr, size, flags & ~sme_me_mask);
+}
+
+int __init early_set_memory_encrypted(void *vaddr, unsigned long size)
+{
+	unsigned long flags = get_pte_flags((unsigned long)vaddr);
+
+	return early_set_memory_enc_dec(vaddr, size, flags | _PAGE_ENC);
+}
+
 static struct dma_map_ops sme_dma_ops = {
 	.alloc                  = sme_alloc,
 	.free                   = sme_free,
