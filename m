From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 13:47:59 -0500
Message-ID: <0012cd4d-d432-ae14-1041-5e8b62973b37@amd.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
        <kvm@vger.kernel.org>, <rkrcmar@redhat.com>,
        <matt@codeblueprint.co.uk>, <linus.walleij@linaro.org>,
        <linux-mm@kvack.org>, <paul.gortmaker@windriver.com>,
        <hpa@zytor.com>, <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <mingo@redhat.com>, <msalter@redhat.com>,
        <ross.zwisler@linux.intel.com>, <dyoung@redhat.com>,
        <jroedel@suse.de>, <keescook@chromium.org>, <toshi.kani@hpe.com>,
        <mathieu.desnoyers@efficios.com>, <devel@linuxdriverproject.org>,
        <tglx@linutronix.de>, <mchehab@kernel.org>,
        <iamjoonsoo.kim@lge.com>, <labbott@fedoraproject.org>,
        <tony.l
To: Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@suse.de>,
        "Brijesh Singh" <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/22/2016 09:45 AM, Paolo Bonzini wrote:
> 
> 
> On 22/09/2016 16:35, Borislav Petkov wrote:
>>>> @@ -230,6 +230,10 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
>>>>  	efi_scratch.efi_pgt = (pgd_t *)__sme_pa(efi_pgd);
>>>>  	pgd = efi_pgd;
>>>>  
>>>> +	flags = _PAGE_NX | _PAGE_RW;
>>>> +	if (sev_active)
>>>> +		flags |= _PAGE_ENC;
>> So this is confusing me. There's this patch which says EFI data is
>> accessed in the clear:
>>
>> https://lkml.kernel.org/r/20160822223738.29880.6909.stgit@tlendack-t1.amdoffice.net
>>
>> but now here it is encrypted when SEV is enabled.
>>
>> Do you mean, it is encrypted here because we're in the guest kernel?
> 
> I suspect this patch is untested, and also wrong. :)

Yes, it is untested but not sure that it is wrong...  It all depends on
how we add SEV support to the guest UEFI BIOS.  My take would be to have
the EFI data and ACPI tables encrypted.

> 
> The main difference between the SME and SEV encryption, from the point
> of view of the kernel, is that real-mode always writes unencrypted in
> SME and always writes encrypted in SEV.  But UEFI can run in 64-bit mode
> and learn about the C bit, so EFI boot data should be unprotected in SEV
> guests.
> 
> Because the firmware volume is written to high memory in encrypted form,
> and because the PEI phase runs in 32-bit mode, the firmware code will be
> encrypted; on the other hand, data that is placed in low memory for the
> kernel can be unencrypted, thus limiting differences between SME and SEV.

I like the idea of limiting the differences but it would leave the EFI
data and ACPI tables exposed and able to be manipulated.

> 
> 	Important: I don't know what you guys are doing for SEV and
> 	Windows guests, but if you are doing something I would really
> 	appreciate doing things in the open.  If Linux and Windows end
> 	up doing different things with EFI boot data, ACPI tables, etc.
> 	it will be a huge pain.  On the other hand, if we can enjoy
> 	being first, that's great.

We haven't discussed Windows guests under SEV yet, but as you say, we
need to do things the same.

Thanks,
Tom

> 
> In fact, I have suggested in the QEMU list that SEV guests should always
> use UEFI; because BIOS runs in real-mode or 32-bit non-paging protected
> mode, BIOS must always write encrypted data, which becomes painful in
> the kernel.
> 
> And regarding the above "important" point, all I know is that Microsoft
> for sure will be happy to restrict SEV to UEFI guests. :)
> 
> There are still some differences, mostly around the real mode trampoline
> executed by the kernel, but they should be much smaller.
> 
> Paolo
> 
