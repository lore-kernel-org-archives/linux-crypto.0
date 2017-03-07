From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v2 07/32] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Tue, 7 Mar 2017 12:57:30 +0100
Message-ID: <20170307115730.rmsmluv42m5xnylf@pd.tnic>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846760142.2349.8522516472305792434.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
	kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
	linux-pci@vger.kernel.org, linus.walleij@linaro.org,
	gary.hook@amd.com, linux-mm@kvack.org, paul.gortmaker@windriver.com,
	hpa@zytor.com, cl@linux.com, dan.j.williams@intel.com,
	aarcange@redhat.com, sfr@canb.auug.org.au,
	andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au,
	bhe@redhat.com, xemul@parallels.com, joro@8bytes.org,
	x86@kernel.org, peterz@infradead.org, piotr.luc@intel.com,
	mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com,
	dyoung@redhat.com, thomas.lendacky@amd.com, jroedel@suse.de,
	keescook@chromium.org, arnd@arndb.de, toshi.kani@hpe.com,
	mathieu.desnoyers@efficios.com, luto@kernel.org,
	devel@linuxdriverproject.org, bhelgaas@google.com,
	tglx@linutronix.de, mchehab@kernel.org, iamjoonsoo.kim@lge.com,
	labbott@fedo
To: Brijesh Singh <brijesh.singh@amd.com>,
	Matt Fleming <matt@codeblueprint.co.uk>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <148846760142.2349.8522516472305792434.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 02, 2017 at 10:13:21AM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> EFI data is encrypted when the kernel is run under SEV. Update the
> page table references to be sure the EFI memory areas are accessed
> encrypted.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

This SOB chain looks good.

> ---
>  arch/x86/platform/efi/efi_64.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 2d8674d..9a76ed8 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -45,6 +45,7 @@
>  #include <asm/realmode.h>
>  #include <asm/time.h>
>  #include <asm/pgalloc.h>
> +#include <asm/mem_encrypt.h>
>  
>  /*
>   * We allocate runtime services regions bottom-up, starting from -4G, i.e.
> @@ -286,7 +287,10 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>  	 * as trim_bios_range() will reserve the first page and isolate it away
>  	 * from memory allocators anyway.
>  	 */
> -	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, _PAGE_RW)) {
> +	pf = _PAGE_RW;
> +	if (sev_active())
> +		pf |= _PAGE_ENC;
> +	if (kernel_map_pages_in_pgd(pgd, 0x0, 0x0, 1, pf)) {
>  		pr_err("Failed to create 1:1 mapping for the first page!\n");
>  		return 1;
>  	}
> @@ -329,6 +333,9 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
>  	if (!(md->attribute & EFI_MEMORY_WB))
>  		flags |= _PAGE_PCD;
>  
> +	if (sev_active())
> +		flags |= _PAGE_ENC;
> +

So I'm wondering if we could avoid this sprinkling of _PAGE_ENC in the
EFI code by defining something like __supported_pte_mask but called
__efi_base_page_flags or so which has _PAGE_ENC cleared in the SME case,
i.e., when baremetal and has it set in the SEV case.

Then we could simply OR in __efi_base_page_flags which the SME/SEV code
will set appropriately early enough.

Hmm.

Matt, what do you think?

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
