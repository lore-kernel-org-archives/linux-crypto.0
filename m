From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 05/32] x86: Use encrypted access of BOOT related data
 with SEV
Date: Thu, 2 Mar 2017 10:12:59 -0500
Message-ID: <148846757895.2349.561582698953591240.stgit__8003.95572227917$1488469090$gmane$org@brijesh-build-machine>
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
Received: from mail-sn1nam01on0055.outbound.protection.outlook.com ([104.47.32.55]:54286
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753236AbdCBPfA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 10:35:00 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tom Lendacky <thomas.lendacky@amd.com>

When Secure Encrypted Virtualization (SEV) is active, BOOT data (such as
EFI related data, setup data) is encrypted and needs to be accessed as
such when mapped. Update the architecture override in early_memremap to
keep the encryption attribute when mapping this data.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/ioremap.c |   36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index c6cb921..c400ab5 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -462,12 +462,31 @@ static bool memremap_is_setup_data(resource_size_t phys_addr,
 }
 
 /*
- * This function determines if an address should be mapped encrypted.
- * Boot setup data, EFI data and E820 areas are checked in making this
- * determination.
+ * This function determines if an address should be mapped encrypted when
+ * SEV is active.  E820 areas are checked in making this determination.
  */
-static bool memremap_should_map_encrypted(resource_size_t phys_addr,
-					  unsigned long size)
+static bool memremap_sev_should_map_encrypted(resource_size_t phys_addr,
+					      unsigned long size)
+{
+	/* Check if the address is in persistent memory */
+	switch (e820__get_entry_type(phys_addr, phys_addr + size - 1)) {
+	case E820_TYPE_PMEM:
+	case E820_TYPE_PRAM:
+		return false;
+	default:
+		break;
+	}
+
+	return true;
+}
+
+/*
+ * This function determines if an address should be mapped encrypted when
+ * SME is active.  Boot setup data, EFI data and E820 areas are checked in
+ * making this determination.
+ */
+static bool memremap_sme_should_map_encrypted(resource_size_t phys_addr,
+					      unsigned long size)
 {
 	/*
 	 * SME is not active, return true:
@@ -508,6 +527,13 @@ static bool memremap_should_map_encrypted(resource_size_t phys_addr,
 	return true;
 }
 
+static bool memremap_should_map_encrypted(resource_size_t phys_addr,
+					  unsigned long size)
+{
+	return sev_active() ? memremap_sev_should_map_encrypted(phys_addr, size)
+			    : memremap_sme_should_map_encrypted(phys_addr, size);
+}
+
 /*
  * Architecure function to determine if RAM remap is allowed.
  */
