From: Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH v2 09/32] x86: Change early_ioremap to early_memremap
 for BOOT data
Date: Wed, 8 Mar 2017 09:46:02 +0100
Message-ID: <20170308084602.z6t44k2izdum3w3v@pd.tnic>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
 <148846763334.2349.9327692408737971533.stgit@brijesh-build-machine>
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
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <148846763334.2349.9327692408737971533.stgit@brijesh-build-machine>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 02, 2017 at 10:13:53AM -0500, Brijesh Singh wrote:
> From: Tom Lendacky <thomas.lendacky@amd.com>
> 
> In order to map BOOT data with the proper encryption bit, the

Btw, what does that all-caps spelling "BOOT" denote? Something I'm
missing?

> early_ioremap() function calls are changed to early_memremap() calls.
> This allows the proper access for both SME and SEV.
> 
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>  arch/x86/kernel/acpi/boot.c |    4 ++--
>  arch/x86/kernel/mpparse.c   |   10 +++++-----
>  drivers/sfi/sfi_core.c      |    6 +++---
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 35174c6..468c25a 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -124,7 +124,7 @@ char *__init __acpi_map_table(unsigned long phys, unsigned long size)
>  	if (!phys || !size)
>  		return NULL;
>  
> -	return early_ioremap(phys, size);
> +	return early_memremap(phys, size);

Right, the question will keep popping up why we can simply replace
memremap with ioremap and the general difference wrt to SME/SEV. So it
would be a good idea to have a comment in, say, arch/x86/mm/ioremap.c,
explaining the general situation.

Thanks.

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
