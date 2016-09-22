From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v1 09/28] x86/efi: Access EFI data as encrypted when
 SEV is active
Date: Thu, 22 Sep 2016 19:08:50 +0200
Message-ID: <c1a609f0-307e-9c6c-ce33-b562ca5c0624@redhat.com>
References: <147190820782.9523.4967724730957229273.stgit@brijesh-build-machine>
 <147190832511.9523.10850626471583956499.stgit@brijesh-build-machine>
 <20160922143545.3kl7khff6vqk7b2t@pd.tnic>
 <464461b7-1efb-0af1-dd3e-eb919a2578e9@redhat.com>
 <20160922145947.52v42l7p7dl7u3r4@pd.tnic>
 <938ee0cf-85e6-eefa-7df9-9d5e09ed7a9d@redhat.com>
 <20160922170718.34d4ppockeurrg25@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Brijesh Singh <brijesh.singh@amd.com>, thomas.lendacky@amd.com,
        simon.guinot@sequanux.org, linux-efi@vger.kernel.org,
        kvm@vger.kernel.org, rkrcmar@redhat.com, matt@codeblueprint.co.uk,
        linus.walleij@linaro.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, hpa@zytor.com, dan.j.williams@intel.com,
        aarcange@redhat.com, sfr@canb.auug.org.au,
        andriy.shevchenko@linux.intel.com, herbert@gondor.apana.org.au,
        bhe@redhat.com, xemul@parallels.com, joro@8bytes.org, x86@kernel.org,
        mingo@redhat.com, msalter@redhat.com, ross.zwisler@linux.intel.com,
        dyoung@redhat.com, jroedel@suse.de, keescook@chromium.org,
        toshi.kani@hpe.com, mathieu.desnoyers@efficios.com,
        devel@linuxdriverproject.org, tglx@linutronix.de, mchehab@kernel.org,
        iamjoonsoo.kim@lge.com, labbott@fedoraproject.org, tony.luck@intel.com,
To: Borislav Petkov <bp@suse.de>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160922170718.34d4ppockeurrg25@pd.tnic>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org



On 22/09/2016 19:07, Borislav Petkov wrote:
>> Which paragraph?
> "Linux relies on BIOS to set this bit if BIOS has determined that the
> reduction in the physical address space as a result of enabling memory
> encryption..."
> 
> Basically, you can enable SME in the BIOS and you're all set.

That's not how I read it.  I just figured that the BIOS has some magic
things high in the physical address space and if you reduce the physical
address space the BIOS (which is called from e.g. EFI runtime services)
would have problems with that.

Paolo

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
