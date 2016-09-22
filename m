From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 12:46:59 -0500
Message-ID: <443d06f5-2db5-5107-296f-94fabd209407@amd.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
	<linus.walleij@linaro.org>, <linux-mm@kvack.org>,
	<paul.gortmaker@windriver.com>, <hpa@zytor.com>, <dan.j.williams@intel.com>,
	<aarcange@redhat.com>, <sfr@canb.auug.org.au>,
	<andriy.shevchenko@linux.intel.com>, <herbert@gondor.apana.org.au>,
	<bhe@redhat.com>, <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
	<mingo@redhat.com>, <msalter@redhat.com>, <ross.zwisler@linux.intel.com>,
	<dyoung@redhat.com>, <jroedel@suse.de>, <keescook@chromium.org>,
	<toshi.kani@hpe.com>, <mathieu.desnoyers@efficios.com>,
	<devel@linuxdriverproject.org>, <tglx@linutronix.de>, <mchehab@kernel.org>,
	<iamjoonsoo.kim@lge.com>, <labbott@fedoraproject.org>, <tony.luck@intel.com>,
	<alexandre.bounine@idt.com>, <kuleshovmail@gmail.com>,
	<linux-kernel@vger.kernel.or
To: Borislav Petkov <bp@suse.de>, Brijesh Singh <brijesh.singh@amd.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On 09/22/2016 09:35 AM, Borislav Petkov wrote:
> On Mon, Aug 22, 2016 at 07:25:25PM -0400, Brijesh Singh wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> EFI data is encrypted when the kernel is run under SEV. Update the
>> page table references to be sure the EFI memory areas are accessed
>> encrypted.
>>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/platform/efi/efi_64.c |   14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
>> index 0871ea4..98363f3 100644
>> --- a/arch/x86/platform/efi/efi_64.c
>> +++ b/arch/x86/platform/efi/efi_64.c
>> @@ -213,7 +213,7 @@ void efi_sync_low_kernel_mappings(void)
>>  
>>  int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>>  {
>> -	unsigned long pfn, text;
>> +	unsigned long pfn, text, flags;
>>  	efi_memory_desc_t *md;
>>  	struct page *page;
>>  	unsigned npages;
>> @@ -230,6 +230,10 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>>  	efi_scratch.efi_pgt = (pgd_t *)__sme_pa(efi_pgd);
>>  	pgd = efi_pgd;
>>  
>> +	flags = _PAGE_NX | _PAGE_RW;
>> +	if (sev_active)
>> +		flags |= _PAGE_ENC;
> 
> So this is confusing me. There's this patch which says EFI data is
> accessed in the clear:
> 
> https://lkml.kernel.org/r/20160822223738.29880.6909.stgit@tlendack-t1.amdoffice.net
> 
> but now here it is encrypted when SEV is enabled.
> 
> Do you mean, it is encrypted here because we're in the guest kernel?

Yes, the idea is that the SEV guest will be running encrypted from the
start, including the BIOS/UEFI, and so all of the EFI related data will
be encrypted.

Thanks,
Tom

> 
> Thanks.
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
