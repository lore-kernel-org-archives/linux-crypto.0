From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 13:59:35 -0500
Message-ID: <23fcb1d7-e9f8-26b8-bfb7-b2d525e49bae@amd.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
 <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Brijesh Singh <brijesh.singh@amd.com>, <simon.guinot@sequanux.org>,
        <linux-efi@vger.kernel.org>, <kvm@vger.kernel.org>,
        <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
        <linus.walleij@linaro.org>, <linux-mm@kvack.org>,
        <paul.gortmaker@windriver.com>, <hpa@zytor.com>,
        <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <mingo@redhat.com>, <msalter@redhat.com>,
        <ross.zwisler@linux.intel.com>, <dyoung@redhat.com>,
        <jroedel@suse.de>, <keescook@chromium.org>, <toshi.kani@hpe.com>,
        <mathieu.desnoyers@efficios.com>, <devel@linuxdriverproject.org>,
        <tglx@linutronix.de>, <mchehab@kernel.org>,
        <iamjoonsoo.kim@lge.com
To: Borislav Petkov <bp@suse.de>, Paolo Bonzini <pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/22/2016 09:59 AM, Borislav Petkov wrote:
> On Thu, Sep 22, 2016 at 04:45:51PM +0200, Paolo Bonzini wrote:
>> The main difference between the SME and SEV encryption, from the point
>> of view of the kernel, is that real-mode always writes unencrypted in
>> SME and always writes encrypted in SEV.  But UEFI can run in 64-bit mode
>> and learn about the C bit, so EFI boot data should be unprotected in SEV
>> guests.
> 
> Actually, it is different: you can start fully encrypted in SME, see:
> 
> https://lkml.kernel.org/r/20160822223539.29880.96739.stgit@tlendack-t1.amdoffice.net
> 
> The last paragraph alludes to a certain transparent mode where you're
> already encrypted and only certain pieces like EFI is not encrypted. I
> think the aim is to have the transparent mode be the default one, which
> makes most sense anyway.

There is a new Transparent SME mode that is now part of the overall
SME support, but I'm not alluding to that in the documentation at all.
In TSME mode, everything that goes through the memory controller would
be encrypted and that would include EFI data, etc.  TSME would be
enabled through a BIOS option, thus allowing legacy OSes to benefit.

> 
> The EFI regions are unencrypted for obvious reasons and you need to
> access them as such.
> 
>> Because the firmware volume is written to high memory in encrypted
>> form, and because the PEI phase runs in 32-bit mode, the firmware
>> code will be encrypted; on the other hand, data that is placed in low
>> memory for the kernel can be unencrypted, thus limiting differences
>> between SME and SEV.
> 
> When you run fully encrypted, you still need to access EFI tables in the
> clear. That's why I'm confused about this patch here.

This patch assumes that the EFI regions of a guest would be encrypted.

Thanks,
Tom

> 
